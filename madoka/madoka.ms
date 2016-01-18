/*******************************************************
MAXScript + DotNet Knowledge Anchoring Program
CharacterScriptSeries "madoka"
********************************************************
Name: 支援スクリプト『まどか』
Created By:+NRSE(成瀬　澪)
twitter @__NRSE
*******************************************************/
macroScript CSS_madoka category:"madoka" toolTip:"madoka" Icon:#("madoka",1)
(
	--ゴースト格納用グローバル変数-----------------------------------------------------------
	global ghost_Temp
	global loadghostsetting
	global ghostname
	global ghostvariation
	--バルーン用フォーム----------------------------------------------------------------
	local baloonFrm = dotNetObject "System.Windows.Forms.Form"
	--セリフテキスト用ラベル-------------------------
	local txtLabel = dotNetObject "label"
	--メインフォーム（本体）--------------------------------------------------------------
	local MainFrm = dotNetObject "System.Windows.Forms.Form"
	--本体Shell-------------------------
	local imgview = dotNetObject "System.Windows.Forms.PictureBox"
	--バルーン表示用タイマー
	local settimer = dotnetobject "System.Windows.Forms.Timer"
	settimer.Interval = 180000 -- every 180s
	--2時間タイマー--
	local timer2H = dotnetobject "System.Windows.Forms.Timer"
	timer2H.Interval = 7200000 --every 2H
	-- バルーンハイド用タイマー
	local hidetimer = dotnetobject "System.Windows.Forms.Timer"　
	hidetimer.Interval = 1000 -- every 1s
	local hidecounter = 0 --ハイド用カウンタ
	local hideintervaltime = 10 --インターバル時間（カウント数）
---------------------------------------------------------------------------------------------------------------------------------------------
	--ルート宣言--
	local scriptroot = "$scripts\\madoka\\"
	--ini設定宣言--
	local myInifile = "$scripts\\madoka\\setting.ini"

	--セリフテキスト用スクリプト読み込み--
	fn loadghost pathstring = (
		filein (pathstring + "ghost.ms")
	)

	--画像取得関数--
	fn collectFiles folder: extensions: = (
		sioDir = dotNetClass "System.IO.Directory"
		sioSOpt = (dotNetClass "System.IO.SearchOption").AllDirectories
		allFiles = sioDir.GetFiles folder "*.*" sioSOpt
		for f in allFiles where findItem extensions (tolower (getfilenametype f)) > 0 collect f
	)

	--バルーンハイド用関数-----------------------
	fn hidebaloon sender e = (
		baloonFrm.hide()
		MainFrm.Refresh()
	)

	--テキストセッティング----------------------------------
	local nomaltxt = #("null") 	----テキスト初期化
	local SPtxt = #("null") 	----テキスト初期化

	fn randomtxtset arg = (
		txt = ""
		r = dotnetobject "System.Random"
		i = r.Next(arg.count)
		if i == 0 do i = 1
		txt = arg[i] as string
	)

	--タイマー部-------------------------------------------
	fn TimerStop arg = (
		arg.Stop()
		dotnet.removeAllEventHandlers arg
		arg.Dispose() --メモリから削除--
	)

	fn setbaloon = (
		txtlabel.text = temp[loopcounter + 1]
		baloonFrm.Show()
		loopcounter += 1
	)

	fn tickHidebaloon sender e = (
		hidecounter += 1
		if hidecounter >= hideintervaltime do (
			baloonFrm.hide()
			MainFrm.Refresh()
		)
	)

	fn tickshowbaloon sender e = (
		if temp[1][loopcounter] == undefined  then (
			hidetimer.Stop()
			loopcounter = 1
		)
		else (
			hidetimer.Stop()
			hidecounter = 0
			setbaloon()
			hidetimer.Start()
		)
	)

	fn ghostAction arg = (
		if arg == 0 do (
			setbaloon nomaltxt
		)
		if arg == 1 do (
			setbaloon SPtxt
		)
	)

	--バルーン表示用タイマー関数
	fn onTick s e = (
		ghostAction 0
	)

	--2時間タイマー--
	fn onTick2H = (
		try(bordFrm.close())catch() --try()chatch()を入れるなら、入れた後にフォーム生成しないとフォームがなくなる。--
		bordFrm = dotNetObject "System.Windows.Forms.Form"
		bordFrm.text = "bord"
		bordFrm.backColor = (dotNetClass "system.drawing.color").green
		bordFrm.TransparencyKey = (dotNetClass "system.drawing.color").green
		bordFrm.bounds = dotNetObject "system.drawing.rectangle" 50 50 500 500
		bordFrm.BackgroundImage = bordimg
		bordFrm.BackgroundImageLayout = none
		--bordFrm.formBorderStyle = (dotNetClass "System.Windows.Forms.FormBorderStyle").none
		bordFrm.ShowInTaskBar =false
		bordFrm.TopMost=true
		bordFrm.show()
	)

	--[INI]ウィンドウ位置取得
	fn fnLoadWinPosByIni = (
		main_posX = (getINISetting myInifile "MainPos" "x") as Float
		main_posY = (getINISetting myInifile "MainPos" "y") as Float
		baloon_posX = (getINISetting myInifile "BaloonPos" "x") as Float
		baloon_posY = (getINISetting myInifile "BaloonPos" "y") as Float

		--初回起動時--
		if main_posX == 0.0 AND main_posY == 0.0 then (
			MainFrm.location.X = df_mainPosX
			MainFrm.location.Y = df_mainPosY
			baloonFrm.location.X = df_baloonPosX
			baloonFrm.location.Y = df_baloonPosY
		)
		--２回目以降--
		else (
			MainFrm.location.X = main_posX
			MainFrm.location.Y = main_posY
			baloonFrm.location.X = baloon_posX
			baloonFrm.location.Y = baloon_posY
		)
	)

	--[INI]ウィンドウ位置保存
	fn fnSaveWinPosByIni = (
		setINISetting myInifile "MainPos" "x" ( MainFrm.location.X as String)
		setINISetting myInifile "MainPos" "y" ( MainFrm.location.Y as String)
		setINISetting myInifile "BaloonPos" "x" ( baloonFrm.location.X as String)
		setINISetting myInifile "BaloonPos" "y" ( baloonFrm.location.Y as String)
	)

	--本体マウスイベント設定-----------------------------------------------------------
	--Variable used in mouseMove handler.
	local mouseIsDown = false
	local mousePoint_X
	local mousePoint_Y

	fn formMouseDown sender arg = (
		--Check to see which mouse button is being pressed.
		if arg.button == arg.button.left do (
			mousePoint_X = arg.X
			mousePoint_Y = arg.Y
			mouseIsDown=true
		)
	)

	fn formMouseUp sender arg = (
		mouseIsDown=false
	)

	fn mainMouseMove sender arg = (
		if mouseIsDown do (
			MainFrm.Location.X = MainFrm.Location.X + arg.X - mousePoint_X
			--MainFrm.Location.Y = MainFrm.Location.Y + arg.Y - mousePoint_Y
			baloonFrm.Location.X = baloonFrm.Location.X + arg.X - mousePoint_X
		)
	)

	fn formMouseMove sender arg = (
		if mouseIsDown do (
			sender.Location.X = sender.Location.X + arg.X - mousePoint_X
			sender.Location.Y = sender.Location.Y + arg.Y - mousePoint_Y
		)
	)

	fn formMouseDClick sender arg = (
		ghostAction 0
	)

	fn onAppLaunch sender arg = (
		--shellLaunch "プログラムのパス" ""
	)

	fn onMacrorun sender arg = (
		ghostAction 1
		--macros.run "カテゴリ" "スクリプト名"
	)

	fn FrmClose sender srg = (
		fnSaveWinPosByIni()
		loadghostsetting.fn_setghostname myInifile ghostname
		loadghostsetting.fn_setghostvariation myInifile ghostvariation
		TimerStop settimer
		TimerStop timer2H
		TimerStop hidetimer
		baloonFrm.Close()
		MainFrm.Close()
	)

---------------------------------------------------------------------------------------------------------------------------------------------
	--[struct]ゴーストセッティング--
	loadghostsetting = GhostSetting()
	ghostname = loadghostsetting.fn_ghostname myInifile
	ghostvariation = loadghostsetting.fn_ghostvariation myInifile
	local ghost_path = loadghostsetting.fn_getGhostPath scriptroot ghostname ghostvariation

	--パス宣言--
	local shell_FullPath = loadghostsetting.fn_getGhostShellPath scriptroot ghostname ghostvariation
	local baloon_FullPath = loadghostsetting.fn_getGhostBaloonPath scriptroot
	local bord_FullPath = loadghostsetting.fn_getGhostBordPath scriptroot ghostname ghostvariation

	--[struct]ゴースト読み込み
	ghost_Temp = loadghost ghost_path
	ghost = ghost_Temp
	local nomaltxt = ghost.setnomaltxt()
	local SPtxt = ghost.setSPtxt()
	local texcount = nomaltxt.count
	local stexcount = SPtxt.count

	--画像読み込み---------------------------------------------------------------------------------
	--配列宣言--
	local shell_Array = collectFiles folder: shell_FullPath extensions:#(".png")
	local baloon_Array = collectFiles folder: baloon_FullPath extensions:#(".png")
	local bord_Array = collectFiles folder: bord_FullPath extensions:#(".jpg",".png")

	--本体--
	local mainimgfiles = shell_Array[1]
	local mainimgClass = dotNetClass	"System.Drawing.Image"
	local mainimg =(mainimgClass.FromFile mainimgfiles)
	local mainimgWidth = mainimg.Size.Width as integer
	local mainimgHeight = mainimg.Size.Height as integer

	--バルーン--
	local baloonimgfiles =  baloon_Array[1]
	local baloonimgClass = dotNetClass	"System.Drawing.Image"
	local baloonimg = (baloonimgClass.FromFile baloonimgfiles)
	local baloonimgWidth = baloonimg.Size.Width as integer
	local baloonimgHeight = baloonimg.Size.Height as integer

	--セリフテキスト用サイズ変数--
	local txtlabelwidth = baloonimgWidth - 10
	local txtlabelHeight = baloonimgHeight - 10

	--２時間タイマー用ボード--
	local bordimgfiles =  bord_Array[1]
	local bordimgClass = dotNetClass	"System.Drawing.Image"
	local bordimg = (bordimgClass.FromFile bordimgfiles)
	local bordimgWidth = bordimg.Size.Width as integer
	local bordimgHeight = bordimg.Size.Height as integer

	--画面解像度取得--
	--フル画面右下に表示--
	local window_Width = systemTools.GetScreenWidth()
	local window_Height = systemTools.GetScreenHeight()
	local df_mainPosX = window_Width - (mainimgWidth + 50)
	local df_mainPosY = window_Height - (mainimgHeight + 29)
	local df_baloonPosX = window_Width - 500
	local df_baloonPosY = window_Height - 200

	--本体表示設定(フォームをMAXの子に)--
	local maxHandlePointer = (Windows.GetMAXHWND())
	local sysPointer = DotNetObject "System.IntPtr" maxHandlePointer
	local maxHwnd = (dotNetClass "System.Windows.Forms.Control" ).fromHandle sysPointer

	--DotNetフォームスタイル-------------------------------------------------------------------------------------------------------
	--バルーンフォームスタイル-----------------------
	baloonFrm.text = "baloon"
	baloonFrm.StartPosition = baloonFrm.StartPosition.Manual
	baloonFrm.backColor = (dotNetClass "system.drawing.color").green
	baloonFrm.TransparencyKey = (dotNetClass "system.drawing.color").green
	baloonFrm.bounds = dotNetObject "system.drawing.rectangle" df_baloonPosX df_baloonPosY baloonimgWidth baloonimgHeight
	baloonFrm.BackgroundImage = baloonimg
	baloonFrm.BackgroundImageLayout = none
	baloonFrm.formBorderStyle = (dotNetClass "System.Windows.Forms.FormBorderStyle").none
	baloonFrm.ShowInTaskBar = false
	baloonFrm.TopMost = true

	--テキストラベルスタイル-----------------------
	txtlabel.text =  "txt"
	txtlabel.bounds = dotNetObject "system.drawing.rectangle" 10 10 txtlabelwidth txtlabelHeight
	txtlabel.backColor = (dotNetClass "system.drawing.color").Transparent
	baloonFrm.Controls.Add txtlabel

	--メインフォームスタイル-----------------------
	MainFrm.text = "madoka"
	MainFrm.StartPosition = MainFrm.StartPosition.Manual
	MainFrm.bounds = dotNetObject "system.drawing.rectangle" df_mainPosX df_mainPosY mainimgWidth mainimgHeight
	MainFrm.backColor = (dotNetClass "system.drawing.color").black
	MainFrm.TransparencyKey = (dotNetClass "system.drawing.color").black
	MainFrm.formBorderStyle = (dotNetClass "System.Windows.Forms.FormBorderStyle").none
	MainFrm.ShowInTaskBar =false
	MainFrm.TopMost=true

	--本体Shell設定-------------------------
	--formsize -16   -38----584 322
	imgview.bounds = dotNetObject "system.drawing.rectangle" 0 0 mainimgWidth mainimgHeight
	imgview.Image = mainimg
	imgview.backColor = (dotNetClass "system.drawing.color").Transparent
	MainFrm.Controls.Add imgview
	-------------------------------------------------------------------------------------------------------------------------
	-------------------------------------
	--表情変更用（未実装）
	--faceview = dotNetObject "System.Windows.Forms.PictureBox"
	----formsize -16   -38----584 322
	--faceview.bounds = dotNetObject "system.drawing.rectangle" 30 30 100 100
	--facefiles =  shell_Array[2]
	--faceClass = dotNetClass	"System.Drawing.Image"
	--faceimg =(faceClass.FromFile facefiles)
	--faceview.Image = faceimg
	--faceview.backColor = (dotNetClass "system.drawing.color").Transparent
	--MainFrm.Controls.Add faceview
	-------------------------------------
	--イベントハンドラ追加---------------------------------------------
	dotNet.addEventHandler imgview "DoubleClick" formMouseDClick
	dotNet.addEventHandler imgview "mouseDown" formMouseDown
	dotNet.addEventHandler imgview "mouseUp" formMouseUp
	dotNet.addEventHandler imgview "mouseMove" mainMouseMove
	-------------------------------------
	dotNet.addEventHandler baloonFrm "mouseDown" formMouseDown
	dotNet.addEventHandler baloonFrm "mouseUp" formMouseUp
	dotNet.addEventHandler baloonFrm "mouseMove" formMouseMove
	-------------------------------------
	dotnet.addeventhandler txtlabel "DoubleClick" hidebaloon
	--バルーン表示用タイマー-------------------
	dotnet.addEventHandler settimer "Tick" onTick
	dotNet.setLifetimeControl settimer #dotnet
	--2時間タイマー-------------------------
	dotnet.addEventHandler timer2H "Tick" onTick2H
	dotNet.setLifetimeControl timer2H #dotnet
	--ハイド用タイマー-----------------------
	dotnet.addEventHandler hidetimer "Tick" tickHidebaloon
	dotNet.setLifetimeControl hidetimer #dotnet
	------------------------------------------------------------
	--コンテキスト（右クリック）メニュー----------------------
	cm = dotNetObject "ContextMenu"
	item = cm.menuitems.Add "test"
	dotnet.addeventhandler item "Click" onMacrorun
	item = cm.menuitems.Add "test"
	dotnet.addeventhandler item "Click" onAppLaunch
	item = cm.menuitems.Add "Close"
	dotnet.addeventhandler item "Click" FrmClose

	MainFrm.ContextMenu = cm
	--------------------------------------------
	--本体表示--
	MainFrm.Show(maxHwnd)
	-- MainFrm.Show()
	fnLoadWinPosByIni()
	settimer.Start()
	timer2H.Start()
	hidetimer.Start()
)
