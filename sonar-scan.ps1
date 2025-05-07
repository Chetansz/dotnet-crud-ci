# Variables
$SONAR_PROJECT_KEY="dotnet-crud-api"
$SONAR_HOST_URL="http://localhost:9000"

Write-Host "Starting SonarQube Analysis..."

# Begin SonarQube Analysis
dotnet sonarscanner begin `
    /k:"$SONAR_PROJECT_KEY" `
    /d:sonar.host.url="$SONAR_HOST_URL" `
    /d:sonar.login="admin" `
    /d:sonar.password="admin" `
    /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" `
    /d:sonar.coverage.exclusions="**Tests/*.cs" `
    /d:sonar.exclusions="**/obj/**,**/bin/**"

# Build the project
dotnet build

# End SonarQube Analysis
dotnet sonarscanner end /d:sonar.login="admin" /d:sonar.password="admin"

Write-Host "SonarQube Analysis completed. Visit $SONAR_HOST_URL to view the results."
