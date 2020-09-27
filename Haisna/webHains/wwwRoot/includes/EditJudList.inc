<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 判定一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName         		エレメント名
' 　　　　   (In)     strSelectedJudCd		リストにて選択すべき判定コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 判定コード順
'
'-------------------------------------------------------------------------------
Function EditJudList(strName, strSelectedJudCd)

	Dim objJud			'判定情報アクセス用COMオブジェクト

	Dim strJudCd		'判定コード
	Dim strJudSName		'判定略称

	Set objJud = Server.CreateObject("HainsJud.Jud")

	'判定分類情報の読み込み
	If objJud.SelectJudList(strJudCd, strJudSName) > 0 Then

		'ドロップダウンリストの編集
		EditJudList = EditDropDownListFromArray(strName, strJudCd, strJudSName, strSelectedJudCd, NON_SELECTED_ADD)

	End If

	Set objJud = Nothing

End Function
%>
