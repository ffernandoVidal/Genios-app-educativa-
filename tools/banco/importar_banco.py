"""Importador del banco educativo GENIOS (370 preguntas) para desarrollo.

Uso (desde la raíz del repositorio):
  python tools/banco/importar_banco.py --dry-run
      Valida el banco, compara con Neon (SOLO LECTURA) y escribe el informe. No modifica nada.
  python tools/banco/importar_banco.py --generar-sql database/migraciones/003_banco_370.sql
      Además genera el SQL idempotente. El script NUNCA escribe en la base: el SQL se revisa y se aplica aparte.

Reglas:
  - Fuente única: data/educational/preguntas_genios_consolidado_370.json (los otros dos archivos son referencia).
  - Se conservan los IDs originales de preguntas (preguntas.codigo) y de opciones (opciones_pregunta.codigo_opcion).
  - No se inventa ni se corrige ninguna pregunta: lo dudoso se informa, no se cambia.
  - Mapeo propuesto (requiere aprobación humana): asignatura -> «Nivel 1» -> categoría (una por category_code).
    El orden de las categorías es el de subjects[].categories del archivo.
"""
import argparse
import json
import os
import re
import subprocess
import sys
from collections import Counter, defaultdict
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
BANCO = RAIZ / "data" / "educational" / "preguntas_genios_consolidado_370.json"
INFORME = RAIZ / "data" / "educational" / "informe_importacion.json"
FUENTE = "GENIOS_BANCO_370_V1"

# Nombre del banco -> código de asignatura en la base.
ASIGNATURAS = {
    "Matemáticas": "MATEMATICAS",
    "Comunicación y Lenguaje": "LENGUAJE",
    "Ciencias Naturales": "CIENCIAS_NATURALES",
    "Ciencias Sociales": "CIENCIAS_SOCIALES",
}
DIFICULTAD = {"BASICO": "basica", "INTERMEDIO": "intermedia", "AVANZADO": "avanzada"}
ARITMETICA = re.compile(r"¿Cuánto es (\d+) ([×x+−\-÷]) (\d+)\?")


def cargar():
    return json.loads(BANCO.read_text(encoding="utf-8"))


def validar(banco):
    """Validación estructural (6.1) y comprobaciones automáticas de exactitud. Devuelve (errores, avisos)."""
    errores, avisos = [], []
    preguntas = banco["questions"]
    categorias_declaradas = {c["code"] for s in banco["subjects"] for c in s["categories"]}

    ids = Counter(q["id"] for q in preguntas)
    for i, n in ids.items():
        if n > 1:
            errores.append(f"{i}: ID repetido")

    for q in preguntas:
        i = q["id"]
        if q["subject"] not in ASIGNATURAS:
            errores.append(f"{i}: materia desconocida {q['subject']!r}")
        if q["category_code"] not in categorias_declaradas:
            errores.append(f"{i}: categoría no declarada {q['category_code']}")
        if not q["question"].strip():
            errores.append(f"{i}: enunciado vacío")
        if not q.get("explanation", "").strip():
            errores.append(f"{i}: explicación vacía")
        if q["difficulty"] not in DIFICULTAD:
            errores.append(f"{i}: dificultad inválida {q['difficulty']}")
        if q["grade"] not in range(1, 7):
            errores.append(f"{i}: grado inválido {q['grade']}")
        if q["type"] != "SINGLE_CHOICE":
            errores.append(f"{i}: tipo no soportado {q['type']}")

        opciones = q["options"]
        textos = [o["text"].strip().lower() for o in opciones]
        if len(opciones) != 4:
            errores.append(f"{i}: {len(opciones)} opciones (se esperaban 4)")
        if len(set(textos)) != len(textos):
            errores.append(f"{i}: opciones repetidas")
        correctas = [o for o in opciones if o["is_correct"]]
        if len(correctas) != 1:
            errores.append(f"{i}: {len(correctas)} opciones correctas")
        elif correctas[0]["text"] != q["correct_answer"]:
            errores.append(f"{i}: correct_answer no coincide con la opción correcta")
        for o in opciones:
            if len(o["id"]) > 30:
                errores.append(f"{i}: id de opción demasiado largo ({o['id']})")
        if len(i) > 100:
            errores.append(f"{i}: id de pregunta demasiado largo")

        # Exactitud automática solo donde es posible: aritmética directa.
        m = ARITMETICA.fullmatch(q["question"].strip())
        if m and correctas:
            a, op, b = int(m.group(1)), m.group(2), int(m.group(3))
            esperado = {"×": a * b, "x": a * b, "+": a + b, "−": a - b, "-": a - b}.get(op)
            if op == "÷":
                esperado = a / b if b and a % b == 0 else None
            if esperado is not None and str(int(esperado)) != correctas[0]["text"].strip():
                errores.append(f"{i}: la aritmética no coincide ({q['question']} = {esperado}, clave {correctas[0]['text']})")

    # Duplicados semánticos relevantes: mismo enunciado y mismas opciones/clave => revisar.
    por_enunciado = defaultdict(list)
    for q in preguntas:
        por_enunciado[q["question"].strip().lower()].append(q)
    for texto, grupo in por_enunciado.items():
        if len(grupo) > 1:
            detalle = ", ".join(f"{g['id']} (clave: {g['correct_answer']})" for g in grupo)
            avisos.append(f"Enunciado repetido: {texto!r} -> {detalle}")

    # Cobertura: cada categoría debe poder armar una partida de 10 preguntas distintas.
    por_categoria = Counter(q["category_code"] for q in preguntas)
    for c in sorted(categorias_declaradas):
        if por_categoria[c] < 10:
            errores.append(f"{c}: solo {por_categoria[c]} preguntas (se necesitan 10)")
        elif por_categoria[c] == 10:
            avisos.append(f"{c}: exactamente 10 preguntas, sin margen para variar entre partidas")
    return errores, avisos


