<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受診者一覧 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'	列番号と列名の関係は次のとおり。
'	 1	時間枠(未使用)
'	 2	当日ＩＤ
'	 3	管理番号(未使用)
'	 4	コース
'	 5	氏名
'	 6	カナ氏名
'	 7	性別
'	 8	生年月日
'	 9	受診時年齢
'	10	団体略称
'	11	予約番号
'	12	受診日
'	13	予約日
'	14	追加検査
'	15  受付日(未使用)
'	16	個人氏名(カナ氏名・氏名の両方)
'	17	個人ＩＤ
'	18	受診項目
'	19	部門送信(未使用)
'	20	受診日からの相対日(未使用)
'	21	従業員番号(未使用)
'	22	健保記号
'	23	健保番号
'	24	事業部名称(未使用)
'	25	室部名称(未使用)
'	26	所属名称(未使用)
'	27	受診日確定フラグ(未使用)
'	28	ＯＣＲ用受診日(未使用)
'	29	検体番号(未使用)
'	30	問診票出力日(未使用)
'	31	胃カメラ受診日(未使用)
'	32	サブコース
'	33	個人情報の健保記号(未使用)
'	34	個人情報の健保番号(未使用)
'	35	結果入力状態

'	36  予約状況
'	37  確認はがき出力日
'	38  一式書式出力日
'	39  予約群名称
'	40  お連れ様有無
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editFreeList.inc"   -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objGrp				'グループ項目アクセス用
Dim objItem				'検査項目アクセス用
Dim objOrganization		'団体情報アクセス用

'パラメータ値
Dim strKey				'検索キー
Dim lngStrYear			'受診日(自)(年)
Dim lngStrMonth			'受診日(自)(月)
Dim lngStrDay			'受診日(自)(日)
Dim lngEndYear			'受診日(至)(年)
Dim lngEndMonth			'受診日(至)(月)
Dim lngEndDay			'受診日(至)(日)
Dim strCsCd				'コースコード
Dim strPrtField			'出力項目コード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strItemCd			'依頼項目コード
Dim strGrpCd			'グループコード
Dim strEntry			'結果入力状態("":指定なし、"1":未入力のみ表示、"2":入力済みのみ表示)
Dim lngSortKey			'ソートキー
Dim lngSortType			'ソート順(0:昇順、1:降順)
Dim lngStartPos			'表示開始位置
Dim strGetCount			'１ページ表示行数
Dim lngPrint			'印刷モード(0:通常表示モード、1:印刷モード)
Dim strNavi				'ナビバー表示

Dim strRsvStat			'予約状態("":すべて、"1":キャンセル、"2":予約のみ、"3":受付済みのみ)
Dim strRptStat			'受診状態("":すべて、"1":未来院、"2":来院済み)

'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
Dim strCslDivCd         '受診区分コード
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

'出力項目情報
Dim lngArrPrtField		'出力項目の配列
Dim strPrtFieldName		'出力項目名

'受診情報
Dim strArrRsvNo			'予約番号の配列
Dim strArrCancelFlg		'キャンセルフラグの配列
Dim strArrCslDate		'受診日の配列
Dim strArrPerId			'個人IDの配列
Dim strArrOrgCd1		'団体コード1の配列
Dim strArrOrgCd2		'団体コード2の配列
Dim strArrRsvDate		'予約日の配列
Dim strArrAge			'年齢の配列
Dim strArrDayId			'当日IDの配列
Dim strArrWebColor		'コース名表示色の配列
Dim strArrCsName		'コース名の配列
Dim strArrName			'氏名の配列
Dim strArrKanaName		'カナ氏名の配列
Dim strArrBirth			'生年月日の配列
Dim strArrGender		'性別の配列
Dim strArrOrgSName		'団体略称の配列
Dim strArrAddDiv		'追加検査区分の配列
Dim strArrAddName		'追加検査名の配列
Dim strArrRequestName	'検査項目名の配列
Dim strArrIsrSign		'健保記号の配列
Dim strArrIsrNo			'健保番号の配列
Dim strArrSubCsWebColor	'サブコースのwebカラーの配列
Dim strArrSubCsName		'サブコース名の配列
Dim strArrEntry			'結果入力状態の配列
Dim strArrRsvStatus		'予約状況の配列
Dim strArrCardPrintDate	'確認はがき出力日の配列
Dim strArrFormPrintDate	'一式書式出力日の配列
Dim strArrRsvGrpName	'予約群名称の配列
Dim strArrHasFriends	'お連れ様有無の配列
Dim lngCount			'レコード件数
Dim lngNotCanceledCount	'非キャンセル者のレコード件数

Dim lngGetCount			'表示件数
Dim dtmStrDate			'受診日(自)
Dim dtmEndDate			'受診日(至)
Dim strDispDate			'表示用の受診日付
Dim strOrgSName			'団体略称
Dim strItemName			'依頼項目／グループ名称
Dim dtmDate				'日付
Dim blnAnchor			'アンカーの要否
Dim strMessage			'エラーメッセージ
Dim strBuffer			'文字列バッファ
Dim strHTML				'HTML文字列
Dim strURL				'ジャンプ先のURL
Dim i, j				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strKey      = Request("key")
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))
strCsCd     = Request("csCd")
strPrtField = Request("prtField")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strItemCd   = Request("itemCd")
strGrpCd    = Request("grpCd")
strEntry    = Request("entry")
lngSortKey  = CLng("0" & Request("sortKey"))
lngSortType = CLng("0" & Request("sortType"))
lngStartPos = CLng("0" & Request("startPos"))
strGetCount = Request("getCount")
lngPrint    = CLng(Request("print"))
strNavi     = Request("navi")

