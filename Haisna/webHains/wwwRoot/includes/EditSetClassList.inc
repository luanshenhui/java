<% 
'-----------------------------------------------------------------------------
'		共通関数(セット分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : takagi.fujitsu.com
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : セット分類ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedSetClassCd  リストにて選択すべきセット分類コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditSetClassList(strName, strSelectedSetClassCd, strNonSelDelFlg)

	Dim objSetClass		'セット分類情報アクセス用

	Dim strSetClassCd	'セット分類コード
	Dim strSetClassName	'セット分類名
	Dim lngCount		'件数

	'オブジェクトのインスタンス作成
	Set objSetClass = Server.CreateObject("HainsSetClass.SetClass")

	'セット分類情報の読み込み
	objSetClass.SelectSetClassList strSetClassCd, strSetClassName
	
	'ドロップダウンリストの編集
	EditSetClassList = EditDropDownListFromArray(strName, strSetClassCd, strSetClassName, strSelectedSetClassCd, strNonSelDelFlg)
	
End Function
%>
