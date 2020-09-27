<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      依頼状発送確認(2010.1.5) 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objReqSendCheck     '依頼状作成クラス
Dim objFree             '汎用情報アクセス用
Dim objConsult          '受診情報
Dim objJudClass         '判定分類アクセス用

'パラメータ
Dim strAction           '処理状態
Dim lngRequestNo        '依頼状コード番号

Dim blnCslInfoFlg       '受診情報表示フラグ(True:表示)
Dim strHtml             'HTML文字列
Dim Ret                 '関数戻り値
Dim strArrMessage       'エラーメッセージ

Dim lngCount            '戻り値
Dim i                   'ｲﾝﾃﾞｯｸｽ

'既に発送確認済みの場合、全ての発送情報を取得
Dim vntSeq              '依頼状番号配列
Dim vntJudClassName     '依頼状ファイル名配列
Dim vntFileName         '依頼状ファイル名配列
Dim vntAddDate          '依頼状登録日時配列
Dim vntAddUser          '依頼状登録者配列
Dim vntReqSendDate      '依頼状発送日配列
Dim vntReqSendUser      '依頼状発送者配列

'受診情報用変数
Dim strPerId            '個人ID
Dim strCslDate          '受診日
Dim strCsCd             'コースコード
Dim strCsName           'コース名
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strBirth            '生年月日
Dim strAge              '年齢
Dim strGender           '性別
Dim strGenderName       '性別名称
Dim strDayId            '当日ID
Dim strOrgName          '団体名称

Dim strEraBirth         '生年月日(和暦)
Dim strRealAge          '実年齢
Dim strJudClassName     '判定分類名

'バーコードから引数値取得
Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '検査項目コード
Dim lngPrtDiv           '様式分類
Dim lngSeq              '依頼状番号

'削除用バリアント配列
Dim vntCRsvNo           '予約番号
Dim vntCJudClassCd      '判定分類コード
Dim vntCPrtDiv          '様式分類
Dim vntCSeq             'SEQ

'SUBMIT文字列可変用
Dim strOnSubmit
Dim vntSSendDate        '発送日戻り値
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objReqSendCheck   = Server.CreateObject("HainsReqSendCheck.ReqSendCheck")
Set objConsult        = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '(指定)発送年月日

strAction    = Request("act")
lngRequestNo = Request("requestNo")

    '### 開始年月日
    If IsEmpty(Request("strSendYear")) Then
        strSSendYear   = Year(Now())             '発送年
        strSSendMonth  = Month(Now())            '発送月
        strSSendDay    = Day(Now())              '発送日
    Else
        strSSendYear   = Request("strSendYear")   '発送年
        strSSendMonth  = Request("strSendMonth")  '発送月
        strSSendDay    = Request("strSendDay")    '発送日
    End If
    strSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSsendDay


