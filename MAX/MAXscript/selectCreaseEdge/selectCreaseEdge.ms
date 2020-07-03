rollout ro_selCreaseEdge "select crease edge" (
    button btn_exec "select" width:140 height:30 align:#center

    on btn_exec pressed do (
        p = undefined
		p =$selection as array
		edgecount = p[1].edges .count
		seledgearray = #()
		cwaitarray = #()
		j = 1
		for i = 1 to edgecount do(
			polyop.setedgeSelection p[1] #{i}	
		 numsel = 1
		 uniform = false
		cwait = $.EditablePoly.getEdgeData 1&numsel &uniform

			if cwait > 0 do(
				 seledgearray[j] = i
				 cwaitarray[j] = cwait
				j = j+ 1
			)
		)
		polyop.setedgeSelection p[1] seledgearray
			)
)

createDialog ro_selCreaseEdge