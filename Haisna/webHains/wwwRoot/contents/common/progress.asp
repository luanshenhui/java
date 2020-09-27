<%@ LANGUAGE="VBScript" %>
<%
'########################################
'管理番号：SL-HS-Y0101-004
'修正日  ：2010.09.15
'担当者  ：FJTH)KOMURO
'修正内容：連携ツールエラー情報　文言変更
'########################################
'-----------------------------------------------------------------------------
'        受診進捗状況 (Ver0.0.1)
'        AUTHER  : Sogawa Satomi@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objConsult              '受診情報アクセス用
Dim objCourse               'コース情報アクセス用
Dim objJudgement            '判定情報アクセス用
Dim objProgress             '進捗情報アクセス用
Dim objSchedule             'スケジュール情報アクセス用

'前画面から送信されるパラメータ値
Dim strActMode              '動作モード
Dim lngCslYear              '受診日(年)
Dim lngCslMonth             '受診日(月)
Dim lngCslDay               '受診日(日)
Dim strKeyCsCd              'コース
Dim strMode                 '表示モード
Dim strRsvNo                '予約番号
Dim lngStartPos             '検索開始位置
Dim strRsvGrpCd             '予約群コード

'表示モード
Dim vntArrCd(1)             '表示モード
Dim vntArrName(1)           '表示モードの名称

'進捗管理分類情報
Dim strProgressCd           '進捗分類コード
Dim strProgressSName        '進捗分類略称
Dim lngProgressCount        '進捗分類数

'受診情報
Dim strArrRsvNo             '予約番号
Dim strArrCancelFlg         'キャンセルフラグ
Dim strArrCslDate           '受診日
Dim strArrPerId             '個人ＩＤ
Dim strArrDayId             '当日ＩＤ
Dim strArrWebColor          'webカラー
Dim strArrCsCd              'コースコード
Dim strArrCsName            'コース名
Dim strArrLastName          '姓
Dim strArrFirstName         '名
Dim strArrGender            '性別
Dim strArrBirth             '生年月日
Dim strArrAge               '年齢
Dim strArrEntriedJud        '判定入力状態
Dim strArrEntriedJudManual  '判定入力状態(手動）
Dim strArrRsvGrpName        '予約群名称
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
Dim strArrMensetsuState     '自動判定処理実施有無（処理済み：可能、未処理：不可能）
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

Dim lngCount                'レコード件数

'進捗状況
Dim strRslProgressCd        '進捗分類コード
Dim strRslStatus            '入力状態("2":入力完了、"1":未入力、"0":依頼なし)
Dim lngRslProgressCount     'レコード件数

Dim dtmCslDate              '受診日
Dim lngGetCount             '取得件数
Dim strPageMaxLIne          '１ページ表示行数
Dim strMessage              'エラーメッセージ
Dim strMessage2             'エラーメッセージ
Dim lngFoundIndex           '検索されたインデックス
Dim strURL                  'URL文字列
Dim Ret                     '関数戻り値
Dim i, j, k                 'インデックス

'予約群情報
Dim strAllRsvGrpCd          '予約群コード
Dim strAllRsvGrpName        '予約群名称
Dim lngRsvGrpCount          '予約群数

Dim strWkRsvGrpCd           '予約群コード

'### 2004/06/04 Added by Ishihara@FSIT 判定進捗管理に完全未入力モード追加
'判定進捗管理マーク
Dim strJudgementMark
Dim strJudgementMarkManual
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
Dim strMensetsuStateColor   '自動判定処理実施有無色指定（処理済み：可能、未処理：不可能）
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objCourse   = Server.CreateObject("HainsCourse.Course")
Set objProgress = Server.CreateObject("HainsProgress.Progress")