Do
    blnCslInfoFlg = False

    '発送確認（新規）
    If strAction <> "" Then

        'バーコード確認
        If lngRequestNo = "" Then
            strArrMessage = Array("依頼状コード番号を指定してください")
            Exit Do
        End If
        If Len(lngRequestNo) <> 17 Then
            strArrMessage = Array("依頼状コード番号が不正です")
            lngRequestNo = ""
            Exit Do
        Else 
            If Not IsNumeric(lngRequestNo) Then
                strArrMessage = Array("依頼状コード番号が不正です")
                lngRequestNo = ""
                Exit Do
            End If
        End If
    
        lngRsvNo      = CLng("0" & Mid(lngRequestNo, 1, 9))
        lngJudClassCd = CLng("0" & Mid(lngRequestNo, 10, 3))
        lngPrtDiv     = CLng("0" & Mid(lngRequestNo, 13, 1))
        lngSeq        = CLng("0" & Mid(lngRequestNo, 14, 4))



        If strAction = "save" Then
            '発送データの存在チェック
            lngCount = objReqSendCheck.SelectAll_SendDate(lngRsvNo, _
                                                          lngJudClassCd, _
                                                          lngPrtDiv, _
                                                          vntSeq, _
                                                          vntJudClassName, _
                                                          vntFileName, _
                                                          vntAddDate, _
                                                          vntAddUser, _
                                                          vntReqSendDate, _
                                                          vntReqSendUser _
                                                         )

                If lngCount > 0 Then

                    '存在するなら、さらに新規か、更新かキャンセルかを選択させる
                    strAction = "choisemode"
                    blnCslInfoFlg = True

                Else
                    '発送日更新
                    Ret = objReqSendCheck.UpdateReqSendDate("UPD", lngRsvNo, lngJudClassCd, lngPrtDiv, lngSeq, Server.HTMLEncode(Session("USERID")), strSSendDate)

                    If Ret = INSERT_NORMAL Then
                        strAction = "saveend"
                        blnCslInfoFlg = True
                    Else
                        strAction = "saveerr"
                    End If
                End If
        End If

            '発送確認（更新）
        If strAction = "upd" Then

                '発送日更新
            Ret = objReqSendCheck.UpdateReqSendDate("UPD", lngRsvNo, lngJudClassCd, lngPrtDiv, lngSeq, Server.HTMLEncode(Session("USERID")), strSSendDate)

            If Ret = INSERT_NORMAL Then
                strAction = "saveend"
                blnCslInfoFlg = True
            Else
                strAction = "saveerr"
            End If
        End If

        '発送確認情報削除
        If strAction = "clear" Then

            '関数用に配列化
            vntCRsvNo = Array()
            vntCJudClassCd = Array()
            vntCPrtDiv = Array()
            vntCSeq   = Array()

            Redim Preserve vntCRsvNo(0)
            Redim Preserve vntCJudClassCd(0)
            Redim Preserve vntCPrtDiv(0)
            Redim Preserve vntCSeq(0)
            vntCRsvNo(0) = lngRsvNo
            vntCJudClassCd(0) = lngJudClassCd
            vntCPrtDiv(0) = lngPrtDiv
            vntCSeq(0)   = lngSeq

            '発送確認情報削除（最新情報のみ削除）
            If objReqSendCheck.DeleteReqSendDate("DEL", vntCRsvNo, vntCJudClassCd, vntCPrtDiv, vntCSeq) Then
                strAction = "clearend"
            Else
                strAction = "clearerr"
            End If

            blnCslInfoFlg = True
        End If
    End If

        '受診情報を表示
    If  blnCslInfoFlg = True Then

        '受診情報検索
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        strCslDate,    _
                                        strPerId,      _
                                        strCsCd,       _
                                        strCsName,     _
                                        , , _
                                        strOrgName,    _
                                        , , _
                                        strAge,        _
                                        , , , , , , , , , , , , _
                                        strDayId,   _
                                        , , 0, , , , , , , , , , , , , , , _
                                        strLastName,   _
                                        strFirstName,  _
                                        strLastKName,  _
                                        strFirstKName, _
                                        strBirth,      _
                                        strGender _
                                        )

        '受診情報が存在しない場合はエラーとする
        If Ret = False Then
            Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
        End If

        '生年月日(西暦＋和暦)の編集
        strEraBirth = objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d")

        '実年齢の計算
        If strBirth <> "" Then
            Set objFree = Server.CreateObject("HainsFree.Free")
            strRealAge = objFree.CalcAge(strBirth)
            Set objFree = Nothing
        Else
            strRealAge = ""
        End If

        '小数点以下の切り捨て
        If IsNumeric(strRealAge) Then
            strRealAge = CStr(Int(strRealAge))
        End If
        
        Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")
            If objJudClass.SelectJudClassName(lngJudClassCd, strJudClassName) Then
                strJudClassName = strJudClassName
            End If
        Set objJudClass = Nothing

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
<TITLE>依頼状発送確認</TITLE>

<SCRIPT TYPE="text/javascript">
    <!--
    // フォーカスセット
    function setFocus() {
    <%
        If strAction ="choisemode" Then
        '既に発送日が存在する場合
    %>
        return;
    <%
        Else
    %>
        document.entryForm.key.focus();
        document.entryForm.key.value = '';
        document.entryForm.act.value = '';
    <%
        End If
    %>
    }

// 依頼状発送日制御
function executeRequestSendDate( mode ) {

    // 通常更新
    if ( mode == 1 ) {
        document.entryForm.act.value = 'save';
        document.entryForm.requestNo.value = document.entryForm.key.value;
    }

    // 上書き更新
    if ( mode == 2 ) {
        if( !confirm('既存の発送日を今回の発送日で更新します。よろしいですか？' ) ) return;
        document.entryForm.act.value = 'upd';
        document.entryForm.submit();
    }

    // キャンセル
    if ( mode == 3 ) {
        if( !confirm('画面をクリアして初期画面を表示します。よろしいですか？' ) ) return;
        document.entryForm.act.value = '';
        document.entryForm.key.value = '';
        document.entryForm.submit();
    }

    // 発送日クリア
    if ( mode == 4 ) {
        if( !confirm('依頼状発送日をクリアします。よろしいですか？' ) ) return;
        document.entryForm.act.value = 'clear';
        document.entryForm.submit();
    }

    return;
}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.flwtab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<BODY ONLOAD="javascript:setFocus()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<BASEFONT SIZE="2">
<%
    '既に発送日が存在する場合
    If strAction ="choisemode" Then
        strOnSubmit = "javascript:return false;"
    Else
        strOnSubmit = "javascript:executeRequestSendDate(1)"
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="<%= strOnSubmit %>">

    <INPUT TYPE="hidden" NAME="act"          VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="requestNo"    VALUE="<%= lngRequestNo %>">

<!-- エラーメッセージ -->
<%
    'メッセージの編集
    If Not IsEmpty(strArrMessage) Then

        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

    End If
