<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       汎用ガイド (Ver0.0.1)
'       AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'開始位置のデフォルト値

'データベースアクセス用オブジェクト
Dim objCommon			'共通関数アクセス用
Dim objFree				'アフターケアアクセス用

Dim strArrFreeCd
Dim strArrFreeClassCd
Dim strArrFreeName
Dim strArrFreeDate
Dim strArrFreeFeild1
Dim strArrFreeFeild2
Dim strArrFreeFeild3
Dim strArrFreeFeild4
Dim strArrFreeFeild5 

Dim strKey				'検索キーの集合
Dim strArrKey			'(分割後の)検索キーの集合
Dim lngStartPos			'開始レコード件数
Dim lngGetCount			'終了レコード件数

Dim lngAllCount			'条件を満たす全レコード件数
Dim lngCount			'レコード件数
Dim strURL				'URL文字列
Dim i, j				'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objFree		= Server.CreateObject("HainsFree.Free")

'引数値の取得
strKey		 	= Request("key")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", 20, lngGetCount))

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>汎用ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF">


<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

<INPUT TYPE="hidden" NAME="key" VALUE="<%= strKey %>">

<!-- 表題 -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">汎用情報の検索</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<%
	Do

		'検索条件を満たすレコード件数を取得
		lngAllCount = objFree.GdeSelectFreeCount( strKey )

		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす指導文章情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If
%>
		<% If strKey <> "" Then %>、「<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>」<% End If %>の検索結果は <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR> 
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objFree.GdeSelectFree(strKey, lngStartPos, lngGetCount, strArrFreeCd, strArrFreeClassCd, strArrFreeName, strArrFreeDate, strArrFreeFeild1, strArrFreeFeild2, strArrFreeFeild3, strArrFreeFeild4, strArrFreeFeild5 )
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'選択時のURLを編集
			strURL = "gdeSelectFree.asp?act=search&freeCd=" & strArrFreeCd(i)

%>
			<TR>
				<TD>
					<INPUT TYPE="hidden" NAME="FreeCd"  VALUE="<%= strArrFreeCd(i) %>">
				</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"  CLASS="guideStc"><%= strArrFreeFeild1(i) %>（<%= strArrFreeCd(i) %>）</A></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'ページングナビゲータの編集
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
