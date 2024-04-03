

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
; assign that to this var
latestCommit := GetLatestCommitSHA()
MsgBox, Latest Commit SHA: %latestCommit%


; Read local version from file
FileRead, localversion, %A_Temp%\Reaper\Rversion.txt

; Compare local and host versions
If (localversion = latestCommit)
	currentVersionStatus := 1
Else
	currentVersionStatus := 0

; Update local version with latest commit
MsgBox,,,Local Version = %localversion%`rHost Version = %latestCommit%`r`rUpdating locally.

; Delete existing Rversion.txt
FileDelete, %A_Temp%\Reaper\Rversion.txt

; Append latest commit to Rversion.txt
FileAppend, % "localversion = " . latestCommit, %A_Temp%\Reaper\Rversion.txt