<% 
'-----------------------------------------------------------------------------
'		共通関数(時間枠一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 時間枠一覧ドロップダウンリストの編集
'
' 引数　　 : (In)	strName					エレメント名
' 　　　　 : (In)	strSelectedTimeFra		リストにて選択すべき時間枠
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 時間枠が１つしかない場合でもドロップダウンリストを編集する
'
'-------------------------------------------------------------------------------
Function EditTimeFraList(strName, strSelectedTimeFra)

	Dim vntTimeFra		'時間枠
	Dim vntTimeFraName	'時間枠名称

	Dim objCommon		'共通関数アクセス用COMオブジェクト

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'時間枠情報の取得
	If objCommon.SelectTimeFraList(vntTimeFra, vntTimeFraName) > 0 Then

		'ドロップダウンリストの編集
		EditTimeFraList = EditDropDownListFromArray(strName, vntTimeFra, vntTimeFraName, strSelectedTimeFra, NON_SELECTED_DEL)

	End If

	Set objCommon = Nothing

End Function
%>