%>

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">依頼状発送確認</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
    <IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="400" ALIGN="left"><BR>
    <BR>
    <BR>

<%
    If strAction ="" Then

' ### 2016.01.26 張 成績書と依頼状の区分ができるようにメッセージ修正 STR #########################
'        strHtml = "バーコードを読み込んでください。"
        strHtml = "<FONT COLOR=""#0080FF"">依頼状のバーコード</FONT>を読み込んでください。"
' ### 2016.01.26 張 成績書と依頼状の区分ができるようにメッセージ修正 END #########################

    Else
        Select Case strAction
        Case "saveend"
            strHtml = "依頼状発送確認が完了しました。"
        Case "saveerr"
            strHtml = "フォローアップ情報が見つかりません。" & "（予約番号:" & lngRsvNo & "）"
        Case "clearend"
            strHtml = "依頼状発送日をクリアしました。"
        Case "clearerr"
            strHtml = "依頼状発送日をクリアに失敗しました。"
        Case "checkerr"
            If Not IsEmpty(strArrMessage) Then
                'エラーメッセージを編集
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
            End If
        Case "choisemode"
            strHtml = "<FONT COLOR=""RED"">既に発送確認済みです。処理を選択してください。</FONT>"
        End Select
    End If
%>
    <FONT SIZE="6"><%= strHtml %></FONT>

<%
    If strAction ="choisemode" Then
    '既に発送日が存在する場合

%>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
<%
        For i = 0 To lngCount - 1
%>
        <TR>
            <TD>検査項目</TD><TD><B><%= vntJudClassName(i) %></B></TD>
            <TD>依頼状番号</TD><TD><B>依頼状&nbsp;_&nbsp;<%= vntSeq(i) %>版</B></TD>
        </TR>
        <TR>
            <TD>依頼状発送日時</TD><TD><B>&nbsp;<%=vntReqSendDate(i)%></B></TD>
            <TD>依頼状発送者</TD><TD><B>&nbsp;<%=vntReqSendUser(i)%></B></TD>
        </TR>
<%
        Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
             <TD><FONT COLOR="#ff0000"><B>現在依頼状番号：依頼状&nbsp;_&nbsp;<%= lngSeq %>版</B></FONT></TD>
        </TR>
        <TR>
            <TD><INPUT TYPE="BUTTON" VALUE="発送日を更新" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeRequestSendDate(2)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="キャンセル"   STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeRequestSendDate(3)"></TD>
        </TR>
    </TABLE>
    <INPUT TYPE="hidden" NAME="key" VALUE="<%= lngRequestNo %>">

    <INPUT TYPE="hidden" NAME="strSendYear" VALUE="<%= strSSendYear %>">
    <INPUT TYPE="hidden" NAME="strSendMonth" VALUE="<%= strSSendMonth %>">
    <INPUT TYPE="hidden" NAME="strSendDay" VALUE="<%= strSSendDay %>">
<%
    Else
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD COLSPAN="7"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>

        <TR>
            <TD NOWRAP>BarCode：</TD>
            <TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" STYLE="ime-mode:disabled"></TD>
        </TR>
        <TR><TD COLSPAN="7">&nbsp;</TD></TR>
        <TR>
            <TD NOWRAP>発送日：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>日</TD>
            <INPUT TYPE="hidden" NAME="strSSendDate" VALUE="<%= strSSendDate %>">
        </TR>
        <TR><TD COLSPAN="7">&nbsp;</TD></TR>
    </TABLE>

<%
    End If

    '受診者情報を表示
    If blnCslInfoFlg = True Then
%>
    <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">

        <TR>
<%
        If strAction = "saveend" Then
            strHtml = strSSendDate & " " & objCommon.FormatString(Now(), "hh:mmam/pm") & "　発送確認完了"
        Else
            strHtml = "&nbsp;"
        End If
%>
            <TD NOWRAP><B><FONT COLOR="#ff0000"><%= strHtml %></FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP>受診日：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>　当日ＩＤ：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
            <TD NOWRAP>　検査項目：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strJudClassName %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><%= strPerId %></TD>
            <TD NOWRAP>　<B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & " " & strFirstKName %></FONT>）</TD>
            <TD NOWRAP>　<%= strEraBirth %>生　<%= strRealAge %>歳（<%= Int(strAge) %>歳）　<%= IIf(strGender = "1", "男性", "女性") %></TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
        <TR>     
            <TD>
                <!--<A HREF="/webHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">予約情報を参照</A>-->
<%
        If strAction <> "clearend" Then
%>    
                <A HREF="javascript:javascript:executeRequestSendDate(4)">現在依頼状発送日をクリアする</A>
<%
        End If
%>
            </TD>
        </TR>
    </TABLE>

<%
    End If
%>

</FORM>
</BLOCKQUOTE>
</BODY>
</HTML>