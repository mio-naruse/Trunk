# bpyインポート
import bpy
from mathutils import Matrix, Vector
import numpy as np

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

        active_obj = context.active_object
        matrix=Matrix()
        use_verts=False

        me = active_obj.data
        mw = active_obj.matrix_world

        if use_verts:
            data = (v.co for v in me.vertices)
        else:
            data = (Vector(v) for v in active_obj.bound_box)

        coords = np.array([matrix @ v for v in data])

        x = coords.T[0]
        # y = coords.T[1]
        # z = coords.T[2]
        mins = np.take(coords, np.where(x == x.min())[0], axis=0)

        o = Vector(np.mean(mins, axis=0))
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

        active_obj = context.active_object
        matrix=Matrix()
        use_verts=False

        me = active_obj.data
        mw = active_obj.matrix_world

        if use_verts:
            data = (v.co for v in me.vertices)
        else:
            data = (Vector(v) for v in active_obj.bound_box)

        coords = np.array([matrix @ v for v in data])

        #x = coords.T[0]
        y = coords.T[1]
        #z = coords.T[2]
        mins = np.take(coords, np.where(y == y.min())[0], axis=0)

        o = Vector(np.mean(mins, axis=0))
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

        active_obj = context.active_object
        matrix=Matrix()
        use_verts=False

        me = active_obj.data
        mw = active_obj.matrix_world

        if use_verts:
            data = (v.co for v in me.vertices)
        else:
            data = (Vector(v) for v in active_obj.bound_box)

        coords = np.array([matrix @ v for v in data])

        # x = coords.T[0]
        # y = coords.T[1]
        z = coords.T[2]
        mins = np.take(coords, np.where(z == z.min())[0], axis=0)

        o = Vector(np.mean(mins, axis=0))
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