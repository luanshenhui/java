<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       入金処理 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>

<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPaymentDivList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>入金処理</TITLE>

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数値
Dim strAction				'処理状態(確定ボタン押下時:"save")
Dim strMode					'処理モード(削除時:"delete")
Dim strBillNo				'請求書番号
Dim strSeq					'入金SEQ(空白の場合新規)

'請求情報
Dim lngCloseYear			'締め日(年)
Dim lngCloseMonth			'締め日(月)
Dim lngCloseDay				'締め日(日)
Dim strCloseDate			'締め日
Dim lngBillSeq				'請求書Seq
Dim lngBranchNo				'請求書枝番
Dim lngDelFlg				'削除フラグ

Dim strOrgName				'負担元団体名
Dim lngTotal				'請求金額
Dim lngNotPayment			'未収金額
Dim strDispTotal			'表示用請求金額
Dim strDispNotPayment		'表示用未収金額
Dim strDispPayment			'表示用入金額

'入金情報
Dim lngSeq					'入金SEQ
Dim strPaymentDate			'入金日
Dim lngPaymentYear			'入金日（年）
Dim lngPaymentMonth			'入金日（月）
Dim lngPaymentDay			'入金日（日）
Dim strPaymentPrice			'入金額
Dim strPaymentDiv			'入金種別
Dim strUpdUser				'更新者
Dim strUserName				'更新者名
Dim strPayNote				'コメント
Dim strDuePrice				'入金予定額

'### 2004.02.18 Add by H.Ishihara レジ番号追加
Dim strRegisterNo			'レジ番号
Dim strCash					'現金

Dim strArrRegisterno()		'レジ番号（コンボ用）
Dim strArrRegisternoName()	'レジ番号名称（コンボ用）

Dim strDispCharge			'おつり（画面表示用）
'### 2004.02.18 Add End

Dim objDemand				'請求情報アクセス用COMオブジェクト

'## 2004.06.01 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
Dim strSumPrice			'金額合計
Dim strSumEditPrice		'調整金額合計
Dim strSumTaxPrice		'税額合計
Dim strSumEditTax		'調整税額合計
Dim strSumPriceTotal		'総合計
Dim lngSumRecord		'レコード数
Dim strSumPrice2		'金額合計
Dim strSumEditPrice2		'調整金額合計
Dim strSumTaxPrice2		'税額合計
Dim strSumEditTax2		'調整税額合計
Dim strSumPriceTotal2		'総合計
Dim lngSumRecord2		'レコード数
'## 2004.06.01 ADD END

Dim strArrMessage			'エラーメッセージ
Dim strRet					'関数戻り値
Dim i						'インデックス
Dim flgNoInput				

'2004.01.28 追加
Dim objFree				'汎用情報アクセス用
Dim strCardKind     	'カード種別
Dim strCardName     	'カード名
Dim strCreditslipno 	'伝票No
'Dim lngCreditslipno 	'伝票No
Dim strBankCode     	'金融機関コード
Dim strBankName     	'金融機関名称
Dim strArrCardKind		'カード種別
Dim strArrCardName		'カード名称
Dim strArrBankCode		'銀行コード
Dim strArrBankName		'銀行名称
Dim objCommon

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAction = Request("act") & ""
strMode   = Request("mode") & ""
strBillNo = Request("billNo") & ""
strSeq    = Request("seq") & ""
lngPaymentYear  = CLng("0" & Request("paymentYear"))	'入金日（年）
lngPaymentMonth = CLng("0" & Request("paymentMonth"))	'入金日（月）
lngPaymentDay   = CLng("0" & Request("paymentDay"))		'入金日（月）
strPaymentDiv   = Request("paymentDiv")					'入金種別
strPaymentPrice = Request("paymentPrice")
strPayNote      = Request("payNote")					'コメント
strUpdUser      = Session("userid")
strUserName     = Session("username")

'2004.01.28 追加
strCardKind     = Request("cardKind") & ""
strCreditslipno = Request("creditslipno") & ""
strBankCode     = Request("bankCode") & ""
strCardName = ""
strBankName = ""

'### 2004.02.18 Add by H.Ishihara レジ番号、現金追加
strRegisterNo   = Request("registerNo")
strCash         = Request("paymentPrice")
'### 2004.02.18 Add End

