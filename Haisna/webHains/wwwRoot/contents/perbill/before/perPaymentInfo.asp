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

Dim objCommon			'共通クラス
Dim objDemand				'請求情報アクセス用
Dim objConsult				'受診情報アクセス用
Dim objPerbill				'受診情報アクセス用

Dim strMode					'処理モード
Dim lngRsvNo				'予約番号
Dim lngCount				'取得件数
Dim lngSubCount				'取得件数
Dim lngPerBillCount			'取得件数
Dim lngPerCount				'個人負担件数 2003.12.18 add
Dim lngDelCount				'取消し伝票数
Dim Ret						'関数戻り値

Dim lngHeader				'項目書込みフラグ
Dim lngTotalFlg

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


'個人請求書情報用変数(SelectPerBill)
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

'個人受診金額用変数(SelectConsult_m)
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
Dim vntOptName				'オプション名称
Dim vntOptBranchNo			'オプション枝番
Dim vntOtherLineDivCd		'セット外名称区分
Dim vntLineName				'明細名称（セット外明細名称含む）
Dim vntBillLineNo			'請求明細行No
Dim vntOmitTaxFlg			'消費税免除フラグ
Dim vntPrintDate			'領収書印刷日

'KMT 同じ変数を別のCOMで使用すると死ぬときがあった為、とりあえず変数分ける
Dim vntDmdDate_m			'請求日
Dim vntBillSeq_m			'請求書Ｓｅｑ
Dim vntBranchNo_m			'請求書枝番
Dim vntPrice_m				'金額
Dim vntEditPrice_m			'調整金額
Dim vntTaxPrice_m			'税額
Dim vntEditTax_m			'調整税額
Dim vntPaymentDate_m		'入金日
Dim vntPaymentSeq_m			'入金Ｓｅｑ

'個人受診金額小計取得用
Dim lngPriceCount			'取得件数
Dim vntSubOrgCd1            '団体コード１
Dim vntSubOrgCd2            '団体コード２
Dim vntSubPrice_m			'金額小計
Dim vntSubEditPrice_m		'調整金額小計
Dim vntSubTax_m				'小計（税額）
Dim vntSubEditTax_m			'小計（税調整額）
Dim vntSubTotal_m			'小計（小計の）



Dim lngCloseCount
Dim vntCloseOrgCd1          '団体コード１
Dim vntCloseOrgCd2          '団体コード２
Dim vntCloseOrgName         '団体名
Dim vntCloseCsCd            'コースコード
Dim vntCloseCsName          'コース名
Dim vntBillNo				'請求書番号
Dim blnVislbleSave			'保存ボタンを表示するかどうか
Dim blnExistsClose			'既に締め済み

'個人受診金額更新用変数
Dim vntExistsZeroData		'\0データ ON/OFFスイッチ
Dim lngSaveRsvNo			'更新用予約番号

Dim vntBreakOrgCd1			'ブレイク用団体コード
Dim vntBreakOrgCd2			'ブレイク用団体コード
Dim vntBreakCsCd			'ブレイク用コースコード
Dim vntBreakDmdLineClassCd	'ブレイク用請求明細分類コード

Dim lngPerBillTotal			'金額合計（個人負担請求書）
Dim lngPerPayTotal			'入金合計（個人負担請求書）

'金額小計用変数
Dim vntSubPrice				'金額小計
Dim vntSubEditPrice			'調整金額小計
Dim vntSubTax				'小計（税額）
Dim vntSubEditTax			'小計（税調整額）
Dim vntSubTotal				'小計（小計の）

Dim lngPriceTotal			'金額合計
Dim lngEditPriceTotal		'調整金額合計
Dim lngTaxTotal				'合計（税額）
Dim lngEditTaxTotal			'合計（税調整額）
Dim lngTotal				'合計（全金額）

'セット外請求明細用パラメータ
Dim lngBillCount			'未入金請求書数
Dim strReqDmdDate			'請求日
Dim lngReqBillSeq			'請求書Ｓｅｑ
Dim lngReqBranchNo			'請求書枝番

