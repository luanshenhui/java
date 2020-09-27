<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		傷病休業リスト (Ver0.0.1)
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
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objPerDisease		'傷病休業情報アクセス用
Dim objOrg				'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objOrgBsd			'事業所情報アクセス用
Dim objOrgRoom			'室部情報アクセス用
Dim objOrgPost			'所属情報アクセス用
Dim objFree				'汎用情報アクセス用

'団体情報
Dim strOrgName			'団体名称
Dim strOrgSName			'略称
Dim strOrgKName			'団体カナ名称

'個人情報
'Dim strPerID			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名

'事業部情報
Dim strOrgBsdKName		'事業部カナ名称
Dim strOrgBsdName		'事業部名称

'室部情報
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgRoomName		'室部名称

'所属情報
Dim strOrgPostKName1	'所属カナ名称１
Dim strOrgPostKName2	'所属カナ名称２
Dim strOrgPostName1		'所属名称１
Dim strOrgPostName2		'所属名称２

'傷病休業情報
Dim strDataDate			'データ年（検索用）
Dim strPerID			'個人ＩＤ（検索用）
Dim strOrgCd1 			'団体コード１（検索用）
Dim strOrgCd2			'団体コード２（検索用）
Dim strOrgBsdCd			'事業所コード（検索用）
Dim strOrgRoomCd		'室部コード（検索用）
Dim strOrgPostCd1		'所属コード１（検索用）
Dim strOrgPostCd2		'所属コード２（検索用）
Dim arrPerId			'個人コード（検索結果）
Dim arrEmpNo			'従業員番号（検索結果）
Dim arrLastName			'姓（検索結果）
Dim arrFirstName		'名（検索結果）
Dim arrLastKName		'姓カナ（検索結果）
Dim arrFirstKName		'名カナ（検索結果）
Dim arrBirth			'生年月日（検索結果）
Dim arrGender			'性別（検索結果）
Dim arrOrgName			'団体名称（検索結果）
Dim arrOrgPostName		'所属名称（検索結果）
Dim arrDisName			'病名（検索結果）
Dim arrDataDate			'データ日付（検索結果）
Dim arrDisCd			'病名コード（検索結果）
Dim arrOccurDate		'発病日付（検索結果）
Dim arrHoliday			'休暇日数（検索結果）
Dim arrAbsence			'欠勤日数（検索結果）
Dim arrContinues		'継続区分（検索結果）
Dim arrMedicalDiv		'療養区分（検索結果）
Dim arrAge

Dim strDataYear			'データ年（検索用）
Dim strDataMonth		'データ月（検索用）
Dim strToday			'本日日付（システム日付）
Dim strAge				'年齢
Dim strKeyPerId			'個人ＩＤ（検索用）

Dim lngGetCount			'

Dim lngStartPos			'表示開始位置
Dim strPageMaxLine		'表示最大行
Dim strSearchString		'ページングナビ用検索文字列
Dim lngAllCount			'取得件数
Dim lngCount			'取得件数
Dim vntMessage 			'メッセージ
Dim strOldPerId			'コントロールブレイク用個人ID

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim BlnCheckFlg			'処理結果チェック用
Dim strHtml         	'html出力用ワーク
Dim lngPerDisCount		'傷病休業検索件数
Dim lngALLPerDisCount	'傷病休業検索件数
Dim i , j      			'ループカウント用ワーク

Dim strMode				'入力が画面呼び出し時の動作モード設定
Dim strDspContinue		'表示用継続区分
Dim strDspMedicalDiv	'表示用療養区分

strDspContinue   = Array("新規","継続")
strDspMedicalDiv = Array("自宅療養","通院","入院")

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strOrgCd1 		= Request("orgCd1")
strOrgCd2 		= Request("orgCd2")
strDataYear		= Request("dataYear")
strDataMonth	= Request("dataMonth")
strPerID		= Request("perId")
strOrgBsdCd		= Request("orgBsdCd")
strOrgRoomCd	= Request("orgRoomCd")
strOrgPostCd1	= Request("orgPostCd1")
strOrgPostCd2	= Request("orgPostCd2")
strMode         = Request("mode")

strPageMaxLine  = Request("PageMaxLine")
lngStartPos     = CLng("0" & Request("startPos"))
lngStartPos     = IIf(lngStartPos = 0, 1, lngStartPos)

'検索用の日付設定
If( strDataYear <> "" And strDataMonth <> "" ) Then
	strDataDate		= strDataYear & "/" & strDataMonth
End If

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
	BlnCheckFlg = objOrgBsd.SelectOrgBsd( strOrgCd1, strOrgCd2, strOrgBsdCd, _
										   strOrgBsdKName, strOrgBsdName, _
										   Empty, Empty, Empty _
						     			 )
	Set objOrgBsd = Nothing
