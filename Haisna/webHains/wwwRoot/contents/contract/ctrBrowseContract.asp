<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(契約情報の参照・コピー) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const OPMODE_BROWSE  = "browse"	'処理モード(参照)
Const OPMODE_COPY    = "copy"	'処理モード(コピー)

'データベースアクセス用オブジェクト
Dim objOrganization		'団体情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用

'前画面から送信されるパラメータ値(参照・コピー共通)
Dim strOpMode			'処理モード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード
Dim strRefOrgCd1		'参照先団体コード1
Dim strRefOrgCd2		'参照先団体コード2

'前画面から送信されるパラメータ値(コピー時のみ)
Dim lngStrYear			'契約開始年
Dim lngStrMonth 		'契約開始月
Dim lngStrDay			'契約開始日
Dim lngEndYear			'契約終了年
Dim lngEndMonth 		'契約終了月
Dim lngEndDay			'契約終了日

'自身をリダイレクトする場合のみ送信されるパラメータ値
Dim strCtrPtCd			'契約パターンコード

'契約管理情報
Dim strOrgName			'団体名
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日
Dim strStrDate			'編集用の契約開始日
Dim strEndDate			'編集用の契約終了日

'参照先団体の契約情報
Dim strRefOrgName		'参照先契約団体名
Dim strRefCtrPtCd		'契約パターンコード
Dim strRefStrDate		'契約開始日
Dim strRefEndDate		'契約終了日
Dim blnOrgEquals		'参照先団体一致フラグ(参照先団体の参照先が参照元団体と等しい場合にTrue)
Dim blnReferred			'参照済みフラグ(参照先団体の契約情報がすでに参照元団体から参照されている場合にTrue)
Dim blnOverlap			'契約期間重複フラグ(参照先団体の契約期間が参照元団体のそれと重複する場合にTrue)
Dim blnExistBdn 		'負担元存在フラグ(参照先団体の負担元として参照元団体が存在する場合にTrue)
Dim lngCount			'参照先団体の契約情報数

'エラーメッセージ
Dim strMsgOrgEquals		'参照先団体一致時
Dim strMsgReferred		'契約情報既存在時
Dim strMsgOverlap		'契約期間重複時
Dim strMsgExistBdn		'負担元存在時

Dim strMessage			'エラーメッセージ
Dim blnBrowseCopy		'参照・コピー処理が可能か
Dim strOpName			'処理名
Dim strURL				'URL文字列
Dim Ret					'関数戻り値
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'前画面から送信されるパラメータ値の取得
strOpMode    = Request("opMode")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strCsCd      = Request("csCd")
strRefOrgCd1 = Request("refOrgCd1")
strRefOrgCd2 = Request("refOrgCd2")

'前画面から送信されるパラメータ値の取得(コピー時のみ)
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))

'自身をリダイレクトする場合のみ送信されるパラメータ値
strCtrPtCd = Request("ctrPtCd")

'処理名の編集
strOpName = IIf(strOpMode = OPMODE_BROWSE, "参照", "コピー")

'エラーメッセージの編集
strMsgOrgEquals = "参照先団体が契約団体自身の契約を参照しています。"
strMsgReferred  = "この契約情報はすでに契約団体自身から参照されています。"
strMsgOverlap   = "契約団体の現契約情報と契約期間が重複するため、" & strOpName & "することはできません。"
strMsgExistBdn  = "契約団体自身が負担元として存在する契約情報の" & strOpName & "はできません。"

'チェック・更新・読み込み処理の制御
Do
	'契約パターンコードが渡されていない場合は制御処理を抜ける
	If strCtrPtCd = "" Then
		Exit Do
	End If

	'処理モードごとの処理
	Select Case strOpMode

		'参照の場合
		Case OPMODE_BROWSE

			'契約情報の参照処理
			Ret = objContractControl.Refer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 1: strMessage = strMsgOrgEquals
				Case 2: strMessage = strMsgReferred
				Case 3: strMessage = strMsgOverlap
				Case 4: strMessage = strMsgExistBdn
			End Select

		'コピーの場合
		Case OPMODE_COPY

			'契約情報のコピー処理
			Ret = objContractControl.Copy(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd, lngStrYear, lngStrMonth, lngStrDay, lngEndYear, lngEndMonth ,lngEndDay)
			Select Case Ret
				Case 1: strMessage = "すでに登録済みの契約情報と契約期間が重複するため、" & strOpName & "できません。"
				Case 2: strMessage = strMsgExistBdn
			End Select

	End Select

	'エラー発生時は処理を終了する
	If strMessage <> "" Then
		Exit Do
	End If

	'エラーがなければ処理完了ページへ
	Response.Redirect "ctrFinished.asp?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>契約情報の選択</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約情報の選択</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'団体名の読み込み
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If

	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
