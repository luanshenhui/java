<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 保険区分一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedIsrDiv   リストにて選択すべき保険区分
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditIsrDivList(strName, strSelectedIsrDiv)

	Dim objCommon		'保険区分情報アクセス用COMオブジェクト

	Dim strIsrDiv		'保険区分
	Dim strIsrDivName	'保険区分名称

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'保険区分情報の読み込み
	If objCommon.SelectIsrDivList(strIsrDiv, strIsrDivName) > 0 Then

		'ドロップダウンリストの編集
		EditIsrDivList = EditDropDownListFromArray(strName, strIsrDiv, strIsrDivName, strSelectedIsrDiv, NON_SELECTED_ADD)

	End If

	Set objCommon = Nothing

End Function
%>
