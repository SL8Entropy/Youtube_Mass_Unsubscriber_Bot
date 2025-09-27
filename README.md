***

# Auto-Clicker & Key-Presser Script for AutoHotkey v2

[cite_start]This AutoHotkey script automates a sequence of mouse clicks and keyboard presses. [cite: 2] [cite_start]It is designed to run in a loop, performing a series of actions that include searching for specific colors on the screen to determine click locations. [cite: 3, 4]

## Features

* [cite_start]**Looping Automation:** Starts an infinite loop of actions when you press the F1 hotkey. [cite: 2, 17]
* [cite_start]**Easy Controls:** The loop can be started with `F1` [cite: 17] [cite_start]and stopped at any time with `F2`. [cite: 5, 31]
* **Dynamic Color-Based Clicks:**
    * [cite_start]**First Click:** The script moves the mouse to a starting position and scans vertically downwards until it finds a specified color (`Target1_Color`) before clicking. [cite: 7, 20, 21]
    * [cite_start]**Third Click:** It moves to another starting position and scans horizontally to the left to find a different color (`Target3_Color`) before clicking. [cite: 11, 25, 26]
* [cite_start]**Relative Clicking:** The second click is performed at a location relative to where the first click occurred, specifically at a vertical offset. [cite: 10, 24]
* [cite_start]**Automated Key Presses:** After the three clicks, the script presses the "Down Arrow" key a configurable number of times. [cite: 14, 29]
* [cite_start]**Customizable Settings:** All coordinates, colors [cite: 8, 12][cite_start], delays [cite: 15, 16][cite_start], and the key press sequence [cite: 14] are defined in a clear settings section at the top of the script, making it easy to configure.
* [cite_start]**Safety Stops:** If the target colors for the dynamic clicks are not found within a predefined search area, the script will automatically stop to prevent errors. [cite: 9, 13, 22, 27]

## Prerequisites

You must have **AutoHotkey v2** installed on your system to run this script.

## How to Use

1.  **Configuration:** Before running the script, you must configure the variables in the `--- COORDINATES & SETTINGS ---` section.
    * Open the `maxunsubscribe.ahk` script file in a text editor.
    * Use the **AutoHotkey Window Spy** tool (which comes with the AutoHotkey installation) to find the screen coordinates and color values (in BGR format) for your specific task and screen resolution.
    * Update the variables in the settings section to match your requirements. See the **Configuration Details** section below for an explanation of each variable.
2.  **Run the Script:** Double-click the `maxunsubscribe.ahk` file to run it. An AutoHotkey icon will appear in your system tray.
3.  [cite_start]**Start the Loop:** Press the `F1` key to begin the automation loop. [cite: 17] A tooltip will appear confirming that the loop has started.
4.  [cite_start]**Stop the Loop:** Press the `F2` key at any time to stop the automation. [cite: 31] A tooltip will confirm the loop has stopped.

## Configuration Details

This section explains each customizable variable in the script.

### [cite_start]First Click (Vertical Search) [cite: 7]
* `Search1_StartX`: The X-coordinate where the downward color search begins.
* `Search1_StartY`: The Y-coordinate where the downward color search begins.
* [cite_start]`Target1_Color`: The color (`0xBGR` format) the script looks for while moving down. [cite: 8]
* `Search1_LimitY`: The lowest Y-coordinate the mouse will search to. [cite_start]If the color isn't found by this point, the script stops. [cite: 9]
* `Search1_Speed`: The number of pixels the mouse moves down in each step of the search.

### [cite_start]Second Click (Relative Position) [cite: 10]
* `Click2_Y_Offset`: This value is added to the Y-coordinate of the first click's location to determine the position of the second click.

### [cite_start]Third Click (Horizontal Search) [cite: 11]
* `Search3_StartX`: The X-coordinate where the leftward color search begins.
* `Search3_StartY`: The Y-coordinate where the leftward color search begins.
* [cite_start]`Target3_Color`: The color (`0xBGR` format) the script looks for while moving left. [cite: 12]
* `Search3_LimitX`: The leftmost X-coordinate the mouse will search to. [cite_start]If the color isn't found by this point, the script stops. [cite: 13]
* `Search3_Speed`: The number of pixels the mouse moves left in each step of the search.

### Key Press & Delays
* `Press_Sequence`: An array that defines how many times the "Down Arrow" key should be pressed after the clicks. [cite_start]The current script is set to `[4]`, meaning it will press the key 4 times in every loop. [cite: 14]
* [cite_start]`Sleep_Amount`: The delay in milliseconds after each click and after the full sequence of key presses. [cite: 15, 23, 30]
* [cite_start]`KeyPress_Delay`: The delay in milliseconds between each individual "Down Arrow" key press. [cite: 16]


### Project demo:
* https://youtu.be/RILnZVq7Rs4
