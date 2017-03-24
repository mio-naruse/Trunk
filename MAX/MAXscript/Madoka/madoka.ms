filein ((getDir #scripts) + "\\Madoka\\include\\global.ms")
filein ((getDir #scripts) + "\\Madoka\\include\\ui.ms")
filein ((getDir #scripts) + "\\Madoka\\include\\main.ms")

madokaFn.INIfilecheck()
checkini = madokaFn.prefINIget()

--if checkini == "true" do (
	--filein ((getDir #scripts) + "\\Madoka\\characterize\\ghost\\ghostsetting.ms")
		--[struct]ゴーストセッティング--
	--loadghostsetting = GhostSetting()
	--loadghostsetting.GhostINIfilecheck
	--ghostname = loadghostsetting.fn_ghostname GhostInifile
	--ghostvariation = loadghostsetting.fn_ghostvariation GhostInifile
	--ghost_path = loadghostsetting.fn_getGhostPath CA_scriptroot ghostname ghostvariation
	--filein ghost_path
	--ghost = loadghost()
	--filein madokaCA_Path
)