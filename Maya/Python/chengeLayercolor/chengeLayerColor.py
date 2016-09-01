# -*- coding: utf-8 -*-
import os
import maya.cmds as cmds  
import maya.mel as mel

  
def selectPalette():
  
    selectNum = cmds.palettePort(palette,q=True,scc=True)
    print selectNum
    changeLayerColor(selectNum)

def changeLayerColor(colorNum):
    
    failedfiles = []
    layers = cmds.ls(type='displayLayer')
    
    for layer in layers:
        if not layer == "defaultLayer":
            selectionStatus = cmds.layerButton(layer, query=True, select=True)
    
            if selectionStatus:
                cmds.setAttr("%s.color"%layer, colorNum)
                                       
    if len(failedfiles) > 0:
        txt = "--- Failed Layer(s) List ---\n\n "
        txt += ",\n".join(map(str,failedfiles))                
        cmds.confirmDialog( title='ExportResult', 
        message=txt, button=['Confirm'])
        
windowName = "changeLayerColorUI"
if cmds.window(windowName,exists=True) == True:
    cmds.deleteUI(windowName)
paletteWindow = cmds.window(windowName,title=windowName)
paletteLayout = cmds.frameLayout(labelVisible=0)
palette = cmds.palettePort( dimensions=(16,2),width=16 * 20,height= 2 * 20,transparent = 0,topDown=True,colorEditable=False,cc=selectPalette)
  
for i in range(1,31):
  
    col = cmds.colorIndex(i,q=True)
    cmds.palettePort(palette,e=True,rgbValue=(i,col[0],col[1],col[2]))
  
cmds.showWindow(paletteWindow)