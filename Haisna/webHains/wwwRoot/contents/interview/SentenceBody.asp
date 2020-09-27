<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   所見選択（ボディ） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objSentence			'文章情報アクセス用

'パラメータ
Dim strItemCd			'検査項目コード
Dim lngItemType			'項目タイプ
Dim arrStcCd			'文章コード 配列

'文章
Dim strStcCd			'文章コード
Dim strShortStc			'略文章
Dim lngCount			'レコード件数

Dim lngChkFlg			'チェックフラグ
Dim i,j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSentence 	= Server.CreateObject("HainsSentence.Sentence")

'引数値の取得
strItemCd			= Request("itemcd")
lngItemType			= CLng("0" & Request("itemtype"))
arrStcCd			= ConvIStringToArray(Request("stccd"))

Do

	'指定検査項目コード、項目タイプのレコードを取得
	lngCount = objSentence.SelectSentenceList(strItemCd, _
											  lngItemType, _
											  strStcCd, _
											  strShortStc, _
											  , , , , , , , , _
											  1 _
											  )
	If lngCount < 0 Then
		Err.Raise 1000, , "文章の一覧が取得できません。（検査項目コード = " & strItemCd & ",項目タイプ = " & lngItemType & ")"
	End If

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>所見選択</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<INPUT TYPE="hidden" NAME="itemcd"   VALUE="<%= strItemCd   %>">
	<INPUT TYPE="hidden" NAME="itemtype" VALUE="<%= lngItemType %>">

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD NOWRAP COLSPAN="2">コード</TD>
			<TD NOWRAP>文章名</TD>
		</TR>
<%
	For i=0 To lngCount -1
		'選択済みチェック
		lngChkFlg = 0
		For j=0 To UBound(arrStcCd)
			If arrStcCd(j) = strStcCd(i) Then
				lngChkFlg = 1
				Exit For
			End If
		Next
%>
		<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
			<TD NOWRAP><INPUT TYPE="checkbox" NAME="chk" <%=IIf(lngChkFlg=1,"CHECKED","")%> ></TD>
			<TD NOWRAP><INPUT TYPE="hidden" NAME="stccd" VALUE="<%= strStcCd(i) %>"><%= strStcCd(i) %></TD>
			<TD NOWRAP><INPUT TYPE="hidden" NAME="shortstc" VALUE="<%= strShortStc(i) %>"><%= strShortStc(i) %></TD>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
