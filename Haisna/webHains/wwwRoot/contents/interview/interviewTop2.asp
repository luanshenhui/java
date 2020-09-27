<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		面接支援メイン (Ver0.0.1)
'		AUTHER  : 
'		パラメータによって初期表示画面変化
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト

'前画面から送信されるパラメータ値
Dim lngRsvNo		'予約番号
Dim lngIndex		'インデックス（画面選択コンボ）
Dim lngGrpCd		'インデックス（初期画面選択）

Dim strURL			'URL文字列
Dim mainURL			'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")
lngIndex    = Request("index")
lngGrpCd    = Request("grpcd")

'初期表示のURLセット
strURL = ""
If lngGrpCd = "" Then
    '## 初期画面区分が何もなかった場合、総合判定画面表示
    strURL = "totalJudView.asp?grpno=0"
    strURL = strURL & "&rsvNo=" & lngRsvNo
    strURL = strURL & "&winmode=0"
Else
    Select Case lngGrpCd
        '## 病歴情報画面展開
        Case 21 strURL = "DiseaseHistory.asp"
        '## 問診内容画面展開
        Case 24 strURL = "MonshinNyuryoku.asp"
    End Select

    strURL = strURL & "?grpno=" & lngGrpCd
    strURL = strURL & "&rsvNo=" & lngRsvNo
    strURL = strURL & "&winmode=0"
End If

mainURL = IIf( Request("urlname") <> "", Request("urlname"), strURL)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>面接支援</TITLE>
</HEAD>
<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
	strURL = "interviewHeader.asp"
	strURL = strURL & "?rsvNo=" & lngRsvNo
	strURL = strURL & "&Index=" & lngIndex
%>
	<FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
	<FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
