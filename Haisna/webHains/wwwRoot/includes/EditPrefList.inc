<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 都道府県一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedPrefCd   リストにて選択すべき都道府県コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditPrefList(strName, strSelectedPrefCd)

	Dim objPref		'都道府県情報アクセス用COMオブジェクト

	Dim strPrefCd	'都道府県コード
	Dim strPrefName	'都道府県名

	Set objPref = Server.CreateObject("HainsPref.Pref")

	'都道府県情報の読み込み
	If objPref.SelectPrefList(strPrefCd, strPrefName) > 0 Then

		'ドロップダウンリストの編集
		EditPrefList = EditDropDownListFromArray(strName, strPrefCd, strPrefName, strSelectedPrefCd, NON_SELECTED_ADD)

	End If

	Set objPref = Nothing

End Function
%>
