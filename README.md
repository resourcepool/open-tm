# Open-Tm

Current version: `1.5`

**Open-Tm supports opentx >=2.2. Don't forget to upgrade**

Looking for OpenTx Flight Logs to give you more awesomeness! Tweet if you have some to share :)

## What it is
Open-Tm is a set of awesome telemetry screens for your favorite OpenTX Radio.
Right now we support both Taranis X7 & Taranis X9D/X9D+
**X9D/X9D+:**  
![Telemetry Example](images/screen-1.png)  
![Telemetry Example 2](images/screen-2.png)

**X7:**  
![Telemetry Example 3](images/screen-3.png)

## What it does
Open-Tm pulls the telemetry data and displays it in cool widgets.
Really, it's so cool it looks like your OSD.

The following sensors are supported:
 * Hdg : Heading
 * VFAS : Battery level
 * AccX-AccY-AccZ: Accelerometer
 * Flight Mode
 * Flight Timer
 * RSSI

## Howto

### 1. Place files on SD Card
Download this repository and unzip its content into the /SCRIPTS/TELEMETRY folder of your Taranis.

The folder should look similar to this:
![SD Card content](images/setup-1.png)

### 2. Configure Flight Modes
As you may know, your Radio needs to know about your flight modes.
Configure your flight modes in order for the Script to show the current flight mode.

### 3. Configure Flight Timer
In order to show the flight time, the script uses the values given by a Timer.
Configure your timer in order to reflect your flight time on your Radio.

### 4. Configure Script
Open the Racer.lua file with any text editor and change the first lines according to your configuration.
By default, the script assumes that you have a Taranis X9D/X9D+, a compass on your drone and that the flight timer is timer-0 (the first timer)

### 5. Enable Script as telemetry screen
Go to your Taranis settings and enable your telemetry screen. Congrats!


# Any issues?
Having trouble on your setup? Here's a few things to check before creating an issue:
 * Check whether you have the latest version of the OpenTX Firmware (2.2)
 * Make sure you have the "luac" option enabled on your firmware. Otherwise flash a new firmware on OpenTX Companion
 * Make sure you have transferred the right files in the specific directories on your SD card


# Contribute
Any ideas? Feature requests? Tell us about it in the "Issues" section!  

Contact: Twitter @loicortola
