# Construir la aplicación C#
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o /app

# Imagen final para la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "MyApiConsumer.dll"]

# Configuración de Prometheus
FROM prom/prometheus AS prometheus
WORKDIR /etc/prometheus
COPY prometheus.yml .

CMD ["/etc/prometheus/prometheus", "--config.file=/etc/prometheus/prometheus.yml"]