'引数値の取得
strActMode  = Request("actMode")
lngCslYear  = CLng("0" & Request("syear"))
lngCslMonth = CLng("0" & Request("smonth"))
lngCslDay   = CLng("0" & Request("sday"))
strKeyCsCd  = Request("course")
strMode     = Request("mode")
strRsvNo    = Request("rsvNo")
lngStartPos = CLng("0" & Request("startPos"))
strRsvGrpCd = Request("rsvGrpCd")

'検索開始位置未指定時は先頭から検索する
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)

'表示形式を配列にセット
vntArrCd(0)   = "1"
vntArrCd(1)   = "2"
vntArrName(0) = "未検査が存在する受診者のみ"
vntArrName(1) = "全て完了している受診者のみ"

'受診日の初期値設定
If lngCslYear = 0 and lngCslMonth = 0  and lngCslDay = 0 Then
    lngCslYear  = Year(Now)
    lngCslMonth = Month(Now)
    lngCslDay   = Day(Now)
End If

'受診進捗状況表示行数（デフォルト値）を取得
strPageMaxLine = objCommon.SelectProgressPageMaxLine

'オブジェクトのインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'すべての予約群を読み込む
lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strAllRsvGrpCd, strAllRsvGrpName)

Set objSchedule = Nothing

'チェック・更新・読み込み処理の制御
Do

    '動作モード未指定時は何もしない
    If strActMode = "" Then
        Exit Do
    End If

    '予約番号が入力された場合、他の条件は使用しない
    If strRsvNo <> "" Then

        '数値チェック
        strMessage2 = objCommon.CheckNumeric("予約番号", strRsvNo, LENGTH_CONSULT_RSVNO)
        If strMessage2 <> "" Then
            strMessage = strMessage2
            Exit Do
        End If

        '先頭部のゼロを取り除く
        strRsvNo = CStr(CLng(strRsvNo))

        '受診情報読み込み
        Ret = objConsult.SelectConsult( _
                  strRsvNo, _
                  strArrCancelFlg, strArrCslDate, strArrPerId, _
                  strArrCsCd, strArrCsName , , , , , , _
                  strArrAge , , , , , , , , , , , , , _
                  strArrDayId, , , , , , , , , , , , , , , , , , _
                  strArrLastName, strArrFirstName, , , _
                  strArrBirth, strArrGender, , , , , , strWkRsvGrpCd _
              )

        '受診情報が存在しない場合
        If Ret = False Then
            strMessage = "指定された予約番号の受診情報は存在しません。"
            Exit Do
        End If

        For i = 0 To lngRsvGrpCount - 1
            If strAllRsvGrpCd(i) = strWkRsvGrpCd Then
                strArrRsvGrpName = strAllRsvGrpName(i)
                Exit For
            End If
        Next

        strMessage2 = "氏名=" & Trim(strArrLastName & "　" & strArrFirstName) & "（" & strArrPerId & "）、コース=" & strArrCsName & "（" & strArrCsCd & "）"

        'キャンセルされている場合
        If CLng(strArrCancelFlg) <> CONSULT_USED Then
            strMessage = "指定された予約番号の受診情報はキャンセルされています。 " & strMessage2
            Exit Do
        End If

        '未受付の場合
        If strArrDayId = "" Then
            strMessage = "指定された予約番号の受診情報は受付されていません。 " & strMessage2
            Exit Do
        End If

        'コーステーブルからwebカラーを取得
        objCourse.SelectCourse strArrCsCd, , , , , , strArrWebColor

        '判定入力状態を取得
        Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")

        '### 手動判定項目と自動判定項目を分けて表示するため修正 STR ##############
        'objJudgement.SelectJudgementStatus strRsvNo, strArrEntriedJud
        objJudgement.SelectJudgementStatusAuto strRsvNo, strArrEntriedJud
        objJudgement.SelectJudgementStatusManual strRsvNo, strArrEntriedJudManual
        '### 手動判定項目と自動判定項目を分けて表示するため修正 END ##############

        '受診日の編集
        dtmCslDate = CDate(strArrCslDate)

        '受診日指定と共通の編集ロジックを使用するため、あらかじめ配列に変換
        strArrRsvNo      = Array(strRsvNo)
        strArrDayId      = Array(strArrDayId)
        strArrWebColor   = Array(strArrWebColor)
        strArrCsName     = Array(strArrCsName)
        strArrRsvGrpName = Array(strArrRsvGrpName)
        strArrLastName   = Array(strArrLastName)
        strArrFirstName  = Array(strArrFirstName)
        strArrGender     = Array(strArrGender)
        strArrBirth      = Array(strArrBirth)
        strArrAge        = Array(strArrAge)
        strArrEntriedJud = Array(strArrEntriedJud)
        strArrEntriedJudManual = Array(strArrEntriedJudManual)
        strArrMensetsuState = Array(strArrMensetsuState)

    '予約番号未入力時は受診日指定
    Else

        '日付チェック
        If Not IsDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay) Then
            strMessage = "受診日の入力形式が正しくありません。"
            Exit Do
        End If

    End If

    '全ての進捗分類情報を取得する
    lngProgressCount = objProgress.SelectProgressList(strProgressCd, , strProgressSName)
    If lngProgressCount <= 0 Then
        strMessage = "進捗分類情報が存在しません。"
    End If

    Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診進捗状況</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style>
