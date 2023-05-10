    function Log-ScriptInfo {
        param (
            [string]$LogMessage
        )
    
        $EventLogSource = "SmartPerformance-v0.2"
    
        if (![System.Diagnostics.EventLog]::SourceExists($EventLogSource)) {
            [System.Diagnostics.EventLog]::CreateEventSource($EventLogSource, "Application")
        }
    
        [System.Diagnostics.EventLog]::WriteEntry($EventLogSource, $LogMessage, [System.Diagnostics.EventLogEntryType]::Information)
    }
    
    Log-ScriptInfo -LogMessage "The SmartPerformance script is running."
    Log-ScriptInfo -LogMessage "The script is secure and is made by Matteo."

# smartperformance.ps1

# GUID dei piani energetici
$balancedPlan = "381b4222-f694-41f0-9685-ff5bb260df2e"
$highPerformancePlan = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"

# Funzione per ottenere il piano energetico attuale
function Get-CurrentPowerPlan {
    $activePlan = powercfg /list | Select-String "\*"
    $activePlan = $activePlan -replace ".*\((.*)\).*", '$1'
    return $activePlan
}

# Funzione per assegnare il piano energetico appropriato
function Set-PowerPlan {
    param($planGUID)

    if ($planGUID -ne (Get-CurrentPowerPlan)) {
        powercfg /setactive $planGUID
        Write-Host "Power plan has been changed to: $planGUID"
    }
}

# Funzione per controllare lo stato di alimentazione
function Check-PowerStatus {
    $batteryStatus = Get-WmiObject -Class Win32_Battery
    return $batteryStatus.BatteryStatus -eq 2
}

# Registra l'evento di cambio alimentazione
$powerEvent = Register-WmiEvent -Query "SELECT * FROM Win32_PowerManagementEvent WHERE EventType = 10" -SourceIdentifier PowerEvent -Action {

    # Stato di alimentazione: connesso (1) o scollegato (0)
    $powerStatus = (Check-PowerStatus) -eq 1

    if ($powerStatus) {
        Set-PowerPlan -planGUID $highPerformancePlan
    } else {
        Set-PowerPlan -planGUID $balancedPlan
    }
}

# Imposta il piano energetico iniziale
$initialPowerStatus = Get-WmiObject -Namespace root\wmi -Class BatteryStatus | Select-Object -ExpandProperty PowerOnline
if ($initialPowerStatus) {
    Set-PowerPlan -planGUID $highPerformancePlan
} else {
    Set-PowerPlan -planGUID $balancedPlan
}

# Attendi l'evento di cambio alimentazione
Write-Host "Monitoring power events. Press Ctrl+C to exit."
while ($true) {
    Wait-Event -SourceIdentifier PowerEvent
}