<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		個人受診金額表示 (Ver0.0.1)
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
'定数の定義
Const MODE_INSERT   = "insert"	'処理モード(挿入)
Const MODE_UPDATE   = "update"	'処理モード(更新)
Const ACTMODE_SAVE  = "save"	'動作モード(保存)
Const ACTMODE_SAVED = "saved"	'動作モード(保存完了)

Dim objCommon				'共通クラス
Dim objDemand				'請求情報アクセス用
Dim objConsult				'受診情報アクセス用
Dim objPerbill				'受診情報アクセス用


Dim strDmdDate				'請求日
Dim lngBillSeq				'請求書Ｓｅｑ
Dim lngBranchNo				'請求書枝番

Dim lngCountCsl				'取得件数
Dim lngCount				'取得件数
Dim Ret						'関数戻り値

'受診情報用変数
Dim vntRsvNo				'予約番号
Dim vntCslDate				'受診日
Dim vntPerId				'個人ＩＤ
Dim vntLastName				'姓
Dim vntFirstName			'名
Dim vntLastKName			'カナ姓
Dim vntFirstKName			'カナ名
Dim vntCsCd					'コースコード
Dim vntCsName				'コース名

'個人請求明細情報の取得
'Dim vntBillLineNo			'請求明細行No
Dim vntPrice				'金額
Dim vntEditPrice			'調整金額
Dim vntTaxPrice				'税額
Dim vntEditTax				'調整税額
'Dim vntCtrPtCd				'契約パターンコード
'Dim vntOptCd				'オプションコード
'Dim vntOptBranchNo			'オプション枝番
'Dim vntRsvNo				'予約番号
'Dim vntPriceSeq			'受信金額ＳＥＱ
Dim vntLineName				'明細名称
Dim vntOtherLineDivCd		'セット外明細コード
Dim vntOtherLineName		'セット外明細名
Dim vntLastName_c			'受診者名　姓
Dim vntFirstName_c			'受診者名　名

'個人請求管理情報(BillNo)
Dim vntDelFlg				'取消し伝票フラグ
'Dim vntIcomeDate			'更新日時
'Dim vntUserId				'ユーザＩＤ
'Dim vntUserName				'ユーザ漢字氏名
Dim vntBillcoment			'請求書コメント
Dim vntPaymentDate			'入金日
Dim vntPaymentSeq			'入金Ｓｅｑ
Dim vntPriceTotal			'金額（請求書合計）
Dim vntEditPriceTotal		'調整金額（請求書合計）
Dim vntTaxPriceTotal		'税額（請求書合計）
Dim vntEditTaxTotal			'調整税額（請求書合計）
Dim vntTotal				'小計（請求書合計）
Dim vntTaxTotal				'税合計（請求書合計）
Dim vntPrintDate			'領収書印刷日
''' 2003.12.19 add start
Dim vntBillName				'請求宛先
Dim vntKeishou				'敬称
Dim strDspBillName			'表示用編集宛名
''' 2003.12.19 add end

'入金情報
'Dim vntPaymentDate			'入金日
'Dim vntPaymentSeq			'入金Ｓｅｑ
Dim vntPriceTotal_Pay		'請求金額合計
Dim vntCredit				'現金預かり金
Dim vntHappy_ticket			'ハッピー買物券
Dim vntCard					'カード
Dim vntCardKind				'カード種別
Dim vntCardNAME				'カード名称
Dim vntCreditslipno			'伝票Ｎｏ
Dim vntJdebit				'Ｊデビット
Dim vntBankCode				'金融機関コード
Dim vntBankName				'金融機関名
Dim vntCheque				'小切手
Dim vntRegisterno			'レジ番号
Dim vntIcomedate			'更新日付
Dim vntUserId				'ユーザＩＤ
Dim vntUserName				'ユーザ漢字氏名
' ## 2003.12.25 add 
Dim vntTransfer				'振込み


Dim lngLineTotal			'小計
Dim lngPaymentFlg			'入金済フラグ（入金済:"1"、未収:"0"）


Dim strMode					'処理モード
Dim lngRsvNo				'予約番号
Dim lngSubCount				'取得件数
Dim lngPerBillCount			'取得件数

Dim strActMode				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス

Dim strLastName
Dim strFirstName
Dim vntSubTotal

Dim strHTML

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得

strDmdDate     = Request("dmddate")
lngBillSeq     = Request("billseq")
lngBranchNo    = Request("branchno")
lngRsvNo       = Request("rsvno")

strActMode   = Request("act")

'パラメタのデフォルト値設定
'lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

Do

	'保存ボタン押下時
	If strActMode = "delete" Then
