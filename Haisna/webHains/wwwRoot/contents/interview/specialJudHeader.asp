<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		特定健診面接支援ヘッダ表示 (Ver0.0.1)
'		AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'前画面から送信されるパラメータ値
Dim strRsvNo        '予約番号

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
strRsvNo    = Request("rsvno")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接支援ヘッダ</TITLE>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!-- #include virtual = "/webHains/includes/specialJudHeader.inc" -->
<BODY>
<FORM NAME="headerForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= strRsvNo %>">

<%
    '面接支援ヘッダーインクルードを呼ぶ
    Call specialJudHeader(strRsvNo)
%>
</FORM>
</BODY>
</HTML>
