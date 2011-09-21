#include <Array.au3>

;_CheckVideoPlayback("CyberLink PowerDVD 11")
_CheckVideoNext("CyberLink PowerDVD 11")

;msgBox (0, "check", $BufArray[0] & ", " & $BufArray[1] & ", " & $BufArray[2])


Func _CheckVideoPlayback($appTitle)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	;DrawRectangle($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10, 0x111111)
	;msgBox (0, "test", $appCheckScopeX & ", " & $appCheckScopeY & ", " & $appCheckScopeX + 10 & ", " & $appCheckScopeY + 10)

	Dim $BufArray[3]
	Dim $i = 0
	Dim $j = 0

	for $i = 0 to 2
		$BufArray[$i] = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		sleep(2000)
		;$CheckArray[$i] = PixelChecksum($appCheckScopeX,$appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		;sleep(5000)
	Next


	_ArrayDisplay($BufArray, "$avArray")

	If $BufArray[0] == $BufArray[1] AND $BufArray[1] == $BufArray[2] then
			msgBox(0, "warning", "It's pause")
		Else
			msgBox(0, "Warning", "Playback")
	EndIf
EndFunc


Func _CheckVideoNext($appTitle)
	$appPos = WinGetPos ($appTitle, "")
	$appLoc = ControlGetPos($appTitle, "", "") ; $pos[2] : Width  ; $pos[3] : Height

	$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
	$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

	Dim $BufArray[3]
	Dim $i = 0
	Dim $j = 0

	
	for $i = 0 to 2
		$BufArray[$i] = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		sleep(2000)
		;$CheckArray[$i] = PixelChecksum($appCheckScopeX,$appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		;sleep(5000)
	Next
	
	
	Do 
		$CheckArray = PixelChecksum($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10)
		
		$iIndex = _ArraySearch($BufArray, $CheckArray, 0, 0, 0, 1)
		If @error Then
			_log("Not Found" & ", " & $CheckArray)
		Else
			_log("Found" & ", " & $CheckArray)
			$j+=1
		EndIf
		
	Until $j = 3
	
	msgBox(0, "stop", "Stop check")
	
	


EndFunc


Func _log($log_String)
			$file = FileOpen(@ScriptDir & "\PowerDVD_Remote_log.txt", 9)

			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file.")
				Exit
			EndIf

			$time = @hour & ":" & @MIN

			FileWriteLine($file, $time & "	" & $log_string)
			FileClose($file)			
EndFunc
