# Dockerfile para MyApiConsumer

# Utiliza una imagen base de .NET para compilar y publicar la API en C#
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copia los archivos de proyecto y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia el resto de los archivos y compila el proyecto
COPY . ./
RUN dotnet publish -c Release -o out

# Genera la imagen final que ejecutará la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expone el puerto en el que correrá la API
EXPOSE 80
ENTRYPOINT ["dotnet", "MyApiConsumer.dll"]

# Configuración para Prometheus
FROM prom/prometheus AS prometheus
WORKDIR /etc/prometheus

# Copia el archivo de configuración de Prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml

CMD ["/bin/prometheus", "--config.file=/etc/prometheus/prometheus.yml"]
