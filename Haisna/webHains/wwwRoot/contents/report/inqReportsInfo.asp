<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   成績書作成進捗確認 (Ver0.0.2)
'	   AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objOrg				'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objReportSendDate	'成績書発送情報アクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")


'Dim strKey              	'検索キー
Dim strArrKey              	'検索キー(空白で分割後のキー）
Dim strStartCslDate     	'検索条件受診年月日（開始）
Dim strStartYear     		'検索条件受診年（開始）
Dim strStartMonth     		'検索条件受診月（開始）
Dim strStartDay     		'検索条件受診日（開始）
Dim strEndCslDate     		'検索条件受診年月日（終了）
Dim strEndYear     			'検索条件受診年（終了）
Dim strEndMonth     		'検索条件受診月（終了）
Dim strEndDay     			'検索条件受診日（終了）
Dim strOrgCd1		   		'検索条件団体コード１
Dim strOrgCd2		   		'検索条件団体コード２
Dim strOrgName		   		'検索条件団体名

Dim strOrgGrpCd				'団体グループコード
Dim strCsCd					'コースコード
Dim strPerId
Dim strPerName

'Dim strPerId		   		'検索条件個人ＩＤ
'Dim strPerName		   		'検索条件個人名
Dim strLastName         	'検索条件姓
Dim strFirstName        	'検索条件名

Dim vntRsvNo	          	'予約番号
Dim vntCslDate          	'受診日
Dim vntPerId	          	'個人ＩＤ
Dim vntLastName         	'姓
Dim vntFirstName        	'名
Dim vntLastKName         	'カナ姓
Dim vntFirstKName        	'カナ名
Dim vntOrgCd1    	      	'団体コード１
Dim vntOrgCd2	          	'団体コード２
Dim vntOrgSName          	'団体略称
Dim vntDayId         		'当日ＩＤ
Dim vntReportSendDate		'発送確認日時
Dim vntPubNote 		       	'成績書コメント
Dim vntClrFlg           	'発送クリアフラグ

Dim vntGFFlg				'後日GF受診フラグ
Dim vntCFFlg				'後日GF受診フラグ
Dim vntSeq					'SEQ
Dim vntCsName				'コース名
Dim vntwebColor				'コースカラー
Dim vntReportOutEng			'英文成績書出力
Dim vntChargeUserName		'発送確認者名

Dim lngAllCount				'件数
Dim lngGetCount				'件数
Dim i						'カウンタ
Dim j

Dim lngStartPos				'表示開始位置
Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列

Dim lngArrSendMode()		'発送日確認状態の配列
Dim strArrSendModeName()	'発送日確認状態名の配列

Dim lngSendMode

Dim Ret						'関数戻り値
Dim strURL					'ジャンプ先のURL

Dim vntDelRsvNo				'
Dim vntDelSeq				'

'画面表示制御用検査項目
Dim strBeforeRsvNo			'前行の予約番号

Dim strWebCslDate			'
Dim strWebDayId				'
Dim strWebCsInfo			'
Dim strWebPerId				'
Dim strWebPerName			'
Dim strWebOrgName			'
Dim strWebGFFlg				'
Dim strWebCFFlg				'
Dim strWebReportOutEng		'

Dim strMessage
Dim strArrMessage	'エラーメッセージの配列

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objReportSendDate = Server.CreateObject("HainsReportSendDate.ReportSendDate")

'引数値の取得
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
'strKey            = Request("textKey")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
vntRsvNo          = ConvIStringToArray(Request("rsvno"))
vntSeq            = ConvIStringToArray(Request("seq"))
vntClrFlg         = ConvIStringToArray(Request("checkClrVal"))
lngSendMode       = Request("sendMode")
strCsCd           = Request("csCd")
strOrgGrpCd       = Request("OrgGrpCd")

