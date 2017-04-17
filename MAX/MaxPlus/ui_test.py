from PySide import QtGui
import MaxPlus


class _GCProtector(object):
    widgets = []

def make_cylinder():
    obj = MaxPlus.Factory.CreateGeomObject(MaxPlus.ClassIds.Cylinder)
    obj.ParameterBlock.Radius.Value = 10.0
    obj.ParameterBlock.Height.Value = 30.0
    node = MaxPlus.Factory.CreateNode(obj)
    time = MaxPlus.Core.GetCurrentTime()
    MaxPlus.ViewportManager.RedrawViews(time)
    return

app = QtGui.QApplication.instance()
if not app:
    app = QtGui.QApplication([])
    
def main():     
    MaxPlus.FileManager.Reset(True)
    
    w = QtGui.QWidget(MaxPlus.GetQMaxWindow())
    _GCProtector.widgets.append( w )
    w.resize(250, 100)
    w.setWindowTitle('PySide Qt Window')

    main_layout = QtGui.QVBoxLayout()
    label = QtGui.QLabel("Click button to create a cylinder in the scene")
    main_layout.addWidget(label)

    cylinder_btn = QtGui.QPushButton("Cylinder")
    cylinder_btn.clicked.connect(make_cylinder)
    main_layout.addWidget(cylinder_btn)
    
    textEdit = QtGui.QLineEdit()
    textEdit.setText("Edit box")
    main_layout.addWidget(textEdit)
    
    w.setLayout( main_layout )
    w.show()

    
if __name__ == '__main__':
    main()