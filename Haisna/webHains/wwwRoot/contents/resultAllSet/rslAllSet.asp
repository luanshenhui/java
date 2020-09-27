<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果一括入力 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim mobjConsult			'受診情報アクセス用COMオブジェクト

Dim objResult			'検査結果アクセス用COMオブジェクト
Dim objWorkStation		'通過情報アクセス用

'各ステップで汎用的に使用する引数
Dim mstrStep			'現ページのステップ

'Step1からの引数
Dim mlngYear			'受診日（年）
Dim mlngMonth			'受診日（月）
Dim mlngDay				'受診日（日）
Dim mstrCsCd			'コースコード
Dim mstrDayIdF			'当日ＩＤ（自）
Dim mstrDayIdT			'当日ＩＤ（至）
Dim mstrGrpCd			'検査項目グループコード
Dim mstrCslDate			'受診日

'Step2からの引数(検査項目情報)
Dim mstrAction			'動作モード
Dim mstrItemCd			'検査項目コード
Dim mstrSuffix			'サフィックス
Dim mstrItemName		'検査項目名称
Dim mstrResultType		'結果タイプ
Dim mstrItemType		'項目タイプ
Dim mstrResult			'検査結果
Dim mstrResultErr		'検査結果エラー
Dim mstrStcItemCd		'文章参照用項目コード
Dim mstrShortStc		'文章略称
Dim mstrAllResultClear	'「このグループの検索結果を全てクリアする」

'Step3からの引数(例外者情報)
Dim mstrOverWrite		'「すでに入力されている結果を上書きする」
Dim mstrRsvNo			'予約番号
Dim mstrSelectFlg		'例外者対象フラグ

'例外者入力へ渡すためにStep4で保持する引数
Dim mstrOutRsvNo		'更新対象外予約番号
Dim mlngOutCount		'更新対象外人数
Dim mlngUpdCount		'更新件数

'全ステップ共通の作業用変数
Dim strArrMessage		'エラーメッセージ
Dim mlngIndex1			'インデックス
Dim mlngIndex2			'インデックス

'端末管理情報
Dim strIPAddress		'IPAddress
Dim strWkstnName		'端末名
Dim strWkstnGrpCd		'グループコード
Dim strWkstnGrpName		'グループ名

Dim strUpdUser			'更新者
Dim lngWkStrDayId		'開始当日ID
Dim lngWkEndDayId		'終了当日ID
Dim lngAllUpdCount		'受診情報数
Dim strAllUpdRsvNo		'予約番号

Dim lngRsvNoIndex		'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objResult = Server.CreateObject("HainsResult.Result")

'更新者の設定
strUpdUser = Session("USERID")

'IPアドレスの取得
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'どのステップから呼ばれたかを求める
mstrStep = Request("step")

'Step1で設定された引数値の取得
mlngYear   = CLng("0" & Request("year"))
mlngMonth  = CLng("0" & Request("month"))
mlngDay    = CLng("0" & Request("day"))
mstrCsCd   = Request("csCd")
mstrDayIdF = Request("dayIdF")
mstrDayIdT = Request("dayIdT")
mstrGrpCd  = Request("grpCd")

'受診年月日の編集
mstrCslDate = mlngYear & "/" & mlngMonth & "/" & mlngDay

'Step2で設定された引数値の取得
mstrAction         = Request("act")
mstrItemCd         = ConvIStringToArray(Request("itemCd"))
mstrSuffix         = ConvIStringToArray(Request("suffix"))
mstrItemName       = ConvIStringToArray(Request("itemName"))
mstrResultType     = ConvIStringToArray(Request("resultType"))
mstrItemType       = ConvIStringToArray(Request("itemType"))
mstrResult         = ConvIStringToArray(Request("result"))
mstrResultErr      = ConvIStringToArray(Request("resultErr"))
mstrStcItemCd      = ConvIStringToArray(Request("stcItemCd"))
mstrShortStc       = ConvIStringToArray(Request("shortStc"))
mstrAllResultClear = Request("allResultClear")

'Step3で設定された引数値の取得
mstrOverWrite = Request("overWrite")
mstrRsvNo     = ConvIStringToArray(Request("rsvNo"))
mstrSelectFlg = ConvIStringToArray(Request("selectFlg"))

'コードが渡されていない場合
If mstrGrpCd = "" Then

	'オブジェクトのインスタンス作成
	Set objWorkStation = Server.CreateObject("HainsWorkStation.WorkStation")

	'規定のグループコード取得
	If objWorkStation.SelectWorkstation(strIPAddress, strWkstnName, strWkstnGrpCd, strWkstnGrpName) = True Then
		mstrGrpCd = strWkstnGrpCd
	End If

End If

