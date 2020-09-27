<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       面接文章ガイド (Ver0.0.1)
'       AUTHER  : ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
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
Dim objAfterCare		'アフターケアアクセス用

Dim strKey				'検索キー
Dim strGuidanceDiv		'指導内容区分
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'面接文章情報
Dim strArrGuidanceDiv		'指導文章コード
Dim strArrStdContactStcCd	'定型面接文章コード
Dim strArrContactStc		'面接文章

'iniファイル定義内容
Dim vntGuidanceDivCd	'指導内容区分
Dim vntGuidanceDiv		'指導内容文字列

Dim strDispStdContactStcCd	'編集用の指導内容区分
Dim strDispContactStc		'編集用の面接文章
Dim strDispGuidanceDiv		'編集用の指導内容

Dim strAction			'
Dim strArrKey			'(分割後の)検索キーの集合
Dim lngAllCount			'条件を満たす全レコード件数
Dim lngCount			'レコード件数
Dim strURL				'URL文字列
Dim i, j				'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

'引数値の取得
strAction      	= Request("act")
strKey         	= Request("key")
strGuidanceDiv 	= Request("guidanceDiv")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", 30, lngGetCount))

'iniファイルから指導内容を取得
	objAfterCare.GetGuidanceDiv  vntGuidanceDivCd , vntGuidanceDiv 

If( strGuidanceDiv <> "" ) then
	strDispGuidanceDiv = vntGuidanceDiv(Cint(strGuidanceDiv) - 1)
End if


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接文章ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF" ONLOAD="JavaScript:window.document.kensakulist.key.focus();">


<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="guidanceDiv" VALUE="<%= strGuidanceDiv %>">

<!-- 表題 -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">面接文書の検索</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR><TD COLSPAN="2">検索条件を入力して下さい。</TD></TR>
				<TR><TD HEIGHT="5"></TD></TR>
				<TR>
					<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.kensakulist.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR><BR>
<%
	Do
		If IsEmpty(strAction) Then
			Exit Do
		End If

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件を満たすレコード件数を取得
		lngAllCount = objAfterCare.SelectStdContactStcListCount( strArrKey, strGuidanceDiv )

		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす指導文章情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If
%>
		「<FONT COLOR="#FF6600"><B><%= IIf(strGuidanceDiv = "", "全ての面接文章", strDispGuidanceDiv) %></B></FONT>」
		<% If strKey <> "" Then %>、「<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>」<% End If %>の検索結果は <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objAfterCare.SelectStdContactStc(strArrKey, strGuidanceDiv, lngStartPos, lngGetCount, strArrGuidanceDiv, strArrStdContactStcCd, strArrContactStc)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'表示用指導文章文章の編集
			strDispContactStc = strArrContactStc(i)

			If strKey <> "" Then

				'検索キーに合致する部分に<B>タグを付加
				For j = 0 To UBound(strArrKey)
					strDispStdContactStcCd 	= Replace(strDispContactStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispContactStc 		= Replace(strDispContactStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'面接文章選択時のURLを編集
			strURL = "gdeSelectStdContactStc.asp?act=search&guidanceDiv=" & strArrGuidanceDiv(i) & "&stdContactStcCd=" & strArrStdContactStcCd(i)

%>
			<TR>
				<TD>
					<INPUT TYPE="hidden" NAME="dispGuidanceDiv"  VALUE="<%= strArrGuidanceDiv(i) %>">
					<INPUT TYPE="hidden" NAME="dispStdContactStc" VALUE="<%= strArrStdContactStcCd(i) %>">
				</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><%= strArrStdContactStcCd(i) %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"  CLASS="guideStc"><%= strDispContactStc %></A></TD>
				<TD WIDTH="150" NOWRAP><% If strArrGuidanceDiv(i) <> "" Then %><FONT SIZE="-1" COLOR="666666">（<%= vntGuidanceDiv(Cint(strArrGuidanceDiv(i)) -1 ) %>）</FONT><% End If %></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'ページングナビゲータの編集
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=select&guidanceDiv=" & strGuidanceDiv & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
