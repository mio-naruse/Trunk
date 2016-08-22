import maya.cmds as cmds
unknownPluginNodes = cmds.unknownPlugin( q=True, l=True)
for unk in unknownPluginNodes
	cmds.unknownPlugin( unk, r=True )