End If

'室部名の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" ) Then
	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
	BlnCheckFlg = objOrgRoom.SelectOrgRoom( strOrgCd1,strOrgCd2,strOrgBsdCd, strOrgRoomCd, _
							  				strOrgRoomName,strOrgRoomKName, _
							  				Empty,Empty,Empty,Empty,Empty _
		     							  )
	Set objOrgRoom = Nothing
End If

'所属名１の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	BlnCheckFlg = objOrgPost.SelectOrgPost( strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd1, _
							  				strOrgPostName1, strOrgPostKName1, _
							  				Empty, Empty, Empty, Empty, _
							  				Empty, Empty, Empty _
										  )
	Set objOrgPost = Nothing
End If

'所属名２の取得
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	BlnCheckFlg = objOrgPost.SelectOrgPost( strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd2, _
							  				strOrgPostName2, strOrgPostKName2, _
							  				Empty, Empty, Empty, Empty, _
							  				Empty, Empty, Empty _
										  )
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
var strMode;	//  次画面（入力画面）へ移行する時の処理モードを設定

// ガイド画面呼び出し
function callOrgGuide() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント
	orgGuide_showGuideOrg( objForm.orgCd1, objForm.orgCd2, 'orgName', '', '' , null , false );

}
// 団体クリア
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName');

}

// 事業部ガイド呼び出し
function callOrgBsdGuide() {

	if( checkData(1) ){
		var objForm = document.entryForm;	// 自画面のフォームエレメント
		orgBsdGuide_showGuideOrgBsd( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, '' , 'orgBsdName', null , false );
	}
}

// 事業部クリア
function clearOrgBsdCd() {

	orgBsdGuide_clearOrgBsdInfo(document.entryForm.orgBsdCd, '' , 'orgBsdName');

}

// 室部ガイド呼び出し
function callOrgRoomGuide() {

	if( checkData(2) ){
		var objForm = document.entryForm;	// 自画面のフォームエレメント
		OrgRoomGuide_showGuideOrgRoom( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, objForm.orgRoomCd, '' , 'orgRoomName', null , false );
	}
}

// 室部クリア
function clearOrgRoomCd() {

	OrgRoomGuide_clearOrgRoomInfo(document.entryForm.orgRoomCd, 'orgRoomName' , '' );

}

// 所属ガイド呼び出し
function callOrgPostGuide( postCdNo ) {
	var  objPostCd;
	var  idPostName;

	if( postCdNo == 1 ){
		objPostCd = document.entryForm.orgPostCd1;
		idPostCd  = 'OrgPostName1';
	}else{
		objPostCd = document.entryForm.orgPostCd2;
		idPostCd  = 'OrgPostName2';
	}

	if( checkData(3) ){
		var objForm = document.entryForm;	// 自画面のフォームエレメント
		OrgPostGuide_showGuideOrgPost( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, objForm.orgRoomCd, objPostCd, idPostCd, '' , null , false );
	}
}

// 所属クリア
function clearOrgPostCd( postCdNo ) {
	var  objPostCd;
	var  idPostName;

	if( postCdNo == 1 ){
		objPostCd = document.entryForm.orgPostCd1;
		idPostCd  = 'OrgPostName1';
	}else{
		objPostCd = document.entryForm.orgPostCd2;
		idPostCd  = 'OrgPostName2';
	}


	OrgPostGuide_clearOrgPostInfo(objPostCd, idPostCd , '' );

}
// 個人検索ガイド呼び出し
function callPerGuide() {

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

// 傷病休業入力画面の表示
function showPerDisease(CheckMode){

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var url    = '';					// フォームの送信先ＵＲＬ

	//  エラーチェックがＯＫの場合入力画面を表示する
	if( checkData(CheckMode) ){

		if( CheckMode == 4 ){
			myForm.mode.value = 'insert';
			url = '/webHains/contents/disease/perDiseaseInfo.asp';
		}else{
			myForm.mode.value = 'replace';
		}

		myForm.action = url ;
		document.entryForm.submit();
	}

	return false;

}

// サブ画面を閉じる
function closeWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

}
// 入力チェック
function checkData(CheckMode) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var ret    = false;					// 関数戻り値
	var CheckRsl;
	var strErrMsg = '';

	switch (CheckMode){
		case 1 :
			// 事業部選択時のチェック
			if ( myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ){
				strErrMsg = '事業部を選択する場合、団体コードは必須入力です。';
			}
			break;
		case 2 :
			// 室部選択時のチェック
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' ){
				strErrMsg = '室部を選択する場合、団体，事業部コードは必須入力です。';
			}
			break;
		case 3 :
			// 所属選択時のチェック
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' && myForm.orgRoomCd.value == '' ){
				strErrMsg = '所属を選択する場合、団体，事業部，室部コードは必須入力です。';
			}
			break;
//		case 4 :
//			// 新規ボタンクリック時のチェック
//			if ( myForm.perId.value == '' ) {
//				strErrMsg = '新規入力を行う場合、個人ＩＤは必須入力です。';
//			}
//			break;
		case 5 :
			// 検索ボタンクリック時のチェック
			if ( myForm.orgCd1.value == '' && myForm.orgCd2.value == '' && myForm.perId.value == '' ){
				strErrMsg = '検索を行う場合、団体コードまたは個人ＩＤのいずれか必須入力です。';
			}
	}

	if( strErrMsg != '' ){
		alert(strErrMsg);
		return ret;
	}

	return(true);
}

// ## 2002.12.12 Add 8Lines by T.Takagi@FSIT （所属ガイド対応）ONLOADイベントにてエレメントの参照設定を行う
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
	}

}
// ## 2002.12.12 Add End
//-->
</SCRIPT>

<TITLE>傷病休業情報の検索</TITLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()" ONUNLOAD="JavaScript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="/webHains/contents/disease/perDiseaseList.asp" METHOD="get">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">傷病休業情報の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT ガイド呼び出し関数を変更しました
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
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT ガイド呼び出し関数を変更しました
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
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT ガイド呼び出し関数を変更しました
			<TD><A HREF="javascript:callOrgRoomGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearOrgRoomCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="室部をクリア"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="室部をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
			<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH=90" NOWRAP>所属</TD>
			<TD>：</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT ガイド呼び出し関数を変更しました
			<TD><A HREF="javascript:callOrgPostGuide(1)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(1)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>～</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT ガイド呼び出し関数を変更しました
			<TD><A HREF="javascript:callOrgPostGuide(2)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(2)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
		</TR>
		<TR>
			<TD WIDTH='90"' NOWRAP>受診者</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="個人をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= strPerID %>">
			<TD><SPAN ID="perName"><%= strLastName %>    <%= strFirstName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="90" NOWRAP>データ年月</TD>
			<TD>：</TD>
			<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, strDataYear , true) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("dataMonth", 1, 12, strDataMonth, true) %></TD>
			<TD>月</TD>
			<TD></TD>
			<TD>表示件数：</TD>
			<TD>
				<SELECT NAME="pageMaxLine">
					<OPTION VALUE="50"  <%= IIf(strPageMaxLine = 50,  "SELECTED", "")%>>50行ずつ
					<OPTION VALUE="100" <%= IIf(strPageMaxLine = 100, "SELECTED", "")%>>100行ずつ
					<OPTION VALUE="200" <%= IIf(strPageMaxLine = 200, "SELECTED", "" )%>>200行ずつ
					<OPTION VALUE="300" <%= IIf(strPageMaxLine = 300, "SELECTED", "" )%>>300行ずつ
					<OPTION VALUE="999999999" <%= IIf(strPageMaxLine = 999999999, "SELECTED", "" )%>>すべて
				</SELECT>
			</TD>
			<TD WIDTH="50"></TD>
			<TD ALIGN="right" VALIGN="middle">
				<TABLE WIDTH="180" BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD><A HREF="perDiseaseInfo.asp?mode=insert"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい傷病休業情報を登録します"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return showPerDisease(5)"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
						<TD></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<% 
'-------------------------------------------------------------------------------
' 検索結果の表示
'-------------------------------------------------------------------------------
	Do
		'初期表示モードなら何もしない
		If strMode = "" Then Exit Do

		'エラー時は何もしない
		If Not IsEmpty(vntMessage) Then Exit Do

		'有効なデータ年月が指定されている場合、編集
		strDataDate = strDataYear & "/" & strDataMonth & "/" & "1"
		If IsDate(strDataDate) = False Then
			strDataDate = ""
		End If

		'オブジェクトのインスタンス作成
		Set objPerDisease 	= Server.CreateObject("HainsPerDisease.PerDisease")

		'傷病休業情報件数取得
		lngAllCount = objPerDisease.SelectPerDisease("CNT", _
													strDataDate,	_
													strPerID,		_
													strOrgCd1,		_
													strOrgCd2,		_
													strOrgBsdCd,	_
													strOrgRoomCd,	_
													strOrgPostCd1,	_
													strOrgPostCd2, "")
													
