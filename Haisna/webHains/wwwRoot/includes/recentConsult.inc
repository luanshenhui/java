<%
'-----------------------------------------------------------------------------
'		指定受診日の近範囲受診歴検索用関数 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Const RECENTCONSULT_RANGE_OF_MONTH = 3	'本値(単位はヶ月)以内に受診情報が存在する場合、ワーニング対象とする

'-------------------------------------------------------------------------------
'
' 機能　　 : 指定年月の受診情報、翌月以降で最古の受診情報、前月以前で最新の受診情報を取得
'
' 引数　　 : (In)     strPerId     個人ＩＤ
' 　　　　   (In)     lngCslYear   年
' 　　　　   (In)     lngCslMonth  月
' 　　　　   (In)     strCurRsvNo  (取得対象から除くべき)現在の予約番号
' 　　　　   (Out)    strCslDate   受診日
' 　　　　   (Out)    strRsvNo     予約番号
'
' 戻り値　 :
'
' 備考　　 : ドック・定期健診以外のコースは取得対象外
'
'-------------------------------------------------------------------------------
Sub RecentConsult_GetRecentConsultHistory(strPerId, lngCslYear, lngCslMonth, strCurRsvNo, strCslDate, strRsvNo)

	Dim objConsult				'受診情報アクセス用

	Dim strHistoryRsvNo			'受診情報の予約番号
	Dim strHistoryCslDate		'受診情報の受診日
	Dim strHistoryCsCd			'受診情報のコースコード
	Dim lngCount				'受診情報数

	Dim dtmFirstDayOfNextMonth	'翌月の初日
	Dim dtmLastDayOfPrevMonth	'前月の末日

	Dim dtmCslDateOfNextMonth	'翌月以降で最古の受診日
	Dim strRsvNoOfNextMonth		'翌月以降で最古の受診日をもつ受診情報の予約番号
	Dim dtmCslDateOfLastMonth	'前月以前で最新の受診日
	Dim strRsvNoOfLastMonth		'前月以前で最新の受診日をもつ受診情報の予約番号
	Dim dtmCslDateOfCurMonth()	'指定年月の受診日配列
	Dim strRsvNoOfCurMonth()	'指定年月の予約番号配列
	Dim lngCurCslCount			'指定年月の受診日配列要素数

	Dim strArrCslDate()			'戻り値として返すべき受診日
	Dim strArrRsvNo()			'戻り値として返すべき予約番号
	Dim lngCslCount				'戻り値として返すべき受診日の数

	Dim dtmDate					'日付ワーク
	Dim i						'インデックス

	strCslDate = Empty
	strRsvNo   = Empty

	'初期設定
	dtmDate = CDate(lngCslYear & "/" & lngCslMonth & "/1")
	dtmFirstDayOfNextMonth = DateAdd("m", 1, dtmDate)
	dtmLastDayOfPrevMonth  = dtmDate - 1

	'オブジェクトのインスタンス作成
	Set objConsult = CreateObject("HainsConsult.Consult")

	'受診情報読み込み
	lngCount = objConsult.SelectConsultHistory(strPerId, , , , , strHistoryRsvNo, strHistoryCslDate, strHistoryCsCd)

	'オブジェクトの解放
	Set objConsult = Nothing

	'受診情報の検索(上記メソッドにて受診日の降順に取得されているため、これを考慮したロジック)
	For i = 0 To lngCount - 1

		Do

			'ドック、定期健診のみを検索対象とする
			Select Case strHistoryCsCd(i)
				Case "100", "110"
				Case Else
					Exit Do
			End Select

			'指定予約番号の受診情報は除外
			If strCurRsvNo <> "" Then
				If CLng(strHistoryRsvNo(i)) = CLng(strCurRsvNo) Then
					Exit Do
				End If
			End If

			'Date型による比較を行うため日付ワークに代入
			dtmDate = CDate(strHistoryCslDate(i))

			'受診日の判定
			Select Case True

				'翌月以降の受診日であれば
				Case dtmDate >= dtmFirstDayOfNextMonth

					'翌月以降で最古の受診日値を更新(受診日の降順に検索するため、発生する度に値を更新)
					dtmCslDateOfNextMonth = dtmDate
					strRsvNoOfNextMonth   = strHistoryRsvNo(i)

				'前月以前の受診日であれば
				Case dtmDate <= dtmLastDayOfPrevMonth

					'前月以前で最新の受診日値を更新
					dtmCslDateOfLastMonth = dtmDate
					strRsvNoOfLastMonth   = strHistoryRsvNo(i)

					'一度前月以前で最新の受診日値が得られれば、受診日の降順に検索することから以降の検索は不要。
					Exit For

				'指定年月の受診日であれば
				Case Else

					ReDim Preserve dtmCslDateOfCurMonth(lngCurCslCount)
					ReDim Preserve strRsvNoOfCurMonth(lngCurCslCount)
					dtmCslDateOfCurMonth(lngCurCslCount) = dtmDate
					strRsvNoOfCurMonth(lngCurCslCount)   = strHistoryRsvNo(i)
					lngCurCslCount = lngCurCslCount + 1

			End Select

			Exit Do
		Loop

	Next

	'戻り値として返すべき受診日の編集開始

	'翌月以降で最古の受診日
	If Not IsEmpty(dtmCslDateOfNextMonth) Then
		ReDim Preserve strArrCslDate(lngCslCount)
		ReDim Preserve strArrRsvNo(lngCslCount)
		strArrCslDate(lngCslCount) = CStr(dtmCslDateOfNextMonth)
		strArrRsvNo(lngCslCount)   = strRsvNoOfNextMonth
		lngCslCount = lngCslCount + 1
	End If

	'指定年月の受診日
	For i = 0 To lngCurCslCount - 1
		ReDim Preserve strArrCslDate(lngCslCount)
		ReDim Preserve strArrRsvNo(lngCslCount)
		strArrCslDate(lngCslCount) = CStr(dtmCslDateOfCurMonth(i))
		strArrRsvNo(lngCslCount)   = strRsvNoOfCurMonth(i)
		lngCslCount = lngCslCount + 1
	Next

	'前月以前で最新の受診日
	If Not IsEmpty(dtmCslDateOfLastMonth) Then
		ReDim Preserve strArrCslDate(lngCslCount)
		ReDim Preserve strArrRsvNo(lngCslCount)
		strArrCslDate(lngCslCount) = CStr(dtmCslDateOfLastMonth)
		strArrRsvNo(lngCslCount)   = strRsvNoOfLastMonth
		lngCslCount = lngCslCount + 1
	End If

	'戻り値の設定
	If lngCslCount > 0 Then
		strCslDate = strArrCslDate
		strRsvNo   = strArrRsvNo
	End If

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 指定受診日にて保存する際、ワーニング対象となる受診情報が存在するかを判定
'
' 引数　　 : (In)     strPerId    個人ＩＤ
' 　　　　   (In)     strCslDate  保存したい受診日
' 　　　　   (In)     strCsCd     保存したいコースコード
' 　　　　   (In)     strRsvNo    保存対象となる受診情報の予約番号
'
' 戻り値　 : ワーニング対象となる受診情報存在時、メッセージを返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function RecentConsult_CheckRecentConsult(strPerId, strCslDate, strCsCd, strRsvNo)

	Dim objConsult			'受診情報アクセス用

	Dim strCurCslDate		'現在の受診日

	Dim strRecentCslDate	'近範囲の受診日情報
	Dim strRecentRsvNo		'近範囲の予約番号情報

	Dim dtmMinCslDate		'指定受診日の指定月数前の受診日
	Dim dtmMaxCslDate		'指定受診日の指定月数後の受診日

	Dim dtmDate				'日付ワーク
	Dim dtmRecentCslDate	'近範囲の受診日

	Dim strWarnCslDate()	'ワーニング対象となる受診日
	Dim lngWarnCount		'ワーニング対象となる受診日の数

	Dim Ret					'関数戻り値
	Dim i					'インデックス

	'初期設定
	dtmDate = CDate(strCslDate)

	'ドック、定期健診を除くコースの場合はチェック非対象
	Select Case strCsCd
		Case "100", "110"
		Case Else
			Exit Function
	End Select

	'予約番号指定時
	If strRsvNo <> "" Then

		'オブジェクトのインスタンス作成
		Set objConsult = CreateObject("HainsConsult.Consult")

		'受診情報を読み、現在の受診日を取得
		Ret = objConsult.SelectConsult(strRsvNo, , strCurCslDate)

		'オブジェクトの解放
		Set objConsult = Nothing

		If Ret = False Then
			Exit Function
		End If

		'受診日に変更がない場合は対象外
		If CDate(strCurCslDate) = dtmDate Then
			Exit Function
		End If

	End If

	'指定年月の近範囲の受診日情報を取得
	Call RecentConsult_GetRecentConsultHistory(strPerId, Year(dtmDate), Month(dtmDate), strRsvNo, strRecentCslDate, strRecentRsvNo)
	If Not IsArray(strRecentCslDate) Then
		Exit Function
	End If

	'指定月数前の受診日、指定月数後の受診日を算出
	dtmMinCslDate = DateAdd("m", RECENTCONSULT_RANGE_OF_MONTH * -1, dtmDate)
	dtmMaxCslDate = DateAdd("m", RECENTCONSULT_RANGE_OF_MONTH,      dtmDate)

	'受診日を検索
	For i = UBound(strRecentCslDate) To 0 Step -1

		Do

			'予約番号指定時、指定された予約番号の受診情報は対象外
			If strRsvNo <> "" Then
				If CLng(strRecentRsvNo(i)) = CLng(strRsvNo) Then
					Exit Do
				End If
			End If

			dtmRecentCslDate = CDate(strRecentCslDate(i))

			'指定月数前の受診日、指定月数後の受診日の範囲外ならば対象外
			If dtmRecentCslDate < dtmMinCslDate Or dtmRecentCslDate > dtmMaxCslDate Then
				Exit Do
			End If

			'上記除外条件に該当しない場合はワーニング対象となる受診情報のため、スタック
			ReDim Preserve strWarnCslDate(lngWarnCount)
			strWarnCslDate(lngWarnCount) = Year(dtmRecentCslDate) & "年" & Month(dtmRecentCslDate) & "月" & Day(dtmRecentCslDate) & "日"
			lngWarnCount = lngWarnCount + 1

			Exit Do
		Loop

	Next

	'ワーニング対象となる受診日存在時はメッセージを返す
	If lngWarnCount > 0 Then
		RecentConsult_CheckRecentConsult = Join(strWarnCslDate, "、") & "にこの受診者の受診情報がすでに存在します。"
	End If

End Function
%>
