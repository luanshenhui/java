<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 状態一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName               エレメント名
' 　　　　   (In)     strSelectedCondition	リストにて選択すべき状態
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditConditionList(strName, strSelectedCondition)

	Dim objCommon		'状態情報アクセス用COMオブジェクト

	Dim strCondition		'状態
	Dim strConditionName	'状態名称

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'状態情報の読み込み
	If objCommon.SelectConditionList(strCondition, strConditionName) > 0 Then

		'ドロップダウンリストの編集
		EditConditionList = EditDropDownListFromArray(strName, strCondition, strConditionName, strSelectedCondition, NON_SELECTED_ADD)

	End If

	Set objCommon = Nothing

End Function
%>
