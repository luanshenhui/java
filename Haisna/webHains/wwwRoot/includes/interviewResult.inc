<%
'-----------------------------------------------------------------------------
'       面接支援　結果表示 Include File (Ver0.0.1)
'       AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'========================================
'管理番号：SL-SN-Y0101-305
'修正日  ：2011.07.01
'担当者  ：ORB)YAGUCHI
'修正内容：大腸３Ｄ－ＣＴ、頸動脈超音波、心不全スクリーニング、内臓脂肪面積、動脈硬化の追加
'========================================
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const INTERVIEWRESULT_TYPE1  = 1    '表示タイプ１
Const INTERVIEWRESULT_TYPE2  = 2    '表示タイプ２
Const INTERVIEWRESULT_TYPE3  = 3    '表示タイプ３
Const INTERVIEWRESULT_REFER  = 0    '参照モード
Const INTERVIEWRESULT_ENTRY  = 1    '更新モード

Dim lngEntryMode        '更新モード(0:参照モード,1:更新モード)
Dim lngHideFlg          '面接支援非表示フラグ(1:検査結果がない場合は非表示)

Dim lngMenResultTypeNo  '表示タイプ(1,2,3)
Dim strMenResultTitle   '表題
Dim strMenResultGrpCd1  '検索するグループ（タイプ１）
Dim strMenResultGrpCd3  '検索するグループ（タイプ３）
Dim strRayPaxOrdDiv     'RayPax画像レポート表示用のオーダ種別
Dim strRayPaxOrdDiv2    'RayPax画像レポート表示用のオーダ種別（２）
'#### 2013.01.08 SL-SN-Y0101-611 ADD START ####
Dim strRayPaxOrdDiv3    'RayPax画像レポート表示用のオーダ種別（３）
'#### 2013.01.08 SL-SN-Y0101-611 ADD END ####

'-------------------------------------------------------------------------------
'
' 機能　　 : 検査結果表示タイプ１用のTABLEタグ生成
'
' 引数　　 : (In)     lngHisCount       表示歴数
' 　　　　   (In)     vntHisRsvNo       予約番号（配列）
' 　　　　   (In)     lngRsvNo          予約番号（今回分）
' 　　　　   (In)     strGrpCd          グループコード
' 　　　　   (In)     lngLastDspMode    前回歴表示モード
' 　　　　   (In)     vntCsGrp          コースコード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditMenResultTable1( lngHisCount, vntHisRsvNo, lngRsvNo, strGrpCd, lngLastDspMode, vntCsGrp )
    'データベースアクセス用オブジェクト
    Dim objCommon           '共通クラス
    Dim objInterView        '面接情報アクセス用

    Dim lngGetSeqMode       '取得順 0:グループ内表示順＋日付 1:日付＋コード＋サフィックス
    Dim vntPerId            '予約番号
    Dim vntCslDate          '検査項目コード
    Dim vntHisNo            '履歴No.
    Dim vntRsvNo            '予約番号
    Dim vntItemCd           '検査項目コード
    Dim vntSuffix           'サフィックス
    Dim vntResultType       '結果タイプ
    Dim vntItemType         '項目タイプ
    Dim vntItemName         '検査項目名称
    Dim vntResult           '検査結果
    Dim vntStdFlg           '基準値フラグ
    Dim vntRslCmtCd1        '結果コメント１
    Dim vntRslCmtName1      '結果コメント名１
    Dim vntRslCmtCd2        '結果コメント２
    Dim vntRslCmtName2      '結果コメント名２
    Dim vntStccd            '文章コード
    Dim vntUnit             '単位
    Dim vntLowerValue       '基準値（最低）
    Dim vntUpperValue       '基準値（最高）
    Dim vntCUTargetFlg      'CU経年変化表示対象
    Dim vntClassName        '検査分類名称
    Dim vntRslFlg           '検査結果存在フラグ
    Dim vntHideInterview    '面接支援非表示フラグ
    Dim vntMinValue         '最小値
    Dim vntMaxValue         '最大値
    Dim lngRslCnt           '検査結果数

    Dim strHtml             'HTML文字列
    Dim strClassName        '検査分類名称
    Dim strClassName1       '検査分類名称(上の行）
    Dim strItemCd           '検査項目コード
    Dim strSuffix           'サフィックス
    Dim lngResultType       '結果タイプ
    Dim strItemName         '検査項目名称
    Dim strCUTargetFlg      'CU経年変化表示対象
    Dim strUnit             '単位
    Dim strLowerValue       '基準値（最低）
    Dim strUpperValue       '基準値（最高）
    Dim strMinValue         '最小値
    Dim strMaxValue         '最大値
    Dim i, j                'インデックス
    Dim strWork             'ワーク
    Dim strBgColor          '背景色
    Dim ArrIndex(3)         '検査結果インデックス
    Dim blnTRFlg            '行表示フラグ
    Dim strHideInterview    '面接支援非表示フラグ
    Dim blnIsValue          '値フラグ（True:有効値、False:無効値）
    Dim lngStdValueFlg      '基準値フラグ

    If lngHisCount < 1 then
        Exit Sub
    End If

    'オブジェクトのインスタンス作成
    Set objCommon       = Server.CreateObject("HainsCommon.Common")
    Set objInterView    = Server.CreateObject("HainsInterView.InterView")

    lngGetSeqMode = 0
    '指定対象受診者の検査結果を取得する
    lngRslCnt = objInterView.SelectHistoryRslList( _
                        lngRsvNo, _
                        lngHisCount, _
                        strGrpCd, _
                        lngLastDspMode, _
                        vntCsGrp, _
                        lngGetSeqMode, _
                        0, _
                        1, _
                        vntPerId, _
                        vntCslDate, _
                        vntHisNo, _
                        vntRsvNo, _
                        vntItemCd, _
                        vntSuffix, _
                        vntResultType, _
                        vntItemType, _
                        vntItemName, _
                        vntResult, _
                        vntStcCd, _
                        vntStdFlg, _
                        vntRslCmtCd1, vntRslCmtName1, _
                        vntRslCmtCd2, vntRslCmtName2, _
                        vntUnit, _
                        vntLowerValue, _
                        vntUpperValue, _
                        vntCUTargetFlg, _
                        , _
                        vntClassName, _
                        , , _
                        vntRslFlg, _
                        vntHideInterview, _
                        vntMinValue, _
                        vntMaxValue _
                        )
    If lngRslCnt < 0 Then
        Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="921" class="mensetsu-tb">
    <TR ALIGN="center" BGCOLOR="#cccccc">
        <th NOWRAP WIDTH="130">検査分類</th>
