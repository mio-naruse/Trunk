struct madokaFn(

	--INIファイルチェック--
	fn INIfilecheck =(
		if (doesFileExist madokaINI_Path) == false do(
			local firstsettype = "false"
			setINISetting madokaINI_Path "Use characterized script" "set" (firstsettype as String)
			)
	),


	fn prefINIget = (
		local getprefstate = (getINISetting madokaINI_Path "Use characterized script" "set") as string
		if getprefstate == "" then (
			prefstate = "false"
			)
		else (
			prefstate = getprefstate
			)
		return prefstate
	),

	--INI設定保存--
	fn prefINIsave saveprefstate = (
		setINISetting madokaINI_Path "Use characterized script" "set" (saveprefstate as String)
	),

	--画像取得関数--
	fn collectFiles folder: extensions: = (
		sioDir = dotNetClass "System.IO.Directory"
		sioSOpt = (dotNetClass "System.IO.SearchOption").AllDirectories
		allFiles = sioDir.GetFiles folder "*.*" sioSOpt
		for f in allFiles where findItem extensions (tolower (getfilenametype f)) > 0 collect f
	),
	--floating rollout--------------------------------------------------------------------------------------	
	fn ro_Cecilia dup_panel = (
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
		addrollout Cecilia dup_panel
	),

	fn openCecilia = (
		if dup_float != undefined do (closerolloutfloater dup_float)
		dup_float = newrolloutfloater "Object List" 180 350

		madokaFn.ro_Cecilia dup_float
	),

--ROLLOUTGROUP MODEL---------------------------------------------------------------------------
	--ScaleChecker
	fn ro_Sylvia sRoll = (
		rollout Sylvia "Scale Checker" 
		(
			local list_obj = #()
			Button Chk_BTN "Check Scale" width:140 height:30 align:#center
			on Chk_BTN pressed do (
				if selection.count == 0 then (
					messagebox "Please select objects" title:"Alart!"
				)
				else (
					--try(DestroyDialog Cecilia)catch()
					j = 1
					for i in selection do (
						if isGroupHead i then (setGroupOpen i true)
						else (
							if (i.scale != [1,1,1]) do (
								list_obj[j] = i.name
								j = j + 1
							)
						)
					)
					Cecilia_list_obj = list_obj
					madokaFn.openCecilia()
				)--else end--
			)	
		)--rollout end--
		AddSubRollout sRoll Sylvia
	),
	--NameChecker
	fn ro_Melody sRoll = (
		rollout Melody "Name Checker" 
		(
			Button Chk_BTN "Check Name" width:140 height:30 align:#center
			on Chk_BTN pressed do (
				local list_obj = #()
				--try(DestroyDialog Cecilia)catch()
				j = 1
				local obj_array = #()
				local objname_array = #()
				
				for x = 1 to $objects.count do (append obj_array $objects[x])
				for x = 1 to $objects.count do (append objname_array $objects[x].name)
				sort objname_array
				
				for y = 1 to (objname_array.count - 1) do
				(
					if objname_array[y] == objname_array[(y+1)] do
					(
						list_obj[j] =  objname_array[y]
						j = j + 1
					)
				)

				for i = (list_obj.count) to 2 by -1 do
				(
					if list_obj[i] == list_obj[(i-1)] do 
					(
						deleteItem list_obj i
					)
				)
				Cecilia_list_obj = list_obj
				madokaFn.openCecilia()
			)	
		)
		AddSubRollout sRoll Melody
	),
	--Modifire Killer--
		fn ro_Tina sRoll = (
		rollout Tina "Modifire Killer"
		(
			edittext modnamebox "Name" text:"TurboSmooth"
			checkbox top_mod"Only top Modifier"
			Button DelT_BTN "Kill Modifire" width:140 height:30 align:#center

			on DelT_BTN pressed do (
				undo on (
					if selection.count == 0 then (
						messagebox "Please select objects" title:"Alart!"
					)
					else (
						if top_mod.checked == true do (
							for i in selection do (
								try(
									if (i.modifiers[1].name == modnamebox.text ) do (
										deleteModifier i 1
									)--if end --
								)--try end --
								catch()
							)--for end --
						)-- if end --
						if top_mod.checked == false do (
							for i in selection do (
								try(
									for s = i.modifiers.count to 1 by -1 do (
										if (i.modifiers[s].name == modnamebox.text ) do (
											deleteModifier i s
										)--if end --
									)
								)--try end --
								catch()
							)--for end --
						)-- if end --
					)
				)--undo end--
			)--on end --
		)
		AddSubRollout sRoll Tina
	),
	--SaverotateXform--
	fn ro_Stella sRoll = (
		rollout Stella "SaveRotateXForm"
		(
			Button Stella_BTN "SaveRotateXform" width:140 height:30 align:#center
			on Stella_BTN pressed do (
				for i in selection do (
					
					rot_val = i.rotation
					pos_val = i.pos
					
				i.pos = [0,0,0]
				i.rotation = eulerangles 0 0 0
					
				resetxform i
				maxOps.CollapseNode i off
					
				i.rotation = rot_val
				i.pos = pos_val
				)
			)
		)
		AddSubRollout sRoll Stella rolledUp:true
	),
	--Scene Material Collector--
	fn ro_Matilda sRoll = (
		rollout Matilda "Scene Material Collector"
		(
			Button Matilda_BTN "Collect Material"  width:140 height:30 align:#center
			on Matilda_BTN pressed do (
				for i = 1 to sceneMaterials .count do
				(
					meditMaterials[i] = sceneMaterials[i]
				)	
			)
		)
		AddSubRollout sRoll Matilda rolledUp:true
	),
	--Material Killer--
	fn ro_Kelly sRoll = (
		rollout Kelly "Material Killer"
		(
			Button Kelly_BTN "Kill Material"  width:140 height:30 align:#center
			on Kelly_BTN pressed do (
				if selection.count == 0 then (
					messagebox "Please select objects" title:"Alart!"
				)
				else (
					for i in selection do (
						i.material = undefined 
					)
				)
			)
		)
		AddSubRollout sRoll Kelly rolledUp:true
	),
	---Point Maker--
	fn ro_Priscilla sRoll = (
		rollout Priscilla "Point Maker"
		(
			spinner Priscilla_SPN "Point Size : " range:[1,100,20] type:#float
			checkbox parent_ck "parent"checked:true 
			
			Button Priscilla_BTN "MakePoint "  width:140 height:30 align:#center
			on Priscilla_BTN pressed do (
				if selection.count == 0 then (
					messagebox "Please select objects" title:"Alart!"
				)
				else (
					try (
						undo on(
							ss = selection as array
							for i = 1 to ss.count do (
								mkpoint = Point pos:[ss[i].pos.x,ss[i].pos.y,ss[i].pos.z] size:Priscilla_SPN.value Box:on cross:on
								if parent_ck.checked == true do(	
									ss[i].parent = mkpoint
								)
							)		
						)
					)
					catch (
						messagebox "Notice : Error" title:"Alart!"
					)
				)--else end
			)
		)
		AddSubRollout sRoll Priscilla
	),
	---IKSetup HISolver--
	fn ro_Iris sRoll = (
		rollout Iris "IKSetup HISolver"
		(
			spinner Iris_SPN "Point Size : " range:[1,100,20] type:#float
			Button Iris_BTN "IKSetup HISolver"  width:140 height:30 align:#center
			on Iris_BTN pressed do (
				if selection.count == 0 then (
					messagebox "Please select bones" title:"Alart!"
				)
				else (
					try (
						undo on(
							IKpoint =#()
							chainset = #()
							i= 1
							m = 1
							for s in selection do (
								chainset[i] = s
								i = i +1
							)
							for t = 1 to (chainset.count - 1) do (
							IKpoint[m] = 	IKSys.ikChain chainset [t] chainset[t +1] "IKHISolver"
								m = m+1
							)
							mkpoint = Point pos:[chainset[1].pos.x,chainset[1].pos.y,chainset[1].pos.z] size:Iris_SPN.value Box:on cross:on
								chainset[1].parent = mkpoint
							for t = 1 to IKpoint.count do (
								mk2point = Point pos:[IKpoint[t].pos.x,IKpoint[t].pos.y,IKpoint[t].pos.z] size:Iris_SPN.value Box:on cross:on
								IKpoint[t].parent = mk2point
							)
						)
					)
					catch (
						messagebox "Notice : Please select bones in turn" title:"Alart!"
					)
				)--else end
			)
		)
		AddSubRollout sRoll Iris
	),
	--Convert instance object
	fn ro_Charlotte sRoll = (
		rollout Charlotte "Convert Instance object"
		(
			local instobj = #()
			local origobj = #()
			local parentobj = #()
			
			label Charlotte_lbl "adapt:" align:#left
			checkbox Charlotte_rotation_ck "Rotation"checked:true
			checkbox Charlotte_scale_ck "Scale"checked:true
			checkbox Charlotte_parent_ck "Keep parent position"checked:true
			checkbox Charlotte_neme_ck "Keep current name"checked:true
			checkbox Charlotte_delete_ck "Delete current object"checked:true
			Button Charlotte_BTN "Convert"  width:140 height:30 align:#center
			
			on Charlotte_BTN pressed do (
				undo on (
					instobj = selection as array
					if instobj.count >0 do (
						origobj = pickobject rubberband:instobj[1].pos rubberBandColor:yellow
						if origobj != undefined do (
							for i = 1 to instobj.count do (
								parentobj[i] = instobj[i].parent
								maxOps.CloneNodes origobj actualNodeList:&c_node newNodes:&d_node cloneType:#instance
								if Charlotte_scale_ck.checked == true do(
									d_node.scale = instobj[i].scale
								)
								if Charlotte_rotation_ck.checked == true do(
									d_node.rotation = instobj[i].rotation
								)

								d_node.pos = instobj[i].pos

								if Charlotte_parent_ck.checked == true do (
									if parentobj[i] != undefined do (
										d_node.parent = parentobj[i]
									)
								)
								if Charlotte_neme_ck.checked == true do (
									d_node.name = instobj[i].name
								)
									if Charlotte_delete_ck.checked == true do(
									delete instobj[i]
									)
							)
						)
					)
				)
			)
		)
		AddSubRollout sRoll Charlotte  rolledUp:true
	),
	--PRS Locker
	fn ro_Lola sRoll = (
		rollout Lola "PRS Locker" 
		(
			--getTransformLockFlags $
			label Lola_lbl_M "move" align:#left
			checkbox mcheck_x "X"checked:true pos:[(Lola_lbl_M.pos.x + 50),Lola_lbl_M.pos.y]
			checkbox mcheck_y "Y"checked:true pos:[(Lola_lbl_M.pos.x + 80),Lola_lbl_M.pos.y]
			checkbox mcheck_z "Z"checked:true pos:[(Lola_lbl_M.pos.x + 110),Lola_lbl_M.pos.y]
			
			label Lola_lbl_R "Rotate" align:#left
			checkbox rcheck_x "X"checked:true pos:[(Lola_lbl_R.pos.x + 50),Lola_lbl_R.pos.y]
			checkbox rcheck_y "Y"checked:true pos:[(Lola_lbl_R.pos.x + 80),Lola_lbl_R.pos.y]
			checkbox rcheck_z "Z"checked:true pos:[(Lola_lbl_R.pos.x + 110),Lola_lbl_R.pos.y]

			label Lola_lbl_S "Scale" align:#left
			checkbox scheck_x "X"checked:true pos:[(Lola_lbl_S.pos.x + 50),Lola_lbl_S.pos.y]
			checkbox scheck_y "Y"checked:true pos:[(Lola_lbl_S.pos.x + 80),Lola_lbl_S.pos.y]
			checkbox scheck_z "Z"checked:true pos:[(Lola_lbl_S.pos.x + 110),Lola_lbl_S.pos.y]
			
			Button Allon_BTN "All ON" width:65 height:30 pos:[10,70]
			Button Alloff_BTN "All OFF" width:65 height:30 pos:[85,70]

			Button Lola_BTN "Execution" width:140 height:30 align:#center
			
			local PRSsel = #{}
			
			on Allon_BTN pressed do (
				mcheck_x.triState = 1
				mcheck_y.triState = 1
				mcheck_z.triState = 1
				rcheck_x.triState = 1
				rcheck_y.triState = 1
				rcheck_z.triState = 1
				scheck_x.triState = 1
				scheck_y.triState = 1
				scheck_z.triState = 1
			)
			
			on Alloff_BTN pressed do (
				mcheck_x.triState = 0
				mcheck_y.triState = 0
				mcheck_z.triState = 0
				rcheck_x.triState = 0
				rcheck_y.triState = 0
				rcheck_z.triState = 0
				scheck_x.triState = 0
				scheck_y.triState = 0
				scheck_z.triState = 0
			)
			
			on Lola_BTN pressed do (
				if mcheck_x.checked == true then append PRSsel 1
					else deleteItem PRSsel 1
				if mcheck_y.checked == true then append PRSsel 2
					else deleteItem PRSsel 2
				if mcheck_z.checked == true then append PRSsel 3
					else deleteItem PRSsel 3
				if rcheck_x.checked == true then append PRSsel 4
					else deleteItem PRSsel 4
				if rcheck_y.checked== true then append PRSsel 5
					else deleteItem PRSsel 5
				if rcheck_z.checked == true then append PRSsel 6
					else deleteItem PRSsel 6
				if scheck_x.checked == true then append PRSsel 7
					else deleteItem PRSsel 7
				if scheck_y.checked == true then append PRSsel 8
					else deleteItem PRSsel 8
				if scheck_z.checked == true then append PRSsel 9
					else deleteItem PRSsel 9
				
				for i in selection do setTransformLockFlags i PRSsel
			)
		)
		AddSubRollout sRoll Lola
	),
	
	--BoneConverter
	fn ro_Bonnie sRoll = (
		rollout Bonnie "BoneConverter" 
		(
			Button Bonnie_BTN "Start"  width:140 height:30 align:#center			
			
			on Bonnie_BTN pressed do 
				(
					selobj = selection as array
					if selobj != undefined do pic_root = pickobject rubberband:selobj[1].pos
					if pic_root != undefined  do 
						(
							undo "Bone Convert" on
								(
									bn=#()
									setroot= selobj[1]
									ss = selobj.count
									
									for i = 1 to ss - 1 do (
										bn[i] = BoneSys.createBone selobj[i].pos selobj[i + 1].pos [0,0,1]
										bn[i].width = 1.0
										bn[i].height = 1.0
									)
										bn[ss] = BoneSys.createBone bn[ss - 1].pos selobj[ss].pos [0,0,1]
										in coordSys Local move bn[ss] [bn[ss - 1].length,0,0]
										bn[ss].width = bn[ss - 1].width
										bn[ss].height = bn[ss - 1].height
										bn[ss].taper = 90
										bn[ss].length = (bn[ss - 1].width+bn[ss - 1].height)/2
										bn[ss].wirecolor =bn[ss - 1].wirecolor
									
									for s = bn.count to 2 by -1 do (
										bn[s].parent = bn[s - 1]
									)
									
									bn[1].parent = pic_root
									
									for i = 1 to ss do (
										bn[i].rotation.controller = copy selobj[i].rotation.controller
										notifyDependents bn[i].rotation.controller
									)
								)
						)
				)
		)
		AddSubRollout sRoll Bonnie rolledUp:true
	),

	--Linker
	fn ro_Lisa sRoll = (
		rollout Lisa "Object Linker"
		(
			local instobj = #()
			local origobj = #()
			
			Button Lisa_BTN "Link"  width:140 height:30 align:#center
			
			on Lisa_BTN pressed do (
				instobj = selection as array
				if instobj.count >0 do (
					origobj = pickobject rubberband:instobj[1].pos rubberBandColor:yellow
					if origobj != undefined do (
						for i = 1 to instobj.count do (
						instobj[i].parent = origobj
						)
					)
				)
			)
		)
		AddSubRollout sRoll Lisa
	),
	
	--keep axis rotate--
	fn ro_Katherine sRoll = (
		rollout Katherine "Keep Axis Rotate"
		(

			label Katherine_lbl_M "mirror axis" align:#left
			checkbox axis_x "X"checked:true pos:[(Katherine_lbl_M.pos.x + 50),Katherine_lbl_M.pos.y]
			checkbox axis_y "Y"checked:false pos:[(Katherine_lbl_M.pos.x + 80),Katherine_lbl_M.pos.y]
			checkbox axis_z "Z"checked:false pos:[(Katherine_lbl_M.pos.x + 110),Katherine_lbl_M.pos.y]
			Button Katherine_BTN "mirror"  width:140 height:30 align:#center

			on axis_x changed true do 
			(
				axis_y.triState = 0
				axis_z.triState = 0
			)
			on axis_y changed true do 
			(
				axis_x.triState = 0
				axis_z.triState = 0
			)
			on axis_z changed true do 
			(
				axis_x.triState = 0
				axis_y.triState = 0
			) 

			on Katherine_BTN pressed do
			(
				undo on
				(
					obj = selection as array
					if obj.count > 0 do
					(
						if axis_x.checked == true do
						(
							for i = 1 to obj.count do
							(
								initpos = obj[i].pos
								obj[i].pos = [0,0,0]
								initrotate = quatToEuler (inverse obj[i].rotation)
								obj[i].rotation = inverse ((eulerAngles initrotate.x -initrotate.y -initrotate.z)as quat)
								obj[i].pos = [-initpos.x,initpos.y,initpos.z]
							)
						)

						if axis_y.checked == true do
						(
							for i = 1 to obj.count do
							(
								initpos = obj[i].pos
								obj[i].pos = [0,0,0]
								initrotate = quatToEuler (inverse obj[i].rotation)
								obj[i].rotation = inverse ((eulerAngles -initrotate.x initrotate.y -initrotate.z)as quat)
								obj[i].pos = [initpos.x,-initpos.y,initpos.z]
							)
						)

						if axis_z.checked == true do
						(
							for i = 1 to obj.count do
							(
								initpos = obj[i].pos
								obj[i].pos = [0,0,0]
								initrotate = quatToEuler (inverse obj[i].rotation)
								obj[i].rotation = inverse ((eulerAngles -initrotate.x (initrotate.y + 180) (initrotate.z+180))as quat)
								obj[i].pos = [initpos.x,initpos.y,-initpos.z]
							)
						)
					)
				)
			)
		)
		AddSubRollout sRoll Katherine
	),
--ROLLOUTGROUP RENDARING----------------------------------------------------------------------
	--RenderElementRenamer------------------------------------------------------------
	fn ro_Rebecca sRoll = (
		rollout Rebecca "RenderElementRenamer" 
		(
			checkbox Rebecca_box "Exit last underbar" checked:true
			checkbox Rebecca_box2 "Render same path" checked:true
			
			Button Rebecca_BTN "Rename"  width:140 height:30 align:#center
			on Rebecca_BTN pressed do (
					try (
						if ( renderSceneDialog.isOpen() )do (
							renderSceneDialog.commit()
							renderSceneDialog.close()
						)
						re = maxOps.GetCurRenderElementMgr() 
						theManager = maxOps.GetRenderElementMgr #Production
						gop_name = #()
						nowop_name = rendOutputFilename
						sp_st = filterString nowop_name @"\"
						f_name = sp_st[sp_st.count]
						st_count = f_name.count - 4
						op_name = substring f_name 1 st_count
						
						for n = 0 to (theManager.numrenderelements () - 1) do (
							el = re.getrenderelement n
							getop_name = re.GetRenderElementFileName n
							getop_st = filterString getop_name @"\"
							f_name2 = getop_st[getop_st.count]
							st_count2 =  f_name2.count - 4
							pathcount = getop_name.count - f_name2.count
							if Rebecca_box2.checked == true then (
								new_namepath = substring nowop_name 1 pathcount
							)
							else (
								new_namepath = substring getop_name 1 pathcount
							)
							ftype = getFilenameType f_name2
								
							if	Rebecca_box.checked == true then (
							re.SetRenderElementFilename n (new_namepath + op_name + el.elementname + ftype )
							)
							else (
							re.SetRenderElementFilename n (new_namepath + op_name + "_" + el.elementname + ftype )
							)
								
						)
						renderSceneDialog.open()
					)
					catch (
						messagebox "undefined error" title:"Alart!"
					)
			)
		)
		AddSubRollout sRoll Rebecca
	),
	-----------------------------------------------------------------------------------------
--ROLLOUTGROUP ANIMATION-----------------------------------------------------------------------
	--Biped Attach Tool------------------------------------------------------------
	fn ro_Bicky sRoll = (
		rollout Bicky "biped Attach Tool"
		(
			local rigname = "Name"
			local pointHip
			local pointLT
			local pointRT
			local targetPointLT
			local targetPointLC
			local targetPointLF
			local targetPointLNub
			local targetPointRT
			local targetPointRC
			local targetPointRF
			local targetPointRNub

			local spineArray
			local headArray
			local headLinkPoint
			local headLinkNub

			local pointLS
			local targetPointLS
			local targetPointLUa
			local targetPointLFa
			local targetPointLH
			
			local leftFingerArray
			local leftFingerCount

			local pointRS
			local targetPointRS
			local targetPointRUa
			local targetPointRFa
			local targetPointRH
			local rightFingerArray
			local rightFingerCount

			local baseName = "Name_Bip"
			local bip
			local pelvis
			local leftThigh
			local leftCalf
			local leftFoot
			local leftToe
			local rightThigh
			local rightCalf
			local rightFoot
			local rightToe

			local neckLinkcount
			local spineLinkcount
			local legLinkcount
			local fingercount
			local fingerLinkcount
			local toescount
			local toesLinkcount
			local spinePartArray
			local headPartArray
			local headPart

			local leftShoulder
			local leftUpperarm
			local leftForearm
			local leftHand
			local leftFingerPartArray

			local rightShoulder
			local rightUpperarm
			local rightForearm
			local rightHand
			local rightFingerPartArray

			-------------------------------------------------------------------------
			--functions
			-------------------------------------------------------------------------
			
			fn FingerCounter Handpoint = 
			(
				HandCldArray = Handpoint.children
				temp = #()
				FingerCountArray = #()
				for i = 1 to HandCldArray.count do 
				(
					if (findString HandCldArray[i].name "_LinkPoint") != undefind do 
					(
						append temp HandCldArray[i]
					)
				)
				
				listed = sort(for i in temp collect i.name)
				for i=1 to listed.count do
				(
					newNode = getnodebyname (listed[i] as string) exact:true
					appendIfUnique FingerCountArray newNode
				)
				
				return FingerCountArray
			)
			
			fn getChildren obj =
			(
				children = for c in obj.children collect c
				for c in children do
				(
					join children (for c in c.children collect c)
				)
				return children
			)
			
		------------------------------------------------------------------------------
		--align functions
		------------------------------------------------------------------------------
			fn scaleToLength part p1 p2 =
			(
				scalePart		= biped.getTransform part #scale
				lengthPart	= distance p1 p2
				biped.setTransform part #scale [lengthPart, scalePart.y, scalePart.z] false
			)
			
			fn rotateFromPoints part p1 p2 offset =
			(
				theVector	= normalize (p1.pos - p2.pos)
				theMatrix	= matrixFromNormal theVector
				preRotate theMatrix offset
				biped.setTransform part #rotation theMatrix false
			)

		-------------------------------------------------------------------------------------
		--おしり
		-------------------------------------------------------------------------------------
			fn hipsAlign bip p1 p2 pel =
			(
				hipsPos		= (p1.pos + p2.pos) / 2
				biped.setTransform bip #pos hipsPos false
				
				scaleP		= biped.getTransform pelvis #scale
				hipsWidth	= distance pointLT pointRT
				biped.setTransform pel #scale [scaleP.x, scaleP.y, hipsWidth] false
				
				rotateFromPoints bip pointLT pointRT (eulerAngles -90 180 0)
			)

		-------------------------------------------------------------------------------------
		--上腕　＆　太もも
		-------------------------------------------------------------------------------------
			fn proximalAlign part p2 p3 =
			(
				p1 = part --biped.getTransform part #pos
				scaleToLength part p1 p2
				
				p1 = biped.getTransform part #pos
				
				outVector	= normalize (p3.pos - p1)
				partVector	= normalize (p2.pos - p1)
				rightVector	= normalize (cross outVector partVector)
				upVector	= normalize (cross rightVector partVector)
				theMatrix	= matrix3 partVector upVector rightVector p1
				biped.setTransform part #rotation theMatrix false
			)

			fn fourPointAngle pA pB pC pD =
			(
				local vAB = pB - pA
				local vCD = pD - pC
				local vectorangle = acos (dot (normalize vAB) (normalize vCD))
				if vectorangle < 90.0 then vectorangle 
				else (180.0 - vectorangle)
			)

		-------------------------------------------------------------------------------------
		--下腕　＆　脛
		-------------------------------------------------------------------------------------
			fn distalAlign part p1 p2 =
			(
				scaleToLength part p1 p2
					p3		= biped.getTransform part.children[1] #pos
					partAngle	= fourPointAngle p1.pos p3 p1.pos p2.pos
					rotate part (angleAxis -partAngle [0,0,1])
			)

		-------------------------------------------------------------------------------------
		--足
		-------------------------------------------------------------------------------------
			fn footAlign foot p1 p2 =
			(
				biped.setTransform foot #pos (p1.transform.translationpart) false
				biped.setTransform foot #rotation (p1.transform.rotationpart) false
				
				scalePart		= biped.getTransform foot #scale
				lengthPart	= distance p1 p2
				biped.setTransform foot #scale [scalePart.X, lengthPart, scalePart.z] false
				
				rescaleFoot = biped.getTransform foot #scale
				if p1.pos.z < 0 then adlengthX = p1.pos.z * -1 - rescaleFoot.X else adlengthX = p1.pos.z -  rescaleFoot.X
				RelengthX = rescaleFoot.X + adlengthX
				RelengthX = rescaleFoot.X
				RelengthY = rescaleFoot.Y
				biped.setTransform foot #scale [RelengthX, RelengthY, rescaleFoot.Z] false
			)

		-------------------------------------------------------------------------------------
		--つま先
		-------------------------------------------------------------------------------------
			fn ToeAlign part p1 p2 =
			(
				scaleToLength part p1 p2
				biped.setTransform part #rotation (p1.transform.rotationpart) false
				biped.setTransform part #pos p1.pos false
			)
			
		-------------------------------------------------------------------------------------
		--背骨
		-------------------------------------------------------------------------------------
			fn spineAlign spinePartArray spineArray =
			(
				biped.setTransform spinePartArray[1] #pos (spineArray[1].transform.translationpart) false
				for i = 1 to (spineArray.count - 1) do
				(
					scaleToLength spinePartArray[i] spineArray[i] spineArray[i + 1]
					rotateFromPoints spinePartArray[i] spineArray[i] spineArray[i + 1] (eulerAngles 180 90 0)
					
					if i ==  (spineArray.count - 1) do 
					(
						scalePart		= biped.getTransform spinepartArray[i] #scale
						rescalePart	= scalePart.Z - 1.298
						biped.setTransform spinepartArray[i] #scale [scalePart.X, scalePart.y, rescalePart] false
					)
				)
			)

		-------------------------------------------------------------------------------------
		--頭
		-------------------------------------------------------------------------------------
			fn headAlign headPartArray headArray =
			(
				biped.setTransform headPartArray[1] #pos (headArray[1].transform.translationpart) false

				for i = 1 to (headArray.count - 1) do
				(
					if i < (headArray.count - 1) do
					(
						scaleToLength headPartArray[i] headArray[i] headArray[i + 1]
					)
					rotateFromPoints headPartArray[i] headArray[i] headArray[i + 1] (eulerAngles 180 90 0)
				)
			)
			
		-------------------------------------------------------------------------------------
		--肩
		-------------------------------------------------------------------------------------
			fn shoulderAlign part p1 p2 =
			(
				topSpine	= spinePartArray[spinePartArray.count]
				topSpinePoint	= spineArray[spineArray.count - 1]
				biped.setTransform topSpine #rotation (topSpinePoint.transform.rotationpart) false
				
				initPointRotate = topSpinePoint.rotation
				initPointpos = topSpinePoint.pos
				initspineRotate = biped.getTransform topSpine #rotation
				
				biped.setTransform topSpine #rotation (quat -0.707107 0 -0.707107 0) false
				
				topSpinePoint.rotation = biped.getTransform topSpine #rotation
				topSpinePoint.pos = biped.getTransform topSpine #pos
				
				biped.setTransform part #pos (p1.transform.translationpart) false
				scaleToLength part p1 p2
				
				-------------------------------------------------------------------------------
				--暫定処理--
				-------------------------------------------------------------------------------
				bip.controller.figureMode = false
				shoulderAngle = 0
				if part == rightShoulder do shoulderAngle = 180
				rotateFromPoints part p1 p2 (eulerAngles shoulderAngle 90 90)
				
				select part
				biped.createCopyCollection bip.controller bip.name
				bippose = biped.copyPosture part.controller #posture true true true
				bip.controller.figureMode = true
				biped.pastePosture part.controller #posture false bippose
				clearselection
				
				biped.setTransform topSpine #rotation initspineRotate false
				topSpinePoint.rotation = initPointRotate
				topSpinePoint.pos = initPointpos
				
				biped.deleteAllCopies bip.controller #posture
				biped.deleteAllCopyCollections bip.controller
			)
			
		-------------------------------------------------------------------------------------
		--手　＆　指
		-------------------------------------------------------------------------------------

				fn fingerAlign handpart handpoint fingerPartArray fingerArray =
			(
				biped.setTransform handpart #rotation (handpoint.transform.rotationpart) false
				----------------------------------------------------------------------------
				--付け根
				----------------------------------------------------------------------------
				handpartCld = for c in handpart.children collect c
				handpointCld = FingerCounter Handpoint
				for i = 1 to handpartCld.count do 
				(
					biped.setTransform handpartCld[i] #pos (handpointCld[i].transform.translationpart) false
				)
				--------------------------------------------------------------------------
				--親指
				--------------------------------------------------------------------------
				for i = 1 to 3 do
				(
					scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
					biped.setTransform fingerPartArray[i] #rotation (fingerArray[i].transform.rotationpart) false
					--rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 90)
				)
				--------------------------------------------------------------------------
				--人差し指　　他の指と軸設定が違うので注意
				--------------------------------------------------------------------------
				for i = 6 to 8 do 
				(
					-----------------------------------------
					--右手側
					-----------------------------------------
					if handPart == righthand then (
						--指関節付け根だけ軸が違うので別処理
						scaleToLength fingerPartArray[5] fingerArray[5] fingerArray[6]
						rotateFromPoints fingerPartArray[5] fingerArray[5] fingerArray[6] (eulerAngles 180 90 0)
						
						scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
						rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 -90)
					)
					else (
					----------------------------------------
					--左手側
					----------------------------------------
						--指関節付け根だけ軸が違うので別処理
						scaleToLength fingerPartArray[5] fingerArray[5] fingerArray[6]
						rotateFromPoints fingerPartArray[5] fingerArray[5] fingerArray[6] (eulerAngles 180 90 0)
						
						scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
						rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 90)
					)
				)
				--------------------------------------------
				--中指以降は同処理
				--------------------------------------------
				for i = 10 to 13 do  
				(
					scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
					rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 0)
				)
				
				for i = 15 to 18 do
				(
					scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
					rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 0)
				)
				
				for i = 20 to 23 do 
				(
					scaleToLength fingerPartArray[i] fingerArray[i] fingerArray[i + 1]
					rotateFromPoints fingerPartArray[i] fingerArray[i] fingerArray[i + 1] (eulerAngles 180 90 0)
				)	
			)

		---------------------------------------------------------------------------------------------------------------------------------------------
			label bipname_lbl "biped name:" align:#left
			edittext bip_name text:baseName align:#right 
			label rigname_lbl "rig name:" align:#left
			edittext rig_name text:rigname align:#right 
			Button Bicky_BTN "Start" width:140 height:60 align:#center

			on bip_name entered arg do (
				baseName = arg
			)
			on rig_name entered arg do (
				rigname = arg
			)	

			on Bicky_BTN pressed do (
				-------------------------------------------------------------------------
				--check LinkPoint
				-------------------------------------------------------------------------
				pointHip 	= execute ("$'" + rigname + "_LinkPoint Pelvis'")

				pointLT		= execute ("$'" + rigname + "_LinkPoint L Thigh'")
				pointRT		= execute ("$'" + rigname + "_LinkPoint R Thigh'")

				targetPointLT	= execute ("$'" + rigname + "_LinkPoint L Calf'")
				targetPointLC 	= execute ("$'" + rigname + "_LinkPoint L Foot'")
				targetPointLF 	= execute ("$'" + rigname + "_LinkPoint L Toe0'")
				targetPointLNub = execute ("$'" + rigname + "_LinkPoint L Toe0Nub'")

				targetPointRT	= execute ("$'" + rigname + "_LinkPoint R Calf'")
				targetPointRC	= execute ("$'" + rigname + "_LinkPoint R Foot'")
				targetPointRF	= execute ("$'" + rigname + "_LinkPoint R Toe0'")
				targetPointRNub = execute ("$'" + rigname + "_LinkPoint R Toe0Nub'")

				spineArray = #()
				for i = 1 to 3 do
				(
					id = ""
					if i > 1 do id = (i - 1) as string
					spineLinkPoint = execute ("$'" + rigname + "_LinkPoint Spine" + id +"'")
					if spineLinkPoint != undefined do 
					(
						append spineArray spineLinkPoint
					)
				)

				headArray = #()
				for i = 1 to 3 do
				(
					id = ""
					if i > 1 do id = (i - 1) as string
					neckLinkPoint = execute ("$'" + rigname + "_LinkPoint Neck" + id +"'")
					if neckLinkPoint != undefined do 
					(
						append headArray neckLinkPoint
					)
				)

				headLinkPoint = execute ("$'" + rigname + "_LinkPoint Head'")
				append headArray headLinkPoint

				headLinkNub = execute ("$'" + rigname + "_LinkPoint HeadNub'")
				append headArray headLinkNub
				
				append spineArray headArray[1]
				
				-------------------------------------------------------------------------
				--check Left Arm
				-------------------------------------------------------------------------
				pointLS		= execute ("$'" + rigname + "_LinkPoint L Clavicle'")
				targetPointLS	= execute ("$'" + rigname + "_LinkPoint L UpperArm'")
				targetPointLUa	= execute ("$'" + rigname + "_LinkPoint L ForeArm'")
				targetPointLFa	= execute ("$'" + rigname + "_LinkPoint L Hand'")
				targetPointLH	= execute ("$'" + rigname + "_LinkPoint L Finger2'")
				
				leftFingerArray = #()
				leftFingerCount = FingerCounter targetPointLFa	

				for i = 1 to leftFingerCount.count do
				(
					leftFingerLinkCount =  getChildren leftFingerCount[i]
					baseID = (i - 1) as string
					for s = 1 to leftFingerLinkCount.count do 
					(
						id = ""
						if s > 1 do id = (s - 1) as string
						leftFingerPart = execute ("$'" + rigname + "_LinkPoint L Finger" +baseID + id + "'")
						if leftFingerPart != undefined do 
						(
							append leftFingerArray leftFingerPart
						)
					)
					
					leftFingerNub = execute ("$'" + rigname + " _LinkPoint L Finger" + baseID + "Nub'")
					append leftFingerArray leftFingerNub		
				)

				-------------------------------------------------------------------------
				--check Right Arm
				-------------------------------------------------------------------------
				pointRS		= execute ("$'" + rigname + "_LinkPoint R Clavicle'")
				targetPointRS	= execute ("$'" + rigname + "_LinkPoint R UpperArm'")
				targetPointRUa	= execute ("$'" + rigname + "_LinkPoint R ForeArm'")
				targetPointRFa	= execute ("$'" + rigname + "_LinkPoint R Hand'")
				targetPointRH	= execute ("$'" + rigname + "_LinkPoint R Finger2'")
				
				rightFingerArray = #()
				rightFingerCount = FingerCounter targetPointRFa
				
				for i = 1 to rightFingerCount.count do
				(
					rightFingerLinkCount =  getChildren rightFingerCount[i]
					baseID = (i - 1) as string
					for s = 1 to 4 do 
					(
						id = ""
						if s > 1 do id = (s - 1) as string
						rightFingerPart = execute ("$'" + rigname + "_LinkPoint R Finger" +baseID + id + "'")
						if rightFingerPart != undefined do 
						(
							append rightFingerArray rightFingerPart
						)
					)
					
					rightFingerNub = execute ("$'" + rigname + " _LinkPoint R Finger" + baseID + "Nub'")
					append rightFingerArray rightFingerNub	
				)
				

				-------------------------------------------------------------------------
				--check all biped bones
				-------------------------------------------------------------------------
				bip			= execute ("$'" + basename)
				pelvis		= execute ("$'" + basename + " Pelvis'")
				leftThigh	= execute ("$'" + basename + " L Thigh'")
				leftCalf	= execute ("$'" + basename + " L Calf'")
				leftFoot	= execute ("$'" + basename + " L Foot'")
				leftToe = execute  ("$'" + basename + " L Toe0'")
				rightThigh	= execute ("$'" + basename + " R Thigh'")
				rightCalf	= execute ("$'" + basename + " R Calf'")
				rightFoot	= execute ("$'" + basename + " R Foot'")
				rightToe = execute  ("$'" + basename + " R Toe0'")

				neckLinkcount 	= bip.controller.neckLinks
				spineLinkcount 	= bip.controller.spineLinks
				legLinkcount 	= bip.controller.legLinks
				fingercount 	= bip.controller.fingers
				fingerLinkcount = bip.controller.fingerLinks
				toescount 		= bip.controller.toes
				toesLinkcount 	= bip.controller.toeLinks
				
				------------------------------------------------------------------------------------
				--stored in Array
				------------------------------------------------------------------------------------
				spinePartArray = #()
				for i = 1 to spineLinkcount do
				(
					id = ""
					if i > 1 do id = (i - 1) as string
					spinePart = execute ("$'" + basename + " Spine" + id + "'")
					if spinePart != undefined do 
					(
						append spinePartArray spinePart
					)
				)

				headPartArray = #()
				for i = 1 to neckLinkcount do
				(
					id = ""
					if i > 1 do id = (i - 1) as string
					neckPart = execute ("$'" + basename + " Neck" + id + "'")
					if neckPart != undefined do 
					(
						append headPartArray neckPart
					)
				)

				headPart = execute ("$'" + basename + " Head" + "'")
				append headPartArray headPart

				leftShoulder	= execute ("$'" + basename + " L Clavicle'")
				leftUpperarm	= execute ("$'" + basename + " L Upperarm'")
				leftForearm	= execute ("$'" + basename + " L Forearm'")
				leftHand	= execute ("$'" + basename + " L Hand'")
				
				leftFingerPartArray = #()	
				if fingercount != 0 do
				(
					for i = 1 to fingercount do
					(
						baseID = (i - 1) as string
						for s = 1 to fingerLinkCount do 
						(
							id = ""
							if s > 1 do id = (s - 1) as string
							leftFingerPart = execute ("$'" + basename + " L Finger" +baseID + id + "'")
							if leftFingerPart != undefined do 
							(
								append leftFingerPartArray leftFingerPart
							)
						)

						leftFingerNub = execute ("$'" + basename + " L Finger" + baseID + "Nub'")
						append leftFingerPartArray leftFingerNub	
						i += 1		
					)
				)

				rightShoulder	= execute ("$'" + basename + " R Clavicle'") 
				rightUpperarm	= execute ("$'" + basename + " R Upperarm'")
				rightForearm	= execute ("$'" + basename + " R Forearm'")
				rightHand	= execute ("$'" + basename + " R Hand'")

				rightFingerPartArray = #()

					if fingercount != 0 do
				(
					for i = 1 to fingercount do
					(
						baseID = (i - 1) as string
						for s = 1 to fingerLinkCount do 
						(
							id = ""
							if s > 1 do id = (s - 1) as string
							rightFingerPart = execute ("$'" + basename + " R Finger" +baseID + id + "'")
							if rightFingerPart != undefined do 
							(
								append rightFingerPartArray rightFingerPart
							)
						)

						rightFingerNub = execute ("$'" + basename + " R Finger" + baseID + "Nub'")
						append rightFingerPartArray rightFingerNub	
						i += 1		
					)
				)

				hipsAlign bip pointLT pointRT pelvis
				proximalAlign leftThigh targetPointLT targetPointLC
				distalAlign leftCalf targetPointLT targetPointLC
				footAlign leftFoot targetPointLC targetPointLF
				--toeAlign leftToe targetPointLF targetPointLNub

				proximalAlign rightThigh targetPointRT targetPointRC
				distalAlign rightCalf targetPointRT targetPointRC
				footAlign rightFoot targetPointRC targetPointRF
				--toeAlign rightToe targetPointRF targetPointRNub

				spineAlign spinePartArray spineArray

				shoulderAlign leftShoulder pointLS targetPointLS
				shoulderAlign rightShoulder pointRS targetPointRS

				proximalAlign leftUpperarm targetPointLUa targetPointLFa
				proximalAlign rightUpperarm targetPointRUa targetPointRFa

				distalAlign leftForearm targetPointLUa targetPointLFa
				distalAlign rightForearm targetPointRUa targetPointRFa

				fingerAlign lefthand targetPointLFa leftfingerPartArray leftfingerArray
				fingerAlign righthand targetPointRFa rightfingerPartArray rightfingerArray

				headAlign headPartArray headArray
			)
		)
		AddSubRollout sRoll Bicky
	),
	--BipedXtra Selector------------------------------------------------------------
	fn ro_Scarlett sRoll = (
		rollout Scarlett "BipedXtra Selector" 
		(
			Button Scarlett_BTN "Select BipedXtras"  width:140 height:30 align:#center
			on Scarlett_BTN pressed do (
				
				fn GetAllBipedXtras bip =
				(
				--Get all non Xtras
				knownbipbonesidarr = #{1..22,101..110} as Array
				knownbipbonesarr = #()
				for i in knownbipbonesidarr do
				(
				for j = 1 to 5 do
				(
				currentnode = biped.getNode bip i link:j
				if currentnode != undefined then append knownbipbonesarr currentnode
				)
				)
				--Get all biped children that are bip objects
				allbipbonesarr = #()
				append allbipbonesarr bip
				i=1
				while i <= allbipbonesarr.count do
				(
				childCount = allbipbonesarr[i].children.count
				if childCount !=0 do
				(
				for j=1 to childCount do
				(
				currentchild = allbipbonesarr[i].children[j]
				if classof currentchild == Biped_Object then append allbipbonesarr currentchild
				)
				)
				i+=1
				)
				--filter non xtras from all children
				xtrabonesarr = #()
				for i in allbipbonesarr do
				(
				currentbone = finditem knownbipbonesarr i
				if currentbone == 0 then append xtrabonesarr i
				)
				return xtrabonesarr
				)
				if selection.count ==1 then (
					
				if (classOf selection[1] == Biped_Object and classof selection[1].controller == Vertical_Horizontal_Turn) then (
					
					GetAllBipedXtras $
					clearselection()
					rollout bs_xtra_roll "Xtra"width:160 height:300
					(
						Multilistbox bipedxtra "Xtra:" height:20
					on bipedxtra selected v do
					(
						if bipedxtra.selection[v] then
						selectMore (getNodeByName bipedxtra.items[v])
						
						else
						deselect (getNodeByName bipedxtra.items[v])
					)
					)
					CreateDialog bs_xtra_roll
					bs_xtra_roll.bipedxtra.items = sort(for s in xtrabonesarr collect s.name)
				)
				else (
					messagebox "Please select BipedRoot" title:"Alart!"
					)
				)
				else (
					messagebox "Please select BipedRoot" title:"Alart!"
					)
					)-- on BTN end--
		)
		AddSubRollout sRoll Scarlett
	),