def sql_texto(valor):
    return "'" + str(valor).replace("'", "''") + "'"


def generar_sql(banco):
    s = []
    s.append(f"""-- ============================================================================
-- GENIOS - Banco educativo V1 (370 preguntas) - GENERADO por tools/banco/importar_banco.py
-- Fuente: data/educational/preguntas_genios_consolidado_370.json
--
-- SOLO DATOS: no cambia el esquema. Idempotente: cada fila se protege con su clave natural
-- (ON CONFLICT DO NOTHING / NOT EXISTS). Se puede ejecutar varias veces; la segunda vez no cambia nada.
-- No modifica ni borra filas existentes ni respuestas históricas.
--
-- ESTADO PEDAGÓGICO: preguntas con fuente = '{FUENTE}', PENDIENTES de revisión curricular (CNB Guatemala).
-- Mapeo (propuesto, requiere aprobación): asignatura -> «Nivel 1» -> categoría (una por category_code).
--
-- Reversión (solo si no hay partidas sobre estas categorías):
--   DELETE FROM claves_respuesta WHERE pregunta_id IN (SELECT id FROM preguntas WHERE fuente = '{FUENTE}');
--   DELETE FROM opciones_pregunta WHERE pregunta_id IN (SELECT id FROM preguntas WHERE fuente = '{FUENTE}');
--   DELETE FROM preguntas WHERE fuente = '{FUENTE}';
--   DELETE FROM categorias WHERE codigo IN (<códigos MAT-/LEN-/NAT-/SOC- del banco>) AND id NOT IN (SELECT categoria_id FROM preguntas);
-- ============================================================================
BEGIN;
""")
    for subj in banco["subjects"]:
        codigo = ASIGNATURAS[subj["name"]]
        s.append(f"-- {subj['name']}")
        s.append(
            "INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)\n"
            f"SELECT id, 'Nivel 1', 1 FROM asignaturas WHERE codigo = {sql_texto(codigo)}\n"
            "ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;"
        )
        for orden, cat in enumerate(subj["categories"], 1):
            descripcion = f"Grado {cat['grade']}" + (f" · misión {cat['mission']} del banco" if cat.get("mission") else "")
            s.append(
                "INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)\n"
                f"SELECT n.id, {sql_texto(cat['code'])}, {sql_texto(cat['title'])}, {sql_texto(descripcion)}, {orden}, TRUE\n"
                "FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id\n"
                f"WHERE a.codigo = {sql_texto(codigo)} AND n.numero_orden = 1\n"
                "ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;"
            )
    s.append("")
    for q in banco["questions"]:
        cat = sql_texto(q["category_code"])
        cod = sql_texto(q["id"])
        s.append(f"-- {q['id']}")
        s.append(
            "INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)\n"
            f"SELECT c.id, {cod}, 'opcion_multiple', {sql_texto(q['question'])}, {sql_texto(q['explanation'])}, "
            f"{sql_texto(DIFICULTAD[q['difficulty']])}, {sql_texto(FUENTE)}\n"
            f"FROM categorias c WHERE c.codigo = {cat}\n"
            f"AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = {cod});"
        )
        for orden, o in enumerate(q["options"], 1):
            s.append(
                "INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)\n"
                f"SELECT p.id, {sql_texto(o['id'])}, {sql_texto(o['text'])}, {orden}\n"
                f"FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = {cat} AND p.codigo = {cod}\n"
                "ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;"
            )
        correcta = next(o for o in q["options"] if o["is_correct"])
        s.append(
            "INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)\n"
            f"SELECT p.id, jsonb_build_object('opcionId', o.id), {sql_texto(q['explanation'])}\n"
            "FROM preguntas p JOIN categorias c ON c.id = p.categoria_id\n"
            f"JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = {sql_texto(correcta['id'])}\n"
            f"WHERE c.codigo = {cat} AND p.codigo = {cod}\n"
            "ON CONFLICT (pregunta_id) DO NOTHING;"
        )
    s.append("\nCOMMIT;\n")
    return "\n".join(s)


