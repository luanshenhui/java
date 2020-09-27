<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   成績書発送確認  (Ver0.2)
'	   AUTHER  : H.Ishihara@FSIT
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
Dim objCommon			'共通クラス
Dim objReportSendDate	'成績書作成クラス
Dim objFree				'汎用情報アクセス用
Dim objConsult			'受診情報

'パラメータ
Dim strAction			'処理状態
Dim lngRsvNo			'予約番号

'受診情報用変数
Dim strPerId			'個人ID
Dim strCslDate			'受診日
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strGenderName		'性別名称
Dim strDayId			'当日ID
Dim strOrgName			'団体名称

Dim strEraBirth			'生年月日(和暦)
Dim strRealAge			'実年齢

Dim blnCslInfoFlg		'受診情報表示フラグ(True:表示)
Dim strHtml				'HTML文字列
Dim Ret					'関数戻り値
Dim strArrMessage		'エラーメッセージ

'既に発送確認済みの場合、その情報
Dim strSeq          	'SEQ
Dim strInsDate          '登録日時
Dim strInsUser          '登録ユーザ
Dim strInsUserName      '登録ユーザ名
Dim strReportSendDate   '成績書発送日
Dim strChargeUser       '成績書発送ユーザ
Dim strChargeUserName   '成績書発送ユーザ名

Dim vntDayID			'当日ID
Dim vntComeDate			'来院日時

'削除用バリアント配列
Dim vntRsvNo			'予約番号
Dim vntSeq				'SEQ

'SUBMIT文字列可変用
Dim strOnSubmit

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objReportSendDate = Server.CreateObject("HainsReportSendDate.ReportSendDate")
Set objConsult        = Server.CreateObject("HainsConsult.Consult")


'引数値の取得

'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '発送年月日

strAction		= Request("act")
lngRsvNo		= Request("rsvno")


'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
'◆ 開始年月日
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

    If strAction <> "" Then

        '値のチェック(予約番号)
        strArrMessage = objCommon.CheckNumeric("予約番号", lngRsvNo, LENGTH_CONSULT_RSVNO, CHECK_NECESSARY)

        If strArrMessage <> "" Then
            strAction = "checkerr"
        End If

        '入力予約番号の妥当性チェック
        If strAction <> "checkerr" Then

            '受診情報の取得
            Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                vntDayID, _
                                                vntComeDate)
    
            '受診情報が存在しない場合はエラーとする
            If Ret = False Then
                Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
            End If
    
            '未受付の場合はエラーとする
            If Trim(vntDayID) = "" Then
                Err.Raise 1000, , "指定された予約番号の受診情報は未受付です。（予約番号= " & lngRsvNo & " )"
            End If
    
            '未来院の場合はエラーとする
            If Trim(vntComeDate) = "" Then
                Err.Raise 1000, , "指定された予約番号の受診情報は未来院です。（予約番号= " & lngRsvNo & " )"
            End If

        End If

        '発送確認（新規）
        If strAction = "save" Then

            '発送データの存在チェック
            If objReportSendDate.SelectConsult_ReptSendLast(lngRsvNo, _
                                                            strSeq, _
                                                            strInsDate, _
                                                            strInsUser, _
                                                            strInsUserName, _
                                                            strReportSendDate, _
                                                            strChargeUser, _
                                                            strChargeUserName) Then

                '存在するなら、さらに新規か、更新かキャンセルかを選択させる
                strAction = "choisemode"
                blnCslInfoFlg = True

            Else

                '成績書発送日更新
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'               Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")))
                Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")), strSSendDate)

                If Ret = INSERT_NORMAL Then
                    strAction = "saveend"
                    blnCslInfoFlg = True
                Else
                    strAction = "saveerr"
                End If

            End If

        End If

        '発送確認（追加挿入モード）
        If strAction = "forceins" Then

            '成績書発送日追加
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'            Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")))
            Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")),strSSendDate)
            If Ret = INSERT_NORMAL Then
                strAction = "saveend"
                blnCslInfoFlg = True
            Else
                strAction = "saveerr"
            End If

        End If

        '発送確認（更新モード）
        If strAction = "upd" Then

            '成績書発送日更新
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'            Ret = objReportSendDate.UpdateReportSendDate("UPD", lngRsvNo, Server.HTMLEncode(Session("USERID")))
            Ret = objReportSendDate.UpdateReportSendDate("UPD", lngRsvNo, Server.HTMLEncode(Session("USERID")),strSSendDate)

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
            vntRsvNo = Array()
            vntSeq   = Array()
            Redim Preserve vntRsvNo(0)
            Redim Preserve vntSeq(0)
            vntRsvNo(0) = lngRsvNo
            vntSeq(0)   = 0

            '発送確認情報削除（最新情報のみ削除モード）
            If objReportSendDate.DeleteConsult_ReptSend("MAX", vntRsvNo, vntSeq) Then
                strAction = "clearend"
            Else
                strAction = "clearerr"
            End If

            blnCslInfoFlg = True

        End If

    End If

    '受診情報を表示する？
    If 	blnCslInfoFlg = True Then

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
<TITLE>成績書発送確認</TITLE>

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

