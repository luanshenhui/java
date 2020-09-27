<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 判定分類一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             		エレメント名
' 　　　　   (In)     strSelectedJudClassCd		リストにて選択すべき判定分類コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 依頼項目判定グループに存在する判定分類コードのみ、判定分類コード順
'
'-------------------------------------------------------------------------------
Function EditJudClassList(strName, strSelectedJudClassCd, strNonSelDelFlg)

	Dim objJudClass		'依頼項目判定分類情報アクセス用COMオブジェクト

	Dim strJudClassCd	'判定分類コード
	Dim strJudClassName	'判定分類名称
	Dim lngCount		'件数
	Dim i				'インデックス

	Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR ( strNonSelDelFlg = NON_SELECTED_DEL ) OR ( strNonSelDelFlg = SELECTED_ALL ) Then
		'判定分類情報の読み込み
		If objJudClass.SelectJudClassList(strJudClassCd, strJudClassName) > 0 Then

			'ドロップダウンリストの編集
			EditJudClassList = EditDropDownListFromArray(strName, strJudClassCd, strJudClassName, strSelectedJudClassCd, strNonSelDelFlg)

		End If
	Else
		'コース情報の読み込み
		lngCount = objJudClass.SelectJudClassList(strJudClassCd, strJudClassName)

		Redim Preserve strJudClassCd(lngCount)
		Redim Preserve strJudClassName(lngCount)

		For i = lngCount To 1 Step -1
			strJudClassCd(i)   = strJudClassCd(i - 1)
			strJudClassName(i) = strJudClassName(i - 1)
			strJudClassCd(i - 1)   = ""
			strJudClassName(i - 1) = ""
		Next

		strJudClassCd(0)   = ""
		strJudClassName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditJudClassList = EditDropDownListFromArray(strName, strJudClassCd, strJudClassName, strSelectedJudClassCd, NON_SELECTED_DEL)
	
	End If

	Set objJudClass = Nothing

End Function
%>
