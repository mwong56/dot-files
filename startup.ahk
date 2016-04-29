#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!t::
	Run, "C:\Program Files (x86)\Cmder\Cmder.exe"
Return

!c::
	Run, Chrome
Return

; "CTRL + RIGHT" for next
!^Right::Media_Next

; "CTRL + LEFT"  for previous 
!^Left::Media_Prev

; "CTRL + UP"  for pause
!^Up::Media_Play_Pause


!^D::
    Run, "C:\Users\Michael\Downloads"
Return


WhatIsIt?:
    SPI_GETMOUSE(accel, low, high)
    MsgBox Mouse acceleration settings-`n  accel:`t%accel%`n  low:`t%low%`n  high:`t%high%
return

!Z::    ; Enable acceleration.
!X::    ; Disable acceleration.
    SPI_SETMOUSE(A_ThisHotkey="!Z") ; i.e. 1 if ^NumpadAdd, 0 otherwise.
    gosub WhatIsIt?
return

^NumpadEnter::  ; Toggle acceleration.
    if SPI_GETMOUSE(accel)
        SPI_SETMOUSE(!accel)
    ;else an error occurred.
    gosub WhatIsIt?
return


; Get mouse acceleration level and low/high thresholds.
; Returns true on success and false on failure.
SPI_GETMOUSE(ByRef accel, ByRef low="", ByRef high="")
{
    VarSetCapacity(vValue, 12)
    if !DllCall("SystemParametersInfo", "uint", 3, "uint", 0, "uint", &vValue, "uint", 0)
        return false ; Fail.
    low := NumGet(vValue, 0)
    high := NumGet(vValue, 4)
    accel := NumGet(vValue, 8)
    return true
}

; Set mouse acceleration level and low/high thresholds.
; Supplies standard default values for low/high if omitted.
; fWinIni:  0 or one of the following values:
;           1 to update the user profile
;           2 to notify applications
;           3 to do both.
; Returns true on success and false on failure.
SPI_SETMOUSE(accel, low="", high="", fWinIni=0)
{
    VarSetCapacity(vValue, 12)
    , NumPut(accel
    , NumPut(high!="" ? high : accel ? 10 : 0
    , NumPut(low!="" ? low : accel ? 6 : 0, vValue)))
    return 0!=DllCall("SystemParametersInfo", "uint", 4, "uint", 0, "uint", &vValue, "uint", 0)
}

