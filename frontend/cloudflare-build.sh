#!/usr/bin/env bash
# Compila Flutter Web en Cloudflare Workers Builds (Root directory = frontend).
# Variables de build requeridas (publicas, nunca secretos): URL_API y GOOGLE_CLIENT_ID.
set -euo pipefail

VERSION_FLUTTER="3.47.1"

if [[ -z "${URL_API:-}" || -z "${GOOGLE_CLIENT_ID:-}" ]]; then
  echo "Faltan variables de build: URL_API y GOOGLE_CLIENT_ID." >&2
  exit 1
fi
if [[ "${URL_API}" != https://* ]]; then
  echo "URL_API debe empezar por https://" >&2
  exit 1
fi

if [[ ! -x "${HOME}/flutter/bin/flutter" ]]; then
  git clone --depth 1 --branch "${VERSION_FLUTTER}" https://github.com/flutter/flutter.git "${HOME}/flutter"
fi
export PATH="${HOME}/flutter/bin:${PATH}"

flutter config --no-analytics
flutter --version
flutter pub get
flutter build web --release \
  --dart-define=URL_API="${URL_API}" \
  --dart-define=GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID}"

test -f build/web/index.html
