import os,os.path,re,glob
import maya.cmds as mc

def incrementFileName(ST_path,ST_vName="_",IN_defIncrementNum=3):

	if os.path.exists(ST_path):
		basename = os.path.basename(ST_path)
		fileName = os.path.splitext(basename)[0]
		fileNameNonVer = re.sub(ST_vName+"v[0-9]+$","",fileName)
		fileExt = os.path.splitext(basename)[1]
		dirName = os.path.dirname(ST_path)

		fileList = glob.glob(dirName+"/"+ fileNameNonVer + ST_vName + "v" + "*"+fileExt)

		incrimentNum = 0

		if len(fileList) == 0:
			incrimentNum = 1
		else:
			maxNum = 1
			for files in fileList:
				buff = files.split(ST_vName + "v")
				if maxNum < int(buff[len(buff) -1].strip(fileExt)):
					maxNum = int(buff[len(buff) -1].strip(fileExt))
			incrimentNum = maxNum + 1
		return dirName + "/" + fileNameNonVer + ST_vName + "v" + str(incrimentNum).zfill(IN_defIncrementNum) + fileExt

def incrementSaveFile():

	ST_mayaScenes = mc.file(q=True,sceneName=True)

	if ST_mayaScenes != "":

		ST_IncrementFileName = incrementFileName(ST_mayaScenes)
		os.rename(ST_mayaScenes,ST_IncrementFileName)
		mc.file(save=True)
	else:
		multipleFilters = "Maya ASCII (*.ma);;Maya Binary (*.mb);;All Files (*.*)"
		saveFileName = mc.fileDialog2(fileFilter=multipleFilters, dialogStyle=1)
		print saveFileName[0]
		ST_type = "mayaAscii"

		if os.path.splitext(saveFileName[0])[1] == ".mb":
			ST_type = "mayaBinary"
			mc.file(rename=saveFileName[0])
			mc.file(save=True,f=True,type=ST_type)

incrementSaveFile()
