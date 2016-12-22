import pymel.core as pm

meshes = pm.selected(o=True)

area = 0.0

for mesh in meshes:
area += mesh.getShape().area() # この行の先頭に半角スペースを4つ入れてください。

print u"表面積:", area

# ここまで