<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		個人請求書新規作成 (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'
'		新規作成は mode=insertで要求、請求書があるときはmode=updateと請求書No
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
Dim objPerbill				'個人情報アクセス用

Dim strAction				'動作モード(保存:"save"、保存完了:"saved"、再表示："dsp")
Dim strMode					'処理モード(新規："insert"、更新："update")
Dim strArrMessage			'エラーメッセージ
Dim i						'インデックス
Dim Ret						'関数戻り値

Dim strDmdDate				'請求日
Dim lngBillSeq				'請求書Ｓｅｑ
Dim lngBranchNo				'請求書枝番

Dim strReqDate				'請求日（新規または変更後）

Dim strYear					'請求発生日(年)
Dim strMonth				'請求発生日(月)
Dim strDay					'請求発生日(日)

Dim lngPerCount				'受診者数（表示用）
Dim lngBillCount			'請求書数（表示用）

Dim strArrName				'受診者名
Dim strArrKName				'受診者名（カナ）

'個人請求書管理個人情報(Person)
Dim lngPerRet				'復帰値（受診者数）
Dim vntPerId				'個人ＩＤ
Dim vntLastName				'姓
Dim vntFirstName			'名
Dim vntLastKName			'カナ姓
Dim vntFirstKName			'カナ名

'個人請求明細情報の取得(perBill_c)
Dim lngBillRet				'復帰値（請求書数）
Dim lngBillLineNo			'請求書明細行No
Dim vntPrice				'金額
Dim vntEditPrice			'調整金額
Dim vntTaxPrice				'税額
Dim vntEditTax				'調整税額
Dim vntLineName				'明細名称
Dim vntOtherLineDivCd		'セット外明細コード
Dim vntOtherLineName		'セット外明細名

'個人請求管理情報(BillNo)
Dim vntDelFlg				'取消し伝票フラグ
Dim strBillComment			'請求書コメント
Dim strPaymentDate			'入金日
Dim lngPaymentSeq			'入金Ｓｅｑ
Dim vntLineTotal			'小計

'入金情報
Dim lngPriceTotal_Pay		'請求金額合計
Dim lngCredit				'現金預かり金
Dim lngHappy_ticket			'ハッピー買物券
Dim lngCard					'カード
Dim strCardKind				'カード種別
Dim strCardNAME				'カード名称
Dim lngCreditslipno			'伝票Ｎｏ
Dim lngJdebit				'Ｊデビット
Dim strBankCode				'金融機関コード
Dim strBankName				'金融機関名
Dim lngCheque				'小切手
Dim lngRegisterno			'レジ番号
Dim strIcomedate			'更新日付
Dim strUserId				'ユーザＩＤ
Dim strUserName				'ユーザ漢字氏名

Dim lngPaymentFlg			'入金済フラグ（入金済:"1"、未収:"0"）
Dim lngPriceTotal			'金額合計
Dim lngEditPriceTotal		'調整金額合計
Dim lngTaxPriceTotal		'税額合計
Dim lngEditTaxTotal			'調整税額合計
Dim lngTotal				'請求書合計

strArrMessage = ""

Dim strHTML

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得
strAction            = Request("act")
strMode              = Request("mode")

strDmdDate           = Request("dmddate")
lngBillSeq           = Request("billseq")
lngBranchNo          = Request("branchno")

strYear              = Request("year")
strMonth             = Request("month")
strDay               = Request("day")

strBillComment       = Request("comment")

lngPerCount          = Request("percount")
vntPerId			 = ConvIStringToArray(Request("perid"))
'vntLastName			 = ConvIStringToArray(Request("lastName"))
'vntFirstName		 = ConvIStringToArray(Request("firstName"))
'vntLastKName		 = ConvIStringToArray(Request("lastKName"))
'vntFirstKName		 = ConvIStringToArray(Request("firstKName"))
strArrName			 = ConvIStringToArray(Request("pername"))
strArrKName			 = ConvIStringToArray(Request("perKname"))

lngBillCount         = Request("billcount")
vntPrice             = ConvIStringToArray(Request("price"))
vntEditPrice         = ConvIStringToArray(Request("editprice"))
vntTaxPrice          = ConvIStringToArray(Request("taxprice"))
vntEditTax           = ConvIStringToArray(Request("edittax"))
vntLineName          = ConvIStringToArray(Request("linename"))
vntOtherLineDivCd    = ConvIStringToArray(Request("divcd"))
vntOtherLineName     = ConvIStringToArray(Request("divname"))

'デフォルト値を設定
strYear        = IIf(strYear  = "", Year(Now()),  strYear )
strMonth       = IIf(strMonth = "", Month(Now()), strMonth)
strDay         = IIf(strDay   = "", Day(Now()),   strDay  )

lngPerCount    = IIf(lngPerCount = "", 5, lngPerCount )
lngBillCount   = IIf(lngBillCount = "", 5, lngBillCount )

strMode   = IIf(strMode = "", "insert", strMode )

Do

	'削除ボタン押下時
	If strAction = "delete" Then

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
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

'KMT 親画面不明
'			Response.Redirect "perPaymentInfo.asp?rsvno="&lngRsvNo
'			Response.end

		End If
	End If

	'保存ボタン押下時
	If strAction = "save" Then

       	'請求日の編集
		strReqDate = CDate(strYear & "/" & strMonth & "/" & strDay)

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'請求書新規作成・修正処理
		Ret = objPerbill.createPerBill_PERSON(strMode, _
									strReqDate, _
									vntPerId, _
									vntPrice, _
									vntEditPrice, _
									vntTaxPrice, _
									vntEditTax, _
									vntLineName, _
									vntOtherLineDivCd, _
									strBillComment, _
									Session("USERID"), _
									lngBillSeq, _
									lngBranchNo _
							)


		'保存に失敗した場合
		If Ret = False Then
			Err.Raise 1000, , "保存に失敗しました。"
		End If

		'保存終了時は更新モードでリダイレクト
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&percount=" & lngPerCount & "&billcount=" & lngBillCount & "&dmddate=" & strReqDate & "&billseq=" & lngBillSeq & "&branchno=" & lngBranchNo
		Response.End

	End If

	Exit Do
Loop

Do

	'配列の宣言を行う。
	If strAction = "" Or strAction = "saveend" Then

		'配列の宣言
		vntPerId          = Array()
		strArrName		  = Array()
		strArrKName		  = Array()

		vntPrice          = Array()
		vntEditPrice      = Array()
		vntTaxPrice       = Array()
		vntEditTax        = Array()
		vntLineTotal      = Array()
		vntLineName       = Array()
		vntOtherLineDivCd = Array()
		vntOtherLineName  = Array()

		ReDim Preserve vntPerId(lngPerCount)
		ReDim Preserve strArrName(lngPerCount)
		ReDim Preserve strArrKName(lngPerCount)

		ReDim Preserve vntPrice(lngBillCount)
		ReDim Preserve vntEditPrice(lngBillCount)
		ReDim Preserve vntTaxPrice(lngBillCount)
		ReDim Preserve vntEditTax(lngBillCount)
		ReDim Preserve vntLineTotal(lngBillCount)
		ReDim Preserve vntLineName(lngBillCount)
		ReDim Preserve vntOtherLineDivCd(lngBillCount)
		ReDim Preserve vntOtherLineName(lngBillCount)

	Else

		vntLineTotal      = Array()

		ReDim Preserve vntPerId(lngPerCount)
		ReDim Preserve strArrName(lngPerCount)
		ReDim Preserve strArrKName(lngPerCount)

		ReDim Preserve vntPrice(lngBillCount)
		ReDim Preserve vntEditPrice(lngBillCount)
		ReDim Preserve vntTaxPrice(lngBillCount)
		ReDim Preserve vntEditTax(lngBillCount)
		ReDim Preserve vntLineTotal(lngBillCount)
		ReDim Preserve vntLineName(lngBillCount)
		ReDim Preserve vntOtherLineDivCd(lngBillCount)
		ReDim Preserve vntOtherLineName(lngBillCount)

	End If


	'新規モード、更新モード（初期表示、保存終了後）以外読込みを行わない
	If strMode = "insert" OR ( strMode = "update" AND strAction <> "" AND strAction <> "saveend" )   Then
		Exit Do
	End If

	strDmdDate = CDate(strDmdDate)
	strYear  = CStr(Year(strDmdDate))
	strMonth = CStr(Month(strDmdDate))
	strDay   = CStr(Day(strDmdDate))

	'請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得する
	lngPerRet = objPerbill.SelectPerBill_Person( _
											strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntPerId, _
											vntLastName, _
											vntFirstName, _
											vntLastKName, _
											vntFirstKName )

	'個人情報が存在しない場合
	If lngPerRet < 1 Then
		Err.Raise 1000, , "個人情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	For i=0 To lngPerRet - 1
		If i <= UBound(vntLastName) Then
			'個人名編集
			strArrName(i)  = Trim(vntLastName(i) & "　" &  vntFirstName(i))
			strArrKName(i) = Trim(vntLastKName(i) & "　" &  vntFirstKName(i))
		End If
	Next

	If lngPerCount <= lngPerRet Then
		lngPerCount = (lngPerRet / 5)*5 + 5
	End If

	'配列は表示サイズに変更
	ReDim Preserve vntPerId(lngPerCount)
	ReDim Preserve strArrName(lngPerCount)
	ReDim Preserve strArrKName(lngPerCount)

	'個人請求明細情報の取得
	lngBillRet = objPerbill.SelectPerBill_Person_c(strDmdDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngBillLineNo, _
													vntPrice, _
													vntEditPrice, _
													vntTaxPrice, _
													vntEditTax, _
													vntLineName, _
													vntOtherLineDivCd, _
													vntOtherLineName )

'	lngBillRet = objPerbill.SelectPerBill_c(strDmdDate, _
'											lngBillSeq, _
'											lngBranchNo, _
'											lngBillLineNo, _
'											vntPrice, _
'											vntEditPrice, _
'											vntTaxPrice, _
'											vntEditTax, _
'											, , , , , _
'											vntLineName, _
'											vntOtherLineDivCd, _
'											vntOtherLineName )

	'個人請求明細情報が存在しない場合
	If lngBillRet < 1 Then
		Err.Raise 1000, , "個人請求明細情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	If lngBillCount <= lngBillRet Then
		lngBillCount = (lngBillRet / 5)*5 + 5
	End If

	'配列は表示サイズに変更
	ReDim Preserve vntPrice(lngBillCount)
	ReDim Preserve vntEditPrice(lngBillCount)
	ReDim Preserve vntTaxPrice(lngBillCount)
	ReDim Preserve vntEditTax(lngBillCount)
	ReDim Preserve vntLineTotal(lngBillCount)
	ReDim Preserve vntLineName(lngBillCount)
	ReDim Preserve vntOtherLineDivCd(lngBillCount)
	ReDim Preserve vntOtherLineName(lngBillCount)

	'個人請求管理情報の取得
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntDelFlg, _
											, , , _
											strBillComment, _
											strPaymentDate, _
											lngPaymentSeq )

	'個人請求管理情報が存在しない場合
	If Ret <> True Then
		Err.Raise 1000, , "個人請求管理情報が取得できません。（請求書No　= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	'入金済フラグ初期化
	lngPaymentFlg = 0

	'入金情報あり？
	If IsNull(strPaymentDate) = False Then
		'入金済セット
		lngPaymentFlg = 1

		'入金情報の取得
		Ret = objPerbill.SelectPerPayment(strPaymentDate, _
											lngPaymentSeq, _
											lngPriceTotal_Pay, _
											lngCredit, _
											lngHappy_ticket, _
											lngCard, _
											strCardKind, _
											strCardNAME, _
											lngCreditslipno, _
											lngJdebit, _
											strBankCode, _
											strBankName, _
											lngCheque, _
											lngRegisterno, _
											strIcomedate, _
											strUserId, _
											strUserName )
		'受診情報が存在しない場合
		If Ret <> True Then
			Err.Raise 1000, , "入金情報が取得できません。（入金No　= " & vntPaymentDate(i) & vntPaymentSeq(i) &" )"
		End If
		objCommon.AppendArray strArrMessage, "入金済のため修正できません。"
	End If


	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 指定個人数のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function PerCountList( )

	Dim i

