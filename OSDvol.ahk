; Make customisation only in this area or hotkey area!!

; Change the part after the = to the name of your device in the Sound control panel
; It will match partial names so make the device names distinctive

DesktopMicrophone = Microphone
DesktopSpeakers = Desktop Speakers

HeadsetMicrophone = Microphone
HeadsetSpeakers = Headset Speakers

; If your keyboard has multimedia buttons for Volume, you can
; try changing the below hotkeys to use them by specifying
; Volume_Up, ^Volume_Up, Volume_Down, and ^Volume_Down
; The format for the below lines is:
; HotKey, <the hotkey that you want to use>, <the function which it should call>
; You'll probably only want to change the middle section
; If you want to use this script just for switching audio devices,
; you can comment out the HotKey ... vol_MasterUp/Down lines 

HotKey, #F11, vol_MasterDown
HotKey, #F12, vol_MasterUp

; This is the hotkey for switching between devices
HotKey, Volume_Mute, Toggle_Default_Devices

; The percentage by which to raise or lower the volume each time:
vol_Step = 10

; How long to display the volume level bar graphs:
vol_DisplayTime = 2000

; Master Volume Bar color (see the AHK help to use more
; precise shades):
vol_CBM = Lime

; Background color
vol_CW = 222222

; Bar's screen position.  Use -1 to center the bar in that dimension:
vol_PosX = -1
vol_PosY = 1200
vol_Width = 200  ; width of bar
vol_Thick = 20   ; thickness of bar

; Opacity of the bar. 0 for completely transparent, 255 for completely opaque
vol_Opacity = 192

;OnMessage(0x4213, Toggle_Default_Devices)

; Shouldn't be any need to edit below this point unless you want to change functionality

; This script resets the sound device to speakers when it starts.
; The next line sets the icon accordingly
; If you want to change the icons, search for the word Icon and change each instance
; there will be 3 instances
Menu, Tray, Icon, C:\Windows\system32\DDORes.dll,92 ;default is speaker icon

;___________________________________________ 
;_____Auto Execute Section__________________ 

; DON'T CHANGE ANYTHING HERE (unless you know what you're doing).

;A window to receive messages
;Gui, show, Hide, OSDVol

;Set Desktop speakers and mic as default
VA_SetDefaultEndpoint(DesktopSpeaker, 0)
VA_SetDefaultEndpoint(DesktopSpeaker, 2)
VA_SetDefaultEndpoint(DesktopMicrophone, 0)
VA_SetDefaultEndpoint(DesktopMicrophone, 2)

;SETS THE TRAY ICON, ADDS AN OPTION TO RUN THE SCRIPT FROM THE TRAY
;Menu, Tray, NoStandard				;?
;Menu, Tray, Add, &Switch Playback Device, Toggle_Default_Devices	;add tray option
;Menu, Tray, Add, 				;add blank line
;Menu, Tray, Standard				;?
;Menu, Tray, Default, &Switch Playback Device	;default option is new option

;COM_Init()
DetectHiddenWindows, on

Process, Exist
vol_Window = %vol_Title% ahk_class AutoHotkey2 ahk_pid %ErrorLevel%

vol_BarOptionsMaster = 1:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBM% CW%vol_CW%

; If the X position has been specified, add it to the options.
; Otherwise, omit it to center the bar horizontally:
if vol_PosX >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% X%vol_PosX%
}

; If the Y position has been specified, add it to the options.
; Otherwise, omit it to have it calculated later:
if vol_PosY >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% Y%vol_PosY%
}

#SingleInstance
SetBatchLines, 10ms

Return

;___________________________________________ 

vol_MasterUp:
vol_tmp := VA_GetMasterVolume()
vol_tmp := (vol_tmp + vol_Step)
Transform, vol_Master, Round, %vol_tmp%
if vol_Master > 100
{
  vol_Master = 100
}
VA_SetMasterVolume(vol_Master)
Gosub, vol_ShowBars
return

vol_MasterDown:
vol_tmp := VA_GetMasterVolume()
vol_tmp := (vol_tmp - vol_Step)
Transform, vol_Master, Round, %vol_tmp%
if vol_Master < 0.1
{
  vol_Master = 0
  VA_SetMasterVolume(0.01)
}
else
  VA_SetMasterVolume(vol_Master)
Gosub, vol_ShowBars
return

vol_ShowBars:
IfWinNotExist, %vol_Window%
{
    Progress, %vol_BarOptionsMaster% P%vol_Master%, , , %vol_Title%
    WinExist(vol_Window) ; Set Last Found Window.
    WinSet, Transparent, %vol_Opacity%
;    WinSet, TransColor, %vol_CW% %Vol_Opacity%
;    WinSet, TransColor, %vol_CBM% %Vol_Opacity%
}
Progress, 1:%vol_Master%
SetTimer, vol_BarOff, %vol_DisplayTime%
return

vol_BarOff:
SetTimer, vol_BarOff, off
Progress, 1:Off
return

Toggle_Default_Devices:
Toggle := !Toggle

if (!Toggle) {
VA_SetDefaultEndpoint(DesktopSpeakers, 0)
VA_SetDefaultEndpoint(DesktopSpeakers, 2)
VA_SetDefaultEndpoint(DesktopMicrophone, 0)
VA_SetDefaultEndpoint(DesktopMicrophone, 2)
Menu, Tray, Icon, C:\Windows\system32\DDORes.dll,92
}
else {
VA_SetDefaultEndpoint(HeadsetSpeakers, 0)
VA_SetDefaultEndpoint(HeadsetSpeakers, 2)
VA_SetDefaultEndpoint(HeadsetMicrophone, 0)
VA_SetDefaultEndpoint(HeadsetMicrophone, 2)
Menu, Tray, Icon, C:\Windows\system32\DDORes.dll,94
}
return