<%
    If lngEntryMode = 0 Then
%>
        <th NOWRAP WIDTH="18">CU</th>
<%
    End If
%>
        <th NOWRAP WIDTH="160">検査項目</th>
        <th NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1"></th>
        <th NOWRAP WIDTH="90">今回</th>
        <th NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1"></th>
        <th NOWRAP WIDTH="90">前回</th>
        <th NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1"></th>
        <th NOWRAP WIDTH="90" >前々回</th>
        <th NOWRAP WIDTH="100%">単位（標準範囲）</th>
    </TR>
<%
    For j=0 To 2
        ArrIndex(j) = -1
    Next
    If lngRslCnt > 0 then
        strClassName = vntClassName(0)
        strItemCd = vntItemCd(0)
        strSuffix = vntSuffix(0)
        lngResultType = vntResultType(0)
        strItemName = vntItemName(0)
        strCUTargetFlg = vntCUTargetFlg(0)
        strUnit = vntUnit(0)
        strLowerValue = vntLowerValue(0)
        strUpperValue = vntUpperValue(0)
        strMinValue = vntMinValue(0)
        strMaxValue = vntMaxValue(0)
        strHideInterview = vntHideInterview(0)
    Else
        lngRslCnt = -1
    End If

    strClassName1 = ""
    For i = 0 To lngRslCnt
        blnTRFlg = False
        '次の検査項目になったとき、１行表示(最後の検査結果も含む)
        If i = lngRslCnt Then
            blnTRFlg = True
        Else
            If strItemCd <> vntItemCd(i) Or strSuffix <> vntSuffix(i) Then
                blnTRFlg = True
            End If
        End If
        If blnTRFlg = True Then

            strHtml = " <TR BGCOLOR=""#ffffff"">"

            '検査分類
            If strClassName1 <> strClassName Then
                strClassName1 = strClassName
                strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center"">" & strClassName1 & "</TD>"
            Else
                strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center"">&nbsp;</TD>"
            End If

            'CU
            If lngEntryMode = 0 Then
                If strCUTargetFlg = 1 Then
                    strHtml = strHtml & vbLf & "        <TD NOWRAP WIDTH=""18""><INPUT TYPE=""checkbox"" NAME=""CUSelectItems"" VALUE=""1""></TD>"
                Else
                    strHtml = strHtml & vbLf & "        <TD NOWRAP WIDTH=""18""><INPUT style=""visibility:hidden"" TYPE=""checkbox"" NAME=""CUSelectItems"" VALUE=""0""></TD>"
                End If
            End If

            '検査項目
            If IsNull(strItemName) Or strItemName = "" Then
                strWork = "&nbsp;"
            Else
                strWork = strItemName
            End If
            strHtml = strHtml & vbLf & "        <TD NOWRAP>" & strWork & "</TD>"

            blnIsValue = Array(False, False, False)

            For j = 0 To 2
                Select Case j
                Case 0      '今回
                    strBgColor = " BGCOLOR=""#eeeeee"""

