; =================================================================================
; Auto-Clicker with Color Search (AutoHotkey v2) - Updated
;
; DESCRIPTION:
; This script loops through two actions: a fixed click and a dynamic color search.
; If the color search fails 5 times in a row, it refreshes the page (Ctrl+R)
; and performs a second color search before continuing.
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

; --- Second Click (Main Color Search) ---
Search2_StartX := 1850
Search2_StartY := 740
Target2_Color  := 0x3E3E3E
Search2_Step   := 10
Search2_LimitY := 410 ;

; --- Refresh Action (after 5 failures) ---
RefreshSearch_StartX := 1844         ; X-coord to start searching after a refresh.
RefreshSearch_StartY := 330          ; Y-coord to start searching after a refresh.
RefreshTarget_Color  := 0x525252      ; The new color to find after a refresh.
RefreshSearch_Step   := 5            ; Pixels to move up each step.
RefreshSearch_LimitY := 50           ; Failsafe limit for the refresh search.

; --- Delays ---
sleepAmount    := 250
failRetrySleep := 250

; --- A global variable to control the loop ---
global KeepLooping := false

; --- F1 Hotkey: "Start" ---
F1::
{
    global KeepLooping
    local consecutiveFails := 0
    ToolTip("Clicking loop STARTED.")
    KeepLooping := true

    Loop
    {
        if !KeepLooping
            break

        Click(Click1_X, Click1_Y)
        Sleep(sleepAmount)

        if !KeepLooping
            break

        MouseMove(Search2_StartX, Search2_StartY, 0)
        local colorFound := false

        Loop ; Inner "search loop" for Action 2
        {
            if !KeepLooping
                break

            MouseGetPos(&currentX, &currentY)

            if (PixelGetColor(currentX, currentY) == Target2_Color)
            {
                colorFound := true
                break
            }

            if (currentY <= Search2_LimitY)
            {
                ToolTip("Color not found. Retrying...")
                SetTimer(() => ToolTip(), -1500)
                Sleep(failRetrySleep)
                break
            }

            MouseMove(currentX, currentY - Search2_Step, 0)
            Sleep(20)
        }

        if !KeepLooping
            break

        if !colorFound
        {
            consecutiveFails++
            ToolTip("Consecutive failures: " . consecutiveFails)
            SetTimer(() => ToolTip(), -1500)

            if (consecutiveFails >= 5)
            {
                ToolTip("5 failures reached. Refreshing page...")
                Send("^r") ; Press Ctrl+R
                Sleep(3000) ; Wait for page to refresh

                ; << NEW: Start searching for the post-refresh button >>
                MouseMove(RefreshSearch_StartX, RefreshSearch_StartY, 0)
                Loop
                {
                    if !KeepLooping
                        break 2 ; Break out of this search and the parent 'if' block

                    MouseGetPos(&rx, &ry)

                    if (PixelGetColor(rx, ry) == RefreshTarget_Color)
                        break ; Color found, exit this search loop

                    if (ry <= RefreshSearch_LimitY)
                    {
                        ToolTip("Post-refresh color search FAILED. Retrying main loop.")
                        SetTimer(() => ToolTip(), -2000)
                        break ; Failsafe for this inner search
                    }
                    MouseMove(rx, ry - RefreshSearch_Step, 0)
                    Sleep(20)
                }
                
                if (KeepLooping)
                    Click() ; Click if the refresh-search was successful
                    
                Sleep(1000)
                consecutiveFails := 0
            }
            continue
        }

        Click()
        Sleep(sleepAmount)
        consecutiveFails := 0
    }

    if (A_PriorHotkey == "F2")
    {
        ToolTip("Clicking loop STOPPED.")
        SetTimer(() => ToolTip(), -1500)
    }
}

; --- F2 Hotkey: "Stop" ---
F2::
{
    global KeepLooping
    KeepLooping := false
}