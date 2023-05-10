function Log-ScriptInfo {
    $EventLogSource = "SmartPerformance"

    if (![System.Diagnostics.EventLog]::SourceExists($EventLogSource)) {
        [System.Diagnostics.EventLog]::CreateEventSource($EventLogSource, "Application")
    }

    $EventLogMessage = "SmartPerformance script is running."
    $EventLogMessage = "Made by Matteo, this is a secure script!"

    [System.Diagnostics.EventLog]::WriteEntry($EventLogSource, $EventLogMessage, [System.Diagnostics.EventLogEntryType]::Information)
}

Log-ScriptInfo

$CustomBalancedPlanGuid = "381b4222-f694-41f0-9685-ff5bb260df2e"
$HighPerformancePlanGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"

function Get-PowerSource {
    $BatteryStatus = Get-WmiObject -Class Win32_Battery
    $PowerStatus = (Get-CimInstance -Namespace root\wmi -ClassName BatteryStatus).PowerOnline

    if ($PowerStatus -eq $true) {
        return "AC"
    } elseif ($BatteryStatus -ne $null -and $PowerStatus -eq $false) {
        return "Battery"
    } else {
        return "Unknown"
    }
}
function Set-PowerPlan {
    param($PlanGuid)
    powercfg.exe -setactive $PlanGuid
}

function Check-PowerProfileExists {
    param($ProfileGuid)
    $Profiles = powercfg.exe -list
    if ($Profiles -match $ProfileGuid) {
        return $true
    } else {
        return $false
    }
}

function Create-HighPerformancePlan {
    $HighPerformancePlanName = "High Performance"
    $NewPlan = powercfg.exe -duplicatescheme $HighPerformancePlanGuid 2>&1
    if ($NewPlan -match "Parametri non validi") {
        Write-Host "Error: Failed to duplicate High Performance plan. Exiting."
        exit
    }
    $NewPlanGuid = $NewPlan.Split()[3]
    powercfg.exe -changename $NewPlanGuid $HighPerformancePlanName
    return $NewPlanGuid
}

if (-not (Check-PowerProfileExists -ProfileGuid $CustomBalancedPlanGuid)) {
    Write-Host "Custom Balanced plan not found. Exiting."
    exit
}

while ($true) {
    $PowerSource = Get-PowerSource
    $CurrentPlan = (powercfg.exe -getactivescheme).split()[3]

    if ($PowerSource -eq "AC" -and $CurrentPlan -ne $HighPerformancePlanGuid) {
        Set-PowerPlan -PlanGuid $HighPerformancePlanGuid
        Write-Host "Switched to High Performance plan"
    } elseif ($PowerSource -eq "Battery" -and $CurrentPlan -ne $CustomBalancedPlanGuid) {
        Set-PowerPlan -PlanGuid $CustomBalancedPlanGuid
        Write-Host "Switched to Custom Balanced plan"
    }

    Start-Sleep -Seconds 120
}