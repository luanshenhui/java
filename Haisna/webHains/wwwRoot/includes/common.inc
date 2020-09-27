<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 情報漏えい対策ログ出力
'
' 引数　　 : (In)    functionCode   機能コード
' 　　　　   (In)    logMessage     ログ出力用メッセージ
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function putPrivacyInfoLog(functionCode, logMessage)

	putPrivacyInfoLog = putPrivacyInfoLogWithUserID(functionCode, logMessage, Session("USERID"))

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 情報漏えい対策ログ出力
'
' 引数　　 : (In)    functionCode   機能コード
' 　　　　   (In)    logMessage     ログ出力用メッセージ
' 　　　　   (In)    paramUserID    ユーザID
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function putPrivacyInfoLogWithUserID(functionCode, logMessage, paramUserID)

	Dim privacyRet
	Dim objPrivacyInfo
	Set objPrivacyInfo = Server.CreateObject("HainsPrivacyInfo.PrivacyInfo")

	'IDとリクエストオブジェクトを渡してログを書く
	privacyRet = objPrivacyInfo.putPrivacyInfoLog(paramUserID, functionCode, logMessage, Request)
	If privacyRet < 1 Then
		Err.Raise 1000, ,"情報漏えい対策ログ書き込み処理に失敗しました。WWWサーバのイベントログを参照してください。"
		putPrivacyInfoLogWithUserID = False
		Exit Function
	End If

	putPrivacyInfoLogWithUserID = True

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 式の評価結果によって、2つの引数のうち1つを返す
'
' 引数　　 : (In)     blnExpr       評価対象の式
' 　　　　   (Out)    vntTruePart   blnExprが真の場合に返す値または式
' 　　　　   (Out)    vntFalsePart  blnExprが偽の場合に返す値または式
'
' 戻り値　 : vntTruePartあるいはvntFalsePartの値
'
' 備考　　 : VBのIIf関数と機能的に同一
'
'-------------------------------------------------------------------------------
Function IIf(blnExpr, vntTruePart, vntFalsePart)

    If blnExpr Then
        IIf = vntTruePart
    Else
        IIf = vntFalsePart
    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 連続した数値用(年・月・日など)のSELECTタグ生成
'
' 引数　　 : (In)     strName           エレメント名
' 　　　　   (In)     lngStartValue     開始値
' 　　　　   (In)     lngEndValue       終了値
' 　　　　   (In)     lngSelectedValue  デフォルトの選択値
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditSelectNumberList(strName, lngStartValue, lngEndValue, lngSelectedValue)

    Dim strHtml 'HTML文字列
    Dim i       'インデックス

    strHtml = "<SELECT NAME=""" & strName & """>"
    strHtml = strHtml & vbLf & "<OPTION VALUE="""">"

    For i = lngStartValue To lngEndValue
'        strHtml = strHtml & vbLf & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
        strHtml = strHtml & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
    Next
    strHtml = strHtml & vbLf & "</SELECT>"

    EditSelectNumberList = strHtml

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 年のSELECTタグ生成
'
' 引数　　 : (In)     strMode           処理モード
' 　　　　   (In)     strName           エレメント
' 　　　　   (In)     lngSelectedValue  デフォルトの選択値
'
' 戻り値　 : SELECTタグ
'
' 備考　　 : 生年月日、システム管理日付により年の範囲を計算し、SELECTタグを作成
'
'-------------------------------------------------------------------------------
Function EditSelectYearList(strMode, strName, lngSelectedValue)

    Dim objCommon       'アクセス用COMオブジェクト
    Dim strBirthStart   '生年月日（年）開始
    Dim strBirthDefault '生年月日（年）初期値
    Dim lngStartValue   '開始年
    Dim lngEndValue     '終了年
    Dim strHtml         'HTML文字列
    Dim i               'インデックス

    Set objCommon = CreateObject("HainsCommon.Common")

    Select Case strMode
        '生年月日
        Case YEARS_BIRTH
            Call objCommon.SelectYearsRangeBirth(strBirthStart, strBirthDefault)
            lngStartValue = Clng("0" & strBirthStart)
            lngEndValue   = Year(Now)
        'システム管理日付
        Case YEARS_SYSTEM
            Call objCommon.SelectYearsRangeSystem(lngStartValue, lngEndValue)
        Case Else
            Exit Function
    End Select

    'デフォルト年が設定されていて、かつ、デフォルト選択値が設定されていない場合
