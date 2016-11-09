(
	--local setting--
	local Arc_1 = getFilenamePath (curve_Path) + "Arc001.max"

	--localsetting end--
		rcmenu mymenu
	(
		subMenu "menu1"
		(
			menuItem item1 "item_1"
			separator sp1
			menuItem item2 "item_2"
		)
		subMenu "menu2"
		(
			menuItem item3 "item_3"
			menuItem item4 "item_4"
		)
		on item1 picked do
			(
				rol1.lbl1.text="select item1"
			)
		on item2 picked do
			(
				item2.checked = not item2.checked
			)
	)
	--fuctions--
	fn collectFiles folder: extensions: = (
		local sioDir = dotNetClass "System.IO.Directory"
		local sioSOpt = (dotNetClass "System.IO.SearchOption").AllDirectories
		local allFiles = sioDir.GetFiles folder "*.*" sioSOpt
		for f in allFiles where findItem extensions (tolower (getfilenametype f)) > 0 collect f
	  )

	--floating rollout--------------------------------------------------------------------------------------	
		rollout Cecilia "CheckedObjects" width:218 height:250
	(
		MultiListBox Lst_hit "Multi List Box"
		button seldup_bt "Select" width:140 height:30 align:#center

		--on Lst_hit selected v do
		--(
			--if Lst_hit.selection[v] then
			--selectMore (getNodeByName Lst_hit.items[v])
			--else
			--deselect (getNodeByName Lst_hit.items[v])
		--)
		on seldup_bt pressed do
		(
			local obj_array = #()
			
			for x = 1 to $objects.count do (append obj_array $objects[x])
			deselect $*
			for i = 1 to Cecilia_list_obj.count do
			(
				if Cecilia.Lst_hit.selection[i] == true do
				(
					for k = 1 to obj_array.count do
					(
						if Cecilia_list_obj[i] == obj_array[k].name do 
						(
							selectmore obj_array[k]
							--print obj_array[k].name
						)
					)
				)
			)	
		)-- end seldup_bt

		on Cecilia open do
		(
			local items = sort Cecilia_list_obj
			Lst_hit.items = items
			Lst_hit.selection = #{}
		)

	)--rollout Cecilia end---

	fn openCecilia = (
		if dup_float != undefined do (closerolloutfloater dup_float)

		dup_float = newrolloutfloater "Object List" 180 350
		addrollout Cecilia dup_float
	)
	--main rollout---------------------------------------------------------------------------------------------	
	fn createMainrollout newfloater = (
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
						add_ModelRollouts subRoll
					)
					1:
					(
						dd_RenderRollouts subRoll
					)
					2:
					(
						add_AnimRollouts subRoll
					)
					3:
					(
						add_AboutRollouts subRoll
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
				initTabs tabs labels:#("Model", "Render", "Anim","About")
				addTabRollout 0
			)
		)--rollout end--
		addRollout main_rollout newfloater border:false
	)
		--Main Executing part------------------------------------------------------------------------------------------
		on execute do (
			clearListener()
			theNewFloater = newRolloutFloater "madoka" 188 990
			createMainrollout theNewFloater
			cui.RegisterDialogBar theNewFloater
			)
)-- script end--