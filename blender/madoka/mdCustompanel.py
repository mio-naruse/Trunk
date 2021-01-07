import os
import random
import bpy
from PySide2 import QtWidgets, QtCore, QtGui
from . import QtWindowEventLoop


class ImageWidget(QtWidgets.QWidget):
    def __init__(self, label_name, text):
        super().__init__()
        self.resize(720, 300)
        self.setWindowTitle('Qt Window')
        self.setWindowFlags(QtCore.Qt.WindowStaysOnTopHint)
        self.label = QtWidgets.QLabel(label_name)
        self.label2 = QtWidgets.QLabel(text)
        self.label3 = QtWidgets.QLabel()

        pixmap = QtGui.QPixmap('C:\\Users\\komomomo\\Dropbox\\grafics\\t_ico.png')
        self.label4 = QtWidgets.QLabel()
        self.label4.setPixmap(pixmap) 
        
        layout = QtWidgets.QVBoxLayout()
        layout.setContentsMargins(0, 0, 0, 0)
        layout.addWidget(self.label)
        layout.addWidget(self.label2)
        layout.addWidget(self.label3)

        layout.addWidget(self.label4)

        self.setLayout(layout)
        self.show()

    def enterEvent(self, event):
        self.label3.setText(bpy.context.object.name)


class CustomWindowOperator(QtWindowEventLoop):
    bl_idname = 'screen.meditcustom_window'
    bl_label = 'Image Viewer'
    bl_description = "test"
    #bl_options = {'REGISTER', 'UNDO'}

    def __init__(self):
        super().__init__(ImageWidget, 'LABEL_NAME', text='a text')
        