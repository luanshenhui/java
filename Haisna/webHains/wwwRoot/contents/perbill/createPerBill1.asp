<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書作成処理（枚数選択） (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

Dim objCommon				'共通クラス
Dim objDemand				'請求情報アクセス用
Dim objConsult				'受診情報アクセス用

Dim Ret						'関数戻り値

Dim lngCount				'取得件数
Dim lngBillCount			'取得件数
Dim lngSelectNo				'選択枚数
Dim lngRsvNo				'予約番号

'受診情報用変数
Dim strPerId				'個人ID
Dim strCslDate				'受診日
Dim strCsCd					'コースコード
Dim strCsName				'コース名
Dim strLastName				'姓
Dim strFirstName			'名
Dim strLastKName			'カナ姓
Dim strFirstKName			'カナ名
Dim strBirth				'生年月日
Dim strAge					'年齢
Dim strGender				'性別
Dim strGenderName			'性別名称
Dim strKeyDayId				'当日ID

'個人受診金額用変数
Dim vntOrgCd1               '団体コード１
Dim vntOrgCd2               '団体コード２
Dim vntOrgSeq				'契約パターンＳＥＱ
Dim vntOrgName              '団体名
Dim vntPrice                '金額
Dim vntEditPrice            '調整金額
Dim vntTaxPrice             '税額
Dim vntEditTax            	'調整税額
Dim vntLineTotal			'小計（金額、調整金額、税額、調整税額）
Dim vntPriceSeq             'ＳＥＱ
Dim vntCtrPtCd				'契約パターンコード
Dim vntOptCd				'オプションコード
Dim vntOptBranchNo			'オプション枝番
Dim vntOptName				'オプション名称
Dim vntOtherLineDivCd		'セット外名称区分
Dim vntLineName				'明細名称（セット外明細名称含む）
Dim vntDmdDate				'請求日
Dim vntBillSeq				'請求書Ｓｅｑ
Dim vntBranchNo				'請求書枝番
Dim vntBillLineNo			'請求書明細行No
Dim vntPaymentDate			'入金日
Dim vntPaymentSeq			'入金Ｓｅｑ

Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim i						'インデックス
Dim strHTML
Dim strArrMessage	'エラーメッセージ

strArrMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

lngRsvNo       = Request("rsvno")
lngSelectNo    = Request("selectno")

strAction      = Request("act")
strMode        = Request("mode")

'IIf( lngSelectNo = "" , "1", lngSelectNo)

Do

	If strAction = "move" Then
		Response.Redirect "createPerBill2.asp" & "?rsvno=" & lngRsvNo & "&selectno=" & lngSelectNo & "&act=new"
	End If


	'受診情報検索
	Ret = objConsult.SelectRslConsult(lngRsvNo,      _
									  strPerId,      _
									  strCslDate,    _
									  strCsCd,       _
									  strCsName,     _
									  strLastName,   _
									  strFirstName,  _
									  strLastKName,  _
									  strFirstKName, _
									  strBirth,      _
									  strAge,        _
									  strGender,     _
									  strGenderName, _
									  strKeyDayId)

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'個人受診金額情報取得
	lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
											 vntOrgCd1, _
											 vntOrgCd2, _
											 vntOrgSeq, _
											 vntOrgName, _
											 vntPrice, _
											 vntEditPrice, _
											 vntTaxPrice, _
											 vntEditTax, _
											 vntLineTotal, _ 
											 vntPriceSeq, _
											 vntCtrPtCd, _
											 vntOptCd, _
											 vntOptBranchNo, _
											 vntOptName, _
											 vntOtherLineDivCd, _
											 vntLineName, _
											 vntDmdDate, _
											 vntBillSeq, _
											 vntBranchNo, _
											 vntBillLineNo, _
											 vntPaymentDate, _
											 vntPaymentSeq )


	'受診金額情報が存在しない場合
	If lngCount < 1 Then
		Exit Do
	End If

	'作成請求書枚数カウント
	lngBillCount = 0
	For i=0 To lngCount - 1
		If ( ( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX") AND _
		    ((vntDmdDate(i) = "") OR (vntBillSeq(i) = "") OR (vntBranchNo(i) = "")) ) Then
			
			lngBillCount = lngBillCount + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 選択枚数のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function SelectList()

	Redim Preserve strArrSelectNo(lngBillCount-1)		'枚数
	Redim Preserve strArrSelectName(lngBillCount-1) 	'名称

	'固定値の編集

	For i=0 To lngBillCount - 1
		strArrSelectNo(i)  = i + 1
		strArrSelectName(i) = i + 1
	Next

'	SelectList = EditDropDownListFromArray("selectno", strArrSelectNo, strArrSelectName, IIf( lngSelectNo = "" , "1", lngSelectNo), NON_SELECTED_DEL)
	SelectList = EditDropDownListFromArray("selectno", strArrSelectNo, strArrSelectName, lngSelectNo, NON_SELECTED_DEL)

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>請求書作成（枚数選択）処理</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function changeUrl() {

	// モードを指定してsubmit
	document.entryForm.act.value = 'move';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="act" VALUE="">
<INPUT TYPE="hidden" NAME="RsvNo"   VALUE="<%= lngRsvNo %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>請求書作成（枚数選択）処理</B></TD>
	</TR>
</TABLE>

<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>予約番号</TD>
			<TD>：</TD>
			<TD><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診コース</TD>
			<TD>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName & " " & strFirstName %></a></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= strAge %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
		</TR>
	</TABLE>
	<BR>
<!-- 引数情報 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
<%
			If lngBillCount > 0 Then
%>
				<TD COLSPAN="5" NOWRAP><SPAN STYLE="color:#cc9999">●</SPAN>請求書作成枚数を入力してください。</TD>
				<TD NOWRAP><%= SelectList() %> 枚</TD>
<%
			Else
%>
				<TD NOWRAP><FONT COLOR="#ff6600"><B>個人請求書は全て作成済。</B></TD>
<%
			End If
%>
		</TR>
	</TABLE>

	<BR>

<!-- 修正時 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%"></TD>
<%
			If lngBillCount > 0 Then
				if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
				<TD><A HREF="javascript:changeUrl()"><IMG SRC="../../images/next.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="次へ"></A></TD>
<%
				End If
			End If
%>
			<TD>&nbsp;</TD>
			<TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
