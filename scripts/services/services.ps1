param (
    [string]$servicesConfigUrl
)

# Download services.config file
Invoke-WebRequest -Uri $servicesConfigUrl -OutFile $localConfigPath

# Function to process service configuration
function ProcessServiceConfiguration($serviceName, $startupType) {
    # Set the service with the specified startup type
    Set-Service -Name $serviceName -StartupType $startupType
    Write-Host "Service $serviceName startup has been set to $startupType"
}

# Process service configuration
if (Test-Path $localConfigPath) {
    # Read the contents of the local services.config file
    $servicesConfig = Get-Content $localConfigPath

    # For each line in the services.config file
    foreach ($line in $servicesConfig) {
        # Skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            # Split the line by comma to separate service name and startup type
            $serviceData = $line -split ","
            
            # Check if the line is correctly formatted
            if ($serviceData.Length -eq 2) {
                $serviceName = $serviceData[0].Trim()
                $startupType = $serviceData[1].Trim()

                # Process service configuration
                ProcessServiceConfiguration -serviceName $serviceName -startupType $startupType
            }
        }
    }
} else {
    # Will update this to grab the latest from the GitHub repo
    Write-Host "services.config file not found."
}