strRsvStat  = Request("rsvStat")
strRptStat  = Request("rptStat")

'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
strCslDivCd = Request("cslDivCd")
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

'検索キー中の半角カナを全角カナに変換する
strKey = objCommon.StrConvKanaWide(strKey)

'検索キー中の小文字を大文字に変換する
strKey = UCase(strKey)

'全角空白を半角空白に置換する
strKey = Replace(Trim(strKey), "　", " ")

'2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop

'出力項目のデフォルト値設定
strPrtField = IIf(strPrtField = "", "RSVLIST1", strPrtField)

'出力開始位置のデフォルト値として１を設定
lngStartPos  = IIf(lngStartPos = 0, 1, lngStartPos)

'１ページ表示行数のデフォルト値設定
strGetCount = IIf(strGetCount = "", objCommon.SelectDailyPageMaxLine, strGetCount)
If IsNumeric(strGetCount) Then
    lngGetCount = CLng(strGetCount)
End If

'団体名称の取得
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
    objOrganization.SelectOrgSName strOrgCd1, strOrgCd2, strOrgSName
    Set objOrganization = Nothing
End If

'検査項目名の取得
If strItemCd <> "" Then
    Set objItem = Server.CreateObject("HainsItem.Item")
    objItem.SelectItem_P strItemCd, strItemName
    Set objItem = Nothing
End If

'グループ名の取得
If strGrpCd <> "" Then
    Set objGrp = Server.CreateObject("HainsGrp.Grp")
    objGrp.SelectGrp_P strGrpCd, strItemName
    Set objGrp = Nothing
End If

Do

    '受診日(自)の日付チェック
    If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
        If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
            strMessage = "受診日の指定に誤りがあります。"
            Exit Do
        End If
    End If

    '受診日(至)の日付チェック
    If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
        If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
            strMessage = "受診日の指定に誤りがあります。"
            Exit Do
        End If
    End If

    '表示項目の取得
    EditPrtFieldArray strPrtField, strPrtFieldName, lngArrPrtField
    If Not IsArray(lngArrPrtField) Then
        strMessage = "表示すべき項目が指定されていません。"
        Exit Do
    End If

    'ソートキー未指定時は表示項目の先頭項目を適用する
    If lngSortKey = 0 Then
        lngSortKey  = lngArrPrtField(0)
        lngSortType = 0
    End If

    '受診日の編集
    If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
        dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
    End If

    If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
        dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
    End If

    Do

        '終了日未設定時は何もしない
        If dtmEndDate = 0 Then
            Exit Do
        End If

        '開始日未設定、または開始日より終了日が過去であれば
        If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

            '値を交換
            dtmDate    = dtmStrDate
            dtmStrDate = dtmEndDate
            dtmEndDate = dtmDate

        End If

        '更に同値の場合、終了日はクリア
        If dtmStrDate = dtmEndDate Then
            dtmEndDate = 0
        End If

        Exit Do
    Loop

    '後の処理のために年月日を再編集
    If dtmStrDate <> 0 Then
        lngStrYear  = Year(dtmStrDate)
        lngStrMonth = Month(dtmStrDate)
        lngStrDay   = Day(dtmStrDate)
    Else
        lngStrYear  = 0
        lngStrMonth = 0
        lngStrDay   = 0
    End If

    If dtmEndDate <> 0 Then
        lngEndYear  = Year(dtmEndDate)
        lngEndMonth = Month(dtmEndDate)
        lngEndDay   = Day(dtmEndDate)
    Else
        lngEndYear  = 0
        lngEndMonth = 0
        lngEndDay   = 0
    End If

    '検索キー、受診日のいずれかが指定されていない場合は検索を行わない
    If dtmEndDate = 0 And dtmStrDate = 0 And strKey = "" Then
        strMessage = "検索条件を満たす受診情報は存在しません。"
        Exit Do
    End If

    '受診情報の読み込み
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
'    lngCount = objConsult.SelectDailyList( _
'                   strKey,              dtmStrDate,       dtmEndDate,                           _
'                   strCsCd,             strOrgCd1,        strOrgCd2,       strGrpCd,            _
'                   strItemCd,           strEntry,         lngArrPrtField,  lngSortKey,          _
'                   lngSortType,         lngStartPos,      lngGetCount,                          _
'                   strArrRsvNo,         strArrCancelFlg,  strArrCslDate,   strArrPerId,         _
'                   strArrOrgSName,      strArrRsvDate,    strArrAge,       strArrDayId,         _
'                   strArrWebColor,      strArrCsName,     strArrName,      strArrKanaName,      _
'                   strArrBirth,         strArrGender,     strArrAddDiv,    strArrAddName,       _
'                   strArrRequestName,   strArrIsrSign,    strArrIsrNo,     strArrSubCsWebColor, _
'                   strArrSubCsName,     strArrEntry,      strArrRsvStatus, strArrCardPrintDate, _
'                   strArrFormPrintDate, strArrRsvGrpName, strArrHasFriends,                     _
'                   strRsvStat,          strRptStat                                              _
'               )

    lngCount = objConsult.SelectDailyList( _
                   strKey,              dtmStrDate,       dtmEndDate,                           _
                   strCsCd,             strOrgCd1,        strOrgCd2,       strGrpCd,            _
                   strItemCd,           strEntry,         lngArrPrtField,  lngSortKey,          _
                   lngSortType,         lngStartPos,      lngGetCount,                          _
                   strArrRsvNo,         strArrCancelFlg,  strArrCslDate,   strArrPerId,         _
                   strArrOrgSName,      strArrRsvDate,    strArrAge,       strArrDayId,         _
                   strArrWebColor,      strArrCsName,     strArrName,      strArrKanaName,      _
                   strArrBirth,         strArrGender,     strArrAddDiv,    strArrAddName,       _
                   strArrRequestName,   strArrIsrSign,    strArrIsrNo,     strArrSubCsWebColor, _
                   strArrSubCsName,     strArrEntry,      strArrRsvStatus, strArrCardPrintDate, _
                   strArrFormPrintDate, strArrRsvGrpName, strArrHasFriends,                     _
                   strRsvStat,          strRptStat,     , strCslDivCd                           _
               )
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

    Set objConsult = Nothing

    '対象データが存在しない場合はメッセージを編集
    If lngCount = 0 Then
        strMessage = "検索条件を満たす受診情報は存在しません。"
    End If

    Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 表示行数一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　 : (In)     strSelectedPageMaxLine  リストにて選択すべき表示行数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDailyPageMaxLineList(strName, strSelectedPageMaxLine)

    Dim vntPageMaxLine	'表示行数
    Dim vntPageMaxName	'表示行数名称

    '表示行数情報の取得
    If objCommon.SelectDailyPageMaxLineList(vntPageMaxLine, vntPageMaxName) > 0 Then

        'ドロップダウンリストの編集
        EditDailyPageMaxLineList = EditDropDownListFromArray(strName, vntPageMaxLine, vntPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件入力エレメントの編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditEntryCondition()

    '通常表示モード以外であれば編集しない
    If lngPrint <> 0 Then
        Exit Sub
    End If
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="850">
        <TR>
            <TD WIDTH="74" NOWRAP>検索キー：</TD>
            <TD COLSPAN="8"><INPUT TYPE="text" NAME="key" SIZE="45" VALUE="<%= strKey %>"></TD>
            <TD COLSPAN="11"><% Call EditOperationMenu() %></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD NOWRAP>受診日：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><A HREF="javascript:calGuide_clearDate('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, True) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, True) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strDay", 1, 31, lngStrDay, True) %></TD>
            <TD>日</TD>
            <TD>～</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, True) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, True) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("endDay", 1, 31, lngEndDay, True) %></TD>
            <TD>日</TD>
            <TD WIDTH="100%" ALIGN="right" NOWRAP>コース：</TD>
            <TD><%= EditCourseList("csCd", strCsCd, "全てのコース") %></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD WIDTH="72" NOWRAP>受診団体：</TD>
            <TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"  ></A></TD>
            <TD WIDTH="169" NOWRAP><SPAN ID="orgname"><%= strOrgSName %></SPAN></TD>
            <TD ALIGN="right" NOWRAP>受診項目：</TD>
            <TD><A HREF="javascript:callItmGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="項目ガイドを表示"  ></A></TD>
            <TD><A HREF="javascript:clearItemCd()" ><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="itemname"><%= strItemName %></SPAN></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="850">
        <TR>