'初期化
strCloseDate  = empty
strOrgName    = empty
strArrMessage = empty
lngDelFlg = CLng("0")
flgNoInput = 0

'### 2004.02.18 Add by H.Ishihara レジ番号追加
'レジ番号・名称の配列作成
Call CreateRegisternoInfo()
'### 2004.02.18 Add End

'オブジェクトのインスタンス作成
Set objDemand = Server.CreateObject("HainsDemand.Demand")
Set objFree   = Server.CreateObject("HainsFree.Free")
Set objCommon = Server.CreateObject("HainsCommon.Common")

Do

	' Request から請求書キー
	If Len(strBillNo) <> 14 Then
		strArrMessage = Array("請求書番号が不正です")
		Exit Do
	Else 
		If Not IsNumeric(strBillNo) Then
			strArrMessage = Array("請求書番号が不正です")
			Exit Do
		End If	
	End If

	lngCloseYear  = CLng("0" & Mid(strBillNo, 1, 4))
	lngCloseMonth = CLng("0" & Mid(strBillNo, 5, 2))
	lngCloseDay   = CLng("0" & Mid(strBillNo, 7, 2))
	lngBillSeq    = CLng("0" & Mid(strBillNo, 9, 5))
	lngBranchNo   = CLng("0" & Mid(strBillNo, 14, 1))

	'請求情報取得(外部結合で取得している)
	If Not objDemand.SelectDmdPaymentBillSum(lngCloseYear, _
											lngCloseMonth, _
											lngCloseDay, _
											strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngDelFlg, _
											strOrgName, _
											lngTotal, _
											lngNotPayment ) Then
		strArrMessage = Array("請求書情報の取得に失敗しました。")
		Exit Do
	End If