'KMT
'Err.Raise 1000, , "（lngRsvNo= " & lngRsvNo & " )  "
'Exit Do

		'請求書の取り消し
		Ret = objPerbill.DeletePerBill(strDmdDate, _
										lngBillSeq, _
										lngBranchNo, _
										Session("USERID"))

		'保存に失敗した場合
		If Ret <> True Then
			srtMessage = "請求書の取消しに失敗しました"
'			Err.Raise 1000, , "の取消しに失敗しました。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
		Else

			Response.Redirect "perPaymentInfo.asp?rsvno="&lngRsvNo
'			Response.end

		End If
	End If


	'請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
	lngCountCsl = objPerbill.SelectPerBill_csl(strDmdDate, _
										lngBillSeq, _
										lngBranchNo, _
										vntRsvNo, _
										vntCslDate, _
										vntPerId, _
										vntLastName, _
										vntFirstName, _
										vntLastKName, _
										vntFirstKName, _
										vntCsCd, _
										vntCsName )
	'受診情報が存在しない場合
	If lngCountCsl < 1 Then
'		Err.Raise 1000, , "受診情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If


	'個人請求明細情報の取得
	lngCount = objPerbill.SelectPerBill_c(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											, _
											vntPrice, _
											vntEditPrice, _
											vntTaxPrice, _
											vntEditTax, _
											, , , , , _
											vntLineName, _
											vntOtherLineDivCd, _
											vntOtherLineName, _
											vntLastName_c, _
											vntFirstName_c )

	'個人請求明細情報が存在しない場合
	If lngCount < 1 Then
		Err.Raise 1000, , "個人請求明細情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If


	'個人請求管理情報の取得
	''' 宛先、敬称を追加 2003.12.19
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntDelFlg, _
											, , , _
											vntBillComent, _
											vntPaymentDate, _
											vntPaymentSeq, _
                                            vntPriceTotal, _
											vntEditPriceTotal, _
											vntTaxPriceTotal, _
											vntEditTaxTotal, _
											vntTotal, _
											vntTaxTotal, _
											vntPrintDate, _
											vntBillName, _
											vntKeishou )
	'受診情報が存在しない場合
	If Ret <> True Then
		Err.Raise 1000, , "個人請求管理情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	'入金済フラグ初期化
	lngPaymentFlg = 0

	'入金情報あり？
	If IsNull(vntPaymentDate) = False Then
'KMT	If vntPaymentDate <> "" Then
		'入金済セット
		lngPaymentFlg = 1

		'入金情報の取得
		'### 振込み(TRANSFER)を追加 2003.12.25
		Ret = objPerbill.SelectPerPayment(vntPaymentDate, _
											vntPaymentSeq, _
											vntPriceTotal_Pay, _
											vntCredit, _
											vntHappy_ticket, _
											vntCard, _
											vntCardKind, _
											vntCardNAME, _
											vntCreditslipno, _
											vntJdebit, _
											vntBankCode, _
											vntBankName, _
											vntCheque, _
											vntRegisterno, _
											vntIcomedate, _
											vntUserId, _
											vntUserName, _
											vntTransfer )
		'受診情報が存在しない場合
		If Ret <> True Then
			Err.Raise 1000, , "入金情報が取得できません。（入金No　= " & vntPaymentDate(i) & vntPaymentSeq(i) &" )"
		End If
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
<TITLE>請求書情報</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winComment;			// コメント入力ウィンドウハンドル
var winMerge;			// 請求書統合ウィンドウハンドル
var winPrint;			// 印刷ウィンドウハンドル
var winIncome;			// 入金情報ウィンドウハンドル

function showCommentWindow() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillComment.asp'
	url = url + '?dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winComment.focus();
		winComment.location.replace(url);
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winComment = window.open( url, '', 'width=550,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winComment = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}
}

//請求書統合ウィンドウ表示
function showMergeWindow() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winMerge != null ) {
		if ( !winMerge.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/mergePerBill1.asp';
	url = url + '?dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winMerge.focus();
		winMerge.location.replace(url);
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winMerge = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winMerge = window.open( url, '', 'width=750,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}
}

//印刷情報ウィンドウ表示
function PrintWindow() {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//	var objForm = document.entryForm;	// 自画面のフォームエレメント
//
//	var url;			// URL文字列
//	var opened = false;	// 画面がすでに開かれているか
//
//	// すでにガイドが開かれているかチェック
//	if ( winPrint != null ) {
//		if ( !winPrint.closed ) {
//			opened = true;
//		}
//	}
//
//	url = '/WebHains/contents/perbill/prtPerBill.asp';
//	url = url + '?rsvno=' + '<%= lngRsvNo %>';
//	url = url + '&dmddate=' + '<%= strDmdDate %>';
//	url = url + '&billseq=' + <%= lngBillSeq %>;
//	url = url + '&branchno=' + <%= lngBranchNo %>;
//
//	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
//	if ( opened ) {
//		winPrint.focus();
//		winPrint.location.replace(url);
//	} else {
//		winPrint = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
//	}
/// 領収書印刷ウインドウを表示する 2003.12.25 start
//	var url = '/webHains/contents/report_form/rd_18_prtBill.asp';
//	url = url + '?p_Uid='      + '<%= Session("USERID") %>';
//	url = url + '&p_ScslDate=' + '<%= strDmdDate %>';
//	url = url + '&p_BilSeq='   + '<%= lngBillSeq %>';
//	url = url + '&p_BilBan='   + '<%= lngBranchNo %>';
//	url = url + '&p_Option='   + '0';
//	open( url );
	var url = '/webHains/contents/perbill/prtPerBill.asp';
	url = url + '?reqdmddate=' + '<%= strDmdDate %>';
	url = url + '&reqbillseq='   + '<%= lngBillSeq %>';
	url = url + '&reqbranchno='   + '<%= lngBranchNo %>';
	url = url + '&prtKbn='   + '0';
	open( url );
/// 領収書印刷ウインドウを表示する 2003.12.25 end
// ## 2003.12.20 Mod End

}

//入金情報ウィンドウ表示
function IncomeWindow() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var varBranchNo;

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			opened = true;
		}
	}

	varBranchNo = <%= lngBranchNo %>;
	// 取消伝票なら返金ウインドウ
	if ( varBranchNo == 1 ) {
		url = '/WebHains/contents/perbill/perHenkin.asp';
	} else {
		url = '/WebHains/contents/perbill/perBillIncome.asp';
	}
	url = url + '?rsvno=' + '<%= lngRsvNo %>';
	url = url + '&dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winIncome.focus();
		winIncome.location.replace(url);
	} else {
		winIncome = window.open( url, '', 'width=600,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// 削除処理
function deleteData() {

	if ( !confirm( 'この請求書を削除します。よろしいですか？' ) ) {
		return;
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}
function windowClose() {

	// 入金情報ウインドウを閉じる
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;

	// 印刷ウインドウを閉じる
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			winPrint.close();
		}
	}

	winPrint = null;

	// 請求書統合ウインドウを閉じる
	if ( winMerge != null ) {
		if ( !winMerge.closed ) {
			winMerge.close();
		}
	}

	winMerge = null;

	// コメント入力ウインドウを閉じる
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			winComment.close();
		}
	}

	winComment = null;

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="act" VALUE="select">
	<INPUT TYPE="hidden" NAME="startPos">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE=<%= lngRsvNo %>>
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求書情報</B></TD>
		</TR>
	</TABLE>
<%
'メッセージの編集
	If strMessage <> "" Then
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
	End If

%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP height="15">請求発生日</TD>
			<TD height="15">：</TD>
			<TD height="15"><%= strDmdDate %></TD>
			<TD height="15"></TD>
		</TR>
		<TR>
			<TD NOWRAP height="15">請求書No</TD>
			<TD height="15">：</TD>
			<TD height="15">
				<%= objCommon.FormatString(strDmdDate, "yyyymmdd") %><%= objCommon.FormatString(lngBillSeq, "00000") %><%= lngBranchNo %></TD>
			<TD height="15"></TD>
		</TR>
		<TR>
			<TD NOWRAP height="15">請求金額</TD>
			<TD NOWRAP height="15">：</TD>
			<TD NOWRAP height="15"><B><%= FormatCurrency(vntTotal) %></B>　（内　消費税<%= FormatCurrency(vntTaxTotal) %>）</TD>
<!--
			<TD NOWRAP rowspan="2"><a href="prtPerBill.asp?dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>" target="_blank"><IMG SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="この請求書を印刷します" BORDER="0"></A></TD>
-->
		</TR>
		<TR>
			<TD NOWRAP >請求書コメント</TD>
			<TD >：</TD>
			<TD >
			<TABLE  border="0" cellspacing="1" cellpadding="0">
				<TR>
					<TD><A HREF="JavaScript:showCommentWindow();"><IMG SRC="../../images/question.gif" ALT="請求書コメント入力" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD width= "357"><%= vntBillComent %></TD>
				</TR>
			</TABLE>
			</TD>
<!--- 宛名を追加したのでボタンの位置をずらした（1行下げた） 2003.12.19 -->
			<TD NOWRAP rowspan="2"><A HREF="JavaScript:history.back();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A></TD>
            
            <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
			    <TD NOWRAP rowspan="2"><A HREF="JavaScript:PrintWindow()"><IMG SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="この請求書を印刷します" BORDER="0"></A></TD>
            <% End If %>

		</TR>
<!-- 宛名追加　2003.12.19 start -->
		<TR>
<%
			'請求宛先指定あり？
			If vntBillName <> "" Then
				strDspBillName = vntBillName
			Else
				strDspBillName = vntLastName(0) & " " & vntFirstName(0)
			End If

			'敬称指定あり？
			If vntKeishou <> "" Then
				strDspBillName = strDspBillName & " " & vntKeishou
			Else
				strDspBillName = strDspBillName & " 様"
			End If
%>
			<TD NOWRAP >宛名</TD>
			<TD >：</TD>
			<TD ><%= strDspBillName %></TD>
		</TR>
<!-- 宛名追加　2003.12.19 end -->
	</TABLE>
	<BR>
	<TABLE WIDTH="157" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
<%
			'領収書印刷済は統合できない
'### 2004/11/05 Updated by Ishihara@FSIT 入金済みの場合に、取消せずに統合させないようにする。
'			If vntPrintDate <> "" Then
			If (vntPrintDate <> "") Or (Trim(vntPaymentDate) <> "")  Then
'### 2004/11/05 Updated End
%>
				<TD NOWRAP><FONT COLOR="RED">※領収書印刷済もしくは入金済みの場合、請求書の統合はできません。</FONT></TD>
<%
			Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
				    <TD NOWRAP><A HREF="JavaScript:showMergeWindow();"><IMG SRC="/webHains/images/b_MergePerBill.gif" WIDTH="110" HEIGHT="24" ALT="この請求書を他の請求書と統合します"></A></TD>
<%
			    End If
            End If
%>
<!-- KMT
			<TD NOWRAP><A HREF="/webHains/contents/perbill/mergePerBill1.asp?dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>">この請求書を他の請求書と統合</A></TD>
-->
		</TR>
	</TABLE>
	<BR>
<!-- 受診者情報編集 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
		<TR BGCOLOR="SILVER" height="15">
			<TD NOWRAP height="15">受診日</TD>
			<TD NOWRAP height="15">受診コース</TD>
			<TD NOWRAP height="15">予約番号</TD>
			<TD NOWRAP height="15">個人ＩＤ</TD>
			<TD NOWRAP height="15">受診者名</TD>
		</TR>
<%
		For i = 0 To lngCountCsl - 1
%>
			<TR>
				<TD NOWRAP height="15"><%= vntCslDate(i) %></TD>
				<TD NOWRAP height="15"><%= vntCsName(i) %></TD>
				<TD NOWRAP height="15"><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
				<TD NOWRAP height="15"><%= vntPerId(i) %></TD>
				<TD NOWRAP height="15"><B><%= vntLastName(i) & " " & vntFirstName(i) %></B> (<FONT SIZE="-1"><%= vntLastKname(i) & "　" & vntFirstKName(i) %></FONT>)</TD>
			</TR>
<%
		Next
%>
<!-- 受診情報編集 -->
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
		<TR BGCOLOR="SILVER" height="15">
			<TD nowrap height="15">受診者</TD>
			<TD NOWRAP height="15">請求明細名</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">　金額</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">調整金額</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">　税額</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">調整税額</TD>
			<TD ALIGN="right" NOWRAP WIDTH="69" height="15">合計金額</TD>
		</TR>

<%
		strLastName = ""
		strFirstName = ""
		For i = 0 To lngCount - 1

			lngLineTotal = Clng(vntPrice(i)) +  Clng(vntEditPrice(i)) + Clng(vntTaxPrice(i)) +  Clng(vntEditTax(i))
%>
			<TR height="15">
				<INPUT TYPE="hidden" NAME="billNo" VALUE="315">
				<INPUT TYPE="hidden" NAME="seq" VALUE="">
<%
				'受診者名はインディケイトする。
				If ((strLastName = vntLastName_c(i)) AND (strFirstName = vntFirstName_c(i))) Then
%>
					<TD nowrap height="15"></TD>
<%
				Else
%>
					<TD nowrap height="15"><%= vntLastName_c(i) & " " & vntFirstName_c(i) %></TD>
<%
					'受診者名記憶
					strLastName = vntLastName_c(i)
					strFirstName = vntFirstName_c(i)
				End If

'### 2004/3/6 Added by Ishihara@FSIT 明細名の出し方が根本的におかしいので修正（明細名が優先）
%>
				<TD NOWRAP height="15"><%= IIf( vntLineName(i) <> "", vntLineName(i),  vntOtherLineName(i) ) %><FONT COLOR="#666666"></FONT></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntEditTax(i)) %></TD>
				<TD WIDTH="69" NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngLineTotal) %></TD>
			</TR>
<%
		Next
%>
		<TR height="1">
			<TD colspan="7" style="border-top: 1px solid #999" height="1"></TD>
		</TR>
		<TR height="15">
			<td 70" nowrap align="right" height="15"></td>
			<TD COLSPAN="1"70" NOWRAP ALIGN="right" height="15">合計</TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntEditPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntTaxPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntEditTaxTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><B><%= FormatCurrency(vntTotal) %></B></TD>
		</TR>
	</TABLE>

<!-- 入金情報編集 --><BR>
	<BR>
	<TABLE WIDTH="541" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
<!-- 新規作成画面に合わせる
			<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">●</FONT>&nbsp;入金情報</TD>
-->
			<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">●</FONT>
<!-- 返金処理のときは返金にする　2004.01.20  start -->
<%
				'取り消し伝票の場合
				If lngBranchNo = 1 Then
%>
					<A HREF="JavaScript:IncomeWindow()">返金情報</A>
<%
				Else
%>
<!-- 返金処理のときは返金にする　2004.01.20  end -->
					<A HREF="JavaScript:IncomeWindow()">入金情報</A>
<!-- 返金処理のときは返金にする　2004.01.20  start -->
<%
				End If
%>
<!-- 返金処理のときは返金にする　2004.01.20  end -->
			</TD>
			<TD NOWRAP WIDTH="100%"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="SILVER">
<!-- 返金処理のときは返金にする　2004.01.20  start -->
<%
			'取り消し伝票の場合
			If lngBranchNo = 1 Then
%>
				<TD ALIGN="left" NOWRAP>返金日</TD>
<%
			Else
%>
<!-- 返金処理のときは返金にする　2004.01.20  end -->
				<TD ALIGN="left" NOWRAP>入金日</TD>
<!-- 返金処理のときは返金にする　2004.01.20  start -->
<%
			End If
%>
<!-- 返金処理のときは返金にする　2004.01.20  end -->
			<TD NOWRAP>現金</TD>
			<TD NOWRAP>クレジット</TD>
			<TD NOWRAP>Jデビッド</TD>
			<TD NOWRAP>ハッピー買物</TD>
			<TD NOWRAP>小切手・フレンズ</TD>
<!-- 振込み追加　2003.12.25 -->
			<TD NOWRAP>振込み</TD>
			<TD NOWRAP>オペレータ</TD>
		</TR>
<%
		If lngPaymentFlg = 0 Then
%>
			<TR>
<%
				'取り消し伝票の場合
				If lngBranchNo = 1 Then
%>
					<TD NOWRAP><B>返金されていません。</B></TD>
<%
				Else
%>
					<TD NOWRAP><B>入金されていません。</B></TD>
<%
				End If
%>
			</TR>
<%
		Else
%>
			<TR>
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:IncomeWindow();"><%= vntPaymentDate %></A></TD>
<!-- KMT
				<TD NOWRAP ALIGN="left"><A HREF="perBillIncome.asp?rsvno=<%= lngRsvNo %>&dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>" TARGET="_blank"><%= vntPaymentDate %></A></TD>
-->
<!--
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCredit <> "", FormatCurrency(vntPriceTotal_Pay), "") %></B></TD>
-->
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCredit <> "", FormatCurrency(vntCredit), "") %></B></FONT></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCard <> "", FormatCurrency(vntCard), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntJdebit <> "", FormatCurrency(vntJdebit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntHappy_ticket <> "", FormatCurrency(vntHappy_ticket), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCheque <> "", FormatCurrency(vntCheque), "") %></B></TD>
<!-- 振込み　追加 2003.12.25 -->
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntTransfer <> "", FormatCurrency(vntTransfer), "") %></B></TD>
				<TD NOWRAP ALIGN="left"><%= vntUserName %></TD>
			</TR>
<%
		End If
%>
	</TABLE>
	<BR>
	<TABLE WIDTH="109" BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
		'取消し伝票は取消しボタン非表示
 		If vntDelFlg <> 1 Then
%>
			<TR>
				<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                    <TD NOWRAP>
					<A HREF="JavaScript:deleteData()"><IMG SRC="/webHains/images/b_delPerBill.gif" WIDTH="110" HEIGHT="24" ALT="この請求書を取り消す"></A>
				    </TD>
                <% End If %>
			</TR>
<%
		End If
%>
	</TABLE>
	<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->

</BODY>
</HTML>
