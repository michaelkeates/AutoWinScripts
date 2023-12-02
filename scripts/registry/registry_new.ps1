# Specify the URL to the registry.config file on GitHub
$registryConfigUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/minimal/registry.config"

# Get the directory path of the script
$scriptDirectory = $PSScriptRoot

# Specify the relative path to the registry.config file
$registryConfigPath = Join-Path -Path $scriptDirectory -ChildPath "registry.config"

# Function to process registry configuration
function ProcessRegistryConfiguration($path, $name, $value, $force) {
    # Convert the force value to a boolean
    $force = $force -eq 1

    # Check if the registry path and name are not empty
    if (![string]::IsNullOrEmpty($path) -and ![string]::IsNullOrEmpty($name)) {
        # Check if the registry path exists
        if (Test-Path $path) {
            # Set the registry item property using the specified values
            Set-ItemProperty -Path $path -Name $name -Value $value -Force:$force
            Write-Host "Registry item property set for $name"
        } else {
            # Create a new registry item
            New-Item -Path $path -Force | Out-Null
            Write-Host "New registry item created: $path"
        }
    } else {
        Write-Host "Invalid registry path or name specified."
    }
}

# Process registry configuration from the URL
try {
    # Attempt to download the registry.config file
    Invoke-WebRequest -Uri $registryConfigUrl -OutFile "$scriptDirectory\registry.config"

    # Read the contents of the registry.config file
    $registryConfig = Get-Content "$scriptDirectory\registry.config"

    # Flag to indicate whether to process new registry items
    $processNewItems = $false
    # Flag to indicate whether to remove items
    $removeItems = $false

    # For each line in the registry.config file
    foreach ($line in $registryConfig) {
        # Skip comment lines that begin with #
        if ($line -match '^\s*#') {
            # Check if the line is the marker for adding new items
            if ($line -match '^\s*#ADDNEWITEMS#') {
                $processNewItems = $true
                $removeItems = $false
            }
            # Check if the line is the marker for removing items
            if ($line -match '^\s*#REMOVEITEMS#') {
                $processNewItems = $false
                $removeItems = $true
            }
            continue
        }

        # Split the line by a comma to separate registry path, name, value, and force
        $registryData = $line -split ","

        # Check if the line is correctly formatted
        if ($registryData.Length -ge 3) {
            $path = $registryData[0].Trim()
            $name = $registryData[1].Trim()
            $value = $registryData[2].Trim()
            $force = 1

            # Process registry configuration
            if (!$removeItems) {
                ProcessRegistryConfiguration -path $path -name $name -value $value -force $force
            } else {
                # Remove the specified registry item
                if (Test-Path $path) {
                    Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
                    Write-Host "Registry item removed: $path"
                }
            }
        } elseif ($processNewItems -and $registryData.Length -ge 1) {
            # Check if new items should be processed
            $path = $registryData[0].Trim()
            $name = $registryData[1].Trim()

            # Create a new registry item
            if (![string]::IsNullOrEmpty($path)) {
                New-Item -Path $path -Force | Out-Null
                Write-Host "New registry item created: $path"
            }
        } else {
            Write-Host "Invalid line format in registry.config: $line"
        }
    }
}
catch {
    Write-Host "Failed to download registry.config file from $registryConfigUrl. Error: $_"
}