table.progresstb td {
    border-bottom: 1px solid #ccc;
    padding: 2px 3px 2px;
    border-right: 1px solid #fff;
}

p.progress-cap {
    margin: 2px 0 4px 2px;
    font-size: 12px;
    color: #666;
}
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="actMode" VALUE="select">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">受診進捗状況</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'エラーメッセージの編集
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD>受診日</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('syear', 'smonth', 'sday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("syear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("smonth", 1, 12, lngCslMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("sday", 1, 31, lngCslDay, False) %></TD>
                        <TD>日</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>コース</TD>
            <TD>：</TD>
            <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "course", strKeyCsCd, SELECTED_ALL, False) %></TD>
            <TD NOWRAP>表示形式</TD>
            <TD>：</TD>
            <TD><%= EditDropDownListFromArray("mode", vntArrCd, vntArrName, strMode, SELECTED_ALL) %></TD>
        </TR>
        <TR>
            <TD NOWRAP>予約群</TD>
            <TD>：</TD>
            <TD><%= EditDropDownListFromArray("rsvGrpCd", strAllRsvGrpCd, strAllRsvGrpName, strRsvGrpCd, SELECTED_ALL) %></TD>
            <TD NOWRAP>予約番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="rsvNo" SIZE="11" MAXLENGTH="<%= LENGTH_CONSULT_RSVNO %>" VALUE="<%= strRsvNo %>"></TD>
            <TD ROWSPAN="5" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
        </TR>
    </TABLE>

    <BR>
<%
    '受診者一覧の編集
    Do
        '動作モード未指定時は何もしない
        If strActMode = "" Then
            Exit Do
        End If

        'エラー時は何もしない
        If strMessage <> "" Then
            Exit Do
        End If

        '予約番号が入力されていない場合
        If strRsvNo = "" Then

            '受診日の設定
            dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

            '取得件数の設定
            lngGetCount = 0
            If IsNumeric(strPageMaxLine) Then
                lngGetCount = CLng(strPageMaxLine)
            End If

            '検索条件を満たすレコード件数を取得
            'lngCount = objConsult.SelectConsultList(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, , , strRsvGrpCd, strArrRsvGrpName)
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
'            lngCount = objConsult.SelectConsultListProgress(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, strArrEntriedJudManual, , , strRsvGrpCd, strArrRsvGrpName)
            lngCount = objConsult.SelectConsultListProgress(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, strArrEntriedJudManual, , , strRsvGrpCd, strArrRsvGrpName, strArrMensetsuState)
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

%>
            「<FONT COLOR="#ff6600"><B><%= lngCslYear %>年<%= lngCslMonth %>月<%= lngCslDay %>日</B></FONT>」の受診者一覧を表示しています。<BR>
            受診者数は <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>人です。<BR><BR>