'## 2004.06.01 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
	lngSumRecord = objDemand.SelectSumDetailItems(Mid(strBillNo, 1, 13) & "0",, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	lngSumRecord2 = objDemand.SelectSumDetailItems(Mid(strBillNo, 1, 13) & "1",, _
							strSumPrice2, _
							strSumEditPrice2, _
							strSumTaxPrice2, _
							strSumEditTax2, _
							strSumPriceTotal2)
'	If lngSumRecord > 0 Then
'		lngTotal = lngTotal + strSumPriceTotal(0)
'	End If
'## 2004.06.01 ADD END

	'請求金額を画面用に整形
	strDispTotal = FormatCurrency(lngTotal)
	'未収金額（請求金額 － 入金額）を画面用に整形
	strDispNotPayment = FormatCurrency(lngNotPayment)

	'入金Seq（新規の場合は0）
	lngSeq = CLng("0" & strSeq)

	'入金額は入力できないのでこちらで与える
	'すでに入金レコードがある場合はそのレコードの値、
	'そうでない場合は、未収額合計を設定
	If Not objDemand.GetDmdPaymentPrice(strCloseDate, _
										  lngBillSeq, _
										  lngBranchNo, _
										  lngSeq, _
										  strPaymentPrice, _
										  strDuePrice) Then
		strArrMessage = Array("請求書情報の取得に失敗しました。")
		Exit Do
	End If

	If lngSeq = 0 Then
'## 2004.06.01 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
		If lngSumRecord > 0 Then
			strDuePrice = strDuePrice + strSumPriceTotal(0)
		End if
		If lngSumRecord2 > 0 Then
			strDuePrice = strDuePrice + strSumPriceTotal2(0)
		End if
'## 2004.06.01 ADD END
		strPaymentPrice = strDuePrice
	End If

	' 確定押下
	If strAction = "save" Then

		'取消伝票は参照のみでデータ修正できません
		If lngBranchNo = 0 And lngDelFlg = 1 Then
			strArrMessage = Array("取消伝票の入金追加・変更・削除はできません。")
			Exit Do
		End If

		'mode未確定は無視
		If strMode = "" Then Exit Do

		'削除処理
		If strMode = "delete" Then

			If Not objDemand.DeletePayment(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngSeq) Then
				strArrMessage = Array("入金情報は削除できませんでした")
				Exit Do
			End If

		Else
			'入力チェック
			strArrMessage = CheckPaymentDivValue()
			If IsEmpty(strArrMessage) Then
				strArrMessage = objDemand.CheckValuePayment(strCloseDate, _
															lngBillSeq, _
															lngBranchNo, _
															strSeq, _
															lngPaymentYear, _
															lngPaymentMonth, _
															lngPaymentDay, _
															strPaymentDate, _
															strPaymentPrice, _
															strPaymentDiv, _
															strPayNote)
			End If
			If Not IsEmpty(strArrMessage) Then Exit Do

			'入力チェック成功
			'入金情報更新
			If strSeq <> "" Then
'### 2004.02.18 Mod by H.Ishihara レジ番号、現金追加
'				strRet = objDemand.UpdatePayment(strCloseDate, _
'													lngBillSeq, _
'													lngBranchNo, _
'													lngSeq, _
'													strPaymentDate, _
'													strPaymentPrice, _
'													strPaymentDiv, _
'													strUpdUser, _
'													strPayNote, _
'													strCardKind, _
'													strCreditslipno, _
'													strBankCode)
				strRet = objDemand.UpdatePayment(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq, _
													strPaymentDate, _
													strPaymentPrice, _
													strPaymentDiv, _
													strUpdUser, _
													strPayNote, _
													strCardKind, _
													strCreditslipno, _
													strBankCode, _
													strRegisterNo, _
													strCash)
'### 2004.02.18 Mod End
				If Not strRet Then
					strArrMessage = Array("入金情報は更新できませんでした")
					Exit Do
				End If
			Else
				'分割入金がないためseqは常に１となるようdllを修正した
'### 2004.02.18 Mod by H.Ishihara レジ番号、現金追加
'				strRet = objDemand.InsertPayment(strCloseDate, _
'													lngBillSeq, _
'													lngBranchNo, _
'													strPaymentDate, _
'													strPaymentPrice, _
'													strPaymentDiv, _
'													strUpdUser, _
'													strPayNote, _
'													strCardKind, _
'													strCreditslipno, _
'													strBankCode)
				strRet = objDemand.InsertPayment(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													strPaymentDate, _
													strPaymentPrice, _
													strPaymentDiv, _
													strUpdUser, _
													strPayNote, _
													strCardKind, _
													strCreditslipno, _
													strBankCode, _
													strRegisterNo, _
													strCash)
'### 2004.02.18 Mod End

				'キー重複時はエラーメッセージを編集する
				If strRet = INSERT_DUPLICATE Then
					strArrMessage = Array("入金情報がすでに存在します。")
					Exit Do
				End If
			End If
		End If
	
		'DB更新成功の場合は前画面に戻る
		If IsEmpty(strArrMessage) Then
			strAction = "saveend"
			Response.Write "<BODY ONLOAD=""goBackPage()"">"
			Exit Do
		End If

	End If

	'修正時は入金情報取得
	If strSeq <> "" Then

'### 2004.02.18 Mod by H.Ishihara レジ番号、現金追加
'		Call objDemand.SelectPayment(strCloseDate, _
'										lngBillSeq, _
'										lngBranchNo, _
'										lngSeq, _
'										strPaymentDate, _
'										strPaymentPrice, _
'										strPaymentDiv, _
'										strUpdUser, _
'										strUserName, _
'										strPayNote, _
'										strCardKind, _
'										strCreditslipno, _
'										strBankCode, _
'										strCardName, _
'										strBankName)
		Call objDemand.SelectPayment(strCloseDate, _
										lngBillSeq, _
										lngBranchNo, _
										lngSeq, _
										strPaymentDate, _
										strPaymentPrice, _
										strPaymentDiv, _
										strUpdUser, _
										strUserName, _
										strPayNote, _
										strCardKind, _
										strCreditslipno, _
										strBankCode, _
										strCardName, _
										strBankName, _
										strRegisterNo, _
										strCash)

		If Trim(strCash) = "" Then strCash = 0
'### 2004.02.18 Mod End

		lngPaymentYear = Year(strPaymentDate)
		lngPaymentMonth = Month(strPaymentDate)
		lngPaymentDay = Day(strPaymentDate)
		strDispPayment = FormatCurrency(strPaymentPrice)

	' 登録時
	Else
		If strDuePrice = 0 Then
			'入金の必要がない場合は、表示しない
			strPaymentPrice = 0
			strDispPayment = ""
			flgNoInput = 1
		Else 
			strDispPayment = FormatCurrency(strPaymentPrice)

			'2004.01.28 追加
			strPaymentDiv = "3"
		End If
	End If

	Exit Do
Loop

strDispCharge = ""
If strPaymentDiv = "1" Then
	If IsNumeric(strCash) Then
	strDispCharge = "おつりは" & FormatCurrency(strCash - strPaymentPrice) & "です。"
	End If
End If

'日付は本日にしておきたいから
lngPaymentYear = IIf(lngPaymentYear = 0, Year(Now()), lngPaymentYear)
lngPaymentMonth = IIf(lngPaymentMonth = 0, Month(Now()), lngPaymentMonth)
lngPaymentDay = IIf(lngPaymentDay = 0, Day(Now()), lngPaymentDay)

'オブジェクトのインスタンス削除
Set objDemand = Nothing
'Set objCommon = Nothing

'-------------------------------------------------------------------------------
'
' 機能　　 : 種別毎の選択状況チェック
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckPaymentDivValue()

	Dim vntArrMessage

	With objCommon

'### 2004.02.18 Add by H.Ishihara レジ番号、現金追加

		'入金種別が振込みでもその他でもない場合は、レジ番号必須
		If (strPaymentDiv <> "3") And (strPaymentDiv <> "7") And (Trim(strRegisterNo) = "") Then
			.AppendArray vntArrMessage, "「振込み」、「その他」以外の入金種別が選択された場合、レジ番号は必須です。"
		End If

		'入金種別が現金の場合
		If strPaymentDiv = "1" Then

			Do

				'金額がセットされていないなら、0セット
				If Trim(strCash) = "" Then strCash = 0

				'金額の値チェック
				.AppendArray vntArrMessage, .CheckNumericWithSign("入金額", _
														 strCash, _
														 8, _
														 CHECK_NECESSARY)

				If IsArray(vntArrMessage) Then Exit Do

				'入金額に達していないなら、エラー
				If cDbl(strCash) < cDbl(strPaymentPrice) Then
					.AppendArray vntArrMessage, "入金額が請求額に達していません。"
				End If

				Exit Do
			Loop

		Else
			'入金種別が現金でないなら、現金フィールドはクリア
			strCash = ""
		End If

		'振込みなら、レジ番号をクリア
		If strPaymentDiv = "3" Then
			strRegisterNo = ""
		End IF
'### 2004.02.18 Add End
		
		If strPaymentDiv = "5" Then
			If strCardKind = "" Then
				.AppendArray vntArrMessage, "カード種別を選択して下さい。"
			End If
			.AppendArray vntArrMessage, .CheckNumeric("伝票No.", _
													 strCreditslipno, _
													 5, _
													 CHECK_NECESSARY)
		End If

		If strPaymentDiv = "6" Then
			If strBankCode = "" Then
				.AppendArray vntArrMessage, "金融機関を選択して下さい。"
			End If
		End If

	End With

	If IsArray(vntArrMessage) Then
		CheckPaymentDivValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 入金種別の読み込み
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function getPaymentDivName()

'	Dim objCommon				'入金種別情報アクセス用COMオブジェクト
	Dim vntPaymentDiv			'入金種別
	Dim vntPaymentDivName		'入金種別名称
	Dim i

	getPaymentDivName = ""

	'入金種別情報の読み込み
	If objCommon.SelectPaymentDivList(vntPaymentDiv, vntPaymentDivName) > 0 Then
		If Not IsEmpty(vntPaymentDiv) Then
			For i = 0 to UBound(vntPaymentDiv)
				If CStr(vntPaymentDiv(i)) = CStr(strPaymentDiv) Then 
					getPaymentDivName = vntPaymentDivName(i)
					Exit For
				End If
			Next
		End If
	End If
	
	Set objCommon = Nothing

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : レジ番号・名称の配列作成
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateRegisternoInfo()

	Redim Preserve strArrRegisterno(3)
	Redim Preserve strArrRegisternoName(3)

	strArrRegisterno(0) = "":strArrRegisternoName(0) = ""
	strArrRegisterno(1) = "1":strArrRegisternoName(1) = "1"
	strArrRegisterno(2) = "2":strArrRegisternoName(2) = "2"
	strArrRegisterno(3) = "3":strArrRegisternoName(3) = "3"

End Sub
%>



<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--

// 削除確認メッセージ
function delConfirm() {

	var ret;		// 戻り値

	ret = self.confirm('指定された入金情報を削除します。よろしいですか。');

	// 削除OK
	if ( ret ) {
		document.dmdPayment.act.value = 'save';
		document.dmdPayment.mode.value = 'delete';
		document.dmdPayment.submit();
	}

	return false;
}

// 次画面処理
function goNextPage() {

	var paymentDate;		// 入金日

	// 入金日入力チェック
	if ( !isDate(document.dmdPayment.paymentYear.value, document.dmdPayment.paymentMonth.value, document.dmdPayment.paymentDay.value) ) {
		self.alert('入金日の形式に誤りがあります。');
		return false;
	}

	// 入金日編集
	paymentDate = formatDate(document.dmdPayment.paymentYear.value, document.dmdPayment.paymentMonth.value, document.dmdPayment.paymentDay.value);

	// 入金日が締め日より前となっていないかチェック
	if ( paymentDate < document.dmdPayment.closeDate.value ) {
		self.alert('入金日は締め日以降の日付を入力してください。');
		return false;
	}

	// 2004.01.28 追加
	if ( document.dmdPayment.paymentDiv.value != '5' ) {
		document.dmdPayment.cardkind.value = '';
		document.dmdPayment.creditslipno.value = '';
	}
	if ( document.dmdPayment.paymentDiv.value != '6' ) {
		document.dmdPayment.bankcode.value = '';
	}

	// 自画面を送信
	document.dmdPayment.act.value = 'save';
<%' 2004/02/02 Shiramizu Modified Start%>
	document.dmdPayment.mode.value = 'update';
<%' 2004/02/02 Shiramizu Modified End%>
	document.dmdPayment.submit();

	return false;
}

// 親ウインドウへ戻る
function goBackPage() {

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.dmdPayment_CalledFunction != null ) {
		opener.dmdPayment_CalledFunction();
	}

	close();

	return false;
}

