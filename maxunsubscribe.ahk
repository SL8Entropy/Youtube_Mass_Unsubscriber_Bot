; =================================================================================
; Auto-Clicker with Start/Stop Hotkeys (AutoHotkey v2 - Corrected Syntax)
;
; DESCRIPTION:
; This script will start an infinite loop when you press the F1 key.
; The loop consists of three clicks, two of which are based on finding a
; specific color on the screen, followed by a series of DOWN ARROW key
; presses. The loop can be stopped at any time by pressing F2.
; =================================================================================

#SingleInstance Force
#Warn

; --- State variable for the loop ---
global KeepLooping := false

; --- COORDINATES & SETTINGS ---
; Settings for the first, color-based click
Search1_StartX := 1660
Search1_StartY := 480
Target1_Color := 0x3F3F3F ; The color to search for (in BGR format)
Search1_LimitY := 900     ; The lowest Y coordinate to stop searching at
Search1_Speed := 10 ; the amount of pixels the mouse should traverse by

; Settings for the second click, relative to the first
Click2_Y_Offset := 190

; Settings for the third, color-based click
Search3_StartX := 1300
Search3_StartY := 640
Target3_Color := 0x263850 ; The color to search for (in BGR format)
Search3_LimitX := 500      ; The leftmost X coordinate to stop searching at
Search3_Speed := 10 ; the amount of pixels the mouse should traverse by

; Define the sequence of down arrow presses for each loop iteration.
Press_Sequence := [4]

; Set the delay in milliseconds for all major pauses in the loop.
Sleep_Amount := 400

; Set the delay in milliseconds between each individual key press.
KeyPress_Delay := 400
; ------------------------------


; F1 Hotkey: This is the "Start" button.
F1::
{
    global KeepLooping ; Tells this function to use the global variable.
    local Loop_Index := 1 ; Initialize/reset the sequence index each time the loop starts.
    ToolTip("Starting Click Loop...")
    KeepLooping := true
    
    Loop
    {
        if !KeepLooping
            break

        ; --- Logic for the first click: Search for a color moving down ---
        MouseMove(Search1_StartX, Search1_StartY)
        local Click1_FoundX, Click1_FoundY

        Loop
        {
            if !KeepLooping
                break
            MouseGetPos(&Click1_FoundX, &Click1_FoundY)
            if (PixelGetColor(Click1_FoundX, Click1_FoundY) == Target1_Color)
                break
            if (Click1_FoundY >= Search1_LimitY)
            {
                ToolTip("Target color 1 not found. Stopping script.")
                SetTimer(RemoveToolTip, -3000)
                KeepLooping := false
                break
            }
            MouseMove(Click1_FoundX, Click1_FoundY + Search3_Speed, 0)
            Sleep(10)
        }
        if !KeepLooping
            break
        Click()
        Sleep(Sleep_Amount)

        if !KeepLooping
            break

        ; --- Logic for the second click: Relative to the first ---
        Click(Click1_FoundX, Click1_FoundY + Click2_Y_Offset)
        Sleep(Sleep_Amount)

        if !KeepLooping
            break

        ; --- Logic for the third click: Search for a color moving left ---
        MouseMove(Search3_StartX, Search3_StartY)
        Loop
        {
            if !KeepLooping
                break
            MouseGetPos(&currentX, &currentY)
            if (PixelGetColor(currentX, currentY) == Target3_Color)
                break 
            if (currentX <= Search3_LimitX)
            {
                ToolTip("Target color 3 not found. Stopping script.")
                SetTimer(RemoveToolTip, -3000)
                KeepLooping := false
                break
            }
            MouseMove(currentX - Search3_Speed, currentY, 0)
            Sleep(10)
        }
        if !KeepLooping
            break
        Click()
        Sleep(Sleep_Amount)
        
        ; --- Logic for key presses ---
        Num_Presses := Press_Sequence[Loop_Index]
        Loop Num_Presses
        {
            if !KeepLooping
                break 2
            Send("{Down}")
            Sleep(KeyPress_Delay)
        }
        Sleep(Sleep_Amount)
        
        Loop_Index++
        if (Loop_Index > Press_Sequence.Length)
            Loop_Index := 1
    }
    
    ToolTip("Click Loop Stopped.")
    SetTimer(RemoveToolTip, -1500)
}


; F2 Hotkey: This is the "Stop" button.
F2::
{
    global KeepLooping
    KeepLooping := false
}


; This is a small helper function to automatically remove the on-screen tooltips.
RemoveToolTip()
{
    ToolTip()
}

