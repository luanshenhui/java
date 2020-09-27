<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       請求書削除 (Ver1.0.0)
'       AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数値
Dim strAction				'処理状態(検索ボタン押下時"select")
Dim lngYear					'表示開始年
Dim lngMonth				'表示開始月
Dim lngDay					'表示開始日
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
'Dim strIsDeleteHand			'手動作成データの削除有無
'Dim strIsDeletePayment		'入金済みデータの削除有無

Dim strDate					'日付
Dim strOrgName				'団体名称

Dim objDemand				'請求情報アクセス用COMオブジェクト
Dim objOrganization			'団体情報アクセス用COMオブジェクト

Dim strArrMessage			'メッセージ
Dim lngMessageIcon			'メッセージ用アイコン
Dim lngDeleteCount			'削除済み件数
Dim i						'インデックス
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAction          = Request("act")
lngYear            = CLng("0" & Request("strYear"))
lngMonth           = CLng("0" & Request("strMonth"))
lngDay             = CLng("0" & Request("strDay"))
strOrgCd1          = Request("orgCd1")
strOrgCd2          = Request("orgCd2")
'strIsDeleteHand    = Request("IsDeleteHand")
'strIsDeletePayment = Request("IsDeletePayment")
strArrMessage      = ""

'未指定時は初期値セット
lngYear    = IIf(lngYear  = 0, Year(Now),    lngYear )
lngMonth   = IIf(lngMonth = 0, Month(Now),   lngMonth)
lngDay     = IIf(lngDay   = 0, Day(Now),     lngDay  )
strDate    = lngYear & "/" & lngMonth & "/" & lngDay

'団体名称取得
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	Call objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName)
	Set objOrganization = Nothing
End If

Do

	'検索処理
	If strAction = "delete" Then
		lngMessageIcon = MESSAGETYPE_WARNING

		'入力日付のチェック
		If Not IsDate(strDate) Then
			strArrMessage = "締め日の入力形式が正しくありません。"
			Exit Do
		End If

		'条件に合致する請求情報を検索
		Set objDemand = Server.CreateObject("HainsDemand.Demand")
		lngDeleteCount = objDemand.DeleteAllBill(strDate, strOrgCd1, strOrgCd2)
'		lngDeleteCount = objDemand.DeleteAllBill(strDate, strOrgCd1, strOrgCd2, strIsDeleteHand, strIsDeletePayment)
		If lngDeleteCount < 0 Then
			strArrMessage = "請求書削除処理に失敗しました。"
			strAction = "error"
		Else
			strArrMessage = lngDeleteCount & "件の請求書を削除しました。"
			lngMessageIcon = MESSAGETYPE_NORMAL
		End If
		Set objDemand = Nothing

	End If

	Exit Do

Loop

'オブジェクトのインスタンス削除
Set objDemand = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書削除</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winDmdPayment;				// ウィンドウハンドル
var dmdPayment_CalledFunction;	// 入金処理後呼び出し関数

// 団体検索ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entrycondition.orgCd1, document.entrycondition.orgCd2, 'orgName');

}

// 団体コード削除
function delOrgCd() {

	orgGuide_clearOrgInfo(document.entrycondition.orgCd1, document.entrycondition.orgCd2, 'orgName');

}
// 検索ボタン押下時の処理
function submitSearch() {

	if ( !confirm( '指定された条件で請求書を削除します。よろしいですか？' ) ) {
		return;
	}
	document.entrycondition.act.value = 'delete';
	document.entrycondition.submit();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entrycondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="act" VALUE="">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求書削除</FONT></B></TD>
	</TR>
</TABLE>
<%
	If strArrMessage <> "" Then
		Call EditMessage(strArrMessage, lngMessageIcon)
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">締め日</TD>
		<TD>：</TD>
		<TD COLSPAN="5">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngDay, False) %></TD>
					<TD>日</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">請求先</TD>
		<TD>：</TD>
		<TD COLSPAN="5">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return delOrgCd()"><IMG SRC="../../images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="5"></TD>
					<TD><INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"></TD>
					<TD><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>"></TD>
					<TD WIDTH="400">
						<SPAN ID="orgName" STYLE="position:relative"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="10"></TD>
	</TR>
	<TR>
		<TD COLSPAN=8 ALIGN="right">
		<% '2005.08.22 権限管理 Add by 李　--- START %>
		<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()">
			<IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="請求書を削除します。">
			</A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 権限管理 Add by 李　--- END %>
		</TD>
	</TR>
<!--
	<TR HEIGHT="21">
		<TD WIDTH="10"></TD>
		<TD WIDTH="70"></TD>
		<TD></TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="isDeleteHand">手入力で作成した請求書も削除する</TD>
	</TR>
	<TR HEIGHT="24">
		<TD WIDTH="10"></TD>
		<TD WIDTH="70"></TD>
		<TD></TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="isDeletePayment">入金済み請求書も削除する</TD>
		<TD>
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()">
			<IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="請求書を削除します。">
			</A>
		</TD>
	</TR>
</TABLE>
-->
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
