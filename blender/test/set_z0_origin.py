# bpyインポート
import bpy

def set_z0_origin(arg_location=(0,0,0)):
    # 現在のアクティブオブジェクトをsrc_objとして保存しておく
    src_obj = bpy.context.view_layer.objects.active

    bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY', center='BOUNDS')

    # 選択オブジェクトの回転地をすべてゼロに
    bpy.context.object.rotation_euler[0] = 0
    bpy.context.object.rotation_euler[1] = 0
    bpy.context.object.rotation_euler[2] = 0

    # 選択オブジェクトの座標をゼロにして原点に移動
    bpy.context.object.location[0] = 0
    bpy.context.object.location[1] = 0
    bpy.context.object.location[2] = 0


    #cursorpos = copy.copy(bpy.context.scene.cursor_location)

    # dimensions（境界面、バウンディングボックス）の大きさを取得
    dx = bpy.context.object.dimensions.x
    dy = bpy.context.object.dimensions.y
    dz = bpy.context.object.dimensions.z

    #print(dx,dy,dz)
    # 境界面Zの半分だけ移動
    bpy.context.object.location[2] = dz/2

    # 3Dカーソルの位置を指定位置（原点）に移動する
    bpy.context.scene.cursor.location = arg_location
    # オブジェクトの原点を3Dカーソル位置に移動する
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
    return

# 関数の実行例
set_z0_origin((0,0,0))