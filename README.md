# SmartPerformance 

SmartPerformance is a PowerShell script that performs specific actions when your computer is connected to AC power or running on battery power. The script uses a combination of scheduled tasks and WMI (Windows Management Instrumentation) event queries to monitor power events efficiently.

## Prerequisites

- PowerShell 5.1 or later
- Administrator privileges to create the scheduled task

## Installation

1. Download the SmartPerformance PowerShell script (e.g., `SmartPerformance.ps1`) from this repository.

2. Open Task Scheduler by pressing `Win + R`, typing `taskschd.msc` in the Run dialog, and pressing Enter.

3. Right-click on "Task Scheduler Library" and select "Create Task."

4. In the "Create Task" window, enter a name and description for the task, and check the "Run with highest privileges" checkbox.

5. Go to the "Triggers" tab and click "New." In the "New Trigger" window, set "Begin the task" to "On an event."

6. Set "Log" to "System" and "Source" to "Kernel-Power." For the "Event ID," use "105" for AC power connected (plugged in) events and "107" for battery power events (unplugged). Click "OK" to create the trigger. You can create multiple triggers if needed.

7. Go to the "Actions" tab and click "New." In the "New Action" window, set "Action" to "Start a program." For "Program/script," enter `powershell.exe`. In the "Add arguments (optional)" field, enter `-ExecutionPolicy Bypass -File "C:\Path\To\BoostOnCharge.ps1"`. Replace `C:\Path\To\BoostOnCharge.ps1` with the full path to your downloaded BoostOnCharge script. Click "OK" to create the action.

8. Click "OK" to create the scheduled task.

## Usage

The SmartPerformance script will run automatically when the power state of your computer changes, either when it's connected to AC power or running on battery power. The script will perform specific actions depending on the power state.

You can customize the actions in the `BoostOnCharge.ps1` script by modifying the content of the `if` and `elseif` blocks:

```powershell
$powerStatus = (Get-WmiObject -Class Win32_Battery).BatteryStatus

if ($powerStatus -eq 2) {
    # AC power connected (plugged in) actions
} elseif ($powerStatus -eq 1) {
    # Battery power actions (unplugged)
}
