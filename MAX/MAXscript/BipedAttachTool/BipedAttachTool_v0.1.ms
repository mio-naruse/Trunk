rollout Bicky "biped attach tool" width:200 height:120
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
		
		scalePart = biped.getTransform foot #scale
		lengthPart = distance p1 p2
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
	label rigname_lbl "rig name:" align:#left
	edittext bip_name text:baseName fieldWidth:100 align:#right pos:[(bipname_lbl.pos.x + 60),bipname_lbl.pos.y]
	edittext rig_name text:rigname fieldWidth:100 align:#right pos:[(rigname_lbl.pos.x + 60),rigname_lbl.pos.y]
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
createDialog Bicky