<%
'-----------------------------------------------------------------------------
'		自覚症状　表示 Include File (Ver0.0.1)
'		AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const JIKAKUSHOUJYOU_COUNT  = 6		'自覚症状の件数

'-------------------------------------------------------------------------------
'ドロップダウンリスト（固定値）
'-------------------------------------------------------------------------------
Dim strArrCodeJikaku1			'自覚症状内容（コード）
Dim strArrNameJikaku1			'自覚症状内容（名称）
Dim strArrCodeJikaku2			'数値（コード）
Dim strArrNameJikaku2			'数値（名称）
Dim strArrCodeJikaku3			'単位（コード）
Dim strArrNameJikaku3			'単位（名称）
Dim strArrCodeJikaku4			'受診（コード）
Dim strArrNameJikaku4			'受診（名称）

'*** 自覚症状内容 ***
'### (2004/10/19)張修正：自覚症状の文章コード追加による項目追加 ###
'strArrCodeJikaku1 = Array( _
'					"1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
'					"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
'					"21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
'					"31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
'					"41", "42", "43", "44" _
'					)
'strArrNameJikaku1 = Array( _
'					"体重増加", "体重減少", "頭痛", "胸痛", "背部痛", "上腹部痛", "下腹部痛", "側腹部痛", "腰痛", "関節痛", _
'					"動悸", "不整脈の自覚", "めまい", "食欲低下", "便秘", "下痢", "便通異常", "排便時の出血", "胃の調子が悪い", "口渇感", _
'					"息切れ", "耳鳴り", "手足のしびれ", "手指のふるえ", "多汗", "むくみ", "排尿困難", "尿失禁", "月経不順", "月経痛", _
'					"不正出血", "立ちくらみ", "肩こり", "眼精疲労", "聴力低下", "眼精疲労", "視力低下", "睡眠障害", "倦怠感", "焦燥感", _
'					"不安感", "抑うつ気分", "意欲低下", "仕事能力低下" _
'					)

strArrCodeJikaku1 = Array( _
					"1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
					"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
					"21", "45", "46", "47", "48", "49", "22", "23", "24", "25", _
					"26", "27", "28", "50", "51", "29", "30", "31", "52", "53", _
					"54", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
					"41", "42", "43", "44", "55" _
					)
strArrNameJikaku1 = Array( _
					"体重増加", "体重減少", "頭痛", "胸痛", "背部痛", "上腹部痛", "下腹部痛", "側腹部痛", "腰痛", "関節痛", _
					"動悸", "不整脈の自覚", "めまい", "食欲低下", "便秘", "下痢", "便通異常", "排便時の出血", "胃の調子が悪い", "口渇感", _
					"息切れ", "いびき", "咳がでる", "痰がでる", "咽頭痛", "鼻汁", "耳鳴り", "手足のしびれ", "手指のふるえ", "多汗", _
					"むくみ", "排尿困難", "尿失禁", "頻尿", "尿の出が悪い", "月経不順", "月経痛", "不正出血", "更年期と思われる症状", "乳房の痛み", _
					"乳房のしこり", "立ちくらみ", "肩こり", "眼精疲労", "聴力低下", "眼精疲労", "視力低下", "睡眠障害", "倦怠感", "焦燥感", _
					"不安感", "抑うつ気分", "意欲低下", "仕事能力低下", "物忘れ" _
					)

'*** 数値 ***
strArrCodeJikaku2 = Array( "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" )
strArrNameJikaku2 = Array( "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" )

'*** 単位 ***
strArrCodeJikaku3 = Array( "1", "2", "3", "4", "5" )
strArrNameJikaku3 = Array( "時間前", "日前", "週間前", "ヶ月前", "年前" )

'*** 受診 ***
strArrCodeJikaku4 = Array( "1", "2" )
strArrNameJikaku4 = Array( "受診", "未受診" )

'-------------------------------------------------------------------------------
'
' 機能　　 : 自覚症状のTABLEタグ生成
'
' 引数　　 : (In)     lngStartIndex     検査結果の先頭位置
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditJikakushoujyou( lngStartIndex )
	Dim lngIndex			'インデックス
	Dim strHTML				'HTML文字列
	Dim i, j				'カウンター


	'TABLEタグ生成
	strHTML = ""
	strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPACING=""2"" CELLPADDING=""1"">" & vbLf
	strHTML = strHTML & "<TR>" & vbLf
	strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">自覚症状内容</TD>" & vbLf
	strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">数値</TD>" & vbLf
	strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">単位</TD>" & vbLf
	strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">受診</TD>" & vbLf
	strHTML = strHTML & "</TR>" & vbLf
	For i=0 To JIKAKUSHOUJYOU_COUNT - 1
		strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

		lngIndex = lngStartIndex + 0 + i*4
		strHTML = strHTML & "<TD NOWRAP>" & vbLf
		strHTML = strHTML & EditDropDownListFromArray2("listjikaku1", strArrCodeJikaku1, strArrNameJikaku1, vntResult(lngIndex), NON_SELECTED_ADD, "javascript:document.entryForm.ChgRsl[" & lngIndex & "].value = this.value") & vbLf
		strHTML = strHTML & "</TD>" & vbLf

		lngIndex = lngStartIndex + 1 + i*4
		strHTML = strHTML & "<TD NOWRAP>" & vbLf
'		strHTML = strHTML & EditDropDownListFromArray2("listjikaku2", strArrCodeJikaku2, strArrNameJikaku2, vntResult(lngIndex), NON_SELECTED_ADD, "javascript:document.entryForm.ChgRsl[" & lngIndex & "].value = this.value") & vbLf
		strHTML = strHTML & EditSelectNumberList2("listjikaku2", 1, 12, CLng("0" & vntResult(lngIndex)), "javascript:document.entryForm.ChgRsl[" & lngIndex & "].value = this.value") & vbLf
		strHTML = strHTML & "</TD>" & vbLf

		lngIndex = lngStartIndex + 2 + i*4
		strHTML = strHTML & "<TD NOWRAP>" & vbLf
		strHTML = strHTML & EditDropDownListFromArray2("listjikaku3", strArrCodeJikaku3, strArrNameJikaku3, vntResult(lngIndex), NON_SELECTED_ADD, "javascript:document.entryForm.ChgRsl[" & lngIndex & "].value = this.value") & vbLf
		strHTML = strHTML & "</TD>" & vbLf

		lngIndex = lngStartIndex + 3 + i*4
		strHTML = strHTML & "<TD NOWRAP>" & vbLf
		strHTML = strHTML & EditDropDownListFromArray2("listjikaku4", strArrCodeJikaku4, strArrNameJikaku4, vntResult(lngIndex), NON_SELECTED_ADD, "javascript:document.entryForm.ChgRsl[" & lngIndex & "].value = this.value") & vbLf
		strHTML = strHTML & "</TD>" & vbLf

		strHTML = strHTML & "</TR>" & vbLf
	Next
	strHTML = strHTML & "</TABLE>" & vbLf
	Response.Write strHTML

End Sub
%>
