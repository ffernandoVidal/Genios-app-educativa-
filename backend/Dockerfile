
# Etapa 1: Compilacion .NET 10
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY src/GENIOS.Domain/GENIOS.Domain.csproj src/GENIOS.Domain/
COPY src/GENIOS.Application/GENIOS.Application.csproj src/GENIOS.Application/
COPY src/GENIOS.Infrastructure/GENIOS.Infrastructure.csproj src/GENIOS.Infrastructure/
COPY src/GENIOS.Api/GENIOS.Api.csproj src/GENIOS.Api/

RUN dotnet restore src/GENIOS.Api/GENIOS.Api.csproj

COPY src/ src/

RUN dotnet publish src/GENIOS.Api/GENIOS.Api.csproj \
    -c Release \
    -o /app/publish \
    --no-restore

# Etapa 2: Ejecucion
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:10000

EXPOSE 10000

USER app

ENTRYPOINT ["dotnet", "GENIOS.Api.dll"]
