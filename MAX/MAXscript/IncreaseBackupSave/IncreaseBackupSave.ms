macroScript IncreaseBackupSave category:"File" internalCategory:"File" toolTip:"IncreaseBackupSave" buttonText:"IBS"
(
    if maxFileName != "" then (
		
		
		vernum = 1
		oldPath = maxFilePath + @"_old\" + (getFilenameFile maxFileName) + "_v01" + ".max"
		nextPath = maxFilePath + @"_old\" + (getFilenameFile maxFileName) + "_v0"+ (vernum as string) + ".max"
		
		
		if doesFileExist oldPath then (
			
			while doesFileExist nextPath do (
				vernum = vernum + 1
				nextPath = maxFilePath + @"_old\" + (getFilenameFile maxFileName) + "_v0"+ (vernum as string) + ".max"
				
			)
				
				copyFile (maxFilePath + maxFileName) nextPath
				print nextPath
		)
			
		
		else (
			makeDir (maxFilePath + @"_old\")
			copyFile (maxFilePath + maxFileName) oldPath
			print oldPath
		)
		
		maxPrefFile = maxFilePath + maxFileName
		saveMaxFile maxPrefFile

    ) else checkForSave()
)