<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		労基署所属情報メンテナンス(メイン画面) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
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
Const STARTPOS        = 1			'開始位置のデフォルト値
Const GETCOUNT        = 20			'表示件数のデフォルト値

'COMコンポーネント
Dim objOrganization		'団体情報アクセス用
Dim objOrgPost			'所属情報アクセス用

'引数値（本スクリプトを呼び出す際の引数情報を定義します）
Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strActMode			'動作モード(保存:"save"、保存完了:"saved")
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgWkPostCd		'労基署所属コード
Dim strOrgWkPostName	'労基署所属名
Dim strOrgWkPostSeq		'労基署所属ＳＥＱ
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'所属情報
Dim strArrOrgBsdCd		'事業部コード
Dim strArrOrgRoomCd		'室部コード
Dim strArrOrgPostCd		'所属コード
Dim strArrOrgPostName	'所属名称
Dim strArrOrgPostKName	'所属カナ名称
Dim strArrOrgBsdName	'事業部名称
Dim strArrOrgBsdKName	'事業部カナ名称
Dim strArrOrgRoomName	'室部名称
Dim strArrOrgRoomKName	'室部カナ名称

'作業用の変数
Dim strOrgSName			'団体略称
Dim lngCount			'レコード件数
Dim strArrMessage		'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim strURL2				'ジャンプ先のURL
Dim Ret					'関数戻り値
Dim i, j				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'引数値の取得
strMode          = Request("mode")
strActMode       = Request("actMode")
strOrgCd1        = Request("orgCd1")
strOrgCd2        = Request("orgCd2")
strOrgWkPostCd   = Request("orgWkPostCd")
strOrgWkPostName = Request("orgWkPostName")
strOrgWkPostSeq  = Request("orgWkPostSeq")
lngStartPos      = Request("startPos")
lngGetCount      = Request("getCount")

'引数省略時のデフォルト値設定
strMode     = IIf(strMode = "", MODE_INSERT, strMode)
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'チェック・更新・読み込み処理の制御
Do

	'削除時の処理
	If strActMode = ACTMODE_DELETE Then

		'労基署所属テーブルレコード削除
		Ret = objOrgPost.DeleteOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd)
		If Ret = 0 Then
			strArrMessage = Array("この労基署所属を参照している所属情報が存在します。削除できません。")
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

			'労基署所属テーブルレコード更新
			Ret = objOrgPost.UpdateOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName)

			'レコードが存在しない場合は新規時の処理を行う
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'挿入の場合
		If strMode = MODE_INSERT Then

			'労基署所属テーブルレコード挿入
			Ret = objOrgPost.InsertOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName)

			'キー重複時はエラーメッセージを編集する
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("同一団体、労基署所属コードの労基署所属情報がすでに存在します。")
				Exit Do
			End If

		End If

		'保存に成功した場合は更新モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="        & MODE_UPDATE
		strURL = strURL & "&actMode="     & ACTMODE_SAVED
		strURL = strURL & "&orgCd1="      & strOrgCd1
		strURL = strURL & "&orgCd2="      & strOrgCd2
		strURL = strURL & "&orgWkPostCd=" & strOrgWkPostCd
		Response.Redirect strURL
		Response.End

	End If

	'新規の場合は読み込みを行わない
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'労基署所属テーブルレコード読み込み
	objOrgPost.SelectOrgWkPost strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq

	'処理モードを更新とする
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 各値の妥当性チェックを行う
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

		'労基署所属コード
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("労基署所属コード", strOrgWkPostCd, 10, CHECK_NECESSARY)

		'労基署所属名称
		.AppendArray vntArrMessage, .CheckWideValue("労基署所属名称", strOrgWkPostName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

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
<TITLE>労基署所属情報メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winAllocOrgPost;	// 所属割り当て画面のウィンドウハンドル

// ガイド画面呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, '', 'orgSName', '' );

}

// submit時の処理
function submitForm( actMode ) {

	// 削除時は確認メッセージを表示
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( 'この労基署所属情報を削除します。よろしいですか？' ) ) {
			return;
		}
	}

	// 動作モードを指定してsubmit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}

// 所属割り当て画面呼び出し
function callAllocOrgPostWindow() {

	var opened = false;					// 画面が開かれているか
	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var url;							// 団体・コース変更画面のURL

	// すでにガイドが開かれているかチェック
	if ( winAllocOrgPost != null ) {
		if ( !winAllocOrgPost.closed ) {
			opened = true;
		}
	}

	// 団体変更画面のURL編集
	url = 'mntAllocOrgPost.asp';
	url = url + '?orgCd1='      + myForm.orgCd1.value;
	url = url + '&orgCd2='      + myForm.orgCd2.value;
	url = url + '&orgWkPostCd=' + myForm.orgWkPostCd.value;

	// 開かれている場合は画面をFOCUSし、さもなくば新規画面を開く
	if ( opened ) {
		winAllocOrgPost.focus();
	} else {
		winAllocOrgPost = window.open( url, '', 'status=yes,toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=300' );
	}

}