def leer_env():
    env = dict(os.environ)
    for linea in (RAIZ / ".env").read_text(encoding="utf-8").splitlines():
        if linea.strip() and not linea.startswith("#") and "=" in linea:
            k, v = linea.split("=", 1)
            env.setdefault(k.strip(), v.strip())
    return env


def consultar(sql):
    """Solo lectura contra Neon con psql. Devuelve filas como listas de texto."""
    env = leer_env()
    env.update(PGSSLMODE="verify-full", PGSSLROOTCERT=str(RAIZ / "certs" / "isrg-root-x1.pem"), PGPASSWORD=env["NEON_PASSWORD"])
    r = subprocess.run(
        ["psql", "-h", env["NEON_HOST"], "-U", env["NEON_USER"], "-d", env["NEON_DB"], "-t", "-A", "-F", "|", "-c", sql],
        env=env, capture_output=True, text=True, encoding="utf-8",
    )
    if r.returncode != 0:
        raise RuntimeError(r.stderr.strip())
    return [fila.split("|") for fila in r.stdout.strip().splitlines() if fila]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="Valida y compara con Neon en solo lectura.")
    ap.add_argument("--generar-sql", metavar="RUTA", help="Escribe el SQL idempotente (no lo aplica).")
    args = ap.parse_args()
    if not args.dry_run and not args.generar_sql:
        ap.error("indica --dry-run y/o --generar-sql")

    banco = cargar()
    errores, avisos = validar(banco)
    qs = banco["questions"]

    informe = {
        "archivo": BANCO.name,
        "preguntas": len(qs),
        "categorias": len({q["category_code"] for q in qs}),
        "por_materia": dict(Counter(q["subject"] for q in qs)),
        "por_dificultad": dict(Counter(q["difficulty"] for q in qs)),
        "por_grado": {str(k): v for k, v in sorted(Counter(q["grade"] for q in qs).items())},
        "puntos_del_banco_ignorados": sorted({q["points"] for q in qs}),
        "rechazadas": len(errores),
        "errores": errores,
        "avisos_de_revision": avisos,
        "pistas": "El banco no trae pistas (hint); no se importa ninguna.",
        "estado_pedagogico": "TODAS pendientes de revisión curricular (CNB Guatemala).",
    }

    if args.dry_run:
        codigos = [q["id"] for q in qs]
        existentes = consultar("select codigo from preguntas where fuente = '" + FUENTE + "'")
        ya = {f[0] for f in existentes}
        cats = {f[0] for f in consultar("select codigo from categorias")}
        informe["comparacion_con_neon"] = {
            "preguntas_nuevas": sum(1 for c in codigos if c not in ya),
            "preguntas_ya_importadas": sum(1 for c in codigos if c in ya),
            "categorias_nuevas": len({q["category_code"] for q in qs} - cats),
            "categorias_existentes": len({q["category_code"] for q in qs} & cats),
            "actualizaciones": 0,
        }

    INFORME.write_text(json.dumps(informe, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({k: v for k, v in informe.items() if k not in ("errores", "avisos_de_revision")}, ensure_ascii=False, indent=2))
    print(f"\nErrores: {len(errores)} | Avisos de revisión: {len(avisos)} -> {INFORME.relative_to(RAIZ)}")
    for e in errores[:20]:
        print("  ERROR:", e)

    if args.generar_sql:
        if errores:
            sys.exit("No se genera el SQL: hay preguntas rechazadas.")
        destino = Path(args.generar_sql)
        destino.write_text(generar_sql(banco), encoding="utf-8")
        print(f"SQL generado: {destino} ({destino.stat().st_size // 1024} KB). NO se ha aplicado.")


if __name__ == "__main__":
    main()
