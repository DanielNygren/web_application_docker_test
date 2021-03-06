#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["web_application_docker_test/web_application_docker_test.csproj", "web_application_docker_test/"]
RUN dotnet restore "web_application_docker_test/web_application_docker_test.csproj"
COPY . .
WORKDIR "/src/web_application_docker_test"
RUN dotnet build "web_application_docker_test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "web_application_docker_test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "web_application_docker_test.dll"]