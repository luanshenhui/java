<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(オプション検査の登録) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editJudList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdLineClassList.inc" -->
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
Const CALCMODE_NORMAL      = "0"	'金額計算モード（料金手動設定）
Const CALCMODE_ROUNDUP     = "1"	'金額計算モード（検査項目単価積算）
Const EXISTSISR_NOT_EXISTS = "0"	'健保有無区分(健保なし)
Const EXISTSISR_EXISTS     = "1"	'健保有無区分(健保あり)

Const LENGTH_OPTCD         = 3		'オプションコードの項目長
Const LENGTH_OPTNAME       = 30		'オプション名の項目長

'データベースアクセス用オブジェクト
Dim objCommon				'共通クラス
Dim objContract				'契約情報アクセス用
Dim objContractControl		'契約情報アクセス用

'引数値（契約基本情報）
Dim strMode					'処理モード
Dim strActMode				'動作モード
Dim strCalcMode				'金額計算モード
Dim strOrgCd1				'団体コード1
Dim strOrgCd2				'団体コード2
Dim strCtrPtCd				'契約パターンコード

'引数値（オプション検査基本情報）
Dim strOptCd				'オプションコード
Dim strOptName				'オプション名
Dim strSubCsCd				'（サブ）コースコード
Dim strOptAddMode			'オプション追加モード

'引数値（オプション検査対象条件）
Dim strExistsIsr			'健保有無区分
Dim lngGender				'受診可能性別
Dim strAge					'受診対象年齢
Dim strLastRefMode			'前回値参照モード
Dim strLastRefCsCd			'前回値参照用コースコード
Dim strJudClassCd			'判定分類コード
Dim strSign					'条件記号
Dim strJudCd				'判定コード
Dim strPerItemCd			'（個人検査結果）検査項目コード
Dim strPerSuffix			'（個人検査結果）サフィックス
Dim strPerItemName			'（個人検査結果）検査項目名
Dim strPerResultType		'（個人検査結果）結果タイプ
Dim strPerItemType			'（個人検査結果）項目タイプ
Dim strPerResult			'（個人検査結果）検査結果
Dim strCslFlg				'受診フラグ
Dim strNightDutyFlg			'夜勤者健診対象

'引数値（請求情報）
Dim strDmdLineClassCd		'請求明細分類コード
Dim strIsrDmdLineClassCd	'健保用請求明細分類コード
Dim strApDiv				'適用元区分
Dim strSeq					'SEQ
Dim strBdnOrgCd1			'団体コード1
Dim strBdnOrgCd2			'団体コード2
Dim strArrOrgName			'団体名称
Dim strOrgDiv				'(団体テーブル上の)団体種別
Dim strPrice				'負担金額
Dim strTax					'消費税
Dim strCtrOrgDiv			'(契約パターン負担金額管理テーブル上の)団体種別
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
Dim strOptDiv				'オプション区分
Dim strUpdCsCd				'（更新用の）コースコード
Dim strRegularFlg			'定期健診フラグ
Dim strStrAge				'受診対象開始年齢
Dim strEndAge				'受診対象終了年齢

Dim strMode2				'処理モード(COM呼び出し用)
Dim strHTML					'HTML文字列
Dim strURL					'ジャンプ先のURL
Dim strMessage				'エラーメッセージ
DIm blnSet					'初期値設定フラグ
Dim Ret						'関数戻り値
Dim i, j, k					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'引数値の取得（契約基本情報）
strMode     = Request("mode")
strActMode  = Request("actMode")
strCalcMode = Request("calcMode")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strCtrPtCd  = Request("ctrPtCd")

'引数値の取得（オプション検査基本情報）
strOptCd      = Request("optCd")
strOptName    = Request("optName")
strSubCsCd    = Request("subCsCd")
strOptAddMode = Request("optAddMode")

