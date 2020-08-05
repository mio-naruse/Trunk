o=$selection as array --選択オブジェクトを配列oに代入--

unregisterRedrawViewsCallback GW_displayVertexNumber --コールバック関数を解除--
fn GW_displayVertexNumber =
(
    for i = 1 to o.count do --選択オブジェクトの数だけ繰り返し
    (
        theMesh = snapshotAsMesh o[i]  --配列oのi番目にあるデータをメッシュに変換して「theMesh」としてメモリに乗せる--
        theVertCount = theMesh.numverts  --「theMesh」の頂点数をカウント--

        for v = 1 to theVertCount do  --「v」の1番目から、カウントした頂点数分繰り返し--
        (
            gw.setTransform (matrix3 1)  --3次元空間を2次元空間に変換--
            thePos = (getVert theMesh v)  --v番目の頂点の座標を「thePos」に代入--
            gw.text thePos (v as string) color:yellow  --V番目の頂点の位置に、頂点番号を黄色で表示--
        )
    )
    gw.enlargeUpdateRect #whole  --描画領域の拡張--
)
registerRedrawViewsCallback GW_displayVertexNumber --コールバック関数を登録--
