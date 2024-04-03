
SetWorkingDir, %A_Temp%\Reaper\


; find the current main version on github
GetLatestCommitSHA() {
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	url := "https://github.com/Huenik/Project-Reaper/commit/main"
	oHTTP.Open("GET", url)
	oHTTP.Send()
	html := oHTTP.ResponseText
	startIndex := InStr(html, "<span class=""sha user-select-contain"">") + StrLen("<span class=""sha user-select-contain"">")
	endIndex := InStr(html, "</span>", false, startIndex)
	commitSHA := SubStr(html, startIndex, endIndex - startIndex)
	return commitSHA
}
htmlModset() {
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	url := "https://raw.githubusercontent.com/Huenik/Project-Reaper/main/modset.html"
	oHTTP.Open("GET", url)
	oHTTP.Send()
	html := oHTTP.ResponseText
	return html
}

; assign that to this var
latestCommit := GetLatestCommitSHA()

; Read local version from file
FileRead, localversion, Rversion.txt

; Compare local and host versions
If (localversion = latestCommit) {
	currentVersionStatus := 1
	MsgBox,,,Local Version = %localversion%`rHost Version = %latestCommit%`r`rLocal Version matches Host.`rExiting
	goto, Uptodate
} Else {
	currentVersionStatus := 0
    ; Display message box indicating update
	MsgBox,,,Local Version = %localversion%`rHost Version = %latestCommit%`r`rUpdating locally.
	goto, Outdated
}

Uptodate:
exitapp

Outdated:
;download update
; gather html modset

htmlName := A_DD . A_MM . A_YYYY
modsetHtmlText := htmlModset()
FileAppend, %modsetHtmlText%, modsets\%localversion%.html
;once done silently check for update again.

;add to arma Presets offer
MsgBox, 4,Add to Presets?, Would you like to add the new version to your ARMA3 presets? (press Yes or No)
IfMsgBox Yes
	goto,modlist_preset_injector
else
	goto, updated

modlist_preset_injector:

filename = %A_DD%/%A_MM% %latestCommit%
MsgBox,,Preset Naming,Your preset will be called %filename%

pattern := "<a href=""(https:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?id=\d+)"""
matches := [] ; Initialize an empty array to store matches

currentPosition := 1
while (currentPosition := RegExMatch(modsetHtmlText, pattern, match, currentPosition)) {
    ; Remove the first 55 characters from the match
	match1 := SubStr(match1, 56)
    ; Append "<id>steam: " to the start and "</id>" to the end of each match
	match1 := "<id>steam:" . match1 . "</id>"
	matches.Push(match1)
	currentPosition += StrLen(match) ; Move to the next position after the current match
}

line1 =<?xml version="1.0" encoding="utf-8"?>
line2 =<addons-presets>
line3 =  <last-update>2023-11-19T16:23:43.4408522+10:30</last-update>
line4 =   <published-ids>

line5 =  </published-ids>
line6 =  <dlcs-appids />
line7 =</addons-presets>

FileDelete,file.txt
FileAppend,%line1%`n,file.txt
FileAppend,%line2%`n,file.txt
FileAppend,%line3%`n,file.txt
FileAppend,%line4%`n,file.txt

if (matches.Length()) {
    ; Display all matches
	for index, value in matches {
		FileAppend,    %value%`n  ,file.txt
		MsgBox,,Success,Preset made successfully.,2
	}
} else {
	MsgBox,,Error001," Unable to create preset2 file, error001",5
	goto, updated
}
FileAppend,%line5%`n,file.txt
FileAppend,%line6%`n,file.txt
FileAppend,%line7%,file.txt

dest := A_AppData . "\Local\Arma 3 Launcher\Presets\" . fileName . ".preset2"
FileMove, file.txt, %dest%
; this changes the file extension to preset2 and places it in the default arma3 presets folder

MsgBox,,All Done, Check your ARMA3 launcher for the preset you named %fileName%.
;~~~

updated:
; Delete existing Rversion.txt
FileDelete, Rversion.txt
    ; Append latest commit to Rversion.txt
FileAppend, %latestCommit%, Rversion.txt
fileappend, %localversion%`r, RversionHistory.txt
MsgBox,,Updated,Updated from %localversion%,`r To the newer %latestCommit%.
; end of updating locally



exitapp
f3::exitapp


/*
Errors:
001	Preset2 file unable to be created due to no matches found in variable modsetHtmlText. said html text comes from 
	https://github.com/Huenik/Project-Reaper/blob/main/modset.html. If no mods are in said html modset, then no matches possible.

*/