'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		strAction = ""
		Exit Do
	End If

	'保存ボタンクリック
	If strAction = "save" Then

		vntDelRsvNo = Array()
		vntDelSeq   = Array()

		For i = 0 To UBound(vntClrFlg)

			'チェックされた場合に、処理実行
			If vntClrFlg(i) = "1" Then

				ReDim Preserve vntDelRsvNo(j)
				ReDim Preserve vntDelSeq(j)

				vntDelRsvNo(j) = vntRsvNo(i)
				vntDelSeq(j)   = vntSeq(i)
				j = j + 1

			End If

		Next

		if j > 0 Then

			'発送日クリア
			If objReportSendDate.DeleteConsult_ReptSend("SEL", vntDelRsvNo, vntDelSeq) Then
				strAction = "saveend"
			Else
				strAction = "saveerr"
			End If

		Else
		
			'オブジェクトのインスタンス作成
			objCommon.AppendArray strArrMessage, "クリアする成績書が一つも選択されていません"
			strMessage = strArrMessage

		End If

	End If

	If strAction <> "" Then

'		If strKey <> "" Then
'			'検索キーを空白で分割する
'			strArrKey = SplitByBlank(strKey)
'		Else 
'			strArrKey  = Array()
'			ReDim Preserve strArrKey(0)
'		End if

		'検索開始終了受診日の編集
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

		'全件を取得する
		lngAllCount = objReportSendDate.SelectReportSendDateList("CNT", _
		                                                         strPerId, _
		                                                         cDate(strStartCslDate), _
		                                                         cDate(strEndCslDate), _
		                                                         strCsCd, _
		                                                         strOrgCd1, _
		                                                         strOrgCd2, _
		                                                         strOrgGrpCd, _
		                                                         lngSendMode, _
		                                                         lngStartPos, _
		                                                         lngPageMaxLine)


		If lngAllCount > 0 Then

			'検索条件に従い成績書情報一覧を抽出する
			lngGetCount = objReportSendDate.SelectReportSendDateList("", _
			                                                         strPerId, _
			                                                         cDate(strStartCslDate), _
			                                                         cDate(strEndCslDate), _
			                                                         strCsCd, _
			                                                         strOrgCd1, _
			                                                         strOrgCd2, _
			                                                         strOrgGrpCd, _
			                                                         lngSendMode, _
			                                                         lngStartPos, _
			                                                         lngPageMaxLine, _
			                                                         vntRsvNo, _
			                                                         vntCslDate, _
			                                                         vntDayId, _
			                                                         vntPerId, _
			                                                         , _
			                                                         vntCsName, _
			                                                         vntwebColor, _
			                                                         vntLastName, _
			                                                         vntFirstName, _
			                                                         vntLastKName, _
			                                                         vntFirstkName, _
			                                                         , _
			                                                         , _
			                                                         vntOrgSName, _
			                                                         , _
			                                                         vntGFFlg, _
			                                                         vntCFFlg, _
			                                                         vntSeq, _
			                                                         , _
			                                                         vntReportSendDate, _
			                                                         , _
			                                                         vntChargeUserName, _
			                                                         vntPubNote, _
			                                                         vntReportOutEng)


			vntClrFlg = Array()
			Redim Preserve vntClrFlg(UBound(vntCslDate))

		End If

		'団体コードあり？
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName 
		Else
			strOrgName = ""
		End If 

		'個人IDの指定がある場合、名称取得
		If strPerId <> "" Then
			ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
			strPerName = strLastName & "　" & strFirstName
		Else
			strPerName = ""
		End If 

	End If

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	'検索開始終了受診日の編集
	strStartCslDate = strStartYear & "/" & strStartMonth & "/" & strStartDay
	strEndCslDate   = strEndYear & "/" & strEndMonth & "/" & strEndDay

	With objCommon

		If Not IsDate(strStartCslDate) Then
			.AppendArray strArrMessage, "指定された開始受診日が正しい日付ではありません。"
		End If

		If Not IsDate(strEndCslDate) Then
			.AppendArray strArrMessage, "指定された終了受診日が正しい日付ではありません。"
		End If

	End With

	'チェック結果を返す
	CheckValue = strArrMessage

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(2)
	Redim Preserve strArrPageMaxLineName(2)

	Redim Preserve lngArrSendMode(2)
	Redim Preserve strArrSendModeName(2)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50行ずつ"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100行ずつ"
	lngArrPageMaxLine(2) = 999:strArrPageMaxLineName(2) = "すべて"

	lngArrSendMode(0)     = 0
	strArrSendModeName(0) = "すべて"

	lngArrSendMode(1)     = 1
	strArrSendModeName(1) = "発送済みのみ"

	lngArrSendMode(2)     = 2
	strArrSendModeName(2) = "未発送のみ"

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>成績書作成進捗確認</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// クリアチェック
function checkClrAct( index ) {

	with ( document.entryReportInfo ) {
		if ( checkClr.length == null ) {
			checkClr.value = (checkClr.checked ? '1' : '0');
			checkClrVal.value = (checkClr.checked ? '1' : '0');
		} else {
			checkClr[index].value = (checkClr[index].checked ? '1' : '0');
			checkClrVal[index].value = (checkClr[index].checked ? '1' : '0');
		}
	}

}
// 検索ボタンクリック
function searchClick() {

	with ( document.entryReportInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// 保存ボタンクリック
function setReportSendDateClr() {

	if( !confirm('選択された成績書発送日をクリアします。よろしいですか？' ) ) return;

	with ( document.entryReportInfo ) {
		action.value = 'save';
		submit();
	}

	return false;

}

// アンロード時の処理
function closeGuideWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	// 個人検索ガイドを閉じる
	perGuide_closeGuidePersonal();

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryReportInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>"> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">成績書発送進捗確認</FONT></B></TD>
	</TR>
</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>受診日</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;日～&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;日</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>コース</TD>
		<TD>：</TD>
		<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
	</TR>
	<TR>
		<TD>団体</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryReportInfo.orgCd1, document.entryReportInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="団体検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryReportInfo.orgCd1, document.entryReportInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD NOWRAP COLSPAN="2">団体グループ：<%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
	</TR>
	<TR>
		<TD>個人ID</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryReportInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryReportInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
						<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
						<SPAN ID="perName"><%= strPerName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD><%= EditDropDownListFromArray("sendMode", lngArrSendMode, strArrSendModeName, lngSendMode, NON_SELECTED_DEL) %>　</TD>
		<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>　</TD>
		<TD><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<!--ここは検索件数結果-->
<%
	If strAction <> "" Then
%>

<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>
			<SPAN STYLE="font-size:9pt;">
			「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日</B></FONT>」の成績書作成情報一覧を表示しています。<BR>
					検索結果は<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件（成績書枚数単位）です。 
<%
	If lngAllCount > 0 Then
%>
			<FONT COLOR="#999999">（※受診者名称をクリックするとコメント情報が開きます）</FONT>
<%
	End If
%>
			</SPAN>
		</TD>
<%
	If lngAllCount > 0 Then
%>
		<TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
		<TD><A HREF="javascript:setReportSendDateClr()"><IMG SRC="../../images/save.gif" ALT="発送確認日時をクリアします" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
<%
	End If
%>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP>受診日</TD>
		<TD ALIGN="left" NOWRAP>当日ＩＤ</TD>
		<TD ALIGN="left" NOWRAP>コース</TD>
		<TD ALIGN="left" NOWRAP>個人ＩＤ</TD>
		<TD ALIGN="left" NOWRAP>受診者名</TD>
		<TD ALIGN="left" NOWRAP>団体名</TD>
		<TD ALIGN="left" NOWRAP>後日GF</TD>
		<TD ALIGN="left" NOWRAP>後日CF</TD>
		<TD ALIGN="left" NOWRAP>英語</TD>
		<TD ALIGN="left" NOWRAP>発送確認日時</TD>
		<TD ALIGN="left" NOWRAP>担当者</TD>
		<TD ALIGN="left" NOWRAP>確認クリア</TD>
		<TD ALIGN="left" NOWRAP>注意事項</td>
		<TD ALIGN="left" NOWRAP>予約番号</td>
	</TR>
<%
	End If

	If lngAllCount > 0 Then
		strBeforeRsvNo = ""

		For i = 0 To UBound(vntCslDate)

			strWebCslDate  = ""
			strWebDayId    = ""
			strWebCsInfo   = ""
			strWebPerId    = ""
			strWebPerName  = ""
			strWebOrgName  = ""
			strWebGFFlg    = ""
			strWebCFFlg    = ""


			If strBeforeRsvNo <> vntRsvNo(i) Then

				strWebCslDate  = vntCslDate(i)
				strWebDayId    = objCommon.FormatString(vntDayId(i), "0000")
				strWebCsInfo   = "<FONT COLOR=""#" & vntwebColor(i) & """>■</FONT>" & vntCsName(i) 
				strWebPerId    = vntPerId(i)
				strWebPerName  = "<SPAN STYLE=""font-size:9px;"">" & vntLastKName(i) & "　" & vntFirstKName(i) & "</SPAN><BR>" & vntLastName(i) & "　" & vntFirstName(i)
				strWebOrgName  = vntOrgSName(i)
				strWebGFFlg    = IIf(vntGFflg(i) > "0", "GF", "")
				strWebCFFlg    = IIf(vntCFflg(i) > "0", "CF", "")

			End If
%>
			<TR HEIGHT="18" BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strWebCslDate %></TD>
				<TD NOWRAP><%= strWebDayId   %></TD>
				<TD NOWRAP><%= strWebCsInfo  %></TD>
				<TD NOWRAP><%= strWebPerId   %></TD>
				<TD NOWRAP><A HREF="javascript:noteGuide_showGuideNote('1', '1,1,0,0', '', <%= vntRsvNo(i) %>)" ALT="クリックするとコメント情報が開きます"><%= strWebPerName %></A></TD>
				<TD NOWRAP><%= strWebOrgName %></TD>

				<TD NOWRAP ALIGN="CENTER"><%= strWebGFFlg %></TD>
				<TD NOWRAP ALIGN="CENTER"><%= strWebCFFlg %></TD>

				<TD NOWRAP ALIGN="CENTER"><%= IIf(vntReportOutEng(i) = "1", "Eng", "") %></TD>
				<TD NOWRAP><%= vntReportSendDate(i) %></TD>
				<TD NOWRAP><%= vntChargeUserName(i) %></TD>
				<INPUT TYPE="hidden" NAME="checkClrVal" VALUE="<%= vntClrFlg(i) %>">
				<TD NOWRAP>
<%
	If vntReportSendDate(i) <> "" Then
%>
					<INPUT TYPE="checkbox" NAME="checkClr" VALUE="1" <%= IIf(vntClrflg(i) <> "", " CHECKED", "") %>  ONCLICK="javascript:checkClrAct(<%= i %>)" border="0">クリア
<%
	Else
%>
					<INPUT TYPE="checkbox" NAME="checkClr" VALUE="0" BORDER="0" STYLE="visibility:hidden">
<%
	End If
%>
				</TD>
				<TD NOWRAP><FONT COLOR="black"><%= vntPubNote(i) %></FONT></TD>
				<TD><%= vntRsvNo(i) %></TD>
				<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= vntRsvNo(i) %>">
				<INPUT TYPE="hidden" NAME="seq"   VALUE="<%= vntSeq(i) %>">
			</TR>
<%
			strBeforeRsvNo = vntRsvno(i)
		Next
	ENd If
%>
</TABLE>
<%
	If lngAllCount > 0 Then
		'全件検索時はページングナビゲータ不要
     	If lngPageMaxLine <= 0 Then
		Else
			'URLの編集
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?mode="        & strMode
			strURL = strURL & "&action="      & strAction
			strURL = strURL & "&startYear="   & strStartYear
			strURL = strURL & "&startMonth="  & strStartMonth
			strURL = strURL & "&startDay="    & strStartDay
			strURL = strURL & "&endYear="     & strEndYear
			strURL = strURL & "&endMonth="    & strEndMonth
			strURL = strURL & "&endDay="      & strEndDay
			strURL = strURL & "&orgCd1="      & strOrgCd1
			strURL = strURL & "&orgCd2="      & strOrgCd2
'			strURL = strURL & "&textKey="     & strKey
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
'### 2004/06/04 Added by Ishihara@FSIT ページングナビ使用時に引数がロスト
			strURL = strURL & "&sendMode="    & lngSendMode
			strURL = strURL & "&OrgGrpCd="    & strOrgGrpCd
			strURL = strURL & "&csCd="        & strCsCd
'### 2004/06/04 Added End
			'ページングナビゲータの編集
%>
			<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
		End If
%>
		<BR>
<%
	End If
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>