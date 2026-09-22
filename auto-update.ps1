$project = "$HOME\Desktop\java-cicd-demo"
$jarDestination = "$HOME\Downloads\calculator-jar"

Set-Location $project

Write-Host "GitHub auto-update started..."
Write-Host "Checking GitHub every 30 seconds..."
Write-Host "Press Ctrl+C to stop."
Write-Host ""

while ($true) {

    git fetch origin main

    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse origin/main

    if ($localCommit -ne $remoteCommit) {

        Write-Host "New changes found on GitHub!"
        Write-Host "Pulling latest code..."

        git pull origin main

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Git pull failed."
            Start-Sleep -Seconds 30
            continue
        }

        Write-Host "Building new JAR..."

        mvn clean package

        if ($LASTEXITCODE -eq 0) {

            Write-Host "Maven build successful."

            Copy-Item `
                "$project\target\java-cicd-demo-1.0-SNAPSHOT.jar" `
                "$jarDestination\java-cicd-demo-1.0-SNAPSHOT.jar" `
                -Force

            Write-Host "JAR updated successfully!"
            Write-Host ""
        }
        else {
            Write-Host "Maven build failed. JAR was not updated."
        }
    }
    else {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - No changes."
    }

    Start-Sleep -Seconds 30
}