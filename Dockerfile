# Usar la imagen oficial de .NET SDK para compilar y publicar
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copiar los archivos del proyecto y restaurar las dependencias
COPY . ./
RUN dotnet restore

# Compilar y publicar la aplicación
RUN dotnet publish -c Release -o out

# Usar una imagen más ligera para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Exponer el puerto 80 para la API
EXPOSE 80

# Comando de inicio
ENTRYPOINT ["dotnet", "MyApiConsumer.dll"]
