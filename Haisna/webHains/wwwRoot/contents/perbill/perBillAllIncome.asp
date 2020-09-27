<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   まとめて入金処理 (Ver0.0.1)
'	   AUTHER  : H.Kamata@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const DEFAULT_ROW         = 5			'デフォルト表示行数
Const INCREASE_COUNT      =  5			'表示行数の増分単位

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objPerBill			'会計情報アクセス用
Dim objHainsUser		'ユーザ情報アクセス用
Dim objConsult			'受診情報アクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget			'ターゲット先のURL
Dim lngRsvNo			'予約番号
Dim lngPerBillCount			'取得件数
Dim Ret						'関数戻り値


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
Dim vntPrice                '金額
Dim vntEditPrice            '調整金額
Dim vntTaxPrice             '税額
Dim vntEditTax            	'調整税額
Dim vntSubTotal				'小計（小計の）

Dim strDmdDate     		'請求日
Dim lngBillSeq     		'請求書Ｓｅｑ
Dim lngDelflg     		'取消伝票フラグ
Dim lngBranchNo     	'請求書枝番
Dim lngPriceTotal     	'請求金額合計
Dim lngTaxTotal     	'税金合計
Dim strUpdDate			'更新日付
Dim strUpdUser        	'更新者

Dim lngBillCnt			'指定請求書数
Dim lngDispCnt			'指定可能請求書数

'選択用
Dim arrDmdDate     		'請求日 配列
Dim arrBillSeq     		'請求書Ｓｅｑ 配列
Dim arrBranchNo     	'請求書枝番 配列
Dim arrPerID			'個人ＩＤ 配列
Dim arrLastName			'姓 配列
Dim arrFirstName		'名 配列
Dim arrLastKName		'カナ姓 配列
Dim arrFirstKName		'カナ名 配列
Dim arrRsvNo			'予約番号 配列
Dim arrAge				'年齢 配列
Dim arrGender			'性別 配列
Dim arrGenderName		'性別名称 配列

'同伴者情報
Dim vntInCslDate()	'受診日 配列
Dim vntInRsvNo()	'予約番号 配列
Dim vntFDmdDate     '請求日 配列
Dim vntFBillSeq     '請求書Ｓｅｑ 配列
Dim vntFBranchNo    '請求書枝番 配列
Dim vntFPerID		'個人ＩＤ 配列
Dim vntFLastName	'姓 配列
Dim vntFFirstName	'名 配列
Dim vntFLastKName	'カナ姓 配列
Dim vntFFirstKName	'カナ名 配列
Dim vntFRsvNo		'予約番号 配列
Dim vntFAge			'年齢 配列
Dim vntFGender		'性別 配列
Dim lngFriendsCnt	'同伴者請求書件数
Dim lngSetFlg		'同伴者セット済みフラグ

Dim i				'カウンタ
Dim j				'カウンタ

'セット外請求明細用パラメータ
Dim strReqDmdDate			'請求日
Dim lngReqBillSeq			'請求書Ｓｅｑ
Dim lngReqBranchNo			'請求書枝番


Dim strArrGenderName()		'性別名称

Dim strArrDispCnt()             '指定可能枚数
Dim strArrDispCntName()		'指定可能枚数名称


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strMode           = Request("mode")
strAction         = Request("act")
strTarget         = Request("target")

lngRsvNo          = Request("rsvno")
strPerId          = Request("perid")
strCslDate        = Request("csldate")

arrPerId		= ConvIStringToArray(Request("gdePerId"))
arrLastName     = ConvIStringToArray(Request("gdeLastName"))
arrFirstName    = ConvIStringToArray(Request("gdeFirstName"))
arrLastKName    = ConvIStringToArray(Request("gdeLastKName"))
arrFirstKName   = ConvIStringToArray(Request("gdeFirstKName"))
arrAge			= ConvIStringToArray(Request("gdeAge"))
arrGender		= ConvIStringToArray(Request("gdeGender"))
arrRsvNo		= ConvIStringToArray(Request("gdeRsvNo"))
arrDmdDate      = ConvIStringToArray(Request("gdeDmdDate"))
arrBillSeq      = ConvIStringToArray(Request("gdeBillSeq"))
arrBranchNo     = ConvIStringToArray(Request("gdeBranchNo"))

