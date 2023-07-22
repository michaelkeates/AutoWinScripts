#change any app to true to uninstall, if set at false it will not uninstall

$apps = @(
    @{
        Name = "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        Uninstall = $true
    }
    @{
        Name = "*Clipchamp.Clipchamp*"
        Uninstall = $true
    }
    @{
        Name = "*Dolby*"
        Uninstall = $true
    }
    @{
        Name = "*Duolingo-LearnLanguagesforFree*"
        Uninstall = $true
    }
    @{
        Name = "*Facebook*"
        Uninstall = $true
    }
    @{
        Name = "*Flipboard*"
        Uninstall = $true
    }
    @{
        Name = "*HULULLC.HULUPLUS*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.3DBuilder*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.549981C3F5F10*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Asphalt8Airborne*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.BingFinance*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.BingNews*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.BingSports*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.BingTranslator*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.BingWeather*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.GetHelp*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Getstarted*"
        Uninstall = $true   # Cannot be uninstalled in Windows 11
    }
    @{
        Name = "*Microsoft.Messaging*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Microsoft3DViewer*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.MicrosoftOfficeHub*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.MicrosoftSolitaireCollection*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.MicrosoftStickyNotes*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.MixedReality.Portal*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.NetworkSpeedTest*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.News*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Office.OneNote*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Office.Sway*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.OneConnect*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Print3D*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.SkypeApp*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Todos*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.WindowsAlarms*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.WindowsFeedbackHub*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.WindowsMaps*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.WindowsSoundRecorder*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.Xbox.TCUI*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.XboxApp*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.XboxGameOverlay*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.XboxGamingOverlay*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.XboxIdentityProvider*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.XboxSpeechToTextOverlay*"
        Uninstall = $true   # NOTE: This app may not be able to be reinstalled!
    }
    @{
        Name = "*Microsoft.ZuneMusic*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.ZuneVideo*"
        Uninstall = $true
    }
    @{
        Name = "*PandoraMediaInc*"
        Uninstall = $true
    }
    @{
        Name = "*PICSART-PHOTOSTUDIO*"
        Uninstall = $true
    }
    @{
        Name = "*Royal Revolt*"
        Uninstall = $true
    }
    @{
        Name = "*Speed Test*"
        Uninstall = $true
    }
    @{
        Name = "*Spotify*"
        Uninstall = $true
    }
    @{
        Name = "*Twitter*"
        Uninstall = $true
    }
    @{
        Name = "*Wunderlist*"
        Uninstall = $true
    }
    @{
        Name = "*king.com.BubbleWitch3Saga*"
        Uninstall = $true
    }
    @{
        Name = "*king.com.CandyCrushSaga*"
        Uninstall = $true
    }
    @{
        Name = "*king.com.CandyCrushSodaSaga*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.GamingApp*"
        Uninstall = $true
    }
    @{
        Name = "*Microsoft.MSPaint*"
        Uninstall = $false   # Paint 3D
    }
    @{
        Name = "*Microsoft.People*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.PowerAutomateDesktop*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.RemoteDesktop*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.ScreenSketch*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.Windows.Photos*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.WindowsCalculator*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.WindowsCamera*"
        Uninstall = $false
    }
    @{
        Name = "*Microsoft.WindowsStore*"
        Uninstall = $false   # NOTE: This app cannot be reinstalled!
    }
    @{
        Name = "*Microsoft.YourPhone*"
        Uninstall = $false
    }
    @{
        Name = "*microsoft.windowscommunicationsapps*"
        Uninstall = $false   # Mail & Calendar
    }
)

foreach ($app in $apps) {
    if ($app.Uninstall) {
        Write-Host "Attempting to remove $($app.Name)"

        Get-AppxPackage -Name $app.Name -AllUsers | Remove-AppxPackage

        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app.Name } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
    }
}