// 画面を閉じる
function closeWindow() {

	// 所属割り当て画面を閉じる
	if ( winAllocOrgPost ) {
		if ( !winAllocOrgPost.closed ) {
			winAllocOrgPost.close();
		}
	}

	winAllocOrgPost = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">労基署所属情報メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						strURL = "mntSearchOrgWkPost.asp"
						strURL = strURL & "?orgCd1=" & strOrgCd1
						strURL = strURL & "&orgCd2=" & strOrgCd2
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="労基署所属の検索画面に戻る"></A></TD>
<%
						'更新時は削除ボタンを表示する
						If strMode = "update" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この労基署所属情報を削除します"></A></TD>
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
	<INPUT TYPE="hidden" NAME="orgWkPostSeq" VALUE="<%= strOrgWkPostSeq %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>団体</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						Do
							'団体コード未指定の場合はガイドボタンを表示する
							If strOrgCd1 = "" Or strOrgCd2 = "" Then
%>
								<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
								<TD>&nbsp;</TD>
<%
								Exit Do
							End If

							'団体情報読み込み
							Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
							objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName

							Exit Do
						Loop
%>
						<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>労基署所属コード</TD>
<%
			'挿入モードの場合はテキスト表示を行い、更新モードの場合はhiddenでコードを保持
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgWkPostCd" SIZE="13" MAXLENGTH="10" VALUE="<%= strOrgWkPostCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgWkPostCd" VALUE="<%= strOrgWkPostCd %>"><%= strOrgWkPostCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>労基署所属名称</TD>
			<TD><INPUT TYPE="text" NAME="orgWkPostName" SIZE="104" MAXLENGTH="40" VALUE="<%= strOrgWkPostName %>" STYLE="ime-mode:active;"></TD>
		</TR>
	</TABLE>
<%
	Do

		'更新モード以外は何もしない
		If strMode <> MODE_UPDATE Then
			Exit Do
		End If
%>
		<BR><BR>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="650">
			<TR>
				<TD NOWRAP>この労基署所属を参照している所属情報</TD>
				<TD ALIGN="right" NOWRAP><A HREF="javascript:callAllocOrgPostWindow()">所属を範囲指定してこの労基署所属への参照を行う</A></TD>
			</TR>
			<TR>
				<TD COLSPAN="2" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'検索条件を満たすレコード件数を取得
		lngCount = objOrgPost.SelectOrgPostListFromOrgWkPostSeq(strOrgCd1, strOrgCd2, strOrgWkPostSeq, lngStartPos, lngGetCount, strArrOrgBsdCd, strArrOrgRoomCd, strArrOrgPostCd, strArrOrgPostName, strArrOrgPostKName, strArrOrgBsdName, strArrOrgBsdKName, strArrOrgRoomName,  strArrOrgRoomKName)

		'検索結果が存在しない場合はメッセージを編集
		If lngCount = 0 Then
%>
			<IMG SRC="/webHains/images/spacer.gif" WIDTH="15" HEIGHT="1" ALT="">所属情報はありません。
<%
			Exit Do
		End If
%>
		<IMG SRC="/webHains/images/spacer.gif" WIDTH="15" HEIGHT="1" ALT=""><FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件の所属情報があります。<BR><BR>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>コード</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>所属名称</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>事業部</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>室部</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="8"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			'所属情報メンテナンスから戻れるよう、本画面のURLを編集
			strURL2 = Request.ServerVariables("SCRIPT_NAME")
			strURL2 = strURL2 & "?mode="        & MODE_UPDATE
			strURL2 = strURL2 & "&orgCd1="      & strOrgCd1
			strURL2 = strURL2 & "&orgCd2="      & strOrgCd2
			strURL2 = strURL2 & "&orgWkPostCd=" & strOrgWkPostCd

			For i = 0 To UBound(strArrOrgBsdCd)

				'所属選択時のURLを編集
				strURL = "/webHains/contents/maintenance/orgPost/mntOrgPost.asp"
				strURL = strURL & "?mode="      & "update"
				strURL = strURL & "&orgCd1="    & strOrgCd1
				strURL = strURL & "&orgCd2="    & strOrgCd2
				strURL = strURL & "&orgBsdCd="  & strArrOrgBsdCd(i)
				strURL = strURL & "&orgRoomCd=" & strArrOrgRoomCd(i)
				strURL = strURL & "&orgPostCd=" & strArrOrgPostCd(i)
				strURL = strURL & "&prevURL="   & Server.URLEncode(strURL2)

				'所属情報の編集
%>
				<TR>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><%= strArrOrgPostCd(i) %></TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><A HREF="<%= strURL %>"><%= strArrOrgPostName(i) %></A></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgBsdName(i) %></FONT></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgRoomName(i) %></FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'ページングナビゲータの編集
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="        & MODE_UPDATE
		strURL = strURL & "&orgCd1="      & strOrgCd1
		strURL = strURL & "&orgCd2="      & strOrgCd2
		strURL = strURL & "&orgWkPostCd=" & strOrgWkPostCd
%>
		<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