<!--
            <TD ALIGN="right" NOWRAP>結果入力状態：</TD>
            <TD>
                <SELECT NAME="entry">
                    <OPTION VALUE=""  <%= IIf(strEntry = "",  "SELECTED", "") %>>指定なし
                    <OPTION VALUE="1" <%= IIf(strEntry = "1", "SELECTED", "") %>>未入力のみ表示
                    <OPTION VALUE="2" <%= IIf(strEntry = "2", "SELECTED", "") %>>入力済みのみ表示
                </SELECT>
            </TD>
-->
            <TD NOWRAP>予約状態：</TD>
            <TD>
                <SELECT NAME="rsvStat">
                    <OPTION VALUE=""  <%= IIf(strRsvStat = "",  "SELECTED", "") %>>すべて
                    <OPTION VALUE="1" <%= IIf(strRsvStat = "1", "SELECTED", "") %>>キャンセル
                    <OPTION VALUE="2" <%= IIf(strRsvStat = "2", "SELECTED", "") %>>予約のみ
                    <OPTION VALUE="3" <%= IIf(strRsvStat = "3", "SELECTED", "") %>>受付済み
                </SELECT>
            </TD>
            <TD NOWRAP>&nbsp;受診状態：</TD>
            <TD>
                <SELECT NAME="rptStat">
                    <OPTION VALUE=""  <%= IIf(strRptStat = "",  "SELECTED", "") %>>すべて
                    <OPTION VALUE="1" <%= IIf(strRptStat = "1", "SELECTED", "") %>>未来院
                    <OPTION VALUE="2" <%= IIf(strRptStat = "2", "SELECTED", "") %>>来院済み
                </SELECT>
            </TD>

<%'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################ %>
            <TD NOWRAP>&nbsp;受診区分：</TD>
<%
            Dim objFree         '汎用情報アクセス用

            '汎用情報
            Dim strFreeCd           '汎用コード
            Dim strFreeDate         '汎用日付
            Dim strFreeField1       'フィールド１
            Dim strFreeField2       'フィールド２

            '汎用テーブルから受診区分を読み込む
            Set objFree = Server.CreateObject("HainsFree.Free")
            objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
            Set objFree = Nothing
%>
            <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, SELECTED_ALL) %></TD>

<%'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################ %>

            <TD WIDTH="100%"></TD>
            <TD><%= EditRsvListList("prtField", strPrtField, NON_SELECTED_DEL) %></TD>
            <TD><%= EditDailyPageMaxLineList("getCount", strGetCount) %></TD>
            <TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示" id="testtest"></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditCondition()

    Dim objCourse	'コース情報アクセス用

    Dim strCsName	'コース名
    Dim strBuffer	'文字列バッファ

    '印刷用表示モード以外であれば編集しない
    If lngPrint <> 1 Then
        Exit Sub
    End If