<%
        End If

        '## 2005.3.24 ADD ST FJTH)C.M

        Dim objErrLog           'エラーログ情報アクセス用
        Dim lngErrLog           'エラーログステータス
        Dim vntFileName         'エラーログファイル名
        Dim vntErrDate          'エラーログ更新日時
        
        '連携エラーログ情報を取得
        Set objErrLog = Server.CreateObject("HainsErrLog.ErrLog")
        lngErrLog = objErrLog.SelectErrLog( vntFileName, vntErrDate )

        If lngErrLog = -3 Then
            strMessage = "汎用マスタ設定確認。ERRFILE情報がありません！"
        End If

        If lngErrLog = -2 Then
            strMessage = "共有フォルダが見つかりません！"
        End If
        
        'エラーメッセージの編集
        Call EditMessage(strMessage, MESSAGETYPE_WARNING)
        
        If lngErrLog = 1 Then
            If vntFileName <> "" Then
%>
                <table width="600" border="0" cellspacing="2" cellpadding="0">
<%
                    With Response
                        .Write "<tr>"
                        .Write "<td><IMG SRC=/webHains/images/ico_w.gif WIDTH=16 HEIGHT=16 ALT=></td>"
'#### 2010.09.15 SL-HS-Y0101-004 MOD START ####
'                        .Write "<td><font color=red><b>エラーが発生しています！(RayPax連携) システム担当へ連絡して下さい。</b></font></td>"
                        .Write "<td><font color=red><b>エラーが発生しています！(横河連携) システム担当へ連絡して下さい。</b></font></td>"
'#### 2010.09.15 SL-HS-Y0101-004 MOD END ####
                        .Write "<td>最終更新日時：" & vntErrDate & "</td>"
                        .Write "</tr>"
                    End With
%>
                </table>
                <BR>
<%
            End If
        End If

        '## 2005.3.24 ADD ED

        '### 2013/11/21 Added by ishihara@flip-logic.com 連携ログ監視用ファイルを検知した場合、警告メッセージを出す
        lngErrLog = ""
        strMessage = ""

        lngErrLog = objErrLog.SelectErrLog( vntFileName, vntErrDate, "ERRFILE2" )
        Response.Write "<!-- SendOrder.log監視File Status=" & lngErrLog & " vntFileName=" & vntFileName & "-->"

        If lngErrLog = 1 And vntFileName <> "" Then
            lngErrLog = -9
        End iF
        Select Case lngErrLog
            Case -2
            strMessage = "SendOrder.logの共有フォルダが見つかりません"
            Case -9
            'strMessage = "連携サーバのCOM+をリフレッシュしてください。" 
            strMessage = "連携サーバCOM+のリフレッシュが必要ですのでシステム担当へ連絡して下さい。"
        End Select

        If strMessage <> "" Then
            'エラーメッセージの編集
            Call EditMessage(strMessage, MESSAGETYPE_WARNING)
        End If
        '### 2013/11/21 Added End


        '対象データが存在しない場合は編集を抜ける
        If IsEmpty(strArrRsvNo) Then
            Exit Do
        End If
%>
<p class="progress-cap">○：検査完了&nbsp;&nbsp;●：一部未入力あり&nbsp;&nbsp;▲：未検査&nbsp;&nbsp;空白：依頼なし <FONT COLOR="#999999">（受診進捗欄をクリックすると対象受診歴の結果入力画面にジャンプします）</p>
<p class="progress-cap"><IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="自動判定処理実施">&nbsp;：&nbsp;自動判定処理による判定結果登録あり（自動判定処理実施済み）</p>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="progresstb">
            <TR BGCOLOR="#cccccc">
                <!--リストに当日ID、氏名、性別、年齢だけを表示するように変更-->
                <!--TD NOWRAP>受診日</TD-->
                <TD NOWRAP>当日ＩＤ</TD>
                <!--TD NOWRAP>受診コース</TD-->
                <!--TD NOWRAP>予約群</TD-->
                <TD NOWRAP>氏名</TD>
                <TD NOWRAP>性別</TD>
                <!--TD NOWRAP>生年月日</TD-->
                <TD NOWRAP>年齢</TD>
                <TD WIDTH="22" ALIGN="center">手判</TD>
                <TD WIDTH="22" ALIGN="center">判定</TD>
                <TD WIDTH="22" ALIGN="center" colspan="2">自判</TD>
                <TD WIDTH="22" ALIGN="center">結果</TD>
