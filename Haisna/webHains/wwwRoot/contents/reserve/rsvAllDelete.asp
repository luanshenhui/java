<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		ＣＳＶファイルからの一括予約削除 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon		'共通クラス
Dim objContract		'契約情報アクセス用
Dim objCreateCsv	'ＣＳＶファイル作成用
Dim objImport		'個人情報取り込み用
Dim objOrganization	'団体情報アクセス用
Dim objParse		'POSTデータ解析用

'POSTされた情報
Dim strName			'エレメント名
Dim strFileName		'ファイル名
Dim strContentType	'content-type値
Dim strContent		'エレメント値

'引数値
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strCtrPtCd		'契約パターンコード
Dim strCsvFileName	'CSVファイル名
Dim strStartPos		'読み込み開始位置
Dim strReadCount	'読み込みレコード数
Dim strDelCount		'削除受診情報数

'契約情報
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim dtmStrDate		'契約開始日
Dim dtmEndDate		'契約終了日

Dim strUpdUser		'更新者
Dim vntPostedData	'POSTデータ
Dim lngCnt			'POSTデータのサイズ
Dim strOrgName		'団体名称
Dim strMessage		'エラーメッセージ
Dim strURL			'ジャンプ先のURL

Dim objExec			'取り込み処理実行用
Dim strCommand		'コマンドライン文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strOrgCd1    = Request.QueryString("orgCd1")
strOrgCd2    = Request.QueryString("orgCd2")
strCtrPtCd   = Request.QueryString("ctrPtCd")
strStartPos  = Request.QueryString("startPos")
strReadCount = Request.QueryString("readCount")
strDelCount  = Request.QueryString("delCount")

'チェック・更新・読み込み処理の制御
Do

	'引数がQueryStringにて渡されている場合
	If strOrgCd1 <> "" Then
		strMessage = "読み込みレコード数＝" & strReadCount & "、削除受診情報数＝" & strDelCount
		Exit Do
	End If

	'データがPOSTされていなければ何もしない
	lngCnt = Request.TotalBytes
	If lngCnt <= 0 Then
		Exit Do
	End If

	'POSTデータの取得
	vntPostedData = Request.BinaryRead(lngCnt)

	Set objParse = Server.CreateObject("HainsCooperation.Parse")

	'解析
	objParse.ParseMulti Request.ServerVariables("CONTENT_TYPE"), vntPostedData, strName, strFileName, strContentType, strContent

	Set objParse = Nothing

	'引数値の取得
	strOrgCd1      = strContent(0)
	strOrgCd2      = strContent(1)
	strCtrPtCd     = strContent(2)
	strCsvFileName = strFileName(3)
	strStartPos    = strContent(4)

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

	'POSTデータから一時ファイルを作成
	strFileName = objCreateCsv.ConvertStreamToFile(strContent(3))

	Set objCreateCsv = Nothing

	'作成すべき出力ファイル名の定義

	Set objImport = Server.CreateObject("HainsCooperation.Truncate")

	'受診情報の削除
	objImport.DeleteFromCsvFile strFileName, strOrgCd1, strOrgCd2, strUpdUser, strCtrPtCd, CLng("0" & strStartPos), strReadCount, strDelCount

	Set objImport = Nothing

	Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

	'一時ファイルを削除
	objCreateCsv.DeleteFile strFileName

	Set objCreateCsv = Nothing

'	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\ImportPerson.vbs"
'	strCommand = strCommand & " " & strFileName
'	strCommand = strCommand & " " & strOrgCd1
'	strCommand = strCommand & " " & strOrgCd2
'	strCommand = strCommand & " " & strUpdUser
'	strCommand = strCommand & " " & strCtrPtCd
'
'	'取り込み処理起動
'	Set objExec = Server.CreateObject("HainsCooperation.Exec")
'	objExec.Run strCommand
'	strWritePersonCount = "0"

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="    & strOrgCd1
	strURL = strURL & "&orgCd2="    & strOrgCd2
	strURL = strURL & "&ctrPtCd="   & strCtrPtCd
	strURL = strURL & "&startPos="  & strStartPos
	strURL = strURL & "&readCount=" & strReadCount
	strURL = strURL & "&delCount="  & strDelCount
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim strMessage	'エラーメッセージの集合
	Dim i			'インデックス

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'団体コードのチェック
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "団体を指定して下さい。"
	End If

	'契約パターンコードのチェック
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "契約パターンを指定して下さい。"
	End If

	'CSVファイルのチェック
	If strCsvFileName = "" Then
		objCommon.appendArray strMessage, "ＣＳＶファイルを指定して下さい。"
	End If

	'読み込み開始位置のチェック
	If strStartPos <> "" Then
		For i = 1 To Len(strStartPos)
			If InStr("0123456789", Mid(strStartPos, i, 1)) <= 0 Then
				objCommon.appendArray strMessage, "読み込み開始位置は０以上の数字で指定して下さい。"
				Exit For
			End If
		Next
	End If

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

	Set objCommon = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＣＳＶファイルからの予約一括削除</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab  { background-color:#ffffff }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );
		orgPostGuide_getPatternElement( ctrPtCd, 'csName', 'strDate', 'endDate');
	}

}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ENCTYPE="multipart/form-data" ONSUBMIT="javascript:return confirm('この内容で削除処理を行います。よろしいですか？')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">ＣＳＶファイルからの予約一括削除</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Do

		'件数未指定時は通常のメッセージ編集
		If strDelCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

		'受診情報の更新メッセージ
		If strDelCount = "0" Then
			strMessage = strMessage & "<BR>受診情報は削除されませんでした。"
		Else
			strMessage = strMessage & "<BR>" & strDelCount & "件の受診情報が削除されました。"
		End If

		EditMessage strMessage & "<BR>詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

'		EditMessage "ＣＳＶファイルからの一括予約処理が開始されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		Exit Do
	Loop
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
<%
	'団体名称の読み込み
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then

		Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If

		Set objOrganization = Nothing

	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="130" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	'契約情報の読み込み
	If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then

		Set objContract = Server.CreateObject("HainsContract.Contract")

		If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
			Err.Raise 1000, ,"契約情報が存在しません。"
		End If

		Set objContract = Nothing

	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="130" NOWRAP>契約パターン</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="契約パターン検索ガイドを表示"></A></TD>
<%
			Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy年m月d日"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "～yyyy年m月d日"), "") %></SPAN>
			</TD>
<%
			Set objCommon = Nothing
%>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="130" NOWRAP>ＣＳＶファイル</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="file" NAME="csvFileName" SIZE="50"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="130" NOWRAP>読み込み開始位置</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="startPos" SIZE="3" VALUE="<%= strStartPos %>" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で削除する">
    <%  end if  %>

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&amp;transactionDiv=LOGRSVDEL"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>