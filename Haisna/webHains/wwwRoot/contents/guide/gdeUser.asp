<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		ユーザ名ガイド (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'		　　　　　判定医師名ガイド をコピーして作成 2004.01.13 K.Fujii@ffcs
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'
' 機能　　 : ユーザ名一覧の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditUserList()

	Dim objHainsUser	'ユーザ名アクセス用COMオブジェクト

	Dim strUserCd		'ユーザコード
	Dim strUserName	'ユーザ名
	Dim strDelFlg		'削除フラグ

	Dim lngCount		'レコード件数

	Dim strDispUserCd	'編集用のユーザコード
	Dim strDispUserName	'編集用のユーザ名
	Dim i			'インデックス
	Dim j			'インデックス

	Do
		'ユーザのレコードを取得
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		lngCount = objHainsUser.SelectUserList(strUserCd, strUserName, , , strDelFlg)

		j = 0
		'ユーザ名一覧の編集開始
		For i = 0 To lngCount - 1

			Do
				If strDelFlg(i) = "1" Then
					Exit Do
				End If

				'ユーザ名の取得
				strDispUserCd   = strUserCd(i)
				strDispUserName = strUserName(i)

				'ユーザ名の編集
				If (j Mod 2) = 0 Then
%>
				<TR BGCOLOR="#ffffff">
<%
				Else
%>
				<TR BGCOLOR="#eeeeee">
<%
				End If
%>
					<TD>
						<INPUT TYPE="hidden" NAME="usercd" VALUE="<%= strUserCd(i) %>"><%= strDispUserCd %>
					</TD>
					<TD>
						<INPUT TYPE="hidden" NAME="username" VALUE="<%= strUserName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(j) %>)" CLASS="guideItem"><%= strDispUserName %></A>
					</TD>
				</TR>
<%
				j = j + 1
				Exit Do
			Loop
		Next

		Exit Do
	Loop

	Set objHainsUser = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ユーザガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 医師コード・医師名のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、ユーザコード・ユーザ名を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	if ( opener.usrGuide_UserCd != null ) {
		if ( document.entryform.usercd.length != null ) {
			opener.usrGuide_UserCd = document.entryform.usercd[ index ].value;
		} else {
			opener.usrGuide_UserCd = document.entryform.usercd.value;
		}
	}

	if ( opener.usrGuide_UserName != null ) {
		if ( document.entryform.username.length != null ) {
			opener.usrGuide_UserName = document.entryform.username[ index ].value;
		} else {
			opener.usrGuide_UserName = document.entryform.username.value;
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.usrGuide_CalledFunction != null ) {
		opener.usrGuide_CalledFunction();
	}

	opener.winGuideUsr = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>ユーザ名を選択してください。</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">コード</TD>
			<TD>ユーザ名</TD>
		</TR>
<%
		'ユーザ名一覧の編集
		EditUserList
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
