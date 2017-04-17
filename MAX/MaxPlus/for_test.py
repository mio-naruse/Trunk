import MaxPlus

def chackScale():
 list_obj =[]
 selections = MaxPlus.SelectionManager.Nodes
 for n in selections:
  if n.Scaling != MaxPlus.Point3(1,1,1):
   list_obj.append(n)

 for i in list_obj:
  print i.Name


if __name__ == '__main__':
 chackScale()