struct GhostSetting
(
		--INIファイルチェック--
	fn GhostINIfilecheck =(
		if (doesFileExist GhostInifile) == false do(
			local firstsettype = "default"
			local secondsettype = "master"
			setINISetting GhostInifile "GHOST" "name" (firstsettype as String)
			setINISetting GhostInifile "GHOST" "variation" (secondsettype as String)
			)
	),

	fn fn_ghostname ini = (
		local getghostname = (getINISetting ini "GHOST" "name") as string
		if getghostname == "" then (
			ghostname = "default"
			)
		else (
			ghostname = getghostname
			)
		return ghostname
	),

	fn fn_ghostvariation ini = (
		local getghostvariation = (getINISetting ini "GHOST" "variation") as string
		if getghostvariation == "" then (
			ghostvariation = "master"
			)
		else (
			ghostvariation = getghostvariation
			)
		return ghostvariation
	),

	--パス宣言--
	fn fn_getGhostPath scriptroot namestring variationstring = (
		ghost_Path = scriptroot + "ghost\\" + namestring + "\\ghost\\" + variationstring + "\\" + "ghost.ms"
	),

	fn fn_getGhostShellPath scriptroot namestring variationstring = (
		shell_Path = scriptroot + "ghost\\" + namestring + "\\shell\\" + variationstring + "\\"
		shell_FullPath = getFilenamePath (shell_Path)
	),

	fn fn_getGhostBaloonPath scriptroot = (
		baloon_Path = scriptroot + "\\baloon\\"
		baloon_FullPath = getFilenamePath (baloon_Path)
	),

	fn fn_getGhostBordPath scriptroot namestring variationstring = (
		bord_Path = scriptroot + "ghost\\" + namestring + "\\bord\\" + variationstring + "\\"
		bord_FullPath = getFilenamePath (bord_Path)
	),

	fn fn_setghostname ini namestring  = (
		setINISetting ini "GHOST" "name" ( namestring as String)
	),

	fn fn_setghostvariation ini namestring = (
		setINISetting ini "GHOST" "variation" ( namestring as String)
	),

	--セリフテキスト用スクリプト読み込み--
	fn fn_loadghost pathstring = (
		filein (pathstring + "ghost.ms")
	),

	fn randomtxtset arg = (
		txt = ""
		r = dotnetobject "System.Random"
		i = r.Next(arg.count)
		if i == 0 do i = 1
		txt = arg[i] as string
	),

	fn fn_waitcounter stringarray timearg = (
		newarray =#()
		temp = #()
		if (findstring stringarray "\w[") != undefined then (
			newarray = filterstring stringarray "\w[*]"
			for i = 2 to (newarray.count - 1) by 2 do (
				append temp (newarray[i] as integer)
			)
			for i = temp.count to 1 by -1 do (
				deleteitem newarray (i * 2)
			)
			append temp timearg
		)
		else (
			newarray[1] = stringarray
			temp[1] = timearg
		)
		insertItem temp newarray 1
		return newarray
	)

)
