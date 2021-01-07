# this addon is .......

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

if "bpy" in locals():
    import imp
    imp.reload(meditOrigins)
    imp.reload(QtWindowEventLoop)
    imp.reload(mdCustompanel)
    #imp.reload(backward_object)
else:
    from . import meditOrigins
    from .core import QtWindowEventLoop
    from . import mdCustompanel
    #from . import backward_object

import bpy

# Sidebarのタブ [カスタムタブ] に、パネル [カスタムパネル] を追加
class MadokaCustomPanel(bpy.types.Panel):

    bl_label = "Madoka"         # パネルのヘッダに表示される文字列
    bl_space_type = 'VIEW_3D'           # パネルを登録するスペース
    bl_region_type = 'UI'               # パネルを登録するリージョン
    bl_category = "Madoka"        # パネルを登録するタブ名
    bl_context = "objectmode"           # パネルを表示するコンテキスト

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
        layout.operator(meditOrigins.MadokaSetOriginC.bl_idname, text="center")

        # 一行配置（アライメントなし）
        row = layout.row(align=True)
        row.operator(meditOrigins.MadokaSetOriginXmin.bl_idname, text="Xmin" )
        row.operator(meditOrigins.MadokaSetOriginYmin.bl_idname, text="Ymin" )
        row.operator(meditOrigins.MadokaSetOriginZmin.bl_idname, text="Zmin" )

        # camcontrolloer test
        layout.separator()
        layout.label(text="PySide test")
        layout.operator(mdCustompanel.CustomWindowOperator.bl_idname, text="Image Viewer")


# Blenderに登録するクラス
classes = [
    QtWindowEventLoop,
    mdCustompanel.CustomWindowOperator,
    meditOrigins.MadokaSetOriginC,
    meditOrigins.MadokaSetOriginXmin,
    meditOrigins.MadokaSetOriginYmin,
    meditOrigins.MadokaSetOriginZmin,
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
    bpy.ops.screen.custom_window() # load the tool upon initializing the addon?
