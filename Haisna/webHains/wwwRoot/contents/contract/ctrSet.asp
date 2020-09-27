<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(検査セットの登録) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editJudClassList.inc"     -->
<!-- #include virtual = "/webHains/includes/editJudList.inc"          -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editRsvFraList.inc"       -->
<!-- #include virtual = "/webHains/includes/editSetClassList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_INSERT          = "INS"	'処理モード(挿入)
Const MODE_UPDATE          = "UPD"	'処理モード(更新)
Const MODE_COPY            = "COPY"	'処理モード(コピー)
Const ACTMODE_SAVE         = "save"	'動作モード(保存)
Const ACTMODE_DELETE       = "del"	'動作モード(削除)

Const LENGTH_OPTCD         = 4		'オプションコードの項目長
Const LENGTH_OPTBRANCHNO   = 2		'オプション枝番の項目長
Const LENGTH_OPTNAME       = 30		'オプション名の項目長
Const LENGTH_OPTSNAME      = 20		'オプション略称の項目長

'データベースアクセス用オブジェクト
Dim objCommon				'共通クラス
Dim objContract				'契約情報アクセス用
Dim objContractControl		'契約情報アクセス用
Dim objFree					'汎用情報アクセス用

'引数値（契約基本情報）
Dim strMode					'処理モード
Dim strActMode				'動作モード
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strCtrPtCd				'契約パターンコード

'引数値（オプション検査基本情報）
Dim strOptCd				'オプションコード
Dim strOptBranchNo			'オプション枝番
Dim strOptName				'オプション名
Dim strOptSName				'オプション略称
Dim strSubCsCd				'（サブ）コースコード
Dim strSetColor				'セットカラー
Dim strSetClassCd			'セット分類コード
Dim strRsvFraCd				'予約枠コード

'引数値（オプション検査対象条件）
Dim strCslDivCd				'受診区分コード
Dim lngGender				'受診可能性別
Dim strAge					'受診対象年齢
Dim strLastRefMonth			'前回値参照用月数
Dim strLastRefCsCd			'前回値参照用コースコード
Dim lngAddCondition			'追加条件
Dim strHideRsvFra			'予約枠画面非表示
Dim strHideRsv				'予約画面非表示
Dim strHideRpt				'受付画面非表示
Dim strHideQuestion			'問診画面非表示
Dim strExceptLimit			'限度額設定除外

'引数値（請求情報）
Dim strApDiv				'適用元区分
Dim strSeq					'SEQ
Dim strBdnOrgCd1			'団体コード1
Dim strBdnOrgCd2			'団体コード2
Dim strArrOrgName			'団体名称
Dim strPrice				'負担金額
Dim strTax					'消費税
Dim strCtrOrgDiv			'(契約パターン負担金額管理テーブル上の)団体種別
Dim strBillPrintName		'請求書出力名
Dim strBillPrintEName		'請求書英語出力名
Dim lngCount				'負担情報数

'引数値（受診項目情報）
Dim strGrpCd				'グループコードの配列
Dim strGrpName				'グループコードの配列
Dim strItemCd				'依頼項目コードの配列
Dim strRequestName			'依頼項目名の配列

'契約情報
Dim strOrgName				'漢字名称
Dim strCsCd					'コースコード
Dim strCsName				'コース名
Dim dtmStrDate				'契約開始日
Dim dtmEndDate				'契約終了日

'契約パターンオプション管理情報読み込み／更新用
Dim strStrAge				'受診対象開始年齢
Dim strEndAge				'受診対象終了年齢

'汎用情報
Dim strFreeCd				'汎用コード
Dim strFreeDate				'汎用日付
Dim strFreeField1			'フィールド１
Dim strFreeField2			'フィールド２

Dim strTaxRate				'消費税率

Dim strMode2				'処理モード(COM呼び出し用)
Dim strHTML					'HTML文字列
Dim strURL					'ジャンプ先のURL
Dim strMessage				'エラーメッセージ
Dim Ret						'関数戻り値
Dim Ret2					'関数戻り値
Dim i, j, k					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'引数値の取得（契約基本情報）
strMode     = Request("mode")
strActMode  = Request("actMode")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strCtrPtCd  = Request("ctrPtCd")

'引数値の取得（オプション検査情報）
strOptCd         = Request("optCd")
strOptBranchNo   = Request("optBranchNo")
strOptName       = Request("optName")
strOptSName      = Request("optSName")
strSubCsCd       = Request("subCsCd")
strSetColor      = Request("setColor")
strSetClassCd    = Request("setClassCd")
strRsvFraCd      = Request("rsvFraCd")
strCslDivCd      = Request("cslDivCd")
lngGender        = CLng("0" & Request("gender"))
strAge           = ConvIStringToArray(Request("age"))
strLastRefMonth  = Request("lastRefMonth")
strLastRefCsCd   = Request("lastRefCsCd")
lngAddCondition  = CLng("0" & Request("addCondition"))
strHideRsvFra    = Request("hideRsvFra")
strHideRsv       = Request("hideRsv")
strHideRpt       = Request("hideRpt")
strHideQuestion  = Request("hideQuestion")
strExceptLimit   = Request("exceptLimit")

