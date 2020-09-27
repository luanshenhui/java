<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約確認メール送信 (Ver1.0.0)
'		AUTHER  : Tsutomu Takagi@RD
'-----------------------------------------------------------------------------
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.5
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objSender			'メール送信コンポーネント
Dim objTemplate			'メールテンプレート情報アクセス用

'引数値
Dim strMode				'動作モード
Dim lngStrYear			'受診開始年
Dim lngStrMonth			'受診開始月
Dim lngStrDay			'受診開始日
Dim lngEndYear			'受診終了年
Dim lngEndMonth			'受診終了月
Dim lngEndDay			'受診終了日
Dim strCsCd				'コースコード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strPerId			'個人ID
Dim lngStatus			'状態(0:すべて、1:未送信、2:送信済み)
Dim strTemplateCd		'テンプレートコード
Dim strRsvNo			'予約番号
Dim lngSendCount		'送信件数

'受診情報
Dim strArrRsvNo			'予約番号の配列
Dim strArrCslDate		'受診日の配列
Dim strArrCsName		'コース略称の配列
Dim strArrWebColor		'webカラーの配列
Dim strArrRsvGrpName	'予約群名称の配列
Dim strArrPerId			'個人IDの配列
Dim strArrLastName		'姓の配列
Dim strArrFirstName		'名の配列
Dim strArrLastKName		'カナ姓の配列
Dim strArrFirstKName	'カナ名の配列
Dim strArrGender		'性別の配列
Dim strArrBirth			'生年月日の配列
Dim strArrAge			'受診時年齢の配列
Dim strArrOrgSName		'団体略称の配列
Dim strArrSendMailDiv	'予約確認メール送信先の配列
Dim strArrEmail			'e-Mailの配列
Dim strArrSendMailDate	'予約確認メール送信日時の配列
Dim lngCount			'レコード件数

'メールテンプレート情報
Dim strArrTemplateCd	'テンプレートコードの配列
Dim strArrTemplateName	'テンプレート名の配列

Dim strOrgSName			'団体略称
Dim strLastName			'姓
Dim strFirstName		'名
Dim strPerName			'個人氏名
Dim dtmStrCslDate		'開始受診年月日
Dim dtmEndCslDate		'終了受診年月日
Dim strSendMailDivName	'予約確認メール送信先名
Dim blnEnabled			'受診情報の選択可否
Dim strUrl				'URL
Dim strMessage			'エラーメッセージ
Dim strWkMessage		'メッセージ
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode      = Request("mode")
lngStrYear   = CLng("0" & Request("strYear"))
lngStrMonth  = CLng("0" & Request("strMonth"))
lngStrDay    = CLng("0" & Request("strDay"))
lngEndYear   = CLng("0" & Request("endYear"))
lngEndMonth  = CLng("0" & Request("endMonth"))
lngEndDay    = CLng("0" & Request("endDay"))
strCsCd      = Request("csCd")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strPerId     = Request("perId")
lngStatus    = CLng("0" & Request("status"))
lngSendCount = CLng("0" & Request("count"))

'引数値の取得(テンプレートコード、予約番号)
strTemplateCd = Request("templateCd")
strRsvNo      = IIf(Request("rsvNo") <> "", ConvIStringToArray(Request("rsvNo")), Empty)

'受診開始、終了日のデフォルト値設定
lngStrYear  = IIf(lngStrYear  = 0, Year(Date),  lngStrYear)
lngStrMonth = IIf(lngStrMonth = 0, Month(Date), lngStrMonth)
lngStrDay   = IIf(lngStrDay   = 0, Day(Date),   lngStrDay)
lngEndYear  = IIf(lngEndYear  = 0, Year(Date),  lngEndYear)
lngEndMonth = IIf(lngEndMonth = 0, Month(Date), lngEndMonth)
lngEndDay   = IIf(lngEndDay   = 0, Day(Date),   lngEndDay)

'団体名称の取得
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrgSName strOrgCd1, strOrgCd2, strOrgSName
	Set objOrganization = Nothing
End If