'	Redim Preserve strArrSelectNo(9)	'人数
'	Redim Preserve strArrSelectName(9) 	'名称

	'固定値の編集
'	For i=0 To 9
'		strArrSelectNo(i)  = Cstr((i+1)*5)
'		strArrSelectName(i) = (i+1)*5 & "人"
'	Next

	Redim Preserve strArrSelectNo(1)	'人数
	Redim Preserve strArrSelectName(1) 	'名称

	'固定値の編集
	For i=0 To 1
		strArrSelectNo(i)  = lngPerCount + i*5
		strArrSelectName(i) = (lngPerCount+i*5) & "人"
	Next


	PerCountList = EditDropDownListFromArray("percount", strArrSelectNo, strArrSelectName, lngPerCount, NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 指定明細数のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function BillCountList( )

	Dim i

'	Redim Preserve strArrSelectNo(9)	'人数
'	Redim Preserve strArrSelectName(9) 	'名称

	'固定値の編集
'	For i=0 To 9
'		strArrSelectNo(i)  = Cstr((i+1)*5)
'		strArrSelectName(i) = (i+1)*5 & "明細"
'	Next

	Redim Preserve strArrSelectNo(1)	'人数
	Redim Preserve strArrSelectName(1) 	'名称

	'固定値の編集
	For i=0 To 1
		strArrSelectNo(i)  = lngBillCount + i*5
		strArrSelectName(i) = (lngBillCount+i*5) & "明細"

	Next

	BillCountList = EditDropDownListFromArray("billcount", strArrSelectNo, strArrSelectName, lngBillCount, NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書コメントの妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim i
	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合

	'共通クラスのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon

		'日付のチェックは必要か？

		'請求書コメントチェック
		.AppendArray vntArrMessage, .CheckWideValue("請求書コメント", strBillComment, 200)

		'受診者入力チェック
		For i = 0 To lngPerCount -1
			If vntPerId(i) <> "" Then
				Exit For
			End If
		Next
		If Clng(i) >= Clng(lngPerCount) Then 
			.AppendArray vntArrMessage, "受診者を指定して下さい。"
		End If

		'請求明細入力チェック
		For i = 0 To lngBillCount -1
			If vntOtherLineDivCd(i) <> "" Then
				Exit For
			End If
		Next
		If Clng(i) >= Clng(lngBillCount) Then 
			.AppendArray vntArrMessage, "請求明細を指定して下さい。"
		End If

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人請求書新規情報</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<!-- #include virtual = "/webHains/includes/price.inc" -->
<!-- #include virtual = "/webHains/includes/Date.inc" -->

<SCRIPT TYPE="text/javascript">
<!--
var winOther;			// セット外請求追加ウィンドウハンドル
var winIncome;			// 入金情報ウィンドウハンドル
var Other_divCd;		// セット外請求書明細コード
var Other_lineName;		// 請求書明細名
var Other_divName;		// セット外請求書明細名
var Other_Price;		// 標準単価
var Other_EditPrice;	// 調整単価
var Other_TaxPrice;		// 標準税額
var Other_EditTax;		// 調整税額
var lngSelectedIndex;	// 個人検索ガイド表示時に選択された個人情報のインデックス


//セット外請求追加ウィンドウ表示
function otherIncomeWindow(divCd, lineName, divName, price, editPrice, taxPrice, editTax) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// ガイドとの連結用変数にエレメントを設定
	Other_divCd     = divCd;
	Other_divName   = divName;
	Other_lineName  = lineName;
	Other_Price     = price;
	Other_EditPrice = editPrice;
	Other_TaxPrice  = taxPrice;
	Other_EditTax   = editTax;

	// すでにガイドが開かれているかチェック
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			opened = true;
		}
	}