// 成績書発送日制御
function executeReportSendDate( mode ) {

    // 通常更新
    if ( mode == 1 ) {
        document.entryForm.act.value = 'save';
        document.entryForm.rsvno.value = document.entryForm.key.value;
    }

    // 追加挿入
    if ( mode == 2 ) {
        if( !confirm('今回の発送日を新しく追加します。よろしいですか？' ) ) return;
        document.entryForm.act.value = 'forceins';
        document.entryForm.submit();
    }

    // 上書き更新
    if ( mode == 3 ) {
        if( !confirm('既存の発送日を今回の発送日で上書きします。よろしいですか？' ) ) return;
        document.entryForm.act.value = 'upd';
        document.entryForm.submit();
    }

    // キャンセル
    if ( mode == 4 ) {
        if( !confirm('画面をクリアして初期画面を表示します。よろしいですか？' ) ) return;
        document.entryForm.act.value = '';
        document.entryForm.key.value = '';
        document.entryForm.submit();
    }

    // 発送日クリア
    if ( mode == 5 ) {
        if( !confirm('成績書発送日をクリアします。よろしいですか？' ) ) return;
        document.entryForm.act.value = 'clear';
        document.entryForm.submit();
    }

    return;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setFocus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<BASEFONT SIZE="2">
<%
    '既に発送日が存在する場合
    If strAction ="choisemode" Then
        strOnSubmit = "javascript:return false;"
    Else
        strOnSubmit = "javascript:executeReportSendDate(1)"
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="<%= strOnSubmit %>">

    <INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">成績書発送確認</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
    <IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left"><BR>
    <BR>
    <BR>
<%
    If strAction ="" Then
' ### 2016.01.26 張 成績書と依頼状の区分ができるようにメッセージ修正 STR #########################
'        strHtml = "バーコードを読み込んでください。"
        strHtml = "<FONT COLOR=""#ff6600"">成績書のバーコード</FONT>を読み込んでください。"
' ### 2016.01.26 張 成績書と依頼状の区分ができるようにメッセージ修正 END #########################
    Else
        Select Case strAction
        Case "saveend"
            strHtml = "成績書発送確認が完了しました。"
        Case "saveerr"
            strHtml = "受診者が見つかりません。" & "（BarCode:" & lngRsvNo & "）"
        Case "clearend"
            strHtml = "成績書発送日をクリアしました。"
        Case "clearerr"
            strHtml = "成績書発送日をクリアに失敗しました。"
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
        <TR>
            <TD>最新登録番号</TD><TD><B><%= strSeq %></B></TD>
            <TD>発送確認日時</TD><TD><B><%= strReportSendDate %></B></TD>
            <TD>発送確認担当者</TD><TD><B><%= strChargeUserName %></B></TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD><FONT COLOR="#999999">登録日時</FONT></TD><TD><FONT COLOR="#999999"><%= strInsDate %></FONT></TD>
            <TD><FONT COLOR="#999999">登録担当者</FONT></TD><TD><FONT COLOR="#999999"><%= strInsUserName %></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD><INPUT TYPE="BUTTON" VALUE="新しく発送日を追加" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(2)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="既存の発送日を更新" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(3)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="キャンセル"         STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(4)"></TD>
        </TR>
    </TABLE>
    <INPUT TYPE="hidden" NAME="key" VALUE="<%= lngRsvNo %>">

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
<%' ### 2016.01.26 張 フォローアップ依頼状のバーコードなどで発送処理が出来ないよう修正 STR #########################%>
            <!--TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" MAXLENGTH="9" STYLE="ime-mode:disabled"></TD-->
            <TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" MAXLENGTH="18" STYLE="ime-mode:disabled"></TD>
<%' ### 2016.01.26 張 フォローアップ依頼状のバーコードなどで発送処理が出来ないよう修正 END #########################%>
        </TR>
<!-- ### 2005.08.05 張 成績書発送日指定して処理できるように引数追加 -->
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
<!--================================================================-->
    </TABLE>
<%
    End If
%>

<%
    '受診者情報を表示
    If blnCslInfoFlg = True Then
%>
    <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">
        <TR>
<%
        If strAction = "saveend" Then
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'            strHtml = objCommon.FormatString(Now(), "yyyy/mm/dd hh:mmam/pm") & "　発送確認完了"
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
            <TD NOWRAP>　コース：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>　当日ＩＤ：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
            <TD NOWRAP>　団体：</TD>
            <TD NOWRAP><%= strOrgName %></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><%= strPerId %></TD>
            <TD NOWRAP>　<B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>）</TD>
            <TD NOWRAP>　<%= strEraBirth %>生　<%= strRealAge %>歳（<%= Int(strAge) %>歳）　<%= IIf(strGender = "1", "男性", "女性") %></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
        <TR>
            <TD>
                <A HREF="/webHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">予約情報を参照</A>　　
<%
        If strAction <> "clearend" Then
%>
                <A HREF="javascript:javascript:executeReportSendDate(5)">この受診者の成績書発送日をクリアする</A>
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
