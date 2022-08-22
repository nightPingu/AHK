; #NoEnv  
#SingleInstance Force ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn All, OutputDebug ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/**
 * Required AHK v2
 * 	made with Version 2.0-beta.3
 * 
 * Simple utility to darken monitors.
 * 
 * Hotkeys are auto generate based on monitor numeric id
 * 	Example: WindowsButton+1 -> darken monitor 1
 * 
 * Monitor does not need to support ddc/ci.
 *  This tool creates a simple transparent overlay to darken screen.
 * 
 */

 TRANSPARENCY := 180 ; Value between 0 - 255. 255 being complete black 

Loop MonitorGetCount()
{
	key := "#" A_Index
	Hotkey key, (ThisHotkey) => activateOverlay(ThisHotkey) ;
}

createOverlay()
{ 
	o := Gui()
	o.BackColor := "000000"
	WinSetTransparent(180, o) ; numeric value 
	o.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner +MinSize640x480 -Caption")

	WinSetExStyle "+0x20", o ; 0x20 = WS_EX_CLICKTHROUGH
	WinSetExStyle "^0x80", o ; ^0x80 = WS_EX_TOOLWINDOW exclide from alt+tab list

	return o

}


overLays := Map()

activateOverlay(hotkey)
{ 

	monitorIndex := SubStr(hotkey, 2, 1) ;

	if overLays.Has(monitorIndex) {
		overlay := overLays.Get(monitorIndex)
	} else {
		overlay := { gui:createOverlay(), visible: false}
		overLays.Set(monitorIndex, overlay)
	}

	if (overlay.visible) {
		overlay.gui.Hide()
		overlay.visible := false
	} else {
		overlay.visible := true

		MonitorGet monitorIndex, &L, &T, &R, &B
		MonitorGetWorkArea monitorIndex, &WL, &WT, &WR, &WB

		overlay.gui.Show(Format("y{1} x{2} w{3} h{4}", WT, WL, Abs(L-R), Abs(T-B)))
	}

}
