<!-- #include virtual = "/webHains/includes/common.inc" -->
<% 
'-----------------------------------------------------------------------------
'	   受診者一覧関数 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診者一覧表示行数の読み込み
'
' 引数　　 : (In)	strName				エレメント名
' 　　　　   (In)	strSelectedCsCd		リストにて選択すべきコースコード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRslPageMaxLine()

	Dim objCommon   '共通関数アクセス用COMオブジェクト

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'受診者一覧表示行数の読み込み
	EditRslPageMaxLine = objCommon.SelectRslPageMaxLine

	Set objCommon = Nothing

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 表示順一覧ドロップダウンリストの編集
'
' 引数　　 : (In)	 strName             エレメント名
' 　　　　   (In)	 strSelectedSortKey  リストにて選択すべき表示順
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditSortKeyList(strName, strSelectedSortKey)

	Dim objCommon		'共通クラス
	Dim objFree			'汎用情報アクセス用

	Dim strSortKey		'表示順
	Dim strSortKeyName	'表示順名称
	Dim lngCount		'表示順の数

	Dim strFreeCd		'汎用コード
	Dim strFreeName		'汎用名
	Dim lngFreeCount	'汎用情報の数

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")
	Set objFree   = Server.CreateObject("HainsFree.Free")

	'表示順情報の読み込み
	lngCount = objCommon.SelectRslSortKeyList(strSortKey, strSortKeyName)

	'汎用テーブルからフィルム番号情報を読み込む
	lngFreeCount = objFree.SelectFree(1, "FILM", strFreeCd, strFreeName)

	'フィルム番号情報が存在する場合
	If lngFreeCount > 0 Then

		'表示順情報が存在しない場合は新しい配列を作成
		If lngCount = 0 Then
			strSortKey     = Array()
			strSortKeyName = Array()
		End If

		'表示順情報に追加
		For i = 0 To lngFreeCount - 1
			Redim Preserve strSortKey(lngCount)
			Redim Preserve strSortKeyName(lngCount)
			strSortKey(lngCount)     = strFreeCd(i)
			strSortKeyName(lngCount) = "フィルム番号（" & strFreeName(i) & "）"
			lngCount = lngCount + 1
		Next

	End If

	'ドロップダウンリストの編集
	EditSortKeyList = EditDropDownListFromArray(strName, strSortKey, strSortKeyName, strSelectedSortKey, NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 表示行数一覧ドロップダウンリストの編集
'
' 引数　　 : (In)	 strName				エレメント名
' 　　　　   (In)	 strSelectedPageMaxLine	リストにて選択すべき表示行数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRslPageMaxLineList(strName, strSelectedPageMaxLine)

	Dim strPageMaxLine  '表示行数
	Dim strPageMaxName  '表示行数名称

	Dim objCommon   '共通関数アクセス用COMオブジェクト

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'表示順情報の読み込み
	If objCommon.SelectRslPageMaxLineList(strPageMaxLine, strPageMaxName) > 0 Then

		'ドロップダウンリストの編集
		EditRslPageMaxLineList = EditDropDownListFromArray(strName, strPageMaxLine, strPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

	End If

	Set objCommon = Nothing

End Function

%>
