#SingleInstance, Force
CoordMode, Mouse Pixel, Relative

SetWorkingDir %A_ScriptDir%

; read from file
FileRead, fileText, colorrefinfo.txt
;StringGetPos, 
msgbox, %fileText%

; Global Variables
;-----------------
global TurnX := 1557, TurnY := 508, YellowColor, GreenColor, colorRef = false

; Gui Layout
;---------------
;Gui, Font, s50
Gui Add, Text, ,  Choose a script profile

Gui, Add, Radio, vRadio1 x10 y40, Auto Turn
Gui, Add, Radio, vRadio2, Auto Turn Hero Power
Gui, Add, Radio, vRadio3, Auto Turn Mage Attack
Gui, Add, Radio, vRadio4 x150 y40, Auto Turn Druid Attack
Gui, Add, Radio, vRadio5, Auto Turn Paladin Attack
Gui, Add, Radio, vRadio6, Auto Turn Rogue Attack

Gui, Add, Button, vBut2 gSet_Button_Colors h30 w400 x50 y225, Set color references (F3) 
Gui, Add, Button, vBut1 gStart_Script h30 w400 x50 y260, Start Script (F2)
Gui, Add, Text, x50 y180 cRed, F5 to force close program

Gui +AlwaysOnTop
Gui, show, w500 h300 x150 y10, AutoClicker

return

; Label
;-------------

GuiClose:
	ExitApp
	return
Start_Script:
	Gui, Submit, NoHide
	if(colorRef = false){
		MsgBox, 48, Error, Please set color references
		return
	}
	if(Radio1 = 1){ ; auto turn
		Gui Minimize
		GuiControl, Disable, But1
		Gui, Submit, NoHide
		
		msgbox, 3, Initiate Script, Are you ready to initiate the script?
		IfMsgBox, Yes
			isReady = true
		else
			isReady = false
			GuiControl, Enable, But1
			Gui Restore
		
		if(%isReady%){
			MsgBox, , Script Running, The script has initialized. Press F1 to end the script, 2
			GoSub, Auto_Turn_Script
		}
	}
	else if(Radio2 = 1){ ; auto hero power
		Gui Minimize
		GuiControl, Disable, But1
		Gui, Submit, NoHide
		
		msgbox, 3, Initiate Script, Are you ready to initiate the script?
		IfMsgBox, Yes
			isReady = true
		else
			isReady = false
			GuiControl, Enable, But1
			Gui Restore
		
		if(%isReady%){
			MsgBox, , Script Running, The script has initialized. Press F1 to end the script, 2
			GoSub, Auto_Hero_Turn_Script
		}
	}
	else if(Radio3 = 1){ ; auto mage
		Gui Minimize
		GuiControl, Disable, But1
		Gui, Submit, NoHide
		
		msgbox, 3, Initiate Script, Are you ready to initiate the script?
		IfMsgBox, Yes
			isReady = true
		else
			isReady = false
			GuiControl, Enable, But1
			Gui Restore
		
		if(%isReady%){
			MsgBox, , Script Running, The script has initialized. Press F1 to end the script, 2
			GoSub, Auto_Turn_Mage
		}
	}
	else if(Radio4 = 1){ ; auto druid
		Gui Minimize
		GuiControl, Disable, But1
		Gui, Submit, NoHide
		
		msgbox, 3, Initiate Script, Are you ready to initiate the script?
		IfMsgBox, Yes
			isReady = true
		else
			isReady = false
			GuiControl, Enable, But1
			Gui Restore
		
		if(%isReady%){
			MsgBox, , Script Running, The script has initialized. Press F1 to end the script, 2
			GoSub, Auto_Turn_Druid
		}
	}
	else
		MsgBox, 48, Error, Please select a profile to start script
	return
Set_Button_Colors:
	Gui Minimize
	GuiControl, Disable, But2
	FileDelete, colorrefinfo.txt
	msgbox, 4096, Set Color References, Click anywhere on Hearthstone to set color references.  `n`nPress 'y' when the TURN BUTTON is YELLOW`nPress 'g' when the TURN BUTTON is GREEN.`n`nPress Ok to continue
	keyF10 = false
	keyF11 = false
	while(!(%keyF10% &&	%keyF11%)) {
		if(GetKeyState("y", "P")){
			PixelGetColor, YellowColor, TurnX, TurnY, Fast
			keyF10 = true
			
		}
		if(GetKeyState("g", "P")){
			PixelGetColor, GreenColor, TurnX, TurnY, Fast
			keyF11 = true
		}
	}
	FileAppend,
	(
[Coordinate Color Values]
TurnButtonY=%YellowColor%
TurnButtonX=%GreenColor%
	),colorrefinfo.txt
	
	colorRef = true
	GuiControl, Enable, But2
	Gui Restore
	
	return
Auto_Hero_Turn_Script:
	BreakLoop = 0
	Loop{
		if(BreakLoop = 1){
			break
			GuiControl, Enable, But1
			Gui, Restore
		}
		if(Turn())
		{
			Sleep, 300
			MouseMove, 1134, 828 ; hero button
			Click
			Sleep, 200
			MouseMove, 1552, 499 ; turn button
			Click
			Sleep, 1000
		}
	}
	return
Auto_Turn_Script:
	BreakLoop = 0
	Loop{
		if(BreakLoop = 1){
			break
			GuiControl, Enable, But1
			Gui, Restore
		}
		if(Turn())
		{
			Sleep, 300
			MouseMove, 1552, 499 ; turn button
			Click
			Sleep, 1000
		}
	}
	return
Auto_Turn_Mage:
	BreakLoop = 0
	Loop{
		if(BreakLoop = 1){
			break
			GuiControl, Enable, But1
			Gui, Restore
		}
		if(Turn())
		{
			Sleep, 200
			MouseMove, 1134, 828 ; hero button
			Click
			Sleep, 200
			MouseMove, 968, 221 ; face
			Sleep, 200
			Click
			Sleep 500
			MouseMove, 1552, 499 ; turn button
			Click
			Sleep, 1000
		}
	}
	return
Auto_Turn_Druid:
	BreakLoop = 0
	Loop{
		if(BreakLoop = 1){
			break
			GuiControl, Enable, But1
			Gui, Restore
		}
		if(Turn())
		{
			Sleep, 200
			MouseMove, 1134, 828 ; hero button
			Click
			Sleep, 200
			MouseMove, 962, 829 ; my face
			click
			Sleep, 200
			MouseMove, 968, 221 ; enemy face
			Sleep, 200
			Click
			Sleep, 500
			MouseMove, 1552, 499 ; turn button
			Click
			Sleep, 1000
		}
	}
	return
; Functions
;----------------

Turn()
{
	PixelGetColor, color, TurnX, TurnY, Fast
	if(color = YellowColor || color = GreenColor)
	{
		return true
	}
	
}

; Hotkeys
;----------------

F1::
	BreakLoop = 1
	return

F2::
	GoSub, Start_Script
	return
F3::
	GoSub, Set_Button_Colors
	return
F5::
	ExitApp
	return