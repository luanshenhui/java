<%
'-------------------------------------------------------------------------------
' web予約オプションコード変換ライブラリ
'-------------------------------------------------------------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Const FREECLASSCD_WEBOPTION     = "WOP"		'汎用分類コード(web予約オプション)

Const WEBOPTCD_MAMMO            = "P06"		'web予約オプションコード(乳房X線)
Const WEBOPTCD_BREASTECHO       = "P07"		'web予約オプションコード(乳房超音波)
Const WEBOPTCD_MAMMO_BREASTECHO = "P-XandE"	'web予約オプションコード(乳房X線、乳房超音波同時受診)

'-------------------------------------------------------------------------------
'
' 機能　　 : カンマ区切りで編集されているweb予約オプションコードを配列に変換
'
' 引数　　 : (In)     strWebOptCd  web予約オプションコード
'
' 戻り値　 : 変換後の配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function ToArrayWebOptCd(strWebOptCd)

	Dim vntArrWebOptCd		'web予約オプションコードの配列
	Dim strArrWebOptCd()	'web予約オプションコードの配列
	Dim lngCount			'配列の要素数
	Dim blnMammoEcho		'乳房X線、乳房超音波同時受診であるか
	Dim i					'インデックス

	'配列に変換
	vntArrWebOptCd = Split(strWebOptCd, ",")

	'全要素のトリミング、かつ乳房X線、乳房超音波同時受診であるかを判定
	For i = 0 To UBound(vntArrWebOptCd)
		vntArrWebOptCd(i) = Trim(vntArrWebOptCd(i))
		If vntArrWebOptCd(i) = WEBOPTCD_MAMMO_BREASTECHO Then
			blnMammoEcho = True
		End If
	Next

	'空要素の除去、及び乳房X線、乳房超音波同時受診時の特殊処理
	For i = 0 To UBound(vntArrWebOptCd)

		Do

			'空要素であればスキップ
			If vntArrWebOptCd(i) = "" Then
				Exit Do
			End If

			'乳房X線、乳房超音波同時受診時は、乳房X線及び乳房超音波単独のオプションコードをスキップ
			If blnMammoEcho And (vntArrWebOptCd(i) = WEBOPTCD_MAMMO Or vntArrWebOptCd(i) = WEBOPTCD_BREASTECHO) Then
				Exit Do
			End If

			'上記除外条件を満たさない場合は要素を追加
			ReDim Preserve strArrWebOptCd(lngCount)
			strArrWebOptCd(lngCount) = vntArrWebOptCd(i)
			lngCount = lngCount + 1

			Exit Do
		Loop

	Next

	'要素が存在する場合は戻り値を設定
	If lngCount > 0 Then
		ToArrayWebOptCd = strArrWebOptCd
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : web予約オプションコード変換情報の取得
'
' 引数　　 : (Out)    vntWebOptCd    web予約オプションコード
' 　　　　   (Out)    vntWebOptName  オプション名
' 　　　　   (Out)    vntSetClassCd     セット分類コード
'
' 戻り値　 : 配列の要素数
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetWebOptConverterArray(vntWebOptCd, vntWebOptName, vntSetClassCd)

	Dim objFree		'汎用情報アクセス用
	Dim lngCount	'配列の要素数

	Set objFree = Server.CreateObject("HainsFree.Free")

	'汎用情報の読み込み
	lngCount = objFree.SelectFreeByClassCd(0, FREECLASSCD_WEBOPTION, , , , vntWebOptCd, vntWebOptName, vntSetClassCd)

	GetWebOptConverterArray = lngCount

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : カンマ区切りで編集されているweb予約オプションコードからオプション名称の配列へのマップ処理
'
' 引数　　 : (In)     strWebOptCd  web予約オプションコード
'
' 戻り値　 : 変換後の配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function ToMapWebOptName(strWebOptCd)

	Dim vntArrWkWebOptCd	'web予約オプションコードの配列

	Dim vntWebOptCd			'web予約オプションコードの配列
	Dim vntWebOptName		'web予約オプション名の配列
	Dim vntSetClassCd		'セット分類コードの配列
	Dim lngCount			'配列の要素数

	Dim strWebOptName()		'web予約オプション名の配列

	Dim lngIndex			'検索インデックス
	Dim i					'インデックス
	Dim j					'インデックス

	'配列に変換
	vntArrWkWebOptCd = ToArrayWebOptCd(strWebOptCd)
	If IsEmpty(vntArrWkWebOptCd) Then
		Exit Function
	End If

	'web予約オプションコード変換情報の取得
	lngCount = GetWebOptConverterArray(vntWebOptCd, vntWebOptName, vntSetClassCd)

	'配列の再定義
	ReDim Preserve strWebOptName(UBound(vntArrWkWebOptCd))

	'配列の各要素ごとの処理
	For i = 0 To UBound(vntArrWkWebOptCd)

		lngIndex = -1

		'変換情報を検索し、オプションコードが一致する変換情報のインデックスを求める
		For j = 0 To lngCount - 1
			If Trim(vntWebOptCd(j)) = vntArrWkWebOptCd(i) Then
				lngIndex = j
				Exit For
			End If
		Next

		'検索成功時はオプション名とオプションコードの組となる文字列を、さもなくばオプションコードのみを編集
		If lngIndex >= 0 Then
			strWebOptName(i) = vntWebOptName(lngIndex) & "(" & vntArrWkWebOptCd(i) & ")"
		Else
			strWebOptName(i) = vntArrWkWebOptCd(i)
		End If

	Next

	ToMapWebOptName = strWebOptName

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : カンマ区切りで編集されているweb予約オプションコードから対応するセット分類を取得
'
' 引数　　 : (In)     strWebOptCd  web予約オプションコード
'
' 戻り値　 : セット分類コードの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function ConvertToSetClass(strWebOptCd)

	Dim vntArrWkWebOptCd	'web予約オプションコードの配列

	Dim vntWebOptCd			'web予約オプションコードの配列
	Dim vntWebOptName		'web予約オプション名の配列
	Dim vntSetClassCd		'セット分類コードの配列
	Dim lngCount			'配列の要素数

	Dim strSetClassCd()		'セット分類コードの配列
	Dim lngSetClassCount	'セット分類コードの配列要素数

	Dim strWkSetClassCd		'セット分類コード
	Dim blnDuplicated		'重複存在か
	Dim i					'インデックス
	Dim j					'インデックス

	'配列に変換
	vntArrWkWebOptCd = ToArrayWebOptCd(strWebOptCd)
	If IsEmpty(vntArrWkWebOptCd) Then
		Exit Function
	End If

	'web予約オプションコード変換情報の取得
	lngCount = GetWebOptConverterArray(vntWebOptCd, vntWebOptName, vntSetClassCd)

	'配列の各要素ごとの処理
	For i = 0 To UBound(vntArrWkWebOptCd)

		Do

			strWkSetClassCd = ""

			'変換情報を検索し、オプションコードが一致する変換情報のインデックスを求める
			For j = 0 To lngCount - 1
				If Trim(vntWebOptCd(j)) = vntArrWkWebOptCd(i) Then
					strWkSetClassCd = Trim(vntSetClassCd(j))
					Exit For
				End If
			Next

			'検索不能時、またはセット分類未定義時はスキップ
			If strWkSetClassCd = "" Then
				Exit Do
			End If

			'すでに取得済みのセット分類であるかを判定
			blnDuplicated = False
			For j = 0 To lngSetClassCount - 1
				If strSetClassCd(j) = strWkSetClassCd Then
					blnDuplicated = True
					Exit For
				End If
			Next

			'取得済みでなければ追加
			If Not blnDuplicated Then
				ReDim Preserve strSetClassCd(lngSetClassCount)
				strSetClassCd(lngSetClassCount) = strWkSetClassCd
				lngSetClassCount = lngSetClassCount + 1
			End If

			Exit Do
		Loop

	Next

	'要素が存在する場合は戻り値を設定
	If lngSetClassCount > 0 Then
		ConvertToSetClass = strSetClassCd
	End If

End Function
%>
