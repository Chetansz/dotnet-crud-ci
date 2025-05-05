FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
# Debug: List files to verify .csproj presence
RUN ls -l
# Debug: Verify .NET SDK version
RUN dotnet --version
# Attempt to restore
RUN dotnet restore "./DotnetCrudApi.csproj" --verbosity detailed
RUN dotnet publish "./DotnetCrudApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DotnetCrudApi.dll"]