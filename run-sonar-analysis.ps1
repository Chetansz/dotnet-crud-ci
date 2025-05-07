param(
    [Parameter(Mandatory=$true)]
    [string]$SonarToken
)

Write-Host "Starting SonarQube Analysis..."

# Install report generator for code coverage
dotnet tool install -g dotnet-reportgenerator-globaltool

# Install coverlet for code coverage collection
dotnet add package coverlet.collector

# Begin SonarQube Analysis
dotnet sonarscanner begin `
    /k:"dotnet-crud-api" `
    /d:sonar.host.url="http://localhost:9000" `
    /d:sonar.login="$SonarToken" `
    /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" `
    /d:sonar.coverage.exclusions="**Tests/*.cs,**/*.Designer.cs" `
    /d:sonar.exclusions="**/bin/**,**/obj/**"

# Build the project
dotnet build --no-incremental

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage;Format=opencover"

# End SonarQube Analysis
dotnet sonarscanner end /d:sonar.login="$SonarToken"

Write-Host "SonarQube Analysis completed. Visit http://localhost:9000 to view the results."
