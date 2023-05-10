# Smart Performance Power Plan Switcher

This PowerShell script, `smartperformance.ps1`, aims to automatically switch between the Balanced and High Performance power plans on your Windows machine based on whether your device is connected to a power source or running on battery.

## Features

- Automatically switches between Balanced and High Performance power plans.
- Monitors power events in real-time.
- Lightweight and easy to use.

## Prerequisites

- Windows OS with PowerShell installed.
- PowerShell 5.1 or later.

## How to use

1. Clone or download the script file `smartperformance.ps1`.
2. Open PowerShell with **Administrator** privileges.
3. Navigate to the folder containing the script.
4. Run the script by typing `.\smartperformance.ps1` and pressing Enter.
5. The script will start monitoring power events and switch power plans accordingly. Press Ctrl+C to exit.

## Creating a shortcut to run the script as Administrator

1. Right-click on an empty space on your desktop or desired folder, then click on `New > Shortcut`.

2. In the `Create Shortcut` window, type the following in the `Type the location of the item` field:

   ````
   powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\smartperformance.ps1"
   ```

   Replace `C:\path\to\` with the actual path to the folder containing the `smartperformance.ps1` script.

3. Click `Next`, give your shortcut a name (e.g., "Smart Performance Switcher"), and click `Finish`.

4. Now, right-click on the newly created shortcut and click on `Properties`.

5. In the `Shortcut` tab, click on the `Advanced` button.

6. Check the box next to `Run as administrator`, then click `OK`.

7. Click `Apply`, then click `OK` to close the `Properties` window.

Now, when you double-click on the shortcut, the `smartperformance.ps1` script will be executed as Administrator.

## Code overview

- The script defines GUIDs for the Balanced and High Performance power plans.
- Functions are defined to get the current power plan, set a new power plan, and check the power status.
- An event is registered for power management events to detect when the power source changes.
- The script sets the initial power plan based on the current power status and starts monitoring power events.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