'引数値の取得（オプション検査対象条件）
strExistsIsr     = Request("existsIsr")
lngGender        = CLng("0" & Request("gender"))
strAge           = ConvIStringToArray(Request("age"))
strLastRefMode   = Request("lastRefMode")
strLastRefCsCd   = Request("lastRefCsCd")
strJudClassCd    = Request("judClassCd")
strSign          = Request("sign")
strJudCd         = Request("judCd")
strPerItemCd     = Request("perItemCd")
strPerSuffix     = Request("perSuffix")
strPerResultType = Request("perResultType")
strPerItemType   = Request("perItemType")
strPerResult     = Request("perResult")
strCslFlg        = Request("cslFlg")
strNightDutyFlg  = Request("nightDutyFlg")

'引数値の取得（請求情報）
strDmdLineClassCd    = Request("dmdLineClassCd")
strIsrDmdLineClassCd = Request("isrDmdLineClassCd")
strApDiv             = ConvIStringToArray(Request("apDiv"))
strSeq               = ConvIStringToArray(Request("seq"))
strBdnOrgCd1         = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2         = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName        = ConvIStringToArray(Request("orgName"))
strOrgDiv            = ConvIStringToArray(Request("orgDiv"))
strPrice             = ConvIStringToArray(Request("price"))
strTax               = ConvIStringToArray(Request("tax"))
strCtrOrgDiv         = ConvIStringToArray(Request("ctrOrgDiv"))

'引数値の取得（受診項目情報）
strGrpCd       = Split(Request("grpCd"),       ",")
strGrpName     = Split(Request("grpName"),     ",")
strItemCd      = Split(Request("itemCd"),      ",")
strRequestName = Split(Request("requestName"), ",")