'### 2006/03/08 張 医局からの修正依頼によって前回と前々回の所見表示背景色変更 Start ###
'                Case 1      '前回
'                    strBgColor = " BGCOLOR=""#ffffcc"""
'                Case 2      '前々回
'                    strBgColor = " BGCOLOR=""#90f0aa"""
                Case 1      '前回
                    strBgColor = " BGCOLOR=""#90f0aa"""
                Case 2      '前々回
                    strBgColor = " BGCOLOR=""#ffffcc"""
'### 2006/03/08 張 医局からの修正依頼によって前回と前々回の所見表示背景色変更 End   ###

                Case Else
                    strBgColor = " BGCOLOR=""#ffffff"""
                End Select

                If ArrIndex(j) <> -1 then
                    If vntRslFlg(ArrIndex(j)) = "0" Then
                        '検査項目が存在しなかったら"***"表示
                        strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center""" & strBgColor & ">&nbsp;</TD>"
                        strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""right""" & strBgColor & ">***</TD>"
                    Else
                        '基準値フラグ
                        If IsNull(vntStdFlg(ArrIndex(j))) Or vntStdFlg(ArrIndex(j)) = "" Then
                            strWork = "&nbsp;"
                        Else
                            If vntStdFlg(ArrIndex(j)) = "S" Or  vntStdFlg(ArrIndex(j)) = "X" Then
                                strWork = "&nbsp;"
                            Else
                                strWork = "<FONT COLOR=""#ff0000""><B>*</B></FONT>"
                            End If
                        End If
                        strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center""" & strBgColor & ">" & strWork & "</TD>"
                        '検査結果
                        If IsNull(vntResult(ArrIndex(j))) Or vntResult(ArrIndex(j)) = "" Then
                            strWork = "&nbsp;"
                        Else
                            blnIsValue(j) = True
'### 2003/12/30 Start K.Kagawa 結果タイプが符号つき数字のときも表示できるように対応
                            '符号つき数字のときはコメント１と結合
                            If lngResultType = 8 Then
'### 2003/01/15 Start K.Kagawa 符号つき数字のコメントを結果の後ろに表示する
'                               strWork = vntRslCmtName1(ArrIndex(j)) & vntResult(ArrIndex(j))
                                strWork = vntResult(ArrIndex(j)) & vntRslCmtName1(ArrIndex(j))
'### 2003/01/15 End
                            Else
                                strWork = vntResult(ArrIndex(j))
                            End If
                        End If
                        strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""right""" & strBgColor & ">" & strWork & "</TD>"
                    End If
                Else
                    '検査項目が存在しなかったら"***"表示
                    strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center""" & strBgColor & ">&nbsp;</TD>"
                    strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""right""" & strBgColor & ">***</TD>"
                End If
            Next

            '単位（標準範囲）
