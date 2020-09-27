<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		セット外請求明細表示 (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)


'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------

'定数の定義
Const MODE_INSERT   = "insert"	'処理モード(挿入)
Const MODE_UPDATE   = "update"	'処理モード(更新)
Const ACTMODE_SAVE  = "save"	'動作モード(保存)
Const ACTMODE_SAVED = "saved"	'動作モード(保存完了)

Dim objCommon				'共通クラス
Dim objPerbill				'受診情報アクセス用

Dim Ret						'関数戻り値
Dim lngRsvNo				'予約番号
Dim lngCount				'セット外明細件数
Dim lngBillCount			'請求書件数

Dim vntOtherLineDivCd		'セット外請求明細コード
Dim vntOtherLineDivName		'セット外請求明細名
Dim vntStdPrice				'標準単価
Dim vntStdTax				'標準税額

Dim strMode					'処理モード
Dim strAction				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス
Dim strHTML
Dim strArrMessage	'エラーメッセージ

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得
lngRsvNo     = Request("rsvno")
lngBillCount = Request("billcount")

Do


	'セット外請求明細情報の獲得
	lngCount = objPerbill.SelectOtherLineDiv(vntOtherLineDivCd, _
											 vntOtherLineDivName, _
											 vntStdPrice, _
											 vntStdTax )
	'セット外請求明細情報が存在しない場合
	If lngCount < 1 Then
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>セット外請求明細の選択</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// セット外請求明細のセット
function selectList( index ) {

	var objForm;		// 自画面のフォームエレメント
	var divCd;			// セット外請求書明細コード
	var divName;		// セット外請求書明細名
	var Price;			// 標準単価
	var TaxPrice;		// 標準税額

	objForm = document.entryForm;

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	// セット外請求明細コードの取得
	if ( objForm.divcd.length != null ) {
		divCd  = objForm.divcd[ index ].value;
	} else {
		divCd  = objForm.divcd.value;
	}

	// セット外請求明細名の取得
	if ( objForm.divname.length != null ) {
		divName = objForm.divname[ index ].value;
	} else {
		divName = objForm.divname.value;
	}

	// 標準金額の取得
	if ( objForm.price.length != null ) {
		Price = objForm.price[ index ].value;
	} else {
		Price = objForm.price.value;
	}

	// 標準税額の取得
	if ( objForm.taxprice.length != null ) {
		TaxPrice = objForm.taxprice[ index ].value;
	} else {
		TaxPrice = objForm.taxprice.value;
	}

	opener.setDivInfo( divCd, divName, Price, TaxPrice );

	// 画面を閉じる
	opener.winGuideOther = null;
	close();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">セット外請求明細の選択</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE WIDTH="262" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR ALIGN="right">
			<TD></TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="70" NOWRAP>金額</TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="70" NOWRAP>税額</TD>
		</TR>
<%
	Do
		For i=0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="divcd"    VALUE="<%= vntOtherLineDivCd(i) %>">
			<INPUT TYPE="hidden" NAME="divname" VALUE="<%= vntOtherLineDivName(i) %>">
			<INPUT TYPE="hidden" NAME="price"    VALUE="<%= vntStdPrice(i) %>">
			<INPUT TYPE="hidden" NAME="taxprice" VALUE="<%= vntStdTax(i) %>">
			<TR ALIGN="right">
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:selectList(<%= i %>)" CLASS="guideItem"><%= vntOtherLineDivName(i) %></A></TD>
				<TD></TD>
				<TD NOWRAP><%= FormatCurrency(vntStdPrice(i)) %></TD>
				<TD></TD>
				<TD NOWRAP><%= FormatCurrency(vntStdTax(i)) %></TD>
			</TR>
<%
		Next

		Exit Do
	Loop

%>
	</TABLE>
</FORM>
</BODY>
</HTML>