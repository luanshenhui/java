<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       請求書基本情報 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数値
Dim strMode					'処理モード(削除時:"delete")
Dim strAction				'処理状態（確定・削除ボタン押下時:"save"，保存完了後:"saveend"，
							'          印刷ボタン押下時:"print"，印刷完了後:"printend"）
Dim strBillNo				'請求書番号(空白時:"新規")

'請求書情報
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strOrgName				'団体名称
Dim lngCloseYear			'締め日（年）
Dim lngCloseMonth			'締め日（月）
Dim lngCloseDay				'締め日（日）
Dim strCloseDate			'締め日
Dim lngMethod				'作成方法(0:手入力による作成 1:締め処理により作成)
Dim strTaxRates				'適用税率
Dim lngPrtYear				'請求書出力日（年）
Dim lngPrtMonth				'請求書出力日（月）
Dim lngPrtDay				'請求書出力日（日）
Dim strPrtDate				'請求書出力日
Dim blnPaymentFlg			'入金データ存在フラグ
'2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
Dim strSecondFlg			'２次検査フラグ
'2004.06.02 ADD END

Dim strBillClassCd			'請求書分類コード
Dim strBillClassName		'請求書分類名

Dim strPaymentBill			'入金済み請求書削除フラグ(0:入金済み請求書削除不可 1:入金済み請求書削除可)

Dim objDemand				'請求情報アクセス用COMオブジェクト
Dim objOrganization			'団体情報アクセス用COMオブジェクト
Dim objCommon				'共通関数アクセス用COMオブジェクト
Dim objReportLog			'印刷ログ用COMオブジェクト

Dim strArrMessage			'エラーメッセージ
Dim strRet					'関数戻り値
Dim i						'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値取得
strMode        = Request("mode")
strAction      = Request("act")
strBillNo      = Request("billNo")

'請求書情報取得
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strBillClassCd = Request("billClassCd")

lngCloseYear   = CLng("0" & Request("closeYear"))
lngCloseMonth  = CLng("0" & Request("closeMonth"))
lngCloseDay    = CLng("0" & Request("closeDay"))
lngMethod      = CLng("0" & Request("billMethod"))
strTaxRates    = Request("taxRates")
lngPrtYear     = CLng("0" & Request("prtYear"))
lngPrtMonth    = CLng("0" & Request("prtMonth"))
lngPrtDay      = CLng("0" & Request("prtDay"))
'2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
strSecondFlg   = Request("secondFlg")
'2004.06.02 ADD END

lngCloseYear   = IIf(lngCloseYear  = 0, Year(Now),    lngCloseYear )
lngCloseMonth  = IIf(lngCloseMonth = 0, Month(Now),   lngCloseMonth)
lngCloseDay    = IIf(lngCloseDay   = 0, Day(Now),     lngCloseDay  )
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書基本情報登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<%

'オブジェクトのインスタンス作成
Set objDemand = Server.CreateObject("HainsDemand.Demand")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objCommon = Server.CreateObject("HainsCommon.Common")

'団体名称取得
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Call objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName)
End If

'入金済み請求書削除フラグ
strPaymentBill = CLng(objCommon.SelectPaymentBillDelete())

Do

	'保存処理
	If strAction = "save" Then
		'入力チェック
		strArrMessage = objDemand.CheckValueDmdOrgMasterBurden(lngCloseYear, lngCloseMonth, _
																lngCloseDay, strCloseDate, _
																strOrgCd1, strOrgCd2, _
																strTaxRates, _
																lngPrtYear, lngPrtMonth, _
																lngPrtDay, strPrtDate)

		'入力エラー時は何もしない
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

'2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'		'新規作成時
'		strRet = objDemand.InsertBill(strBillNo, _
'										strCloseDate, _
'										strOrgCd1, _
'										strOrgCd2, _
'										strPrtDate, _
'										strTaxRates)
		'新規作成時
		strRet = objDemand.InsertBill(strBillNo, _
										strCloseDate, _
										strOrgCd1, _
										strOrgCd2, _
										strPrtDate, _
										strTaxRates, _
										strSecondFlg)
'2004.06.02 MOD END

		'キー重複時はエラーメッセージを編集する
		If strRet = INSERT_DUPLICATE Then
			strArrMessage = Array("同一索引の請求書情報がすでに存在します。")
			Exit Do
		End If

		'オブジェクトのインスタンス削除
		Set objDemand = Nothing
		Set objOrganization = Nothing

		'保存完了
		Response.Write "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?billNo=" & strBillNo & "'"">"
		Response.Write "</BODY></HTML>"
		Response.End

	End If

	'初期表示時
	If strAction = "" Then
		'適用税率取得
		Call objDemand.GetNowTax(Date, strTaxRates, 0)
	End If

	'請求書修正時
'	If strBillNo <> "" Then

		'請求書情報取得
'		strRet = objDemand.SelectDmdOrgMasterBurden(strBillNo, _
'													strCloseDate, _
'													strOrgCd1, _
'													strOrgCd2, _
'													strOrgName, _
'													strBillClassCd, _
'													strBillClassName, _
'													lngMethod, _
'													strTaxRates, _
'													strPrtDate, _
'													blnPaymentFlg)