'### 2003/12/26 Start K.Kagawa 文章タイプの基準値を表示する
            If lngResultType = 4 Then
                If strUpperValue = "" Then
                    strWork = strUnit
                Else
                    strWork = strUnit & "　" & strUpperValue
                End If
                If IsNull(strWork) Or strWork = "" Then
                    strWork = "&nbsp;"
                End If
            Else
                If strLowerValue = "" And strUpperValue = "" Then
                    strWork = strUnit
                Else
                    lngStdValueFlg = 0
                    If IsNumeric(strLowerValue) And IsNumeric(strUpperValue) And IsNumeric(strMinValue) And IsNumeric(strMaxValue) Then
                        If Cdbl(strLowerValue) <= Cdbl(strMinValue) And  Cdbl(strMaxValue) <= Cdbl(strUpperValue) Then
                            '最小値～最大値より基準値の範囲の方が広い場合は基準値表示なし
                            lngStdValueFlg = -1
                        Else
                            If Cdbl(strLowerValue) <= Cdbl(strMinValue) Then
                                '以下表示
                                lngStdValueFlg = 1
                            End If
                            If Cdbl(strMaxValue) <= Cdbl(strUpperValue) Then
                                '以上表示
                                lngStdValueFlg = 2
                            End If
                        End If
                    Else
                        '判断ができないときは、基準値をそのまま表示
                        lngStdValueFlg = 0
                    End If
                    Select Case lngStdValueFlg
                    Case 0      '基準値は「最低～最高」表示
                        strWork = strUnit & "　（" & strLowerValue & "～" & strUpperValue & "）"
                    Case 1      '基準値は「最高以下」表示
                        strWork = strUnit & "　（" & strUpperValue & "　以下）"
                    Case 2      '基準値は「最低以上」表示
                        strWork = strUnit & "　（" & strLowerValue & "　以上）"
                    Case Else   '基準値は表示なし
                        strWork = strUnit
                    End Select
                End If
                If IsNull(strWork) Or strWork = "" Then
                    strWork = "&nbsp;"
                End If
            End If
            strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center"">" & strWork & "</TD>"

            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""itemcd"" VALUE=""" & strItemCd & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & strSuffix & """>"
            strHtml = strHtml & vbLf & "    </TR>" & vbLf

            '非表示チェックがONで、検査項目テーブルの面接支援非表示フラグが"1"かつ値がない場合は非表示
            If lngHideFlg = "1" And strHideInterview = "1" And _
                (blnIsValue(0) = False and blnIsValue(1) = False And blnIsValue(2) = False) Then

                '非表示

            Else
                Response.Write strHtml
            End If

            'リセット
            If i < lngRslCnt Then
                For j=0 To 2
                    ArrIndex(j) = -1
                Next
                strClassName = vntClassName(i)
                strItemCd = vntItemCd(i)
                strSuffix = vntSuffix(i)
                strItemName = vntItemName(i)
                strCUTargetFlg = vntCUTargetFlg(i)
                strUnit = IIf(IsNull(strUnit), "", vntUnit(i))
                strLowerValue = IIf(IsNull(strLowerValue), "", vntLowerValue(i))
                strUpperValue = IIf(IsNull(strUpperValue), "", vntUpperValue(i))
                strMinValue = IIf(IsNull(strMinValue), "", vntMinValue(i))
                strMaxValue = IIf(IsNull(strMaxValue), "", vntMaxValue(i))
                strHideInterview = vntHideInterview(i)
            End If
        End If
        If i < lngRslCnt Then
            lngResultType = vntResultType(i)
            ArrIndex(vntHisNo(i)-1) = i
        End If
    Next