<%
                '進捗分類情報の編集
                For i = 0 To lngProgressCount - 1
%>
                    <TD WIDTH="22" ALIGN="center"><%= strProgressSName(i) %></TD>
<%
                Next
%>
            </TR>
<%
            For i = 0 To UBound(strArrRsvNo)
%>
<!--                <tr onmouseover=this.style.backgroundColor='E8EEFC'; onmouseout=this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>' BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">-->
                <tr onmouseover=this.style.backgroundColor='E8EEFC'; onmouseout=this.style.backgroundColor='#FFFFFF'>
                    <!--リストに当日ID、氏名、性別、年齢だけを表示するように変更-->
                    <!--TD NOWRAP><%'= dtmCslDate %></TD-->
                    <TD NOWRAP><%= objCommon.FormatString(strArrDayId(i), "0000") %></TD>
                    <!--TD NOWRAP><FONT COLOR="#<%'= strArrWebColor(i) %>">■</FONT><%'= strArrCsName(i) %></TD-->
                    <!--TD NOWRAP><%'= strArrRsvGrpName(i) %></TD-->
                    <TD NOWRAP><%= Trim(strArrLastName(i) & "　" & strArrFirstName(i)) %></TD>
                    <TD NOWRAP><%= IIf(strArrGender(i) ="1", "男性", "女性") %></TD>
                    <!--TD NOWRAP><%'= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD-->
                    <TD ALIGN="right" NOWRAP><%= Int(strArrAge(i)) %>歳</TD>
<%
'                    '判定入力画面へのURL編集
'                    strURL = "/webHains/contents/judgement/judMain.asp"
'                    strURL = strURL & "?cslYear="  & Year(dtmCslDate)
'                    strURL = strURL & "&cslMonth=" & Month(dtmCslDate)
'                    strURL = strURL & "&cslDay="   & Day(dtmCslDate)
'                    strURL = strURL & "&dayId="    & strArrDayId(i)
'                    strURL = strURL & "&noPrevNext=1"
                    strURL = "/webHains/contents/interview/interviewTop.asp?rsvNo=" & strArrRsvNo(i)

'### 2004/06/04 Added by Ishihara@FSIT 判定進捗管理に完全未入力モード追加
                strJudgementMark = ""
                Select Case Trim(strArrEntriedJud(i))
                    Case "0"
                        strJudgementMark = "○"
                    Case "1"
                        strJudgementMark = "●"
                    Case "2"
                        strJudgementMark = ""
                    Case "3"
                        strJudgementMark = "▲"
                    Case Else
                        strJudgementMark = strArrEntriedJud(i)
                End Select
'### 2004/06/04 Added End

'### 2004/06/04 Added by Ishihara@FSIT 判定進捗管理に完全未入力モード追加
                strJudgementMarkManual = ""
                Select Case Trim(strArrEntriedJudManual(i))
                    Case "0"
                        strJudgementMarkManual = "○"
                    Case "1"
                        strJudgementMarkManual = "●"
                    Case "2"
                        strJudgementMarkManual = ""
                    Case "3"
                        strJudgementMarkManual = "▲"
                    Case Else
                        strJudgementMarkManual = strArrEntriedJudManual(i)
                End Select
'### 2004/06/04 Added End

