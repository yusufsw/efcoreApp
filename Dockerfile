# 1. Build aşaması
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# csproj dosyasını kopyala ve restore et
COPY *.csproj ./
RUN dotnet restore

# tüm dosyaları kopyala ve publish et
COPY . ./
RUN dotnet publish -c Release -o out

# 2. Runtime aşaması
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out ./

# SQLite veritabanı için klasör oluştur (opsiyonel)
RUN mkdir -p /app/Data

# Uygulamayı başlat
ENTRYPOINT ["dotnet", "efcoreApp.dll"]