Dim lngDelDsp				'取消伝票表示有無フラグ

Dim strActMode				'動作モード(保存:"save"、保存完了:"saved")
Dim strMessage				'エラーメッセージ
Dim i						'インデックス
Dim strReadyCloseString		'締め済みメッセージ

strMessage = ""

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'引数値の取得
strMode      = Request("mode")
lngRsvNo     = Request("rsvNo")
strActMode   = Request("actMode")
lngDelDsp    = Request("DelDsp")


'パラメタのデフォルト値設定
lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )
lngDelDsp  = IIf(lngDelDsp <> 1, 0,  lngDelDsp )

Do

	'消費税免除？
	If strActMode = "omit" Then
		Ret = objPerBill.OmitTaxSet( lngRsvNo )
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=" & strMode & "&rsvNo=" & lngRsvNo & "&actMode=&DelDsp=" & lngDelDsp
		Response.End
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

	'締め管理情報取得
	lngCloseCount = objDemand.SelectPersonalCloseMngInfo(lngRsvNo, _
														vntCloseOrgCd1, _
														vntCloseOrgCd2, _
														vntCloseOrgName, _
														vntCloseCsCd, _
														vntCloseCsName, _
														vntBillNo)

	blnVislbleSave = False
	blnExistsClose = False
	strReadyCloseString = ""

	'締め情報の存在チェック
	For i = 0 To lngCloseCount - 1
		If Trim(vntBillNo(i)) <> "" Then
			blnExistsClose = True
			strReadyCloseString = "既に締め処理が実行されています。金額の修正はできません。"
			Exit For
		End If

	Next

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If


	'予約番号から個人請求書管理情報を取得する
	lngPerBillCount = objPerbill.SelectPerBill(lngRsvNo, _
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

	lngBillCount = 0
	lngDelCount = 0

	For i=0 To lngPerBillCount - 1
		'取消し伝票カウントする。
		If vntDelflg(i) = 1 Then
			lngDelCount = lngDelCount + 1
		End If

		'未入金の請求書をカウントする。（ohterIncomeInfoのパラメータ）
		If (IsNull(vntPaymentDate(i)) = True) AND (vntDelflg(i) = 0) Then
			lngBillCount = lngBillCount + 1
			strReqDmdDate = vntDmdDate(i)
			lngReqBillSeq = vntBillSeq(i)
			lngReqBranchNo = vntBranchNo(i)
		End If
	Next

	'個人請求書情報が存在しない場合
'	If lngPerBillCount < 1 Then
'		Err.Raise 1000, , "個人請求書情報が存在しません。（予約番号= " & lngRsvNo & " PerBillCount= " & lngPerBillCount & ")"
'	End If

	''' 前もって個人負担件数を数えるためここへ移動 2003.12.18 by FFCS
	'個人受診金額情報取得
	lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
											 vntOrgCd1, _
											 vntOrgCd2, _
											 vntOrgSeq, _
											 vntOrgName, _
											 vntPrice_m, _
											 vntEditPrice_m, _
											 vntTaxPrice_m, _
											 vntEditTax_m, _
											 vntLineTotal, _ 
											 vntPriceSeq, _
											 vntCtrPtCd, _
											 vntOptCd, _
											 vntOptBranchNo, _
											 vntOptName, _
											 vntOtherLineDivCd, _
											 vntLineName, _
											 vntDmdDate_m, _
											 vntBillSeq_m, _
											 vntBranchNo_m, _
											 vntBillLineNo, _
											 vntPaymentDate_m, _
											 vntPaymentSeq_m, _
											 vntOmitTaxFlg, _
											 vntPrintDate )

	lngPerCount = 0
	For i=0 To lngCount - 1
		'個人負担をカウントする。
		If (( vntOrgCd1(i) = "XXXXX" ) AND (vntOrgCd1(i) = "XXXXX")) Then
			lngPerCount = lngPerCount + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 小計の編集
'
' 引数　　 : 
'
' 戻り値　 : 小計レコード
'
' 備考　　 : SelectConsult_mTotal実行後に起動
'
'-------------------------------------------------------------------------------
Function SubPriceCount( )

	Dim lngRecode
	For lngRecode = 0 To lngPriceCount - 1
		If ( vntBreakOrgCd1 = vntSubOrgCd1(lngRecode) AND vntBreakOrgCd2 = vntSubOrgCd2(lngRecode) ) Then
			SubPriceCount = lngRecode
			Exit For
		End If
	Next

End Function


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求金額表示～個人</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCreate1;			// 請求書作成ウィンドウハンドル
var winIncome1;			// まとめて入金ウィンドウハンドル
var winOption;			// 受診セット変更ウィンドウハンドル
var winOther;			// セット外請求追加ウィンドウハンドル
var winEditLine1;		// セット外請求登録・修正ウィンドウハンドル
var winEditLine2;		// 請求明細登録・修正ウィンドウハンドル
var winIncome;			// 入金情報ウィンドウハンドル
var winHenkin;			// 返金情報ウィンドウハンドル
var winPrint;			// 印刷ウィンドウハンドル


//請求書作成ウィンドウ表示
function create1Window() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winCreate1 != null ) {
		if ( !winCreate1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/createPerBill1.asp?rsvno=<%= lngRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winCreate1.focus();
		winCreate1.location.replace(url);
	} else {
		winCreate1 = window.open( url, '', 'width=530,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//まとめて入金ウィンドウ表示
function income1Window() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winIncome1 != null ) {
		if ( !winIncome1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillAllIncome.asp';
	url = url + '?rsvno=' + <%= lngRsvNo %>;
	url = url + '&perid=' + '<%= strPerID %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winIncome1.focus();
		winIncome1.location.replace(url);
	} else {
		winIncome1 = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//受診セット変更ウィンドウ表示
function OptionWindow() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winOption != null ) {
		if ( !winOption.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillOption.asp';
	url = url + '?rsvno=' + <%= lngRsvNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winOption.focus();
		winOption.location.replace(url);
	} else {
		winOption = window.open( url, '', 'width=430,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//セット外請求追加ウィンドウ表示
function otherIncomeWindow() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/otherIncomeInfo.asp?rsvno=<%= lngRsvNo %>&billcount=<%= lngBillCount %>&dmddate=<%= strReqDmdDate %>&billseq=<%= lngReqBillSeq %>&branchno=<%= lngReqBranchNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winOther.focus();
		winOther.location.replace(url);
	} else {
		winOther = window.open( url, '', 'width=550,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//セット外請求登録・修正ウィンドウ表示
function editLine1Window( rsvNo, i) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winEditLine1 != null ) {
		if ( !winEditLine1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/editPerBillLine1.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&record=' + i;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winEditLine1.focus();
		winEditLine1.location.replace(url);
	} else {
		winEditLine1 = window.open( url, '', 'width=550,height=335,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//請求明細登録・修正ウィンドウ表示
function editLine2Window( rsvNo, i) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winEditLine2 != null ) {
		if ( !winEditLine2.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/editPerBillLine2.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&record=' + i;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winEditLine2.focus();
		winEditLine2.location.replace(url);
	} else {
		winEditLine2 = window.open( url, '', 'width=550,height=335,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//入金情報ウィンドウ表示
function IncomeWindow(rsvNo, dmdDate, billSeq, branchNo ) {

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
	url = url + '?rsvno=' + rsvNo;
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

//返金情報ウィンドウ表示
function HenkinWindow( rsvNo, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winHenkin != null ) {
		if ( !winHenkin.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perHenkin.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winHenkin.focus();
		winHenkin.location.replace(url);
	} else {
		winHenkin = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//印刷情報ウィンドウ表示
function PrintWindow( rsvNo, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/prtPerBill.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winPrint.focus();
		winPrint.location.replace(url);
	} else {
		winPrint = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// submit時の処理
function submitForm( actMode ) {

	var objPrice;
	var i;

	objPrice = entryForm.editPrice;

	for ( ; ; ) {

		errFlg = false;

		// 全負担金額テキストの検索
		for ( i = 0; i < objPrice.length; i++ ) {
	
			if ( isNaN(objPrice[i].value) == true ) {
				errFlg = true;
				alert((i + 1) + '行目に入力された調整金額が数値として認められません。');
				objPrice[i].focus()
			}

		}

		// 正規表現チェック
		if ( errFlg == true ) {
			break;
		}

		// 動作モードを指定してsubmit
		// （わざわざこのような処理を施しているのはEnterキーによるsubmitを行わせないためである）
		document.entryForm.actMode.value = actMode;
		document.entryForm.submit();

		break;
	}
}

// 取消し処理
function deleteData() {

	if ( !confirm( 'この請求書を削除します。よろしいですか？' ) ) {
		return;
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}

// 消費税免除処理
function OmitTaxAct() {

	if ( !confirm( '個人負担金額の消費税を一括で免除します。よろしいですか？' ) ) {
		return;
	}

	// モードを指定してsubmit
	document.entryForm.actMode.value = 'omit';
	document.entryForm.submit();

}

function windowClose() {

	// 請求書作成ウインドウを閉じる
	if ( winCreate1 != null ) {
		if ( !winCreate1.closed ) {
			winCreate1.close();
		}
	}

	winCreate1 = null;

	// まとめて入金ウインドウを閉じる
	if ( winIncome1 != null ) {
		if ( !winIncome1.closed ) {
			winIncome1.close();
		}
	}

	winIncome1 = null;

	// 入金情報ウインドウを閉じる
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;

	// 返金情報ウインドウを閉じる
	if ( winHenkin != null ) {
		if ( !winHenkin.closed ) {
			winHenkin.close();
		}
	}

	winHenkin = null;

	// 受診セット変更ウインドウを閉じる
	if ( winOption != null ) {
		if ( !winOption.closed ) {
			winOption.close();
		}
	}

	winOption = null;

	// セット外請求追加ウインドウを閉じる
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			winOther.close();
		}
	}

	winOther = null;

	// セット外請求登録・修正ウインドウを閉じる
	if ( winEditLine1 != null ) {
		if ( !winEditLine1.closed ) {
			winEditLine1.close();
		}
	}

	winEditLine1 = null;

	// 請求明細登録・修正ウインドウを閉じる
	if ( winEditLine2 != null ) {
		if ( !winEditLine2.closed ) {
			winEditLine2.close();
		}
	}

	winEditLine2 = null;

	// 印刷ウインドウを閉じる
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			winPrint.close();
		}
	}

	winPrint = null;


}


//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="RsvNo"   VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR HEIGHT="16">
		<TD HEIGHT="16" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print"></SPAN><FONT COLOR="#000000">■個人受診金額情報</FONT></B></TD>
	</TR>
</TABLE>

<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP >受診日</TD>
			<TD NOWRAP >：</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= strCslDate %></TD>
			<TD NOWRAP WIDTH="10"></TD>
			<TD NOWRAP >予約番号</TD>
			<TD NOWARP >：</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP >受診コース</TD>
			<TD NOWRAP >：</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="746">
		<TR>
			<TD COLSPAN="2" WIDTH="325" HEIGHT="10"></TD>
			<TD WIDTH="184" HEIGHT="10"></TD>
			<TD WIDTH="225" HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top" WIDTH="96" ><%= strPerId %></TD>
			<TD NOWRAP><B><a href="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strPerId %>" TARGET="_blank"><%= strLastName & " " & strFirstName %></a></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="225"><%= FormatDateTime(strBirth, 1) %>生　<%= Int(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
			<TD align="right" NOWRAP WIDTH="184"><FONT COLOR="black"><INPUT TYPE="CHECKBOX" NAME="delDsp" VALUE="1" <%= IIf( lngDelDsp = "1", "CHECKED", "") %>> 取消伝票も表示する</FONT></TD>
			<TD NOWRAP WIDTH="225"><INPUT TYPE="IMAGE" SRC="../../images/b_prev.gif" BORDER="0" WIDTH="53" HEIGHT="28" ALT="表示する"></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="182">
		<TR>
			<TD NOWRAP><A HREF="JavaScript:create1Window()"><IMG SRC="/webHains/images/b_CrePerBill.gif" WIDTH="110" HEIGHT="24" ALT="個人請求明細から請求書を作成します"></A></TD>
			<TD NOWRAP><A HREF="JavaScript:income1Window()"><IMG SRC="/webHains/images/b_AllIncome.gif" WIDTH="110" HEIGHT="24" ALT="他の請求書とまとめて入金します"></A></TD>
		</TR>
		<TR>
			<TD colspan="2" nowrap align="left" valign="BOTTOM"><BR>
			<SPAN STYLE="color:#cc9999">●</SPAN><FONT COLOR="black">個人負担請求書情報</FONT></TD>
		</TR>
	</TABLE>

	<FONT COLOR="black"><SPAN STYLE="color:#cc9999"></SPAN></FONT>

<%
	'個人負担なし？
	If lngPerCount = 0 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TD NOWRAP ><FONT>　個人負担はありません。</TD>
		</TABLE>
<%
	Else
		'取消し伝票しかない？
		If lngPerBillCount = lngDelCount Then
%>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
				<TD NOWRAP ><FONT COLOR="#ff6600"><B>　請求書がありません。</B></TD>
			</TABLE>
<%
		End If
	End If
%>

<%
	If ((lngDelCount > 0) AND (lngDelDsp = 1)) OR (lngPerBillCount > lngDelCount) Then
%>
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
				<TD NOWRAP ALIGN="RIGHT">入金処理</TD>
				<TD NOWRAP ALIGN="RIGHT">返金</TD>
				<TD NOWRAP ALIGN="LEFT">印刷</TD>
			</TR>
<%
	End If

	Do

		'エラー時は何もしない
		If strMessage <> "" Then Exit Do

		lngPerBillTotal = 0
		lngPerPayTotal = 0
		lngTotalFlg = 0

		'個人請求書情報の編集
		For i = 0 To lngPerBillCount - 1
			If ( (lngDelDsp = 1) OR (lngDelDsp <> 1 AND vntDelflg(i) <> 1) ) Then

				'取消し伝票表示あり時の請求書合計表示
				If( lngDelDsp = 1 AND vntDelflg(i) = 1 AND lngTotalFlg = 0 AND lngPerBillCount > lngDelCount) Then
%>
					<TR BGCOLOR="#FFFFFF">
						<TD></TD>
						<TD NOWRAP>合計</TD>
						<TD COLSPAN="4"></TD>
						<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPerBillTotal) %></B></TD>
						<TD NOWRAP ALIGN="RIGHT"><FONT COLOR=<%= IIf(lngPerPayTotal <> 0, "RED", "BLACK") %>><B><%= FormatCurrency(lngPerPayTotal) %></B></FONT></TD>
						<TD></TD>
					</TR>
<%
					lngTotalFlg = 1
					lngPerBillTotal = 0
					lngPerPayTotal = 0
				End If
%>
				<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#EEEEEE") %> HEIGHT="24">
					<TD NOWRAP ALIGN="left"><A href="perBillInfo.asp?dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= lngRsvNo %>">
						<%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq(i), "00000") %>
						<%= vntBranchNo(i) %></A></TD>
					<TD NOWRAP><%= vntDmdDate(i) %><FONT COLOR="#666666"></FONT></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(vntSubTotal(i)) %></B></TD>
<%
				'入金情報あり？
				If IsNull(vntPaymentDate(i)) = False Then
%>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(0) %></B></TD>
<%
				Else
'					lngPerPayTotal = lngPerPayTotal + vntSubTotal(i)
					If vntBranchNo(i) = 0 Then
						lngPerPayTotal = lngPerPayTotal + vntSubTotal(i)
					End If
%>
					<TD NOWRAP ALIGN="RIGHT"><B><FONT  COLOR=<%= IIf(vntSubTotal(i) = 0 OR vntBranchNo(i) = 1, "BLACK", "RED") %>><%= IIf(vntBranchNo(i) = 0, FormatCurrency(vntSubTotal(i)), FormatCurrency(0)) %></FONT></B></TD>
<%
				End If
%>

<%
				If (vntBranchNo(i) = 0) Then
%>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:IncomeWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">入金情報</A></TD>
					<TD nowrap align="CENTER"></TD>

<%				Else
%>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:HenkinWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">返金情報</A></TD>
					<TD nowrap align="CENTER">済</TD>
<%
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:PrintWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">
					<IMG SRC="/webHains/images/b_Prt.gif" WIDTH="51" HEIGHT="24" ALT="この請求書を印刷します">
				</A></TD>
				</TR>
<%
				lngPerBillTotal = lngPerBillTotal + vntSubTotal(i)
			End If

		Next

		Exit Do
	Loop
%>

<%
	'合計表示
	If (lngPerBillCount > lngDelCount) OR (lngDelDsp = 1 AND lngDelCount > 0) Then
%>
			<TR BGCOLOR="#FFFFFF" HEIGHT="24">
				<TD></TD>
				<TD NOWRAP>合計</TD>
				<TD COLSPAN="4"></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPerBillTotal) %></B></TD>
				<TD NOWRAP ALIGN="RIGHT"><FONT COLOR=<%= IIf(lngPerPayTotal <> 0, "RED", "BLACK") %>><B><%= FormatCurrency(lngPerPayTotal) %></B></FONT></TD>
				<TD></TD>
			</TR>
		</TABLE>
<%
	End If
%>

	<BR>
	<HR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
		<TR>
			<TD nowrap align="left" valign="BOTTOM" COLSPAN="3">
				<SPAN STYLE="color:#cc9999">●</SPAN><FONT COLOR="black">個人負担金額詳細情報</FONT>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:OptionWindow()">
					<IMG SRC="/webHains/images/b_ChangeSet.gif" WIDTH="110" HEIGHT="24" ALT="受診セットを変更します">
				</A>
			</TD>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:otherIncomeWindow()">
					<IMG SRC="/webHains/images/b_OtherSet.gif" WIDTH="110" HEIGHT="24" ALT="セット外請求明細情報を追加します">
				</A>
			</TD>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:OmitTaxAct()">
					<IMG SRC="/webHains/images/b_delTax.gif" WIDTH="110" HEIGHT="24" ALT="全ての個人明細において消費税を免除します">
				</A>
			</TD>
		</TR>
	</TABLE>

<%
	Do

		'エラー時は何もしない
		If strMessage <> "" Then Exit Do

		''' 前もって個人負担の件数を知りたいので、最初に取得する。 2003.12.18 by FFCS
		'個人受診金額情報取得
'		lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
'												 vntOrgCd1, _
'												 vntOrgCd2, _
'												 vntOrgSeq, _
'												 vntOrgName, _
'												 vntPrice_m, _
'												 vntEditPrice_m, _
'												 vntTaxPrice_m, _
'												 vntEditTax_m, _
'												 vntLineTotal, _ 
'												 vntPriceSeq, _
'												 vntCtrPtCd, _
'												 vntOptCd, _
'												 vntOptBranchNo, _
'												 vntOptName, _
'												 vntOtherLineDivCd, _
'												 vntLineName, _
'												 vntDmdDate_m, _
'												 vntBillSeq_m, _
'												 vntBranchNo_m, _
'												 vntBillLineNo, _
'												 vntPaymentDate_m, _
'												 vntPaymentSeq_m, _
'												 vntOmitTaxFlg, _
'												 vntPrintDate )


		'受診金額情報が存在しない場合
		If lngCount < 1 Then
			Exit Do
		End If

		'個人受診金額小計取得
		lngPriceCount = objDemand.SelectConsult_mTotal(lngRsvNo, _
														vntSubOrgCd1, _
														vntSubOrgCd2, _
														vntSubPrice_m, _
														vntSubEditPrice_m, _
														vntSubTax_m, _
														vntSubEditTax_m, _
														vntSubTotal_m )

		'合計計算
		lngPriceTotal = 0
		lngEditPriceTotal = 0
		lngTaxTotal = 0
		lngEditTaxTotal = 0
		lngTotal = 0

		For i = 0 To lngPriceCount - 1
			lngPriceTotal = lngPriceTotal + vntSubPrice_m(i)
			lngEditPriceTotal = lngEditPriceTotal + vntSubEditPrice_m(i)
			lngTaxTotal = lngTaxTotal + vntSubTax_m(i)
			lngEditTaxTotal = lngEditTaxTotal + vntSubEditTax_m(i)
			lngTotal = lngTotal + vntSubTotal_m(i)

		Next


		If blnExistsClose = True Then
%>
			<FONT COLOR="#ff6600"><B><%= strReadyCloseString %></B></FONT>
<%
		End If

		'ブレイク用変数初期化
		vntBreakOrgCd1 = vntORGCD1(0)
		vntBreakOrgCd2 = vntORGCD2(0)
'		vntBreakOrgCd1 = ""
'		vntBreakOrgCd2 = ""
		lngHeader = 0

%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="silver">
				<TD NOWRAP >負担元</TD>
				<TD NOWRAP >請求明細名</TD>
				<TD NOWRAP ALIGN="RIGHT">　金額</TD>
				<TD NOWRAP ALIGN="RIGHT">調整金額</TD>
				<TD NOWRAP ALIGN="RIGHT">　税額</TD>
				<TD NOWRAP ALIGN="RIGHT">調整税額</TD>
				<TD NOWRAP ALIGN="RIGHT">小計</TD>
				<TD NOWRAP ALIGN="RIGHT">税免除</TD>
				<TD NOWRAP ALIGN="RIGHT">SEQ</TD>
				<TD NOWRAP ALIGN="RIGHT">セットコード</TD>
				<TD NOWRAP ALIGN="RIGHT">請求書No.</TD>
				<TD NOWRAP ALIGN="RIGHT">未収額</TD>
			</TR>

<%


		'個人負担請求書情報の編集
		For i = 0 To lngCount - 1

			'負担元の最後に小計を表示する。
			If ((vntBreakOrgCd1 <> vntORGCD1(i)) OR (vntBreakOrgCd2 <> vntORGCD2(i)) ) Then

				lngSubCount = SubPriceCount()
%>
				<TR BGCOLOR="#FFFFFF">
					<TD COLSPAN="1"></TD>
					<TD NOWRAP>小計</TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubPrice_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditPrice_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTax_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditTax_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTotal_m(lngSubCount)) %></TD>
				</TR>
				<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
