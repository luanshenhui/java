<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果一括入力(例外者入力) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const STDFLG_H = "H"		'異常（上）
Const STDFLG_U = "U"		'軽度異常（上）
Const STDFLG_D = "D"		'軽度異常（下）
Const STDFLG_L = "L"		'異常（下）
Const STDFLG_T1 = "*"		'定性値異常
Const STDFLG_T2 = "@"		'定性値軽度異常

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用COMオブジェクト
Dim objResult		'検査結果アクセス用COMオブジェクト
Dim objCommon		'共通関数アクセス用COMオブジェクト

'引数値
Dim strAction		'処理状態(保存ボタン押下時"save"、保存完了時"saveend")
Dim strDate			'受診日
Dim strGrpCd		'検査グループコード
Dim lngCount		'レコード件数
Dim strRsvNo		'予約番号

'受診者情報
Dim strPerId		'個人ＩＤ
Dim strCslDate		'受診日
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strAge			'年齢
Dim strGender		'性別
Dim strGenderName	'性別名称
Dim strDayId		'当日ＩＤ

'検査結果情報
Dim strRslRsvNo		'予約番号
Dim strRslName		'氏名
Dim strConsultFlg	'受診項目フラグ
Dim strItemCd		'検査項目コード
Dim strSuffix		'サフィックス
Dim strItemName		'検査項目名称
Dim strResult		'検査結果
Dim strResultType	'結果タイプ
Dim strItemType		'項目タイプ
Dim strStcItemCd	'文章参照用項目コード
Dim strShortStc		'文章略称
Dim strStdFlg		'基準値フラグ
Dim strInitRsl		'初期読み込み状態の結果
Dim lngItemCount	'レコード件数

'実際に更新する項目情報を格納した検査結果
Dim strUpdRsvNo			'予約番号
Dim strUpdItemCd		'検査項目コード
Dim strUpdSuffix		'サフィックス
Dim strUpdResult		'検査結果
Dim lngUpdCount			'更新項目数

'結果入力チェック用
Dim strResultErr		'検査結果エラー

Dim strArrMessage		'エラーメッセージ
Dim i					'インデックス

'表示色
Dim strH_Color			'基準値フラグ色（Ｈ）
Dim strU_Color			'基準値フラグ色（Ｕ）
Dim strD_Color			'基準値フラグ色（Ｄ）
Dim strL_Color			'基準値フラグ色（Ｌ）
Dim strT1_Color			'基準値フラグ色（＊）
Dim strT2_Color			'基準値フラグ色（＠）

Dim strUpdUser			'更新者
Dim strIPAddress		'IPAddress

Dim lngChkIndex()		'検査項目コード
Dim strChkItemCd()		'検査項目コード
Dim strChkSuffix()		'サフィックス
Dim strChkResult()		'検査結果
Dim strChkShortStc()	'文章略称
Dim strChkResultErr()	'検査結果エラー
Dim lngChkCount			'チェック項目数
Dim j					'インデックス
Dim strPrevRsvNo		'直前レコードの予約番号
Dim strPrevRslName		'直前レコードの氏名
Dim strArrMessage2		'メッセージ
Dim lngMsgCount			'メッセージ数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'更新者の設定
strUpdUser = Session("USERID")

'IPアドレスの取得
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'引数値の取得
strAction			= Request("act")
strDate				= CDate(Request("date"))
strGrpCd			= Request("grpCd")
lngCount			= CLng("0" & Request("count"))
strRsvNo			= ConvIStringToArray(Request("rsvNo"))

'受診者情報
strPerId			= ConvIStringToArray(Request("perID"))
strCslDate			= ConvIStringToArray(Request("cslDate"))
strCsCd				= ConvIStringToArray(Request("csCd"))
strCsName			= ConvIStringToArray(Request("csName"))
strLastName			= ConvIStringToArray(Request("lastName"))
strFirstName		= ConvIStringToArray(Request("firstName"))
strLastKName		= ConvIStringToArray(Request("lastKName"))
strFirstKName		= ConvIStringToArray(Request("firstKName"))
strBirth			= ConvIStringToArray(Request("birth"))
strAge				= ConvIStringToArray(Request("age"))
strGender			= ConvIStringToArray(Request("gender"))
strGenderName		= ConvIStringToArray(Request("genderName"))
strDayId			= ConvIStringToArray(Request("dayID"))