'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
'Dim strMensetsuStateColor   '自動判定処理実施有無色指定（処理済み：可能、未処理：不可能）
                Select Case Trim(strArrMensetsuState(i))
                    Case "可能"
                        strMensetsuStateColor = "#ff6600"
                    Case Else
                        strMensetsuStateColor = ""
                End Select
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
%>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><%= strJudgementMarkManual %></A></TD>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="判定入力"></A></TD>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><%= strJudgementMark %></A></TD>
<%'## 2016.08.12 張 自動判定処理実施有無追加 STR ##%>
                    <TD ALIGN="center">
<%              If Trim(strArrMensetsuState(i)) = "可能" Then    %>
                        <IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="自動判定処理実施">
<%              End If  %>
                    </TD>
<%'## 2016.08.12 張 自動判定処理実施有無追加 END ##%>
                    <TD ALIGN="center"><A HREF="/webHains/contents/result/rslMain.asp?rsvNo=<%= strArrRsvNo(i) %>&cslYear=<%= DatePart("yyyy", dtmCslDate) %>&cslMonth=<%= DatePart("m", dtmCslDate) %>&cslDay=<%= DatePart("d", dtmCslDate) %>&dayId=<%= strArrDayId(i) %>&noPrevNext=1"><IMG SRC="/webHains/images/result.gif" WIDTH="20" HEIGHT="20" ALT="結果入力"></A></TD>
<%
                    '現受診情報の進捗状況を読み込む
                    lngRslProgressCount = objProgress.SelectProgressRsl(strArrRsvNo(i), strRslProgressCd, strRslStatus)

                    '進捗分類情報の編集
                    For j = 0 To lngProgressCount - 1

                        lngFoundIndex = -1

                        '現受診情報の進捗状況を検索
                        For k = 0 To lngRslProgressCount - 1
                            If strRslProgressCd(k) = strProgressCd(j) Then
                                lngFoundIndex = k
                                Exit For
                            End If
                        Next

                        '検索された場合
                        If lngFoundIndex >= 0 Then

                            '結果入力画面のURL編集
                            strURL = "/webHains/contents/result/rslMain.asp"
                            strURL = strURL & "?rsvNo="      & strArrRsvNo(i)
                            strURL = strURL & "&mode="       & "2"
                            strURL = strURL & "&code="       & strProgressCd(j)
                            strURL = strURL & "&cslYear="    & Year(dtmCslDate)
                            strURL = strURL & "&cslMonth="   & Month(dtmCslDate)
                            strURL = strURL & "&cslDay="     & Day(dtmCslDate)
                            strURL = strURL & "&dayId="      & strArrDayId(i)
                            strURL = strURL & "&noPrevNext=" & "1"
%>
                            <TD ALIGN="center"><A HREF="<%= strURL %>"><%= IIf(strRslStatus(lngFoundIndex) = "2", "○", IIf(strRslStatus(lngFoundIndex) = "3", "●", "▲")) %></A></TD>
<%
                        '検索されなかった場合は依頼なしとする
                        Else
%>
                            <TD ALIGN="center">&nbsp;</TD>
<%
                        End If

                    Next
%>
                </TR>
<%
            Next
%>
        </TABLE>
<%
        '取得件数未指定時はページングナビゲータ不用
        If lngGetCount = 0 Then
            Exit Do
        End If

        'URL文字列の編集
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?actMode=" & "select"
        strURL = strURL & "&syear="   & lngCslYear
        strURL = strURL & "&smonth="  & lngCslMonth
        strURL = strURL & "&sday="    & lngCslDay
        strURL = strURL & "&course="  & strKeyCsCd
        strURL = strURL & "&mode="    & strMode
'### 2004/06/11 Added by Ishihara@FSIT 予約群の指定がページングナビ時に消える
        strURL = strURL & "&rsvGrpCd="  & strRsvGrpCd

        'ページングナビゲータの編集
        Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

        Exit Do
    Loop
%>
    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
