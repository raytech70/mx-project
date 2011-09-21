#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <array2.au3>


$appPos = WinGetPos ("CyberLink SoftDMA", "")
$appLoc = ControlGetPos("CyberLink SoftDMA", "", "") ; $pos[2] : Width  ; $pos[3] : Height

$appCheckScopeX = $appPos[0] + ($appLoc[2] / 2)
$appCheckScopeY = $appPos[1] + ($apploc[3] / 2)

DrawRectangle($appCheckScopeX, $appCheckScopeY, $appCheckScopeX + 10, $appCheckScopeY + 10, 0x111111)
;msgBox (0, "test", $appCheckScopeX & ", " & $appCheckScopeY & ", " & $appCheckScopeX + 10 & ", " & $appCheckScopeY + 10)

Dim $MyArray[3][3]
Dim $BufArray[3][3]
Dim $i = 0
Dim $j = 0




#cs
for $i = 0 to 7
	for $j = 0 to 7
		$MyArray[$i][$j] = PixelGetColor($appCheckScopeX, $appCheckScopeY)
		$appCheckScopeY +=1
	Next
	$appCheckScopeX +=1
Next


while 1
    $iX = $appCheckScopeX
    $iY = $appCheckScopeY
    ;$iC = PixelGetColor($iX, $iY)
	
	for $i = 0 to 2
		for $j = 0 to 2
			$BufArray[$i][$j] = PixelGetColor($appCheckScopeX, $appCheckScopeY)
			$appCheckScopeY +=1
		Next
		$appCheckScopeX +=1
	Next
	If _ArraySearch($aArray_Dynamic, $aArray_Static[$i]) <> -1 Then

        MsgBox(0, "Found!", $aArray_Static[$i])  ; Do something with $aArray_Static[$i]
	
	_ArrayDisplay($BufArray, "$avArray as a 2D array")
	
	$posT = _ArraySearch2d($my2dArray, $what2Find, 0, 0, -1, -1, 0, False)
	If Not @error Then
    MsgBox(0, "", $what2Find & " is found in row " & $pos[0] & " Column " & $pos[1] & @CRLF & _
            "$my2dArray[" & $pos[0] & "][" & $pos[1] & "] = " & $what2Find)
Else
    MsgBox(0, "", "Error " & @error)
EndIf
WEnd	

#ce




#cs
for $x =  $appCheckScopeX to $appCheckScopeX + 9
    for $y = $appCheckScopeY to $appCheckScopeY + 9
        $MyArray[$i][$j] = pixelgetcolor($x, $y)
		$j+=1
		;msgBox (0, "test", $x & ", " & $y)
    Next
Next
#ce





Func checkVideoPlayback()
EndFunc



Func getHash() ; useful to get hash of pixels surrounding our desired pixel
    Local $x = 37
    Local $y = 223
    $checksum = PixelChecksum($x, $y, $x+3, $y+3)
    MsgBox(1, "hash", $checksum )
EndFunc



Func _CompareArray($pPixel1, $pPixel2, $pAccuracy = 0.95)
    Local $minX = _Min(UBound($pPixel1,1), UBound($pPixel2,1))
    Local $minY = _Min(UBound($pPixel1,2), UBound($pPixel2,2))
    
    Local $iDiff = 0
    Local $iTotal = ($minX) * ($minY)
    
    For $x = 0 to $minX-1
        For $y = 0 to $minY-1
            If ( $pPixel1[$x][$y] <> $pPixel2[$x][$y] ) Then
                $iDiff += 1
            EndIf
        Next
    Next
    
    $a = ( $iDiff / $iTotal )
    If ( $a < (1-$pAccuracy) ) Then ; Returns true based on a 95% match ( parameter $pAccuracy )
        Return 1
    Else
        Return 0
    EndIf
EndFunc


;/////////////////////



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