%>
		<BR>検索結果は <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'レコード情報が存在しない場合、処理終了
		If lngAllCount = 0 Then
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
			<TR BGCOLOR="#cccccc"  ALIGN="CENTER">
				<TD NOWRAP ROWSPAN="2">従業員番号</TD>
				<TD NOWRAP ROWSPAN="2">氏　　名</TD>
				<TD NOWRAP ROWSPAN="2">年齢</TD>
				<TD NOWRAP COLSPAN="3" ALIGN="CENTER">疾病名・コード</TD>
				<TD NOWRAP COLSPAN="2" ALIGN="CENTER">休業状況</TD>
				<TD NOWRAP ROWSPAN="2">休業開始年月</TD>
				<TD NOWRAP ROWSPAN="2">療養<BR>区分</TD>
				<TD NOWRAP ROWSPAN="2">データ年月</TD>
				<TD ROWSPAN="2">性別</TD>
				<TD NOWRAP ROWSPAN="2">所属</TD>
				<TD NOWRAP ROWSPAN="2">団体</TD>
			</TR>
			<TR BGCOLOR="#cccccc">
				<TD NOWRAP>疾病名</TD>
				<TD NOWRAP>継続</TD>
				<TD NOWRAP>疾病コード</TD>
				<TD NOWRAP>休暇日数</TD>
				<TD NOWRAP>欠勤日数</TD>
			</TR>
<%
			'傷病休業情報取得
			lngCount = objPerDisease.SelectPerDisease("", _
														strDataDate,	_
														strPerID,		_
														strOrgCd1,		_
														strOrgCd2,		_
														strOrgBsdCd,	_
														strOrgRoomCd,	_
														strOrgPostCd1,	_
														strOrgPostCd2,	_
														"",               _
														lngStartPos, _
														strPageMaxLine, _
														arrPerId,		_
														arrEmpNo,		_
														arrLastName,	_
														arrFirstName,	_
														arrLastKName,	_
														arrFirstKName,	_
														arrBirth,		_
														arrAge,		_
														arrGender,		_
														arrOrgName,		_
														arrOrgPostName,	_
														arrDisCd,		_
														arrDisName,		_
														arrDataDate,	_
														arrOccurDate,	_
														arrHoliday,		_
														arrAbsence,		_
														arrContinues,	_
														arrMedicalDiv)

			strOldPerId = ""

			'傷病休業情報の編集
			For i = 0 To lngCount - 1
%>
				<TR  BGCOLOR="#eeeeee">
<%
					If strOldPerId = arrPerId(i) Then
%>
						<TD NOWRAP></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP></TD>
<%
					Else
%>
						<TD NOWRAP><%= arrEmpNo(i) %></TD>
						<TD NOWRAP><%= arrLastName(i) & "　" & arrFirstName(i) %><FONT SIZE="-1" COLOR="#666666">（<%= arrLastKName(i) & "　" &  arrFirstKName(i) %>）</FONT></TD>
						<TD NOWRAP><%= Int(arrAge(i)) %>歳</TD>
<%
					End If

					strHtml = "perDiseaseInfo.asp?mode=update&perId=" & arrPerId(i) & "&dataYear=" & Year(arrDataDate(i)) & "&dataMonth=" & Month(arrDataDate(i)) & "&disCd=" & arrDisCd(i)
%>
					<TD NOWRAP><A HREF="<%= strHtml %>" ><%= arrDisName(i) %></A></TD>
					<TD NOWRAP><%= strDspContinue(arrContinues(i)) %></TD>
					<TD NOWRAP><%= arrDisCd(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= arrHoliday(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= arrAbsence(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= DatePart("yyyy", arrOccurDate(i)) & "年" & DatePart("m", arrOccurDate(i)) & "月" %></TD>
					<TD NOWRAP><%= strDspMedicalDiv(arrMedicalDiv(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= DatePart("yyyy", arrDataDate(i)) & "年" & DatePart("m", arrDataDate(i)) & "月" %></TD>
					<TD NOWRAP><%= arrGender(i) %></TD>
					<TD NOWRAP><%= arrOrgPostName(i) %></TD>
					<TD NOWRAP><%= arrOrgName(i) %></TD>
				</TR>
<%
				strOldPerId = arrPerId(i)
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop

	Set objPerDisease = Nothing

	'ページングナビゲータの編集
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "mode=print"
		strSearchString = strSearchString & "&orgCd1="      & strOrgCd1
		strSearchString = strSearchString & "&orgCd2="      & strOrgCd2
		strSearchString = strSearchString & "&orgBsdCd="    & strOrgBsdCd
		strSearchString = strSearchString & "&orgRoomCd="   & strOrgRoomCd
		strSearchString = strSearchString & "&orgPostCd1="  & strOrgPostCd1
		strSearchString = strSearchString & "&orgPostCd2="  & strOrgPostCd2
		strSearchString = strSearchString & "&perId="       & strPerID
		strSearchString = strSearchString & "&dataYear="    & strDataYear
		strSearchString = strSearchString & "&dataMonth="   & strDataMonth
		strSearchString = strSearchString & "&pageMaxLine=" & strPageMaxLine
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
