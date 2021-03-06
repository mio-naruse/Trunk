(
	--既存ロールアウトを閉じる--
	try (
	cui.UnRegisterDialogBar main_rollout
	DestroyDialog main_rollout
	) catch()
	--local setting--
	--local Arc_1 = getFilenamePath (curve_Path) + "Arc001.max"
	--localsetting end--
	--menu settimgs--
	rcmenu madoka_mainmenu
	(
		subMenu "Config"
		(
			menuItem prefmenu "Prefarence..."
		)

		subMenu "help"
		(
	        menuItem helpmenu "help"
	        separator sp1
			menuItem aboutmenu "about..."
	    )

		on prefmenu picked do
			(
				madokaFn.ro_Prefarence()
			)
		on aboutmenu picked do
			(
				madokaFn.createAboutRollout()
			)
	)

	--main rollout---------------------------------------------------------------------------------------------	
	rollout main_rollout "madoka"
	(
		--Add a dot net tab control.
		dotNetControl tabs "system.windows.forms.tabControl" width:173 height:30 pos:[2,1]
		--Add a sub rollout.
		subRollout subRoll "Sub" width:173 height:960 pos:[4,40]

		--Tab initilization function--
		fn initTabs tab labels:#() =
		(
			--Clear any existing tabs incase we do an update of them at some point. 
			tab.tabPages.clear()
			--Set the size mode so that we can control their width. 
			tab.sizeMode=tab.sizeMode.fixed
			--Set the width of every tab.
			tab.itemSize=dotnetObject "System.Drawing.Size" ((tab.width/labels.count)-2) 25
			
			--Loop through all the labels that we pass to the function and add a tab by the same name. 
				for x in labels do tab.tabPages.add x
		)

		--Add rollouts to the subRollout based on which tab is currently selected. 
		fn addTabRollout index=
		(
			--Remove any existing rollouts first. 
				for x in subRoll.rollouts do removeSubRollout subRoll x
			
			sub=case index of
			(
				default:
				(
					madokaFn.add_ModelRollouts subRoll
				)
				1:
				(
					madokaFn.add_SetupRollouts subRoll
				)
				2:
				(
					madokaFn.add_RenderRollouts subRoll
				)
			)
		)

		--When the rollout opens initilize the tab control
		--When the mouse button is released on a tab get the selected tab and pass it to our addTabRollout function. 
		on tabs MouseDown senderArg arg do
		(
			addTabRollout senderArg.SelectedIndex
		)

		--When the rollout opens initilize the tab control
		on main_rollout open do
		(
			initTabs tabs labels:#("Model", "Setup", "Render")
			addTabRollout 0
		)
	)--rollout end--
		--Main Executing part------------------------------------------------------------------------------------------
	on execute do (
		clearListener()
		--theNewFloater = newRolloutFloater "madoka" 188 990
		createdialog main_rollout 188 990 menu:madoka_mainmenu
		cui.RegisterDialogBar main_rollout
		)
)-- script end--