<%
				
				'ブレイク用変数、再セット
				vntBreakOrgCd1       = vntORGCD1(i)
				vntBreakOrgCd2       = vntORGCD2(i)

			End If

			If (( vntORGCD1(i) <> "XXXXX" OR vntORGCD2(i) <> "XXXXX") AND (lngHeader = 0) ) Then

				lngHeader = 1
%>
				<TR BGCOLOR="#FFFFFF">
					<TD COLSPAN="2" VALIGN="bottom" HEIGHT="30"><SPAN STYLE="color:#cc9999">●</SPAN><FONT COLOR="black">団体負担金額情報</FONT></TD>
					<TD></TD>
				</TR>
				<TR BGCOLOR=#EEEEEE>
					<TD NOWRAP BGCOLOR="silver">負担元</TD>
					<TD NOWRAP BGCOLOR="silver">請求明細名</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">　金額</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">調整金額</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">　税額</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">調整税額</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">小計</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver"></TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">SEQ</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">セットコード</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">請求書No.</TD>
				</TR>

<%
			End If
%>
			<TR BGCOLOR=#EEEEEE>
				<TD NOWRAP><%= vntOrgCd1(i) & "-" & vntOrgCd2(i) & "：" & vntOrgName(i) %></TD>
<%
				'負担元が個人の場合
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then

					'領収書印刷済？
					If vntPrintDate(i) <> "" Then