'個人氏名の取得
If strPerId <> "" Then
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPerson_lukes strPerId, strLastName, strFirstName
	strPerName = strLastName & "　" & strFirstName
End If

'チェック・更新・読み込み処理の制御
Do

	'モード未指定時は何もしない
	If strMode <> "search" And strMode <> "send" And strMode <> "complete" Then
		strMode = ""
		Exit Do
	End If

	'日付チェック
	If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Or Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
		strMessage = "受診日が正しくありません。"
		Exit Do
	End If

	'送信時
	If strMode = "send" Then

		'予約確認メール送信処理
		Set objSender = Server.CreateObject("HainsMail.Sender")
		lngSendCount = objSender.Send(Session("USERID"), strTemplateCd, strRsvNo)

		'リダイレクト
		strUrl = Request.ServerVariables("SCRIPT_NAME") & _
		         "?mode=complete" & _
		         "&orgCd1="   & strOrgCd1   & _
		         "&orgCd2="   & strOrgCd1   & _
		         "&perId="    & strPerId    & _
		         "&strYear="  & lngStrYear  & _
		         "&strMonth=" & lngStrMonth & _
		         "&strDay="   & lngStrDay   & _
		         "&endYear="  & lngEndYear  & _
		         "&endMonth=" & lngEndMonth & _
		         "&endDay="   & lngEndDay   & _
		         "&csCd="     & strCsCd     & _
		         "&status="   & lngStatus   & _
		         "&count="    & lngSendCount
		Response.Redirect strUrl
		Response.End

	End If

	'各種年月日の編集
	dtmStrCslDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	dtmEndCslDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)

	Set objConsult = Server.CreateObject("HainsMail.Consult")

	'受診情報の検索
	lngCount = objConsult.SelectConsultList( _
		dtmStrCslDate,     _
		dtmEndCslDate,     _
		strCsCd,           _
		strOrgCd1,         _
		strOrgCd2,         _
		strPerId,          _
		lngStatus,         _
		strArrRsvNo,       _
		strArrCslDate,     _
		strArrCsName,      _
		strArrWebColor,    _
		strArrRsvGrpName,  _
		strArrPerId,       _
		strArrLastName,    _
		strArrFirstName,   _
		strArrLastKName,   _
		strArrFirstKName,  _
		strArrGender,      _
		strArrBirth,       _
		strArrAge,         _
		strArrOrgSName,    _
		strArrSendMailDiv, _
		strArrEmail,       _
		strArrSendMailDate _
	)

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
<TITLE>予約確認メール送信</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体ガイド画面呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, null, 'orgname', null, null, null, null, '0' );

}

// 団体クリア
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgname');

}

// 個人ガイド画面呼び出し
function callPersonalGuide() {

	perGuide_showGuidePersonal(document.entryForm.perId, 'perName');

}

// 個人クリア
function clearPerId() {

	perGuide_clearPerInfo(document.entryForm.perId, 'perName');

}

// 画面を閉じる
function closeWindow() {

	// 日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	// 個人検索ガイドを閉じる
	perGuide_closeGuidePersonal();

}

function selectList(checkbox) {

	var rsvNo = document.listForm.rsvNo;

	if ( rsvNo.length !== undefined ) {
		for ( var i = 0; i < rsvNo.length; i++ ) {
			if ( !rsvNo[i].disabled ) {
				rsvNo[i].checked = checkbox.checked;
			}
		}
	} else {
		rsvNo.checked = checkbox.checked;
	}

}