'		If strRet = False Then
'			strArrMessage = Array("請求書情報が取得できませんでした 請求書番号:" & strBillNo)
'			strAction = "error"
'			Exit Do
'		End If

		'締め日を年・月・日に分解
'		lngCloseYear = Year(strCloseDate)
'		lngCloseMonth = Month(strCloseDate)
'		lngCloseDay = Day(strCloseDate)

		'請求書出力日を年・月・日に分解
'		If IsDate(strPrtDate) Then
'			lngPrtYear = Year(strPrtDate)
'			lngPrtMonth = Month(strPrtDate)
'			lngPrtDay = Day(strPrtDate)
'		Else
'			lngPrtYear = 0
'			lngPrtMonth = 0
'			lngPrtDay = 0
'		End If
'		'入金済み請求書の削除が可能の場合、常に入金情報なし扱い
'		If strPaymentBill = PAYMENTBILL_DELETE_ENABLED Then
'			blnPaymentFlg = False
'		End If
'	Else
'		'新規作成時は、作成方法＝手入力作成
'		lngMethod = BILL_METHOD_MAN
'	End If

	Exit Do
Loop

'オブジェクト削除
Set objDemand = Nothing
Set objOrganization = Nothing
%>

<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
var myForm;		// 自フォーム

// 団体検索ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.dmdOrgMasterBurden.orgCd1, document.dmdOrgMasterBurden.orgCd2, 'orgName', '', '');

}

// 親ウインドウへ戻る
function goBackPage() {

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.dmdOrgMasterBurden_CalledFunction != null ) {
		opener.dmdOrgMasterBurden_CalledFunction();
	}

	close();

	return false;
}

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#ffffff" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">
<FORM NAME="dmdOrgMasterBurden" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求書基本情報登録</FONT></B></TD>
	</TR>
</TABLE>
<%
	'メッセージの編集
	If strAction <> "" Then

		'保存完了時は「保存完了」の通知
		If strAction = "saveend" Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)
		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
<BR>
<INPUT TYPE="hidden" NAME="mode">
<INPUT TYPE="hidden" NAME="act" VALUE="save">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="billMethod" VALUE="<%= lngMethod %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<!--
	<TR>
						<TD NOWRAP HEIGHT="23">請求書番号</TD>
						<TD>：</TD>
		<TD NOWRAP><%= strBillNo %>　<FONT COLOR="#999999"><%= IIf(lngMethod = BILL_METHOD_PRG,"（締め処理で作成されました）","") %></FONT>
		</TD>
	</TR>
-->
	<TR>
						<TD NOWRAP HEIGHT="23">請求先団体</TD>
						<TD>：</TD>
		<TD NOWRAP>
			<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
			<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
					<TD WIDTH="5"></TD>
					<TD WIDTH="310"><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP HEIGHT="23">締め日</TD>
		<TD>：</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
				<TR>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('closeYear', 'closeMonth', 'closeDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
				<TD><%= EditNumberList("closeYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCloseYear, False) %></TD>
				<TD>年</TD>
				<TD><%= EditNumberList("closeMonth", 1, 12, lngCloseMonth, False) %></TD>
				<TD>月</TD>
				<TD><%= EditNumberList("closeDay", 1, 31, lngCloseDay, False) %></TD>
				<TD>日</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>請求書出力日</TD>
		<TD>：</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
				<TR>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
				<TD><A HREF="JavaScript:calGuide_clearDate('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
				<TD><%= EditNumberList("prtYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPrtYear, True) %></TD>
				<TD>年</TD>
				<TD><%= EditNumberList("prtMonth", 1, 12, lngPrtMonth, True) %></TD>
				<TD>月</TD>
				<TD><%= EditNumberList("prtDay", 1, 31, lngPrtDay, True) %></TD>
				<TD>日</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
<!--
	<tr>
		<td nowrap></td>
		<td></td>
		<td><FONT COLOR="#999999">※請求書出力日を消すと請求書が未出力となり明細が修正できます。</FONT></td>
	</tr>
-->
	<TR>
		<TD NOWRAP>税率</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="text" NAME="taxRates" SIZE="8" MAXLENGTH="8" style="text-align:right" VALUE="<%= strTaxRates %>"><FONT COLOR="#999999">　※5%の場合、0.05と入力してください。</FONT></TD>
	</TR>
<% '2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加 %>
	<TR>
		<TD NOWRAP>２次検査</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="checkbox" NAME="secondFlg" VALUE="1"><FONT COLOR="#999999">　※２次検査請求書の場合、チェックしてください。</FONT></TD>
	</TR>
<% '2004.06.02 ADD END %>
</TABLE>
<BR><BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="right">
	<TR>
		<TD WIDTH="160"></TD>
		<TD WIDTH="5"></TD>

		<TD>
		<% '2005.08.22 権限管理 Add by 李　--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
			<A HREF="JavaScript:document.dmdOrgMasterBurden.submit()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容を保存"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 権限管理 Add by 李　--- END %>
		</TD>
		
		<TD WIDTH="5"></TD>
		<TD><A HREF="javascript:opener.winfl=0;window.close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
	</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
