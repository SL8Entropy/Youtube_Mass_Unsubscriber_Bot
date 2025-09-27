#SingleInstance Force

; Press F3 to test a scroll amount.
F3::
{
    ; This command simulates scrolling the wheel down by 4 notches.
    ; CHANGE THE NUMBER 4 TO TEST different amounts.
    Send("{WheelDown 1}") 
}

; Press F4 to exit this test script.
F4::
{
    ExitApp()
}
