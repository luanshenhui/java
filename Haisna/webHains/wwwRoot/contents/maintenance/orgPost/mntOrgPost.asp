<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		所属情報メンテナンス(メイン画面) (Ver0.0.1)
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
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgRoom			'室部情報アクセス用
Dim objOrgPost			'所属情報アクセス用

'引数値（本スクリプトを呼び出す際の引数情報を定義します）
Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strActMode			'動作モード(保存:"save"、保存完了:"saved")
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strOrgPostCd		'所属コード
Dim strOrgPostKName		'所属カナ名称
Dim strOrgPostName		'所属
Dim strOrgWkPostSeq		'労基署所属ＳＥＱ
Dim strPrevURL			'前画面のURL

'作業用の変数
Dim strOrgSName			'団体略称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strOrgWkPostName	'労基署所属名称
Dim strArrMessage		'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")

'引数値の取得
strMode         = Request("mode")
strActMode      = Request("actMode")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strOrgPostCd    = Request("orgPostCd")
strOrgPostName  = Request("orgPostName")
strOrgPostKName	= Request("orgPostKName")
strOrgWkPostSeq = Request("orgWkPostSeq")
strPrevURL      = Request("prevURL")

'処理モード未指定時は挿入モードとする
strMode = IIf(strMode = "", MODE_INSERT, strMode)