---------------------------------------------------------------------------------------------------
	fn readAboutFile =
	(
	aboutFile = openFile  ((getDir #scripts) + "\\Madoka\\include\\about.txt") mode:#rt
	fileText = readDelimitedString aboutFile "~"
	close aboutFile
	fileText
	),

	fn createAboutRollout = (
		try(destroyDialog Aimee)catch()
		
		rollout Aimee "About" width:620 height:480
		(
			label Version VersionInfo pos:[5,67]
			dotnetcontrol aboutTextbox "System.Windows.Forms.RichTextBox" width:(Aimee.width - 10) height:(Aimee.height - 118) align:#left pos:[5,85]
			Button about_BTN "OK"  width:(Aimee.width - 10) height:23 align:#center

			on Aimee open do
			(
				aboutText = madokaFn.readAboutFile()
				aboutTextbox.multiline = true
				aboutTextbox.wordwrap = true
				aboutTextbox.ReadOnly = true
				aboutTextbox.DetectUrls = false
				aboutTextbox.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
				aboutTextbox.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 200 200 200
				aboutTextbox.BorderStyle = none
				aboutTextbox.text = aboutText
			)
			on about_BTN pressed do
			(
				destroyDialog Aimee
			)
		)
		createDialog Aimee	
	),

---------------------------------------------------------------------------------------------------
	fn ro_Prefarence = (

		try(destroyDialog Patty)catch()

		rollout Patty "Prefarence" width:300 height:250
		(
			checkbox pref_CA_box "Use characterized script" checked:true pos:[20,20]

			on Patty open do(
				checkBoxState = madokaFn.prefINIget()

				if checkBoxState == "true" then (
					pref_CA_box.triState = 1
					)
				else (
					pref_CA_box.triState = 0
					)
			)

			on pref_CA_box changed thestate do (
				checkBoxState = thestate
				)
		)
		rcmenu madoka_premenu
		(
			subMenu "File"
			(
				menuItem item1 "Save Prefarence"
				separator sp1
				menuItem item2 "Reset Prefarence"
			)
			
			on item1 picked do
				(
					madokaFn.prefINIsave checkBoxState
				)

			on item2 picked do
				(
					checkBoxState = "false"
					madokaFn.prefINIsave checkBoxState
					Patty.pref_CA_box.triState = 0
				)
		)
		createdialog Patty menu:madoka_premenu
	),
---------------------------------------------------------------------------------------------------

	fn add_ModelRollouts sRoll =(
		madokaFn.ro_Sylvia sRoll
		madokaFn.ro_Melody sRoll
		madokaFn.ro_Tina sRoll
		madokaFn.ro_Stella sRoll
		madokaFn.ro_Matilda sRoll
		madokaFn.ro_Kelly sRoll
		madokaFn.ro_Priscilla sRoll
		madokaFn.ro_Iris sRoll
		madokaFn.ro_Charlotte sRoll
		madokaFn.ro_Lola sRoll
		madokaFn.ro_Bonnie sRoll
		madokaFn.ro_Lisa sRoll
		madokaFn.ro_Katherine sRoll
	),

	fn add_RenderRollouts sRoll =(
		madokaFn.ro_Rebecca sRoll
	),

	fn add_AnimRollouts sRoll =(
		madokaFn.ro_Bicky sRoll
		madokaFn.ro_Scarlett sRoll
	)
)