function sendMail() {

	var form = document.listForm;
	var count = 0;
	var message;

	while ( true ) {

		// テンプレート選択状態を判定
		if ( form.templateCd.selectedIndex < 0 ) {
			message = 'テンプレートが選択されていません。';
			break;
		}

		var rsvNo = form.rsvNo;

		// 選択された受診情報数をカウント
		if ( rsvNo.length !== undefined ) {
			for ( var i = 0; i < rsvNo.length; i++ ) {
				if ( rsvNo[i].checked ) {
					count++;
				}
			}
		} else {
			if ( rsvNo.checked ) {
				count = 1;
			}
		}

		// 未選択であれば実行不可とする
		if ( count <= 0 ) {
			message = '受診情報が選択されていません。';
			break;
		}

		break;

	}

	if ( message ) {
		alert(message);
		return false;
	}

	// 確認メッセージの表示
	if ( !confirm('選択された' + count + '件の受診情報に対して確認メールを送信します。\nよろしいですか？') ) {
		return false;
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
	<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
		<INPUT TYPE="hidden" NAME="mode" VALUE="search">
		<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
		<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
		<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="70%">
			<TR>
				<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">予約確認メール送信</FONT></B></TD>
			</TR>
		</TABLE>
<%
		'メッセージの編集
		If strMode = "complete" Then
			If lngSendCount > 0 Then
				strWkMessage = lngSendCount & "件の予約確認メールが送信されました。"
			Else
				strWkMessage = "予約確認メールは送信されませんでした。"
			End If
			EditMessage "送信処理が完了しました。" & strWkMessage, MESSAGETYPE_NORMAL
		Else
			EditMessage strMessage, MESSAGETYPE_WARNING
		End If
%>
		<BR>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD>受診日</TD>
				<TD>：</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
							<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
							<TD>年</TD>
							<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
							<TD>月</TD>
							<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
							<TD NOWRAP>日～</TD>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
							<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
							<TD>年</TD>
							<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
							<TD>月</TD>
							<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
							<TD>日</TD>
						</TR>
					</TABLE>
				</TD>
				<TD ROWSPAN="5" STYLE="vertical-align:bottom"><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
			</TR>
			<TR>
				<TD>コース</TD>
				<TD>：</TD>
				<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
			</TR>
			<TR>
				<TD NOWRAP>団体</TD>
				<TD>：</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
							<TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
							<TD NOWRAP><SPAN ID="orgname"><%= strOrgSName %></SPAN></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD NOWRAP>個人ID</TD>
				<TD>：</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callPersonalGuide()"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
							<TD><A HREF="javascript:clearPerId()"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
							<TD NOWRAP><SPAN ID="perName"><%= strPerName %></SPAN></TD>
						</TR>
					</TABLE>
				<TD>
			</TR>
			<TR>
				<TD NOWRAP>状態</TD>
				<TD>：</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="0" <%= IIf(lngStatus = 0, " CHECKED", "") %>></TD>
							<TD NOWRAP>すべて</TD>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="1" <%= IIf(lngStatus = 1, " CHECKED", "") %>></TD>
							<TD NOWRAP>未送信</TD>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="2" <%= IIf(lngStatus = 2, " CHECKED", "") %>></TD>
							<TD NOWRAP>送信済み</TD>
						</TR>
					</TABLE>
				<TD>
			</TR>
		</TABLE>
	</FORM>
<%
	Do

		'モード未指定時は何もしない
		If strMode = "" Then
			Exit Do
		End If

		'エラー時は何もしない
		If Not IsEmpty(strMessage) Then
			Exit Do
		End If

		'レコードが存在しない場合
		If lngCount <= 0 Then
%>
			<BR>検索条件を満たす受診情報は存在しません。
<%
			Exit Do
		End If

		'メールテンプレート一覧読み込み
		Set objTemplate = Server.CreateObject("HainsMail.Template")
		objTemplate.SelectMailTemplateList strArrTemplateCd, strArrTemplateName

		Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
		「<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(dtmStrCslDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(dtmEndCslDate, "yyyy年m月d日") %></B></FONT>」の受診者一覧を表示しています。<BR>
		受診者数は <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>人です。<BR>
		<FORM NAME="listForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="javascript:return sendMail();">
			<INPUT TYPE="hidden" NAME="mode" VALUE="send">
			<INPUT TYPE="hidden" NAME="strYear" VALUE="<%= lngStrYear %>">
			<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= lngStrMonth %>">
			<INPUT TYPE="hidden" NAME="strDay" VALUE="<%= lngStrDay %>">
			<INPUT TYPE="hidden" NAME="endYear" VALUE="<%= lngEndYear %>">
			<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= lngEndMonth %>">
			<INPUT TYPE="hidden" NAME="endDay" VALUE="<%= lngEndDay %>">
			<INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">
			<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
			<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
			<INPUT TYPE="hidden" NAME="status" VALUE="<%= lngStatus %>">
			<TABLE>
				<TR>
					<TD COLSPAN="14">
						<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
							<TR>
								<TD NOWRAP>メールテンプレートを選択：</TD>
								<TD><%= EditDropDownListFromArray("templateCd", strArrTemplateCd, strArrTemplateName, strTemplateCd, NON_SELECTED_DEL) %></TD>
								<td  WIDTH="100%" >　<a href="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?startPos=1&mode=print&transactionDiv=LOGRSVSEND&Year=<%= Year(Date) %>&Month=<%= Month(Date) %>&Day=<%= Day(Date) %>&transactionID=&searchChar=&informationDiv=&OrderByOld=&pageMaxLine=50
" target="_blank">メール送信ログを表示する</a><td>
								<TD ALIGN="right"><INPUT TYPE="image" SRC="/webHains/images/send.gif" ALT="送信"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<TR BGCOLOR="#cccccc">
					<TD><INPUT TYPE="checkbox" ONCLICK="javascript:selectList(this)"></TD>
					<TD>受診日</TD>
					<TD>コース</TD>
					<TD>予約群</TD>
					<TD>予約番号</TD>
					<TD>個人ID</TD>
					<TD>個人名称</TD>
					<TD>性</TD>
					<TD>生年月日</TD>
					<TD>年齢</TD>
					<TD>団体</TD>
					<TD>送信対象</TD>
					<TD>メールアドレス</TD>
					<TD>最終送信日時</TD>
				</TR>
<%
				For i = 0 To lngCount - 1

					blnEnabled = True

					'予約確認メール送信先の名称変換、及び受診情報の選択可否判定
					Select Case strArrSendMailDiv(i)
						Case 1
							strSendMailDivName = "住所（自宅）"
						Case 2
							strSendMailDivName = "住所（勤務先）"
						Case 3
							strSendMailDivName = "住所（その他）"
						Case Else
							strSendMailDivName = "なし"
							blnEnabled = False
					End Select

					'メールアドレスが存在しない場合は受診情報選択不可
					If strArrEmail(i) = "" Then
						blnEnabled = False
					End If
%>
					<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" VALIGN="top">
						<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strArrRsvNo(i) %>"<%= IIf(Not blnEnabled, " DISABLED", "") %>></TD>
<%
						strUrl = "/webHains/contents/reserve/rsvMain.asp?rsvNo=" & strArrRsvNo(i)
%>
						<TD NOWRAP><A HREF="<%= strUrl %>" TARGET="_blank"><%= strArrCslDate(i) %></A></TD>
						<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">■</FONT><%= strArrCsName(i) %></TD>
						<TD NOWRAP><%= strArrRsvGrpName(i) %></TD>
						<TD NOWRAP><a href="<%= strUrl %>" target="_blank"><%= strArrRsvNo(i) %></a></TD>
<%
						strUrl = "/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=" & strArrPerId(i)
%>
						<TD NOWRAP><A HREF="<%= strUrl %>" TARGET="_blank"><%= strArrPerId(i) %></A></TD>
						<TD NOWRAP><SPAN STYLE="font-size:9px;"><%= Trim(strArrLastKName(i) & "　" & strArrFirstKName(i)) %><BR></SPAN><%= Trim(strArrLastName(i) & "　" & strArrFirstName(i)) %></TD>
						<TD NOWRAP><%= IIf(strArrGender(i) ="1", "男", "女") %></TD>
						<TD NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
						<TD NOWRAP ALIGN="right"><%= Int(strArrAge(i)) %>歳</TD>
						<TD NOWRAP><%= strArrOrgSName(i) %></TD>
						<TD><%= strSendMailDivName %></TD>
						<TD><%= strArrEmail(i) %></TD>
						<TD><%= strArrSendMailDate(i) %></TD>
					</TR>
<%
				Next
%>
			</TABLE>
		</FORM>
<%
		Exit Do
	Loop
%>
</BLOCKQUOTE>
</BODY>
</HTML>
