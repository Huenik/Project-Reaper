
; find the current version on github
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
FileRead, version.txt



; update local current version to match server current version
FileDelete, a_temp\Rversion.txt
FileAppend,localversion = %latestCommit%,a_temp\Rversion.txt