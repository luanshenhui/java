<%
'-------------------------------------------------------------------------------
'
' 機能　　 : コード・名称配列からのSELECTタグ生成（選択時イベント処理あり）
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strArrCode          コードの配列
' 　　　　   (In)     strArrName          名称の配列
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelDelFlg     未選択用空リスト削除フラグ(1:削除)
' 　　　　   (In)     strFuncName         スクリプトファンクション名
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDropDownListFromArray2(strName, strArrCode, strArrName, strSelectedCode, strNonSelDelFlg, strFuncName)

    Dim strHTML 	'HTML文字列
    Dim i       	'インデックス
	Dim objCommon	'

	Set objCommon = CreateObject("HainsCommon.Common")

    'SELECTタグの開始
    strHTML = "<SELECT NAME=""" & strName & """ ONCHANGE=""" & strFuncName & """>"

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
'			strHTML = strHTML & vbLf & "<OPTION VALUE=""" & strArrCode(i) & """" & IIf(strArrCode(i) = strSelectedCode, " SELECTED", "") & ">" & strArrName(i)
			strHTML = strHTML & "<OPTION VALUE=""" & strArrCode(i) & """" & IIf(CStr(strArrCode(i)) = CStr(strSelectedCode), " SELECTED", "") & ">" & strArrName(i)
		Next
	End If

    strHTML = strHTML & vbLf & "</SELECT>"

    EditDropDownListFromArray2 = strHTML

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 連続した数値用(年・月・日など)のSELECTタグ生成（選択時イベント処理あり）
'
' 引数　　 : (In)     strName           エレメント名
' 　　　　   (In)     lngStartValue     開始値
' 　　　　   (In)     lngEndValue       終了値
' 　　　　   (In)     lngSelectedValue  デフォルトの選択値
' 　　　　   (In)     strFuncName       スクリプトファンクション名
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditSelectNumberList2(strName, lngStartValue, lngEndValue, lngSelectedValue, strFuncName)

    Dim strHtml 'HTML文字列
    Dim i       'インデックス

    strHtml = "<SELECT NAME=""" & strName & """ ONCHANGE=""" & strFuncName & """>"
    strHtml = strHtml & vbLf & "<OPTION VALUE="""">"

    For i = lngStartValue To lngEndValue
'        strHtml = strHtml & vbLf & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
        strHtml = strHtml & "<OPTION VALUE=""" & CStr(i) & """" & IIf(i = lngSelectedValue, " SELECTED", "") & ">" & CStr(i)
    Next
    strHtml = strHtml & vbLf & "</SELECT>"

    EditSelectNumberList2 = strHtml

End Function
%>
