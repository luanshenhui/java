<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		室部情報メンテナンス(メイン画面) (Ver0.0.1)
'		AUTHER  : 佐藤　基尉
'		Comment : 室部の各項目の長さチェックに事業部の項目長を使っているが、
'				: 長さが同じなので問題ないと思われる為である。
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'定数の定義
Const MODE_INSERT     = "insert"	'処理モード(挿入)
Const MODE_UPDATE     = "update"	'処理モード(更新)
Const ACTMODE_SAVE    = "save"		'動作モード(保存)
Const ACTMODE_SAVED   = "saved"		'動作モード(保存完了)
Const ACTMODE_DELETE  = "delete"	'動作モード(削除)
Const ACTMODE_DELETED = "deleted"	'動作モード(削除完了)

'COMコンポーネント
Dim objCommon			'共通クラス
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgRoom			'室部情報アクセス用

'引数値（本スクリプトを呼び出す際の引数情報を定義します）
Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strActMode			'動作モード(保存:"save"、保存完了:"saved")
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgRoomName		'室部名称

'作業用の変数
Dim strOrgSName			'団体略称
Dim strOrgBsdName		'事業部略称
Dim strArrMessage		'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'引数値の取得
strMode         = Request("mode")
strActMode      = Request("actMode")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strOrgRoomName  = Request("orgRoomName")
strOrgRoomKName	= Request("orgRoomKName")

'処理モード未指定時は挿入モードとする
strMode = IIf(strMode = "", MODE_INSERT, strMode)

'チェック・更新・読み込み処理の制御
Do

	'削除時の処理
	If strActMode = ACTMODE_DELETE Then

		'室部テーブルレコード削除
		Ret = objOrgRoom.DeleteOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd)
		If Ret = 0 Then
			strArrMessage = Array("この室部は他から参照されています。削除できません。")
			Exit Do
		End If

		'削除に成功した場合は挿入モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="    & MODE_INSERT
		strURL = strURL & "&actMode=" & ACTMODE_DELETED
		strURL = strURL & "&orgCd1="  & strOrgCd1
		strURL = strURL & "&orgCd2="  & strOrgCd2
		Response.Redirect strURL
		Response.End

	End If

	'保存時の処理
	If strActMode = ACTMODE_SAVE Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'更新の場合
		If strMode = MODE_UPDATE Then

			'室部テーブルレコード更新
			Ret = objOrgRoom.UpdateOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName)

			'レコードが存在しない場合は新規時の処理を行う
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'挿入の場合
		If strMode = MODE_INSERT Then

			'室部テーブルレコード挿入
			Ret = objOrgRoom.InsertOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName)

			'キー重複時はエラーメッセージを編集する
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("同一団体、事業部、室部コードの室部情報がすでに存在します。")
				Exit Do
			End If

		End If

		'保存に成功した場合は更新モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="		& MODE_UPDATE
		strURL = strURL & "&actMode="	& ACTMODE_SAVED
		strURL = strURL & "&orgCd1="	& strOrgCd1
		strURL = strURL & "&orgCd2="	& strOrgCd2
		strURL = strURL & "&orgBsdCd="	& strOrgBsdCd
		strURL = strURL & "&orgRoomCd=" & strOrgRoomCd
		Response.Redirect strURL
		Response.End

	End If

	'新規の場合は読み込みを行わない
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'室部テーブルレコード読み込み
	If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName) = False Then
		Err.Raise 1000, , "室部情報が存在しません。"
	End If

	'処理モードを更新とする
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 事業部情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim vntArrMessage	'エラーメッセージの集合
	Dim strMessage		'エラーメッセージ

	'各値チェック処理
	With objCommon

		'団体コード
		If strOrgCd1 = "" Or  strOrgCd2 = "" Then
			.AppendArray vntArrMessage, "団体を入力して下さい。"
		End If

		'事業部コード
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("事業部コード", strOrgBsdCd, LENGTH_ORGBSD_ORGBSDCD, CHECK_NECESSARY)

		'室部コード
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("室部コード", strOrgRoomCd, LENGTH_ORGBSD_ORGBSDCD, CHECK_NECESSARY)

		'室部カナ名称
		strMessage = .CheckWideValue("室部カナ名称", strOrgRoomKName,  LENGTH_ORGBSD_ORGBSDKNAME)
		If strMessage = "" Then
			If .CheckKana(strOrgRoomKName) = False Then
				strMessage = "室部カナ名称に不正な文字が含まれます。"
			End If
		End If
		.AppendArray vntArrMessage, strMessage

		'室部名称
		.AppendArray vntArrMessage, .CheckWideValue("室部名称", strOrgRoomName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>室部情報メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// ガイド画面呼び出し
// (1) 団体コードについては大抵textやhiddenで定義されるため、配列形式となる場合もある。（例：契約情報の負担元登録画面）
//     ゆえにオブジェクト自体を引数にて渡す。
// (2) 団体名称（漢字・カナ・略称）についてはSPANタグで定義されたIDを指定する。
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, '', 'orgSName', '' );

}

