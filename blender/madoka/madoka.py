# bpyインポート
import bpy
from mathutils import Matrix, Vector
import copy

bl_info = {
    "name": "Madoka",
    "author": "__NRSE",
    "version": (0, 1),
    "blender": (2, 80, 0),
    "location": "View3D > Sidebar > Madoka",
    "description": "test addon",
    "warning": "",
    "support": 'TESTING',
    "wiki_url": "",
    "tracker_url": "",
    "category": "Object"
}

class MadokaSetOriginC(bpy.types.Operator):
    #Blender内部で使用するID [str]
    bl_idname = "object.set_origin_center"
    # BlenderのUI上で表示される文字列[str]
    bl_label = "Set objact Origin Center"
    # BlenderのUI上で表示される説明文[str]
    bl_description = "Set origin Center an active object"
    # オペレータの属性[set]
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):
        # 現在のアクティブオブジェクトをactive_objとして保存しておく
        active_obj = context.active_object

        bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY', center='MEDIAN')

        # オペレータメッセージを出力するメソッド
        # 引数
        #   第1引数: オペレータメッセージの種類 [set]
        #   第2引数: オペレータメッセージ本文 [str]
        self.report({'INFO'},
                    "madoka: Set objact Origin '{}'"
                    .format(active_obj.name))
        # コンソールウィンドウへメッセージを出力
        print("madoka: Operator '{}' is executed".format(self.bl_idname))

        # オペレータが正常終了したことをBlenderに通知
        return {'FINISHED'}


class MadokaSetOriginXmin(bpy.types.Operator):
    #Blender内部で使用するID [str]
    bl_idname = "object.set_origin_xmin"
    # BlenderのUI上で表示される文字列[str]
    bl_label = "Set objact Origin -X"
    # BlenderのUI上で表示される説明文[str]
    bl_description = "Set origin -X an active object"
    # オペレータの属性[set]
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):
        # 現在のアクティブオブジェクトをactive_objとして保存しておく
        active_obj = context.active_object

        matrix=Matrix()
        me = active_obj.data
        mw = active_obj.matrix_world
        local_verts = [matrix @ Vector(v[:]) for v in active_obj.bound_box]
        o = sum(local_verts, Vector()) / 8
        o.x = min(v.x for v in local_verts)
        o = matrix.inverted() @ o
        me.transform(Matrix.Translation(-o))

        mw.translation = mw @ o

        # オペレータメッセージを出力するメソッド
        # 引数
        #   第1引数: オペレータメッセージの種類 [set]
        #   第2引数: オペレータメッセージ本文 [str]
        self.report({'INFO'},
                    "madoka: Set objact Origin '{}'"
                    .format(active_obj.name))
        # コンソールウィンドウへメッセージを出力
        print("madoka: Operator '{}' is executed".format(self.bl_idname))

        # オペレータが正常終了したことをBlenderに通知
        return {'FINISHED'}


class MadokaSetOriginYmin(bpy.types.Operator):
    #Blender内部で使用するID [str]
    bl_idname = "object.set_origin_ymin"
    # BlenderのUI上で表示される文字列[str]
    bl_label = "Set objact Origin -Y"
    # BlenderのUI上で表示される説明文[str]
    bl_description = "Set origin -Y an active object"
    # オペレータの属性[set]
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):
        # 現在のアクティブオブジェクトをactive_objとして保存しておく
        active_obj = context.active_object

        matrix=Matrix()
        me = active_obj.data
        mw = active_obj.matrix_world
        local_verts = [matrix @ Vector(v[:]) for v in active_obj.bound_box]
        o = sum(local_verts, Vector()) / 8
        o.y = min(v.y for v in local_verts)
        o = matrix.inverted() @ o
        me.transform(Matrix.Translation(-o))

        mw.translation = mw @ o

        # オペレータメッセージを出力するメソッド
        # 引数
        #   第1引数: オペレータメッセージの種類 [set]
        #   第2引数: オペレータメッセージ本文 [str]
        self.report({'INFO'},
                    "madoka: Set objact Origin '{}'"
                    .format(active_obj.name))
        # コンソールウィンドウへメッセージを出力
        print("madoka: Operator '{}' is executed".format(self.bl_idname))

        # オペレータが正常終了したことをBlenderに通知
        return {'FINISHED'}


