#get the directory path of the script
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

#construct the path to the services.config file
$servicesConfigPath = Join-Path -Path $scriptDirectory -ChildPath "..\..\services.config"

#function to process service configuration
function ProcessServiceConfiguration($serviceName, $startupType) {
    # Set the service with the specified startup type
    Set-Service -Name $serviceName -StartupType $startupType
    Write-Host "Service $serviceName startup has been set to $startupType"
}

#process service configuration
if (Test-Path $servicesConfigPath) {
    #read the contents of the services.config file
    $servicesConfig = Get-Content $servicesConfigPath

    #for each line in the services.config file
    foreach ($line in $servicesConfig) {
        #skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            #split the line by comma to separate service name and startup type
            $serviceData = $line -split ","
            
            #check if the line is correctly formatted
            if ($serviceData.Length -eq 2) {
                $serviceName = $serviceData[0].Trim()
                $startupType = $serviceData[1].Trim()

                #process service configuration
                ProcessServiceConfiguration -serviceName $serviceName -startupType $startupType
            }
        }
    }
}
else {
    #will update this to grab latest from github repo
    Write-Host "services.config file not found."
}