%>
</TABLE>
<%
    'オブジェクトのインスタンス削除
    Set objCommon = Nothing
    Set objInterView = Nothing
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 検査結果表示タイプ３用のTABLEタグ生成
'
' 引数　　 : (In)     lngHisCount       表示歴数
' 　　　　   (In)     vntHisRsvNo       予約番号（配列）
' 　　　　   (In)     lngRsvNo          予約番号（今回分）
' 　　　　   (In)     strGrpCd          グループコード
' 　　　　   (In)     lngLastDspMode    前回歴表示モード
' 　　　　   (In)     vntCsGrp          コースコード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditMenResultTable3( lngHisCount, vntHisRsvNo, lngRsvNo, strGrpCd, lngLastDspMode, vntCsGrp )
    Dim objInterView        '面接情報アクセス用

    Dim lngGetSeqMode       '取得順 0:グループ内表示順＋日付 1:日付＋コード＋サフィックス
    Dim vntPerId            '予約番号
    Dim vntCslDate          '検査項目コード
    Dim vntHisNo            '履歴No.
    Dim vntRsvNo            '予約番号
    Dim vntItemCd           '検査項目コード
    Dim vntSuffix           'サフィックス
    Dim vntResultType       '結果タイプ
    Dim vntItemType         '項目タイプ
    Dim vntItemName         '検査項目名称
    Dim vntResult           '検査結果
    Dim vntStccd            '文章コード
    Dim vntRslCmtCd1        '結果コメント１
    Dim vntRslCmtName1      '結果コメント名１
    Dim vntRslCmtCd2        '結果コメント２
    Dim vntRslCmtName2      '結果コメント名２
    Dim vntClassName        '検査分類名称
    Dim vntRslFlg           '検査結果存在フラグ
    Dim vntHideInterview    '面接支援非表示フラグ
    Dim lngRslCnt           '検査結果数

    Dim strHtml             'HTML文字列
    Dim strClassName        '検査分類名称
    Dim strClassName1       '検査分類名称(上の行）
    Dim i, j                'インデックス
    Dim strWork             'ワーク
    Dim lngDispCnt          '検査結果表示数
    Dim strUpdFlg           '更新可能フラグ
    Dim blnIsValue          '値フラグ（True:有効値、False:無効値）

    If lngHisCount < 1 then
        Exit Sub
    End If

    'オブジェクトのインスタンス作成
    Set objInterView    = Server.CreateObject("HainsInterView.InterView")

    lngGetSeqMode = 2
    '指定対象受診者の検査結果を取得する
    lngRslCnt = objInterView.SelectHistoryRslList( _
                        lngRsvNo, _
                        lngHisCount, _
                        strGrpCd, _
                        lngLastDspMode, _
                        vntCsGrp, _
                        lngGetSeqMode, _
                        0, _
                        1, _
                        vntPerId, _
                        vntCslDate, _
                        vntHisNo, _
                        vntRsvNo, _
                        vntItemCd, _
                        vntSuffix, _
                        vntResultType, _
                        vntItemType, _
                        vntItemName, _
                        vntResult, _
                        vntStccd, _
                        , _
                        vntRslCmtCd1, vntRslCmtName1, _
                        vntRslCmtCd2, vntRslCmtName2, _
                        , , , , , _
                        vntClassName, _
                        , , _
                        vntRslFlg, _
                        vntHideInterview _
                        )
    If lngRslCnt < 0 Then
        Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="900" class="mensetsu-tb">
    <TR ALIGN="center" BGCOLOR="#cccccc">
        <th NOWRAP WIDTH="130">検査分類</th>
        <th NOWRAP WIDTH="160">検査項目</th>
<%
    If lngEntryMode = 0 Then
%>
        <th NOWRAP WIDTH="100%">所見</th>
<%
    Else
%>
        <th NOWRAP COLSPAN="3" WIDTH="100%">所見</th>
<%
    End If
%>
    </TR>
<%
    lngDispCnt = 0
    strClassName1 = ""
    For i = 0 To lngRslCnt -1
        '結果タイプにより表示項目を判断する
'### 2003/12/17 Start K.Kagawa 結果タイプがメモのときも表示できるように対応
'       If vntResultType(i) = 3 Or vntResultType(i) = 4 Then
        If vntResultType(i) = 3 Or vntResultType(i) = 4 Or vntResultType(i) = 7 Then

            blnIsValue = False

            '背景色の判定
            Select Case vntHisNo(i)
            Case 1      '今回
                strHtml = " <TR BGCOLOR=""#eeeeee"">"
'### 2006/03/08 張 医局からの修正依頼によって前回と前々回の所見表示背景色変更 Start ###
'            Case 2      '前回
'                strHtml = " <TR BGCOLOR=""#ffffcc"">"
'            Case 3      '前々回
'                strHtml = " <TR BGCOLOR=""#90f0aa"">"
            Case 2      '前回
                strHtml = " <TR BGCOLOR=""#90f0aa"">"
            Case 3      '前々回
                strHtml = " <TR BGCOLOR=""#ffffcc"">"
'### 2006/03/08 張 医局からの修正依頼によって前回と前々回の所見表示背景色変更 End   ###
            Case Else
                strHtml = " <TR BGCOLOR=""#ffffff"">"
            End Select

            '検査分類
            strClassName = vntClassName(i)
            If strClassName1 <> strClassName Then
                strClassName1 = strClassName
                strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center"">" & strClassName1 & "</TD>"
            Else
                strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center"">&nbsp;</TD>"
            End If

            '検査項目
            If IsNull(vntItemName(i)) Or vntItemName(i) = "" Then
                strWork = "&nbsp;"
            Else
                strWork = vntItemName(i)
            End If
            strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""center""><SPAN ID=""itemname" & lngDispCnt & """>" & strWork & "</SPAN></TD>"

            '所見
            strUpdFlg = -1
            If vntRslFlg(i) = "0" Then
                '検査項目が存在しなかったら"***"表示
                strHtml = strHtml & vbLf & "        <TD NOWRAP COLSPAN=""3"" ALIGN=""left"">***</TD>"
            Else
                If IsNull(vntResult(i)) Or vntResult(i) = "" Then
                    strWork = "&nbsp;"
                Else
                    blnIsValue = True
                    strWork = vntResult(i)
                End If
                If lngEntryMode = 0Then
                    strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""left"">" & strWork & "</TD>"
                Else
                    If vntRsvNo(i) = vntHisRsvNo(0) Then
                        '更新モードで今回分は所見の修正が可能
                        strUpdFlg = 0
