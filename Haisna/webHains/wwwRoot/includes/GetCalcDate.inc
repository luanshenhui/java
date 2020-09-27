<% 
'--------------------------------------------------------------------------------------
'		共通関数(計上日の取得) (Ver0.0.1)
'		AUTHER  : M.Gouda@FSIT
'--------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------
'
' 機能　　 : 計上日の取得
'
' 引数　　 : (In)  strCheckPaymentYear  : 入金(返金)日の年
'            (In)  strCheckPaymentMonth : 入金(返金)日の月
'            (In)  strCheckPaymentMonth : 入金(返金)日の日
'            (Out) strWorkCalcDateYear  : 計上日の年
'            (Out) strWorkCalcDateMonth : 計上日の月
'            (Out) strWorkCalcDateDay   : 計上日の日
'            (In)  strWorkCloseDate     : 締め日
'
' 戻り値　 : 
'
' 備考　　 : 締め日の次の日を計上日とする
'            但し、次の日が休診日・祝日の場合は、休み明けの最初の営業日を計上日とする
'
'--------------------------------------------------------------------------------------
Sub GetCalcDate(strCheckPaymentYear, strCheckPaymentMonth, strCheckPaymentDay, _
				strWorkCalcDateYear, strWorkCalcDateMonth, strWorkCalcDateDay, _
				strWorkCloseDate) 

	Dim strWorkCalcDate			'計上日
	Dim strCheckPaymentDate		'入金(返金)日
	Dim strEndDate				'取得する休診日・祝日の最終日
	Dim vntArrCslDate			'休診日・祝日
	Dim vntArrHoliday			'表示モード(1:休診日、2:祝日)
	Dim lngCount				'休診日・祝日の日数
	Dim j						'カウント

	Dim objSchedule			'スケジュールアクセス用COMオブジェクト

	'計上日の引数値が存在した場合	
	If strWorkCalcDateYear <> "" Then Exit Sub

	'日次締め日が日付として判断できなかった場合
	If IsDate(strWorkCloseDate) = False Then

		strWorkCalcDateYear  = strCheckPaymentYear
		strWorkCalcDateMonth = strCheckPaymentMonth
		strWorkCalcDateDay   = strCheckPaymentDay

		Exit Sub
	End If

	'入金(返金)日の編集
	strCheckPaymentDate = CDate(strCheckPaymentYear & "/" & strCheckPaymentMonth & "/" & strCheckPaymentDay)

	'日次締め日が入金(返金)日より過去の場合
	If Trim(strCheckPaymentDate) > Trim(strWorkCloseDate) Then

		'入金(返金)日をセット
		strWorkCalcDateYear  = strCheckPaymentYear
		strWorkCalcDateMonth = strCheckPaymentMonth
		strWorkCalcDateDay   = strCheckPaymentDay
		
		Exit Sub
	End If

	'締め日に1日加算した日付を計上日に設定する						
	strWorkCalcDate = DateAdd("d", 1, strWorkCloseDate)	

	'スケジュールアクセス用COMオブジェクトの割り当て
	Set objSchedule = CreateObject("HainsSchedule.Schedule")

	'休診日・祝日の取得期間を6ヶ月にセット
	strEndDate = DateAdd("m", 6, strWorkCalcDate)
		
	'指定期間の病院スケジューリング情報を取得する
	lngCount = objSchedule.SelectSchedule_h(strWorkCalcDate, strEndDate, vntArrCslDate, vntArrHoliday)
	
	'締め日の次の日が休診日・祝日の場合、計上日は休診日・祝日明けの最初の営業日に設定する
	j = 0
	
	Do

		'計上日と休診日・祝日が同じ日の場合		
		If Trim(strWorkCalcDate) = Trim(vntArrCslDate(j)) Then

			strWorkCalcDate = DateAdd("d", 1, strWorkCalcDate)	
			j = j + 1

		Else

			'計上日をセット	
			strWorkCalcDateYear  = CStr(Year(strWorkCalcDate))
			strWorkCalcDateMonth = CStr(Month(strWorkCalcDate))
			strWorkCalcDateDay   = CStr(Day(strWorkCalcDate))
			Exit Do

		End If 
	Loop

	Set objSchedule = Nothing

End Sub

%>