function callOrgBsdGuide() {

	orgPostGuide_getElement( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', document.entryForm.orgBsdCd, 'orgBsdName', '', '', '', '', '', '' );
	orgPostGuide_showGuideOrgBsd();

}

// submit時の処理
function submitForm( actMode ) {

	// 削除時は確認メッセージを表示
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( 'この室部情報を削除します。よろしいですか？' ) ) {
			return;
		}
	}

	// 動作モードを指定してsubmit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">室部情報メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						'前画面のURL編集
						strURL = "mntSearchOrgRoom.asp"
						strURL = strURL & "?orgCd1=" & strOrgCd1
						strURL = strURL & "&orgCd2=" & strOrgCd2
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="室部の検索画面に戻る"></A></TD>
<%
						'更新時は削除ボタンを表示する
						If strMode = "update" And strOrgRoomCd <> "0000000000" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この室部情報を削除します"></A></TD>
<%
						End If
%>
						<TD><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<%
	'保存、削除完了時は完了通知を行い、さもなくばエラーメッセージを編集する
	Select Case strActMode
		Case ACTMODE_SAVED
			EditMessage "保存が完了しました。", MESSAGETYPE_NORMAL
		Case ACTMODE_DELETED
			EditMessage "削除が完了しました。", MESSAGETYPE_NORMAL
		Case Else
			EditMessage strArrMessage, MESSAGETYPE_WARNING
	End Select
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>団体</TD>
			<!-- TD ROWSPAN="5" WIDTH="5"></TD -->
			<TD>
				<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
				<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						'団体コードが指定されている場合
						If strOrgCd1 <> "" And strOrgCd2 <> "" Then

							'団体情報読み込み
							objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName

						End If
%>
						<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>

		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>事業部</TD>
			<TD>
				<INPUT TYPE="hidden" NAME="orgBsdCd" VALUE="<%= strOrgBsdCd %>">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						'挿入モードの場合はガイドボタンを表示する
						If strMode = MODE_INSERT Then
%>
							<TD><A HREF="javascript:callOrgBsdGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
							<TD>&nbsp;</TD>
<%
						End If

						'団体コードが指定されている場合
						If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" Then

							'団体情報読み込み
							objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName

						End If
%>
						<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>

		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>室部コード</TD>
<%
			'挿入モードの場合はテキスト表示を行い、更新モードの場合はhiddenでコードを保持
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgRoomCd" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDCD) %>" MAXLENGTH="<%= LENGTH_ORGBSD_ORGBSDCD %>" VALUE="<%= strOrgRoomCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgRoomCd" VALUE="<%= strOrgRoomCd %>"><%= strOrgRoomCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="12"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>室部カナ名称</TD>
			<TD><INPUT TYPE="text" NAME="orgRoomKName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" VALUE="<%= strOrgRoomKName %>" STYLE="ime-mode:active;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>室部名称</TD>
			<TD><INPUT TYPE="text" NAME="orgRoomName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDNAME) %>" VALUE="<%= strOrgRoomName %>" STYLE="ime-mode:activate;"></TD>
		</TR>
	</TABLE>

</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