'チェック・更新・読み込み処理の制御
Do
	'動作モードごとの制御
	Select Case strActMode

		'削除ボタン押下時
		Case ACTMODE_DELETE

			'指定契約パターン、オプションコードのオプション検査情報を削除
			Ret = objContractControl.DeleteOption(strOrgCd1, strOrgCd2, strCtrPtCd, strOptCd)
			Select Case Ret
				Case 0
				Case 1, 2
					strMessage = Array("このオプションを参照している受診情報が存在します。削除できません。")
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

			'前回値参照用コースコードと定期健診フラグの設定
			strUpdCsCd    = IIf(strLastRefCsCd = CSCD_REGULAR, "", strLastRefCsCd)
			strRegularFlg = IIf(strLastRefCsCd = CSCD_REGULAR, "1", "")

			'COM呼び出し用の処理モード設定
			Select Case strMode
				Case MODE_INSERT, MODE_COPY
					strMode2 = MODE_INSERT
				Case MODE_UPDATE
					strMode2 = MODE_UPDATE
			End Select

			'追加オプション書き込み
			Ret = objContractControl.SetAddOption(strMode2,             _
												  strOrgCd1,            _
												  strOrgCd2,            _
												  strCtrPtCd,           _
												  strOptCd,             _
												  strOptName,           _
												  strSubCsCd,           _
												  strDmdLineClassCd,    _
												  strIsrDmdLineClassCd, _
												  strOptAddMode,        _
												  lngGender,            _
												  strExistsIsr,         _
												  strLastRefMode,       _
												  strUpdCsCd,           _
												  strRegularFlg,        _
												  strJudClassCd,        _
												  strSign,              _
												  strJudCd,             _
												  strNightDutyFlg,      _
												  strPerItemCd,         _
												  strPerSuffix,         _
												  strPerResult,         _
												  strCslFlg,            _
												  strStrAge,            _
												  strEndAge,            _
												  strSeq,               _
												  strBdnOrgCd1,         _
												  strBdnOrgCd2,         _
												  strPrice,             _
												  strTax,               _
												  strCtrOrgDiv,         _
												  strGrpCd,             _
												  strItemCd)

			Select Case Ret
				Case 0
				Case 1
					strMessage = Array("この契約情報の負担元情報は変更されています。更新できません。")
					Exit Do
				Case 2
					strMessage = Array("調整金額が設定されてある負担元の負担金額には必ず値を入力する必要があります。")
					Exit Do
				Case 3
					strMessage = Array("同一オプションコードのオプション検査がすでに存在します。")
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
		If objContract.SelectCtrPtOpt(strCtrPtCd,           strOptCd,          _
									  strOptName,           strOptDiv,         _
									  strSubCsCd,           strDmdLineClassCd, _
									  strIsrDmdLineClassCd, strOptAddMode,     _
									  lngGender,            strExistsIsr,      _
									  strLastRefMode,       strLastRefCsCd,    _
									  strRegularFlg,        strJudClassCd,     _
									  strSign,              strJudCd,          _
									  strNightDutyFlg,      strPerItemCd,      _
									  strPerSuffix,         strPerItemName,    _
									  strPerResultType,     strPerItemType,    _
									  strPerResult,         strCslFlg) = False Then
			Err.Raise 1000, ,"オプション検査情報が存在しません。"
		End If

		'金額計算モードの設定
		strCalcMode = IIf(strDmdLineClassCd <> "" Or strIsrDmdLineClassCd <> "", CALCMODE_NORMAL, CALCMODE_ROUNDUP)

		'前回値参照用コースコードの設定
		strLastRefCsCd = IIf(strRegularFlg = "1", CSCD_REGULAR, strLastRefCsCd)

		'契約パターンオプション年齢条件情報の読み込み
		objContract.SelectCtrPtOptAge strCtrPtCd, strOptCd, strStrAge, strEndAge

		'受診対象開始・終了年齢から受診対象年齢配列への変換
		Call RevConvAgeArray(strStrAge, strEndAge, strAge)

		'契約パターングループ情報の読み込み
		objContract.SelectCtrPtGrp strCtrPtCd, strOptCd, strGrpCd, strGrpName

		'契約パターン検査項目情報の読み込み
		objContract.SelectCtrPtItem strCtrPtCd, strOptCd, strItemCd, strRequestName

		'契約パターン負担金額情報の読み込み
		lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, strOptCd, strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, , , , , , , strOrgDiv, strCtrOrgDiv)
		If lngCount <= 0 Then
			Err.Raise 1000, ,"契約情報が存在しません。"
		End If

		'コピーモードの場合はオプションコードをクリアする
		If strMode = MODE_COPY Then
			strOptCd = ""
		End If

		Exit Do
	End If

	'新規モードの場合

	'すべての年齢をチェック対象とさせるための初期値を作成
	strStrAge = Array("0")
	strEndAge = Array("999")
	Call RevConvAgeArray(strStrAge, strEndAge, strAge)

	'契約パターン負担金額情報の読み込み
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, , , , , , , strOrgDiv, strCtrOrgDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If

	'料金手動設定モードの場合はここで処理終了
	If strCalcMode = CALCMODE_NORMAL Then
		Exit Do
	End If

	'検査項目単価積算モードの新規登録時は団体種別の初期値を設定する
	blnSet = False
	For i = 0 To lngCount - 1

		Do
			'契約団体自身をデフォルト負担事業所とする
			If strApDiv(i) = CStr(APDIV_MYORG) Then
				strCtrOrgDiv(i) = "0"
				Exit Do
			End If

			'最初に検索された健保用団体をデフォルト負担健保とする
			If Not blnSet And strOrgDiv(i) = "1" Then
				strCtrOrgDiv(i) = "1"
				blnSet = True
				Exit Do
			End If

			'それ以外は団体種別を設定しない
			strCtrOrgDiv(i) = ""
			Exit Do
		Loop

	Next

	Exit Do
