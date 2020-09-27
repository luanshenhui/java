<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		判定医師名ガイド (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
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
Dim strDoctorFlg		'判定医フラグ
Dim strTitle			'ガイドタイトル
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strDoctorFlg = Request("doctorFlg")
If strDoctorFlg = DOCTORFLG_USER Then
	strTitle = "担当者名"
Else
	strTitle = "判定医師名"
End If
'-------------------------------------------------------------------------------
'
' 機能　　 : 判定医師名一覧の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditDocList()

	Dim objHainsUser	'医師名アクセス用COMオブジェクト

	Dim strDoctorCd		'医師コード
	Dim strDoctorName	'医師名

	Dim lngCount		'レコード件数

	Dim strDispDoctorCd	'編集用の医師コード
	Dim strDispDoctorName	'編集用の医師名
	Dim i			'インデックス

	Do
		'判定医師のレコードを取得
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		lngCount = objHainsUser.SelectDoctorList(strDoctorFlg, strDoctorCd, strDoctorName)

		'判定医師名一覧の編集開始
		For i = 0 To lngCount - 1

			'判定医師名の取得
			strDispDoctorCd   = strDoctorCd(i)
			strDispDoctorName = strDoctorName(i)

			'判定医師名の編集
			If (i Mod 2) = 0 Then
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
					<INPUT TYPE="hidden" NAME="doctorcd" VALUE="<%= strDoctorCd(i) %>"><%= strDispDoctorCd %>
				</TD>
				<TD>
					<INPUT TYPE="hidden" NAME="doctorname" VALUE="<%= strDoctorName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(i) %>)" CLASS="guideItem"><%= strDispDoctorName %></A>
				</TD>
			</TR>
<%
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
<TITLE><%= strTitle %>ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 医師コード・医師名のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、医師コード・医師名を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 医師コード
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_UserCd != null ) {
			if ( document.entryform.doctorcd.length != null ) {
				opener.usrGuide_UserCd = document.entryform.doctorcd[ index ].value;
			} else {
				opener.usrGuide_UserCd = document.entryform.doctorcd.value;
			}
		}
	} else {
		if ( opener.docGuide_DoctorCd != null ) {
			if ( document.entryform.doctorcd.length != null ) {
				opener.docGuide_DoctorCd = document.entryform.doctorcd[ index ].value;
			} else {
				opener.docGuide_DoctorCd = document.entryform.doctorcd.value;
			}
		}
	}

	// 医師名
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_UserName != null ) {
			if ( document.entryform.doctorname.length != null ) {
				opener.usrGuide_UserName = document.entryform.doctorname[ index ].value;
			} else {
				opener.usrGuide_UserName = document.entryform.doctorname.value;
			}
		}
	} else {
		if ( opener.docGuide_DoctorName != null ) {
			if ( document.entryform.doctorname.length != null ) {
				opener.docGuide_DoctorName = document.entryform.doctorname[ index ].value;
			} else {
				opener.docGuide_DoctorName = document.entryform.doctorname.value;
			}
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_CalledFunction != null ) {
			opener.usrGuide_CalledFunction();
		}
	} else {
		if ( opener.docGuide_CalledFunction != null ) {
			opener.docGuide_CalledFunction();
		}
	}

	opener.winGuideDoc = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>判定医師を選択してください。</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">コード</TD>
			<TD>医師名</TD>
		</TR>
		<INPUT TYPE="hidden" NAME="doctorFlg" VALUE="<%= strDoctorFlg %>">
<%
		'判定医師名一覧の編集
		EditDocList
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
