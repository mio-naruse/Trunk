struct ghost (
	btxt,
	scripttxt,
	fn setnomaltxt = (
		btxt = #()
		append btxt "そのモデル、愛着持って作ってます？先輩。"
		append btxt "先輩？\n何でもかんでもアンビエントオクルージョン\n焼けばいいってものでもないですよ？"
		append btxt "先輩…？\nメッシュの乱れは心の乱れだって誰かが言ってましたよね？\n落ちついて・・・はい！リテイク！"
		append btxt "理解・分解・再構築！！"
		append btxt "せんぱい、おきてください♪\n…なんてやるわけ無いじゃないですか\n居眠りしてないでさっさと起きてください。"
		return btxt
	),

	fn setSPtxt = (
		scripttxt = #()
		append scripttxt "起動しまーす！"
		return scripttxt
	)
)