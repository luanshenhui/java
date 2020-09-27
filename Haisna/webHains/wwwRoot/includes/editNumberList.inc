<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 数値のSELECTタグ生成
'
' 引数　　 : (In)     strName           エレメント
' 　　　　   (In)     lngStartValue     開始値
' 　　　　   (In)     lngEndValue       終了値
' 　　　　   (In)     vntSelectedValue  デフォルトの選択値
' 　　　　   (In)     blnNeedsEmptyRow  空白行の必要性
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditNumberList(strElementName, vntStartValue, vntEndValue, vntSelectedValue, blnNeedsEmptyRow)

	Dim objCommon			'共通クラス

	Dim lngSelectedValue	'デフォルト選択年

	Dim strSelected			'SELECTED属性
	Dim strHtml				'HTML文字列
	Dim i					'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = CreateObject("HainsCommon.Common")

	'デフォルト選択年の編集
	If Not IsEmpty(vntSelectedValue) Then
		lngSelectedValue = CLng("0" & vntSelectedValue)
	End If

	'SELECTタグ編集開始
	strHtml = "<SELECT NAME=""" & strElementName & """>"

	'空白行の編集が必要な場合
	If blnNeedsEmptyRow Then

		'空白行を作成する
		strHtml = strHtml & vbLf & "<OPTION VALUE="""">"

	End If

	'各年のOPTIONタグを編集
	For i = CLng(vntStartValue) To CLng(vntEndValue)

		'年が一致するかを判定
		strSelected = IIf(lngSelectedValue = i, " SELECTED", "")

		'タグを追加する
'		strHtml = strHtml & vbLf & "<OPTION VALUE=""" & i & """" & strSelected & ">" & i
		strHtml = strHtml & "<OPTION VALUE=""" & i & """" & strSelected & ">" & i

	Next

	'SELECTタグ編集終了
	strHtml = strHtml & vbLf & "</SELECT>"

	EditNumberList = strHtml

End Function
%>
