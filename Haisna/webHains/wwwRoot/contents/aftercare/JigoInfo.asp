<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		事後措置入力 (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objAfterCare		'アフターケア情報用
Dim objPerson			'個人情報用
Dim objFree				'汎用情報用

Dim strArroverTimeDiv
strArroverTimeDiv = Array("なし","あり")

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
'アフターケア情報
Dim strArrContactDate	'面接日
Dim strArrContactYear	'面接年度
Dim strArrUserId 		'ユーザーＩＤ
Dim strArrRsvNo			'予約番号
Dim strArrUserName		'ユーザー名
Dim strArrBlood_H		'血圧（高）
Dim strArrBlood_L		'血圧（低）
Dim strArrCircumStances	'面接状況
Dim strArrCareComment	'コメント

'アフターケア管理項目
Dim strJudClassCd		'判定分類
Dim strJudClassName		'判定分類名
Dim strOtherJudClassName 'その他判定分類名

'アフターケア面接文書
Dim strSeq				'ＳＥＱＮＯ
Dim strGuidanceDiv		'指導内容区分
Dim strGuidance			'指導内容
Dim strContactStcCd		'定型面接文章コード
Dim strContactstc		'面接文書

'iniファイル取得要用
Dim strArrGuidanceDiv_ini
Dim strArrGuidance_ini

'個人情報
Dim strPerId			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード2
Dim strOrgKName			'団体カナ名称
Dim strOrgName			'団体漢字名称
Dim strOrgSName			'団体略称
Dim strOrgBsdCd			'事業所コード
Dim strOrgBsdKName		'事業部カナ名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomCd		'室部コード
Dim strOrgRoomName		'室部名称
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgPostCd		'所属部署コード
Dim strOrgPostName		'所属名称
Dim strOrgPostKName		'所属カナ名称
Dim strJobName			'職名
Dim strEmpNo			'従業員番号
Dim strWorkMeasureName	'事後措置区分名
Dim strOverTimeDiv		'超過勤務区分

Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）

Dim lngAfteCateCount	'アフターケア情報レコード件数
Dim lngAfteCateMCount	'アフターケア管理項目レコード件数
Dim lngAfteCateCCount	'アフターケア面接情文章レコード件数
Dim lngContactDateRowSpan	'HTML表示用
Dim lngContactRowSpan		'HTML表示用
Dim i,j,k				'ループカウント

Dim strAfterCareDiv

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

strPerId = Request("perId")

'オブジェクトのインスタンス作成
Set objPerson 	= Server.CreateObject("HainsPerson.Person")
Set objFree		= Server.CreateObject("HainsFree.Free")

'個人情報読み込み
objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
					   strLastKName, strFirstKName,  strBirth,        _
					   strGender,    strOrgCd1,      strOrgCd2,       _
					   strOrgKName,  strOrgName,     strOrgSName,     _
					   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
					   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
					   strOrgPostCd, strOrgPostName, strOrgPostKName, _
					   , strJobName, , , , , _
					   strEmpNo, , , , , , , , , , , , , _
					   strWorkMeasureName, strOverTimeDiv

'表示用名称の編集
strDispPerName 	= Trim(strLastName & "　" & strFirstName)
strDispPerKName = Trim(strLastKName & "　" & strFirstKName)

'年齢の算出
strDispAge = objFree.CalcAge(strBirth, Date, "")

'和暦編集
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'性別
strGender = IIf(strGender = CStr(GENDER_MALE), "男性", "女性")

'表示内容の編集
strDispBirth = strDispBirth & "生　" & strDispAge & "歳　" & strGender

'オブジェクトのインスタンスの開放
Set objPerson = Nothing

'アフターケア情報の検索
lngAfteCateCount = objAfterCare.SelectAfterCare( _
						strPerId , _
						strArrContactDate , _
						strArrContactYear , _
						strArrUserId , _
						strArrRsvNo , _
						strArrBlood_H , _
						strArrBlood_L , _
						strArrCircumStances , _
						strArrCareComment , _
						strArrUserName _
				   )

objAfterCare.GetGuidanceDiv strArrGuidanceDiv_ini, strArrGuidance_ini
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winInterview;	// 新規ウィンドウオブジェクト

function showInterview( mode, strContactDate, strUserId, strRsvNo ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var opened = false;	// 画面が開かれているか
	var url = '';

	// すでにガイドが開かれているかチェック
	if ( winInterview != null ) {
		if ( !winInterview.closed ) {
			opened = true;
		}
	}

	// URLの編集
	if ( mode != null ) {

		// 面接日押下
		url = '/webHains/contents/aftercare/AfterCareInterview.asp';
		url = url + '?perId='       + '<%= strPerId %>';
		url = url + '&contactDate=' + strContactDate;
		url = url + ( ( strRsvNo != '' ) ? '' : '&disp=1' );

	} else {

		// 新規登録
		url = '/webHains/contents/aftercare/SelectAfterCareDiv.asp';
		url = url + '?perId=<%= strPerId %>';

	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
//	if ( opened ) {
//		winInterview.location.replace( url );
//	} else {
//		winInterview = window.open( url, '', 'width=750,height=650,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no' );
//	}
	window.open( url, '', 'width=850,height=660,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no' );

}
//-->
</SCRIPT>
<TITLE>事後措置対象者の入力</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="" METHOD="GET">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">事後措置</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strPerId %>" TARGET="_BLANK"><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</A></TD>
<!--		<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="">健診結果を参照する</A></TD>-->
		<TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
<!--		<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="">既往歴・家族歴を参照する</A></TD> -->
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>団体：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;所属：</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;職種：</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
					<TR>
						<TD NOWRAP>就業措置区分：</TD>
						<TD NOWRAP><B><%= strWorkMeasureName %></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
						<TD NOWRAP>超過勤務区分：</TD>
						<TD NOWRAP><B><%= strArroverTimeDiv(Cint(strOverTimeDiv)) %></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
					</TR>
				</TABLE>
			</TD>
			<TD ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="/webHains/contents/maintenance/personal/mntPerInspection.asp?perid=<%= strPerId %>" TARGET="_BLANK">
					<IMG SRC="/webhains/images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="個人検査情報を修正します">
				</A>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="800">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">過去の面接情報</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<A HREF="javascript:showInterview()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい面接情報を登録します"></A><BR><BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2" WIDTH="800">
<%
		'アフターケア管理項目取得
		For i = 0 To lngAfteCateCount - 1
%>
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>面接日</TD>
			<TD NOWRAP>分類</TD>
			<TD WIDTH="160" NOWRAP>所見</TD>
			<TD COLSPAN="3" NOWRAP>面接結果</TD>
			<TD NOWRAP>担当</TD>
		</TR>
<%
		'アフターケア管理項目取得
		lngAfteCateMCount = objAfterCare.SelectAfterCareM( _
									strPerId , _
									strArrContactDate(i) , _
									strJudClassCd ,  _
									strJudClassName ,  _
									strOtherJudClassName _
													)

		'アフターケア面接文書取得
		lngAfteCateCCount = objAfterCare.SelectAfterCareC( _
									strPerId , _
									strArrContactDate(i) , _
									strSeq,  _
									strGuidanceDiv,  _
									strContactStcCd,  _
									strContactStc  _
													)

		lngContactDateRowSpan = lngAfteCateCCount + 3
		lngContactRowSpan = lngAfteCateCCount + 1

		'分類用文字列の編集
		If Trim(strArrRsvNo(i)) = "" Then
			strAfterCareDiv = "保健指導"
		Else
			strAfterCareDiv = "<A HREF=""/webHains/contents/common/dailyList.asp?navi=1&key=rsvno%3A" & strArrRsvNo(i) & """ TARGET=""_BLANK"">"
			strAfterCareDiv = strAfterCareDiv & "事後措置</A>"
		End If
%>
		<TR BGCOLOR="#eeeeee" VALIGN="top">
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><A HREF="javascript:showInterview( 1 , '<%= strArrContactDate(i) %>', '<%= strArrUserId(i) %>', '<%= strArrRsvNo(i) %>')"><%= strArrContactDate(i) %></A></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><%= strAfterCareDiv %></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="100%">
<%
					For j = 0 to lngAfteCateMCount - 1
%>
						<TR>
							<TD NOWRAP><%= strJudClassName(j) %></TD>
<%
							If( j + 1 <= lngAfteCateMCount - 1 ) Then
%>
								<TD NOWRAP><%= strJudClassName(j + 1) %></TD>
<%
								j = j + 1
							End If
%>
						</TR>
<%
					Next
%>
				</TABLE>
			</TD>
			<TD BGCOLOR="#cccccc" NOWRAP>状況</TD>
			<TD COLSPAN="2"><%= Replace(strArrCircumStances(i), vbCrLf, "<BR>") %></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><%= strArrUserName(i) %></TD>
		</TR>
		<TR BGCOLOR="#cccccc" VALIGN="top">
			<TD ROWSPAN="<%= lngContactRowSpan %>" NOWRAP>面接指導</TD>
			<TD NOWRAP>指導内容</TD>
			<TD WIDTH="100%" NOWRAP>指導文章</TD>
		</TR>
<%
		For k = 0 to lngAfteCateCCount - 1
%>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strArrGuidance_ini(CINT(strGuidanceDiv(k)) - 1 )%></TD>
				<TD NOWRAP><%= strContactStc(k) %></TD>
			</TR>
<%
		Next
%>
		<TR BGCOLOR="#eeeeee" VALIGN="top">
			<TD BGCOLOR="#cccccc" NOWRAP>総評</TD>
			<TD COLSPAN="2"><%= Replace(strArrCareComment(i), vbCrLf, "<BR>") %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
<%
	Next
%>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