%>
    <SPAN STYLE="font-size: 9px;">
<%
    'コース名の取得
    If strCsCd <> "" Then
        Set objCourse = Server.CreateObject("HainsCourse.Course")
        objCourse.SelectCourse strCsCd, strCsName
        Set objCourse = Nothing
    End If
%>
    コース：<%= IIf(strCsName = "", "すべて", strCsName) %>&nbsp;&nbsp;

    受診団体：<%= IIf(strOrgSName = "", "指定なし", strOrgSName) %>&nbsp;&nbsp;

    受診項目：<%= IIf(strItemName = "", "指定なし", strItemName) %><BR>
<%
    Select Case strEntry
        Case "1"
            strBuffer = "未入力のみ表示"
        Case "2"
            strBuffer = "入力済みのみ表示"
        Case Else
            strBuffer = "指定なし"
    End Select
%>
<!--
    結果入力状態：<%= strBuffer %>&nbsp;&nbsp;
-->
    表示項目：<%= IIf(strPrtFieldName = "", "デフォルト", strPrtFieldName) %>&nbsp;&nbsp;

    <%= IIf(strGetCount = "*", "全データ", strGetCount & "件ずつ") %>表示

    </SPAN>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 「この日の操作」の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditOperationMenu()

    Dim blnAnchor	'アンカーの要否
    Dim strURL		'URL文字列

    '通常表示モード以外であれば編集しない
    If lngPrint <> 0 Then
        Exit Sub
    End If

    '開始日のみ設定されている場合以外は編集しない
    If Not (dtmStrDate <> 0 And dtmEndDate = 0) Then
        Exit Sub
    End If
%>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#cccccc" ALIGN="right">
        <TR>
            <TD ALIGN="center"><SPAN STYLE="font-size:12px;color:#ffffff;font-weight:bolder;">この日の操作</SPAN></TD>
            <TD BGCOLOR="#ffffff">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
<%
                        '予約画面へのURL編集
                        strURL = "/webHains/contents/reserve/rsvMain.asp"
                        strURL = strURL & "?cyear="  & lngStrYear
                        strURL = strURL & "&cMonth=" & lngStrMonth
                        strURL = strURL & "&cDay="   & lngStrDay
%>
                        <TD><A HREF="<%= strURL %>" TARGET="_top"><IMG SRC="/webHains/images/rsv.gif" WIDTH="18" HEIGHT="18" ALT="新しく予約する"></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">新しく予約する</A></TD>
                        <TD><A HREF="javascript:showReceiptAll()"><IMG SRC="/webHains/images/receipt.gif" WIDTH="18" HEIGHT="18" ALT="当日ＩＤ発番処理"></A></TD>
                        <TD NOWRAP><A HREF="javascript:showReceiptAll()">当日ＩＤ発番</A></TD>
<%
                        '進捗画面へのURL編集
                        strURL = "/webHains/contents/common/progress.asp"
                        strURL = strURL & "?act="    & "select"
                        strURL = strURL & "&syear="  & lngStrYear
                        strURL = strURL & "&sMonth=" & lngStrMonth
                        strURL = strURL & "&sDay="   & lngStrDay
%>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="18" HEIGHT="18" ALT=""></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">進捗を見る</A></TD>
<%
                        'アンカーの編集
                        strURL = "/webHains/contents/maintenance/capacity/mntCapacityList.asp"
                        strURL = strURL & "?cslYear="  & lngStrYear
                        strURL = strURL & "&cslMonth=" & lngStrMonth
                        strURL = strURL & "&cslDay="   & lngStrDay
                        strURL = strURL & "&mode="     & "all"
%>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="18" HEIGHT="18" ALT=""></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">予約枠を見る</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : タイトル行の編集
'
' 引数　　 : (In)     strAddDiv   追加検査区分
' 　　　　   (In)     strAddName  追加検査名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditTitle()

    Dim strTitle	'タイトル
    Dim blnAnchor	'アンカーの要否

    'タイトル名の配列を作成
    strTitle = Array( _
                   "", _
                   "時間枠",         "当日ＩＤ",         "管理番号",       "コース",     "氏名",         _
                   "カナ氏名",       "性",               "生年月日",       "年齢",       "団体",         _
                   "予約番号",       "受診日",           "予約日",         "受診セット", "受付日",       _
                   "個人名称",       "個人ＩＤ",         "受診項目",       "部門送信",   "日数",         _
                   "従業員番号",     "受診時健保記号",   "受診時健保番号", "事業部",     "室部",         _
                   "所属",           "受診日確定",       "ＯＣＲ用受診日", "検体番号",   "問診票出力日", _
                   "胃カメラ受診日", "サブコース",       "健保記号",       "健保番号",   "結果入力状態", _
                   "予約状況",       "確認はがき出力日", "一式書式出力日", "予約群",     "お連れ様"      _
               )
%>
    <TR BGCOLOR="#cccccc">
