

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


; what is the local version?
localversionFilePath := a_temp\Reaper\Rversion.txt
FileRead,localversion,localversionFilePath

; update local version to host current version
MsgBox,,,Local Version = %localversion%`rHost Version = %latestCommit%`r`rUpdating localle.
FileDelete, a_temp\Reaper\Rversion.txt
FileAppend,localversion = %latestCommit%,localversionFilePath
