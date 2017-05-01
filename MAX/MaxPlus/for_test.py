from PySide import QtGui
import MaxPlus

class _GCProtector(object):
	widgets = []

def checkScale():
	list_obj =[]
	selections = MaxPlus.SelectionManager.Nodes
	for n in selections:
	 if n.Scaling != MaxPlus.Point3(1,1,1):
	  list_obj.append(n)

	for i in list_obj:
	 print i.Name


app = QtGui.QApplication.instance()
if not app:
    app = QtGui.QApplication([])
    
def main():
    
    w = QtGui.QWidget(MaxPlus.GetQMaxWindow())
    _GCProtector.widgets.append( w )
    w.resize(250, 100)
    w.setWindowTitle('PySide Qt Window')

    main_layout = QtGui.QHBoxLayout()
    label = QtGui.QLabel("Click button to create a cylinder in the scene")
    main_layout.addWidget(label)

    cylinder_btn = QtGui.QPushButton("Check Scale")
    cylinder_btn.clicked.connect(checkScale)
    main_layout.addWidget(cylinder_btn)
    
    textEdit = QtGui.QLineEdit()
    textEdit.setText("Edit box")
    main_layout.addWidget(textEdit)
    
    w.setLayout( main_layout )
    w.show()

    
if __name__ == '__main__':
    main()