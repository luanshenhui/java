<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		個人ＩＤ付け替え (Ver0.0.1)
'		AUTHER  : Ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim strAction		'処理状態(確定ボタン押下時:"execute")
Dim strFromPerId	'変更元個人ＩＤ
Dim strLastName		'変更元姓
Dim strFirstName	'変更元名

Dim strToPerId		'変更後個人ＩＤ

Dim objPerson		'個人ＩＤ付け替えアクセス用COMオブジェクト
Dim strArrMessage	'エラーメッセージ
Dim Ret				'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------

'オブジェクトのインスタンス作成
Set objPerson = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strAction		= Request("action") & ""
strFromPerId	= Request("fromPerID") & ""
strLastName		= Request("lastname") & ""
strFirstName	= Request("firstname") & ""
strToPerId		= Request("toPerID") & ""

Do

	'確定ボタン押下時
	If strAction = "execute" Then

		'再チェック
		If Trim(strFromPerId) = "" Then
			strArrMessage = "変換対象の個人ＩＤが指定されていません。"
			strAction = "retry"
			Exit Do
		End If

		If Trim(strToPerId) = "" Then
			strArrMessage = "新しく設定する個人ＩＤが指定されていません。"
			strAction = "retry"
			Exit Do
		End If

		'個人ＩＤ付け替え
		If objPerson.ChangePerID (strFromPerId, strToPerId) = True Then
			strArrMessage = "ＩＤの付け替えが完了しました。"
			strAction = "normalend"
		Else
			strArrMessage = "更新時にエラーが発生しました。"
			strAction = "error"
		End If

		'ID付け替え完了
		Exit Do

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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>個人ＩＤの付け替え</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 個人検索ガイド呼び出し
function callPerGuide() {

	// 個人ガイド表示
	perGuide_showGuidePersonal( null, null, null, setPerInfo );

}

// 個人情報の編集
function setPerInfo( perInfo ) {

	var mydoc = document.changeperid;	// 自画面のフォームエレメント

	mydoc.toperid.value = perInfo.perId;
	mydoc.toname.value  = perInfo.perName;

	document.getElementById( 'pername' ).innerHTML = mydoc.toperid.value + ' ' + mydoc.toname.value + ' ' + perInfo.birthJpn + '生';

}

// 名簿受診者登録、受診者情報修正画面を閉じる
function closeChangePerID( action ) {

	// 更新完了の後でなければ何もしない
	if ( action != 'normalend' ) {
		return false;
	} else {
		alert ('<%= strArrMessage %>');
		close();
	}

	close();

}

// 確定ボタン押下時の処理
function ExecuteChangePerID() {

	var EditMsg;

	// 受診コースの必須チェック
	if ( document.changeperid.toperid.value == '' ) {
		alert('変換する個人ＩＤを指定して下さい。');
		return false;
	}

	EditMsg = '<%= strFromPerId %>　<%= strLastName %>　<%= strFirstName %>　様のデータを、';
	EditMsg = EditMsg + document.changeperid.toperid.value + '　';
	EditMsg = EditMsg + document.changeperid.toname.value;

	res = confirm(EditMsg + '　様のデータとして変更します。よろしいですか？');

	if ( res == true ){
		document.changeperid.action.value = 'execute';
	} else {
		return false;
	}

	document.changeperid.submit();

	return false;
}

//-->
</SCRIPT>
<style>
body { margin: 10px 10px 5px }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:closeChangePerID( '<%= strAction %>')">
<%
'保存完了時は画面を閉じるのみなので何も編集させない
If strAction = "normalend" Then
%>
	<BODY>
	</HTML>
<%
	Response.End
End If
%>

<FORM NAME="changeperid" ACTION="">

	<INPUT TYPE="hidden" NAME="action" VALUE="">
	<INPUT TYPE="hidden" NAME="fromperid" VALUE="<%= strFromPerId %>">
	<INPUT TYPE="hidden" NAME="toperid" VALUE="">
	<INPUT TYPE="hidden" NAME="toname" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人ＩＤ付け替え</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
	<BR><B><%= strFromPerId %>　<%= strLastName %>　<%= strFirstName %>　様</B><BR>の受診歴データを下に指定する個人ＩＤに変更します。

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
		<TR>
			<TD NOWRAP ALIGN="right">個人名：</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
						<TD WIDTH="5"></TD>
						<TD NOWRAP><SPAN ID="pername"></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="RIGHT">
		<TR>
			<TD WIDTH="5"></TD>
			<TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>    
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return ExecuteChangePerID()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="個人ＩＤの付け替えを実行"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>

			<TD WIDTH="5"></TD>
			<TD>
				<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
