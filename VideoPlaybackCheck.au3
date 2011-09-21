#include <Array.au3>

;_ShowCheckScope("CyberLink PowerDVD 11")


; Start Video playback and get 3 PixelCheckSum
; it will detec the video is playing or pausing
$StartVideoArray = _CheckVideoPlayback("CyberLink PowerDVD 11")
msgBox(0, "Action", "Click Next button")
sleep(3000)

; Go to Next video and also get 3 PixelCheckSum into Memory
$GetNextArray = _GetNextVideoPixel("CyberLink PowerDVD 11")
_ArrayDisplay($GetNextArray)
msgBox(0, "Action", "Click Previous button")
sleep(3000)

; Go to Previous video and check the PixelCheckSum of First Video
_CheckVideoPrevious("CyberLink PowerDVD 11", $StartVideoArray)
msgBox(0, "Action", "Click Next button")

; Go to Next video and check the PixelChecksum of Next Video
sleep(3000)
_CheckVideoNext("CyberLink PowerDVD 11", $GetNextArray)


;====================================================================================
; Function name : _CheckVideoPlayback
; Detected Playing or Pausing
; Recorded the 3 PixelChecksum of First Video into Array
;====================================================================================
Func _CheckVideoPlayback($appTitle)
	WinActivate($appTitle)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	Dim $BufArray[3]
	Dim $i = 0
	Dim $j = 0
	
	Sleep(5000)
	for $i = 0 to 2
		$BufArray[$i] = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		sleep(2000)
	Next

	;_ArrayDisplay($BufArray, "$avArray")
	
	_log("===================Start check video Playback===================")
	Do 
		$CheckArray = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		
		$iIndex = _ArraySearch($BufArray, $CheckArray, 0, 0, 0, 1)
		If @error Then
			_log("Playing" & ", " & $CheckArray)
			$i+=1
		Else
			_log("Pause" & ", " & $CheckArray)
			$j+=1
		EndIf
		
	Until $i = 100 or $j = 100
		
	if $i = 100 Then
		msgBox(0, "Video", "Video is playing")
	Else
		msgBox(0, "Video", "Video is pausing")
	EndIf	
	
	return $BufArray
EndFunc


;====================================================================================
; Function name : _GetNextVideoPixel
; Recorde 3 PixelCheckSum of Next Video clip into array 
;====================================================================================
Func _GetNextVideoPixel($appTitle)
	WinActivate($appTitle)
	;_ArrayDisplay($sArray)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	Dim $BufArrayForNext[3]
	Dim $i = 0
	Dim $j = 0

	sleep(5000)
	for $i = 0 to 2
		$BufArrayForNext[$i] = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		sleep(2000)
	Next

	Return $BufArrayForNext
EndFunc

;====================================================================================
; Function name : _CheckVideoPrevious
; Compare the 3 PixelChecksum of the first video and current video
; if match, it's previous video
; if does not match, it's not previous video
;====================================================================================
Func _CheckVideoPrevious($appTitle, $sArray)
	WinActivate($appTitle)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)


	Dim $i = 0
	Dim $j = 0
	;_ArrayDisplay($sArray)

	_log("===================Start check previous video===================")
	; Check Pixel Sum in loop 
	Do 
		$CheckArray = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		
		$iIndex = _ArraySearch($sArray, $CheckArray, 0, 0, 0, 1)
		If @error Then
			_log("Not Found" & ", " & $CheckArray & ", " & $sArray)

		Else
			_log("Found" & ", " & $CheckArray & ", " & $sArray)
			$j+=1
		EndIf
		
	Until $j = 3
	
		msgBox(0, "Check", "It's Previous Video")

EndFunc

;====================================================================================
; Function name : _CheckVideoNext
; Compare the 3 PixelChecksum with $GetNextArray
; if match, it's Next video
; if does not match, it's not Next video
;====================================================================================
Func _CheckVideoNext($appTitle, $sArray)
	_ArrayDisplay($sArray)
	WinActivate($appTitle)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	Dim $i = 0
	Dim $j = 0

	
	_log("===================Start check next Video===================")
	; Check Pixel Sum in loop 
	Do 
		$CheckArray = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		
		$iIndex = _ArraySearch($sArray, $CheckArray, 0, 0, 0, 1)
		If @error Then
			_log("Not Found" & ", " & $CheckArray & ", " & $sArray)

		Else
			_log("Found" & ", " & $CheckArray & ", " & $sArray)
			$j+=1
		EndIf
		
	Until $j = 3
	
		msgBox(0, "Check", "It's Next Video")

EndFunc

;====================================================================================
; Function name : _log
; File write into VideoCheck_log.txt
;====================================================================================
Func _log($log_String)
			$file = FileOpen(@ScriptDir & "\VideoCheck_log.txt", 9)

			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file.")
				Exit
			EndIf

			$time = @hour & ":" & @MIN

			FileWriteLine($file, $time & "	" & $log_string)
			FileClose($file)			
EndFunc


;====================================================================================
; Function name : _ShowCheckScope
; Display check scope on the App
;====================================================================================
Func _ShowCheckScope($appTitle)
	
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	DrawRectangle($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10, 0x111111)
EndFunc

Func DrawRectangle($xstart, $ystart, $xend, $yend, $color)
	
	For $x = $xstart to $xend
		For $y = $ystart to $yend
			PixelDraw($x, $y, $color)
		Next
	Next
EndFunc

Func PixelDraw($XCoord, $YCoord, $Color, $hwnd="GetDC")
	Local $PixelDraw
   
	$PixelDraw = DLLCall("user32.dll","long",$hwnd,"hwnd",0)
   
	DllCall("gdi32","long","SetPixel", "long", $PixelDraw[0], "long", $XCoord, "long", $YCoord, "long", $Color)
	If @error = 1 Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc