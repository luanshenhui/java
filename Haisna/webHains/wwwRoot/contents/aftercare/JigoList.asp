<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		事後措置検索 (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objJudClass			'判定分類情報アクセス用
Dim objJud				'判定情報アクセス用
Dim objAfterCare		'アフターケアアクセス用
Dim objOrg				'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objOrgBsd			'事業所情報アクセス用
Dim objOrgRoom			'室部情報アクセス用
Dim objOrgPost			'所属情報アクセス用
Dim objFree				'汎用情報アクセス用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strConstverTimeDiv
strConstverTimeDiv = Array("なし","あり")

'判定分類情報
Dim strDispJudClassCd		'判定分類コード
Dim strDispJudClassName		'判定分類名称

'判定情報
Dim strDispJudCd			'判定コード
Dim strDispJudSName			'判定略称
Dim strDispJudRName			'報告書用判定名称

'団体情報
Dim strOrgName				'団体名称
Dim strOrgSName				'略称
Dim strOrgKName				'団体カナ名称

'個人情報
'Dim strPerID				'個人ＩＤ
Dim strLastName				'姓
Dim strFirstName			'名

'事業部情報
Dim strOrgBsdKName			'事業部カナ名称
Dim strOrgBsdName			'事業部名称

'室部情報
Dim strOrgRoomKName			'室部カナ名称
Dim strOrgRoomName			'室部名称

'所属情報
Dim strOrgPostKName1		'所属カナ名称１
Dim strOrgPostKName2		'所属カナ名称２
Dim strOrgPostName1			'所属名称１
Dim strOrgPostName2			'所属名称２

'事後措置対象者検索用
Dim strOutputKbn			'出力順
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strOrgBsdCd				'事業所コード
Dim strOrgRoomCd			'室部コード
Dim strOrgPostCd1			'所属コード１
Dim strOrgPostCd2			'所属コード２
Dim strPerID				'個人ＩＤ
Dim strSochiKbn				'就業措置区分
Dim strChokaKbn				'超過勤務区分
Dim strJudClassCd			'判定分類コード
Dim strJudCd				'判定コード
Dim strStrAgeInt			'検索開始年齢
Dim strEndAgeInt			'検索終了年齢
Dim strGender				'性別
Dim strArrPerId         	'個人ＩＤ
Dim strArrEmpNo         	'従業員番号
Dim strArrLastName          '姓
Dim strArrFirstName         '名
Dim strArrLastKName         '姓（カナ）
Dim strArrFirstKName        '名（カナ）
Dim strArrBirth             '生年月日
Dim strArrGender            '性別
Dim strArrOrgName           '団体名称
Dim strArrOrgPostName       '所属名称
Dim strArrWorkMeasureName   '就業措置区分
Dim strArrOverTimeDiv       '超過勤務区分
Dim strArrJudString      	'判定文字列

'就業措置区分オプションボタン用
Const strKeyWorkMeasureDiv = "WORKDIV"
Dim strWorkMeasureDiv			'就業措置区分
Dim strArrWorkMeasureDiv		'就業措置区分（配列）
Dim strArrWorkMeasureDivName	'就業措置区分名（配列）
Dim lngWorkMeasureDivCount		'就業措置区分数

Dim strToday				'本日日付（システム日付）
Dim strDispPerName			'個人名
Dim strDispPerKName			'個人カナ名
Dim strDispAge				'年齢
Dim lngAllJigoCount			'事後措置対象者レコードカウント
Dim lngDispJigoCount		'事後措置対象者管理項目（表示用）
Dim lngJigoCount			'事後措置対象者管理項目
Dim i,j						'ループカウント

Dim lngStartPos				'表示開始位置
Dim strPageMaxLine			'１ページ表示行数
Dim lngGetCount				'１ページ表示件数
Dim lngAllCount				'条件を満たす全レコード件数

Dim strSearchString

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'一覧表示行数の取得
strPageMaxLine = 30

'オブジェクトのインスタンス作成
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objJudClass	 	= Server.CreateObject("HainsJudClass.JudClass")
Set objJud		 	= Server.CreateObject("HainsJud.Jud")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")
Set objFree		 	= Server.CreateObject("HainsFree.Free")

strOutputKbn    	= Request("outputKbn")
strOutputKbn    	= IIf(strOutputKbn = "", 1, strOutputKbn)
strOrgCd1 			= Request("orgCd1")
strOrgCd2 			= Request("orgCd2")
strPerID			= Request("perId")
strOrgBsdCd			= Request("orgBsdCd")
strOrgRoomCd		= Request("orgRoomCd")
strOrgPostCd1		= Request("orgPostCd1")
strOrgPostCd2		= Request("orgPostCd2")
strSochiKbn			= Request("sochiKbn")
strChokaKbn			= Request("chokaKbn")
strJudClassCd		= Request("judClassCd")
strJudCd			= Request("judCd")
strStrAgeInt		= Request("strAgeInt")
strEndAgeInt		= Request("endAgeInt")
strGender			= Request("gender")

lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)

'判定分類情報のリスト取得
	objJudClass.SelectJudClassList  strDispJudClassCd, strDispJudClassName, Empty

'判定コードのリスト取得
	objJud.SelectJudList  strDispJudCd, strDispJudSName, strDispJudRName, Empty, Empty, Empty

'団体名称の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" ) Then
	Set objOrg = Server.CreateObject("HainsOrganization.Organization")
	objOrg.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
	Set objOrg = Nothing
End If

'個人氏名の取得
If( Trim(strPerID) <> "" ) Then
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonName strPerID, strLastName, strFirstName
	Set objPerson = Nothing
End If

'事業所名の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" And Trim(strOrgBsdCd) <> "" ) Then
	Set objOrgBsd  = Server.CreateObject("HainsOrgBsd.OrgBsd")
	objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, _
						   strOrgBsdKName, strOrgBsdName, _
						   Empty, Empty, Empty
	Set objOrgBsd = Nothing
End If

'室部名の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" ) Then
	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
	objOrgRoom.SelectOrgRoom strOrgCd1,strOrgCd2,strOrgBsdCd, strOrgRoomCd, _
							 strOrgRoomName,strOrgRoomKName, _
							 Empty,Empty,Empty,Empty,Empty 
	Set objOrgRoom = Nothing
End If

'所属名１の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd1, _
							 strOrgPostName1, strOrgPostKName1, _
							 Empty, Empty, Empty, Empty, _
							 Empty, Empty, Empty
	Set objOrgPost = Nothing
End If

'所属名２の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd2, _
							 strOrgPostName2, strOrgPostKName2, _
							 Empty, Empty, Empty, Empty, _
							 Empty, Empty, Empty 
	Set objOrgPost = Nothing
End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->

<SCRIPT TYPE="text/javascript">
<!--

// 個人検索ガイド呼び出し
function callPerGuide() {

	//個人ガイド表示
	perGuide_showGuidePersonal( null, null, null, setPerInfo );

}

// 個人情報の編集
function setPerInfo( perInfo ) {

	document.entryForm.perId.value = perInfo.perId;
	document.getElementById('perName').innerHTML = perInfo.perName;

}

// 個人ＩＤ・氏名のクリア
function clearPerInfo() {

	perGuide_clearPerInfo( document.entryForm.perId, 'perName' );

}

// サブ画面を閉じる
function closeWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

}

// 検索実行
function searchSubmit(){

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var url    = '';					// フォームの送信先ＵＲＬ

	if ( myForm.orgCd1.value == '' && myForm.orgCd2.value == '' && myForm.perId.value == '' ){
		strErrMsg = '検索を行う場合、団体コードまたは個人ＩＤのいずれか必須入力です。';
		alert(strErrMsg);
		return false;
	}

	myForm.startPos.value = 1;			//Position初期化
	document.entryForm.submit();
	return false;

}

// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
	}

}
//-->
</SCRIPT>
<TITLE>事後措置対象者の検索</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()" ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">事後措置対象者の検索</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>出力順</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="1" <%= Iif(strOutputKbn = "1", "CHECKED", "") %> ></TD>
					<TD>５０音順</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="2" <%= Iif(strOutputKbn = "2", "CHECKED", "") %> ></TD>
					<TD>従業員番号順</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="3" <%= Iif(strOutputKbn = "3", "CHECKED", "") %> ></TD>
					<TD>所属順</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="4" <%= Iif(strOutputKbn = "4", "CHECKED", "") %> ></TD>
					<TD>職種順</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>団体</TD>
		<TD>：</TD>
<!--
		<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="団体をクリア"></A></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="団体をクリア"></A></TD>
		<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
		<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">
		<TD><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
	</TR>
	<TR>
		<TD NOWRAP>事業部</TD>
		<TD>：</TD>
<!-- 
		<TD><A HREF="javascript:callOrgBsdGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:clearOrgBsdCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="事業をクリア"></A></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="事業所をクリア"></A></TD>
		<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= strOrgBsdCd %>">
		<TD><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
	</TR>
	<TR>
		<TD NOWRAP>室部</TD>
		<TD>：</TD>
<!--
		<TD><A HREF="javascript:callOrgRoomGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:clearOrgRoomCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="室部をクリア"></A></TD>
		<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
		<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="室部をクリア"></A></TD>
		<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
		<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
	</TR>
		<TR>
			<TD WIDTH=90" NOWRAP>所属</TD>
			<TD>：</TD>
<!--
			<TD><A HREF="javascript:callOrgPostGuide(1)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(1)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>～</TD>
			<TD><A HREF="javascript:callOrgPostGuide(2)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(2)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>～</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
		</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH='90"' NOWRAP>受診者指定</TD>
		<TD>：</TD>
		<TD><A HREF="javascript:callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
		<TD><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="個人をクリア"></A></TD>
		<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= strPerID %>">
		<TD><SPAN ID="perName"><%= strLastName %>    <%= strFirstName %></SPAN></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>就業措置区分</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="radio" NAME="sochiKbn" VALUE=""  <%= Iif(strSochiKbn = "", "CHECKED", "") %>></TD>
		<TD NOWRAP>すべて</TD>
<%
			'就業措置区分取得
			lngWorkMeasureDivCount = objFree.SelectFree (1, strKeyWorkMeasureDiv, strArrWorkMeasureDiv, , , strArrWorkMeasureDivName)
			For i = 0 To lngWorkMeasureDivCount - 1
%>
				<TD><INPUT TYPE="radio" NAME="sochiKbn" VALUE="<%= strArrWorkMeasureDiv(i) %>" <%= Iif(strSochiKbn = strArrWorkMeasureDiv(i), "CHECKED", "") %> ></TD>
				<TD NOWRAP><%= strArrWorkMeasureDivName(i) %></TD>
<%
			Next
%>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>超過勤務区分</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE=""  <%= Iif(strChokaKbn = "", "CHECKED", "") %>></TD>
		<TD NOWRAP>すべて</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE="0" <%= Iif(strChokaKbn = "0", "CHECKED", "") %>></TD>
		<TD NOWRAP>なし</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE="1" <%= Iif(strChokaKbn = "1", "CHECKED", "") %>></TD>
		<TD NOWRAP>あり</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>判定分類</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("judClassCd", strDispJudClassCd, strDispJudClassName , strJudClassCd, NON_SELECTED_ADD) %></TD>
		<TD>判定</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("judCd", strDispJudCd, strDispJudSName , strJudCd, NON_SELECTED_ADD) %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="650">
	<TR>
		<TD WIDTH="90" NOWRAP>年齢</TD>
		<TD WIDTH="1">：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><%= EditNumberList("strAgeInt", 1, 150, strStrAgeInt , true) %></TD>
					<TD>歳</TD>
					<TD>
						
					</TD>
					<TD NOWRAP>～</TD>
					<TD><%= EditNumberList("endAgeInt", 1, 150, strEndAgeInt , true) %></TD>
					</TD>
					<TD>歳</TD>
				</TR>
			</TABLE>
		</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
				<TR>
					<TD NOWRAP>性別</TD>
					<TD>：</TD>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
							<TR>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE=""  <%= Iif(strGender = "", "CHECKED", "") %>></TD>
								<TD NOWRAP>すべて</TD>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE="1" <%= Iif(strGender = "1", "CHECKED", "") %> ></TD>
								<TD NOWRAP>男性のみ</TD>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE="2" <%= Iif(strGender = "2", "CHECKED", "") %>></TD>
								<TD NOWRAP>女性のみ</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return searchSubmit(5)"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
	</TR>
</TABLE>
<BR>

<%
'-------------------------------------------------------------------------------
'事後措置対象者の検索
'-------------------------------------------------------------------------------
If( strPerId <> "" Or ( strOrgCd1 <> "" And strOrgCd2 <> "" )) Then

	'事後措置対象者の検索（人数）
	lngAllCount = objAfterCare.SelectAfterCareTarget( _
								"CNT" , _
								strOutputKbn , _
								strPerID , _
								strOrgCd1 , _
								strOrgCd2 , _
								strOrgBsdCd , _
								strOrgRoomCd , _
								strOrgPostCd1 , _
								strOrgPostCd2 , _
								strSochiKbn , _
								strChokaKbn , _
								strJudClassCd , _
								strJudCd , _
								strStrAgeInt , _
								strEndAgeInt , _
								strGender)

	If( lngAllCount > 0 ) Then
%>
	指定条件の事後措置対象者一覧を表示しています。<BR>
	対象者数は <FONT COLOR="#FF6600"><B><%= lngAllCount %></B></FONT>人です。<BR><BR>
<% 
	Else
%>
	検索条件を満たす事後措置入力対象者は存在しません。<BR>
	キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR><BR>
<%
	End If
End If

