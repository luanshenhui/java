<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		個人情報からの一括予約 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon			'共通クラス
'Dim objConsult			'受診情報一括処理用
Dim objContract			'契約情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgPost			'所属情報アクセス用
Dim objOrgRoom			'室部情報アクセス用

'引数値
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim strCtrPtCd			'契約パターンコード
Dim strCslYear			'受診年
Dim strCslMonth			'受診月
Dim strCslDay			'受診日
Dim strOpMode			'処理モード
Dim strCount			'挿入件数

'所属情報
Dim strOrgName			'団体名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strStrOrgPostName	'開始所属名称
Dim strEndOrgPostName	'終了所属名称

'契約情報
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

'個人情報
Dim strPerId			'個人ＩＤ
Dim lngCount			'レコード数

Dim dtmCslDate			'受診日
Dim strUpdUser			'更新者
Dim strMessage			'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値
Dim i					'インデックス

Dim objExec				'取り込み処理実行用
Dim strCommand			'コマンドライン文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsCooperation.ConsultAll")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strStrOrgPostCd = Request("strOrgPostCd")
strEndOrgPostCd = Request("endOrgPostCd")
strCtrPtCd      = Request("ctrPtCd")
strCslYear      = Request("cslYear")
strCslMonth     = Request("cslMonth")
strCslDay       = Request("cslDay")
strOpMode       = Request("opMode")
strCount        = Request("count")

'処理モードのデフォルト値設定
strOpMode = IIf(strOpMode = "", "0", strOpMode)

'契約情報の読み込み(チェック時と表示時の両方で使用するため、ここで予め読み込む
If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If
End If

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If IsEmpty(Request("reserve.x")) Then
		Exit Do
	End If

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'受診日の設定
	If strCslYear & strCslMonth & strCslDay <> "" Then
		dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)
	End If

'	'一括予約処理
'	Ret = objConsult.InsertConsultFromPerson(strUpdUser, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCtrPtCd, dtmCslDate, strOpMode)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\InsertConsultFromPerson.vbs"
	strCommand = strCommand & " " & strUpdUser
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & IIf(strOrgBsdCd     <> "", strOrgBsdCd,     """""")
	strCommand = strCommand & " " & IIf(strOrgRoomCd    <> "", strOrgRoomCd,    """""")
	strCommand = strCommand & " " & IIf(strStrOrgPostCd <> "", strStrOrgPostCd, """""")
	strCommand = strCommand & " " & IIf(strEndOrgPostCd <> "", strEndOrgPostCd, """""")
	strCommand = strCommand & " " & strCtrPtCd
	strCommand = strCommand & " " & IIf(dtmCslDate > 0, dtmCslDate, 0)
	strCommand = strCommand & " " & strOpMode

	'取り込み処理起動
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="       & strOrgCd1
	strURL = strURL & "&orgCd2="       & strOrgCd2
	strURL = strURL & "&orgBsdCd="     & strOrgBsdCd
	strURL = strURL & "&orgRoomCd="    & strOrgRoomCd
	strURL = strURL & "&strOrgPostCd=" & strStrOrgPostCd
	strURL = strURL & "&endOrgPostCd=" & strEndOrgPostCd
	strURL = strURL & "&ctrPtCd="      & strCtrPtCd
	strURL = strURL & "&cslYear="      & strCslYear
	strURL = strURL & "&cslMonth="     & strCslMonth
	strURL = strURL & "&cslDay="       & strCslDay
	strURL = strURL & "&opMode="       & strOpMode
	strURL = strURL & "&count="        & Ret
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

	Dim strCslDate	'受診日
	Dim strMessage	'エラーメッセージの集合
	Dim blnError	'エラーフラグ

	'団体コードのチェック
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "団体を指定して下さい。"
	End If

	'契約パターンコードのチェック
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "契約パターンを指定して下さい。"
	End If

	'受診日のチェック
	Do

		'受診日未入力時はスキップ
		If strCslYear & strCslMonth & strCslDay = "" Then
			Exit Do
		End If

		'受診日のチェック
		strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
		If Not IsDate(strCslDate) Then
			objCommon.appendArray strMessage, "受診日の入力形式が正しくありません。"
			Exit Do
		End If

		'受診日は指定契約パターンの契約期間内に存在しなければならない
		If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
			If CDate(strCslDate) < dtmStrDate Or CDate(strCslDate) > dtmEndDate Then
				objCommon.appendArray strMessage, "受診日は契約期間の範囲内で指定してください。"
				Exit Do
			End If
		End If

		Exit Do
	Loop

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
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
<TITLE>個人情報からの一括予約</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
		orgPostGuide_getPatternElement( ctrPtCd, 'csName', 'strDate', 'endDate');
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('この内容で一括予約処理を行います。よろしいですか？')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">個人情報からの一括予約</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Do

		'件数未指定時は通常のメッセージ編集
		If strCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

'		'０件の場合
'		If strCount = "0" Then
'			EditMessage "受診情報は作成されませんでした。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
'			Exit Do
'		End If

'		'１件以上処理された場合
'		EditMessage strCount & "件の受診情報が作成されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		EditMessage "個人情報からの一括予約処理が開始されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		Exit Do
	Loop
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">
<%
	'各種名称の取得
	Do

		'団体コード未指定時は何もしない
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'団体名称の読み込み
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If

		'事業部コード未指定時は何もしない
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'事業部名称の読み込み
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "事業部情報が存在しません。"
		End If

		'室部コード未指定時は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部名称の読み込み
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "室部情報が存在しません。"
		End If

		'開始所属名称の読み込み
		If strStrOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName) = False Then
				Err.Raise 1000, , "所属情報が存在しません。"
			End If
		End If

		'終了所属名称の読み込み
		If strEndOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName) = False Then
				Err.Raise 1000, , "所属情報が存在しません。"
			End If
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>事業部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>室部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH=90" NOWRAP>所属</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="strOrgPostName"><%= strStrOrgPostName %></SPAN></TD>
			<TD>～</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="endOrgPostName"><%= strEndOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>契約パターン</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="契約パターン検索ガイドを表示"></A></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy年m月d日"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "～yyyy年m月d日"), "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><A HREF="javascript:calGuide_clearDate('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, True) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, strCslDay, True) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="120"></TD>
			<TD><FONT COLOR="#999999">（省略時は契約開始日を受診日として一括予約を行います。）</FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>その他</TD>
			<TD>：</TD>
			<TD COLSPAN="2" NOWRAP>同一契約パターンの未受付受診情報がすでに存在する場合の処理を選択してください。</TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="0" <%= IIf(strOpMode = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>何もしない</TD>
					</TR>
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="1" <%= IIf(strOpMode = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>キャンセルする</TD>
					</TR>
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="2" <%= IIf(strOpMode = "2", "CHECKED", "") %>></TD>
						<TD NOWRAP>削除する</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で予約する">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRSVPER"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>