//	url = '/WebHains/contents/perbill/otherIncomeInfo.asp?billcount=0&mode=person'
	url = '/WebHains/contents/perbill/otherIncomeInfo.asp';
	url = url + '?billcount=0&mode=person';
	url = url + '&divcd=' + divCd.value;
	url = url + '&divname=' + divName.value;
	if ( lineName.value == '' ) {
		url = url + '&linename=' + divName.value;
	} else {
		url = url + '&linename=' + lineName.value;
	}
	url = url + '&price=' + price.value;
	url = url + '&editprice=' + editPrice.value;
	url = url + '&taxprice=' + taxPrice.value;
	url = url + '&edittax=' + editTax.value;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winOther.focus();
		winOther.location.replace(url);
	} else {
		winOther = window.open( url, '', 'width=430,height=300,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// 保存処理
function saveData() {

	if ( !confirm( 'この請求書を作成します。よろしいですか？' ) ) {
		return;
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}

// 表示行数の変更
function changeRow() {

	document.entryForm.act.value = 'dsp';
	document.entryForm.submit();

}

// 削除処理
function deleteData() {

	// 請求書未作成？
	if ( document.entryForm.dmddate.value == "" ||
		 document.entryForm.billseq.value == "" ||
		 document.entryForm.branchno.value == ""  ) {
		alert( '請求書は未作成の為、削除できません');
		return;
	}

	if ( !confirm( 'この請求書を削除します。よろしいですか？' ) ) {
		return;
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}

// セット外請求明細情報編集用関数
function setOtherDiv( divCd, lineName, divName, price, editPrice, taxPrice, editTax ) {

	// セット外請求明細コードの編集
	if ( Other_divCd ) {
		Other_divCd.value = divCd;
	}

	// 請求明細名の編集
	if ( Other_lineName ) {
		Other_lineName.value = lineName;
	}

	// セット外請求明細名の編集
	if ( Other_divName ) {
		Other_divName.value = divName;
	}

	// 標準金額の編集
	if ( Other_Price ) {
		Other_Price.value = price;
	}
	// 調整金額の編集
	if ( Other_EditPrice ) {
		Other_EditPrice.value = editPrice;
	}

	// 標準税額の編集
	if ( Other_TaxPrice ) {
		Other_TaxPrice.value = taxPrice;
	}

	// 調整税額の編集
	if ( Other_EditTax ) {
		Other_EditTax.value = editTax;
	}

	// 再表示
	changeRow();

}

// 請求書情報のクリア
function otherIncome_clear( divCd, lineName, divName, price, editPrice, taxPrice, editTax ) {

	// セット外請求明細コードの編集
	if (divCd ) {
		divCd.value = '';
	}

	// 請求明細名の編集
	if ( lineName ) {
		lineName.value = '';
	}

	// セット外請求明細名の編集
	if ( divName ) {
		divName.value = '';
	}

	// 標準金額の編集
	if ( price ) {
		price.value = '';
	}
	// 調整金額の編集
	if ( editPrice ) {
		editPrice.value = '';
	}

	// 標準税額の編集
	if ( taxPrice ) {
		taxPrice.value = '';
	}

	// 調整税額の編集
	if ( editTax ) {
		editTax.value = '';
	}

	// 再表示
	changeRow();

}

// 個人ガイド呼び出し
function callPerGuide( index ) {

	// 選択されたガイドのインデックスを保持
	lngSelectedIndex = index;

	perGuide_showGuidePersonal(document.entryForm.perid[ index ], 'pername' + index, 'perKname' + index, setPerName )

}

// 個人情報クリア
function clearPerInfo( index ) {

	document.getElementById('perid' + index ).innerHTML = "";
	document.getElementById('pername' + index ).innerHTML = "";
	document.getElementById('perKname' + index ).innerHTML = "";

	document.entryForm.perid[ index ].value = "";
	document.entryForm.pername[ index ].value = "";
	document.entryForm.perKname[ index ].value = "";

	// 再表示
	changeRow();

}

// hiddenタグの個人ＩＤ編集
function setPerName() {

	document.getElementById('perid' + lngSelectedIndex ).innerHTML = document.entryForm.perid[ lngSelectedIndex ].value ;

	document.entryForm.pername[ lngSelectedIndex ].value = document.getElementById('pername' + lngSelectedIndex ).innerHTML;
	document.entryForm.perKname[ lngSelectedIndex ].value = document.getElementById('perKname' + lngSelectedIndex ).innerHTML;

	// 再表示
	changeRow();

}

//入金情報ウィンドウ表示
function perBillIncomeWindow(perId, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillIncome.asp';
	url = url + '?perid=' + perId;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winIncome.focus();
		winIncome.location.replace(url);
	} else {
		winIncome = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

function windowClose() {

	// セット外請求追加ウインドウを閉じる
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			winOther.close();
		}
	}

	winOther = null;

	// 入金情報ウインドウを閉じる
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR HEIGHT="16">
			<TD HEIGHT="16" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print"></SPAN><FONT COLOR="#000000">■個人請求書新規作成</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
	'メッセージの編集
	If strAction <> "" AND strAction <> "dsp" Then


		Select Case strAction

			'保存完了時は「保存完了」の通知
			Case "saveend"
				Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

			'削除完了時は「削除完了」の通知
			Case "deleteend"
				Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select
	Else
		'修正モードで入金情報あり？
		If strMode = "update" And IsNull(strPaymentDate) = False Then
			Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
		End If

	End If
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">

<%
		'新規作成時は請求書No表示なし
		If strMode = "update" Then
%>
			<TR>
				<TD NOWRAP height="15">請求書No</TD>
				<TD height="15">：</TD>
				<TD height="15">
					<%= objCommon.FormatString(strDmdDate, "yyyymmdd") %><%= objCommon.FormatString(lngBillSeq, "00000") %><%= lngBranchNo %></TD>
				<TD height="15"></TD>
			</TR>
<%
		End If
%>
		<TR>
			<TD NOWRAP>請求発生日</TD>     
			<TD NOWRAP>：</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
<%
						'修正モードで入金情報あり？
						If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
						<TD WIDTH="21" HEIGHT="21"></TD>
						<TD><%= strYear %></TD>
						<TD>&nbsp;年&nbsp;</TD>
						<TD><%= strMonth %></TD>
						<TD>&nbsp;月&nbsp;</TD>
						<TD><%= strDay %></TD>
						<TD>&nbsp;日</TD>
<%
						Else
%>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" BORDER="0"></A></TD>
						<TD><%= EditSelectNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strYear)) %></TD>
						<TD>&nbsp;年&nbsp;</TD>
						<TD><%= EditSelectNumberList("month", 1, 12, Clng("0" & strMonth)) %></TD>
						<TD>&nbsp;月&nbsp;</TD>
						<TD><%= EditSelectNumberList("day",   1, 31, Clng("0" & strDay  )) %></TD>
						<TD>&nbsp;日</TD>
<%
						End if
%>
						<TD></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top" NOWRAP>請求書コメント</TD>
			<TD VALIGN="top" >：</TD>
<%
			'修正モードで入金情報あり？
			If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
				<TD NOWRAP><TEXTAREA NAME="comment" ROWS="4" COLS="50" STYLE="ime-mode:active;" DISABLED><%= strBillComment %></TEXTAREA></TD>
				<TD WIDTH="153"></TD>
<%
			Else
%>
				<TD NOWRAP><TEXTAREA NAME="comment" ROWS="4" COLS="50" STYLE="ime-mode:active;"><%= strBillComment %></TEXTAREA></TD>
				<TD VALIGN="bottom" WIDTH="153"><A HREF="javascript:saveData();"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します" BORDER="0"></A></TD>
<%
			End if
%>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD WIDTH="5"></TD>
			<TD NOWRAP>個人ＩＤ</TD>
			<TD WIDTH="5"></TD>
			<TD>受診者名</TD>
		</TR>
<%
		For i=0 To lngPerCount -1 
%>
			<TR>
				<INPUT TYPE="hidden" NAME="perid" VALUE="<%= vntPerId(i) %>">
				<INPUT TYPE="hidden" NAME="pername" VALUE="<%= strArrName(i) %>">
				<INPUT TYPE="hidden" NAME="perKname" VALUE="<%= strArrKName(i) %>">

<%
				'修正モードで入金情報あり？
				If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
					<TD WIDTH="20"></TD>
					<TD WIDTH="20"></TD>
<%
				Else
%>
					<TD><A HREF="javascript:callPerGuide(<%= i %>);"><IMG SRC="../../images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="22" BORDER="0"></A></TD>
					<TD><A HREF="javascript:clearPerInfo(<%= i %>)"><IMG SRC="../../images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21" BORDER="0"></TD>
<%
				End If
%>
				<TD WIDTH="5"></TD>
				<TD NOWRAP><SPAN ID="perid<%= i %>"><%= vntPerId(i) %></SPAN></TD>
				<TD WIDTH="5"></TD>
				<TD NOWRAP><B><SPAN ID="pername<%= i %>"><%= strArrName(i) %></SPAN></B>
							<%= IIf( vntPerId(i) <> "", "(", "") %><FONT SIZE="-1">
							<SPAN ID="perKname<%= i %>"><%= strArrKName(i) %></SPAN></FONT>
							<%= IIf( vntPerId(i) <> "", ")", "") %><FONT SIZE="-1"></TD>
			</TR>
<%
		Next
%>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
<%
			'修正モードで入金情報あり？
			If strMode = "update" And IsNull(strPaymentDate) = False Then
			Else
%>
				<TD></TD>
				<TD NOWRAP>指定可能個人を</TD>
				<TD><%= PerCountList() %></TD>
				<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示" BORDER="0"></A></TD>
<%
			End If
%>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP>請求明細分類</TD>
			<TD NOWRAP ALIGN="RIGHT">　金額</TD>
			<TD NOWRAP ALIGN="RIGHT">調整金額</TD>
			<TD NOWRAP ALIGN="RIGHT">　税額</TD>
			<TD NOWRAP ALIGN="RIGHT">調整税額</TD>
			<TD ALIGN="right" NOWRAP WIDTH="69">合計金額</TD>
		</TR>
<%
		lngPriceTotal     = 0
		lngEditPriceTotal = 0
		lngTaxPriceTotal  = 0
		lngEditTaxTotal   = 0
		lngTotal          = 0

		For i=0 To lngBillCount -1 
			vntLineTotal(i) = 0
%>
			<TR>
				<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= vntOtherLineDivCd(i) %>">
				<INPUT TYPE="hidden" NAME="linename" VALUE="<%= vntLineName(i) %>">
				<INPUT TYPE="hidden" NAME="divname" VALUE="<%= vntOtherLineName(i) %>">
				<INPUT TYPE="hidden" NAME="price" VALUE="<%= vntPrice(i) %>">
				<INPUT TYPE="hidden" NAME="editprice" VALUE="<%= vntEditPrice(i) %>">
				<INPUT TYPE="hidden" NAME="taxprice" VALUE="<%= vntTaxPrice(i) %>">
				<INPUT TYPE="hidden" NAME="edittax" VALUE="<%= vntEditTax(i) %>">

<%
				'修正モードで入金情報あり？
				If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
					<TD WIDTH="20"></TD>
					<TD WIDTH="20"></TD>
<%
				Else
%>
					<TD NOWRAP><A HREF="JavaScript:otherIncomeWindow( document.entryForm.divcd[<%= i %>], document.entryForm.linename[<%= i %>], document.entryForm.divname[<%= i %>], document.entryForm.price[<%= i %>], document.entryForm.editprice[<%= i %>], document.entryForm.taxprice[<%= i %>], document.entryForm.edittax[<%= i %>] )"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="セット外請求追加" BORDER="0"></A></TD>
					<TD NOWRAP><A HREF="JavaScript:otherIncome_clear(document.entryForm.divcd[<%= i %>], document.entryForm.linename[<%= i %>], document.entryForm.divname[<%= i %>], document.entryForm.price[<%= i %>], document.entryForm.editprice[<%= i %>], document.entryForm.taxprice[<%= i %>], document.entryForm.edittax[<%= i %>])"><IMG SRC="../../images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
<%
				End If
%>

				<TD NOWRAP><%=IIf( vntLineName(i) <> "", vntLineName(i), vntOtherLineName(i)) %></TD>
<%
				If vntOtherLineDivCd(i) <> "" Then
%>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
<%
					vntLineTotal(i)   = Clng(vntPrice(i)) + Clng(vntEditPrice(i)) + _
										Clng(vntTaxPrice(i)) + Clng(vntEditTax(i))
%>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntLineTotal(i)) %></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If
%>
			</TR>
<%
				If vntOtherLineDivCd(i) <> "" Then
					lngPriceTotal     = lngPriceTotal     + vntPrice(i)
					lngEditPriceTotal = lngEditPriceTotal + vntEditPrice(i)
					lngTaxPriceTotal  = lngTaxPriceTotal  + vntTaxPrice(i)
					lngEditTaxTotal   = lngEditTaxTotal   + vntEditTax(i)
					lngTotal          = lngTotal          + vntLineTotal(i)
				End If
		Next
%>
		<TR height="1">
			<TD 70" colspan="9" nowrap align="right" bgcolor="#999999" height="1"></TD>
		</TR>
		<TR height="15">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD COLSPAN="1"70" NOWRAP ALIGN="right" height="15">合計</TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngEditPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngTaxPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngEditTaxTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><B><%= FormatCurrency(lngTotal) %></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
<%
			'修正モードで入金情報あり？
			If strMode = "update" And IsNull(strPaymentDate) = False Then
			Else
%>
				<TD></TD>
				<TD NOWRAP>指定可能明細を</TD>
				<TD><%= BillCountList() %></TD>
				<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示" BORDER="0"></A></TD>
<%
			END If
%>
		</TR>
	</TABLE>
	<BR>
	<BR>
	<TABLE WIDTH="541" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
<%
			If strDmdDate = "" Then
%>
				<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">●</FONT>&nbsp;入金情報</TD>
<%
			Else
%>
				<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">●</FONT>
<%				For i = 0 To lngPerCount
					If vntPerId(i) <> "" Then
						Exit For
					End If
				Next
%>
				<A HREF="JavaScript:perBillIncomeWindow(<%= vntPerId(i) %>, '<%= strDmdDate %>', <%= lngBillSeq %>, <%= lngBranchNo %>)">入金情報</A></TD>
<%
			End If
%>
			<TD NOWRAP WIDTH="100%"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD ALIGN="left" NOWRAP>入金日</TD>
			<TD NOWRAP>現金</TD>
			<TD NOWRAP>クレジット</TD>
			<TD NOWRAP>Jデビッド</TD>
			<TD NOWRAP>ハッピー買物</TD>
			<TD NOWRAP>小切手</TD>
			<TD NOWRAP>オペレータ</TD>
		</TR>
<%
		If lngPaymentFlg = 0 Then
%>
			<TR>
				<TD NOWRAP><B>入金されていません。</B></TD>
			</TR>
<%
		Else
%>
			<TR>
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:perBillIncomeWindow(<%= vntPerId(i) %>, '<%= strDmdDate %>', <%= lngBillSeq %>, <%= lngBranchNo %>)"><%= strPaymentDate %></A></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCredit <> "", FormatCurrency(lngCredit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCard <> "", FormatCurrency(lngCard), "") %></B></FONT></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngJdebit <> "", FormatCurrency(lngJdebit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngHappy_ticket <> "", FormatCurrency(lngHappy_ticket), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCheque <> "", FormatCurrency(lngCheque), "") %></B></TD>
				<TD NOWRAP ALIGN="left"><%= strUserName %></TD>
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
			<TD NOWRAP><A HREF="JavaScript:deleteData();">この請求書を取り消す</A></TD>
		</TR>
<%
		End If
%>
	</TABLE>
	<BR>

</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
