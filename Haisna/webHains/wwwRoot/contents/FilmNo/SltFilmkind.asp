<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		フィルム番号種類選択 (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim objFree 			'フィルム番号管理
Dim strHtml				'html出力用ワーク
Dim lngCount			'戻り値
Dim strFreeCd  			'汎用コード
Dim strFreeClassCd		'汎用分類コード
Dim strFreeName			'汎用名

'*****  2003/01/21  ADD  START  E.Yamamoto
Dim strMachineCls		'号機区分
Dim strMachineNo		'号機番号
Dim strOldMachineCls	'号機番号
'*****  2003/01/21  ADD  END    E.Yamamoto

Dim i	  				'ループカウント

Const FREECD = "FILM"	'汎用コード

Set objFree = Server.CreateObject("HainsFree.Free")

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' 機能　　 : フリーコードをから号機区分，号機番号を取得する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)

	'前回読み込んだ号機区分と異なる場合または「０」の場合はtrue、それ以外はfalseとする。
	If( ( strOldMachineCls <> strMachineCls ) Or strMachineCls = "0" )Then
		strOldMachineCls = strMachineCls
		EditFreeCd = True
	else
		EditFreeCd = false
	End If
 	
End Function
'*****  2003/01/21  ADD  END    E.Yamamoto

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フィルム番号種類選択</TITLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="/webHains/contents/FilmNo/FilmNo.asp" METHOD="get">

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">フィルム番号種類選択</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="308">
	<TR>
		<TD NOWRAP COLSPAN="5">フィルム番号種類を選択してください。</TD>
	</TR>
<%

	'汎用テーブルよりフィルム種別名を取得
	lngCount = objFree.SelectFree( 1,FREECD,strFreeCd,strFreeName)
	strOldMachineCls = "0"

	'ラジオボタンの設定
	For i = 0 To lngCount - 1 
		If( EditFreeCd(strFreeCd(i)) ) Then
		
			strHtml = strHtml & "			<TR><TD NOWRAP>" 
			strHtml = strHtml & "<INPUT TYPE=""radio"" NAME=""freeCd"" VALUE=""" & strFreeCd(i) & """" 
			If( i = 0 ) then
				strHtml = strHtml & " CHECKED>"
			Else
				strHtml = strHtml & " >"
			End if

			strHtml = strHtml & strFreeName(i) & "</TD></TR>" & vbCrLf
		End If
	Next
	
	Response.Write strHtml
%>

	<TR><TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD NOWRAP><INPUT TYPE="image" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="フィルム種別を選択"></TD>
	</TR>
</TABLE>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>