lngPriceTotal   = Request("priceTotal")
lngTaxTotal     = Request("taxTotal")
strUpdDate		= Request("updDate")
strUpdUser      = Session.Contents("userId")

lngBillCnt      = Request("billcnt")
lngDispCnt      = CLng("0" & Request("dispCnt"))

'初期値設定
lngBillCnt   = IIf(IsNumeric(lngBillCnt) = False, 0,  lngBillCnt )
strMode   = IIf(strMode = "", "init",  strMode )

'性別の配列作成
Call CreateGenderInfo()

'指定可能枚数の配列作成
Call CreateDispCntInfo

'チェック・更新・読み込み処理の制御
Do

	'初期表示時
	If lngDispCnt <= 0 Then
		'初期値
		lngDispCnt = DEFAULT_ROW
	End If
	
	If strMode = "init" Then
		arrPerId = Array()
		Redim Preserve arrPerId(lngDispCnt)       
		arrLastName = Array()
		Redim Preserve arrLastName(lngDispCnt)       
		arrFirstName = Array()
		Redim Preserve arrFirstName(lngDispCnt)       
		arrLastKname = Array()
		Redim Preserve arrLastKname(lngDispCnt)       
		arrFirstKName = Array()
		Redim Preserve arrFirstKName(lngDispCnt)       
		arrAge = Array()
		Redim Preserve arrAge(lngDispCnt)       
		arrGender = Array()
		Redim Preserve arrGender(lngDispCnt)       
		arrRsvNo = Array()
		Redim Preserve arrRsvNo(lngDispCnt)       
		arrDmdDate = Array()
		Redim Preserve arrDmdDate(lngDispCnt)       
		arrBillSeq = Array()
		Redim Preserve arrBillSeq(lngDispCnt)       
		arrBranchNo = Array()
		Redim Preserve arrBranchNo(lngDispCnt)
	Else
		'行数変更時、配列の再定義
		If strMode = "change" Then
			Redim Preserve arrPerId(lngDispCnt)       
			Redim Preserve arrLastName(lngDispCnt)       
			Redim Preserve arrFirstName(lngDispCnt)       
			Redim Preserve arrLastKname(lngDispCnt)       
			Redim Preserve arrFirstKName(lngDispCnt)       
			Redim Preserve arrAge(lngDispCnt)       
			Redim Preserve arrGender(lngDispCnt)       
			Redim Preserve arrRsvNo(lngDispCnt)       
			Redim Preserve arrDmdDate(lngDispCnt)       
			Redim Preserve arrBillSeq(lngDispCnt)       
			Redim Preserve arrBranchNo(lngDispCnt)
		End If
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
	'受診情報が存在しない場合はエラーとする
	If lngPerBillCount < 0 Then
		Err.Raise 1000, , "個人請求管理情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'初期表示時　デフォルトで当該予約番号の未入金の請求書を表示する
	If strMode = "init" Then
		j = 0
		lngBillCnt = 0
		For i = 0 To lngPerBillCount-1
			'未入金？
			If IsNull(vntPaymentDate(i)) = True And vntDelflg(i) <> 1 Then
				arrPerId(j) = strPerId
				arrLastName(j) = strLastName
				arrFirstName(j) = strFirstName
				arrLastKname(j) = strLastKName
				arrFirstKName(j) = strFirstKName
				arrAge(j) = strAge
				arrGender(j) = strGender
				arrRsvNo(j) = lngRsvNo
				arrDmdDate(j) = vntDmdDate(i)
				arrBillSeq(j) = vntBillSeq(i)
				arrBranchNo(j) = vntBranchNo(i)
				j = j + 1
				lngBillCnt = lngBillCnt + 1
			End If
		Next
	End If

	'同伴者請求書セット要求時
	If strMode = "friends" Then
		Redim Preserve vntInCslDate(0)
		Redim Preserve vntInRsvNo(0)
		vntInCslDate(0) = strCslDate
		vntInRsvNo(0) = lngRsvNo
		'同伴者請求書取得
		lngFriendsCnt = objPerbill.SelectFriendsPerBill ( _
													vntInCslDate,  vntInRsvNo, _
													vntFDmdDate,   vntFBillSeq,     vntFBranchNo, _
													vntFPerID,     vntFLastName,    vntFFirstName, _
													vntFLastKName, vntFFirstKName, _
													vntFRsvNo,     vntFAge,         vntFGender )

		For i = 0 To lngFriendsCnt - 1
			lngSetFlg = 0
			For j = 0 To lngBillCnt - 1
				'既にセットされているか？
				If arrDmdDate(j) = vntFDmdDate(i) And _
                   arrBillSeq(j) = vntFBillSeq(i) And _
                   arrBranchNo(j) = vntFBranchNo(i)      Then
					lngSetFlg = 1
					Exit For
				End If
			Next
			'セットされていなければ
			If lngSetFlg = 0 Then
				'行数が足りなければ増やす
				If CLng(lngDispCnt) <= CLng(lngBillCnt) Then
					lngDispCnt = lngDispCnt + INCREASE_COUNT
		        	Redim Preserve arrPerId(lngDispCnt)       
		        	Redim Preserve arrLastName(lngDispCnt)      
		        	Redim Preserve arrFirstName(lngDispCnt)     
		        	Redim Preserve arrLastKname(lngDispCnt)     
		        	Redim Preserve arrFirstKName(lngDispCnt)    
		        	Redim Preserve arrAge(lngDispCnt)       
		        	Redim Preserve arrGender(lngDispCnt)       
		        	Redim Preserve arrRsvNo(lngDispCnt)       
		        	Redim Preserve arrDmdDate(lngDispCnt)       
		        	Redim Preserve arrBillSeq(lngDispCnt)       
		        	Redim Preserve arrBranchNo(lngDispCnt)
		        End If
				arrPerId(lngBillCnt)      = vntFPerID(i)
			    arrLastName(lngBillCnt)   = vntFLastName(i)
			    arrFirstName(lngBillCnt)  = vntFFirstName(i)
			    arrLastKname(lngBillCnt)  = vntFLastKName(i)
			    arrFirstKName(lngBillCnt) = vntFFirstKName(i)
			    arrAge(lngBillCnt)        = vntFAge(i)
			    arrGender(lngBillCnt)     = vntFGender(i)
			    arrRsvNo(lngBillCnt)      = vntFRsvNo(i)
			    arrDmdDate(lngBillCnt)    = vntFDmdDate(i)
			    arrBillSeq(lngBillCnt)    = vntFBillSeq(i)
			    arrBranchNo(lngBillCnt)   = vntFBranchNo(i)
				lngBillCnt = lngBillCnt + 1
			End If
		Next

	End If
	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 指定可能請求書枚数の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateDispCntInfo()

	Redim Preserve strArrDispCnt(9)
	Redim Preserve strArrDispCntName(9)

	strArrDispCnt(0) = 5:strArrDispCntName(0) = "5枚"
	strArrDispCnt(1) = 10:strArrDispCntName(1) = "10枚"
	strArrDispCnt(2) = 15:strArrDispCntName(2) = "15枚"
	strArrDispCnt(3) = 20:strArrDispCntName(3) = "20枚"
	strArrDispCnt(4) = 25:strArrDispCntName(4) = "25枚"
	strArrDispCnt(5) = 30:strArrDispCntName(5) = "30枚"
	strArrDispCnt(6) = 35:strArrDispCntName(6) = "35枚"
	strArrDispCnt(7) = 40:strArrDispCntName(7) = "40枚"
	strArrDispCnt(8) = 45:strArrDispCntName(8) = "45枚"
	strArrDispCnt(9) = 50:strArrDispCntName(9) = "50枚"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 性別名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateGenderInfo()

	Redim Preserve strArrGenderName(1)

	strArrGenderName(0) = "男性"
	strArrGenderName(1) = "女性"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>まとめて入金</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!---
