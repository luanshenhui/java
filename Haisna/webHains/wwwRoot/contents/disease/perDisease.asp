<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		既往歴・家族歴 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim strMode  		'処理モード(削除:"delete")
Dim strPerID		'個人ＩＤ
Dim strRelation		'続柄
Dim strDisCd		'病名コード
Dim strDisName		'病名
Dim strStrDate		'発病年月
Dim strEndDate		'治癒年月
Dim strCondition	'状態
Dim strMedical		'医療機関

Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGenderName	'性別名称

Dim lngAllCount		'条件を満たす全レコード件数
Dim lngCount		'レコード件数

Dim strDispStrDate	'編集用の発病年月
Dim strDispEndDate	'編集用の治癒年月

Dim objCommon		'続柄、状態情報アクセス用COMオブジェクト
Dim objDisease		'既往歴家族歴情報アクセス用COMオブジェクト
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------

'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'引数値の取得
strMode		= Request("mode") & ""
strPerID	= Request("perID") & ""
strRelation	= Request("relation") & ""
strDisCd	= Request("disCd") & ""
strStrDate	= Request("strDate") & ""

Do
	'削除モードで起動されたとき、削除を行う
	If strMode = "delete" Then

		objDisease.DeleteDisHistory strPerID, strRelation, strDisCd, strStrDate

	End If

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
<TITLE>既往歴・家族歴</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function deleteCheck(jumpUrl, paraRelationName, paraDisName, paraDispStrDate){

	if(paraRelationName=='')
	{
		res=confirm("発病年月：" + paraDispStrDate + "　既往症：" + paraDisName + "の既往歴を削除します。よろしいですか？");
	}
	else
	{
		res=confirm("続柄：" + paraRelationName + "　病名：" + paraDisName + "　発病年月：" + paraDispStrDate + "の家族歴を削除します。よろしいですか？");
	}
	if(res==true){
		location.replace(jumpUrl); 
	}

	return false;
}

//-->
</SCRIPT>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<FORM NAME="diseaselist" action="#">
	<BLOCKQUOTE>

<%
		'個人情報のレコードを取得
		If objDisease.SelectPerson(strPerID, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGenderName) Then

			'個人情報の編集
%>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
				<TR>
					<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerID %></TD>
					<TD NOWRAP><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
				</TR>
				<TR>
					<TD NOWRAP><%= strBirth %>生　<%= strGenderName %></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR>

		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
			<TR VALIGN="bottom">
				<TD COLSPAN="2"><FONT SIZE="+2"><B>既往歴・家族歴</B></FONT></TD>
			</TR>
			<TR HEIGHT="2">
				<TD COLSPAN="2" BGCOLOR="#CCCCCC"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
			</TR>
		</TABLE>
		<BR>

		<BR>
		<TABLE WIDTH="500" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD BGCOLOR="#999999" WIDTH="20%">
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH=100%>
						<TR HEIGHT="15">
							<TD BGCOLOR=#eeeeee NOWRAP><B>既往歴</B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
<%
				'既往歴のレコード件数を取得
				lngAllCount = objDisease.SelectDiseaseListCount(strPerID)
				'既往歴が存在しない場合はメッセージを編集
				If lngAllCount = 0 Then
%>
					<TD NOWRAP>既往歴の登録件数は０件です。</TD>
<%
				Else
%>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2">
							<TR BGCOLOR="CCCCCC" ALIGN="CENTER">
								<TD NOWRAP>発病年月</TD>
								<TD NOWRAP>既往症</TD>
								<TD NOWRAP>医療機関</TD>
								<TD NOWRAP>治癒年月</TD>
								<TD NOWRAP>状態</TD>
								<TD WIDTH="45" NOWRAP>操作</TD>
							</TR>
<%
							'既往歴のレコードを取得
							lngCount = objDisease.SelectDiseaseList(strPerID, strStrDate, strDisCd, strDisName, strMedical, strEndDate, strCondition)

							For i = 0 To lngCount - 1
								strDispStrDate = objCommon.FormatString(strStrDate(i), "yyyy年mm月")
								If strEndDate(i) = "" Then
									strDispEndDate =  strEndDate(i)
								Else
									strDispEndDate = objCommon.FormatString(strEndDate(i), "yyyy年mm月")
								End If

								'既往歴の編集
