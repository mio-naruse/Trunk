macroScript BipedXtraSelector category:"tools" internalCategory:"tools" toolTip:"BipedXtraSelector" buttonText:"BipXSelector"
(
local xtrabonesarr 

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
	)--rollout end--
	CreateDialog bs_xtra_roll
	bs_xtra_roll.bipedxtra.items = sort(for s in xtrabonesarr collect s.name)
)

else (
	messagebox "Please select BipedRoot"
	)
)

else (
	messagebox "Please select BipedRoot"
	)
		
)--script end--