#get the directory path of the script
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

#specify the relative path to the registry.config file
$registryConfigPath = Join-Path -Path $scriptDirectory -ChildPath "..\..\registry.config"

#function to process registry configuration
function ProcessRegistryConfiguration($path, $name, $value, $force) {
    #convert the force value to a boolean
    $force = $force -eq 1

    #check if the registry path and name are not empty
    if (![string]::IsNullOrEmpty($path) -and ![string]::IsNullOrEmpty($name)) {
        #check if the registry path exists
        if (Test-Path $path) {
            #set the registry item property using the specified values
            Set-ItemProperty -Path $path -Name $name -Value $value -Force:$force
            Write-Host "Registry item property set for $name"
        } else {
            #create a new registry item
            New-Item -Path $path -Force | Out-Null
            Write-Host "New registry item created: $path"
        }
    } else {
        Write-Host "Invalid registry path or name specified."
    }
}

#process registry configuration
if (Test-Path $registryConfigPath) {
    #read the contents of the registry.config file
    $registryConfig = Get-Content $registryConfigPath

    #flag to indicate whether to process new registry items
    $processNewItems = $false
    #flag to indicate whether to remove items
    $removeItems = $false

    #for each line in the registry.config file
    foreach ($line in $registryConfig) {
        #skip comment lines that begin with #
        if ($line -match '^\s*#') {
            #check if the line is the marker for adding new items
            if ($line -match '^\s*#ADDNEWITEMS#') {
                $processNewItems = $true
                $removeItems = $false
            }
            #check if the line is the marker for removing items
            if ($line -match '^\s*#REMOVEITEMS#') {
                $processNewItems = $false
                $removeItems = $true
            }
            continue
        }

        #split the line by comma to separate registry path, name, value, and force
        $registryData = $line -split ","
        
        #check if the line is correctly formatted
        if ($registryData.Length -ge 3) {
            $path = $registryData[0].Trim()
            $name = $registryData[1].Trim()
            $value = $registryData[2].Trim()
            $force = 1

            #process registry configuration
            if (!$removeItems) {
                ProcessRegistryConfiguration -path $path -name $name -value $value -force $force
            } else {
                #remove the specified registry item
                if (Test-Path $path) {
                    Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
                    Write-Host "Registry item removed: $path"
                }
            }
        } elseif ($processNewItems -and $registryData.Length -ge 1) {
            #check if new items should be processed
            $path = $registryData[0].Trim()
            $name = $registryData[1].Trim()

            #create a new registry item
            if (![string]::IsNullOrEmpty($path)) {
                New-Item -Path $path -Force | Out-Null
                Write-Host "New registry item created: $path"
            }
        } else {
            Write-Host "Invalid line format in registry.config: $line"
        }
    }
}
else {
    #will update this to grab the latest from GitHub repo
    Write-Host "registry.config file not found."
}