Do
	'各ステップごとのチェック・更新処理制御
	Select Case mstrStep

		'受診日・グループ指定
		Case "1"

			'デフォルト値の設定
			mlngYear  = IIf(mlngYear  = 0, CLng(Year(Now)),  mlngYear )
			mlngMonth = IIf(mlngMonth = 0, CLng(Month(Now)), mlngMonth)
			mlngDay   = IIf(mlngDay   = 0, CLng(Day(Now)),   mlngDay  )

			'「次へ」ボタンが押されていない場合は処理を抜ける
			If IsEmpty(Request("step2.x")) Then
				Exit Do
			End If

			'入力チェック
			strArrMessage = objResult.CheckRslAllSet1Value(mlngYear, mlngMonth, mlngDay, mstrCslDate, mstrDayIdF, mstrDayIdT)

			'チェックエラー時は処理を抜ける
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'受診情報存在チェック
			If CheckConsult() <= 0 Then
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'				strArrMessage = Array("指定検査グループの検査を受診している受診者が存在しません。")
				strArrMessage = Array("指定検査グループの検査を受診している来院済み受診者が存在しません。")
'## 2004.01.09 Mod End
				Exit Do
			End If

			'次画面へ遷移
			mstrStep = "2"
			Exit Do

		'一括結果値入力
		Case "2"

			'「次へ」「保存」以外は処理を抜ける
			If mstrAction <> "next" And mstrAction <> "save" Then
				Exit Do
			End If

			'受診情報存在チェック
			If CheckConsult() <= 0 Then
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'				strArrMessage = Array("指定検査グループの検査を受診している受診者が存在しません。")
				strArrMessage = Array("指定検査グループの検査を受診している来院済み受診者が存在しません。")
'## 2004.01.09 Mod End
				Exit Do
			End If

			'結果入力チェック
			strArrMessage = objResult.CheckResult(mstrCslDate, mstrItemCd, mstrSuffix, mstrResult, mstrShortStc, mstrResultErr)
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'「次へ」の場合は例外者指定画面へ遷移
			If mstrAction = "next" Then
				mstrStep = "3"
				Exit Do
			End If

			'検査結果更新
			lngWkStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
			lngWkEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

			'オブジェクトのインスタンス作成
			Set mobjConsult = CreateObject("HainsConsult.Consult")
    
			'更新対象となる受診情報を読み込む
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'			lngAllUpdCount = mobjConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngWkStrDayId, lngWkEndDayId, mstrGrpCd, , , , , , , , strAllUpdRsvNo)
			'来院済み受診者のみ対象
			lngAllUpdCount = mobjConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngWkStrDayId, lngWkEndDayId, mstrGrpCd, , , , , , , , strAllUpdRsvNo, , , , , , , , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

			Set mobjConsult = Nothing

			'検査結果一括更新
			IF lngAllUpdCount > 0 Then
				objResult.UpdateResultAll strUpdUser, strIPAddress, mstrAllResultClear, "", strAllUpdRsvNo, mstrItemCd, mstrSuffix, mstrResult
			End If

			'次画面へ遷移
			mlngUpdCount = 1
			mstrStep = "4"

		'例外者入力
		Case "3"

			'更新対象者と例外者に振り分ける
			For lngRsvNoIndex = 0 To UBound(mstrRsvNo)
				If mstrSelectFlg(lngRsvNoIndex) = "1" Then
					If mlngOutCount = 0 Then
						mstrOutRsvNo = Array()
					End If
					ReDim Preserve mstrOutRsvNo(mlngOutCount)
					mstrOutRsvNo(mlngOutCount) = mstrRsvNo(lngRsvNoIndex)
					mlngOutCount = mlngOutCount + 1
				Else
					If lngAllUpdCount = 0 Then
						strAllUpdRsvNo = Array()
					End If
					ReDim Preserve strAllUpdRsvNo(lngAllUpdCount)
					strAllUpdRsvNo(lngAllUpdCount) = mstrRsvNo(lngRsvNoIndex)
					lngAllUpdCount = lngAllUpdCount + 1
				End If
			Next

			'更新者が存在すれば検査結果一括更新
			If lngAllUpdCount > 0 Then
				mlngUpdCount = objResult.UpdateResultAll(strUpdUser, strIPAddress, mstrAllResultClear, mstrOverWrite, strAllUpdRsvNo, mstrItemCd, mstrSuffix, mstrResult)
			End If

			'次画面へ遷移
			mstrStep = "4"

	End Select

	Exit Do
Loop

'各ステップ値ごとの表示ASP制御
Select Case mstrStep

	'受診日・グループ指定
	Case "1"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep1.asp" -->
<%
	'一括結果値入力
	Case "2"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep2.asp" -->
<%
	'例外者入力
	Case "3"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep3.asp" -->
<%
	'入力完了
	Case "4"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep4.asp" -->
<%
End Select

'-------------------------------------------------------------------------------
'
' 機能　　 : 指定グループ内検査項目受診者の存在チェック
'
' 引数　　 :
'
' 戻り値　 : 受診者数
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckConsult()

	Dim objConsult	'受診情報アクセス用COMオブジェクト

	Dim lngStrDayId	'開始当日ID
	Dim lngEndDayId	'終了当日ID

	'オブジェクトのインスタンス作成
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'当日IDの編集
	lngStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
	lngEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

	'受診情報存在チェック
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'	CheckConsult = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd)
	'来院済み受診者のみ対象
	CheckConsult = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

End Function
%>
