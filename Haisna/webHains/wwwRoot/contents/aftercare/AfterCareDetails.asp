<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接情報の登録(Ver0.0.1)
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

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Const lngGuidanceDivCount = 8	'指導内容表示数

'個人情報
Dim strPerId			'個人ＩＤ
Dim strContactDate		'面接日

'アフターケア情報
Dim strArrContactYear	'面接年度
Dim strArrUserId 		'ユーザーＩＤ
Dim strArrRsvNo			'予約番号
Dim strArrUserName		'ユーザー名
Dim strArrBlood_H		'血圧（高）
Dim strArrBlood_L		'血圧（低）
Dim strArrCircumStances	'面接状況
Dim strArrCareComment	'コメント

'アフターケア面接文書情報
Dim strSeq				'ＳＥＱＮＯ
Dim strGuidanceDiv		'指導内容区分
Dim strGuidance			'指導内容
Dim strContactStcCd		'定型面接文章コード
Dim strContactstc		'面接文書


'iniファイル定義内容
Dim vntGuidanceDivCd	'指導内容区分
Dim vntGuidanceDiv		'指導内容文字列

'画面表示用
Dim strBlood_H			'血圧（高）
Dim strBlood_L			'血圧（低）
Dim strCircumStances	'面接状況
Dim strCareComment		'コメント


Dim lngAfteCateCount	'アフターケアレコードカウント
Dim lngAfteCateCCount	'アフターケア面接文書レコードカウント
Dim lngLudClassCount	'レコードカウント
Dim i,j					'ループカウント

Dim strSelectedDiv		'初期表示時に選択済みにする区分

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")

strPerId			= Request("perId")
strContactDate		= Request("contactDate")

'iniファイルから指導内容を取得
lngLudClassCount = objAfterCare.GetGuidanceDiv( vntGuidanceDivCd , vntGuidanceDiv )

'アフターケア情報の検索
If( strPerId <> "" And strContactDate <> "") Then

	lngAfteCateCount = objAfterCare.SelectAfterCare( _
								strPerId , _
								strContactDate , _
								strArrContactYear , _
								strArrUserId , _
								strArrRsvNo , _
								strArrBlood_H , _
								strArrBlood_L , _
								strArrCircumStances , _
								strArrCareComment , _
								strArrUserName _
													)

	strBlood_H 			= strArrBlood_H( lngAfteCateCount - 1 )
	strBlood_L 			= strArrBlood_L( lngAfteCateCount - 1 )
	strCircumStances 	= strArrCircumStances( lngAfteCateCount - 1 )
	strCareComment 		= strArrCareComment( lngAfteCateCount - 1 )

'アフターケア面接文書取得
	lngAfteCateCCount = objAfterCare.SelectAfterCareC( _
								strPerId , _
								strContactDate( lngAfteCateCount - 1 ) , _
								strSeq,  _
								strGuidance,  _
								strContactStcCd,  _
								strContactstc  _
	 												)

End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接情報の登録</TITLE>
<!-- #include virtual = "/WebHains/includes/ContactStcGuide.inc" -->

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

// 面接文書ガイド表示
function callStcGuide(lngArrCount) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント
	var strSpanName = 'guidance' + lngArrCount;

	contactStcGuide_showGuideContactStc( objForm.guidanceDiv[ lngArrCount ], objForm.contactStcCd[ lngArrCount ], strSpanName, null , false );

}
// 面接文書クリア
function clearStc(lngArrCount) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント
	var strSpanName = 'guidance' + lngArrCount;
	contactStcGuide_clearContactStcInfo( objForm.guidanceDiv[ lngArrCount ], objForm.contactStcCd[ lngArrCount ], strSpanName);

}

//-->
</SCRIPT>
</HEAD>
<BODY>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return false;">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>血圧（高／低）</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE=text" SIZE="9" MAXLENGTH="6" NAME="bloodPressure_h" VALUE="<%= strBlood_H %>"></TD>
						<TD>／</TD>
						<TD><INPUT TYPE=text" SIZE="9" MAXLENGTH="6" NAME="bloodPressure_l" VALUE="<%= strBlood_L %>"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>面接状況</TD>
			<TD>：</TD>
			<TD><TEXTAREA NAME="circumStances" COLS="76" ROWS="5"><%= strCircumStances %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>面接内容</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR ALIGN="center" BGCOLOR="#cccccc">
						<TD NOWRAP>指導内容</TD>
						<TD COLSPAN="3" NOWRAP>指導文章</TD>
					</TR>
<%
			For i = 0 to lngGuidanceDivCount
%>
					<TR>
<%
				If( i < lngAfteCateCCount ) Then
%>
					<TD><%= EditDropDownListFromArray("guidanceDiv", vntGuidanceDivCd, vntGuidanceDiv , vntGuidanceDivCd(Cint(strGuidance(i) - 1 )), NON_SELECTED_ADD) %></TD>
					<TD><A HREF="javascript:callStcGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="面接コメントガイドを表示します"></A></TD>
					<TD><A HREF="javascript:clearStc(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="100%" NOWRAP><SPAN ID="guidance<%= i %>"><%= strContactstc(i) %></SPAN>
					<INPUT TYPE="hidden" NAME="contactStcCd"  VALUE="<%= strContactStcCd(i) %>"></TD>
<%
				Else

					'上３つ、かつ新規登録の場合は初期表示時に、デフォルトセット
					If (i < 3)  And (lngAfteCateCCount <= 0) And (lngAfteCateCount <= 0)Then
						strSelectedDiv = vntGuidanceDivCd(i)
					Else
						strSelectedDiv = ""
					End If

%>
					<TD><%= EditDropDownListFromArray("guidanceDiv", vntGuidanceDivCd, vntGuidanceDiv , strSelectedDiv , NON_SELECTED_ADD) %></TD>
					<TD><A HREF="javascript:callStcGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="面接コメントガイドを表示します"></A></TD>
					<TD><A HREF="javascript:clearStc(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="100%" NOWRAP><SPAN ID="guidance<%= i %>"></SPAN>
					<INPUT TYPE="hidden" NAME="contactStcCd"  VALUE=""></TD>
<%
				End If
%>
					</TR>
<%			
			Next
%>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>総評</TD>
			<TD>：</TD>
			<TD><TEXTAREA NAME="careComment" COLS="76" ROWS="5"><%= strCareComment %></TEXTAREA></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
