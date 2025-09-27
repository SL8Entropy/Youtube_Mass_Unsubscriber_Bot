; =================================================================================
; Auto-Clicker with Color Search (AutoHotkey v2) - Updated
;
; DESCRIPTION:
; This script loops through two actions:
; 1. A standard click at a fixed position.
; 2. A dynamic click that first searches upwards for a specific color.
; If the color search fails, it waits 10 seconds and retries the entire loop.
;
; HOTKEYS:
;   - F1: Starts the clicking loop.
;   - F2: Stops the clicking loop at any time.
; =================================================================================

#SingleInstance Force 
#Warn               

; --- SETTINGS ---
; --- First Click (Fixed Position) ---
Click1_X := 1850
Click1_Y := 410

; --- Second Click (Color Search) ---
Search2_StartX := 1850         ; X-coordinate to start the search.
Search2_StartY := 740          ; Y-coordinate to start the search.
Target2_Color  := 0x3E3E3E      ; The color to find (in BGR format).
Search2_Step   := 5            ; How many pixels to move up each step.
Search2_LimitY := 410          ; Failsafe: The highest Y-coordinate to search to.

sleepAmount := 250             ; Delay in milliseconds after each click.
failSleep := 250 ; Delay in milliseconds if fail
; --- A global variable to control whether the loop should run ---
global KeepLooping := false

; --- F1 Hotkey: This is the "Start" button ---
F1::
{
    global KeepLooping 
    ToolTip("Clicking loop STARTED.")
    KeepLooping := true

    Loop
    {
        if !KeepLooping
            break 

        ; --- Action 1: Perform the first, fixed click ---
        Click(Click1_X, Click1_Y)
        Sleep(sleepAmount) 

        if !KeepLooping
            break

        ; --- Action 2: Search for the color for the second click ---
        MouseMove(Search2_StartX, Search2_StartY, 0)
        local colorFound := false ; This flag tracks if the search was successful.

        Loop ; This is the inner "search loop".
        {
            if !KeepLooping
                break

            MouseGetPos(&currentX, &currentY)

            ; Condition 1: The target color is found.
            if (PixelGetColor(currentX, currentY) == Target2_Color)
            {
                colorFound := true ; Set the flag to true.
                break              ; Exit the search loop to perform the click.
            }
            
            ; Condition 2: Failsafe limit is reached without finding the color.
            if (currentY <= Search2_LimitY)
            {
                ToolTip("Color not found. Retrying in 10 seconds...")
                SetTimer(() => ToolTip(), -2000) ; Show message for 2 seconds.
                Sleep(failSleep)                     ; << NEW: Wait for 10 seconds.
                break                            ; Exit the search loop. colorFound remains false.
            }
            
            MouseMove(currentX, currentY - Search2_Step, 0)
            Sleep(20) 
        }

        if !KeepLooping
            break

        ; << NEW: If color was not found, skip the click and restart the main loop.
        if !colorFound
            continue

        ; If we get here, the color was found. Click at its location.
        Click()
        Sleep(sleepAmount)
    }

    if (A_PriorHotkey == "F2")
    {
        ToolTip("Clicking loop STOPPED.")
        SetTimer(() => ToolTip(), -1500)
    }
}

; --- F2 Hotkey: This is the "Stop" button ---
F2::
{
    global KeepLooping
    KeepLooping := false
}