'### 2003/12/30 Start K.Kagawa 結果タイプがメモのときも表示できるように対応
                        'メモタイプのときは別ガイドを表示する
                        If vntResultType(i) = 7 Then
                            strHtml = strHtml & vbLf & "        <TD NOWRAP><A HREF=""JavaScript:callMemo(" & lngDispCnt & ")""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""メモ入力ガイドを表示します""></A></TD>"
                        Else
                            strHtml = strHtml & vbLf & "        <TD NOWRAP><A HREF=""JavaScript:callSentence(" & lngDispCnt & ")""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""所見選択ガイドを表示します""></A></TD>"
                        End If
                        strHtml = strHtml & vbLf & "        <TD NOWRAP><A HREF=""JavaScript:clearSentenceInfo(" & lngDispCnt & ")""><IMG SRC=""../../images/delicon.gif""  WIDTH=""21"" HEIGHT=""21"" ALT=""所見を削除します""></A></TD>"
                        strHtml = strHtml & vbLf & "        <TD NOWRAP ALIGN=""left"" WIDTH=""100%""><SPAN ID=""sentence" & lngDispCnt & """>" & strWork & "</SPAN></TD>"
                    Else
                        strHtml = strHtml & vbLf & "        <TD NOWRAP COLSPAN=""3"" ALIGN=""left"">" & strWork & "</TD>"
                    End If
                End If
            End If
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""rsvno1"" VALUE=""" & vntRsvNo(i) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""itemcd"" VALUE=""" & vntItemCd(i) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & vntSuffix(i) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""itemtype"" VALUE=""" & vntItemType(i) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""result"" VALUE=""" & IIf(IsNull(vntResult(i)),"",vntResult(i)) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""stccd"" VALUE=""" & IIf(IsNull(vntStccd(i)),"",vntStccd(i)) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""cmtcd1"" VALUE=""" & IIf(IsNull(vntRslCmtCd1(i)),"",vntRslCmtCd1(i)) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""cmtcd2"" VALUE=""" & IIf(IsNull(vntRslCmtCd2(i)),"",vntRslCmtCd2(i)) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""hisno"" VALUE=""" & vntHisNo(i) & """>"
            strHtml = strHtml & vbLf & "        <INPUT TYPE=""hidden"" NAME=""updflg"" VALUE=""" & strUpdFlg & """>"
            strHtml = strHtml & vbLf & "    </TR>" & vbLf

            '非表示チェックがONで、検査項目テーブルの面接支援非表示フラグが"1"かつ値がない場合は非表示
            If lngHideFlg = "1" And vntHideInterview(i) = "1" And blnIsValue = False Then

                '非表示

            Else
                Response.Write strHtml
            End If

            lngDispCnt = lngDispCnt + 1
        End If
    Next
%>
</TABLE>
<%
    'オブジェクトのインスタンス削除
    Set objInterView = Nothing
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : グループ情報取得
'
' 　　　　   (In)     strGrpCd          グループコード
'
' 戻り値　 : 
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetMenResultGrpInfo( strGrpNo )
    
    lngMenResultTypeNo = 0
    strMenResultTitle  = "？？？"
    strMenResultGrpCd1 = ""
    strMenResultGrpCd3 = ""

    Select Case strGrpNo
    Case "1"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "診察・体格・血圧・肺機能"
        strMenResultGrpCd3 = "X001"
        strMenResultGrpCd1 = "X002"

    Case "2"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
        strMenResultTitle  = "心電図"
        strMenResultGrpCd3 = "X003"
        strRayPaxOrdDiv = "ORDDIV000006"

    Case "3"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
        strMenResultTitle  = "胸部Ｘ線"
        strMenResultGrpCd3 = "X004"
        strRayPaxOrdDiv = "ORDDIV000009"

    Case "4"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
'### 2004/2/5 Updated by Ishihara@FSIT ドクター要望により名称変更
'		strMenResultTitle  = "上部消化管・大腸"
        strMenResultTitle  = "上部消化管・便潜血"
'### 2004/2/5 Updated End
        strMenResultGrpCd3 = "X005"
        strMenResultGrpCd1 = "X006"
        strRayPaxOrdDiv = "ORDDIV000011"
        strRayPaxOrdDiv2 = "ORDDIV000014"

    Case "5"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
        strMenResultTitle  = "上腹部超音波"
        strMenResultGrpCd3 = "X007"
        strRayPaxOrdDiv = "ORDDIV000007"

    Case "6"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "血液"
        strMenResultGrpCd1 = "X008"

    Case "7"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "糖代謝・脂質代謝"
        strMenResultGrpCd1 = "X009"

    Case "8"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "尿酸・肝機能・腎機能"
        strMenResultGrpCd1 = "X010"

    Case "9"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "電解質・血清・尿検査・前立腺"
        strMenResultGrpCd1 = "X011"

    Case "10"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "視力・眼底・聴力・骨密度"
        strMenResultGrpCd3 = "X012"
        strMenResultGrpCd1 = "X013"
        strRayPaxOrdDiv = "ORDDIV000013"

    Case "11"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
'#### 2013.01.08 SL-SN-Y0101-611 MOD START ####
'       strMenResultTitle  = "乳房・婦人科"
'       strMenResultGrpCd3 = "X014"
       lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
       strMenResultTitle  = "乳房・婦人科・婦人科超音波"
       strMenResultGrpCd3 = "X119"
       strMenResultGrpCd1 = "X118"
'#### 2013.01.08 SL-SN-Y0101-611 MOD END ####
        strRayPaxOrdDiv = "ORDDIV000008"
        strRayPaxOrdDiv2 = "ORDDIV000012"
'#### 2013.01.08 SL-SN-Y0101-611 ADD START ####
        strRayPaxOrdDiv3 = "ORDDIV000020"
'#### 2013.01.08 SL-SN-Y0101-611 ADD END ####

    Case "12"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
        strMenResultTitle  = "大腸内視鏡"
        strMenResultGrpCd3 = "X015"
        strRayPaxOrdDiv = "ORDDIV000015"

    Case "13"
'#### 2017.02.15 張 CT肺気腫検査追加の為、仕様変更 STR ####
'        lngMenResultTypeNo = INTERVIEWRESULT_TYPE3
'        strMenResultTitle  = "ヘリカルＣＴ／喀痰"
'        strMenResultGrpCd3 = "X016"
'----------------------------------------------------------
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "ヘリカルＣＴ／喀痰／ＣＴ肺気腫"
        strMenResultGrpCd3 = "X016"
        strMenResultGrpCd1 = "X679"
'#### 2017.02.15 張 CT肺気腫検査追加の為、仕様変更 END ####
        strRayPaxOrdDiv = "ORDDIV000010"

    Case "14"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "後日検査"
        strMenResultGrpCd1 = "X053"

'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
    Case "15"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "大腸３Ｄ－ＣＴ"
        strMenResultGrpCd3 = "X100"
        strMenResultGrpCd1 = "X101"
        strRayPaxOrdDiv = "ORDDIV000016"

    Case "16"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "頸動脈超音波"
        strMenResultGrpCd3 = "X102"
        strMenResultGrpCd1 = "X103"
        strRayPaxOrdDiv = "ORDDIV000018"

    Case "17"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "動脈硬化"
        strMenResultGrpCd3 = "X104"
        strMenResultGrpCd1 = "X105"
        strRayPaxOrdDiv = "ORDDIV000019"

    Case "18"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "内臓脂肪面積"
        strMenResultGrpCd1 = "X106"
        strRayPaxOrdDiv = "ORDDIV000017"

    Case "19"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE1
        strMenResultTitle  = "心不全スクリーニング"
        strMenResultGrpCd1 = "X108"
'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Case "20"
        lngMenResultTypeNo = INTERVIEWRESULT_TYPE2
        strMenResultTitle  = "婦人科超音波"
        strMenResultGrpCd3 = "X117"
        strMenResultGrpCd1 = "X118"
        strRayPaxOrdDiv = "ORDDIV000020"
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    End Select

End Function

%>