If lngAllCount > 0 Then 

	'事後措置対象者の検索（実データ）
	lngDispJigoCount = objAfterCare.SelectAfterCareTarget( _
								"SRC" , _
								strOutputKbn , _
								strPerID , _
								strOrgCd1 , _
 								strOrgCd2 , _
 								strOrgBsdCd , _
 								strOrgRoomCd , _
 								strOrgPostCd1 , _
 								strOrgPostCd2 , _
 								strSochiKbn , _
 								strChokaKbn , _
 								strJudClassCd , _
 								strJudCd , _
 								strStrAgeInt , _
 								strEndAgeInt , _
 								strGender , _
 								lngStartPos, _
 								strPageMaxLine, _
 								strArrPerId , _
 								strArrEmpNo , _
 								strArrLastName , _
 								strArrFirstName , _
 								strArrLastKName , _
 								strArrFirstKName , _
 								strArrBirth , _
 								strArrGender , _
 								strArrOrgName , _
 								strArrOrgPostName , _
 								strArrWorkMeasureName , _
 								strArrOverTimeDiv , _
								strArrJudString)

End If

If lngDispJigoCount > 0 Then
%>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
<%
		If ( strOrgCd1 = "" ) Or ( strOrgCd2 = "" ) Then
%>
			<TD NOWRAP>団体</TD>
<%
		End If
%>
			<TD NOWRAP>従業員番号</TD>
			<TD NOWRAP>氏名</TD>
			<TD NOWRAP>性別</TD>
			<TD NOWRAP>年齢</TD>
			<TD NOWRAP>所属</TD>
			<TD NOWRAP>措置区分</TD>
			<TD NOWRAP>超勤区分</TD>
			<TD NOWRAP>要管理項目</TD>
		</TR>
<%
End If
%>

<%
For i = 0 To lngDispJigoCount - 1
	'表示用名称の編集
	strDispPerName 	= Trim(strArrLastName(i) & "　" & strArrFirstName(i))
	strDispPerKName = Trim(strArrLastKName(i) & "　" & strArrFirstKName(i))

	'年齢の算出
	strToday = Year(now) & "/" & Month(now) & "/" & Day(now)
'	strDispAge = objFree.CalcAge( strArrBirth(i) , strToday , "" )
	strDispAge = strArrBirth(i)
%>

	<TR BGCOLOR="#ffffff">
<%
	If ( strOrgCd1 = "" ) Or ( strOrgCd2 = "" ) Then
%>
		<TD NOWRAP><%= strArrOrgName(i) %></TD>
<%
	End If
%>
		<TD><%= strArrEmpNo(i) %></TD>
		<TD NOWRAP><A HREF="JigoInfo.asp?perId=<%= strArrPerId(i) %>"><%= strDispPerName %><FONT SIZE="-1" COLOR="#666666">（<%= strDispPerKName %>）</FONT></A></TD>
		<TD NOWRAP><%= strArrGender(i) %></TD>
		<TD ALIGN="right" NOWRAP><%= strDispAge %>歳</TD>
		<TD NOWRAP><%= strArrOrgPostName(i) %></TD>
		<TD NOWRAP><%= strArrWorkMeasureName(i) %></TD>
		<TD ALIGN="center" NOWRAP><%= strConstverTimeDiv(Cint(strArrOverTimeDiv(i))) %></TD>
		<TD NOWRAP><%= strArrJudString(i) %></TD>
	</TR>
<%
Next
%>
	</TABLE>

<%
	'ページングナビゲータの編集
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "outputKbn=" & strOutputKbn
		strSearchString = strSearchString & "&orgCd1=" & strOrgCd1
		strSearchString = strSearchString & "&orgCd2=" & strOrgCd2
		strSearchString = strSearchString & "&orgBsdCd=" & strOrgBsdCd
		strSearchString = strSearchString & "&orgRoomCd=" & strOrgRoomCd
		strSearchString = strSearchString & "&orgPostCd1=" & strOrgPostCd1
		strSearchString = strSearchString & "&orgPostCd2=" & strOrgPostCd2
		strSearchString = strSearchString & "&perId=" & strPerID
		strSearchString = strSearchString & "&sochiKbn=" & strSochiKbn
		strSearchString = strSearchString & "&chokaKbn=" & strChokaKbn
		strSearchString = strSearchString & "&judClassCd=" & strJudClassCd
		strSearchString = strSearchString & "&judCd=" & strJudCd
		strSearchString = strSearchString & "&strAgeInt=" & strStrAgeInt
		strSearchString = strSearchString & "&endAgeInt=" & strEndAgeInt
		strSearchString = strSearchString & "&gender=" & strGender
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>

</FORM>
</BODY>
</HTML>
