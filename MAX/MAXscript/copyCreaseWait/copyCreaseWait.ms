rollout ro_cpCreasewait "Copy crease wait" (

    button btn_exec "copy" width:140 height:30 align:#center

    on btn_exec pressed do (
		p=#()
		p = $selection as array

		polymod = p[1]
		setpolymod= p[2]

		getedgecount = polymod.edges .count
		setedgecount = setpolymod.edges .count

		seledgearray = #()
		cwaitarray = #()
		j = 1
		for i = 1 to getedgecount do(
			polyop.setedgeSelection polymod #{i}	
			numsel = 1
			uniform = false
			cwait = polymod.EditablePoly.getEdgeData 1&numsel &uniform

			if cwait > 0 do(
				seledgearray[j] = i
				cwaitarray[j] = cwait
				j = j+ 1
			)
		)

		for k = 1 to seledgearray.count do
		(
			for l = 1 to setedgecount do(
				
				verarray = polyop.getEdgeVerts polymod seledgearray[k]
				pos1 =polyop.getVert polymod verarray[1]
				pos2 =polyop.getVert polymod verarray[2]
				
				setverray = polyop.getEdgeVerts setpolymod l
				setpos1 =polyop.getVert polymod setverray[1]
				setpos2 =polyop.getVert polymod setverray[2]
				
				pos1xend = close_enough pos1.x setpos1.x 4
				pos1yend = close_enough pos1.y setpos1.y 4
				pos1zend = close_enough pos1.z setpos1.z 4
				
				pos2xend = close_enough pos2.x setpos2.x 4
				pos2yend = close_enough pos2.y setpos2.y 4
				pos2zend = close_enough pos2.z setpos2.z 4
					
				if pos1xend == true and pos1yend == true and pos1zend == true and pos2xend == true and pos2yend == true and pos2zend == true do
				(
					polyop.setedgeSelection setpolymod #{l}
					setpolymod.EditablePoly.setEdgeData 1  cwaitarray[k]
				)
			)
		)
	)
)

createDialog ro_cpCreasewait