<%' 2004/02/18 Add Function by Ishihara@FSIT %>
// レジNoが選択されたときの処理
function selectRegiNo( val ) {

	var curDate = new Date();
	var previsit = curDate.toGMTString();

	curDate.setTime( curDate.getTime() + 30*365*24*60*60*1000 ); // 30年後

	var expire = curDate.toGMTString();

	document.cookie = 'billregino=' + val + ';expires=' + expire;

	document.dmdPayment.registernoval.value = val;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()">
<FORM NAME="dmdPayment" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">入金処理</FONT></B></TD>
	</TR>
</TABLE>
<!-- 引数情報 -->
<INPUT TYPE="hidden" NAME="act"    VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="closeDate"  VALUE="<%= strCloseDate %>">
<INPUT TYPE="hidden" NAME="billSeq" VALUE="<%= lngBillSeq %>">
<INPUT TYPE="hidden" NAME="branchNo" VALUE="<%= lngBranchNo %>">
<INPUT TYPE="hidden" NAME="seq"    VALUE="<%= strSeq %>">
<!-- ## 2004.02.18 Del by H.Ishihara 入金額は入力可能とする
<INPUT TYPE="hidden" NAME="paymentPrice" VALUE="<%= strPaymentPrice %>">
-->
<%
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>締め日</TD>
		<TD>：</TD>
		<TD><%= strCloseDate %></TD>
	</TR>
	<TR>
		<TD>請求先</TD>
		<TD>：</TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD>請求金額</TD>
		<TD>：</TD>
		<TD NOWRAP><B><%= strDispTotal %></B></TD>
	</TR>
	<TR>
		<TD>未収金額</TD>
		<TD>：</TD>
<% If lngNotPayment = 0 Then %>
		<TD NOWRAP><B><%= strDispNotPayment %></B></TD>
<% Else %>
		<TD NOWRAP><FONT COLOR="RED"><B><%= strDispNotPayment %></B></FONT></TD>
<% End If %>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">

<!-- 取消伝票はデータ参照のみ -->
<% If (lngBranchNo = 0 and lngDelFlg = 1) Or flgNoInput = 1 Then %>
<INPUT TYPE="hidden" NAME="paymentYear" VALUE="<%= lngPaymentYear %>">
<INPUT TYPE="hidden" NAME="paymentMonth" VALUE="<%= lngPaymentMonth %>">
<INPUT TYPE="hidden" NAME="paymentDay" VALUE="<%= lngPaymentDay %>">
<INPUT TYPE="hidden" NAME="paymentDiv" VALUE="<%= strPaymentDiv %>">
<INPUT TYPE="hidden" NAME="payNote" VALUE="<%= strPayNote %>">
<%' ### 2004/02/18 Add Function by Ishihara@FSIT %>
	<TR>
		<TD>レジ番号</TD>
		<TD>：</TD>
		<TD><%= strRegisterNo %></TD>
	</TR>
<%' ### 2004/02/18 Add End %>
	<TR>
		<TD>入金日</TD>
		<TD>：</TD>
		<TD><%= strPaymentDate %></TD>
	</TR>
	<TR>
		<TD>入金額</TD>
		<TD>：</TD>
<%
'### 2004.02.18 Add by H.Ishihara レジ番号、現金追加
If strPaymentDiv = "1" Then
%>
		<TD NOWRAP><%= FormatCurrency(strCash) %>　<FONT COLOR="#999999"><%= strDispCharge %></FONT></TD>
<%
Else
%>
		<TD NOWRAP><%= strDispPayment %></TD>
<%
End If
%>

	</TR>
	<TR>
		<TD>入金種別</TD>
		<TD>：</TD>
		<TD>
<% If strPaymentDiv = "5" Then %>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<TD><%= getPaymentDivName %></TD>
					<TD>&nbsp;（カード種別：&nbsp;<%= strCardName %></TD>
					<TD>&nbsp;&nbsp;伝票No.：&nbsp;<%= strCreditslipno %>）</TD>
				<tr>
			</table>
<% ElseIf strPaymentDiv = "6" Then %>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<TD><%= getPaymentDivName %></TD>
					<TD>&nbsp;（金融機関：&nbsp;<%= strBankName %>）</TD>
				<tr>
			</table>
<% Else %>
			<%= getPaymentDivName %>
<% End If %>
		</TD>
	</TR>
	<TR>
		<TD VALIGN="top">コメント</TD>
		<TD VALIGN="top">：</TD>
		<TD><%= strPayNote %></TD>
	</TR>

<% Else %>

<%' ### 2004/02/18 Add Function by Ishihara@FSIT %>
	<TR>
		<TD>レジ番号</TD>
		<TD>：</TD>
		<TD>
			<SPAN ID="registerDrop"></SPAN>
			<INPUT TYPE="hidden" NAME="registernoval" VALUE="<%= strRegisterNo %>">
		</TD>
	</TR>
<%' ### 2004/02/18 Add End %>
	<TR>
		<TD>入金日</TD>
		<TD>：</TD>
		<TD>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td><a href="javascript:calGuide_showGuideCalendar('paymentYear', 'paymentMonth', 'paymentDay')"><img src="/webHains/images/question.gif" alt="日付ガイドを表示" height="21" width="21" border="0"></a></td>
					<TD><%= EditNumberList("paymentYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPaymentYear, False) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditNumberList("paymentMonth", 1, 12, lngPaymentMonth, False) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditNumberList("paymentDay", 1, 31, lngPaymentDay, False) %></TD>
					<TD>&nbsp;日</TD>
					<td></td>
				</tr>
			</table>
		</TD>
	</TR>
	<TR>
		<TD>入金額</TD>
		<TD>：</TD>
<%
'### 2004.02.18 Add by H.Ishihara レジ番号、現金追加
If strPaymentDiv = "1" Then
%>
		<TD NOWRAP><INPUT TYPE="TEXT" NAME="paymentPrice" VALUE="<%= strCash %>" SIZE="10" MAXLENGTH="9">　<FONT COLOR="#999999"><%= strDispCharge %></FONT></TD>
<%
Else
%>
		<TD NOWRAP><INPUT TYPE="TEXT" NAME="paymentPrice" VALUE="<%= strPaymentPrice %>" SIZE="10" MAXLENGTH="9"></TD>
<%
End If
%>

	</TR>
	<TR>
		<TD COLSPAN="2"></TD>
		<TD><FONT COLOR="#999999">※入金種別=現金以外の入金額は無視されます。（請求金額とイコールになります）</FONT></TD>
	</TR>
	<TR>
		<TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD VALIGN="top">入金種別</TD>
		<TD VALIGN="top">：</TD>
		<TD >
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
				<TD><%= EditPaymentDivList("paymentDiv", strPaymentDiv) %></TD>
				<TD>&nbsp;カード種別&nbsp;</TD>
<%
				'カード情報の読み込み
				If objFree.SelectFree( 1, "CARD" , strArrCardKind, , , strArrCardName) > 0 Then
%>
				<TD>
				<%= EditDropDownListFromArray("cardkind", strArrCardKind, strArrCardName, strCardKind, NON_SELECTED_ADD) %>
				</TD>
<%
				End If
%>
				<TD>&nbsp;伝票No.&nbsp;</TD>
				<TD><input type="text" name="creditslipno" value="<%= strCreditslipno %>" size="7" maxlength="5" ></TD>
				<tr>
				<tr>
				<TD></TD>
				<TD>&nbsp;金融機関&nbsp;</TD>
<%
				'銀行情報の読み込み
				If objFree.SelectFree( 1, "BANK" , strArrBankCode, , , strArrBankName) > 0 Then
%>
				<TD>
				<%= EditDropDownListFromArray("bankcode", strArrBankCode, strArrBankName, strBankCode, NON_SELECTED_ADD) %>
				</TD>
<%
				End If
%>
				</tr>
			</table>
		</TD>
	</TR>
	<TR>
		<TD VALIGN="top">コメント</TD>
		<TD VALIGN="top">：</TD>
		<TD>
			<TEXTAREA NAME="payNote" SIZE="" ROWS="4" COLS="40"><%= strPayNote %></TEXTAREA>
		</TD>
	</TR>
<% End If %>

	<TR>
		<TD>処理担当者</TD>
		<TD>：</TD>
		<TD><%= strUserName %>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
<!-- 取消伝票は参照のみ -->
<% If lngBranchNo = 1 or lngDelFlg = 0 Then %>

	<!-- 修正時 -->
	<% If strSeq <> "" Then %>
			<TD>
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return delConfirm()">
				<IMG SRC="/webHains/images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この入金情報を削除します"></A>
			</TD>
			<TD WIDTH="190"></TD>
	<% Else %>
			<TD WIDTH="264"></TD>
	<% End If %>

		<TD WIDTH="5"></TD>
		<TD>
		<% '2005.08.22 権限管理 Add by 李　--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()">
			<IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で確定"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 権限管理 Add by 李　--- END %>
		</TD>

<% Else %>
		<TD WIDTH="264"></TD>

<% End If %>

		<TD WIDTH="5"></TD>
		<TD>
			<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		</TD>
	</TR>
</TABLE>
</FORM>
<% Set objCommon = Nothing %>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
<!-- 取消伝票はデータ参照のみ -->
<% If (lngBranchNo = 0 and lngDelFlg = 1) Or flgNoInput = 1 Then %>
<% Else %>
<SCRIPT TYPE="text/javascript">
<!--
	var i;

	// cookie値の取得
	var searchStr = 'billregino=';
	var strCookie = document.cookie;

	if ( strCookie.length > 0 ){

		var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
		var regino = strCookie.substring(startPos, startPos + 1);

		if (regino != '' ){
			document.dmdPayment.registernoval.value = regino;
			var html = '';
			html = html + '<TD>';
    		html = html + '<SELECT NAME="registerno" ONCHANGE="javascript:selectRegiNo( document.dmdPayment.registerno.value )">';

<%
	    	'配列添字数分のリストを追加
			If Not IsEmpty(strArrRegisterno) Then
				For i = 0 To UBound(strArrRegisterno)
%>
					html = html + '<OPTION VALUE="<%= strArrRegisterno(i) %>"'

<%
					If strSeq <> "" Then
%>
					if ( '<%= strArrRegisterno(i) %>' == '<%= strRegisterNo %>' ){
						html = html + '  SELECTED';
					}
<%
					Else
%>
					if ( '<%= strArrRegisterno(i) %>' == regino ){
						html = html + '  SELECTED';
					}
<%
					End If
%>
					html = html + '> <%= strArrRegisternoName(i) %>';
<%
				Next
			End If
%>

  			html = html + '</SELECT>';
			html = html + '</TD>';
			document.getElementById('registerDrop').innerHTML = html;
		}
	}
//-->
</SCRIPT>
<% End If %>
</BODY>
</HTML>
