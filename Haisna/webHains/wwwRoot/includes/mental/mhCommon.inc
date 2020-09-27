<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　共通(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------


'スタイルシートファイル
Const MH_StyleSheet = "/webhains/contents/css/MentalHealth.css"

'画像パス
Const MH_ImagePath = "/webhains/images/mental/"

'トップパス
Const MH_TopPath = "user.html"

'トータル頁数
Const MH_TotalPage = 12

'回答拒否文言
Const MH_RefusalText1 = "原則的に全項目必須入力ですがどうしても入力したくない項目が存在する場合、入力可能な"
Const MH_RefusalText2 = "項目のみ入力した上で、以下のチェックボックスをチェックし、次頁へ進んでください"
Const MH_RefusalText3 = "入力したくない項目が存在します"

'アクション区分
Const MH_Mode_Fast = 0			'初期遷移時
Const MH_Mode_Back = 1			'戻るボタン
Const MH_Mode_Next = 2			'次へボタン
Const MH_Mode_Clear = 3			'クリアボタン
Const MH_Mode_Result = 4		'総合評価ボタン
Const MH_Mode_Comment = 5		'コメントボタン
Const MH_Mode_Regist = 6		'登録ボタン
Const MH_Mode_End = 7			'終了ボタン
Const MH_Mode_Change = 8		'変更ボタン

'-------------------------------------------------------------------------------
'
' 機能　　 : ログインチェック
'
' 引数　　 : lngRsvNo	予約番号（チェック用）
'
' 戻り値　 : True   正常
' 　　　　 : False  異常
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function LoginCheck(lngRsvNo)

	LoginCheck = True

	'予約番号チェック
	If IsNumeric(lngRsvNo) Then
		If Session("RsvNo") <> CLng(lngRsvNo) Then
			Session("ErrorMsg1") = "画面を表示できませんでした"
			Session("ErrorMsg2") = "再度、ログインを行なってください"
			LoginCheck = False
		End If
	Else
		Session("ErrorMsg1") = "画面を表示できませんでした"
		Session("ErrorMsg2") = "再度、ログインを行なってください"
		LoginCheck = False
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : セッション情報より更新用配列を作成
'
' 引数　　 : (Out)    vntQuestion   設問配列
' 　　　　   (Out)    vntAnswer     回答配列
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function SetUpdateArray(vntQuestion(), vntAnswer())
	Dim i,j,k
	Dim iArrCnt
	Dim iMaxQuestion
	Dim iMaxItem

	iArrCnt = 0

	'登録可能区分
	ReDim Preserve vntQuestion(iArrCnt)
	ReDim Preserve vntAnswer(iArrCnt)
	vntQuestion(iArrCnt) = "RegPermission"
	vntAnswer(iArrCnt) = "2"
	iArrCnt = iArrCnt + 1

	'回答拒否区分
	For i = 1 To 12
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Refusal" & i
		vntAnswer(iArrCnt) = Session("Refusal" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目１
	For i = 1 To 16
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q1-" & i
		vntAnswer(iArrCnt) = Session("Q1-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目２
	For i = 1 To 11
		For j = 1 To 3
			ReDim Preserve vntQuestion(iArrCnt)
			ReDim Preserve vntAnswer(iArrCnt)
			vntQuestion(iArrCnt) = "Q2-" & i & "-" & j
			vntAnswer(iArrCnt) = Session("Q2-" & i & "-" & j)
			iArrCnt = iArrCnt + 1
		Next
	Next

	'項目３
	For i = 1 To 46
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q3-" & i
		vntAnswer(iArrCnt) = Session("Q3-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目４
	For i = 1 To 12
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q4-" & i
		vntAnswer(iArrCnt) = Session("Q4-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目５
	For i = 1 To 4
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q5-" & i
		vntAnswer(iArrCnt) = Session("Q5-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目６
	For i = 1 To 18
		If i = 2 Then
			For j = 1 To 3
				ReDim Preserve vntQuestion(iArrCnt)
				ReDim Preserve vntAnswer(iArrCnt)
				vntQuestion(iArrCnt) = "Q6-" & i & "-" & j
				vntAnswer(iArrCnt) = Session("Q6-" & i & "-" & j)
				iArrCnt = iArrCnt + 1
			Next
		Else
			ReDim Preserve vntQuestion(iArrCnt)
			ReDim Preserve vntAnswer(iArrCnt)
			vntQuestion(iArrCnt) = "Q6-" & i
			vntAnswer(iArrCnt) = Session("Q6-" & i)
			iArrCnt = iArrCnt + 1
		End If
	Next

	'項目７
	For i = 1 To 17
		'MAX回答欄数設定
		iMaxQuestion = 0
		iMaxItem = 0
		Select case i
			Case 11
				iMaxQuestion = 2
				iMaxItem = 5
			Case 13,14
				iMaxQuestion = 2
				iMaxItem = 3
			Case 15
				iMaxQuestion = 5
				iMaxItem = 2
		End Select

		If iMaxQuestion > 0 Then
			'１つの設問に複数回答欄のある場合
			For j = 1 To iMaxQuestion
				For k = 1 To iMaxItem
					ReDim Preserve vntQuestion(iArrCnt)
					ReDim Preserve vntAnswer(iArrCnt)
					vntQuestion(iArrCnt) = "Q7-" & i & "-" & j & "-" & k
					vntAnswer(iArrCnt) = Session("Q7-" & i & "-" & j & "-" & k)
					iArrCnt = iArrCnt + 1
				Next
			Next
		Else
			ReDim Preserve vntQuestion(iArrCnt)
			ReDim Preserve vntAnswer(iArrCnt)
			vntQuestion(iArrCnt) = "Q7-" & i
			vntAnswer(iArrCnt) = Session("Q7-" & i)
			iArrCnt = iArrCnt + 1
		End If
	Next

	'項目８
	For i = 1 To 3
		For j = 1 To 2
			ReDim Preserve vntQuestion(iArrCnt)
			ReDim Preserve vntAnswer(iArrCnt)
			vntQuestion(iArrCnt) = "Q8-" & i & "-" & j
			vntAnswer(iArrCnt) = Session("Q8-" & i & "-" & j)
			iArrCnt = iArrCnt + 1
		Next
	Next

	'項目９
	ReDim Preserve vntQuestion(iArrCnt)
	ReDim Preserve vntAnswer(iArrCnt)
	vntQuestion(iArrCnt) = "Q9-1"
	vntAnswer(iArrCnt) = Session("Q9-1")
	iArrCnt = iArrCnt + 1
	For i = 1 To 39
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q9-2-" & i
		vntAnswer(iArrCnt) = Session("Q9-2-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目１０
	For i = 1 To 6
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q10-" & i
		vntAnswer(iArrCnt) = Session("Q10-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目１１
	For i = 1 To 39
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q11-" & i
		vntAnswer(iArrCnt) = Session("Q11-" & i)
		iArrCnt = iArrCnt + 1
	Next

	'項目１２
	For i = 1 To 10
		ReDim Preserve vntQuestion(iArrCnt)
		ReDim Preserve vntAnswer(iArrCnt)
		vntQuestion(iArrCnt) = "Q12-" & i
		vntAnswer(iArrCnt) = Session("Q12-" & i)
		iArrCnt = iArrCnt + 1
	Next

	SetUpdateArray = True

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : セッション情報をクリア
'
' 引数　　 :
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function ClearSession()
	Dim i,j,k
	Dim iMaxQuestion
	Dim iMaxItem

	Session.Contents.Remove("LoginDiv")
	Session.Contents.Remove("RsvNo")
	Session.Contents.Remove("PerID")
	Session.Contents.Remove("LastName")
	Session.Contents.Remove("FirstName")
	Session.Contents.Remove("Gender")
	Session.Contents.Remove("Birth")
	Session.Contents.Remove("Weight")
	Session.Contents.Remove("BMI")
	Session.Contents.Remove("ErrorMsg1")
	Session.Contents.Remove("ErrorMsg2")
	Session.Contents.Remove("FromAsp")
	Session.Contents.Remove("RegPermission")

	'回答拒否区分
	For i = 1 To 12
		Session.Contents.Remove("Refusal" & i)
	Next

	'項目１
	For i = 1 To 16
		Session.Contents.Remove("Q1-" & i)
	Next

	'項目２
	For i = 1 To 11
		For j = 1 To 3
			Session.Contents.Remove("Q2-" & i & "-" & j)
		Next
	Next

	'項目３
	For i = 1 To 46
		Session.Contents.Remove("Q3-" & i)
	Next

	'項目４
	For i = 1 To 12
		Session.Contents.Remove("Q4-" & i)
	Next

	'項目５
	For i = 1 To 4
		Session.Contents.Remove("Q5-" & i)
	Next

	'項目６
	For i = 1 To 18
		If i = 2 Then
			For j = 1 To 3
				Session.Contents.Remove("Q6-" & i & "-" & j)
			Next
		Else
			Session.Contents.Remove("Q6-" & i)
		End If
	Next

	'項目７
	For i = 1 To 17
		'MAX回答欄数設定
		iMaxQuestion = 0
		iMaxItem = 0
		Select case i
			Case 11
				iMaxQuestion = 2
				iMaxItem = 5
			Case 13,14
				iMaxQuestion = 2
				iMaxItem = 3
			Case 15
				iMaxQuestion = 5
				iMaxItem = 2
		End Select

		If iMaxQuestion > 0 Then
			'１つの設問に複数回答欄のある場合
			For j = 1 To iMaxQuestion
				For k = 1 To iMaxItem
					Session.Contents.Remove("Q7-" & i & "-" & j & "-" & k)
				Next
			Next
		Else
			Session.Contents.Remove("Q7-" & i)
		End If
	Next

	'項目８
	For i = 1 To 3
		For j = 1 To 2
			Session.Contents.Remove("Q8-" & i & "-" & j)
		Next
	Next

	'項目９
	Session.Contents.Remove("Q9-1")

	For i = 1 To 39
		Session.Contents.Remove("Q9-2-" & i)
	Next

	'項目１０
	For i = 1 To 6
		Session.Contents.Remove("Q10-" & i)
	Next

	'項目１１
	For i = 1 To 39
		Session.Contents.Remove("Q11-" & i)
	Next

	'項目１２
	For i = 1 To 10
		Session.Contents.Remove("Q12-" & i)
	Next

	ClearSession = True

End Function

%>