%>
								<TR BGCOLOR="EEEEEE">
									<TD NOWRAP><%= strDispStrDate %></TD>
									<TD NOWRAP><A HREF="/webHains/contents/disease/perEntryDisease.asp?mode=update&perID=<%= strPerID %>&relation=0&disCd=<%= strDisCd(i) %>&stryear=<%= Year(strStrDate(i)) %>&strmonth=<%= Month(strStrDate(i)) %>"><%= strDisName(i) %></A></TD>
									<TD NOWRAP><%= strMedical(i) %></TD>
									<TD NOWRAP><%= strDispEndDate %></TD>
									<TD NOWRAP><%= objCommon.SelectConditionName(strCondition(i)) %></TD>
									<TD ALIGN="center" WIDTH="45" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteCheck('<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=delete&perID=<%= strPerID %>&relation=0&disCd=<%= strDisCd(i) %>&strDate=<%= strStrDate(i) %>', '', '<%= strDisName(i) %>', '<%= strDispStrDate %>')">削除</A></TD>
								</TR>
<%
							Next
%>
						</TABLE>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
						<TR HEIGHT="15" ALIGN="CENTER">
							<TD BGCOLOR="#FFCCCC" NOWRAP><B><A HREF="/webHains/contents/disease/perEntryDisease.asp?mode=insert&perID=<%= strPerID %>&relation=0">新しい既往症情報を追加</A></B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
		<BR>

		<BR>
		<TABLE WIDTH="500" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD BGCOLOR="#999999" WIDTH="20%">
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH=100%>
						<TR HEIGHT="15">
							<TD BGCOLOR=#eeeeee NOWRAP><B>家族歴</B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
<%
				'家族歴のレコード件数を取得
				lngAllCount = objDisease.SelectFamilyListCount(strPerID)
				'家族歴が存在しない場合はメッセージを編集
				If lngAllCount = 0 Then
%>
					<TD NOWRAP>家族歴の登録件数は０件です。</TD>
<%
				Else
%>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2">
							<TR BGCOLOR="CCCCCC" ALIGN="CENTER">
								<TD NOWRAP>続柄</TD>
								<TD NOWRAP>病名</TD>
								<TD NOWRAP>発病年月</TD>
								<TD NOWRAP>治癒年月</TD>
								<TD NOWRAP>状態</TD>
								<TD WIDTH="45" NOWRAP>操作</TD>
							</TR>
<%
							'家族歴のレコードを取得
							lngCount = objDisease.SelectFamilyList(strPerID, strRelation, strDisCd, strDisName, strStrDate, strEndDate, strCondition)

							For i = 0 To lngCount - 1
								strDispStrDate = objCommon.FormatString(strStrDate(i), "yyyy年mm月")
								If strEndDate(i) = "" Then
									strDispEndDate =  strEndDate(i)
								Else
									strDispEndDate = objCommon.FormatString(strEndDate(i), "yyyy年mm月")
								End If

								'家族歴の編集
%>
								<TR BGCOLOR="EEEEEE">
									<TD NOWRAP><%= objCommon.SelectRelationName(strRelation(i)) %></TD>
									<TD NOWRAP><A HREF="/webHains/contents/disease/perEntryFamily.asp?mode=update&perID=<%= strPerID %>&relation=<%= strRelation(i) %>&disCd=<%= strDisCd(i) %>&stryear=<%= Year(strStrDate(i)) %>&strmonth=<%= Month(strStrDate(i)) %>"><%= strDisName(i) %></A></TD>
									<TD NOWRAP><%= strDispStrDate %></TD>
									<TD NOWRAP><%= strDispEndDate %></TD>
									<TD NOWRAP><%= objCommon.SelectConditionName(strCondition(i)) %></TD>
									<TD ALIGN="center" WIDTH="45" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteCheck('<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=delete&perID=<%= strPerID %>&relation=<%= strRelation(i) %>&disCd=<%= strDisCd(i) %>&strDate=<%= strStrDate(i) %>', '<%= objCommon.SelectRelationName(strRelation(i)) %>', '<%= strDisName(i) %>', '<%= strDispStrDate %>')">削除</A></TD>
								</TR>
<%
							Next
%>
						</TABLE>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
						<TR HEIGHT="15" ALIGN="CENTER">
							<TD BGCOLOR="#FFCCCC" NOWRAP><B><A HREF="/webHains/contents/disease/perEntryFamily.asp?mode=insert&perID=<%= strPerID %>">新しい家族症情報を追加</A></B></TD>
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
