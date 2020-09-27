<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       病名ガイド (Ver0.0.1)
'       AUTHER  : Eiichi Yamamoto
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
Dim objDisease			'病名，病類情報アクセス用
Dim objCommon			'共通関数アクセス用

Dim strKey				'検索キー
Dim strDisDivCd			'病類コード
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'病類情報
Dim strArrDisDivName	'病類名称

'病名情報
Dim strArrDisCd			'病名コード
Dim strArrDisName		'病名
Dim strArrSearchChar	'ガイド検索用文字列
Dim strArrDisDivCd		'病類コード

Dim strDispDisCd		'表示用病名コード
Dim strDispDisName		'表示用病名

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
Set objDisease		= Server.CreateObject("HainsDisease.Disease")
Set objCommon   	= Server.CreateObject("HainsCommon.Common")

'引数値の取得

strAction      	= Request("act")
strKey        	= Request("key")
strDisDivCd		= Request("disDivCd")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))

'病類情報の取得
Call objDisease.SelectDisDivList(strArrDisDivCd, strArrDisDivName)

'病名情報の取得
Call objDisease.SelectDiseaseItemList(strArrDisCd, strArrDisName, strArrSearchChar )

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>病名検索ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--


//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF" ONLOAD="JavaScript:window.document.searchForm.key.focus();">


<!-- 表題 -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">病名の検索</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<FORM NAME="searchForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="act" SIZE="30" VALUE="search">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
	<TR>
		<TD COLSPAN="2">検索条件を入力して下さい。</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD NOWRAP>病類</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("disDivCd", strArrDisDivCd, strArrDisDivName , strDisDivCd, NON_SELECTED_ADD) %></TD>
	</TR>	
	<TR>
		<TD NOWRAP>検索条件</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.searchForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A>
	</TR>
</TABLE>
<BR><BR>
<%
	Do

		If( IsEmpty(strAction) or strAction = "" )Then
			Exit Do
		End If

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件を満たすレコード件数を取得
		lngAllCount = objDisease.SelectDisListCount(strArrKey, strDisDivCd)

		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす判定コメント情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If
%>
		<% If strKey <> "" Then %>「<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>」の<% End If %>検索結果は <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objDisease.SelectDisList(strArrKey, strDisDivCd, lngStartPos, lngGetCount, strArrDisCd, strArrDisName, strArrSearchChar, strArrDisDivCd)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'表示用判定コメント文章の編集
			strDispDisCd   = strArrDisCd(i)
			strDispDisName = strArrDisName(i)

			If strKey <> "" Then

				'検索キーに合致する部分に<B>タグを付加
				For j = 0 To UBound(strArrKey)
					strDispDisCd = Replace(strDispDisCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispDisName = Replace(strDispDisName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'病名選択時のURLを編集
			strURL = "gdeSelectDisease.asp?act=search&disCd=" & strArrDisCd(i) & "&disDivCd=" & strArrDisDivCd(i)

%>
			<TR>
				<TD></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><%= strDispDisCd %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"><%= strDispDisName %></A></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'ページングナビゲータの編集
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=search&disDivCd=" & strDisDivCd & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
