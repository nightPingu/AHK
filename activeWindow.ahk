; #NoEnv  
#SingleInstance Force ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn All, OutputDebug ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; moves active window to monitor1 center.
; MoveActiveWindowToCenterOfMonitor
#c::
{ 

    if WinExist("A") {
        WinGetPos ,, &sizeX, &sizeY
        WinMove (A_ScreenWidth/2)-(sizeX/2), (A_ScreenHeight/2)-(sizeY/2)
    }

}

; Set window size to half of monitor
; ToggleWindowSize
#x:: 
{

    if WinExist("A") {
        active_id := WinGetID("A")
        WinGetPos &X, &Y, ,, active_id

        WinMove X, Y, A_ScreenWidth/2, A_ScreenHeight/2, active_id

    }
}

; Move window to mouse
; MoveActiveWindowToMouse
#z:: {
    if WinExist("A") { ; sets 'Last Found Window'
        WinGetPos ,, &sizeX, &sizeY ;
        CoordMode("Mouse","Screen") ; makes MouseGetPos get cords relative to monitor.
        MouseGetPos &xpos, &ypos 
        WinMove xpos - (sizeX/2), ypos - (sizeY/2)
    }
    return
}








; MinimizeAllButActiveWindowOnActiveMonitor
#d:: {
    if WinExist("A") { ; sets 'Last Found Window'
        activeWin := WinGetID("A")
        activeMon := GetMonitorIndexFromWindow(activeWin)
        if(activeMon == -1) {
            return ; Could not determid monitor
        }

        windowsIds := WinGetList(,, "Program Manager")

        for windowId in windowsIds {
            title := WinGetTitle(windowId)
            hwnd := WinGetControlsHwnd(windowId)

            If ( hwnd != "", title != "" && activeWin != windowId && WinGetMinMax( windowId) >= 0 ) {


                foo := GetMonitorIndexFromWindow(windowId)                
                if (foo >= 0 && foo == activeMon) {
                    WinMinimize(title)
                }            
            }
        }   


    }

}



/**
 * Only works if window only overlaps single monitor.
 */
GetMonitorIndexFromWindow(windowHandle)
{

    WinGetPos &L, &T, &Width, &Height, windowHandle
    B := T + Height
    R := L + Width

    Loop MonitorGetCount()
    {
        MonitorGet A_Index, &WL, &WT, &WR, &WB

        horizontalOverlap :=  L > WL && R < WR ;
        verticalOverlap :=  T > WT && B < WB ;
        if(horizontalOverlap && verticalOverlap) {
            return A_Index
        }
    }

    return -1
} 
