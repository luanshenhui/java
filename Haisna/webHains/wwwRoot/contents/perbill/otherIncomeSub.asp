<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		未入金請求書一覧表示 (Ver0.0.1)
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
Dim objPerbill				'受診情報アクセス用

Dim strDmdDate				'請求日
Dim lngBillSeq				'請求書Ｓｅｑ
Dim lngBranchNo				'請求書枝番

Dim Ret						'関数戻り値

'個人請求書情報用変数
Dim vntDmdDate				'請求日
Dim vntBillSeq				'請求書Ｓｅｑ
Dim vntBranchNo				'請求書枝番
Dim vntDelflg				'取消伝票フラグ
Dim vntUpdDate				'更新日時
Dim vntUpdUser				'ユーザＩＤ
Dim vntUserName				'ユーザ漢字氏名
Dim vntBillcoment			'請求書コメント
Dim vntPaymentDate			'入金日
Dim vntPaymentSeq			'入金Ｓｅｑ
Dim vntPrice                '金額
Dim vntEditPrice            '調整金額
Dim vntTaxPrice             '税額
Dim vntEditTax            	'調整税額
Dim vntLineTotal			'小計（金額、調整金額、税額、調整税額）


Dim lngCount				'取得件数

Dim lngRsvNo
Dim strLineName				'セット外請求明細名称
Dim lngDivCd				'セット外請求明細コード
Dim lngPrice				'金額
Dim lngEditPrice			'調整金額
Dim lngTaxPrice				'税額
Dim lngEditTax				'調整税額

Dim strMode					'処理モード
Dim strActMode				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス
Dim strHTML

Dim vntSubTotal

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得

'strDmdDate     = Request("dmddate")
'lngBillSeq     = Request("billseq")
'lngBranchNo    = Request("branchno")

strActMode     = Request("act")
strMode        = Request("mode")

strLineName    = Request("linename")
lngPrice       = Request("price")
lngEditPrice   = Request("editprice")
lngTaxPrice    = Request("taxprice")
lngEditTax     = Request("edittax")
lngDivCd       = Request("divcd")
lngRsvNo       = Request("rsvno")


Do

	'予約番号から個人請求書管理情報を取得する
	lngCount = objPerbill.SelectPerBill(lngRsvNo, _
										vntDmdDate, _
										vntBillSeq, _
										vntBranchNo, _
										vntDelflg, _
										vntUpdDate, _
										vntUpdUser, _
										vntUserName, _
										vntBillcoment, _
										vntPaymentDate, _
										vntPaymentSeq, _
										vntPrice, _
										vntEditPrice, _
										vntTaxPrice, _
										vntEditTax, _
										vntSubTotal )

	'個人請求書情報が存在しない場合
	If lngCount < 1 Then
		Err.Raise 1000, , "個人請求書情報が存在しません。（予約番号= " & lngRsvNo & " lngCount= " & lngCount & ")"
	End If

	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書番号選択</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
	td.prttab  { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■請求書番号選択</SPAN></B></TD>
		</TR>
	</TABLE>
	<!-- 引数情報 -->
	<INPUT TYPE="hidden" NAME="act"    VALUE="">
	<INPUT TYPE="hidden" NAME="mode">

	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="linename"  VALUE="<%= strLineName %>">
	<INPUT TYPE="hidden" NAME="price"     VALUE="<%= lngPrice %>">
	<INPUT TYPE="hidden" NAME="editprice" VALUE="<%= lngEditPrice %>">
	<INPUT TYPE="hidden" NAME="taxprice"  VALUE="<%= lngTaxPrice %>">
	<INPUT TYPE="hidden" NAME="edittax"   VALUE="<%= lngEditTax %>">
	<INPUT TYPE="hidden" NAME="divcd"     VALUE="<%= lngDivCd %>">


	<BR>
	<TR><B>請求書Ｎｏ．を選択して下さい。</B></TR>
	<BR>

	<FONT COLOR="black"><SPAN STYLE="color:#cc9999"></SPAN></FONT>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR BGCOLOR="CCCCCC">
			<TD NOWRAP ALIGN="left">請求書No.</TD>
			<TD NOWRAP>請求書発生日</TD>
			<TD NOWRAP ALIGN="RIGHT">　金額</TD>
			<TD NOWRAP ALIGN="RIGHT">調整金額</TD>
			<TD NOWRAP ALIGN="RIGHT">　税額</TD>
			<TD NOWRAP ALIGN="RIGHT">調整税額</TD>
			<TD NOWRAP ALIGN="RIGHT">小計</TD>
			<TD NOWRAP ALIGN="RIGHT">未収額</TD>
		</TR>
<%
	Do

		'個人負担請求書情報の編集
		For i = 0 To lngCount - 1
		If (IsNull(vntPaymentDate(i)) = True) AND (vntDelflg(i) = 0) Then
%>
				<TR BGCOLOR="#EEEEEE">
					<TD NOWRAP ALIGN="left"><A HREF="otherIncomeInfo.asp?linename=<%= strLineName %>&price=<%= lngPrice %>&editPrice=<%= lngEditPrice %>&taxprice=<%= lngTaxPrice %>&edittax=<%= lngEditTax %>&divcd=<%= lngDivCd %>&dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= lngRsvNo %>&act=save">
						<%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq(i), "00000") %>
						<%= vntBranchNo(i) %></A></TD>
					<TD NOWRAP><%= vntDmdDate(i) %><FONT COLOR="#666666"></FONT></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(vntSubTotal(i)) %></B></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><FONT COLOR="RED"><%= FormatCurrency(vntSubTotal(i)) %></FONT></B></TD>
				</TR>
<%
			End If
		Next
%>
	</TABLE>
<%
		Exit Do
	Loop
%>

	<BR>
<!-- KMT
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="190"></TD>
			<TD WIDTH="5"></TD>
			<TD>
				<A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
			</TD>
		</TR>
	</TABLE>
-->
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
