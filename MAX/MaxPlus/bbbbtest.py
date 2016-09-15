from PySide import QtGui
import MaxPlus

class Tab1Widget(QtGui.QWidget):
    def __init__(self, parent=None):
        super(Tab1Widget, self).__init__()
        closeBtn = QtGui.QPushButton('Close')
        closeBtn.clicked.connect(parent.close)
        hbox = QtGui.QHBoxLayout()
        hbox.addWidget(closeBtn)
        self.setLayout(hbox)

class UI(QtGui.QWidget):
    def __init__(self):
        super(UI, self).__init__()
        self.initUI()

    def initUI(self):
        qtab = QtGui.QTabWidget()
        qtab.addTab(Tab1Widget(parent=self), 'Tab1')
        qtab.addTab(QtGui.QLabel('Label 2'), 'Tab2')

        hbox = QtGui.QHBoxLayout()
        hbox.addWidget(qtab)

        self.setLayout(hbox)

        self.setGeometry(300, 300, 250, 150)
        self.setWindowTitle('Tab Layout')
        self.show()

def main():
    app = QtGui.QApplication(sys.argv)
    ui = UI()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
