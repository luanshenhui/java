<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   傷病休業情報の入力 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'定数の定義
Const MODE_INSERT     = "insert"	'処理モード(挿入)
Const MODE_UPDATE     = "update"	'処理モード(更新)
Const ACTMODE_SAVE    = "save"		'動作モード(保存)
Const ACTMODE_SAVED   = "saved"		'動作モード(保存完了)
Const ACTMODE_DELETE  = "delete"	'動作モード(削除)
Const ACTMODE_DELETED = "deleted"	'動作モード(削除完了)

'COMコンポーネント
Dim objCommon			'共通クラス
Dim objDisease			'病名情報アクセス用
Dim objFree				'汎用情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objPerDisease		'傷病休業情報アクセス用

'引数値
Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strActMode			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strPerId			'個人ＩＤ
Dim lngDataYear			'データ年
Dim lngDataMonth		'データ月
Dim strDisCd			'病名コード
Dim lngOccurYear		'発病年
Dim lngOccurMonth		'発病月
Dim strHoliday			'休暇日数
Dim strAbsence			'欠勤日数
Dim strContinues		'継続区分
Dim strMedicalDiv		'療養区分

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgSName			'団体略称
Dim strOrgPostName		'所属名称
Dim strJobName			'職名

'傷病休業情報
Dim strArrOccurDate		'発病年月
Dim strArrHoliday		'休暇日数
Dim strArrAbsence		'欠勤日数
Dim strArrContinues		'継続区分
Dim strArrMedicalDiv	'療養区分
Dim lngCount			'レコード数

Dim dtmDataDate			'データ年月
Dim dtmOccurDate		'発病年月
Dim strDisName			'病名
Dim strArrMessage		'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon     = Server.CreateObject("HainsCommon.Common")
Set objPerDisease = Server.CreateObject("HainsPerDisease.PerDisease")

'引数値の取得
strMode       = Request("mode")
strActMode    = Request("actMode")
strPerId      = Request("perId")
lngDataYear   = CLng("0" & Request("dataYear"))
lngDataMonth  = CLng("0" & Request("dataMonth"))
strDisCd      = Request("disCd")
lngOccurYear  = CLng("0" & Request("occurYear"))
lngOccurMonth = CLng("0" & Request("occurMonth"))
strHoliday    = Request("holiday")
strAbsence    = Request("absence")
strContinues  = Request("continues")
strMedicalDiv = Request("medicalDiv")

'引数省略時のデフォルト値設定
strMode = IIf(strMode = "", MODE_INSERT, strMode)

If lngDataYear = 0 Or lngDataMonth = 0 Then
	lngDataYear  = Year(DateAdd("m", -1, Date))
	lngDataMonth = Month(DateAdd("m", -1, Date))
End If

If lngOccurYear = 0 Or lngOccurMonth = 0 Then
	lngOccurYear  = Year(DateAdd("m", -1, Date))
	lngOccurMonth = Month(DateAdd("m", -1, Date))
End If

strContinues  = IIf(strContinues  = "", "0", strContinues)
strMedicalDiv = IIf(strMedicalDiv = "", "0", strMedicalDiv)

