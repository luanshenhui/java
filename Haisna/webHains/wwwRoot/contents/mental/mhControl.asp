<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		メンタルヘルス　制御処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用
Dim objResult		'個人情報アクセス用
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim lngLockDiv
Dim lngMHCount
Dim lngCount
Dim strTarget		'画面遷移先
Dim arrQuestion()	'全質問項目名
Dim arrAnswer()		'全回答
Dim strErrMsg1
Dim strErrMsg2

'前画面から送信されるパラメータ値
Dim strCntlNo		'管理番号
Dim dtmCslDate		'受診日
Dim strDayId 		'当日ＩＤ
Dim intLoginDiv		'ログイン区分

'クライアント情報
Dim lngRsvNo		'予約番号
Dim strPerID		'個人ID
Dim strLastName		'名
Dim strFirstName	'氏
Dim dtmBirth		'生年月日
Dim lngGender		'性別
Dim intBMIValue		'肥満値
Dim intWeight		'体重

Dim strItemCd
Dim strResult
Dim emp1,emp2,emp3,emp4,emp5,emp6,emp7,emp8,emp9,emp10,emp11,emp12,emp13,emp14,emp15

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objResult = Server.CreateObject("HainsResult.Result")
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

'パラメータ値取得
intLoginDiv = Request("LOGINKBN")

Do

	If intLoginDiv = 0 Then
		'クライアントログイン
		strDayId  = Trim(Request("DAYID"))
		strCntlNo = Trim(Request("CNTLNO"))
		dtmCslDate = Trim(Request("CSLDATE"))
		strTarget = "mhConsulItem1.asp"

		'受診日・管理番号・当日IDをもとに予約番号を取得する
		'当日ＩＤチェック
		If Len(strDayId) <> 4 Then
			strErrMsg1 = "当日ＩＤが正しくありません"
			strErrMsg2 = "再度、ログインを行なってください"
			Exit Do
		End If
		'管理番号チェック
		If IsNull(strCntlNo) Or strCntlNo = "" Then
			'"0"固定
			strCntlNo = 0
		End If

		'受診日チェック
		If IsNull(dtmCslDate) Or dtmCslDate = "" Then
			'システム日付をセット
			dtmCslDate = FormatDateTime(Now(), vbShortDate)
		End If

		'受診日・管理番号・当日IDをもとに予約番号を取得する
		If objConsult.SelectConsultFromReceipt(dtmCslDate, strCntlNo, strDayId, lngRsvNo, , strPerID, strLastName, strFirstName, , ,dtmBirth, lngGender) = False Then
			strErrMsg1 = "予約番号の取得に失敗しました"
			strErrMsg2 = "申し訳ありませんが、サポート担当者までご連絡ください"
			Exit Do
		End If

		'クライアントロック区分取得
		lngLockDiv = objMentalHealth.SelectClientPermission(lngRsvNo)
		If lngLockDiv < 0 Then
			strErrMsg1 = "クライアントロック情報の取得に失敗しました"
			strErrMsg2 = "申し訳ありませんが、サポート担当者までご連絡ください"
			Exit Do
		ElseIf lngLockDiv = 2 And intLoginDiv = 0 Then
			strErrMsg1 = "現在、メンタルヘルス情報を参照・変更することはできません"
			strErrMsg2 = "メンタルヘルス情報を参照・変更したい場合は、担当医にご相談ください"
			Exit Do
		End If
	Else
		'ドクターログイン
		strTarget = "mhResult.asp"
		lngRsvNo = CLng(Request("RSVNO"))

		'予約番号をもとに個人情報を取得する
		If objMentalHealth.SelectPersonInfo(lngRsvNo,strPerID,strLastName,strFirstName,dtmBirth,lngGender) = False Then
			strErrMsg1 = "クライアント情報の取得に失敗しました"
			strErrMsg2 = "申し訳ありませんが、サポート担当者までご連絡ください"
			Exit Do
		End If
	End If


	'予約番号をもとにメンタルヘルス情報を取得する
	lngMHCount = objMentalHealth.SelectMentalHealth(lngRsvNo, arrQuestion, arrAnswer)
	If lngMHCount < 0 Then
		strErrMsg1 = "メンタルヘルス情報の取得に失敗しました"
		strErrMsg2 = "申し訳ありませんが、サポート担当者までご連絡ください"
		Exit Do
	ElseIf lngMHCount = 0 And intLoginDiv = 1 Then
		strErrMsg1 = "クライアントの入力が終了していない為、メンタルヘルス情報を参照・変更することはできません"
		strErrMsg2 = "クライアントの入力が終了してから、再度、ログインを行なってください"
		Exit Do
	End If

	'体重・肥満値取得
	intWeight = 0
	intBMIValue = 0
	lngCount = objResult.SelectRslList("", lngRsvNo, "Z100",emp1,emp2,emp3,strItemCd,emp4,emp5,strResult,emp6,emp7,emp8,emp9,emp10,emp11,emp12,emp13,emp14,emp15)

	If lngCount < 0 Then
		'エラー
		strErrMsg1 = "クライアント情報(体重・ＢＭＩ)の取得に失敗しました"
		strErrMsg2 = "申し訳ありませんが、サポート担当者までご連絡ください"
		Exit Do
	End If

	For i = 0 To lngCount - 1
		'体重・肥満値セット
		If strItemCd(i) = "001011" Then
			If IsNumeric(strResult(i)) Then
				intWeight = CDbl(strResult(i))
			Else
				strErrMsg1 = "身長・体重を先に計測してください"
				strErrMsg2 = ""
				Exit Do
			End If
		ElseIf strItemCd(i) = "001014" Then
			If IsNumeric(strResult(i)) Then
				intBMIValue = CDbl(strResult(i))
			Else
				strErrMsg1 = "身長・体重を先に計測してください"
				strErrMsg2 = ""
				Exit Do
			End If
		End If
	Next

	If intWeight = 0 Then
		strErrMsg1 = "身長・体重を先に計測してください"
		strErrMsg2 = ""
		Exit Do
	End If

	If intBMIValue = 0 Then
		strErrMsg1 = "身長・体重を先に計測してください"
		strErrMsg2 = ""
		Exit Do
	End If

	'既存セッション情報クリア
	If ClearSession() = False Then
	End if

	'セッションにセット
	Session("LoginDiv") = intLoginDiv
	Session("RsvNo") = lngRsvNo
	Session("PerID") = strPerID
	Session("LastName") = strLastName
	Session("FirstName") = strFirstName
	Session("Gender") = lngGender
	Session("Birth") = dtmBirth
	Session("Weight") = intWeight
	Session("BMI") = intBMIValue

	For i = 0 To lngMHCount - 1
		Session(arrQuestion(i)) = arrAnswer(i)
	Next

	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo
	Exit Do
Loop

'エラー画面表示
Session("ErrorMsg1") = strErrMsg1
Session("ErrorMsg2") = strErrMsg2
Response.Redirect "mhError.asp"
%>