<%
        For i = 0 To UBound(lngArrPrtField)

            'アンカー表示の要否を決定する
            Do
                blnAnchor = False

                '印刷用表示モードの場合はアンカー不用
                If lngPrint = 1 Then
                    Exit Do
                End If

                Select Case lngArrPrtField(i)
                    '追加検査・受付日・受診項目・部門送信・日数・検体番号・サブコース、その他未使用項目の場合はアンカー不用
                    Case 1, 3, 14, 15, 18, 19, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 40
                        Exit Do
                End Select

                blnAnchor = True
                Exit Do
            Loop

            'アンカーが必要な場合
            If blnAnchor Then

                'URLの編集
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?key="           & strKey
                strURL = strURL & "&strYear="       & lngStrYear
                strURL = strURL & "&strMonth="      & lngStrMonth
                strURL = strURL & "&strDay="        & lngStrDay
                strURL = strURL & "&endYear="       & lngEndYear
                strURL = strURL & "&endMonth="      & lngEndMonth
                strURL = strURL & "&endDay="        & lngEndDay
                strURL = strURL & "&csCd="          & strCsCd
                strURL = strURL & "&orgCd1="        & strOrgCd1
                strURL = strURL & "&orgCd2="        & strOrgCd2
                strURL = strURL & "&itemCd="        & strItemCd
                strURL = strURL & "&grpCd="         & strGrpCd
                strURL = strURL & "&prtField="      & strPrtField
                strURL = strURL & "&sortKey="       & lngArrPrtField(i)
                strURL = strURL & "&getCount="      & strGetCount
                strURL = strURL & "&navi="          & strNavi
                strURL = strURL & "&entry="         & strEntry
                strURL = strURL & "&rsvStat="       & strRsvStat
                strURL = strURL & "&rptStat="       & strRptStat

                'ソート順については、現在の編集列が指定表示列と同一な場合は現ソート順の反転指定を行い、さもなくば昇順とする
                strURL = strURL & "&sortType=" & IIf(lngArrPrtField(i) = lngSortKey, IIf(lngSortType = 0, 1, 0), 0)
%>
                <TD CLASS="<%= IIf(lngArrPrtField(i) = lngSortKey, "selectedcolor", "shadowcolor") %>" NOWRAP><A HREF="<%= strURL %>"><%= strTitle(lngArrPrtField(i)) %></A></TD>
<%
            'アンカーが不用な場合
            Else
%>
                <TD NOWRAP><%= strTitle(lngArrPrtField(i)) %></TD>
<%
            End If

        Next

        '通常表示モードの場合は操作用の列を編集する
        If lngPrint = 0 Then
%>
            <TD ALIGN="center" NOWRAP>操作</TD>
<%
        End If
%>
    </TR>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 追加検査の編集
'
' 引数　　 : (In)     strAddDiv   追加検査区分
' 　　　　   (In)     strAddName  追加検査名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditAddItem(strAddDiv, strAddName)

    Const COLS_PER_ROW = 3	'１行辺りの列数

    Dim strWorkAddDiv		'追加検査区分
    Dim strWorkAddName		'追加検査名
    Dim lngCount			'追加検査数

    Dim strMark				'追加検査区分を示すマーク
    Dim i, j				'インデックス

    '追加検査が存在しない場合は処理終了
    If strAddDiv = "" Then
        Exit Sub
    End If

    'カンマをセパレータとして配列に変換
    strWorkAddDiv  = Split(strAddDiv,  ",")
    strWorkAddName = Split(strAddName, ",")
    lngCount = UBound(strWorkAddDiv) + 1

    'TABLE編集を容易にするため、配列の要素数が１行辺りの行数の倍数になるように拡張する
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkAddDiv(lngCount)
        ReDim Preserve strWorkAddName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1

                    'マークの編集
                    Select Case strWorkAddDiv(i * COLS_PER_ROW + j)
                        Case "0"
                            strMark = "○"
                        Case "1"
                            strMark = "●"
                        Case "2"
                            strMark = "×"
                        Case Else
                            strMark = ""
                    End Select
%>
                    <TD><%= strMark %></TD>
                    <TD WIDTH="100" NOWRAP><%= strWorkAddName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診項目の編集
'
' 引数　　 : (In)     strRequestName  検査項目名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditConsultItem(strRequestName)

    Const COLS_PER_ROW = 4	'１行辺りの列数

    Dim strWorkRequestName	'検査項目名
    Dim lngCount			'受診項目数

    Dim i, j				'インデックス

    '受診項目が存在しない場合は処理終了
    If strRequestName = "" Then
        Exit Sub
    End If

    'カンマをセパレータとして配列に変換
    strWorkRequestName = Split(strRequestName, ",")
    lngCount = UBound(strWorkRequestName) + 1

    'TABLE編集を容易にするため、配列の要素数が１行辺りの行数の倍数になるように拡張する
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkRequestName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1
%>
                    <TD WIDTH="120" NOWRAP><%= strWorkRequestName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : サブコースの編集
