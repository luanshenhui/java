<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   個人検査情報 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
If Request("mode") = "1" Then
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
End If

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数値
Dim strPerID			'個人ＩＤ
Dim strMode				'処理モード(フレーム内表示:"1")

'見出し
Dim strArrTitle()		'受診歴見出し

'受診歴
Dim strCslDate			'受診日
Dim strCsName			'コース名

'個人検査結果
Dim strItemCd			'検査項目コード
Dim strSuffix			'サフィックス
Dim strItemName			'検査項目名称
Dim strResult			'検査結果
Dim strResultType		'結果タイプ
Dim strItemType			'項目タイプ
Dim strStcItemCd		'文章参照用項目コード
Dim strShortStc			'文章略称
Dim strIspDate			'検査日

Dim objConsult			'受診情報アクセス用COMオブジェクト
Dim objPerResult		'個人検査結果情報アクセス用COMオブジェクト

Dim lngConsultCount		'受診歴件数
Dim lngPerResultCount	'個人検査結果件数
Dim i					'インデックス

Dim blnExist			'存在フラグ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strPerID = Request("perID")
strMode  = Request("mode")

'オブジェクトのインスタンス作成
Set objConsult   = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")

'受診歴見出しの編集
Call EditTitle

'受診歴読み込み
lngConsultCount = objConsult.SelectConsultHistory(strPerID, , , , 2, , strCslDate, , strCsName)

'個人検査結果読み込み
lngPerResultCount = objPerResult.SelectPerResultList(strPerID, _
														strItemCd, _
														strSuffix, _
														strItemName, _
														strResult, _
														strResultType, _
														strItemType, _
														strStcItemCd, _
														strShortStc, _
														strIspDate)

'-----------------------------------------------------------------------------
' 受診歴見出しの編集
'-----------------------------------------------------------------------------
Sub EditTitle()
	Redim strArrTitle(1)
	strArrTitle(0) = "直近の受診日"
	strArrTitle(1) = "１つ前の受診日"
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>個人情報</TITLE>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD BGCOLOR="#EEEEEE" NOWRAP><B>個人情報</B></TD>
	</TR>
</TABLE>
<BR>
<B>個人検査情報</B><BR>
<%
blnExist = False
For i = 0 To lngPerResultCount - 1
	If strResult(i) <> "" Then
		blnExist = True
		Exit For
	End If
Next

If Not blnExist Then
%>
	<BR>個人検査情報は存在しません。<BR>
<%
Else
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>検査項目名</TD>
			<TD NOWRAP>検査結果</TD>
			<TD NOWRAP>検査日</TD>
		</TR>
<%
		For i = 0 To lngPerResultCount - 1

			If strResult(i) <> "" Then
%>
				<TR BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strItemName(i) %></TD>
					<TD NOWRAP><%= IIf(strShortStc(i) <> "", strShortStc(i), IIf(strResult(i) <> "", strResult(i), "&nbsp;")) %></TD>
					<TD NOWRAP><%= IIf(strIspDate(i)="", "&nbsp;", strIspDate(i)) %></TD>
				</TR>
<%
			End If

		Next
%>
</TABLE>
<%
End If
%>
<BR>
<B>受診歴</B><BR>
<%
If lngConsultCount = 0 Then
%>
	<BR>受診歴は存在しません。
<%
Else
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To lngConsultCount - 1
%>
			<TR BGCOLOR="#EEEEEE">
				<TD NOWRAP><%= strArrTitle(i) %></TD>
				<TD NOWRAP><%= strCslDate(i) %></TD>
				<TD NOWRAP><%= strCsName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End If
%>
<BR>
<%
If strMode <> "1" Then
%>
	<TABLE>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD WIDTH="340" COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>
<%
End If
%>
</BODY>
</HTML>