'検査結果情報
strRslRsvNo			= ConvIStringToArray(Request("rslRsvNo"))
strRslName			= ConvIStringToArray(Request("rslName"))
strConsultFlg		= ConvIStringToArray(Request("consultFlg"))
strItemCd			= ConvIStringToArray(Request("itemCd"))
strSuffix			= ConvIStringToArray(Request("suffix"))
strItemName			= ConvIStringToArray(Request("itemName"))
strResult			= ConvIStringToArray(Request("result"))
strResultType		= ConvIStringToArray(Request("resultType"))
strItemType			= ConvIStringToArray(Request("itemType"))
strStcItemCd		= ConvIStringToArray(Request("stcItemCd"))
strShortStc			= ConvIStringToArray(Request("shortStc"))
strStdFlg			= ConvIStringToArray(Request("stdFlg"))
strInitRsl			= ConvIStringToArray(Request("initRsl"))
lngItemCount		= CLng("0" & Request("itemCount"))

'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'基準値フラグ色取得
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

Do
	'保存処理
	If strAction = "save" Then

		'入力チェック用配列作成
		ReDim strResultErr(lngItemCount - 1)

		'オブジェクトのインスタンス作成
		Set objResult = Server.CreateObject("HainsResult.Result")

		'結果入力チェック
		For i = 0 To UBound(strRslRsvNo)

			'直前レコードと予約番号が変わった時点でチェックを行う
			If strPrevRsvNo <> "" And strRslRsvNo(i) <> strPrevRsvNo Then

				'結果入力チェック
				strArrMessage2 = objResult.CheckResult(strDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

				'チェック結果を戻す
				For j = 0 To lngChkCount - 1
					strResult(lngChkIndex(j))    = strChkResult(j)
					strResultErr(lngChkIndex(j)) = strChkResultErr(j)
					strShortStc(lngChkIndex(j))  = strChkShortStc(j)
				Next

				'エラーが存在する場合
				If Not IsEmpty(strArrMessage2) Then

					If IsEmpty(strArrMessage) Then
						strArrMessage = Array()
					End If

					'エラーメッセージを追加
					For j = 0 To UBound(strArrMessage2)
						ReDim Preserve strArrMessage(lngMsgCount)
						strArrMessage(lngMsgCount) = strPrevRslName & "　" & strArrMessage2(j)
						lngMsgCount = lngMsgCount + 1
					Next

				End If

				'チェック情報をクリア
				Erase lngChkIndex
				Erase strChkItemCd
				Erase strChkSuffix
				Erase strChkResult
				Erase strChkShortStc
				Erase strChkResultErr
				lngChkCount = 0

			End If

			'チェック情報をスタック
			ReDim Preserve lngChkIndex(lngChkCount)
			ReDim Preserve strChkItemCd(lngChkCount)
			ReDim Preserve strChkSuffix(lngChkCount)
			ReDim Preserve strChkResult(lngChkCount)
			ReDim Preserve strChkShortStc(lngChkCount)
			ReDim Preserve strChkResultErr(lngChkCount)
			lngChkIndex(lngChkCount)     = i
			strChkItemCd(lngChkCount)    = strItemCd(i)
			strChkSuffix(lngChkCount)    = strSuffix(i)
			strChkResult(lngChkCount)    = strResult(i)
			strChkShortStc(lngChkCount)  = strShortStc(i)
			strChkResultErr(lngChkCount) = strResultErr(i)
			lngChkCount = lngChkCount + 1

			'現レコードの予約番号、氏名を退避
			strPrevRsvNo   = strRslRsvNo(i)
			strPrevRslName = strRslName(i)

		Next

		'スタック残り分の結果チェック

		'結果入力チェック
		strArrMessage2 = objResult.CheckResult(strDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

		'チェック結果を戻す
		For j = 0 To lngChkCount - 1
			strResult(lngChkIndex(j))    = strChkResult(j)
			strResultErr(lngChkIndex(j)) = strChkResultErr(j)
			strShortStc(lngChkIndex(j))  = strChkShortStc(j)
		Next

		'エラーが存在する場合
		If Not IsEmpty(strArrMessage2) Then

			If IsEmpty(strArrMessage) Then
				strArrMessage = Array()
			End If

			'エラーメッセージを追加
			For j = 0 To UBound(strArrMessage2)
				ReDim Preserve strArrMessage(lngMsgCount)
				strArrMessage(lngMsgCount) = strPrevRslName & "　" & strArrMessage2(j)
				lngMsgCount = lngMsgCount + 1
			Next

		End If

		'入力エラーの場合は何もしない
		If Not IsEmpty(strArrMessage) Then

			'オブジェクトのインスタンス削除
			Set objResult = Nothing

			strAction = "error"

			Exit Do
		End If

		lngUpdCount  = 0
		strUpdRsvNo  = Array()
		strUpdItemCd = Array()
		strUpdSuffix = Array()
		strUpdResult = Array()

		'実際に更新を行う項目のみを抽出(結果未入力でチェックなしの項目以外が更新対象)
		For i = 0 To UBound(strRslRsvNo)

			'結果が更新されていたらデータ更新
			If strConsultFlg(i) = CStr(CONSULT_ITEM_T) And strResult(i) <> strInitRsl(i) Then
				ReDim Preserve strUpdRsvNo(lngUpdCount)
				ReDim Preserve strUpdItemCd(lngUpdCount)
				ReDim Preserve strUpdSuffix(lngUpdCount)
				ReDim Preserve strUpdResult(lngUpdCount)
				strUpdRsvNo(lngUpdCount)      = strRslRsvNo(i)
				strUpdItemCd(lngUpdCount)     = strItemCd(i)
				strUpdSuffix(lngUpdCount)     = strSuffix(i)
				strUpdResult(lngUpdCount)     = strResult(i)
				lngUpdCount = lngUpdCount + 1
			End If

		Next

		'検査結果更新
		If lngUpdCount > 0 Then
			strArrMessage = objResult.UpdateResultList(strUpdUser, strIPAddress, strUpdRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult)
			If Not IsEmpty(strArrMessage) Then

				'オブジェクトのインスタンス削除
				Set objResult = Nothing

				strAction = "error"

				Exit Do
			End If
		End If

		'オブジェクトのインスタンス削除
		Set objResult = Nothing

		'保存完了
		strAction = "saveend"

	End If

	'受診情報格納用配列作成
	ReDim strPerId(lngCount - 1)
	ReDim strCslDate(lngCount - 1)
	ReDim strCsCd(lngCount - 1)
	ReDim strCsName(lngCount - 1)
	ReDim strLastName(lngCount - 1)
	ReDim strFirstName(lngCount - 1)
	ReDim strLastKName(lngCount - 1)
	ReDim strFirstKName(lngCount - 1)
	ReDim strBirth(lngCount - 1)
	ReDim strAge(lngCount - 1)
	ReDim strGender(lngCount - 1)
	ReDim strGenderName(lngCount - 1)
	ReDim strDayId(lngCount - 1)

	'オブジェクトのインスタンス作成
	Set objConsult	= Server.CreateObject("HainsConsult.Consult")

	'予約番号ごとに受診者情報を取得する
	lngItemCount = 0
	For i = 0 To lngCount - 1

		'受診情報取得
		Call objConsult.SelectConsult(strRsvNo(i), 0, strCslDate(i), strPerId(i), strCsCd(i), strCsName(i), , , , , , _
									  strAge(i), , , , , , , , , , , , , _
									  strDayId(i), , , , , , , , , , , , , , , , , , _
									  strLastName(i), strFirstName(i), strLastKName(i), strFirstKName(i), strBirth(i), strGender(i))

		strGenderName(i) = IIf(CLng(strGender(i)) = GENDER_MALE, "男性", "女性")

		'当日ＩＤ編集
		strDayId(i) = objCommon.FormatString(strDayId(i), "0000")

		'生年月日編集
		strBirth(i) = objCommon.FormatString(strBirth(i), "g ee.mm.dd")

		'検査結果取得
		Call SelectRsl(strRsvNo(i), strLastName(i), strFirstName(i), strGrpCd)

	Next

	'オブジェクトのインスタンス削除
	Set objConsult = Nothing

	Exit Do
Loop

'オブジェクトのインスタンス削除
Set objCommon	= Nothing

'-----------------------------------------------------------------------------
' 検査結果情報取得
'-----------------------------------------------------------------------------
Sub SelectRsl(strRsvNo, strLastName, strFirstName ,strGrpCd)

	Dim strArrRslRsvNo()		'検査結果予約番号
	Dim strArrConsultFlg()		'受診項目フラグ
	Dim strArrItemCd()			'検査項目コード
	Dim strArrSuffix()			'サフィックス
	Dim strArrItemName()		'検査項目名称
	Dim strArrResult()			'検査結果
	Dim strArrResultType()		'結果タイプ
	Dim strArrItemType()		'項目タイプ
	Dim strArrStcItemCd()		'文章参照用項目コード
	Dim strArrShortStc()		'文章略称
	Dim strArrStdFlg()			'基準値フラグ

	Dim lngCount				'レコード件数

	Dim i						'インデックス

	'オブジェクトのインスタンス作成
	Set objResult = Server.CreateObject("HainsResult.Result")

	'検査結果取得
	lngCount = objResult.SelectRslAllSetList(strRsvNo, strGrpCd, strArrConsultFlg, strArrItemCd, strArrSuffix, strArrItemName, strArrResult, strArrResultType, strArrItemType, strArrStcItemCd, strArrShortStc, strArrStdFlg)

	'オブジェクトのインスタンス削除
	Set objResult = Nothing

	'検査結果配列へ追加
	For i = 0 To lngCount - 1

		If IsArray(strRslRsvNo) Then

			ReDim Preserve strRslRsvNo(lngItemCount)
			ReDim Preserve strRslName(lngItemCount)
			ReDim Preserve strConsultFlg(lngItemCount)
			ReDim Preserve strItemCd(lngItemCount)
			ReDim Preserve strSuffix(lngItemCount)
			ReDim Preserve strItemName(lngItemCount)
			ReDim Preserve strResult(lngItemCount)
			ReDim Preserve strResultType(lngItemCount)
			ReDim Preserve strItemType(lngItemCount)
			ReDim Preserve strStcItemCd(lngItemCount)
			ReDim Preserve strShortStc(lngItemCount)
			ReDim Preserve strStdFlg(lngItemCount)
			ReDim Preserve strInitRsl(lngItemCount)
			strRslRsvNo(lngItemCount) = strRsvNo
			strRslName(lngItemCount) = strLastName & "　" & strFirstName
			strConsultFlg(lngItemCount) = strArrConsultFlg(i)
			strItemCd(lngItemCount) = strArrItemCd(i)
			strSuffix(lngItemCount) = strArrSuffix(i)
			strItemName(lngItemCount) = strArrItemName(i)
			strResult(lngItemCount) = strArrResult(i)
			strResultType(lngItemCount) = strArrResultType(i)
			strItemType(lngItemCount) = strArrItemType(i)
			strStcItemCd(lngItemCount) = strArrStcItemCd(i)
			strShortStc(lngItemCount) = strArrShortStc(i)
			strStdFlg(lngItemCount) = strArrStdFlg(i)
			strInitRsl(lngItemCount) = strArrResult(i)

			'入力エラー格納用配列にも追加
			ReDim Preserve strResultErr(lngItemCount)

		Else

			strRslRsvNo   = Array(strRsvNo)
			strRslName    = Array(strLastName & "　" & strFirstName)
			strConsultFlg = Array(strArrConsultFlg(i))
			strItemCd     = Array(strArrItemCd(i))
			strSuffix     = Array(strArrSuffix(i))
			strItemName   = Array(strArrItemName(i))
			strResult     = Array(strArrResult(i))
			strResultType = Array(strArrResultType(i))
			strItemType   = Array(strArrItemType(i))
			strStcItemCd  = Array(strArrStcItemCd(i))
			strShortStc   = Array(strArrShortStc(i))
			strStdFlg     = Array(strArrStdFlg(i))
			strInitRsl    = Array(strArrResult(i))

			'入力エラー格納用配列にも追加
			strResultErr = Array("")

		End If

		lngItemCount = lngItemCount + 1
	Next

End Sub

'-----------------------------------------------------------------------------
' 検査項目・結果の編集
'-----------------------------------------------------------------------------
Sub EditItemList(strRsvNo)

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ
	Const CLASS_ERROR     = "CLASS=""rslErr"""				'エラー表示のクラス指定

	Dim strArrConsultFlg()	'編集用受診項目フラグ
	Dim strArrItemCd()		'編集用検査項目コード
	Dim strArrSuffix()		'編集用サフィックス
	Dim strArrItemName()	'編集用検査項目名称
	Dim strArrResultType()	'編集用結果タイプ
	Dim strArrItemType()	'編集用項目タイプ
	Dim strArrResult()		'編集用検査結果
	Dim strArrResultErr()	'編集用検査結果エラー
	Dim strArrStcItemCd()	'編集用文章参照用項目コード
	Dim strArrShortStc()	'編集用文章略称
	Dim strArrStdFlg()		'編集用基準値フラグ
	Dim strArrInitRsl()		'編集用初期表示結果
	Dim lngArrPos()			'結果配列位置

	Dim strOldItemCd		'保存用検査項目コード
	Dim strOldSuffix		'保存用サフィックス
	Dim strOldItemType		'保存用項目タイプ

	Dim strDispStdFlgColor	'編集用基準値表示色
	Dim strAlignMent		'表示位置

	Dim strClass			'スタイルシートのCLASS指定
	Dim strClassStdFlg		'基準値スタイルシートのCLASS指定

	Dim strElementName		'エレメント名

	Dim lngArraySize		'配列サイズ
	Dim i					'インデックス

	If lngItemCount = 0 Then
		Exit Sub
	End If

	'配列を表示用に再編集
	lngArraySize = 0
	For i = 0 To lngItemCount - 1
		Do
			If strRslRsvNo(i) <> strRsvNo Then
				Exit Do
			End If
			'最初の処理
			If strOldItemCd = "" Then
				'編集用配列作成
				ReDim strArrConsultFlg(1, lngArraySize)
				ReDim strArrItemCd(1, lngArraySize)
				ReDim strArrSuffix(1, lngArraySize)
				ReDim strArrItemName(lngArraySize)
				ReDim strArrResultType(1, lngArraySize)
				ReDim strArrItemType(1, lngArraySize)
				ReDim strArrResult(1, lngArraySize)
				ReDim strArrResultErr(1, lngArraySize)
				ReDim strArrStcItemCd(1, lngArraySize)
				ReDim strArrShortStc(1, lngArraySize)
				ReDim strArrStdFlg(1, lngArraySize)
				ReDim strArrInitRsl(1, lngArraySize)
				ReDim lngArrPos(1, lngArraySize)
				lngArraySize = lngArraySize + 1
				'検査項目保存
				strOldItemCd = strItemCd(i)
				strOldItemType = strItemType(i)
				'部位の場合
				If CStr(strItemType(i)) = CStr(ITEMTYPE_BUI) Then
					strArrConsultFlg(0, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(0, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(0, lngArraySize - 1) = strSuffix(i)
					strArrResultType(0, lngArraySize - 1) = strResultType(i)
					strArrItemType(0, lngArraySize - 1) = strItemType(i)
					strArrResult(0, lngArraySize - 1) = strResult(i)
					strArrResultErr(0, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(0, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(0, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(0, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(0, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(0, lngArraySize -1) = i
				Else
					strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
					strArrResultType(1, lngArraySize - 1) = strResultType(i)
					strArrItemType(1, lngArraySize - 1) = strItemType(i)
					strArrResult(1, lngArraySize - 1) = strResult(i)
					strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(1, lngArraySize -1) = i
				End If
				strArrItemName(lngArraySize - 1) = strItemName(i)
			Else
				'前項目と項目コードが一致かつ、前項目タイプが”部位”で今項目タイプが”所見”の場合
				If strOldItemCd = strItemCd(i) And CStr(strOldItemType) = CStr(ITEMTYPE_BUI) And CStr(strItemType(i)) = CStr(ITEMTYPE_SHOKEN) Then
					strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
					strArrResultType(1, lngArraySize - 1) = strResultType(i)
					strArrItemType(1, lngArraySize - 1) = strItemType(i)
					strArrResult(1, lngArraySize - 1) = strResult(i)
					strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(1, lngArraySize -1) = i
					strArrItemName(lngArraySize - 1) = strItemName(i)
				Else
					'編集用配列作成
					ReDim Preserve strArrConsultFlg(1, lngArraySize)
					ReDim Preserve strArrItemCd(1, lngArraySize)
					ReDim Preserve strArrSuffix(1, lngArraySize)
					ReDim Preserve strArrItemName(lngArraySize)
					ReDim Preserve strArrResultType(1, lngArraySize)
					ReDim Preserve strArrItemType(1, lngArraySize)
					ReDim Preserve strArrResult(1, lngArraySize)
					ReDim Preserve strArrResultErr(1, lngArraySize)
					ReDim Preserve strArrStcItemCd(1, lngArraySize)
					ReDim Preserve strArrShortStc(1, lngArraySize)
					ReDim Preserve strArrStdFlg(1, lngArraySize)
					ReDim Preserve strArrInitRsl(1, lngArraySize)
					ReDim Preserve lngArrPos(1, lngArraySize)
					lngArraySize = lngArraySize + 1
					'部位の場合
					If CStr(strItemType(i)) = CStr(ITEMTYPE_BUI) Then
						strArrConsultFlg(0, lngArraySize - 1) = strConsultFlg(i)
						strArrItemCd(0, lngArraySize - 1) = strItemCd(i)
						strArrSuffix(0, lngArraySize - 1) = strSuffix(i)
						strArrResultType(0, lngArraySize - 1) = strResultType(i)
						strArrItemType(0, lngArraySize - 1) = strItemType(i)
						strArrResult(0, lngArraySize - 1) = strResult(i)
						strArrResultErr(0, lngArraySize - 1) = strResultErr(i)
						strArrStcItemCd(0, lngArraySize - 1) = strStcItemCd(i)
						strArrShortStc(0, lngArraySize - 1) = strShortStc(i)
						strArrStdFlg(0, lngArraySize - 1) = strStdFlg(i)
						strArrInitRsl(0, lngArraySize - 1) = strInitRsl(i)
						lngArrPos(0, lngArraySize - 1) = i
					Else
						strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
						strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
						strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
						strArrResultType(1, lngArraySize - 1) = strResultType(i)
						strArrItemType(1, lngArraySize - 1) = strItemType(i)
						strArrResult(1, lngArraySize - 1) = strResult(i)
						strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
						strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
						strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
						strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
						strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
						lngArrPos(1, lngArraySize -1) = i
					End If
					strArrItemName(lngArraySize - 1) = strItemName(i)
				End If
				'検査項目保存
				strOldItemCd = strItemCd(i)
				strOldItemType = strItemType(i)
			End If
			Exit Do
		Loop
	Next

	For i = 0 To lngArraySize - 1
%>
		<TR>
			<TD NOWRAP ALIGN="right"><%= strArrItemName(i) %></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPAGING="0">
					<TR>
<%
						'部位結果ガイドボタンの編集
						If strArrItemCd(0, i) <> "" And CStr(strArrConsultFlg(0, i)) = CStr(CONSULT_ITEM_T) Then

							Select Case strArrResultType(0, i)

								Case CStr(RESULTTYPE_SENTENCE)
%>
									<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(0, i) %>','0','<%= CStr(i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
								Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
									<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(0, i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
								Case Else
%>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
							End Select

						Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
						End If

						'部位結果の編集

						'基準値フラグにより色を設定する
						Select Case strArrStdFlg(0, i)
							Case STDFLG_H
								strDispStdFlgColor = strH_Color
							Case STDFLG_U
								strDispStdFlgColor = strU_Color
							Case STDFLG_D
								strDispStdFlgColor = strD_Color
							Case STDFLG_L
								strDispStdFlgColor = strL_Color
							Case STDFLG_T1
								strDispStdFlgColor = strT1_Color
							Case STDFLG_T2
								strDispStdFlgColor = strT2_Color
							Case Else
								strDispStdFlgColor = ""
						End Select

						If strArrResultErr(0, i) <> "" Then
							strClass       = CLASS_ERROR
							strClassStdFlg = ""
						Else
							strClass       = ""
							strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
						End If
%>
						<TD>
<%
							Do
								'項目自体が存在しなければ何もしない
								If strArrItemCd(0, i) = "" Then
									Exit Do
								End If

								'未受診の場合
								If CStr(strArrConsultFlg(0, i)) = CStr(CONSULT_ITEM_F) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(0, i)  %>">
<%
									Exit Do
								End If

								'計算項目の場合
								If CStr(strArrResultType(0, i)) = CStr(RESULTTYPE_CALC) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(0, i)  %>">
									<SPAN <%= strClassStdFlg %> <%= ALIGNMENT_RIGHT %>"><%= strArrResult(0, i) %></SPAN>
<%
									Exit Do
								End If

								'それ以外

								'スタイルシートの設定
								strAlignment = IIf(CLng(strArrResultType(0, i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
								<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
								<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
								<INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(0, i) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Exit Do
							Loop
%>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPAGING="0">
					<TR>
<%
						'所見結果ガイドボタンの編集
						If strArrItemCd(1, i) <> "" And CStr(strArrConsultFlg(1, i)) = CStr(CONSULT_ITEM_T) Then

							Select Case strArrResultType(1, i)

								Case CStr(RESULTTYPE_SENTENCE)
%>
									<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(1, i) %>','1','<%= CStr(i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
								Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
									<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(1, i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
								Case Else
%>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
							End Select

						Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
						End If

						'所見結果の編集

						'基準値フラグにより色を設定する
						Select Case strArrStdFlg(1, i)
							Case STDFLG_H
								strDispStdFlgColor = strH_Color
							Case STDFLG_U
								strDispStdFlgColor = strU_Color
							Case STDFLG_D
								strDispStdFlgColor = strD_Color
							Case STDFLG_L
								strDispStdFlgColor = strL_Color
							Case STDFLG_T1
								strDispStdFlgColor = strT1_Color
							Case STDFLG_T2
								strDispStdFlgColor = strT2_Color
							Case Else
								strDispStdFlgColor = ""
						End Select

						If strArrResultErr(1, i) <> "" Then
							strClass       = CLASS_ERROR
							strClassStdFlg = ""
						Else
							strClass       = ""
							strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
						End If
%>
						<TD>
<%
							Do
								'項目自体が存在しなければ何もしない
								If strArrItemCd(1, i) = "" Then
									Exit Do
								End If

								'未受診の場合
								If CStr(strArrConsultFlg(1, i)) = CStr(CONSULT_ITEM_F) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(1, i)  %>">
<%
									Exit Do
								End If

								'計算項目の場合
								If CStr(strArrResultType(1, i)) = CStr(RESULTTYPE_CALC) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(1, i)  %>">
									<SPAN <%= strClassStdFlg %>><%= strArrResult(1, i) %></SPAN>
<%
									Exit Do
								End If

								'それ以外

								'スタイルシートの設定
								strAlignment = IIf(CLng(strArrResultType(1, i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
								<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
								<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
								<INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(1, i) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Exit Do
							Loop
%>
						</TD>
					</TR>
				</TABLE>
			</TD>
<%
			strElementName = "stcName_0" & lngArrPos(0, i)
%>
			<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(0, i) %></SPAN></TD>
<%
			strElementName = "stcName_1" & lngArrPos(1, i)
%>
			<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(1, i) %></SPAN></TD>
		</TR>
<%
	Next

End Sub

'-----------------------------------------------------------------------------
' 受診日編集（yyyy年mm月dd日 形式)
'-----------------------------------------------------------------------------
Function EditCslDate(cslDate)

	Dim objCommon		'共通関数アクセス用COMオブジェクト

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	EditCslDate = objCommon.FormatString(cslDate, "yyyy年mm月dd日")

	'オブジェクトのインスタンス削除
	Set objCommon = Nothing

End Function

'-----------------------------------------------------------------------------
' 検査グループ名編集
'-----------------------------------------------------------------------------
Function EditGrpName(grpCd)

	Dim objGrp			'グループアクセス用COMオブジェクト
	Dim strGrpName		'グループ名

	'オブジェクトのインスタンス作成
	Set objGrp = Server.CreateObject("HainsGrp.Grp")

	Call objGrp.SelectGrp_P(grpCd, strGrpName)

	'オブジェクトのインスタンス削除
	Set objGrp = Nothing

	EditGrpName = strGrpName

End Function

'-----------------------------------------------------------------------------
' 検査結果編集
'-----------------------------------------------------------------------------
Sub EditRslList()

	Dim i				'インデックス

%>
	<INPUT TYPE="hidden" NAME="itemCount" VALUE="<%= lngItemCount %>">
<%
	For i = 0 To lngItemCount - 1
%>
		<INPUT TYPE="hidden" NAME="rslRsvNo"   VALUE="<%= strRslRsvNo(i)   %>">
		<INPUT TYPE="hidden" NAME="rslName"    VALUE="<%= strRslName(i)    %>">
		<INPUT TYPE="hidden" NAME="consultFlg" VALUE="<%= strConsultFlg(i) %>">
		<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= strItemCd(i)     %>">
		<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= strSuffix(i)     %>">
		<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= strItemName(i)   %>">
		<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= strResultType(i) %>">
		<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= strItemType(i)   %>">
		<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= strStcItemCd(i)  %>">
		<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= strShortStc(i)   %>">
<%
	Next

	For i = 0 To lngCount - 1
%>
		<INPUT TYPE="hidden" NAME="perID"      VALUE="<%= strPerId(i)      %>">
		<INPUT TYPE="hidden" NAME="cslDate"    VALUE="<%= strCslDate(i)    %>">
		<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strCsCd(i)       %>">
		<INPUT TYPE="hidden" NAME="csName"     VALUE="<%= strCsName(i)     %>">
		<INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= strLastName(i)   %>">
		<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= strFirstName(i)  %>">
		<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= strLastKName(i)  %>">
		<INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= strFirstKName(i) %>">
		<INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth(i)      %>">
		<INPUT TYPE="hidden" NAME="age"        VALUE="<%= strAge(i)        %>">
		<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender(i)     %>">
		<INPUT TYPE="hidden" NAME="genderName" VALUE="<%= strGenderName(i) %>">
		<INPUT TYPE="hidden" NAME="dayID"      VALUE="<%= strDayId(i)      %>">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR VALIGN="top">
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
						<TR BGCOLOR="#eeeeee">
							<TD NOWRAP><B>当日ＩＤ</B></TD>
						</TR>
						<TR>
							<TD><%= strDayId(i) %></TD>
						</TR>
					</TABLE>
				</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
						<TR BGCOLOR="#eeeeee">
							<TD COLSPAN="2"><B>氏名</B></TD>
						</TR>
						<TR>
							<TD><%= strPerID(i) %></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="200" HEIGHT="1"><BR><B><%= strLastName(i) & "　" & strFirstName(i) %></B></TD>
						</TR>
						<TR>
							<TD></TD>
							<TD><%= strBirth(i) %>生&nbsp;<%= strAge(i) %>歳&nbsp;<%= strGenderName(i) %></TD>
						</TR>
						<TR>
							<TD NOWRAP>受診コース：</TD>
							<TD><FONT COLOR="#FF6600"><B><%= strCsName(i) %></B></FONT></TD>
						</TR>
					</TABLE>
				</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
						<TR BGCOLOR="#eeeeee">
							<TD ALIGN="right"><B>検査項目名</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR><B>部位</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR><B>所見</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"><BR><B>部位文章</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"><BR><B>所見文章</B></TD>
						</TR>
<%
						'検査結果編集
						Call EditItemList(strRsvNo(i))
%>
					</TABLE>
				</TD>
<%
				'区切り線
				If i <> lngCount - 1 Then
%>
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#999999" COLSPAN="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
					</TR>
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
<%
				End If
%>
			</TR>
		</TABLE>
<%
	Next

	Response.Flush

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>例外者入力</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex1;	// ガイド表示時に選択されたエレメントのインデックス
var lngSelectedIndex2;	// ガイド表示時に選択されたエレメントのインデックス
var lngSelectedIndex3;	// ガイド表示時に選択されたエレメントのインデックス

// 文章ガイド呼び出し
function callStcGuide( index1, index2, index3 ) {

	// 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;
	lngSelectedIndex3 = index3;

	// ガイド画面の連絡域に検査項目コードを設定する
	if ( document.step5.stcItemCd.length != null ) {
		stcGuide_ItemCd = document.step5.stcItemCd[ index1 ].value;
	} else {
		stcGuide_ItemCd = document.step5.stcItemCd.value;
	}

	// ガイド画面の連絡域に項目タイプ（標準）を設定する
	if ( document.step5.itemType.length != null ) {
		stcGuide_ItemType = document.step5.itemType[ index1 ].value;
	} else {
		stcGuide_ItemType = document.step5.itemType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	stcGuide_CalledFunction = setStcInfo;

	// 文章ガイド表示
	showGuideStc();
}

// 文章コード・略文章のセット
function setStcInfo() {

	var stcNameElement; /* 略文章を編集するエレメントの名称 */
	var stcName;        /* 略文章を編集するエレメント自身 */

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.step5.result.length != null ) {
		document.step5.result[lngSelectedIndex1].value = stcGuide_StcCd;
	} else {
		document.step5.result.value = stcGuide_StcCd;
	}
	if ( document.step5.shortStc.length != null ) {
		document.step5.shortStc[lngSelectedIndex1].value = stcGuide_ShortStc;
	} else {
		document.step5.shortStc.value = stcGuide_ShortStc;
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
//		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex3;
		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex1;

		// IEの場合
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = stcGuide_ShortStc;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = stcGuide_ShortStc;
		}

		break;
	}

	return false;
}

// 定性ガイド呼び出し
function callTseGuide( index1 ) {

	// 選択されたエレメントのインデックスを退避(検査結果のセット用関数にて使用する)
	lngSelectedIndex1 = index1;

	// ガイド画面の連絡域に結果タイプを設定する
	if ( document.step5.itemType.length != null ) {
		tseGuide_ResultType = document.step5.resultType[ index1 ].value;
	} else {
		tseGuide_ResultType = document.step5.resultType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	tseGuide_CalledFunction = setTseInfo;

	// 文章ガイド表示
	showGuideTse();
}

// 検査結果のセット
function setTseInfo() {

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.step5.result.length != null ) {
		document.step5.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		document.step5.result.value = tseGuide_Result;
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step5" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="act" VALUE="save">

	<!-- 前画面(Step4)からの引継ぎ情報 -->

	<INPUT TYPE="hidden" NAME="date"  VALUE="<%= strDate %>">
	<INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strGrpCd %>">
	<INPUT TYPE="hidden" NAME="count" VALUE="<%= lngCount %>">
<%
	For i = 0 To lngCount - 1
%>
		<INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo(i) %>">
<%
	Next
%>
	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">Step5：例外者の結果入力</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strAction <> "" Then

		'保存完了時は「保存完了」の通知
		If strAction = "saveend" Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="635">
			<TR>
				<TD NOWRAP>受診日</TD>
				<TD>：</TD>
				<TD NOWRAP><FONT COLOR="#FF6600"><B><%= EditCslDate(strDate) %></B></FONT></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
				<TD NOWRAP>入力用検査項目セット</TD>
				<TD>：</TD>
				<TD NOWRAP><FONT COLOR="#FF6600"><B><%= EditGrpName(strGrpCd) %></B></FONT></TD>
				<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="document.step5.submit();return false;"><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A></TD>
			</TR>
		</TABLE>
		<BR>

		<!-- 検査結果編集 -->
		<% Call EditRslList %>
		
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
