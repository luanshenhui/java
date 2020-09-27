<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 明細区分一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedLineDiv  リストにて選択すべき明細区分
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditLineDivList(strName, strSelectedLineDiv)

	Dim objCommon		'明細区分情報アクセス用COMオブジェクト

	Dim strLineDiv		'明細区分
	Dim strLineDivName	'明細区分名称

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'明細区分情報の読み込み
	If objCommon.SelectLineDivList(strLineDiv, strLineDivName) > 0 Then

		'ドロップダウンリストの編集
		EditLineDivList = EditDropDownListFromArray(strName, strLineDiv, strLineDivName, strSelectedLineDiv, NON_SELECTED_DEL)

	End If

	Set objCommon = Nothing

End Function
%>