'引数値の取得（請求情報）
strApDiv          = ConvIStringToArray(Request("apDiv"))
strSeq            = ConvIStringToArray(Request("seq"))
strBdnOrgCd1      = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2      = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName     = ConvIStringToArray(Request("orgName"))
strPrice          = ConvIStringToArray(Request("price"))
strTax            = ConvIStringToArray(Request("tax"))
strCtrOrgDiv      = ConvIStringToArray(Request("ctrOrgDiv"))
strPrice          = ConvIStringToArray(Request("price"))
strBillPrintName  = ConvIStringToArray(Request("billPrintName"))
strBillPrintEName = ConvIStringToArray(Request("billPrintEName"))

'引数値の取得（受診項目情報）
strGrpCd       = Split(Request("grpCd"),       ",")
strGrpName     = Split(Request("grpName"),     ",")
strItemCd      = Split(Request("itemCd"),      ",")
strRequestName = Split(Request("requestName"), ",")

'セットカラーのデフォルト値設定
If strSetColor = "" Then
	strSetColor = "000000"
End If

'チェック・更新・読み込み処理の制御
Do
	'動作モードごとの制御
	Select Case strActMode

		'削除ボタン押下時
		Case ACTMODE_DELETE

			'指定契約パターン、オプションコードのオプション検査情報を削除
			Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
			Ret = objContractControl.DeleteOption(strOrgCd1, strOrgCd2, strCtrPtCd, strOptCd, strOptBranchNo)
			Set objContractControl = Nothing

			Select Case Ret
				Case 0
				Case 1, 2
					strMessage = Array("このセットを参照している受診情報が存在します。削除できません。")
					Exit Do
				Case 3
					strMessage = Array("このwebオプション検査は削除できません。")
					Exit Do
				Case Else
					Exit Do
			End Select

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

		'保存ボタン押下時
		Case ACTMODE_SAVE

			'入力チェック
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If

			'受診対象年齢から受診対象開始・終了年齢配列への変換
			Call ConvAgeArray(strAge, strStrAge, strEndAge)

			'COM呼び出し用の処理モード設定
			Select Case strMode
				Case MODE_INSERT, MODE_COPY
					strMode2 = MODE_INSERT
				Case MODE_UPDATE
					strMode2 = MODE_UPDATE
			End Select

			'追加オプション書き込み
			Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
			Ret = objContractControl.SetAddOption(strMode2,          _
												  strOrgCd1,         _
												  strOrgCd2,         _
												  strCtrPtCd,        _
												  strOptCd,          _
												  strOptBranchNo,    _
												  strOptName,        _
												  strOptSName,       _
												  strSubCsCd,        _
												  strSetColor,       _
												  strSetClassCd,     _
												  strRsvFraCd,       _
												  strCslDivCd,       _
												  lngGender,         _
												  strLastRefMonth,   _
												  strLastRefCsCd,    _
												  lngAddCondition,   _
												  strHideRsvFra,     _
												  strHideRsv,        _
												  strHideRpt,        _
												  strHideQuestion,   _
												  strExceptLimit,    _
												  strStrAge,         _
												  strEndAge,         _
												  strSeq,            _
												  strBdnOrgCd1,      _
												  strBdnOrgCd2,      _
												  strPrice,          _
												  strTax,            _
												  strBillPrintName,  _
												  strBillPrintEName, _
												  strCtrOrgDiv,      _
												  strGrpCd,          _
												  strItemCd)

			Set objContractControl = Nothing

			Select Case Ret
				Case 0
				Case 1
					strMessage = Array("この契約情報の負担元情報は変更されています。更新できません。")
					Exit Do
				Case 2
					strMessage = Array("調整金額が設定されてある負担元の負担金額には必ず値を入力する必要があります。")
					Exit Do
				Case 3
					strMessage = Array("同一セットコード、枝番の検査がすでに存在します。")
					Exit Do
				Case Else
					Exit Do
			End Select

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

	End Select

	'更新モードまたはコピーモードの場合
	If strMode = MODE_UPDATE Or strMode = MODE_COPY Then

		'契約パターンオプション管理情報の読み込み
		If objContract.SelectCtrPtOpt( _
						   strCtrPtCd,      strOptCd,        strOptBranchNo, _
						   strOptName,      strOptSName,     strSubCsCd,     _
						   strSetClassCd,   strCslDivCd,     lngGender,      _
						   strLastRefMonth, strLastRefCsCd,  strExceptLimit, _
						   lngAddCondition, strHideRsvFra,   strHideRsv,     _
						   strHideRpt,      strHideQuestion, strRsvFraCd, _
						   strSetColor) = False Then
			Err.Raise 1000, ,"セット検査情報が存在しません。"
		End If

		'契約パターンオプション年齢条件情報の読み込み
		objContract.SelectCtrPtOptAge strCtrPtCd, strOptCd, strOptBranchNo, strStrAge, strEndAge

		'受診対象開始・終了年齢から受診対象年齢配列への変換
		Call RevConvAgeArray(strStrAge, strEndAge, strAge)

		'契約パターングループ情報の読み込み
		objContract.SelectCtrPtGrp strCtrPtCd, strOptCd, strOptBranchNo, strGrpCd, strGrpName

		'契約パターン検査項目情報の読み込み
		objContract.SelectCtrPtItem strCtrPtCd, strOptCd, strOptBranchNo, strItemCd, strRequestName

		'契約パターン負担金額情報の読み込み
		lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, strOptCd, strOptBranchNo, strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, strBillPrintName, strBillPrintEName, , , , , , strCtrOrgDiv)
		If lngCount <= 0 Then
			Err.Raise 1000, ,"契約情報が存在しません。"
		End If

		'コピーモードの場合はオプションコード、枝番をクリアする
		If strMode = MODE_COPY Then
			strOptCd = ""
			strOptBranchNo = ""
		End If

		Exit Do
	End If

	'新規モードの場合

	'すべての年齢をチェック対象とさせるための初期値を作成
	strStrAge = Array("0")
	strEndAge = Array("999")
	Call RevConvAgeArray(strStrAge, strEndAge, strAge)

	'契約パターン負担金額情報の読み込み
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, strBillPrintName, strBillPrintEName, , , , , , strCtrOrgDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If

	Exit Do