'チェック・更新・読み込み処理の制御
Do

	'削除時の処理
	If strActMode = ACTMODE_DELETE Then

		'所属テーブルレコード削除
		Ret = objOrgPost.DeleteOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd)
		If Ret = 0 Then
			strArrMessage = Array("この所属は他から参照されています。削除できません。")
			Exit Do
		End If

		'削除に成功した場合は挿入モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="    & MODE_INSERT
		strURL = strURL & "&actMode=" & ACTMODE_DELETED
		strURL = strURL & "&orgCd1="  & strOrgCd1
		strURL = strURL & "&orgCd2="  & strOrgCd2
		strURL = strURL & "&prevURL=" & Server.URLEncode(strPrevURL)
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

			'所属テーブルレコード更新
			Ret = objOrgPost.UpdateOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostKName, strOrgWkPostSeq)

			'レコードが存在しない場合は新規時の処理を行う
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'挿入の場合
		If strMode = MODE_INSERT Then

			'所属テーブルレコード挿入
			Ret = objOrgPost.InsertOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostKName, IIf(strOrgWkPostSeq <> "", strOrgWkPostSeq, 0))

			'キー重複時はエラーメッセージを編集する
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("同一団体、事業部、室部、所属コードの所属情報がすでに存在します。")
				Exit Do
			End If

		End If

		'保存に成功した場合は更新モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="      & MODE_UPDATE
		strURL = strURL & "&actMode="   & ACTMODE_SAVED
		strURL = strURL & "&orgCd1="    & strOrgCd1
		strURL = strURL & "&orgCd2="    & strOrgCd2
		strURL = strURL & "&orgBsdCd="  & strOrgBsdCd
		strURL = strURL & "&orgRoomCd=" & strOrgRoomCd
		strURL = strURL & "&orgPostCd=" & strOrgPostCd
		strURL = strURL & "&prevURL="   & Server.URLEncode(strPrevURL)
		Response.Redirect strURL
		Response.End

	End If

	'新規の場合は読み込みを行わない
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'所属テーブルレコード読み込み
	If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostKName, , , , , , , , strOrgWkPostSeq) = False Then
		Err.Raise 1000, , "所属情報が存在しません。"
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

	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合
	Dim strMessage		'エラーメッセージ

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon

		'団体コード
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			.AppendArray vntArrMessage, "団体を入力して下さい。"
		End If

		'事業部コード
		If strOrgBsdCd = "" Then
			.AppendArray vntArrMessage, "事業部を入力して下さい。"
		End If

		'室部コード
		If strOrgRoomCd = "" Then
			.AppendArray vntArrMessage, "室部を入力して下さい。"
		End If

		'所属コード
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("所属コード", strOrgPostCd, LENGTH_ORGBSD_ORGBSDCD, CHECK_NECESSARY)

		'所属カナ名称
		strMessage = .CheckWideValue("所属カナ名称", strOrgPostKName,  LENGTH_ORGBSD_ORGBSDKNAME)
		If strMessage = "" Then
			If .CheckKana(strOrgPostKName) = False Then
				strMessage = "所属カナ名称に不正な文字が含まれます。"
			End If
		End If
		.AppendArray vntArrMessage, strMessage

		'所属名称
		.AppendArray vntArrMessage, .CheckWideValue("所属名称", strOrgPostName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

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
<TITLE>所属情報メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc"   -->
<!-- #include virtual = "/webHains/includes/orgWkPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 事業部検索ガイド画面呼び出し
function callOrgBsdGuide() {

	orgPostGuide_getElement( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', document.entryForm.orgBsdCd, 'orgBsdName', document.entryForm.orgRoomCd, 'orgRoomName', '', '', '', '' );
	orgPostGuide_showGuideOrgBsd();

}

// 室部検索ガイド画面呼び出し
function callOrgRoomGuide() {

	orgPostGuide_getElement( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', document.entryForm.orgBsdCd, 'orgBsdName', document.entryForm.orgRoomCd, 'orgRoomName', '', '', '', '' );
	orgPostGuide_showGuideOrgRoom();

}

// 労基署所属検索ガイド画面呼び出し
function callOrgWkPostGuide() {

	with ( document.entryForm ) {
		orgWkPostGuide_showGuideOrg( orgCd1.value, orgCd2.value, orgWkPostSeq, 'orgWkPostName' );
	}

}

// 労基署所属情報のクリア
function clearOrgWkPostInfo() {

	with ( document.entryForm ) {
		orgWkPostGuide_clearOrgWkPostInfo( orgWkPostSeq, 'orgWkPostName' );
	}

}

// submit時の処理
function submitForm( actMode ) {

	// 削除時は確認メッセージを表示
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( 'この所属情報を削除します。よろしいですか？' ) ) {
			return;
		}
	}

	// 動作モードを指定してsubmit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}

// ガイド画面を閉じる
function closeWindow() {

	orgGuide_closeGuideOrg();
	orgWkPostGuide_closeGuideOrgWkPost();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">
	<INPUT TYPE="hidden" NAME="prevURL" VALUE="<%= strPrevURL %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">所属情報メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						'前画面のURL編集
						If strPrevURL = "" Then
							strURL = "mntSearchOrgPost.asp"
							strURL = strURL & "?orgCd1=" & strOrgCd1
							strURL = strURL & "&orgCd2=" & strOrgCd2
						Else
							strURL = strPrevURL
						End If
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="<%= IIf(strPrevURL <> "", "労基署所属メンテナンス画面に戻る", "所属の検索画面に戻る") %>"></A></TD>
<%
						'更新時は削除ボタンを表示する
						If strMode = "update" And strOrgPostCd <> "0000000000" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この所属情報を削除します"></A></TD>
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

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="orgWkPostSeq" VALUE="<%= strOrgWkPostSeq %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>団体</TD>
<%
			'団体コードが指定されている場合は団体情報を読み込み
			If strOrgCd1 <> "" And strOrgCd2 <> "" Then
				objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName
			End If
%>
			<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>事業部</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
<%
						'挿入モードの場合はガイドボタンを表示する
						If strMode = MODE_INSERT Then
%>
							<TD><A HREF="javascript:callOrgBsdGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
<%
						End If

						'団体、事業部が指定されている場合
						If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" Then

							'事業部情報読み込み
							objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName

						End If
%>
						<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>室部</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
<%
						'挿入モードの場合はガイドボタンを表示する
						If strMode = MODE_INSERT Then
%>
							<TD><A HREF="javascript:callOrgRoomGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
<%
						End If

						'団体、事業部、室部が指定されている場合
						If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" And strOrgRoomCd <> "" Then

							'室部情報読み込み
							objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName

						End If
%>
						<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="12"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>所属コード</TD>
<%
			'挿入モードの場合はテキスト表示を行い、更新モードの場合はhiddenでコードを保持
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgPostCd" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDCD) %>" MAXLENGTH="<%= LENGTH_ORGBSD_ORGBSDCD %>" VALUE="<%= strOrgPostCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgPostCd" VALUE="<%= strOrgPostCd %>"><%= strOrgPostCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>所属カナ名称</TD>
			<TD><INPUT TYPE="text" NAME="orgPostKName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" VALUE="<%= strOrgPostKName %>" STYLE="ime-mode:active;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>所属名称</TD>
			<TD><INPUT TYPE="text" NAME="orgPostName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDNAME) %>" VALUE="<%= strOrgPostName %>" STYLE="ime-mode:active;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="12"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>労基署所属</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:callOrgWkPostGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="労基署所属検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgWkPostInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
<%
						'労基署所属ＳＥＱが指定されている場合
						If strOrgWkPostSeq <> "" Then

							'労基署所属情報読み込み
							objOrgPost.SelectOrgWkPostFromSeq strOrgWkPostSeq, , strOrgWkPostName

						End If
%>
						<TD NOWRAP><SPAN ID="orgWkPostName"><%= strOrgWkPostName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