'チェック・更新・読み込み処理の制御
Do

	'削除ボタン押下時
	If strActMode = ACTMODE_DELETE Then

		'データ年月の設定
		dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")

		'傷病休業情報テーブルレコード削除
		Ret = objPerDisease.DeletePerDisease(dtmDataDate, strPerId, strDisCd)

		'削除に成功した場合は挿入モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="    & MODE_INSERT
		strURL = strURL & "&actMode=" & ACTMODE_DELETED
		Response.Redirect strURL
		Response.End

	End If

	'保存ボタン押下時
	If strActMode = "save" Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'データ年月・発病年月の設定
		dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")
		dtmOccurDate = CDate(lngOccurYear & "/" & lngOccurMonth & "/1")

		'更新の場合
		If strMode = MODE_UPDATE Then

			'傷病休業情報テーブルレコード更新
			Ret = objPerDisease.UpdatePerDisease(dtmDataDate, strPerId, strDisCd, dtmDataDate, strPerId, strDisCd, dtmOccurDate, strHoliday, strAbsence, strContinues, strMedicalDiv)

			'レコードが存在しない場合は新規時の処理を行う
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'挿入の場合
		If strMode = MODE_INSERT Then

			'傷病休業情報テーブルレコード挿入
			Ret = objPerDisease.InsertPerDisease(dtmDataDate, strPerId, strDisCd, dtmOccurDate, strHoliday, strAbsence, strContinues, strMedicalDiv)

			'キー重複時はエラーメッセージを編集する
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("同一個人、データ年月、病名の傷病休業情報がすでに存在します。")
				Exit Do
			End If

		End If

		'保存に成功した場合は更新モードで自分自身を呼び出す
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="      & MODE_UPDATE
		strURL = strURL & "&actMode="   & ACTMODE_SAVED
		strURL = strURL & "&dataYear="  & lngDataYear
		strURL = strURL & "&dataMonth=" & lngDataMonth
		strURL = strURL & "&perId="     & strPerId
		strURL = strURL & "&disCd="     & strDisCd
		Response.Redirect strURL
		Response.End

	End If

	'新規モードの場合は読み込みを行わない
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'データ年月の設定
	dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")

	'傷病休業情報テーブルレコード読み込み
	lngCount = objPerDisease.SelectPerDisease("", dtmDataDate, strPerId, "", "", "", "", "", "", strDisCd, , , , , , , , , , , , , , , , , strArrOccurDate, strArrHoliday, strArrAbsence, strArrContinues, strArrMedicalDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, , "傷病休業情報が存在しません。"
	End If

	lngOccurYear  = Year(strArrOccurDate(0))
	lngOccurMonth = Month(strArrOccurDate(0))
	strHoliday    = strArrHoliday(0)
	strAbsence    = strArrAbsence(0)
	strContinues  = strArrContinues(0)
	strMedicalDiv = strArrMedicalDiv(0)

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報各値の妥当性チェックを行う
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
	Dim i				'インデックス

	'各値チェック処理
	With objCommon

		'個人ＩＤ
		If strPerId = "" Then
			.AppendArray vntArrMessage, "個人を選択して下さい。"
		End If

		'病名
		If strDisCd = "" Then
			.AppendArray vntArrMessage, "病名を選択して下さい。"
		End If

		'休暇日数、欠勤日数
		.AppendArray vntArrMessage, .CheckNumeric("休暇日数", strHoliday, 2, CHECK_NECESSARY)
		.AppendArray vntArrMessage, .CheckNumeric("欠勤日数", strAbsence, 2, CHECK_NECESSARY)

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
<TITLE>傷病休業情報の入力</TITLE>
<!-- #include virtual = "/WebHains/includes/diseaseGuide.inc" -->
<!-- #include virtual = "/WebHains/includes/perGuide.inc"     -->
<SCRIPT TYPE="text/javascript">
<!--
// 個人検索ガイド呼び出し
function callPersonGuide() {

	// 個人ガイド表示
	perGuide_showGuidePersonal( null, null, null, setPersonInfo );

}

// 個人情報の編集
function setPersonInfo( perInfo ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	var perName     = '';				// 氏名
	var perKName    = '';				// カナ氏名
	var birthName   = '';				// 生年月日
	var ageName     = '';				// 年齢
	var genderName  = '';				// 性別
	var isrSignName = '';				// 健保記号
	var isrNoName   = '';				// 健保番号
	var isrName     = '';				// 健保記号・番号
	var orgName     = '';				// 団体名
	var orgPostName = '';				// 所属名
	var jobName     = '';				// 職名

	// 氏名の編集
	perName = '<B>' + perInfo.perName + '</B>';

	// カナ氏名の編集
	perKName = '（' + perInfo.perKName + '）';

	// 生年月日・年齢の編集
	birthName  = perInfo.birthJpn + '生';
	ageName    = perInfo.age + '歳';
	genderName = ( perInfo.gender == '1' ? '男性' : '女性' );

	// 団体名の編集
	if ( perInfo.orgSName != '' ) {
		orgName = '団体：' + perInfo.orgSName;
	}

	// 所属名の編集
	if ( perInfo.orgPostName != '' ) {
		orgPostName = '所属：' + perInfo.orgPostName;
	}

	// 職名の編集
	if ( perInfo.jobName != '' ) {
		jobName = '職種：' + perInfo.jobName;
	}

	// 個人情報の編集
	document.entryForm.perId.value = perInfo.perId;
	document.getElementById('dspPerId').innerHTML       = perInfo.perId;
	document.getElementById('dspPerName').innerHTML     = perName;
	document.getElementById('dspPerKName').innerHTML    = perKName;
	document.getElementById('dspBirth').innerHTML       = birthName;
	document.getElementById('dspAge').innerHTML         = ageName;
	document.getElementById('dspGender').innerHTML      = genderName;
	document.getElementById('dspOrgName').innerHTML     = orgName;
	document.getElementById('dspOrgPostName').innerHTML = orgPostName;
	document.getElementById('dspJobName').innerHTML     = jobName;

}

// 病名検索ガイド呼び出し
function callDiseaseGuide() {

	disGuide_showGuideDisease( document.entryForm.disCd, 'disName', '' , '', 'disDivName', null, false );

}

// 病名クリア
function clearDisease() {

	disGuide_clearDiseaseInfo( document.entryForm.disCd, 'disName', '', '', '', '' );

}

// submit時の処理
function submitForm( actMode ) {

	// 削除時は確認メッセージを表示
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( 'この傷病休業情報を削除します。よろしいですか？' ) ) {
			return;
		}
	}

	// 動作モードを指定してsubmit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}