Loop

'契約情報の読み込み
Ret2 = objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate)

'以降は使用しないのでオブジェクトを解放
Set objContract = Nothing

If Ret2 = False Then
	Err.Raise 1000, ,"契約情報が存在しません。"
End If

'税率の取得
Do

	'汎用テーブルから税率を読み込む
	Set objFree = Server.CreateObject("HainsFree.Free")
	Ret = objFree.SelectFree(0, "TAX", , , strFreeDate, strFreeField1, strFreeField2)
	Set objFree = Nothing

	If Ret <= 0 Then
		Exit Do
	End If

	'汎用日付未設定時は計算しない
	If Not IsDate(strFreeDate) Then
		Exit Do
	End If
	
	'汎用日付と契約開始日との関係よりいずれの税率を使用するかを判定
	strTaxRate = IIf(dtmStrDate >= CDate(strFreeDate), strFreeField2, strFreeField1)

	Exit Do
Loop

Set objFree = Nothing

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 : エラーメッセージの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス

	Dim strArrMessage	'エラーメッセージの配列
	Dim strMessage		'エラーメッセージ
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'オプションコードチェック
	Do

		'半角文字チェック
		strMessage = objCommon.CheckNarrowValue("セットコード", strOptCd, LENGTH_OPTCD, CHECK_NECESSARY)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit Do
		End If

		'カンマは指定できない
		If InStr(strOptCd, ",") > 0 Then
			objCommon.AppendArray strArrMessage, "セットコードにカンマは指定できません。"
		End If

		Exit Do
	Loop

	'オプション枝番チェック
	objCommon.AppendArray strArrMessage, objCommon.CheckNumeric("セット枝番", strOptBranchNo, LENGTH_OPTBRANCHNO, CHECK_NECESSARY)

	'オプション名チェック
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("セット名", strOptName, LENGTH_OPTNAME, CHECK_NECESSARY)

	'オプション略称チェック
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("セット略称", strOptSName, LENGTH_OPTSNAME)

	'前回値条件チェック
	Do

		'何も入力されていない場合
		If strLastRefMonth & strLastRefCsCd = "" Then
			Exit Do
		End If

		'両方とも入力されている場合
		If strLastRefMonth <> "" And strLastRefCsCd <> "" Then

			'前回値参照用月数チェック
			strMessage = objCommon.CheckNumeric("月数", strLastRefMonth, 2)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage
				Exit Do
			End If

			'正の整数かをチェック
			If CLng(strLastRefMonth) < 1 Then
				objCommon.AppendArray strArrMessage, "月数は１以上の値を設定してください。"
				Exit Do
			End If

			Exit Do
		End If

		'上記以外はエラー
		objCommon.AppendArray strArrMessage, "前回値の条件指定が不完全です。"
		Exit Do
	Loop

	'負担金額チェック
	For i = 0 To UBound(strPrice)
		strMessage = objCommon.CheckNumericWithSign("負担金額", strPrice(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'消費税チェック
	For i = 0 To UBound(strTax)
		strMessage = objCommon.CheckNumericWithSign("消費税", strTax(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'請求書出力名チェック
	For i = 0 To UBound(strBillPrintName)
		strMessage = objCommon.CheckWideValue("請求書・領収書出力名", strBillPrintName(i), LENGTH_OPTNAME)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'請求書英語出力名チェック
	For i = 0 To UBound(strBillPrintEName)
		strMessage = objCommon.CheckNarrowValue("請求書・領収書出力名（英語）", strBillPrintEName(i), LENGTH_OPTNAME)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'チェック結果を返す
	CheckValue = strArrMessage

	Set objCommon = Nothing

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診対象年齢から受診対象開始・終了年齢配列への変換
'
' 引数　　 : (In)     strAge     受診対象年齢
' 　　　　   (Out)    strStrAge  受診対象開始年齢
' 　　　　   (Out)    strEndAge  受診対象終了年齢
'
' 戻り値　 :
'
' 備考　　 : 受診対象年齢には必ず、
' 　　　　   ①整数値が格納されていること
' 　　　　   ②昇順で値が格納されていること
' 　　　　   を前提とする
'
'-------------------------------------------------------------------------------
Sub ConvAgeArray(strAge, strStrAge, strEndAge)

	Dim lngCount		'配列の要素数
	Dim strLastAge		'直前に検索した年齢の値
	Dim blnAdd			'新要素追加の要否
	Dim i				'インデックス

	'初期処理
	strStrAge = Empty
	strEndAge = Empty

	'引数未指定時は何もしない
	If IsEmpty(strAge) Then
		Exit Sub
	End If

	'受診対象開始・終了年齢の配列を作成
	strStrAge = Array()
	strEndAge = Array()

	strLastAge = ""
	lngCount = 0

	'受診対象年齢の配列を検索
	For i = 0 To UBound(strAge)

		blnAdd = False

		'最初は必ず新たな要素を作成
		If strLastAge = "" Then
			blnAdd = True
		End If

		'直前に検索した年齢値と連続していない場合は新たな要素を作成
		If strLastAge <> "" Then
			If CLng(strAge(i)) - CLng(strLastAge) > 1 Then
				blnAdd = True
			End If
		End If

		'新要素作成処理
		If blnAdd Then
			ReDim Preserve strStrAge(lngCount)
			ReDim Preserve strEndAge(lngCount)
			strStrAge(lngCount) = strAge(i)
			strEndAge(lngCount) = strAge(i)
			lngCount = lngCount + 1
		End If

		'新要素を作成しない場合は最終要素の受診対象終了年齢を更新する
		If Not blnAdd Then
			strEndAge(lngCount - 1) = strAge(i)
		End If

		'現在の受診対象年齢を退避
		strLastAge = strAge(i)

	Next

	'最終要素の受診対象終了年齢が100歳の場合は100歳以上が対象となるよう、値を置換
	If CLng(strEndAge(lngCount - 1)) >= 100 Then
		strEndAge(lngCount - 1) = AGE_MAXVALUE
	End If

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診対象年齢から受診対象開始・終了年齢配列への変換
'
' 引数　　 : (In)    strStrAge  受診対象開始年齢
' 　　　　   (In)    strEndAge  受診対象終了年齢
' 　　　　   (Out)   strAge     受診対象年齢
'
' 戻り値　 :
'
' 備考　　 : 受診対象開始・終了年齢には必ず、
' 　　　　   ①整数値が格納されていること
' 　　　　   ②昇順で値が格納されていること
' 　　　　   を前提とする
'
'-------------------------------------------------------------------------------
Sub RevConvAgeArray(strStrAge, strEndAge, strAge)

	Dim lngCount	'配列の要素数

	'初期処理
	strAge = Empty

	'引数未指定時は何もしない
	If IsEmpty(strStrAge) Or IsEmpty(strEndAge) Then
		Exit Sub
	End If

	'受診対象年齢の配列を作成
	strAge = Array()

	'受診対象開始・終了年齢の配列を検索
	For i = 0 To UBound(strStrAge)

		'開始・終了範囲の全年齢値を追加
		For j = CLng(strStrAge(i)) To CLng(strEndAge(i))

			'年齢が100歳を超える場合は打ち切り
			If j > 100 Then
				Exit For
			End If

			'配列の新要素として追加
			ReDim Preserve strAge(lngCount)
			strAge(lngCount) = CStr(j)
			lngCount = lngCount + 1
		Next

	Next

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診対象年齢の検索
'
' 引数　　 : (In)     strAge     受診対象年齢
' 　　　　   (In)     lngAge     検索年齢
'
' 戻り値　 : True   受診対象年齢の配列に検索年齢が存在
' 　　　　   False  受診対象年齢の配列に検索年齢が存在しない
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckDateCheckBox(strAge, lngAge)

	Dim i	'インデックス

	CheckDateCheckBox = False

	'引数未設定時は何もしない
	If IsEmpty(strAge) Then
		Exit Function
	End If

	'受診対象年齢の検索
	For i = 0 To UBound(strAge)
		If CLng(strAge(i)) = CInt(lngAge) Then
			CheckDateCheckBox = True
			Exit Function
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
<TITLE>検査セットの登録</TITLE>
<!-- #include virtual = "/webHains/includes/colorGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/price.inc"    -->
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
// 現情報に対する選択内容の追加
function appendItem( dataDiv ) {

	var optList;	// SELECTオブジェクト
	var curOptInf;	// 現オプション情報

	var hit;		// 検索フラグ
	var i;			// インデックス

	optList = document.entryForm.optionItem;

	// 指定項目分類の現オプション情報を取得
	curOptInf = new Array();
	for ( i = 0; i < optList.length; i++ ) {

		// オプション要素の先頭文字で判断
		if ( optList.options[ i ].value.charAt(0) == dataDiv ) {

			// オプション要素の2番目以降の文字をコードとして、表示内容を名称として取得
			curOptInf[curOptInf.length] = new optInf(optList.options[ i ].value.substring(1, optList.options[ i ].value.length), optList.options[ i ].text);

		}

	}

	// ガイド選択項目を検索
	for ( i = 0; i < itmGuide_dataDiv.length; i++ ) {

		// 項目分類が合致しなければ対象外
		if ( itmGuide_dataDiv[ i ] != dataDiv ) {
			continue;
		}

		// 現オプション情報に含まれるか検索し、コードが合致すればフラグ成立
		for ( j = 0, hit = false; j < curOptInf.length; j++ ) {
			if ( curOptInf[j].itemCd == itmGuide_itemCd[ i ] ) {
				hit = true;
				break;
			}
		}

		// ヒットしなかった場合は現オプション情報の末尾に追加
		if ( !hit ) {
			curOptInf[curOptInf.length] = new optInf(itmGuide_itemCd[ i ], itmGuide_itemName[ i ]);
		}

	}

	return curOptInf;
}

// 項目ガイド呼び出し
function callItemGuide( mode, group, item, que, calledFunction ) {

	// ガイドを一旦閉じる
	closeGuideItm();

	itmGuide_mode     = mode;	// 依頼／結果モード　1:依頼、2:結果
	itmGuide_group    = group;	// グループ表示有無　0:表示しない、1:表示する
	itmGuide_item     = item;	// 検査項目表示有無　0:表示しない、1:表示する
	itmGuide_question = que;	// 問診項目表示有無　0:表示しない、1:表示する

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	itmGuide_CalledFunction = calledFunction;

	// 項目ガイド表示
	showGuideItm();

}

// 年齢チェックボックス制御
function checkAge( onOff, strAge, endAge ) {

	var i;	// インデックス

	// 指定年齢範囲のチェックボックス制御
	for ( i = strAge; i <= endAge; i++ ) {
		document.entryForm.age[ i ].checked = ( onOff > 0 );
	}

}

// リストからグループまたは検査項目を削除する(固定見出しは非対象)
function deleteItem() {

	var optList;	// SELECTオブジェクト
	var i;			// インデックス

	optList = document.entryForm.optionItem;

	// リストを後方から検索
	for ( i = optList.length - 1; i >= 0; i-- ) {

		// 選択されてなければスキップ
		if ( !optList.options[ i ].selected ) {
			continue;
		}

		// 固定見出しであれば選択解除
		if ( optList.options[ i ].value.charAt(0) == '' ) {
			optList.options[ i ].selected = false;
			continue;
		}

		// リスト削除
		optList.options[ i ] = null;

	}

}

// オプション検査の削除
function deleteOption() {

    /** submitFormファンクションでまとめてチェックできるように修正 Start 2005.06.18 張 **/
    // 確認メッセージの表示
    //if ( !confirm('この検査セットを削除します。よろしいですか？') ) {
    //    return;
    //}
    /** submitFormファンクションでまとめてチェックできるように修正 End   2005.06.18 張 **/

	// submit処理
	submitForm('<%= ACTMODE_DELETE %>');
}

// 検査項目編集用関数
function editItemInfo( itemCd, suffix, itemName, resultType, itemType ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 検査項目コードの編集
	myForm.perItemCd.value     = itemCd;
	myForm.perSuffix.value     = suffix;
	myForm.perResultType.value = resultType;
	myForm.perItemType.value   = itemType;

	// 検査項目名の編集
	document.getElementById('perItemName').innerHTML = itemName;
}

// リストの編集
function editList() {

	var grpInf;		// グループ情報
	var itemInf;	// 依頼項目情報

	var optList;	// SELECTオブジェクト

	var i			// インデックス

	// 現リストのグループにガイド選択内容を追加
	grpInf = appendItem('G');

	// 現リストの依頼項目にガイド選択内容を追加
	itemInf = appendItem('P');

	optList = document.entryForm.optionItem;

	// オブジェクトの初期化
	while ( optList.length > 0 ) {
		optList.options[0] = null;
	}

	// グループ見出し追加
	optList.options[ optList.length ] = new Option('■検査グループ', '');

	// グループ追加
	for ( i = 0; i < grpInf.length; i++ ) {
		optList.options[ optList.length ] = new Option(grpInf[ i ].itemName, 'G' + grpInf[ i ].itemCd);
	}

	// 依頼項目見出し追加
	optList.options[ optList.length ] = new Option( '■検査項目', '' );

	// 依頼項目追加
	for ( i = 0; i < itemInf.length; i++ ) {
		optList.options[ optList.length ] = new Option( itemInf[ i ].itemName, 'P' + itemInf[ i ].itemCd );
	}

}

// オプション情報クラス
function optInf( itemCd, itemName ) {
	this.itemCd   = itemCd;
	this.itemName = itemName;
}

// 検査項目のセット
function setItemInfo() {

	// 未選択時は何もしない
	if ( itmGuide_itemCd == '' ) {
		return;
	}

	// 選択した項目情報を編集
	editItemInfo( itmGuide_itemCd[ 0 ], itmGuide_suffix[ 0 ], itmGuide_itemName[ 0 ], itmGuide_resultType[ 0 ], itmGuide_itemType[ 0 ] );

}

// 文章検査結果編集用関数
function setStcResultInfo() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 検査結果の編集
	myForm.perResult.value = stcGuide_StcCd;

}

// 定性検査結果編集用関数
function setTeiseiResultInfo() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 検査結果の編集
	myForm.perResult.value = tseGuide_Result;

}

// submit時、オプション検査内容をhiddenデータに格納する
function submitForm( actMode ) {

	var myForm  = document.entryForm;				// 自画面のフォームエレメント
	var optList = document.entryForm.optionItem;	// SELECTオブジェクト

	var grpCd;										// グループコード
	var grpName;									// グループ名
	var itemCd;										// 依頼項目コード
	var requestName;								// 依頼項目名

	var i;											// インデックス

    /** 契約情報の保存・削除処理を行う時ワーニングメッセージを表示して再確認するように修正 Start 2005.06.18 張 **/
    var strMsg;                                     // メッセージ区分（保存・削除)

    if(actMode == "<%=ACTMODE_DELETE%>"){
        strMsg = "この検査セットを削除します。よろしいですか？";
    }else{
        strMsg = "この検査セットが変更されます。よろしいですか？";
    }
    // 確認メッセージの表示
    if ( !confirm(strMsg) ) {
        return;
    }
    /** 契約情報の保存・削除処理を行う時ワーニングメッセージを表示して再確認するように修正 End   2005.06.18 張 **/


	// 各項目の配列を作成
	grpCd       = new Array();
	grpName     = new Array();
	itemCd      = new Array();
	requestName = new Array();

	// 各項目分類の値を該当する配列に追加する
	for ( i = 0; i < optList.length; i++ ) {

		switch( optList.options[ i ].value.charAt( 0 ) ) {

			case 'G':	// グループ

				grpCd[ grpCd.length ]     = optList.options[ i ].value.substring( 1, optList.options[ i ].value.length );
				grpName[ grpName.length ] = optList.options[ i ].text;
				break;

			case 'P':	// 依頼項目
				itemCd[itemCd.length]             = optList.options[ i ].value.substring( 1, optList.options[ i ].value.length );
				requestName[ requestName.length ] = optList.options[ i ].text;

			default:

		}

	}

	// hiddenデータに格納
	myForm.grpCd.value       = grpCd;
	myForm.grpName.value     = grpName;
	myForm.itemCd.value      = itemCd;
	myForm.requestName.value = requestName;

	// submit処理
	myForm.actMode.value = actMode;
	myForm.submit();
}

// サブ画面を閉じる
function closeWindow() {

	// 項目ガイド画面を閉じる
	closeGuideItm();

	// 色選択ガイド画面を閉じる
	if ( winColor != null ) {
		if ( !winColor.closed ) {
			winColor.close();
		}
	}

	winColor = null;

}

// 消費税の計算
function calcTax( taxRate, objPrice, objTax ) {

	for ( ; ; ) {

		// 負担金額未入力であれば計算しない
		if ( objPrice.value == '' ) {
			break;
		}

		// 消費税が入力されていれば計算しない
		if ( objTax.value != '' ) {
			break;
		}

		// 正規表現チェック
		if ( objPrice.value.match('^[+-]?[0-9]+$') == null ) {
			break;
		}

		// 負担金額より消費税を計算する(端数は切り捨て)
		objTax.value = parseInt(parseInt(objPrice.value, 10) * taxRate, 10);

		break;
	}

}

// 計算処理
function calculate( mode ) {

	var objPrice = document.entryForm.price;
	var objTax   = document.entryForm.tax;
	var taxRate  = '<%= strTaxRate %>';

	// 消費税の計算
	for ( ; ; ) {

		if ( mode != 1 ) break;

		// 税率が不正なら計算しない
		if ( taxRate == '' || isNaN(taxRate) ) {
			break;
		}

		taxRate = parseFloat(taxRate);

		// 負担金額テキストが１つしか存在しない場合
		if ( objPrice.length == null ) {
			calcTax( taxRate, objPrice, objTax );
			break;
		}

		// 全負担金額テキストの検索
		for ( var i = 0; i < objPrice.length; i++ ) {
			calcTax( taxRate, objPrice[ i ], objTax[ i ] );
		}

		break;
	}

	calcPrice( objPrice, 'totalPrice' );
	calcPrice( objTax,   'totalTax'   );

}

// 色選択ガイド画面を表示
function showGuideColor( elemName, colorElemName ) {

	colorGuide_showGuideColor( document.entryForm.elements[elemName], colorElemName );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:calculate(0)" ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode"     VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="grpCd"       VALUE="">
	<INPUT TYPE="hidden" NAME="grpName"     VALUE="">
	<INPUT TYPE="hidden" NAME="itemCd"      VALUE="">
	<INPUT TYPE="hidden" NAME="requestName" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">検査セットの登録</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="22" NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1" ALT=""></TD>
			<TD ROWSPAN="2" VALIGN="bottom">
<%
				'更新時は「削除」「コピー」ボタンを用意する
				If strMode = MODE_UPDATE Then
					'2005.08.22 権限管理 Add by 李　--- START 
					if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then  
%>
						<A HREF="javascript:deleteOption()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="削除"></A>
<%
						'コピー処理のURL編集
						strURL = Request.ServerVariables("SCRIPT_NAME")
						strURL = strURL & "?orgCd1="      & strOrgCd1
						strURL = strURL & "&orgCd2="      & strOrgCd2
						strURL = strURL & "&ctrPtCd="     & strCtrPtCd
						strURL = strURL & "&optCd="       & strOptCd
						strURL = strURL & "&optBranchNo=" & strOptBranchNo
						strURL = strURL & "&mode="        & MODE_COPY
					end if

					if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
						<A HREF="<%= strURL %>"><IMG SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="コピー"></A>
<%
					end if
				End If
%>
				<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
					<A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 権限管理 Add by 李  ---- END %>
				
				<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
			</TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
<%
			Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(dtmEndDate, "yyyy年m月d日") %></B></TD>
<%
			Set objCommon = Nothing
%>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>基本情報</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>セットコード</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
<%
						'新規・コピー時にオプションコードはテキスト入力可とし、更新時は表示のみとする
						If strMode = MODE_INSERT Or strMode = MODE_COPY Then
%>
							<TD NOWRAP><INPUT TYPE="text" NAME="optCd" SIZE="<%= LENGTH_OPTCD %>" MAXLENGTH="<%= LENGTH_OPTCD %>" VALUE="<%= strOptCd %>">-<INPUT TYPE="text" NAME="optBranchNo" SIZE="2" MAXLENGTH="2" VALUE="<%= strOptBranchNo %>"></TD>
<%
						Else
%>
							<TD NOWRAP><INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strOptCd %>"><INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strOptBranchNo %>"><B><%= strOptCd %>-<%= strOptBranchNo %></B>&nbsp;&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP>セット名：</TD>
						<TD><INPUT TYPE="text" NAME="optName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strOptName %>"></TD>
						<TD NOWRAP>　セット略称：</TD>
						<TD><INPUT TYPE="text" NAME="optSName" SIZE="<%= TextLength(LENGTH_OPTSNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTSNAME) %>" VALUE="<%= strOptSName %>"></TD>
						<TD NOWRAP>　セットカラー：</TD>
						<TD><A HREF="javascript:showGuideColor('setColor', 'elemSetColor')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="色選択ガイド表示"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="setColor" VALUE="<%= strSetColor %>"><FONT SIZE="4" COLOR="#<%= strSetColor %>" ID="elemSetColor">■</FONT></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD NOWRAP>管理コース：</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", IIf(strSubCsCd <> "", strSubCsCd, strCsCd), NON_SELECTED_DEL, False) %></TD>
						<TD NOWRAP>　セット分類：</TD>
						<TD><%= EditSetClassList("setClassCd", strSetClassCd, NON_SELECTED_ADD) %></TD>
						<TD NOWRAP>　管理対象となる予約枠：</TD>
						<TD><%= EditRsvFraList("rsvFraCd", strRsvFraCd, NON_SELECTED_ADD) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
		<TR>
			<TD WIDTH="65" NOWRAP>受診条件</TD>
			<TD>：</TD>
			<TD NOWRAP>受診区分</TD>
			<TD>：</TD>
<%
			'汎用テーブルから受診区分を読み込む
			Set objFree = Server.CreateObject("HainsFree.Free")
			objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
			Set objFree = Nothing
%>
			<TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, NON_SELECTED_DEL) %></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" ROWSPAN="3"></TD>
			<TD>性別</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="gender">
					<OPTION VALUE="<%= GENDER_BOTH   %>" <%= IIf(lngGender = GENDER_BOTH,   "SELECTED", "") %>>男女共通
					<OPTION VALUE="<%= GENDER_MALE   %>" <%= IIf(lngGender = GENDER_MALE,   "SELECTED", "") %>>男性
					<OPTION VALUE="<%= GENDER_FEMALE %>" <%= IIf(lngGender = GENDER_FEMALE, "SELECTED", "") %>>女性
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top"><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="1" HEIGHT="3" ALT=""><BR>年齢</TD>
			<TD VALIGN="top"><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="1" HEIGHT="3" ALT=""><BR>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
					'0歳から99歳までの年齢チェックボックス編集
					i = 0

					'10行分編集
					For j = 1 To 10
%>
						<TR BGCOLOR="#<%= IIf(j Mod 2 = 0, "eeeeee", "ffffff") %>">
<%
							'10列分編集
							For k = 1 To 10
%>
								<TD><INPUT TYPE="checkbox" NAME="age" VALUE="<%= i %>" <%= IIf(CheckDateCheckBox(strAge, i), "CHECKED", "") %>></TD><TD NOWRAP><%= i %>歳</TD>
<%
								i = i + 1
							Next
%>
							<TD BGCOLOR="#ffffff" VALIGN="bottom">&nbsp;<A HREF="javascript:checkAge( 1, <%= i - 10 %>, <%= i - 1 %> )"><IMG SRC="/webHains/images/allcheck.gif" WIDTH="97" HEIGHT="13" ALT="この行すべてチェック"></A></TD>
						</TR>
<%
					Next
%>
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="age" VALUE="100" <%= IIf(CheckDateCheckBox(strAge, 100), "CHECKED", "") %>></TD>
						<TD COLSPAN="19" NOWRAP>100歳以上</TD>
						<TD VALIGN="bottom">&nbsp;&nbsp;&nbsp;<A HREF="javascript:checkAge( 0, 0, 100 )"><IMG SRC="/webHains/images/alloff.gif" WIDTH="97" HEIGHT="13" ALT="すべてオフにする"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>前回値</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD NOWRAP>過去</TD>
						<TD><INPUT TYPE="text" NAME="lastRefMonth" SIZE="2" MAXLENGTH="2" VALUE="<%= strLastRefMonth %>"></TD>
						<TD NOWRAP>ヶ月以内に</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "lastRefCsCd", strLastRefCsCd, "", False) %></TD>
						<TD NOWRAP>を受診</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>追加条件</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="addCondition">
					<OPTION VALUE="0" <%= IIf(lngAddCondition = 0, "SELECTED", "") %>>上記条件に当てはまる場合、自動追加
					<OPTION VALUE="1" <%= IIf(lngAddCondition = 1, "SELECTED", "") %>>上記条件に当てはまる受診者が任意選択
				</SELECT>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>非表示条件</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRsvFra" VALUE="1"<%= IIf(strHideRsvFra <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>予約枠画面</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRsv" VALUE="1"<%= IIf(strHideRsv <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>予約画面</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRpt" VALUE="1"<%= IIf(strHideRpt <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>受付画面</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideQuestion" VALUE="1"<%= IIf(strHideQuestion <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>問診画面</TD>
		</TR>
	</TABLE>
	<IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1" ALT=""><FONT COLOR="#999999">※チェックをつけた画面で、このセットは非表示になります。（セットグループの場合全てに反映されます）</FONT><BR><BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>請求情報</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="exceptLimit" VALUE="1"<%= IIf(strExceptLimit <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>このセットは限度額設定の対象としない</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="100%" COLSPAN="2" NOWRAP>負担元</TD>
			<TD WIDTH="90"  NOWRAP>負担金額</TD>
			<TD WIDTH="90"  NOWRAP>消費税</TD>
			<TD NOWRAP>請求書・領収書出力名</TD>
			<TD NOWRAP>請求書・領収書出力名（英語）</TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		'団体指定の負担情報編集
		For i = 0 To UBound(strSeq)
%>
			<TR>
				<TD COLSPAN="2" NOWRAP>
					<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
					<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
					<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
					<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="">
					<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
				</TD>
				<TD ALIGN="right"><INPUT TYPE="text" NAME="price" SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strPrice(i) %>"></TD>
				<TD ALIGN="right"><INPUT TYPE="text" NAME="tax"   SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strTax(i)   %>"></TD>
				<TD><INPUT TYPE="text" NAME="billPrintName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strBillPrintName(i) %>"></TD>
				<TD><INPUT TYPE="text" NAME="billPrintEName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= LENGTH_OPTNAME %>" VALUE="<%= strBillPrintEName(i) %>"></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD HEIGHT="5"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="6"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD>負担金額総計</TD>
			<TD ALIGN="right"><INPUT TYPE="button" VALUE="再計算" ONCLICK="javascript:calculate(1)"></TD>
			<TD ALIGN="right"><B><SPAN ID="totalPrice"></SPAN></B></TD>
			<TD ALIGN="right"><B><SPAN ID="totalTax"></SPAN></B></TD>
			<TD COLSPAN="2"><FONT COLOR="#999999">　※出力名（日本語）は未指定の場合、セット名が適用されます。</FONT></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>受診項目</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD VALIGN="top" ROWSPAN="2">
				<SELECT NAME="optionItem" MULTIPLE SIZE="12" STYLE="width:150;height:180;">
					<OPTION VALUE="">■検査グループ
<%
					'グループの編集
					If Not IsEmpty(strGrpCd) Then
						For i = 0 To UBound(strGrpCd)
%>
							<OPTION VALUE="G<%= strGrpCd(i) %>"><%= strGrpName(i) %>
<%
						Next
					End If
%>
					<OPTION VALUE="">■検査項目
<%
					'依頼項目の編集
					If Not IsEmpty(strItemCd) Then
						For i = 0 To UBound(strItemCd)
%>
							<OPTION VALUE="P<%= strItemCd(i) %>"><%= strRequestName(i) %>
<%
						Next
					End If
%>
				</SELECT>
			</TD>
			<TD VALIGN="top" NOWRAP>

            <% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:callItemGuide( 1, 1, 1, 0, editList )"><IMG SRC="/webHains/images/additem.gif" WIDTH="77" HEIGHT="24" ALT="受診項目を追加します"></A><BR>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>
		</TR>

		<TR>
			<TD VALIGN="BOTTOM">
            <% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:deleteItem()"><IMG SRC="/webHains/images/delitem.gif" WIDTH="77" HEIGHT="24" ALT="選択した受診項目を削除します"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>

			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>