// 請求書情報のクリア
function clearPerBillInfo(index, PerId, LastName, FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo ) {

	// 個人ＩＤのクリア
	if ( PerId ) {
		PerId.value = '';
	}
	// 個人ＩＤエレメントのクリア
	if ( document.getElementById( 'billPerId' + index ) ) {
		document.getElementById( 'billPerId' + index ).innerHTML = '';
	}


	// 氏名のクリア
	if ( LastName ) {
		LastName.value = '';
	}
	if ( FirstName ) {
		FirstName.value = '';
	}
	if ( LastKName ) {
		LastKName.value = '';
	}
	if ( FirstKName ) {
		FirstKName.value = '';
	}
	// 氏名エレメントのクリア
	if ( document.getElementById( 'billPerName' + index ) ) {
		document.getElementById( 'billPerName' + index ).innerHTML = '';
	}


	// 年齢のクリア
	if ( Age ) {
		Age.value = '';
	}
	// 年齢エレメントのクリア
	if ( document.getElementById( 'billAge' + index ) ) {
		document.getElementById( 'billAge' + index ).innerHTML = '';
	}


	// 性別のクリア
	if ( Gender ) {
		Gender.value = '';
	}
	// 性別エレメントのクリア
	if ( document.getElementById( 'billGender' + index ) ) {
		document.getElementById( 'billGender' + index ).innerHTML = '';
	}


	// 予約番号のクリア
	if ( RsvNo ) {
		RsvNo.value = '';
	}
	// 予約番号エレメントのクリア
	if ( document.getElementById( 'billRsvNo' + index ) ) {
		document.getElementById( 'billRsvNo' + index ).innerHTML = '';
	}


	// 請求書Ｎｏのクリア
	if ( DmdDate ) {
		DmdDate.value = '';
	}
	if ( BillSeq ) {
		BillSeq.value = '';
	}
	if ( BranchNo ) {
		BranchNo.value = '';
	}
	// 請求書Ｎｏエレメントのクリア
	if ( document.getElementById( 'billNo' + index ) ) {
		document.getElementById( 'billNo' + index ).innerHTML = '';
	}


}
//-->
<!--
// 次画面処理
function goNextPage() {


	// 自画面を送信
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

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

var winGuidePerBill;		// ウィンドウハンドル
var winPerBillIncome;		// ウィンドウハンドル
var varPerBill_PerId;		// 個人ＩＤ
var varPerBill_LastName;	// 姓
var varPerBill_FirstName;	// 名
var varPerBill_LastKName;	// カナ姓
var varPerBill_FirstKName;	// カナ名
var varPerBill_Age;		// 年齢
var varPerBill_Gender;		// 性別
var varPerBill_RsvNo;		// 予約番号
var varPerBill_DmdDate;		// 請求日
var varPerBill_BillSeq;		// 請求書Ｓｅｑ
var varPerBill_BranchNo;	// 請求書枝番

//個人請求書の検索画面呼び出し
function callgdePerBill(index,keyDmdDate, Perid, LastName,FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo) {

	var objForm = document.entryForm;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか


	// ガイドとの連結用変数にエレメントを設定
	varPerBill_PerId = Perid;
	varPerBill_LastName = LastName;
	varPerBill_FirstName = FirstName;
	varPerBill_LastKName = LastKName;
	varPerBill_FirstKName = FirstKName;
	varPerBill_Age = Age;
	varPerBill_Gender = Gender;
	varPerBill_RsvNo = RsvNo;
	varPerBill_DmdDate = DmdDate;
	varPerBill_BillSeq = BillSeq;
	varPerBill_BranchNo = BranchNo;

	// すでにガイドが開かれているかチェック
	if ( winGuidePerBill != null ) {
		if ( !winGuidePerBill.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/perbill/gdePerBill.asp';
	url = url + '?dmddate=' + '<%= strCslDate %>';
	url = url + '&paymentflg=1';
	url = url + '&deldsp=1';
	url = url + '&lineno=' + index;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuidePerBill.focus();
		winGuidePerBill.location.replace( url );
	} else {
// ## 2003.12.20 Mod by T.Takagi@FSIT
//		winGuidePerBill = window.open( url, '', 'width=1000,height=370,status=yes,directories=no,menubar=yes,resizable=yes,toolbar=no,scrollbars=yes');
		winGuidePerBill = window.open( url, '', 'width=800,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}

	if (document.entryForm.billcnt.value < index+1){
		document.entryForm.billcnt.value = index+1
	}

	document.entryForm.mode.value = 'guide';

}

// 請求書情報編集用関数
function setDmdDataInfo(lineno, PerId, LastName, FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo ) {

	var varWorkSeq;

	// 個人ＩＤの編集
	if ( varPerBill_PerId ) {
		varPerBill_PerId.value = PerId;
	}
	if ( document.getElementById( 'billPerId' + lineno ) ) {
		document.getElementById( 'billPerId' + lineno ).innerHTML = PerId;
	}

	// 氏名の編集
	if ( varPerBill_LastName ) {
		varPerBill_LastName.value = LastName;
	}
	if ( varPerBill_FirstName ) {
		varPerBill_FirstName.value = FirstName;
	}
	if ( varPerBill_LastKName ) {
		varPerBill_LastKName.value = LastKName;
	}
	if ( varPerBill_FirstKName ) {
		varPerBill_FirstKName.value = FirstKName;
	}
	if ( document.getElementById( 'billPerName' + lineno ) ) {
		document.getElementById( 'billPerName' + lineno ).innerHTML = LastName + ' ' + FirstName + '（<FONT SIZE="-1">' + LastKName + '　' + FirstKName + '）';	
	}

	// 年齢の編集
	if ( varPerBill_Age ) {
		varPerBill_Age.value = Age;
	}
	if ( document.getElementById( 'billAge' + lineno ) ) {
		document.getElementById( 'billAge' + lineno ).innerHTML = Age + '歳';	
	}

	// 性別の編集
	if ( varPerBill_Gender ) {
		varPerBill_Gender.value = Gender;
	}
	if ( document.getElementById( 'billGender' + lineno ) ) {
		if (Gender == 1) {
			document.getElementById( 'billGender' + lineno ).innerHTML = '男性';	
		} else if (Gender == 2) {
			document.getElementById( 'billGender' + lineno ).innerHTML = '女性';
		}	
	}

	// 予約番号の編集
	if ( varPerBill_RsvNo ) {
		varPerBill_RsvNo.value = RsvNo;
	}
	if ( document.getElementById( 'billRsvNo' + lineno ) ) {
		document.getElementById( 'billRsvNo' + lineno ).innerHTML = RsvNo;
	}

	// 請求書Ｎｏの編集
	if ( varPerBill_DmdDate ) {
		varPerBill_DmdDate.value = DmdDate;
	}
	if ( varPerBill_BillSeq ) {
		varPerBill_BillSeq.value = BillSeq;
	}
	if ( varPerBill_BranchNo ) {
		varPerBill_BranchNo.value = BranchNo;
	}
	if ( document.getElementById( 'billNo' + lineno ) ) {
		varRsltDate = DmdDate.split( "/" );
		varWorkSeq = '';
		for ( i = 0; i < 5 - BillSeq.length; i++ ){
			varWorkSeq += '0'
		}
		document.getElementById( 'billNo' + lineno ).innerHTML = varRsltDate[0] + varRsltDate[1] + varRsltDate[2] + varWorkSeq + BillSeq + BranchNo;	
	}

	// 入金画面から戻ることがあるためデータをhiddenに入れたいので追加 2003.12.18
	document.entryForm.submit();
}

//統合確認画面表示
function callperBillIncome(dispCnt) {

	var url;							// URL文字列
	var objForm = document.entryForm;	// 自画面のフォームエレメント
	var opened = false;					// 画面がすでに開かれているか
	var count = 0;						//要求個数

	url = '/WebHains/contents/perbill/perBillIncome.asp';
	url = url + '?rsvno=' + '<%= lngRsvNo %>';

	//同一請求書Noチェック
	for ( i = 0; i < dispCnt; i++ ){
		for ( j = i+1; j < dispCnt; j++ ){
			if ((objForm.gdeDmdDate[i].value == objForm.gdeDmdDate[j].value) &&
				(objForm.gdeBillSeq[i].value == objForm.gdeBillSeq[j].value) &&
				(objForm.gdeBranchNo[i].value == objForm.gdeBranchNo[j].value) ){
				objForm.gdeDmdDate[j].value = '';
				objForm.gdeBillSeq[j].value = '';
				objForm.gdeBranchNo[j].value = '';
			}
		}
	}

	url += '&reqDmdDate=';
	for ( i = 0; i < dispCnt; i++ ){
		if ( objForm.gdeDmdDate[i].value == '' ) continue;
		url = url + objForm.gdeDmdDate[i].value + ',';
		//リクエスト個数カウントする。
		count ++;
	}

	url += '&reqBillSeq=';
	for ( i = 0; i < dispCnt; i++ ){
		if ( objForm.gdeDmdDate[i].value == '' ) continue;
		url = url + objForm.gdeBillSeq[i].value + ',';
	}

	url += '&reqBranchNo=';
	for ( i = 0; i < dispCnt; i++ ){
		if ( objForm.gdeDmdDate[i].value == '' ) continue;
		url = url + objForm.gdeBranchNo[i].value + ',';
	}

	if (count > 0) {

		// すでに開かれているかチェック
		if ( winPerBillIncome != null ) {
			if ( !winPerBillIncome.closed ) {
				opened = true;
			}
		}

		// 戻る機能のためにreplaceをhrefに変更　2003.12.18
		location.href(url);

		// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
//		if ( opened ) {
//			winPerBillIncome.focus();
//			winPerBillIncome.location.replace( url );
//		} else {
//			winPerBillIncome = window.open( url, '', 'width=800,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
//		}

	
//		document.entryForm.mode.value = 'kakutei';
//		document.entryForm.submit();

	} else {
		alert( '請求書が選択されていません');
		return;
	}

}

//請求書行の表示しなおし
function changeRow() {

	document.entryForm.mode.value = 'change';
	document.entryForm.submit();
}

// 同伴者請求書セット要求
function friendsDmdSet() {
	document.entryForm.mode.value = 'friends';
	document.entryForm.submit();
}

function windowClose() {

	// 個人請求書の検索ウインドウを閉じる
	if ( winGuidePerBill != null ) {
		if ( !winGuidePerBill.closed ) {
			winGuidePerBill.close();
		}
	}

	winGuidePerBill = null;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><SPAN CLASS="demand">■</SPAN><B>まとめて入金</B></TD>
	</TR>
</TABLE>
	<!-- 引数情報 -->
	<INPUT TYPE="hidden" NAME="act"    VALUE="save">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="perid" VALUE="<%= strPerId %>">
	<INPUT TYPE="hidden" NAME="csldate" VALUE="<%= strCslDate %>">
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">
	<INPUT TYPE="hidden" NAME="pricetotal"  VALUE="<%= lngPriceTotal %>"> 
	<INPUT TYPE="hidden" NAME="taxtotal"  VALUE="<%= lngTaxTotal %>"> 
	<INPUT TYPE="hidden" NAME="billcnt"  VALUE="<%= lngBillCnt %>"> 
<%	
	For i = 0 To lngDispCnt - 1
%>
		<INPUT TYPE="hidden" NAME="gdePerId"  VALUE="<%= arrPerId(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeLastName"  VALUE="<%= arrLastName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeFirstName"  VALUE="<%= arrFirstName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeLastKName"  VALUE="<%= arrLastKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeFirstKName"  VALUE="<%= arrFirstKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeAge"  VALUE="<%= arrAge(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeGender"  VALUE="<%= arrGender(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeRsvNo"  VALUE="<%= arrRsvNo(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeDmdDate"  VALUE="<%= arrDmdDate(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeBillSeq"  VALUE="<%= arrBillSeq(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeBranchNo"  VALUE="<%= arrBranchNo(i) %>"> 
<%
	Next
%>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
	<TR BGCOLOR="#eeeeee">
		<TD NOWRAP>受診日</TD>
		<TD NOWRAP>受診コース</TD>
		<TD NOWRAP>予約番号</TD>
		<TD NOWRAP>個人ＩＤ</TD>
		<TD NOWRAP>受診者名</TD>
	</TR>
	<TR height="15">
		<TD height="15"><%= strCslDate %></TD>
		<TD height="15"><%= strCsName %></TD>
		<TD height="15"><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= lngRsvNo %>" TARGET="_blank"><%= lngRsvNo %></A></TD>
		<TD height="15"><%= strPerId %></TD>
		<TD height="15"><B><%= strLastName & " " & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP><SPAN STYLE="color:#cc9999">●</SPAN>まとめて入金する請求書を選択してください。</TD>
		<TD NOWRAP><A HREF="javascript:friendsDmdSet()">上記受診者のお連れ様請求書をセット</A></TD>
		<TD NOWRAP><A HREF="Javascript:callperBillIncome(<%= lngDispCnt %>)"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この条件で確定"></A></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
	<TR>
		<TD WIDTH="10"></TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>個人ＩＤ</TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>氏名</TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>年齢</TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>性別</TD>
		<TD WIDTH="10"></TD>
		<TD NOWRAP>予約番号</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>請求書No.</TD>
	</TR>
	<TR>
		<TD WIDTH="10"></TD>
		<TD WIDTH="10"></TD>
		<TD COLSPAN="11" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1" BORDER="0"></TD>
	</TR>

<%	
	For i = 0 To lngDispCnt - 1
%>
	<TR VALIGN="bottom">

		<TD WIDTH="10"><A HREF="javascript:callgdePerBill(<%= i %>,document.entryForm.dmddate.value,document.entryForm.gdePerId[<%= i %>],document.entryForm.gdeLastName[<%= i %>],document.entryForm.gdeFirstName[<%= i %>],document.entryForm.gdeLastKName[<%= i %>],document.entryForm.gdeFirstKName[<%= i %>],document.entryForm.gdeAge[<%= i %>],document.entryForm.gdeGender[<%= i %>],document.entryForm.gdeRsvNo[<%= i %>],document.entryForm.gdeDmdDate[<%= i %>],document.entryForm.gdeBillSeq[<%= i %>],document.entryForm.gdeBranchNo[<%= i %>])"><IMG SRC="/webHains/images/question.gif" ALT="個人請求書検索を表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>



			
		<TD WIDTH="10"><A HREF="javascript:clearPerBillInfo(<%= i %>,document.entryForm.gdePerId[<%= i %>],document.entryForm.gdeLastName[<%= i %>],document.entryForm.gdeFirstName[<%= i %>],document.entryForm.gdeLastKName[<%= i %>],document.entryForm.gdeFirstKName[<%= i %>],document.entryForm.gdeAge[<%= i %>],document.entryForm.gdeGender[<%= i %>],document.entryForm.gdeRsvNo[<%= i %>],document.entryForm.gdeDmdDate[<%= i %>],document.entryForm.gdeBillSeq[<%= i %>],document.entryForm.gdeBranchNo[<%= i %>])"><IMG SRC="/webHains/images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></TD>
		<TD NOWRAP><SPAN ID="billPerId<%= i %>"><%= arrPerId(i) %></SPAN></TD>
		<TD WIDTH="10"></TD>
<%
		If  arrPerId(i) <> "" Then
%>
			<TD NOWRAP><SPAN ID="billPerName<%= i %>"><%= arrLastName(i) & " " & arrFirstName(i) %></B>（<FONT SIZE="-1"><%= arrLastKname(i) & "　" & arrFirstKName(i) %>）</SPAN></TD>
			<TD WIDTH="10"></TD>
			<TD ALIGN="right" NOWRAP><SPAN ID="billAge<%= i %>"><%= Int(arrAge(i)) %>歳</SPAN></TD>
			<TD WIDTH="10"></TD>
<%
			arrGender(i) = IIf( arrGender(i) = "", 0,arrGender(i) )
			If arrGender(i) = 1 Or arrGender(i) = 2 Then
%>
				<TD NOWRAP><SPAN ID="billGender<%= i %>"><%= strArrGenderName(arrGender(i)-1) %></SPAN></TD>
<%
			Else
%>
				<TD NOWRAP><SPAN ID="billGender<%= i %>"></SPAN></TD>
<%
			End If
%>
<%
		Else
%>
			<TD NOWRAP><SPAN ID="billPerName<%= i %>"></SPAN></TD>
			<TD WIDTH="10"></TD>
			<TD ALIGN="right" NOWRAP><SPAN ID="billAge<%= i %>"></SPAN></TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP><SPAN ID="billGender<%= i %>"></SPAN></TD>
<%
		End If
%>
		<TD WIDTH="10"></TD>
		<TD NOWRAP><SPAN ID="billRsvNo<%= i %>"><%= arrRsvNo(i) %></SPAN></TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD ALIGN="right" NOWRAP><SPAN ID="billNo<%= i %>"><%= objCommon.FormatString(arrDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(arrBillSeq(i), "00000") %><%= arrBranchNo(i) %></SPAN></TD>
	</TR>
<%
	Next
%>
	<TR VALIGN="bottom">
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD></TD>
		<TD NOWRAP>指定可能請求書を</TD>
		<TD>
			<SELECT NAME="dispCnt">
<%
				'行数選択リストの編集
				i = DEFAULT_ROW
				Do
					'現在の行数以上の行数を選択可能とする
					If i >= lngDispCnt Then
%>
						<OPTION VALUE="<%= i %>" <%= IIf(i = lngDispCnt, "SELECTED", "") %>><%= i %>枚
<%
					End If

					'編集行数が表示行数を超えた場合は処理を終了する
					If i > lngDispCnt Then
						Exit Do
					End If

					i = i + INCREASE_COUNT
				Loop
%>
			</SELECT>
		</TD>
		<TD><A HREF="JavaScript:changeRow()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示" BORDER="0"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
