<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　対処行動・社会的支援チェック画面表示用(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------

'画面表示文言
Private aryQuestion
Private aryAnswer

aryQuestion = Array("１．趣味や娯楽を楽しむ", _
					"２．感情的にならないように、客観的に状況を処理する", _
					"３．効率よく時間を使う", _
					"４．理解ある友人に話をする" , _
					"５．前もって計画する" , _
					"６．仕事以外の興味や活動を広げる", _
					"７．特定の問題に集中する", _
					"８．ある問題を優先して処理する" , _
					"９．その場から離れて、状況を考える" , _
					"１０．人からの援助をできるだけ活用する" )

aryAnswer = Array("１．絶対使わない", _
				"２．めったに使わない", _
				"３．概ね使わない", _
				"４．概ね使う", _
				"５．よく使う", _
				"６．非常によく使う" )

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

%>