class MadokaSetOriginZmin(bpy.types.Operator):
    #Blender内部で使用するID [str]
    bl_idname = "object.set_origin_zmin"
    # BlenderのUI上で表示される文字列[str]
    bl_label = "Set objact Origin -Z"
    # BlenderのUI上で表示される説明文[str]
    bl_description = "Set origin -Z an active object"
    # オペレータの属性[set]
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):
        # 現在のアクティブオブジェクトをactive_objとして保存しておく
        active_obj = context.active_object

        matrix=Matrix()
        me = active_obj.data
        mw = active_obj.matrix_world
        local_verts = [matrix @ Vector(v[:]) for v in active_obj.bound_box]
        o = sum(local_verts, Vector()) / 8
        o.z = min(v.z for v in local_verts)
        o = matrix.inverted() @ o
        me.transform(Matrix.Translation(-o))

        mw.translation = mw @ o

        # オペレータメッセージを出力するメソッド
        # 引数
        #   第1引数: オペレータメッセージの種類 [set]
        #   第2引数: オペレータメッセージ本文 [str]
        self.report({'INFO'},
                    "madoka: Set objact Origin '{}'"
                    .format(active_obj.name))
        # コンソールウィンドウへメッセージを出力
        print("madoka: Operator '{}' is executed".format(self.bl_idname))

        # オペレータが正常終了したことをBlenderに通知
        return {'FINISHED'}


# Sidebarのタブ [カスタムタブ] に、パネル [カスタムパネル] を追加
class MadokaCustomPanel(bpy.types.Panel):

    bl_label = "madoka"         # パネルのヘッダに表示される文字列
    bl_space_type = 'VIEW_3D'           # パネルを登録するスペース
    bl_region_type = 'UI'               # パネルを登録するリージョン
    bl_category = "madoka"        # パネルを登録するタブ名
    bl_context = "objectmode"           # パネルを表示するコンテキスト

    # 本クラスの処理が実行可能かを判定する
    @classmethod
    def poll(cls, context):
        # オブジェクトが選択されているときのみメニューを表示させる
        for o in bpy.data.objects:
            if o.select_get():
                return True
        return False

    # ヘッダーのカスタマイズ
    def draw_header(self, context):
        layout = self.layout
        layout.label(text="", icon='PLUGIN')

    # メニューの描画処理
    def draw(self, context):
        layout = self.layout
        scene = context.scene

        # ボタンを追加
        layout.label(text="set origin:")
        layout.operator(MadokaSetOriginC.bl_idname, text="center")

        # 一行配置（アライメントなし）
        row = layout.row(align=True)
        row.operator(MadokaSetOriginXmin.bl_idname, text="Xmin" )
        row.operator(MadokaSetOriginYmin.bl_idname, text="Ymin" )
        row.operator(MadokaSetOriginZmin.bl_idname, text="Zmin" )


# Blenderに登録するクラス
classes = [
    MadokaSetOriginC,
    MadokaSetOriginXmin,
    MadokaSetOriginYmin,
    MadokaSetOriginZmin,
    MadokaCustomPanel,
]


# アドオン有効化時の処理
def register():
    for c in classes:
        bpy.utils.register_class(c)
    print("madoka: Add-on '{}' is enabled".format(bl_info["name"]))


# アドオン無効化時の処理
def unregister():
    for c in classes:
        bpy.utils.unregister_class(c)
    print("madoka: Add-on '{}' is disabled".format(bl_info["name"]))


# メイン処理
if __name__ == "__main__":
    register()
