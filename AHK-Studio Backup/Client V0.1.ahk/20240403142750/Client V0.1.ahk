GetLatestCommitSHA() {
    ; Create a WinHttpRequest object
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	
    ; Specify the URL of the GitHub commit page
	url := "https://github.com/Huenik/Project-Reaper/commit/main"
	
    ; Send a GET request to the URL
	oHTTP.Open("GET", url)
	oHTTP.Send()
	
    ; Extract the response text (HTML content)
	html := oHTTP.ResponseText
	
    ; Find the index of the start and end of the commit SHA within the HTML
	startIndex := InStr(html, "<span class=""sha user-select-contain"">") + StrLen("<span class=""sha user-select-contain"">")
	endIndex := InStr(html, "</span>", false, startIndex)
	
    ; Extract the commit SHA from the HTML
	commitSHA := SubStr(html, startIndex, endIndex - startIndex)
	
	return commitSHA
	
	; Call the function to get the latest commit SHA
	latestCommit := GetLatestCommitSHA()
}



; Display the latest commit SHA
MsgBox, Latest Commit SHA: %latestCommit%
