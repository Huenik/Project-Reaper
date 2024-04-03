
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
MsgBox, Latest Commit SHA: %latestCommit%


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
    ; Delete existing Rversion.txt
	FileDelete, Rversion.txt
    ; Append latest commit to Rversion.txt
	FileAppend, %latestCommit%, Rversion.txt
	fileappend, %localversion%`r, RversionHistory.txt
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
MsgBox,4,, Add to presets?

f3::exitapp