%>
						<TD NOWRAP><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
					Else
						'セット外コード？
						If vntOtherLineDivCd(i) <> "" Then
%>
							<TD NOWRAP><A HREF="JavaScript:editLine2Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
						Else
%>
							<TD NOWRAP><A HREF="JavaScript:editLine1Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
						End If
					End If

				Else
%>
					<TD NOWRAP><A HREF="JavaScript:editLine1Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%				
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntLineTotal(i)) %></TD>
<%
				'負担元が個人の場合
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then
%>
					<TD NOWRAP ALIGN="CENTER"><%= IIf( vntOmitTaxFlg(i)=1, "○", "" ) %></TD>
<%
				Else
%>
				<TD NOWRAP ALIGN="RIGHT"></TD>

<%
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><%= vntPriceSeq(i) %></TD>
<%
				If vntOptCd(i) <> "" Then
%>
					<TD NOWRAP ALIGN="RIGHT"><%= vntOptCd(i) & "-" & vntOptBranchNo(i) %></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If
%>

<%
				If (vntDmdDate_m(i) <> "") AND (vntBillSeq_m(i) <> "") AND (vntBranchNo_m(i) <> "") Then 

%>
					<TD NOWRAP ALIGN="left"><A href="perBillInfo.asp?dmddate=<%= vntDmdDate_m(i) %>&billseq=<%= vntBillSeq_m(i) %>&branchno=<%= vntBranchNo_m(i) %>&rsvno=<%= lngRsvNo %>">
						<%= objCommon.FormatString(vntDmdDate_m(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq_m(i), "00000") %>
						<%= vntBranchNo_m(i) %></A></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If

				'負担元が個人の場合
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then
'					If IsNull(vntPaymentDate_m(i)) = True Then
					If (vntPaymentDate_m(i) = "") OR (vntPaymentSeq_m(i) = "") Then 
%>
						<TD NOWRAP ALIGN="RIGHT"><FONT COLOR="RED"><B>未収</B></FONT></TD>
<%
					Else
%>
						<TD NOWRAP ALIGN="RIGHT"></TD>
<%
					End If
				End If
%>
			</TR>
<%
		Next

		lngSubCount = SubPriceCount()
%>
			<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN="1"></TD>
				<TD NOWRAP>小計</TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubPrice_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditPrice_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTax_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditTax_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTotal_m(lngSubCount)) %></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
			<TR></TR>
			<TR></TR>
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN="1"></TD>
				<TD NOWRAP>合計</TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPriceTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngEditPriceTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngTaxTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngEditTaxTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngTotal) %><B></TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<BR>
			<TR>
				<TD COLSPAN="5" NOWRAP>
				<SPAN STYLE="color:#cc9999">●</SPAN>請求書Noが表示されている場合、数字をクリックすると請求書情報画面が表示されます。<BR>
				</TD>
			</TR>
			<TR BGCOLOR="silver">
				<TD NOWRAP COLSPAN="2">負担元</TD>
				<TD NOWRAP COLSPAN="2">コース</TD>
				<TD NOWRAP>請求書No</TD>
			</TR>
<%
			'締め情報の編集
'KMT
'Err.Raise 1000, , "（予約番号= " & lngRsvNo & " )  lngCloseCount= " & lngCloseCount & ""
'Exit Do

			For i = 0 To lngCloseCount - 1
%>
				<TR BGCOLOR=#EEEEEE>
					<TD NOWRAP><%= vntCloseORGCD1(i) & "-" & vntCloseORGCD2(i) %></TD>
					<TD NOWRAP><%= vntCloseORGNAME(i) %></TD>
					<TD NOWRAP><%= vntCloseCSCD(i) %></TD>
					<TD NOWRAP><%= vntCloseCSNAME(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="/webHains/contents/demand/dmdBurdenList.asp?action=search&IsPrint=0&billNo=<%= vntBillNo(i) %>"><%= vntBillNo(i) %></A></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>


</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->

</BODY>
</HTML>
