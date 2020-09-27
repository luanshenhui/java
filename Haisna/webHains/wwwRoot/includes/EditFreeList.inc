<% 
'-----------------------------------------------------------------------------
'		汎用テーブル Include File (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診者一覧表示制御項目ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　   (In)     strSelectedCd           リストにて選択すべき表示制御項目
' 　　　　   (In)     strNonSelDelFlg         未選択用空リスト削除フラグ
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRsvListList(strName, strSelectedCd, strNonSelDelFlg)

	Dim objFree			'汎用クラス

	Dim strFreeCd		'汎用コード
	Dim strFreeName		'汎用名
	Dim lngCount		'レコード数
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objFree = Server.CreateObject("HainsFree.Free")

	'汎用情報の読み込み
	lngCount = objFree.SelectFree(1, "RSVLIST", strFreeCd, strFreeName)
	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR _
	   ( strNonSelDelFlg = NON_SELECTED_DEL ) OR _
	   ( strNonSelDelFlg = SELECTED_ALL )     Then
		'汎用情報リストが存在するとき
		If lngCount > 0 Then

			'ドロップダウンリストの編集
			EditRsvListList = EditDropDownListFromArray(strName, strFreeCd, strFreeName, strSelectedCd, strNonSelDelFlg)

		End If
	Else
		'配列情報に格納
		Redim Preserve strFreeCd(lngCount)
		Redim Preserve strFreeName(lngCount)

		For i = lngCount To 1 Step -1
			strFreeCd(i)   = strFreeCd(i - 1)
			strFreeName(i) = strFreeName(i -1)
			strFreeCd(i - 1)   = ""
			strFreeName(i - 1) = ""
		Next

		strFreeCd(0)   = ""
		strFreeName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditRsvListList = EditDropDownListFromArray(strName, strFreeCd, strFreeName, strSelectedCd, strNonSelDelFlg)

	End If

	Set objFree = Nothing

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診者一覧表示制御項目の格納
'
' 引数　　 : (In)     strFreeCd               表示制御項目コード
' 　　　　 : (Out)    strPrtFieldName         表示制御項目名
' 　　　　 : (Out)    lngArrPrtField          表示制御項目の配列
'
' 戻り値　 : 表示制御項目の個数
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditPrtFieldArray(strFreeCd, strPrtFieldName, lngArrPrtField)

	Dim objFree			'汎用クラス

	Dim vntFreeName		'汎用名(表示項目制御名)
	Dim vntFreeField1	'汎用フィールド1(表示項目制御フラグ)
	Dim vntFreeField2	'汎用フィールド2(表示項目制御フラグ)

	Dim strPrtField		'表示項目制御フラグ
	Dim strArrPrtField	'表示項目の配列
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objFree = Server.CreateObject("HainsFree.Free")
		
	'汎用情報の読み込み
	If objFree.SelectFree(0, strFreeCd, , vntFreeName, , vntFreeField1, vntFreeField2) > 0 Then
		strPrtFieldName = vntFreeName		'汎用名セット
		strPrtField = vntFreeField1			'汎用フィールド1セット
		If vntFreeField2 <> "" Then			'汎用フィールド2にデータが存在すれば結合する
			strPrtField = strPrtField & IIf(strPrtField <> "", ",", "") & vntFreeField2
		End If
	Else
		strPrtFieldName = ""
		strPrtField = ""
	End If

	'配列に格納
	If strPrtField <> "" Then
		strArrPrtField = Split(strPrtField,",")
		If IsArray(strArrPrtField) Then
			Redim lngArrPrtField(UBound(strArrPrtField))
			For i = 0 To UBound(strArrPrtField)
				lngArrPrtField(i) = CLng(strArrPrtField(i))
			Next
		End If
	End If

	Set objFree = Nothing

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診票印刷パターンドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　   (In)     strSelectedCd           リストにて選択すべき表示制御項目
' 　　　　   (In)     strNonSelDelFlg         未選択用空リスト削除フラグ
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditJushinhyoPtnList(strName, strSelectedCd, strNonSelDelFlg)

	Dim objFree			'汎用クラス

	Dim strFreeCd		'汎用コード
	Dim strFreeName		'汎用名
	Dim lngCount		'レコード数
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objFree = Server.CreateObject("HainsFree.Free")

	'汎用情報の読み込み
	lngCount = objFree.SelectJushinhyoPtnList(strFreeCd, strFreeName)

	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR _
	   ( strNonSelDelFlg = NON_SELECTED_DEL ) OR _
	   ( strNonSelDelFlg = SELECTED_ALL )     Then
		'汎用情報リストが存在するとき
		If lngCount > 0 Then

			'ドロップダウンリストの編集
			EditJushinhyoPtnList = EditDropDownListFromArray(strName, strFreeCd, strFreeName, strSelectedCd, strNonSelDelFlg)

		End If
	Else
		'配列情報に格納
		Redim Preserve strFreeCd(lngCount)
		Redim Preserve strFreeName(lngCount)

		For i = lngCount To 1 Step -1
			strFreeCd(i)   = strFreeCd(i - 1)
			strFreeName(i) = strFreeName(i -1)
			strFreeCd(i - 1)   = ""
			strFreeName(i - 1) = ""
		Next

		strFreeCd(0)   = ""
		strFreeName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditJushinhyoPtnList = EditDropDownListFromArray(strName, strFreeCd, strFreeName, strSelectedCd, strNonSelDelFlg)

	End If

	Set objFree = Nothing

End Function

%>