<%
		'処理モードがコピーの場合は先に入力した契約期間を編集する
		If strOpMode = OPMODE_COPY Then

			'契約開始年月日の取得
			If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
				dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
			End If

			'契約終了年月日の取得
			If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
				dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
			End If

			'編集用の契約開始日設定
			If dtmStrDate > 0 Then
				strStrDate = FormatDateTime(dtmStrDate, 1)
			End If

			'編集用の契約終了日設定
			If dtmEndDate > 0 Then
				strEndDate = FormatDateTime(dtmEndDate, 1)
			End If
%>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD>契約期間</TD>
				<TD>：</TD>
				<TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
			</TR>
<%
		End If
%>
	</TABLE>

	<BR>
<%
	'参照先契約団体名の読み込み
	If objOrganization.SelectOrg_Lukes(strRefOrgCd1, strRefOrgCd2, , , strRefOrgName) = False Then
		Err.Raise 1000, , "参照先団体情報が存在しません。"
	End If
%>
	参照先契約団体：<B><%= strRefOrgName %></B>

	<BR>
	<BR>
<%
	'現在編集中コースに対する参照先団体契約情報の参照・コピー処理可否を取得する
	lngCount = objContract.SelectCtrMngRefer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCsCd, strRefCtrPtCd, strRefStrDate, strRefEndDate, blnOrgEquals, blnReferred, blnOverlap, blnExistBdn)
	If lngCount = 0 Then
		Err.Raise 1000, , "参照先団体の契約情報が存在しません。"
	End If

	'参照・コピー可能な契約情報が存在するかをチェックする
	blnBrowseCopy = False
	If strOpMode = OPMODE_BROWSE Then
		For i = 0 To lngCount - 1
			If blnOrgEquals(i) = False And blnReferred(i) = False And blnOverlap(i) = False And blnExistBdn(i) = False Then
				blnBrowseCopy = True
				Exit For
			End If
		Next
	Else
		For i = 0 To lngCount - 1
			If blnExistBdn(i) = False Then
				blnBrowseCopy = True
				Exit For
			End If
		Next
	End If

	'参照・コピーの可否に応じたメッセージの編集
	If blnBrowseCopy Then
%>
		<FONT COLOR="#cc9999">●</FONT><%= strOpName %>を行う契約情報を以下から選択して下さい。<BR><BR>
<%
	Else
%>
		<FONT COLOR="#cc9999">●</FONT><%= strOpName %>可能な契約情報は存在しませんでした。<BR><BR>
<%
	End If

	'URL文字列の編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?opMode="    & strOpMode
	strURL = strURL & "&orgCd1="    & strOrgCd1
	strURL = strURL & "&orgCd2="    & strOrgCd2
	strURL = strURL & "&csCd="      & strCsCd
	strURL = strURL & "&refOrgCd1=" & strRefOrgCd1
	strURL = strURL & "&refOrgCd2=" & strRefOrgCd2

	'処理モードがコピーの場合は更に契約期間をQuery文字列として編集する
	If strOpMode = OPMODE_COPY Then
		strURL = strURL & "&strYear="  & lngStrYear
		strURL = strURL & "&strMonth=" & lngStrMonth
		strURL = strURL & "&strDay="   & lngStrDay
		strURL = strURL & "&endYear="  & lngEndYear
		strURL = strURL & "&endMonth=" & lngEndMonth
		strURL = strURL & "&endDay="   & lngEndDay
	End If
%>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD>契約期間</TD>
			<TD>備考</TD>
		</TR>
<%
		'契約期間とそれぞれの参照・コピー処理可否を編集する
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD HEIGHT="20"><%= strRefStrDate(i) %>～<%= strRefEndDate(i) %></TD>
				<TD>
<%
					Do
						'処理モードが参照の場合は次の3つのチェック処理を行う
						If strOpMode = OPMODE_BROWSE Then

							'契約団体自身の契約情報を参照している場合
							'(※本フラグ成立時は必ず参照済みフラグ・契約期間重複フラグも成立するため、先にチェックする必要がある)
							If blnOrgEquals(i) Then
%>
								<FONT COLOR="#666666">（<%= strMsgOrgEquals %>）</FONT>
<%
								Exit Do
							End If

							'すでに契約団体自身から参照されている場合
							'(※本フラグ成立時は必ず契約期間重複フラグも成立するため、先にチェックする必要がある)
							If blnReferred(i) Then
%>
								<FONT COLOR="#666666">（<%= strMsgReferred %>）</FONT>
<%
								Exit Do
							End If

							'契約期間が重複する場合
							If blnOverlap(i) Then
%>
								<FONT COLOR="#666666">（<%= strMsgOverlap %>）</FONT>
<%
								Exit Do
							End If

						End If

						'契約団体が参照先契約団体契約情報の負担元として存在する場合
						If blnExistBdn(i) Then
%>
							<FONT COLOR="#666666">（<%= strMsgExistBdn %>）</FONT>
<%
							Exit Do
						End If

						'ここまでエラー対象にならなければ参照(コピー)処理用のアンカーを編集
%>
						<A HREF="<%= strURL & "&ctrPtCd=" & strRefCtrPtCd(i) %>">この契約情報を<%= strOpName %>する</A>
<%
						Exit Do
					Loop
%>
				</TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
