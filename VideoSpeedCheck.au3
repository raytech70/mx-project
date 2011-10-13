#include <Array.au3>
#include <ImageSearch.au3>

opt("SendKeyDelay", 100)

; Start normal playback and get the return number
$VideoNormalSpeed = _VideoSpeed("CyberLink PowerDVD 11", 1)
Send("{S}")
sleep(1000)
Send("{ENTER}")
Sleep(500)

; Check with any speed Fast Forward or Rewind : 1.1, 1.2, 1.5, 2, 3, 4, 8, 16, 32
$VideoXSpeed = _VideoSpeed("CyberLink PowerDVD 11", 16)

$SpeedResult = $VideoXSpeed / $VideoNormalSpeed

if $SpeedResult >= 0.8 Then
	MsgBox(0, "Speed", "It's 1.1x Speed")
ElseIf $SpeedResult >= 0.7 Then
	MsgBox(0, "Speed", "It's 1.2x Speed")
ElseIf $SpeedResult >= 0.6 Then
	MsgBox(0, "Speed", "It's 1.5x Speed")
ElseIf $SpeedResult >= 0.4 Then
	MsgBox(0, "Speed", "It's 2x Speed")
ElseIf $SpeedResult >= 0.28 Then
	MsgBox(0, "Speed", "It's 3x Speed")
ElseIf $SpeedResult >= 0.2 Then
	MsgBox(0, "Speed", "It's 4x Speed")
ElseIf $SpeedResult >= 0.1 Then
	MsgBox(0, "Speed", "It's 8x Speed")
ElseIf $SpeedResult >= 0.05 Then
	MsgBox(0, "Speed", "It's 16x Speed")
ElseIf $SpeedResult >= 0.005 Then
	MsgBox(0, "Speed", "It's 32x Speed")
Else
	MsgBox(0, "Speed", "Unknow speed")
EndIf

Send("{S}")
sleep(1000)

_log("Value" & "  " & "1x: " & $VideoNormalSpeed & " " & "Defind X: " & $VideoXSpeed , "SpeedValue")

;====================================================================================
; Function name 	: _VideoSpeed
; Description		: Check All Speed with FastForward and Rewind the video
; Parameter(s)		: $appTitle - App's Title ; $speed - 1, 1.1, 1.2, 1.5, 2, 4, 8, 16, 32
; Return Value(s)	: $j, it only return the number of all PixelChecksum with any Speed
;====================================================================================
Func _VideoSpeed($appTitle, $speed)

	WinActivate($appTitle)
	;_ArrayDisplay($sArray)
	
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)
	
	Dim $BufArray[3]
	$x1 = 0
	$y1 = 0
	$x2 = 0
	$y2 = 0
	$i = 0
	$j = 0


	$StartCheckSum = _WaitForImageSearch(".\image\Duration_Start.png", 5, 1, $x1, $y1, 0)
	sleep(500)
	if $StartCheckSum = 1 Then
		
;~ 		for $i = 0 to 2
;~ 			$BufArray[$i] = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
;~ 		Next

		if $speed = 1 Then
			;
		ElseIf $speed = 1.1 Then
			Send("{F}")
		ElseIf $speed = 1.2 Then
			Send("{F 2}")
		ElseIf $speed = 1.5 Then
			Send("{F 3}")
		ElseIf $speed = 2 Then
			Send("{F 4}")
		ElseIf $speed = 3 Then
			Send("{F 5}")
		ElseIf $speed = 4 Then
			Send("{F 6}")
		ElseIf $speed = 8 Then
			Send("{F 7}")
		ElseIf $speed = 16 Then
			Send("{F 8}")
		ElseIf $speed = 32 Then
			Send("{F 9}")
		Else
			MsgBox(0, "Waring", "Nothing happen")
		EndIf

		sleep(500)
		Do 
			$CheckArray = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
			
			$j+=1

			$StopCheckSum = _ImageSearch(".\image\Duration_Center.png",0,$x2,$y2,0) or _ImageSearch(".\image\Duration_Center2.png",0,$x2,$y2,0)
		Until $StopCheckSum = 1
		
		;msgBox(0, "Found", "Stop playback")	
	Else
		MsgBox(0,"No Found","NONONONONONOONONO")
	EndIf
	;msgBox (0, "array", $j)
	return $j
EndFunc


;====================================================================================
; Function name : _log
; File write into VideoCheck_log.txt
;====================================================================================
Func _log($log_String, $fileName)
			$file = FileOpen(@ScriptDir & "\" & $fileName & ".txt", 9)

			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file.")
				Exit
			EndIf

			$time = @hour & ":" & @MIN

			;FileWriteLine($file, $time & "	" & $log_string)
			FileWriteLine($file, $log_string)
			FileClose($file)			
EndFunc