'
' 引数　　 : (In)     strSubCsWebColor  webカラー
' 　　　　   (In)     strSubCsName      サブコース名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditSubCourse(strSubCsWebColor, strSubCsName)

    Const COLS_PER_ROW = 3		'１行辺りの列数

    Dim strWorkSubCsWebColor	'webカラー
    Dim strWorkSubCsName		'サブコース名
    Dim lngCount				'サブコース数

    Dim strWebColor				'webカラー
    Dim i, j					'インデックス

    'サブコースが存在しない場合は処理終了
    If strSubCsWebColor = "" Then
        Exit Sub
    End If

    'カンマをセパレータとして配列に変換
    strWorkSubCsWebColor = Split(strSubCsWebColor, ",")
    strWorkSubCsName     = Split(strSubCsName,     ",")
    lngCount = UBound(strWorkSubCsWebColor) + 1

    'TABLE編集を容易にするため、配列の要素数が１行辺りの行数の倍数になるように拡張する
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkSubCsWebColor(lngCount)
        ReDim Preserve strWorkSubCsName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1

                    'webカラーの編集
                    If strWorkSubCsWebColor(i * COLS_PER_ROW + j) <> "" Then
                        strWebColor = "<FONT COLOR=""" & strWorkSubCsWebColor(i * COLS_PER_ROW + j) & """>■</FONT>"
                    Else
                        strWebColor = ""
                    End If
%>
                    <TD><%= strWebColor %></TD>
                    <TD WIDTH="110" NOWRAP><%= strWorkSubCsName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診者一覧</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var winReceiptAll;	// 一括受付ウィンドウオブジェクト
var winReceipt;		// 受付ウィンドウオブジェクト

// ガイド画面呼び出し
function callOrgGuide() {

    orgGuide_showGuideOrg( document.dailysearch.orgCd1, document.dailysearch.orgCd2, null, 'orgname', null, null, null, null, '0' );

}

// 団体クリア
function clearOrgCd() {

    orgGuide_clearOrgInfo(document.dailysearch.orgCd1, document.dailysearch.orgCd2, 'orgname');

}

// 項目ガイド呼び出し
function callItmGuide() {

    // ガイドに引き渡すデータのセット
    itmGuide_mode     = 1;	// 依頼／結果モード　1:依頼、2:結果
    itmGuide_group    = 0;	// グループ表示有無　0:表示しない、1:表示する
    itmGuide_item     = 1;	// 検査項目表示有無　0:表示しない、1:表示する
    itmGuide_question = 1;	// 問診項目表示有無　0:表示しない、1:表示する

    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    itmGuide_CalledFunction = setItmInfo;

    // 項目ガイド表示
    showGuideItm();
}

// 検査項目のセット
function setItmInfo() {

    var itmNameElement;	// 検査項目名を編集するエレメントの名称
    var itmName;		// 検査項目名を編集するエレメント自身

    // 予め退避したインデックス先の検査項目情報に、ガイド画面で設定された連絡域の値を編集
    if ( itmGuide_dataDiv[0] == 'P' ) {
        document.dailysearch.itemCd.value = itmGuide_itemCd[0];
        document.dailysearch.grpCd.value  = '';
    } else {
        document.dailysearch.itemCd.value = '';
        document.dailysearch.grpCd.value  = itmGuide_itemCd[0];
    }

    // ブラウザごとの検査項目名編集用エレメントの設定処理
    for ( ; ; ) {

        // エレメント名の編集
        itmNameElement = 'itemname';

        // IEの場合
        if ( document.all ) {
            document.all(itmNameElement).innerHTML = itmGuide_itemName[0];
            break;
        }

        // Netscape6の場合
        if ( document.getElementById ) {
            document.getElementById(itmNameElement).innerHTML = itmGuide_itemName[0];
        }

        break;
    }
    return false;
}

// 検査項目コード・名称のクリア
function clearItemCd() {

    var itmNameElement;			/* 検査項目名を編集するエレメントの名称 */
    var itmName;				/* 検査項目名を編集するエレメント自身 */

    // hidden項目の再設定
    document.dailysearch.itemCd.value = '';
    document.dailysearch.grpCd.value  = '';

    // ブラウザごとの検査項目名編集用エレメントの設定処理
    for ( ; ; ) {

        // エレメント名の編集
        itmNameElement = 'itemname';

        // IEの場合
        if ( document.all ) {
            document.all(itmNameElement).innerHTML = '';
            break;
        }

        // Netscape6の場合
        if ( document.getElementById ) {
            document.getElementById(itmNameElement).innerHTML = '';
        }

        break;
    }

}

// 一括受付画面を表示
function showReceiptAll() {

    var opened = false;	// 画面が開かれているか
    var url;			// 一括受付画面のURL

    // すでにガイドが開かれているかチェック
    if ( winReceiptAll != null ) {
        if ( !winReceiptAll.closed ) {
            opened = true;
        }
    }

    // 一括受付画面のURL編集
    url = '/webHains/contents/receipt/rptAllEntry.asp';
    url = url + '?cYear='  + '<%= lngStrYear  %>';
    url = url + '&cMonth=' + '<%= lngStrMonth %>';
    url = url + '&cDay='   + '<%= lngStrDay   %>';

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winReceiptAll.focus();
    } else {
        winReceiptAll = window.open(url, '', 'toolbar=no,directories=no,menubar=no,resizable=yes,status=yes,scrollbars=yes,width=500,height=400');
    }

}

// 受付画面を表示
function showReceipt( rsvNo, cslYear, cslMonth, cslDay ) {

    var opened = false;	// 画面が開かれているか
    var url;			// 受付画面のURL

    // すでにガイドが開かれているかチェック
    if ( winReceipt != null ) {
        if ( !winReceipt.closed ) {
            opened = true;
        }
    }

    // 受付画面のURL編集
    url = '/webHains/contents/receipt/rptEntry.asp';
    url = url + '?rsvNo=' + rsvNo;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winReceipt.focus();
        winReceipt.location.replace( url );
    } else {
        winReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// 子ウィンドウを閉じる
function closeWindow() {

    // 日付ガイドを閉じる
    calGuide_closeGuideCalendar();

    // 団体検索ガイドを閉じる
    orgGuide_closeGuideOrg();

    // 項目ガイドを閉じる
    closeGuideItm();

    // 一括受付画面を閉じる
    if ( winReceiptAll != null ) {
        if ( !winReceiptAll.closed ) {
            winReceiptAll.close();
        }
    }

    // 受付画面を閉じる
    if ( winReceipt != null ) {
        if ( !winReceipt.closed ) {
            winReceipt.close();
        }
    }

    winReceiptAll = null;
    winReceipt    = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<% '印刷モードの場合TABLEタグのFONTSIZEをしばる
   If lngPrint = 1 Then
%>
	TABLE { font-size:9px; }
<% End If %>

<% If strNavi <> "" Then %>
<% Else %>
	body { margin: 12px 0 0 5px; }
<% End If %>
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<% If strNavi <> "" Then %>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<% End If %>
<FORM NAME="dailysearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<%
    If strNavi <> "" Then
        Response.Write "<BLOCKQUOTE>"
    End If
%>
    <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= strItemCd %>">
    <INPUT TYPE="hidden" NAME="grpCd"  VALUE="<%= strGrpCd  %>">
    <INPUT TYPE="hidden" NAME="navi"   VALUE="<%= strNavi   %>">

    <!-- 表題 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="850">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">受診者一覧</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="8"></TD>
        </TR>
    </TABLE>

    <SPAN STYLE="font-size:<%= IIf(lngPrint = 0, "12", "9") %>px;">
<%
    '検索条件・件数情報の編集

    '検索キーの編集
    If strKey <> "" Then
%>
        「<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>」
<%
    End If

    '受診日条件の編集
    Do

        '双方とも未指定の場合は編集しない
        If dtmStrDate = 0 And dtmEndDate = 0 Then
            Exit Do
        End If

        '一方が未指定の場合はもう一方の値のみ編集する
        If dtmStrDate = 0 Or dtmEndDate = 0 Then
            strDispDate = objCommon.FormatString(dtmStrDate + dtmEndDate, "yyyy年m月d日")
            Exit Do
        End If

        '双方の値が同値ならば一方の値のみ編集する
        If dtmStrDate = dtmEndDate Then
            strDispDate = objCommon.FormatString(dtmStrDate, "yyyy年m月d日")
            Exit Do
        End If

        '双方の値が異なれば時は期間形式で編集
        strDispDate = objCommon.FormatString(dtmStrDate, "yyyy年m月d日") & "～" & objCommon.FormatString(dtmEndDate, "yyyy年m月d日")
        Exit Do
    Loop

    If strDispDate <> "" Then
%>
        「<FONT COLOR="#ff6600"><B><%= strDispDate %></B></FONT>」
<%
    End If

    If strKey <> "" Or strDispDate <> "" Then
%>
        の受診者一覧を表示しています。検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件です。
<%
    End If
%>
    </SPAN>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="8"></TD>
        </TR>
    </TABLE>
<%
    '条件入力エレメントの編集
    Call EditEntryCondition()

    '条件値の編集
    Call EditCondition()

    Do
        'メッセージが発生している場合は編集して処理終了
        If strMessage <> "" Then
%>
            <BR>&nbsp;<%= strMessage %>
<%
            Exit Do
        End If

        '通常表示モードの場合
        If lngPrint = 0 Then

            'URLの編集
            strURL = Request.ServerVariables("SCRIPT_NAME")
            strURL = strURL & "?key="           & strKey
            strURL = strURL & "&strYear="       & lngStrYear
            strURL = strURL & "&strMonth="      & lngStrMonth
            strURL = strURL & "&strDay="        & lngStrDay
            strURL = strURL & "&endYear="       & lngEndYear
            strURL = strURL & "&endMonth="      & lngEndMonth
            strURL = strURL & "&endDay="        & lngEndDay
            strURL = strURL & "&csCd="          & strCsCd
            strURL = strURL & "&orgCd1="        & strOrgCd1
            strURL = strURL & "&orgCd2="        & strOrgCd2
            strURL = strURL & "&itemCd="        & strItemCd
            strURL = strURL & "&grpCd="         & strGrpCd
            strURL = strURL & "&prtField="      & strPrtField
            strURL = strURL & "&sortKey="       & lngSortKey
            strURL = strURL & "&sortType="      & lngSortType
            strURL = strURL & "&print="         & "1"
            strURL = strURL & "&startPos="      & lngStartPos
            strURL = strURL & "&getCount="      & strGetCount
            strURL = strURL & "&entry="         & strEntry
            strURL = strURL & "&rsvStat="       & strRsvStat
            strURL = strURL & "&rptStat="       & strRptStat
%>
            &nbsp;<A HREF="<%= strURL %>" TARGET="_top">印刷用に表示</A>
<%
        End If
%>
        <TABLE BORDER="0" CELLSPACING="<%= IIf(lngPrint = 0, "2", "1") %>" CELLPADDING="1">
<%
            'タイトル行の編集
            Call EditTitle()

            For i = 0 To UBound(strArrRsvNo)
%>
                <TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" VALIGN="top">
<%
                    '各表示列ごとの編集
                    For j = 0 To UBound(lngArrPrtField)

                        '受診時年齢のみ右寄せ
                        Response.Write "<TD NOWRAP" & IIf(lngArrPrtField(j) = 9, " ALIGN=""right""", "") & ">"

                        Select Case lngArrPrtField(j)

                            Case 1	'時間枠

                            Case 2	'当日ＩＤ
                                Response.Write strArrDayId(i)

                            Case 3	'管理番号

                            Case 4	'コース
                                If strArrCsName(i) <> "" Then
                                    Response.Write "<FONT COLOR=""#" & strArrWebColor(i) & """>■</FONT>" & strArrCsName(i)
                                End If

                            Case 5	'氏名
                                Response.Write strArrName(i)

                            Case 6	'カナ氏名
                                Response.Write "（" & strArrKanaName(i) & "）"

                            Case 7	'性別
                                Response.Write IIf(strArrGender(i) = "1", "男", "女")

                            Case 8	'生年月日
                                Response.Write objCommon.FormatString(strArrBirth(i), "gee.mm.dd")

                            Case 9	'受診時年齢
                                If strArrAge(i) <> "" Then
                                    Response.Write Int(strArrAge(i)) & "歳"
                                End If

                            Case 10	'団体略称
                                Response.Write strArrOrgSName(i)

                            Case 11	'予約番号
                                Response.Write strArrRsvNo(i)

                            Case 12	'受診日
                                Response.Write strArrCslDate(i)

                            Case 13	'予約日
                                Response.Write strArrRsvDate(i)

                            Case 14	'追加検査
                                Call EditAddItem(strArrAddDiv(i), strArrAddName(i))

                            Case 15	'受付日(未使用)

                            Case 16	'個人氏名
                                Response.Write "<SPAN STYLE=""font-size:9px;"">" & strArrKanaName(i) & "<BR></SPAN>" & strArrName(i)

                            Case 17	'個人ＩＤ
                                Response.Write strArrPerId(i)

                            Case 18	'受診項目
                                Call EditConsultItem(strArrRequestName(i))

                            Case 19	'部門送信(未使用)

                            Case 20	'受診日からの相対日(未使用)

                            Case 21	'従業員番号

                            Case 22	'健保記号
                                Response.Write strArrIsrSign(i)

                            Case 23	'健保番号
                                Response.Write strArrIsrNo(i)

                            Case 24	'事業部名称

                            Case 25	'室部名称

                            Case 26	'所属名称

                            Case 27	'受診日確定フラグ

                            Case 28	'ＯＣＲ用受診日

                            Case 29	'検体番号

                            Case 30	'問診票出力日

                            Case 31	'胃カメラ受診日

                            Case 32	'サブコース
                                Call EditSubCourse(strArrSubCsWebColor(i), strArrSubCsName(i))

                            Case 33	'個人情報の健保記号

                            Case 34	'個人情報の健保番号

                            Case 35	'結果入力状態
                                Response.Write IIf(strArrEntry(i) = "0", "全て入力", IIf(strArrEntry(i) = "1", "未入力あり", ""))

                            Case 36	'予約状況
                                If strArrRsvStatus(i) <> "" Then
                                    '#### 2007/04/04 張 予約状況区分追加によって修正 Start ####
                                    'Response.Write IIf(strArrRsvStatus(i) = "0", "確定", "保留")
                                    Response.Write IIf(strArrRsvStatus(i) = "0", "確定", IIf(strArrRsvStatus(i) = "1", "保留","未確定"))
                                    '#### 2007/04/04 張 予約状況区分追加によって修正 End   ####
                                End If

                            Case 37	'確認はがき出力日
                                Response.Write strArrCardPrintDate(i)

                            Case 38	'一式書式出力日
                                Response.Write strArrFormPrintDate(i)

                            Case 39	'予約群名称
                                Response.Write strArrRsvGrpName(i)

                            Case 40	'お連れ様有無
                                Response.Write IIf(CLng(strArrHasFriends(i)) > 0, "あり", "")

                        End Select

                    Next

                    '通常表示モードの場合は操作用の列を編集する
                    If lngPrint = 0 Then

                        If strArrRsvNo(i) <> "" Then
%>
                            <TD VALIGN="middle"><% EditButtonCol CLng(strArrRsvNo(i)), CLng(strArrCancelFlg(i)), CDate(strArrCslDate(i)), strArrPerId(i), strArrDayId(i), CDate(strArrCslDate(i)) %></TD>
<%
                        Else
%>
                            <TD></TD>
<%
                        End If

                    End If
%>
                </TR>
<%
            Next
%>
        </TABLE>
<%
        '通常表示モードの場合は処理終了
        If lngPrint <> 0 Then
            Exit Do
        End If

        '全件検索時はページングナビゲータ不要
        If Not IsNumeric(strGetCount) Then
            Exit Do
        End If

        'URLの編集
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?key="      & strKey
        strURL = strURL & "&strYear="  & lngStrYear
        strURL = strURL & "&strMonth=" & lngStrMonth
        strURL = strURL & "&strDay="   & lngStrDay
        strURL = strURL & "&endYear="  & lngEndYear
        strURL = strURL & "&endMonth=" & lngEndMonth
        strURL = strURL & "&endDay="   & lngEndDay
        strURL = strURL & "&csCd="     & strCsCd
        strURL = strURL & "&orgCd1="   & strOrgCd1
        strURL = strURL & "&orgCd2="   & strOrgCd2
        strURL = strURL & "&itemCd="   & strItemCd
        strURL = strURL & "&grpCd="    & strGrpCd
        strURL = strURL & "&prtField=" & strPrtField
        strURL = strURL & "&sortKey="  & lngSortKey
        strURL = strURL & "&sortType=" & lngSortType
        strURL = strURL & "&navi="     & strNavi
        strURL = strURL & "&entry="    & strEntry
        strURL = strURL & "&rsvStat="  & strRsvStat
        strURL = strURL & "&rptStat="  & strRptStat

'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
        strURL = strURL & "&cslDivCd="  & strCslDivCd
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

        'ページングナビゲータの編集
%>
        <%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
        Exit Do
    Loop

    If strNavi <> "" Then
        Response.Write "</BLOCKQUOTE>"
    End If
%>
</FORM>
<script type="text/javascript">
document.dailysearch.onsubmit = function()
{
	document.body.style.cursor = 'wait';
};

window.onload = function()
{
	document.body.style.cursor = 'auto';

	var targetFrame = top.frames['Calendar'];
	if ( targetFrame ) {
		targetFrame.document.body.style.cursor = 'auto';
	}
	
	
};
</script>
</BODY>
</HTML>
