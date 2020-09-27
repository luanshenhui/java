<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 入金種別一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　   (In)     strSelectedPaymentDiv   リストにて選択すべき入金種別
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditPaymentDivList(strName, strSelectedPaymentDiv)

	Dim objCommon			'入金種別情報アクセス用COMオブジェクト

	Dim strPaymentDiv		'入金種別
	Dim strPaymentDivName	'入金種別名称

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'入金種別情報の読み込み
	If objCommon.SelectPaymentDivList(strPaymentDiv, strPaymentDivName) > 0 Then

		'ドロップダウンリストの編集
		EditPaymentDivList = EditDropDownListFromArray(strName, strPaymentDiv, strPaymentDivName, strSelectedPaymentDiv, NON_SELECTED_DEL)

	End If

	Set objCommon = Nothing

End Function
%>
