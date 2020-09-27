<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   来院情報設定  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			    '共通クラス
Dim objFollow               'フォローアップアクセス用 

'パラメータ
Dim lngCheckSeq			    '画面モード(1 :1次勧奨, 2 :2次勧奨)
Dim strModeName			    '画面モード名称
Dim strAction			    '処理状態 (save:勧奨日登録)

Dim lngRsvNo                '予約番号
Dim lngJudClassCd           '判定分類コード
Dim lngReqCheckMode         '勧奨日登録モード（1:勧奨 , 2:未勧奨）
Dim strCheckDate            '勧奨日
Dim strReqCheckDate         '勧奨日（登録完了）
Dim strReqCheckYear         '勧奨日（年）
Dim strReqCheckMonth        '勧奨日（月）
Dim strReqCheckDay          '勧奨日（日）
Dim strUpdUser			    '更新者
Dim strArrMessage		    'エラーメッセージ
Dim Ret					    '関数戻り値

Dim strSql


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'引数値の取得
lngCheckSeq             = Request("mode")
strAction			    = Request("act")
lngRsvNo			    = Request("rsvno")
lngJudClassCd		    = Request("judClassCd")
lngReqCheckMode         = Request("reqCheckMode")
strReqCheckDate         = Request("reqCheckDate")

strReqCheckYear         = Request("reqCheckYear")
strReqCheckMonth        = Request("reqCheckMonth")
strReqCheckDay          = Request("reqCheckDay")

strSql = ""

'勧奨日の設定

If strAction = "" Then
    If IsDate(strReqCheckDate) Then
        strReqCheckYear = Mid(strReqCheckDate, 1, 4) 
        strReqCheckMonth = Mid(strReqCheckDate, 6, 2) 
        strReqCheckDay = Mid(strReqCheckDate, 9, 2) 
        lngReqCheckMode = 1
    Else   
        strReqCheckYear   = Year(Now())				'開始年
		strReqCheckMonth  = Month(Now())			'開始月
		strReqCheckDay    = Day(Now())				'開始日
        'strReqCheckDate = strReqCheckYear & "/" & strReqCheckMonth & "/" & strReqCheckDay
        lngReqCheckMode = 2
    End If
End If


Do
	Select Case lngCheckSeq
	Case "1"
		strModeName = "１次勧奨"
	Case "2"
		strModeName = "２次勧奨"
	Case Else
		strModeName = ""
	End Select


	If strAction = "save" Then
        'strReqCheckDate = strReqCheckYear & "/" & strReqCheckMonth & "/" & strReqCheckDay

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

		'### 勧奨日登録処理
        Ret = objFollow.UpdateFollow_Info_Kansho(lngRsvNo, lngJudClassCd, strReqCheckDate, lngCheckSeq, lngReqCheckMode, Session.Contents("userId"))
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("勧奨日登録に失敗しました。")
            Exit Do
        End If
    End If

	Exit Do
Loop


'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '共通クラス

    Dim vntArrMessage   'エラーメッセージの集合
    Dim strMessage      'エラーメッセージ
    Dim i               'インデックス

    '共通クラスのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon
        '勧奨日
        .AppendArray vntArrMessage, .CheckDate("勧奨日", strReqCheckYear , strReqCheckMonth, strReqCheckDay, strReqCheckDate)
    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strModeName %>日の登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### 保存処理後親画面も最新情報で表示し、自分の画面を閉じる
    If strAction = "saveend"  Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //親画面が閉じられていなかった場合、親画面リフレッシュ
        if (!opener.closed) {
            opener.replaceForm();
        }
        window.close();
//-->
</SCRIPT>
<%
    End If
%>
<SCRIPT TYPE="text/javascript">
<!--
//保存処理
function followRslKansho() {
    var confirmMsg;
    var scnt ;
    var reqFlg;

    reqFlg = '';
    reqFlg = document.entryForm.reqCheckMode.value;

    if (reqFlg == 1) {
        confirmMsg = '勧奨日登録処理を行います。よろしいでしょうか？';
    } else if (reqFlg == 2) {
        confirmMsg = '未勧奨処理を行います。よろしいでしょうか？';
    } else {
      return;
    }

    if ( !confirm( confirmMsg ) ) {
        return;
    }
    with ( document.entryForm ) {
        act.value = 'save';
        submit();
    }
    return false;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">
	<INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= lngCheckSeq %>">
	<INPUT TYPE="hidden"    NAME="act"          VALUE="<%= strAction %>">


	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000"><%= strModeName %>日の登録</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
		If Not IsEmpty(strArrMessage) Then
			'エラーメッセージを編集
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
	<BR>

<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>■</FONT></TD>
			<TD WIDTH="76" NOWRAP><%= strModeName %>日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('reqCheckYear', 'reqCheckMonth', 'reqCheckDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("reqCheckYear", YEARRANGE_MIN, YEARRANGE_MAX, strReqCheckYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("reqCheckMonth", 1, 12, strReqCheckMonth, True) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("reqCheckDay", 1, 31, strReqCheckDay, True) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>



	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<BR>
        <TR>
			<TD>■</FONT></TD>
            <TD WIDTH="76" NOWRAP><%= strModeName %></TD>
			<TD>：</TD>

			<TD WIDTH="70">
				<INPUT TYPE="radio" NAME="radio_Kansho" VALUE="1" <%= IIf(IsDate(strReqCheckDate), "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.radio_Kansho.value = this.value;document.entryForm.reqCheckMode.value = this.value">勧奨
            </TD>
            <TD WIDTH="70">
				<INPUT TYPE="radio" NAME="radio_Kansho" VALUE="2" <%= IIf(IsDate(strReqCheckDate), "", "CHECKED") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.radio_Kansho.value = this.value;document.entryForm.reqCheckMode.value = this.value">未勧奨
				<INPUT TYPE="hidden" NAME="reqCheckMode" VALUE="<%= lngReqCheckMode %>">
			</TD>
		</TR>


	</TABLE>
	<BR>
	<TABLE WIDTH="300" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<BR>
        <TR ALIGN="center">
            <TD  WIDTH="100"></TD>
            <TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="javascript:followRslKansho()">
                <IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" border="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>
            
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル" border="0"></A></TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
