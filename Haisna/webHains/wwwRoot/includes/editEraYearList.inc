<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 和暦のSELECTタグ生成
'
' 引数　　 : (In)     strElementName    エレメント名
' 　　　　   (In)     vntSelectedDate   選択日付
' 　　　　   (In)     blnNeedsEmptyRow  空白行の必要性
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditEraYearList(strElementName, vntSelectedDate, blnNeedsEmptyRow)

	Dim objCommon		'共通クラス

	Dim strBirthStart	'生年月日（年）開始
	Dim strBirthDefault	'生年月日（年）初期値

	Dim lngStartValue	'開始年
	Dim lngEndValue		'終了年

	Dim strEraCode		'デフォルト選択日付の元号(コード表記)

	Dim strArrYear		'西暦年の配列
	Dim strArrEraCode	'元号(コード表記)の配列
	Dim strArrEraName	'元号(日本語表記)の配列

	Dim strSelected		'SELECTED属性
	Dim strHtml			'HTML文字列

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = CreateObject("HainsCommon.Common")

	'和暦タグ作成のための初期値を取得
	objCommon.SelectYearsRangeBirth strBirthStart, strBirthDefault

	'開始年は初期値を使用する
	lngStartValue = Clng("0" & strBirthStart)

	'終了年は現在年を使用する
	lngEndValue = Year(Now)

	'デフォルト選択日付の元号を取得(日付認識不能時は引数値をそのまま使用)
	If IsDate(vntSelectedDate) Then
		strEraCode = objCommon.FormatString(CDate(vntSelectedDate), "ge")
	Else
		strEraCode = vntSelectedDate
	End If

	'西暦、和暦年の情報を取得
	objCommon.GetEraYearArray lngStartValue, lngEndValue, strArrYear, strArrEraCode, strArrEraName

	'SELECTタグ編集開始
	strHtml = "<SELECT NAME=""" & strElementName & """>"

	'OPTIONタグの編集
	For i = 0 To UBound(strArrYear)

		'元号が一致するかを判定
		strSelected = IIf(strEraCode = strArrEraCode(i), " SELECTED", "")

		'タグを追加
		strHtml = strHtml & "<OPTION VALUE=""" & strArrEraCode(i) & """" & strSelected & ">" & strArrEraName(i) & "年（" & strArrYear(i) & "）"

		'空行を必要とし、かつ現編集年が生年月日の初期値と等しい場合
		If blnNeedsEmptyRow And (strArrYear(i) = Clng(strBirthDefault)) Then

			'デフォルト選択日付の元号が存在しなければ選択状態とする
			strSelected = IIf(strEraCode = "", " SELECTED", "")

			'空白行を作成する
			strHtml = strHtml & "<OPTION VALUE=""""" & strSelected & ">"

		End If

	Next

	'SELECTタグ編集終了
	strHtml = strHtml & "</SELECT>"

	EditEraYearList = strHtml

End Function
%>
