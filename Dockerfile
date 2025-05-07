FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DotnetCrudApi.csproj", "."]
RUN dotnet restore "DotnetCrudApi.csproj" --disable-parallel --no-cache -v diag
COPY . .
RUN dotnet /*#__:1
RUN dotnet build "DotnetCrudApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotnetCrudApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotnetCrudApi.dll"]