function closeWindow() {

	perGuide_closeGuidePersonal();
	disGuide_closeGuideDisease();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">傷病休業情報の入力</FONT></B></TD>
		</TR>
	</TABLE>

	<!-- 操作ボタン -->
	<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="perDiseaseList.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="検索画面に戻ります"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
						If strMode = "update" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この傷病休業情報を削除します"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
							<TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=<%= MODE_INSERT %>"><IMG SRC="/webhains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい傷病休業情報を登録します"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
						End If
%>
						<TD><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
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

	If strPerId <> "" Then

		'個人テーブルレコード読み込み
		Set objPerson = Server.CreateObject("HainsPerson.Person")
		objPerson.SelectPerson strPerId, strLastName,  strFirstName, strLastKName,  strFirstKName, strBirth,  strGender, strOrgCd1, strOrgCd2, , , strOrgSName, , , , , , , , strOrgPostName, , , strJobName

		'年齢計算
		Set objFree = Server.CreateObject("HainsFree.Free")
		strAge = objFree.CalcAge(strBirth)

	End If
%>
	<BR>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
<%
			'新規ならばガイドボタンを表示
			If strMode = "insert" Then
%>
				<TD><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
<%
			Else
%>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21" ALT=""></TD>
<%
			End If
%>
			<TD NOWRAP><SPAN ID="dspPerId"><%= strPerId %></SPAN></TD>
			<TD NOWRAP>
				<SPAN ID="dspPerName"><%= IIf(strLastName & strFirstName <> "", "<B>" & Trim(strLastName & "　" & strFirstName) & "</B>", "<FONT COLOR=""#999999"">（個人を選択して下さい）</FONT>") %></SPAN>
				<SPAN ID="dspPerKName"><%= IIf(strLastKName & strFirstKName <> "", "（" & Trim(strLastKName & "　" & strFirstKName) & "）", "") %></SPAN>&nbsp;
				<SPAN ID="dspBirth"><%= IIf(strBirth <> "", objCommon.FormatString(strBirth, "ge.m.d") & "生", "") %></SPAN>&nbsp;
				<SPAN ID="dspAge"><%= IIf(strAge <> "", Int(strAge) & "歳", "") %></SPAN>&nbsp;
				<SPAN ID="dspGender"><%= IIf(strGender = "1", "男性", IIf(strGender = "2", "女性", "")) %></SPAN>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP>
				<SPAN ID="dspOrgName"><%= IIf(strOrgSName <> "", "団体：" & strOrgSName, "") %></SPAN>&nbsp;&nbsp;
				<SPAN ID="dspOrgPostName"><%= IIf(strOrgPostName <> "", "所属：" & strOrgPostName, "") %></SPAN>&nbsp;&nbsp;
				<SPAN ID="dspJobName"><%= IIf(strJobName <> "", "職種：" & strJobName, "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="hidden" NAME="disCd"  VALUE="<%= strDisCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP>データ年月</TD>
			<TD>：</TD>
<%
			If strMode = MODE_UPDATE Then
%>
				<TD HEIGHT="24" NOWRAP><INPUT TYPE="hidden" NAME="dataYear" VALUE="<%= lngDataYear %>"><INPUT TYPE="hidden" NAME="dataMonth" VALUE="<%= lngDataMonth %>"><%= lngDataYear & "年" & lngDataMonth & "月" %></TD>
<%
			Else
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear, False) %></TD>
							<TD>年</TD>
							<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, False) %></TD>
							<TD>月</TD>
						</TR>
					</TABLE>
				</TD>
<%
			End If
%>
		</TR>
<%
		'病名読み込み
		If strDisCd <> "" Then
			Set objDisease = Server.CreateObject("HainsDisease.Disease")
			objDisease.SelectDisease strDisCd, strDisName
		End If
%>
		<TR>
			<TD NOWRAP>病名</TD>
			<TD>：</TD>
<%
			If strMode = MODE_UPDATE Then
%>
				<TD HEIGHT="24" NOWRAP><%= strDisName %></TD>
<%
			Else
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callDiseaseGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="病名検索ガイドを表示"></A></TD>
							<TD><A HREF="javascript:clearDisease()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="病名をクリア"></A></TD>
							<TD><SPAN ID="disName"><%= strDisName %></TD>
						</TR>
					</TABLE>
				</TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD NOWRAP>発病年月</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><%= EditNumberList("occurYear", YEARRANGE_MIN, YEARRANGE_MAX, lngOccurYear ,False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("occurMonth", 1, 12, lngOccurMonth, False) %></TD>
						<TD>月</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>休暇日数</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="holiday" SIZE="2" MAXLENGTH="2" VALUE="<%= strHoliday %>"></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>欠勤日数</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="absence" SIZE="2" MAXLENGTH="2" VALUE="<%= strAbsence %>"></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>継続区分</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="continues" VALUE="0" <%= IIf(strContinues = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>新規</TD>
						<TD><INPUT TYPE="radio" NAME="continues" VALUE="1" <%= IIf(strContinues = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>継続</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>療養区分</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="0" <%= IIf(strMedicalDiv = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>自宅療養</TD>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="1" <%= IIf(strMedicalDiv = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>通院</TD>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="2" <%= IIf(strMedicalDiv = "2", "CHECKED", "") %>></TD>
						<TD NOWRAP>入院</TD>
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