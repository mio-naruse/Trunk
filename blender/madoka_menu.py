# bpyインポート
import bpy

bl_info = {
    "name": "madoka",
    "author": "__NRSE",
    "version": (0, 1),
    "blender": (2, 80, 0),
    "location": "View3D > Sidebar > madoka",
    "description": "test addon",
    "warning": "",
    "support": 'TESTING',
    "wiki_url": "",
    "tracker_url": "",
    "category": "Object"
}

class MadokaSetOrigin(bpy.types.Operator):
    #Blender内部で使用するID [str]
    bl_idname = "object.set_origin"
    # BlenderのUI上で表示される文字列[str]
    bl_label = "Set objact Origin"
    # BlenderのUI上で表示される説明文[str]
    bl_description = "Set origin an active object"
    # オペレータの属性[set]
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):
        # 現在のアクティブオブジェクトをactive_objとして保存しておく
        active_obj = context.active_object
        bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY', center='BOUNDS')

        # 選択オブジェクトの回転値をすべてゼロに
        active_obj.rotation_euler[0] = 0
        active_obj.rotation_euler[1] = 0
        active_obj.rotation_euler[2] = 0

        # 選択オブジェクトの座標をゼロにして原点に移動
        active_obj.location[0] = 0
        active_obj.location[1] = 0
        active_obj.location[2] = 0


        #cursorpos = copy.copy(bpy.context.scene.cursor_location)

        # dimensions（境界面、バウンディングボックス）の大きさを取得
        dx = active_obj.dimensions.x
        dy = active_obj.dimensions.y
        dz = active_obj.dimensions.z

        #print(dx,dy,dz)
        # 境界面Zの半分だけ移動
        active_obj.location[2] = dz/2

        # 3Dカーソルの位置を指定位置（原点）に移動する
        bpy.context.scene.cursor.location = (0,0,0)
        # オブジェクトの原点を3Dカーソル位置に移動する
        bpy.ops.object.origin_set(type='ORIGIN_CURSOR')

        # オペレータメッセージを出力するメソッド
        # 引数
        #   第1引数: オペレータメッセージの種類 [set]
        #   第2引数: オペレータメッセージ本文 [str]
        self.report({'INFO'},
                    "madoka: Set objact Ooigin '{}'"
                    .format(active_obj.name))
        # コンソールウィンドウへメッセージを出力
        print("madoka: Operator '{}' is executed".format(self.bl_idname))

        # オペレータが正常終了したことをBlenderに通知
        return {'FINISHED'}


# メニューを構築する関数
def menu_fn(self, context):
    self.layout.separator()
    self.layout.operator(MadokaSetOrigin.bl_idname)


# Blenderに登録するクラス
classes = [
    MadokaSetOrigin,
]


# アドオン有効化時の処理
def register():
    for c in classes:
        bpy.utils.register_class(c)
    bpy.types.VIEW3D_MT_object.append(menu_fn)
    print("madoka: Add-on '{}' is enabled".format(bl_info["name"]))


# アドオン無効化時の処理
def unregister():
    bpy.types.VIEW3D_MT_object.remove(menu_fn)
    for c in classes:
        bpy.utils.unregister_class(c)
    print("madoka: Add-on '{}' is disabled".format(bl_info["name"]))


# メイン処理
if __name__ == "__main__":
    register()