'    If (Not IsNumeric(lngSelectedValue) Or lngSelectedValue = 0) And IsNumeric(strBirthDefault) Then
'        lngSelectedValue = CLng(strBirthDefault)
'    End If

    strHtml = "<SELECT NAME=""" & strName & """>"
'    strHtml = strHtml & vbLf & "<OPTION VALUE="""">"
    If strMode = YEARS_SYSTEM Then
        If (Not IsNumeric(lngSelectedValue)) Or lngSelectedValue = 0 Then
            strHtml = strHtml & vbLf & "<OPTION VALUE="""" SELECTED>"
        Else
            strHtml = strHtml & vbLf & "<OPTION VALUE="""">"
        End If
    End If

    For i = lngStartValue To lngEndValue
'        strHtml = strHtml & vbLf & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
        If strMode = YEARS_BIRTH Then
            strHtml = strHtml & vbLf & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
            If i = Clng(strBirthDefault) Then
                If (Not IsNumeric(lngSelectedValue)) Or lngSelectedValue = 0 Then
                    strHtml = strHtml & vbLf & "<OPTION VALUE="""" SELECTED>"
                Else
                    strHtml = strHtml & vbLf & "<OPTION VALUE="""">"
                End If
            End If
        Else
            strHtml = strHtml & vbLf & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
        End If
    Next
    strHtml = strHtml & vbLf & "</SELECT>"

    EditSelectYearList = strHtml

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : コード・名称配列からのSELECTタグ生成
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strArrCode          コードの配列
' 　　　　   (In)     strArrName          名称の配列
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelDelFlg     未選択用空リスト削除フラグ(1:削除)
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDropDownListFromArray(strName, strArrCode, strArrName, strSelectedCode, strNonSelDelFlg)

    Dim strHTML 	'HTML文字列
    Dim i       	'インデックス
	Dim objCommon	'

	Set objCommon = CreateObject("HainsCommon.Common")

    'SELECTタグの開始
    strHTML = "<SELECT NAME=""" & strName & """>"

    '未選択用の空リストを作成
    If strNonSelDelFlg = NON_SELECTED_ADD Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">&nbsp;"
    End If

    '「すべて」選択用のリストを作成
    If strNonSelDelFlg = SELECTED_ALL Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">すべて"
    End If

    '配列添字数分のリストを追加
	If Not IsEmpty(strArrCode) Then
		For i = 0 To UBound(strArrCode)
			strHTML = strHTML & "<OPTION VALUE=""" & strArrCode(i) & """" & IIf(CStr(strArrCode(i)) = CStr(strSelectedCode), " SELECTED", "") & ">" & strArrName(i)
		Next
	End If

    strHTML = strHTML & vbLf & "</SELECT>"

    EditDropDownListFromArray = strHTML

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : コード・名称配列からのINPUT(Radio)タグ生成
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strArrCode          コードの配列
' 　　　　   (In)     strArrName          名称の配列
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelDelFlg     未選択用空リスト削除フラグ(1:削除)
'
' 戻り値　 : INPUT(Radio)タグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRadioFromArray(strName, strArrCode, strArrName, strSelectedCode, strNonSelDelFlg)

    Dim strHTML     'HTML文字列
    Dim i           'インデックス
    Dim objCommon   '

    Set objCommon = CreateObject("HainsCommon.Common")

    If strNonSelDelFlg = NON_SELECTED_ADD Then
    '未選択用の空ラジオボタンを作成
        '配列添字数分のリストを追加
        If Not IsEmpty(strArrCode) Then
            For i = 0 To UBound(strArrCode)
                'strHTML = strHTML & "<INPUT TYPE=""radio"" NAME=""" & strName & """ VALUE=""" & strArrCode(i) & """"  & ">" & strArrName(i) & "&nbsp;&nbsp;<br>"
                strHTML = strHTML & "<INPUT TYPE=""radio"" NAME=""" & strName & """ VALUE=""" & strArrCode(i) & """" & IIf(UBound(strArrCode) = 0, " CHECKED", "") & ">" & strArrName(i) & "&nbsp;&nbsp;<br>"
            Next
        End If
    Else
        '配列添字数分のリストを追加
        If Not IsEmpty(strArrCode) Then
            For i = 0 To UBound(strArrCode)
                strHTML = strHTML & "<INPUT TYPE=""radio"" NAME=""" & strName & """ VALUE=""" & strArrCode(i) & """" & IIf(CStr(strArrCode(i)) = CStr(strSelectedCode), " CHECKED", "") & ">" & strArrName(i) & "&nbsp;&nbsp;<br>"
            Next
        End If
    End If

    EditRadioFromArray = strHTML

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 各ブラウザごとに適したテキストエレメントの最大文字列長を求める
'
' 引数　　 : (In)     lngMaxByte  通常の最大文字列長
'
' 戻り値　 : 変換後の最大文字列長
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function TextMaxLength(lngMaxByte)

    Dim lngMaxLength    '文字列の最大長

    Do
        'IE系、Netscape6では文字数となるため、全角文字を考慮し、半分に割る
        If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "MSIE") > 0 Or InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Netscape6") > 0 Then
            lngMaxLength = Int(lngMaxByte / 2)
            Exit Do
        End If

        'それ以外のブラウザは引数値をそのまま適用する
        lngMaxLength = lngMaxByte
        Exit Do
    Loop

    TextMaxLength = lngMaxLength

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 各ブラウザごとに適したテキストエレメントのサイズを求める
'
' 引数　　 : (In)     lngMaxByte  通常のサイズ
'
' 戻り値　 : 変換後のサイズ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function TextLength(lngByte)

    Dim lngLength   '文字列長

    Do
        'IE系の場合の係数乗算
        If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "MSIE") > 0 Then
            lngLength = Int(lngByte * 1.3)
            Exit Do
        End If

        'それ以外のブラウザは引数値をそのまま適用する
        lngLength = lngByte
        Exit Do
    Loop

    TextLength = lngLength

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 空白による文字列の分割
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : 分割された文字列の配列
'
' 備考　　 : 通常のSplit関数では空白文字が複数並んだ場合に対応できないため作成
'
'-------------------------------------------------------------------------------
Function SplitByBlank(strExpression)

    Dim strBuffer   '変換処理後の文字列バッファ

    If Trim(strExpression) = "" Then
        SplitByBlank = Empty
        Exit Function
    End If

    '全角空白を半角空白に置換する
    strBuffer = Replace(Trim(strExpression), "　", " ")

    '2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
    Do Until InStr(1, strBuffer, "  ") = 0
        strBuffer = Replace(strBuffer, "  ", " ")
    Loop

    '1バイト半角空白をデリミタとして配列を作成
    SplitByBlank = Split(strBuffer, " ")

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : IStringList型からVariant配列への変換
'
' 引数　　 : (In)     vntCollection  変換前のIStringList型データ
'
' 戻り値　 : 変換後のVariant配列
'
' 備考　　 : Request.QueryStringもしくはRequest.Formで送られるデータを
' 　　　　   通常の配列と同様に扱うために使用
'
'-------------------------------------------------------------------------------
Function ConvIStringToArray(vntCollection)

	Dim vntArray	'配列
    Dim vntData		'IStringList型データの要素
	Dim strBuffer	'文字列編集バッファ
	Dim i			'インデックス

	'オブジェクトが存在しない場合
'### Updated 2002/11/25
'	If IsEmpty(vntCollection) Or vntCollection = "" Then
	If IsEmpty(vntCollection) Then
		Exit Function
	End If

	'IStringList型データの場合
	If TypeName(vntCollection) = "IStringList" Then

		'全要素をカンマ連結
		For Each vntData In vntCollection
			strBuffer = strBuffer & Trim(vntData) & ","
		Next

	Else

		strBuffer = vntCollection

	End If

	'カンマを区切り文字として文字列を分割
	vntArray = Split(strBuffer, ",")

	'トリミング
	For i = 0 To UBound(vntArray)
		vntArray(i) = Trim(vntArray(i))
	Next

	'IStringList型データの場合、先にわざと要素を増やしているのでそれをカット
	If TypeName(vntCollection) = "IStringList" Then
		Redim Preserve vntArray(UBound(vntArray) - 1)
	End If

	ConvIStringToArray = vntArray

End Function

Function ConvIStringToArray_Old(vntCollection)

	Dim vntArray	'配列
    Dim vntData		'IStringList型データの要素
	Dim i			'インデックス

	'オブジェクトが存在しない場合
	If IsEmpty(vntCollection) Then
		Exit Function
	End If

	Select Case TypeName(vntCollection)

		Case "IStringList"

			'配列のサイズを指定
			vntArray = Array()
			ReDim Preserve vntArray(vntCollection.Count - 1)

			'IStringList型データの全要素を配列に格納
			For Each vntData In vntCollection
				vntArray(i) = Trim(vntData)
				i = i + 1
			Next

		Case "String"

			'カンマを区切り文字として文字列を分割
			vntArray = Split(vntCollection, ",")

			'トリミング
			For i = 0 To UBound(vntArray)
				vntArray(i) = Trim(vntArray(i))
			Next

	End Select

	ConvIStringToArray = vntArray

End Function

'S 東急電鉄-修正開始 A0000-000 2003/01/00 NSC)基尉 ()
'-------------------------------------------------------------------------------
'
' 機能　　 : コード・名称配列からのチェックボックステーブル作成
'
' 引数　　 : (In)     strArrCode          コードの配列
' 　　　　   (In)     strArrName          名称の配列
' 　　　　   (In)     strArrSelectedCode  選択コードの配列
' 　　　　   (In)     intColsNum          列数
' 　　　　   (In)     strOrnamentation    修飾文字
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditCheckTableFromArray(strArrCode, strArrName, strArrSelectedCode, intColsNum, strOrnamentation)

    Dim strHTML 	'HTML文字列
    Dim i, j, k		'インデックス
    Dim strCheck
	Dim objCommon	'

	Set objCommon = CreateObject("HainsCommon.Common")

    '配列添字数分のリストを追加
    i = 1
	If Not IsEmpty(strArrCode) Then
		strHTML = strHTML & vblf & "<TABLE BORDER=""0"" CELLPADDING=""1"" CELLSPACING=""2"">"
		strHTML = strHTML & vblf & "<TR>"
		For j = 0 To UBound(strArrCode)
			strCheck = ""
			If Not IsEmpty(strArrSelectedCode) Then
				For k = 0 to UBound(strArrSelectedCode)
					If Trim(strArrSelectedCode(k)) = Trim(strArrCode(j)) Then
						strCheck = "CHECKED"
					End If
				Next
			End If
			strHTML = strHTML & vbLf & "<TD><INPUT Type=""CheckBox"" Value=""1"" Name=""" & strOrnamentation & strArrCode(j) & """" & strCheck & ">" & strArrName(j) & "</TD>"
			i = i + 1
			If i > CInt(intColsNum) Then
				strHTML = strHTML & vblf & "</TR>" & vblf & "<TR>"
				i = 1
			End If
		Next
		If i > 1 Then
			For i = i To CInt(intColsNum)
				strHTML = strHTML & vblf & "<TD></TD>"
			Next
			strHTML = strHTML & vblf & "</TR>"
		End If
		strHTML = strHTML & vblf & "</TABLE>"
	End If

    EditCheckTableFromArray = strHTML

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 配列先頭要素の追加
'
' 引数　　 : (In/Out) strCd          コード
' 　　　　   (In/Out) strName        名称
' 　　　　   (In/Out) lngCount       配列の要素数
' 　　　　   (In)     strAppendCd    追加コード
' 　　　　   (In)     strAppendName  追加名称
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditList_AppendArray(strCd, strName, lngCount, strAppendCd, strAppendName)

	'コース情報が存在しない場合は空の配列を作成する
	If lngCount <= 0 Then
		strCd   = Array()
		strName = Array()
	End If

	'サイズを１つ増やす
	ReDim Preserve strCd(lngCount)
	ReDim Preserve strName(lngCount)
	lngCount = lngCount + 1

	'全要素を１つずつ後ろにシフトさせる
	For i = UBound(strCd) To 1 Step -1
		strCd(i)   = strCd(i - 1)
		strName(i) = strName(i - 1)
	Next

	'先頭に引数指定された要素を追加
	strCd(0)   = strAppendCd
	strName(0) = strAppendName

End Sub
'E 東急電鉄-修正終了 A0000-000 2003/01/00

'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
'-------------------------------------------------------------------------------
'
' 機能　　 : 2012年10月バージョン対象チェック
'
' 引数　　 : (In)     lngRsvNo 予約番号
'
' 戻り値　 : 2012年10月バージョン対象の受診情報であればTrue
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function IsVer201210(lngRsvNo)

	Const FREECD_CHG201210 = "CHG201210"	'2012年対応　変更日付取得用

	Dim objConsult	'受診情報アクセス用
	Dim objFree		'汎用情報アクセス用
	Dim strCslDate	'受診日
	Dim strChgDate	'切替日
	Dim Ret			'戻り値

	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Set objFree    = Server.CreateObject("HainsFree.Free")

	Do

		'受診情報検索
		If objConsult.SelectConsult(lngRsvNo, , strCslDate) = False Then
			Exit Do
		End If

		'切替日の取得
		objFree.SelectFree 0, FREECD_CHG201210, , , , strChgDate

		'切替日以降の受診日かを判定
		If strChgDate <> "" And CDate(strCslDate) >= CDate(strChgDate) Then
			Ret = True
		End If

		Exit Do
	Loop

	IsVer201210 = Ret

End Function
'## 2012.09.11 Add End


'## 2012.10.30 Add by 張 切替日付取得
'-------------------------------------------------------------------------------
'
' 機能　　 : 2012年10月バージョン対象チェック
'
' 戻り値　 : 2012年10月バージョン切替日付
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetVer201210()

    Const FREECD_CHG201210 = "CHG201210"    '2012年対応　変更日付取得用

    Dim objFree     '汎用情報アクセス用
    Dim strChgDate  '切替日
    Dim Ret         '戻り値

    Set objFree    = Server.CreateObject("HainsFree.Free")

    Do

        '切替日の取得
        objFree.SelectFree 0, FREECD_CHG201210, , , , strChgDate

        '切替日以降の受診日かを判定
        Exit Do
    Loop

    GetVer201210 = strChgDate

End Function
'## 2012.10.30 Add End


'## 2013.03.08 Add by 張 切替日付取得
'-------------------------------------------------------------------------------
'
' 機能　　 : 2012年10月バージョン対象チェック
'
' 戻り値　 : 2012年10月バージョン切替日付
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetVersion(strSpItem)

    Dim objFree     '汎用情報アクセス用
    Dim strChgDate  '切替日
    Dim Ret         '戻り値

    Set objFree    = Server.CreateObject("HainsFree.Free")

    Do
        '切替日の取得
        objFree.SelectFree 0, strSpItem, , , , strChgDate

        '切替日以降の受診日かを判定
        Exit Do
    Loop

    GetVersion = strChgDate

End Function
'## 2013.03.08 Add End


%>