Loop

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

	Dim lngStrAgeInt	'受診対象開始年齢(年齢)
	Dim lngStrAgeDec	'受診対象開始年齢(月齢)
	Dim lngEndAgeInt	'受診対象終了年齢(年齢)
	Dim lngEndAgeDec	'受診対象終了年齢(月齢)

	Dim strArrMessage	'エラーメッセージの配列
	Dim strMessage		'エラーメッセージ
	Dim blnPriceError	'金額エラーフラグ
	Dim blnError1		'エラーフラグ１
	Dim blnError2		'エラーフラグ２
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'オプションコードチェック
	strMessage = objCommon.CheckNumeric("オプションコード", strOptCd, LENGTH_OPTCD, CHECK_NECESSARY)
	If strMessage <> "" Then
		objCommon.AppendArray strArrMessage, strMessage
	Else
		'０は許さない
		If CLng(strOptCd) = 0 Then
			objCommon.AppendArray strArrMessage, "オプションコードには１以上の値を設定してください。"
		End If
	End If

	'オプション名チェック
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("オプション名", strOptName, LENGTH_OPTNAME, CHECK_NECESSARY)

	'受診条件存在チェック
	If strOptAddMode = "" Then
		objCommon.AppendArray strArrMessage, "受診条件を指定して下さい。"
	End If

	'前回値条件チェック
	Do

		'何も入力されていなければ正常
		If strLastRefCsCd & strJudClassCd & strSign & strJudCd = "" Then
			Exit Do
		End If

		'判定分類、判定、条件記号が全て入力されていれば正常
		If strJudClassCd <> "" And strJudCd <> "" And strSign <> "" Then
			Exit Do
		End If

		'上記以外はエラー
		objCommon.AppendArray strArrMessage, "前回値の条件指定が不完全です。"
		Exit Do
	Loop

	'個人検査結果条件チェック
	Do

		'何も入力されていなければ正常
		If strPerItemCd & strPerSuffix & strPerResult & strCslFlg = "" Then
			Exit Do
		End If

		'全て入力されていれば正常
		If strPerItemCd <> "" And strPerSuffix <> "" And strPerResult <> "" And strCslFlg <> "" Then
			Exit Do
		End If

		'上記以外はエラー
		objCommon.AppendArray strArrMessage, "個人検査結果の条件指定が不完全です。"
		Exit Do
	Loop

	'料金手動設定時は請求明細分類、健保請求明細分類のいずれかが必須
	If strCalcMode = CALCMODE_NORMAL And strDmdLineClassCd = "" And strIsrDmdLineClassCd = "" Then
		objCommon.AppendArray strArrMessage, "請求分類、健保請求分類のいずれかを指定して下さい。"
	End If

	blnPriceError = False

	'負担金額チェック
	For i = 0 To UBound(strPrice)
		strMessage = objCommon.CheckNumeric("負担金額", strPrice(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			blnPriceError = True
			Exit For
		End If
	Next

	'消費税チェック
	For i = 0 To UBound(strTax)
		strMessage = objCommon.CheckNumeric("消費税", strTax(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			blnPriceError = True
			Exit For
		End If
	Next

	'健保有無区分と金額設定の関連チェック
	Do

		'金額エラー時は何もしない
		If blnPriceError Then
			Exit Do
		End If

		'健保有無区分が健保なし以外の場合はチェック不要
		If strExistsIsr <> EXISTSISR_NOT_EXISTS Then
			Exit Do
		End If

		'負担金額情報を検索
		For i = 0 To UBound(strApDiv)

			'団体種別が健保の場合
			If strOrgDiv(i) = "1" Then

				'負担金額または消費税に値が存在する場合はエラー
				If CLng(strPrice(i) & "0") <> 0 Or CLng(strTax(i) & "0") <> 0 Then
					objCommon.AppendArray strArrMessage, "健保負担区分が「健保なし」の場合、健保に負担金額は設定できません。"
					Exit Do
				End If

			End If
		Next

		Exit Do
	Loop

	'請求分類と金額設定の関連チェック
	Do

		'金額エラー時は何もしない
		If blnPriceError Then
			Exit Do
		End If

		blnError1 = False
		blnError2 = False

		'負担金額情報を検索
		For i = 0 To UBound(strApDiv)

			'負担金額または消費税に値が存在する場合
			If CLng(strPrice(i) & "0") <> 0 Or CLng(strTax(i) & "0") <> 0 Then

				'団体種別が「団体」でかつ請求分類が未設定の場合はエラー
				If blnError1 = False And strOrgDiv(i) = "0" And strDmdLineClassCd = "" Then
					objCommon.AppendArray strArrMessage, "団体負担金額設定時は必ず請求分類を指定する必要があります。"
					blnError1 = True
				End If

				'団体種別が「健保」でかつ健保請求分類が未設定の場合はエラー
				If blnError2 = False And strOrgDiv(i) = "1" And strIsrDmdLineClassCd = "" Then
					objCommon.AppendArray strArrMessage, "健保負担金額設定時は必ず健保請求分類を指定する必要があります。"
					blnError2 = True
				End If

			End If

			'双方でエラーが発生した場合、これ以上チェックを続ける必要はない
			If blnError1 And blnError2 Then
				Exit Do
			End If

		Next

		Exit Do
	Loop

	'チェック結果を返す
	CheckValue = strArrMessage

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
<TITLE>オプション検査の登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/price.inc"    -->
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
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

// 結果関連ガイド呼び出し
function callResultGuide() {

	// 結果タイプによる処理分岐
	switch ( document.entryForm.perResultType.value ) {

		// 定性の場合
		case '<%= RESULTTYPE_TEISEI1 %>':
		case '<%= RESULTTYPE_TEISEI2 %>':
			callTseGuide();
			break;

		case '<%= RESULTTYPE_SENTENCE %>':
			callStcGuide();

		default:

	}

}

// 文章ガイド呼び出し
function callStcGuide() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 検査項目コード・項目タイプの設定
	stcGuide_ItemCd   = myForm.perItemCd.value;
	stcGuide_ItemType = myForm.perItemType.value;

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	stcGuide_CalledFunction = setStcResultInfo;

	// 文章ガイド表示
	showGuideStc();
}

// 定性結果ガイド呼び出し
function callTseGuide() {

	// 結果タイプの設定
	tseGuide_ResultType = document.entryForm.perResultType.value;

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	tseGuide_CalledFunction = setTeiseiResultInfo;

	// 定性結果ガイド表示
	showGuideTse();

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

	// 確認メッセージの表示
	if ( !confirm('このオプション検査を削除します。よろしいですか？') ) {
		return;
	}

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

// 団体種別の設定
function setCtrOrgDiv( index, ctrOrgDiv ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var i;								// インデックス

	// 負担元が単数の場合
	if ( !myForm.apDiv.length ) {
		myForm.ctrOrgDiv.value = ctrOrgDiv;
		return;
	}

	// 負担元が複数の場合
	for ( i = 0; i < myForm.apDiv.length; i++ ) {

		// 指定されたインデックスの団体種別を設定
		if ( i == index ) {
			myForm.ctrOrgDiv[ i ].value = ctrOrgDiv;
			continue;
		}

		// 指定インデックス以外の場合、以前の設定値をクリア
		if ( myForm.ctrOrgDiv[ i ].value == ctrOrgDiv ) {
			myForm.ctrOrgDiv[ i ].value = '';
		}

	}

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

	// 文章ガイド画面を閉じる
	closeGuideStc();

	// 定性結果ガイド画面を閉じる
	closeGuideTse();

}

// 計算処理
function calculate() {

	calcPrice( document.entryForm.price, 'totalPrice' );
	calcPrice( document.entryForm.tax,   'totalTax'   );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="javascript:calculate()" ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode"     VALUE="">
	<INPUT TYPE="hidden" NAME="calcMode"    VALUE="<%= strCalcMode %>">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="grpCd"       VALUE="">
	<INPUT TYPE="hidden" NAME="grpName"     VALUE="">
	<INPUT TYPE="hidden" NAME="itemCd"      VALUE="">
	<INPUT TYPE="hidden" NAME="requestName" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">オプション検査の登録</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'契約情報の読み込み
	If Not objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD WIDTH="100%" NOWRAP><B><%= strOrgName %></B></TD>
<%
			'更新時は「削除」ボタンを用意する
			If strMode = MODE_UPDATE Then
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:deleteOption()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="削除"></A></TD>
				<TD>&nbsp;</TD>
<%
				'コピー処理のURL編集
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?orgCd1="   & strOrgCd1
				strURL = strURL & "&orgCd2="   & strOrgCd2
				strURL = strURL & "&ctrPtCd="  & strCtrPtCd
				strURL = strURL & "&optCd="    & strOptCd
				strURL = strURL & "&mode="     & MODE_COPY
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="コピー"></A></TD>
				<TD>&nbsp;</TD>
<%
			End If
%>

			<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A></TD>
			<TD>&nbsp;</TD>
<%
			'新規時は「戻る」ボタン、それ以外(更新・コピー時)は「キャンセル」ボタンを用意する
			If strMode = MODE_INSERT Then

				'契約情報参照・登録用URLの編集
				strURL = "ctrOptionGate.asp"
				strURL = strURL & "?orgCd1="   & strOrgCd1
				strURL = strURL & "&orgCd2="   & strOrgCd2
				strURL = strURL & "&ctrPtCd="  & strCtrPtCd
				strURL = strURL & "&calcMode=" & strCalcMode
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A></TD>
<%
			Else
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(dtmEndDate, "yyyy年m月d日") %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="850">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>基本情報</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>オプションコード</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
<%
						'新規・コピー時にオプションコードはテキスト入力可とし、更新時は表示のみとする
						If strMode = MODE_INSERT Or strMode = MODE_COPY Then
%>
							<TD><INPUT TYPE="text" NAME="optCd" SIZE="3" MAXLENGTH="3" VALUE="<%= strOptCd %>"></TD>
<%
						Else
%>
							<TD><INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strOptCd %>"><B><%= strOptCd %></B>&nbsp;&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP>オプション名：</TD>
						<TD><INPUT TYPE="text" NAME="optName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strOptName %>"></TD>
						<TD NOWRAP>サブコース：</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", IIf(strSubCsCd <> "", strSubCsCd, strCsCd), NON_SELECTED_DEL, False) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>受診条件</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD>
							<SELECT NAME="optAddMode">
<%
								'新規時は空行を用意する
								If strMode = MODE_INSERT Then
%>
									<OPTION VALUE="">
<%
								End If
%>
								<OPTION VALUE="<%= OPTADDMODE_FREE      %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_FREE),      "SELECTED", "") %>>希望者のみ
								<OPTION VALUE="<%= OPTADDMODE_ALL       %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_ALL),       "SELECTED", "") %>>全ての受診者を対象
								<OPTION VALUE="<%= OPTADDMODE_CONDITION %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_CONDITION), "SELECTED", "") %>>条件指定
							</SELECT>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD>健保</TD>
						<TD>：</TD>
						<TD>
							<SELECT NAME="existsIsr">
								<OPTION VALUE=""  <%= IIf(strExistsIsr = "",                   "SELECTED", "") %>>指定なし
								<OPTION VALUE="0" <%= IIf(strExistsIsr = EXISTSISR_NOT_EXISTS, "SELECTED", "") %>>健保なし
								<OPTION VALUE="1" <%= IIf(strExistsIsr = EXISTSISR_EXISTS,     "SELECTED", "") %>>健保あり
							</SELECT>
						</TD>
					</TR>
					<TR>
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
											<TD><INPUT TYPE="checkbox" NAME="age" VALUE="<%= i %>" <%= IIf(CheckDateCheckBox(strAge, i), "CHECKED", "") %>></TD>
											<TD NOWRAP><%= i %>歳</TD>
<%
											i = i + 1
										Next
%>
										<TD BGCOLOR="#FFFFFF" VALIGN="BOTTOM">&nbsp;<A HREF="javascript:checkAge( 1, <%= i - 10 %>, <%= i - 1 %> )"><IMG SRC="/webHains/images/allcheck.gif" WIDTH="97" HEIGHT="13" ALT="この行すべてチェック"></A></TD>
									</TR>
<%
								Next
%>
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="age" VALUE="100" <%= IIf(CheckDateCheckBox(strAge, 100), "CHECKED", "") %>></TD>
									<TD COLSPAN="19" NOWRAP>100歳以上</TD>
									<TD VALIGN="BOTTOM">&nbsp;&nbsp;&nbsp;<A HREF="javascript:checkAge( 0, 0, 100 )"><IMG SRC="/webHains/images/alloff.gif" WIDTH="97" HEIGHT="13" ALT="すべてオフにする"></A></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD>前回値</TD>
						<TD>：</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD NOWRAP>前回コース</TD>
									<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "lastRefCsCd", strLastRefCsCd, "指定なし", True) %></TD>
									<TD NOWRAP>における</TD>
									<TD><%= EditJudClassList("judClassCd", strJudClassCd, NON_SELECTED_ADD) %></TD>
									<TD NOWRAP>の判定が</TD>
									<TD><%= EditJudList("judCd", strJudCd) %></TD>
									<TD>
										<SELECT NAME="sign">
											<OPTION VALUE=""  <%= IIf(strSign = "",  "SELECTED", "") %>>
											<OPTION VALUE="0" <%= IIf(strSign = "0", "SELECTED", "") %>>と等しい
											<OPTION VALUE="1" <%= IIf(strSign = "1", "SELECTED", "") %>>以上
											<OPTION VALUE="2" <%= IIf(strSign = "2", "SELECTED", "") %>>以下
										</SELECT>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD COLSPAN="2"></TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="radio" NAME="lastRefMode" VALUE="0" <%= IIf(strLastRefMode <> "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>すべての健診歴を検索</TD>
									<TD><INPUT TYPE="radio" NAME="lastRefMode" VALUE="1" <%= IIf(strLastRefMode  = "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>直近１年分の健診歴を検索</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD NOWRAP>個人検査結果</TD>
						<TD>：</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><A HREF="javascript:callItemGuide( 2, 0, 1, 1, setItemInfo )"><IMG SRC="/webHains/images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD><A HREF="javascript:editItemInfo( '', '', '', '', '' )"><IMG SRC="/webHains/images/delicon.gif"  ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD WIDTH="200" NOWRAP>
										<INPUT TYPE="hidden" NAME="perItemCd"     VALUE="<%= strPerItemCd     %>">
										<INPUT TYPE="hidden" NAME="perSuffix"     VALUE="<%= strPerSuffix     %>">
										<INPUT TYPE="hidden" NAME="perResultType" VALUE="<%= strPerResultType %>">
										<INPUT TYPE="hidden" NAME="perItemType"   VALUE="<%= strPerItemType   %>">
										<SPAN ID="perItemName"><%= strPerItemName %></SPAN>
									</TD>
									<TD NOWRAP>の結果が</TD>
									<TD><A HREF="javascript:callResultGuide()"><IMG SRC="/webHains/images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD><INPUT TYPE="text" NAME="perResult" SIZE="10" MAXLENGTH="8" VALUE="<%= strPerResult %>"></TD>
									<TD NOWRAP>の場合に受診対象と</TD>
									<TD>
										<SELECT NAME="cslFlg">
											<OPTION VALUE=""  <%= IIf(strCslFlg = "",  "SELECTED", "") %>>
											<OPTION VALUE="0" <%= IIf(strCslFlg = "0", "SELECTED", "") %>>しない
											<OPTION VALUE="1" <%= IIf(strCslFlg = "1", "SELECTED", "") %>>する
										</SELECT>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD COLSPAN="2"></TD>
						<TD NOWRAP><FONT COLOR="#666666">（「受診対象としない」を選択した場合、他の受診条件は無効となります。）</FONT></TD>
					</TR>
					<TR>
						<TD>夜勤者健診</TD>
						<TD>：</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="nightDutyFlg" VALUE="1" <%= IIf(strNightDutyFlg = "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>夜勤者健診対象者のみ受診</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="850">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="400" NOWRAP>請求情報</TD>
			<TD NOWRAP>受診項目</TD>
		</TR>
		<TR>
			<TD VALIGN="top">
<%
				'処理モードごとの表示処理
				Select Case strCalcMode

					'料金手動設定時
					Case CALCMODE_NORMAL
%>
						<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
							<TR>
								<TD>請求分類</TD>
								<TD>：</TD>
								<TD><%= Tokyu_EditDmdLineClassList(EDITDMDLINECLASSLIST_MODE_NORMAL, "dmdLineClassCd", strDmdLineClassCd, NON_SELECTED_ADD) %></TD>
							</TR>
							<TR>
								<TD NOWRAP>健保請求分類</TD>
								<TD>：</TD>
								<TD><%= Tokyu_EditDmdLineClassList(EDITDMDLINECLASSLIST_MODE_ISR, "isrDmdLineClassCd", strIsrDmdLineClassCd, NON_SELECTED_ADD) %></TD>
							</TR>
						</TABLE>

						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
							<TR BGCOLOR="#eeeeee">
								<TD WIDTH="300" COLSPAN="2" NOWRAP>負担元</TD>
								<TD WIDTH="90"  NOWRAP>負担金額</TD>
								<TD WIDTH="90"  NOWRAP>消費税</TD>
							</TR>
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
<%
							'団体指定の負担情報編集
							For i = 0 To UBound(strSeq)
%>
								<TR>
									<TD COLSPAN="2">
										<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
										<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
										<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
										<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
										<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="">
										<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
									</TD>
									<TD ALIGN="right"><INPUT TYPE="text" NAME="price" SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled" VALUE="<%= strPrice(i) %>"></TD>
									<TD ALIGN="right"><INPUT TYPE="text" NAME="tax"   SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled" VALUE="<%= strTax(i)   %>"></TD>
								</TR>
<%
							Next
%>
							<TR>
								<TD HEIGHT="5"></TD>
								<TD>※請求書・領収書出力名は空白の場合、自動的にセット名が適用されます。</TD>
							</TR>
							<TR>
								<TD HEIGHT="5"></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="4"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
							</TR>
							<TR>
								<TD HEIGHT="1"></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD>負担金額総計ほげ</TD>
								<TD ALIGN="right"><INPUT TYPE="button" VALUE="再計算" ONCLICK="javascript:calculate()"></TD>
								<TD ALIGN="right"><B><SPAN ID="totalPrice"></SPAN></B></TD>
								<TD ALIGN="right"><B><SPAN ID="totalTax"></SPAN></B></TD>
							</TR>
						</TABLE>
<%
					'検査項目単価積算時
					Case CALCMODE_ROUNDUP
%>
						<BR>金額計算方法：<B>検査項目設定料金から計算（マルメあり）</B><BR><BR>

						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
							<TR BGCOLOR="#eeeeee">
								<TD WIDTH="280" NOWRAP>負担元</TD>
								<TD COLSPAN="2" NOWRAP>健保</TD>
								<TD COLSPAN="2" NOWRAP>事業所</TD>
							</TR>
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
<%
							'団体指定の負担情報編集
							For i = 0 To UBound(strSeq)
%>
								<TR>
									<TD>
										<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
										<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
										<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
										<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
										<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="<%= strCtrOrgDiv(i)  %>">
										<INPUT TYPE="hidden" NAME="price"     VALUE="">
										<INPUT TYPE="hidden" NAME="tax"       VALUE="">
										<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
									</TD>
									<TD><INPUT TYPE="radio" NAME="isr" <%= IIf(strCtrOrgDiv(i) = "1", "CHECKED", "") & " " & IIf(strOrgDiv(i) <> "1", "DISABLED", "") %> ONCLICK="javascript:setCtrOrgDiv(<%= i %>, '1')"></TD>
									<TD NOWRAP>負担</TD>
									<TD><INPUT TYPE="radio" NAME="bsd" <%= IIf(strCtrOrgDiv(i) = "0", "CHECKED", "") & " " & IIf(strOrgDiv(i) =  "1", "DISABLED", "") %> ONCLICK="javascript:setCtrOrgDiv(<%= i %>, '0')"></TD>
									<TD NOWRAP>負担</TD>
								</TR>
<%
							Next
%>
						</TABLE>
<%
				End Select
%>
			</TD>
			<TD VALIGN="top">
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
							<A HREF="javascript:callItemGuide( 1, 1, 1, 0, editList )"><IMG SRC="/webHains/images/additem.gif" WIDTH="77" HEIGHT="24" ALT="受診項目を追加します"></A><BR>
						</TD>
					</TR>
					<TR>
						<TD VALIGN="BOTTOM">
							<A HREF="javascript:deleteItem()"><IMG SRC="/webHains/images/delitem.gif" WIDTH="77" HEIGHT="24" ALT="選択した受診項目を削除します"></A>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>