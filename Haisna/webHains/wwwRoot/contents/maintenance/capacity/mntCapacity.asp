<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠登録 (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc"  -->
<!-- #include virtual = "/webHains/includes/EditTimeFraList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction			'処理状態（保存ボタン押下時:"save"，保存完了後:"saveend"）
Dim lngYear				'受診開始年
Dim lngMonth			'受診開始月
Dim lngTimeFra			'時間枠
Dim strRsvFraCd			'予約枠コード

'フォーム情報（ＰＯＳＴ形式で送信される画面入力値）
Dim strEditYear			'編集年
Dim strEditMonth		'編集月
Dim strEditDay			'編集日
Dim strEndDay			'末日
Dim lngHoliday			'病院設定値（0:未設定，1:休診日，2:祝日）
Dim lngArrHoliday		'１日～末日の病院設定値（0:未設定，1:休診日，2:祝日）
Dim strEmptyCount		'予約設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
Dim strArrEmptyCount	'１日～末日の予約設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
Dim strCheckType		'時間枠管理されているか否かの判定（"":未設定，"0":終日管理，"1":時間枠管理）

'COMオブジェクト
Dim objSchedule			'スケジュールアクセス用COMオブジェクト
Dim objCommon			'共通関数アクセス用COMオブジェクト

'iniファイル読み込み
Dim strHolidayFlg		'休日・祝日に対する予約の許可

'予約枠データ読み込み
Dim strRsvFraName		'予約枠名称
Dim lngOverRsv			'枠人数オーバー登録
Dim lngFraType			'枠管理タイプ
Dim lngDefCnt0			'デフォルト人数（時間帯枠０）
Dim lngDefCnt1			'デフォルト人数（時間帯枠１）
Dim lngDefCnt2			'デフォルト人数（時間帯枠２）
Dim lngDefCnt3			'デフォルト人数（時間帯枠３）
Dim lngDefCnt4			'デフォルト人数（時間帯枠４）
Dim lngDefCnt5			'デフォルト人数（時間帯枠５）
Dim lngDefCnt6			'デフォルト人数（時間帯枠６）
Dim lngDefCnt7			'デフォルト人数（時間帯枠７）
Dim lngDefCnt8			'デフォルト人数（時間帯枠８）
Dim lngDefCnt9			'デフォルト人数（時間帯枠９）
Dim lngDefCnt			'デフォルト人数
Dim blnRetCd			'リターンコード

'スケジューリングデータ読み込み
Dim strStrDate			'読み込み開始日付
Dim strEndDate			'読み込み終了日付
Dim vntCslDate			'受診日
Dim vntHoliday			'休診日
Dim vntTimeFra			'時間枠
Dim vntRsvFraCd			'予約枠コード
Dim vntEmptyCount		'予約可能人数
Dim vntRsvCount			'予約済み人数
Dim lngCount			'レコード数

'入力チェック
Dim strArrMessage		'エラーメッセージ
Dim strArrMessage2		'警告メッセージ

Dim strClass			'CLASS属性編集用
Dim strURL				'ジャンプ先のURL
Dim i, j, k				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction   = Request("action") & ""
lngYear     = Request("year") & ""
lngYear     = CLng(IIf(lngYear = "", Year(Date), lngYear))
lngMonth    = Request("month") & ""
lngMonth    = CLng(IIf(lngMonth = "", Month(Date), lngMonth))
lngTimeFra  = Request("timeFra") & ""
lngTimeFra  = CLng(IIf(lngTimeFra = "", TIME_FRA_NON, lngTimeFra))
strRsvFraCd = Request("rsvFraCd") & ""

'初期設定
lngArrHoliday = Empty
strArrEmptyCount = Empty
strArrMessage = Empty
strArrMessage2 = Empty

'iniファイル読み込み（休日・祝日に対する予約の許可）
Set objCommon = Server.CreateObject("HainsCommon.Common")
strHolidayFlg = objCommon.SelectHolidayFlg
Set objCommon = Nothing

'スケジュールアクセス用COMオブジェクトの割り当て
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'チェック・更新・読み込み処理の制御
Do
	'事前処理
	If strRsvFraCd = "ALL" Then			'病院スケジューリング

		'時間枠の指定は無視
		lngTimeFra = CLng(TIME_FRA_NON)

	ElseIf strRsvFraCd <> "" Then		'予約スケジューリング

		'指定予約枠コードの予約枠情報を取得する
		blnRetCd = objSchedule.SelectRsvFra(strRsvFraCd, strRsvFraName, lngOverRsv, lngFraType, lngDefCnt0, lngDefCnt1, lngDefCnt2, lngDefCnt3, lngDefCnt4, lngDefCnt5, lngDefCnt6, lngDefCnt7, lngDefCnt8, lngDefCnt9)

		'読み込みエラー時は処理を抜ける
		If blnRetCd <> True Then
			strArrMessage = Array("引数で指定された予約枠コードが不正です。[" & strRsvFraCd & "]")
			strRsvFraCd = ""
			Exit Do
		End If

		'枠管理タイプがコース枠管理でない時（検査項目枠管理の時）、時間枠は「０：終日」のみ有効
		If lngFraType <> FRA_TYPE_CS Then
			'表示ボタン押下時、または保存完了後は、時間枠の指定は無視
			If strAction <> "save" Then
				lngTimeFra = CLng(TIME_FRA_NON)
			'保存ボタン押下時、時間枠は「０：終日」以外エラー
			Else
				If lngTimeFra <> TIME_FRA_NON Then
					strArrMessage = Array("処理中の予約枠「" & strRsvFraName & "」の枠管理タイプが検査項目枠管理に変更されました。")
					i = UBound(strArrMessage) + 1
					ReDim Preserve strArrMessage(i)
					strArrMessage(i) = "処理は中断されました。もう一度やり直して下さい。"
					strRsvFraCd = ""
					Exit Do
				End If
			End If
		End If

		'該当の時間枠のデフォルト人数
		Select	Case 	lngTimeFra
			Case 0
				lngDefCnt = lngDefCnt0
			Case 1
				lngDefCnt = lngDefCnt1
			Case 2
				lngDefCnt = lngDefCnt2
			Case 3
				lngDefCnt = lngDefCnt3
			Case 4
				lngDefCnt = lngDefCnt4
			Case 5
				lngDefCnt = lngDefCnt5
			Case 6
				lngDefCnt = lngDefCnt6
			Case 7
				lngDefCnt = lngDefCnt7
			Case 8
				lngDefCnt = lngDefCnt8
			Case 9
				lngDefCnt = lngDefCnt9
			Case Else
				lngDefCnt = lngDefCnt0
		End Select

		'病院スケジューリングデータ読み込み
		GetLngArrHoliday

	End If

	'保存ボタン押下時
	If strAction = "save" Then

		'フォーム情報（ＰＯＳＴ形式で送信された画面入力値）の取得
		If strRsvFraCd = "ALL" Then			'病院スケジューリング

			'指定年月
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'スタート日（先頭が何曜日かを取得）
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'月末日
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'１週間ごとに処理を行う（最大６週あるので）
			For j = 1 To 6

				'１日ごとに処理を行う
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						If IsEmpty(lngArrHoliday) Then
							lngArrHoliday = Array(CLng(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & ""))
						Else
							i = UBound(lngArrHoliday) + 1
							ReDim Preserve lngArrHoliday(i)
							lngArrHoliday(i) = CLng(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & "")
						End If
					End If

				Next 

			Next

		ElseIf strRsvFraCd <> "" Then		'予約スケジューリング

			'指定年月
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'スタート日（先頭が何曜日かを取得）
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'月末日
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'１週間ごとに処理を行う（最大６週あるので）
			For j = 1 To 6

				'１日ごとに処理を行う
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						If IsEmpty(strArrEmptyCount) Then
							strArrEmptyCount = Array(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & "")
						Else
							i = UBound(strArrEmptyCount) + 1
							ReDim Preserve strArrEmptyCount(i)
							strArrEmptyCount(i) = Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & ""
						End If
					End If

				Next 

			Next

		End If

		'入力チェック
		If strRsvFraCd = "ALL" Then			'病院スケジューリング

			strArrMessage = objSchedule.CheckValueSchedule_h((strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngArrHoliday, strArrMessage2)

		ElseIf strRsvFraCd <> "" Then		'予約スケジューリング

			strArrMessage = objSchedule.CheckValueSchedule((strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngTimeFra, strRsvFraCd, strArrEmptyCount, strArrMessage2)
			'警告メッセージは表示不要（表示必要なら下の１行をコメントにする）
			strArrMessage2 = Empty

		End If

		'チェックエラー時は処理を抜ける
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'保存処理
		If strRsvFraCd = "ALL" Then			'病院スケジューリング

			objSchedule.UpdateSchedule_h (strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngArrHoliday

		ElseIf strRsvFraCd <> "" Then		'予約スケジューリング

			objSchedule.UpdateSchedule_tk (strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngTimeFra, strRsvFraCd, strArrEmptyCount, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

		End If

		'保存に成功した場合、保存完了後モードへ遷移
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?year="     & lngYear
		strURL = strURL & "&month="    & lngMonth
		strURL = strURL & "&timeFra="  & lngTimeFra
		strURL = strURL & "&rsvFraCd=" & strRsvFraCd
		strURL = strURL & "&action="   & "saveend"
		Response.Redirect strURL
		Response.End

	End If

	'データ読み込み
	If strRsvFraCd = "ALL" Then			'病院スケジューリング

		'病院スケジューリングデータ読み込み
		lngArrHoliday = Empty
		GetLngArrHoliday

	ElseIf strRsvFraCd <> "" Then		'予約スケジューリング

		'予約スケジューリングデータ読み込み
		strArrEmptyCount = Empty
		GetStrArrEmptyCount

	End If

	Exit Do
Loop

'スケジュールアクセス用COMオブジェクトの解放
Set objSchedule = Nothing

'-------------------------------------------------------------------------------
'
' 機能　　 : 病院スケジューリングデータ読み込み
'
' 引数　　 : なし
'
' 戻り値　 : なし
'
' 備考　　 : lngArrHoliday に１日～末日の病院設定値を編集する
' 　　　　 : （0:未設定，1:休診日，2:祝日）
'
'-------------------------------------------------------------------------------
Sub GetLngArrHoliday()

	'指定年月の１日から末日
	strStrDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/1"
	strEndDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1"))))

	'指定期間の病院スケジューリング情報を取得する
	lngCount = objSchedule.SelectSchedule_h(strStrDate, strEndDate, vntCslDate, vntHoliday)

	'１日～末日の設定値を判定
	k = 0
	For j = 1 To Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1")))
		lngHoliday = HOLIDAY_NON
		If k < lngCount Then
			If DateValue(vntCslDate(k)) = DateValue(CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(j)) Then
				lngHoliday = vntHoliday(k)
				k = k + 1
			End if
		End If
		'１日～末日の設定値をセット
		If IsEmpty(lngArrHoliday) Then
			lngArrHoliday = Array(lngHoliday)
		Else
			i = UBound(lngArrHoliday) + 1
			ReDim Preserve lngArrHoliday(i)
			lngArrHoliday(i) = lngHoliday
		End If
	Next

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約スケジューリングデータ読み込み
'
' 引数　　 : なし
'
' 戻り値　 : なし
'
' 備考　　 : strArrEmptyCount に１日～末日の予約設定値を編集する
' 　　　　 : （"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
' 　　　　 : 前もってlngArrHoliday に１日～末日の病院設定値が編集されていること
'
'-------------------------------------------------------------------------------
Sub GetStrArrEmptyCount()

	'指定年月の１日から末日
	strStrDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/1"
	strEndDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1"))))

	'指定期間の該当予約枠コードの予約スケジューリング情報を取得する（時間枠の指定はせず、すべての時間枠を抽出）
	lngCount = objSchedule.SelectSchedule(strStrDate, strEndDate, "", strRsvFraCd, vntCslDate, vntTimeFra, vntRsvFraCd, vntEmptyCount, vntRsvCount)

	'１日～末日の設定値を判定
	k = 0
	For j = 1 To Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1")))
		'その日の予約スケジューリングの設定を把握する
		strEmptyCount = ""
		strCheckType = ""
		If k < lngCount Then
			Do While DateValue(vntCslDate(k)) = DateValue(CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(j))
				'該当時間枠の予約設定値
				If vntTimeFra(k) = lngTimeFra Then
					strEmptyCount = vntEmptyCount(k)
				End If
				'時間枠管理されているか否かの判定
				If vntTimeFra(k) = TIME_FRA_NON Then
					strCheckType = "0"
				Else
					strCheckType = "1"
				End If
				k = k + 1
				If k >= lngCount Then
					Exit Do
				End If
			Loop
		End If
		'休日・祝日で、その日の予約を許さない場合
		If lngArrHoliday(j - 1) <> HOLIDAY_NON And strHolidayFlg = CStr(HOLIDAYFLG_DENY) Then
			'非表示とする
			strEmptyCount = "hidden"
		'休日・祝日以外、または、休日・祝日でも予約を許す場合
		Else
			'終日の入力時、時間枠管理されている日は非表示とする
			If lngTimeFra = TIME_FRA_NON And strCheckType = "1" Then
				strEmptyCount = "hidden"
			End If
			'指定時間枠の入力時、終日管理されている日は非表示とする
			If lngTimeFra <> TIME_FRA_NON And strCheckType = "0" Then
				strEmptyCount = "hidden"
			End If
		End If
		'１日～末日の設定値をセット
		If IsEmpty(strArrEmptyCount) Then
			strArrEmptyCount = Array(strEmptyCount)
		Else
			i = UBound(strArrEmptyCount) + 1
			ReDim Preserve strArrEmptyCount(i)
			strArrEmptyCount(i) = strEmptyCount
		End If
	Next

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約枠一覧ドロップダウンリストの編集
'
' 引数　　 : (In)	strName					エレメント名
' 　　　　 : (In)	strSelectedRsvFraCd		リストにて選択すべき予約枠コード
' 　　　　 : (In)	strNonSelDelFlg			未選択用空リスト削除フラグ
'
' 戻り値　 : HTML文字列
'
' 備考　　 : "SELECTED_ALL"で未選択用の空リストも同時に作成
'
'-------------------------------------------------------------------------------
Function EditRsvFraList(strName, strSelectedRsvFraCd, strNonSelDelFlg)

	Dim vntRsvFraCd			'予約枠コード
	Dim vntRsvFraName		'予約枠名称
	Dim vntEditRsvFraCd		'編集用予約枠コード
	Dim vntEditRsvFraName	'編集用予約枠名称
	Dim i					'インデックス
	Dim j					'インデックス
	Dim k					'インデックス

	Dim objSchedule			'スケジュールアクセス用COMオブジェクト

	'初期設定
	vntEditRsvFraCd = Empty
	vntEditRsvFraName = Empty

	'未選択用の空リストを作成
'### 2004/3/27 Deleted by Ishihara@FSIT 聖路加版では予約枠メンテナンスは別
'	If strNonSelDelFlg = NON_SELECTED_ADD Or strNonSelDelFlg = SELECTED_ALL Then
'		vntEditRsvFraCd = Array("")
'		vntEditRsvFraName = Array("▼表示するコースまたは設備を指定してください")
'	End If
'### 2004/3/27 Deleted End

	'「すべて（病院スケジュール）」選択用のリストを作成
	If strNonSelDelFlg = SELECTED_ALL Then
		If IsEmpty(vntEditRsvFraName) Then
			vntEditRsvFraCd = Array("ALL")
			vntEditRsvFraName = Array("休診日設定（土・日・祝）")
		Else
			i = UBound(vntEditRsvFraCd) + 1
			ReDim Preserve vntEditRsvFraCd(i)
			vntEditRsvFraCd(i) = "ALL"
			i = UBound(vntEditRsvFraName) + 1
			ReDim Preserve vntEditRsvFraName(i)
			vntEditRsvFraName(i) = "休診日設定（土・日・祝）"
		End If
	End If

'### 2004/3/27 Deleted by Ishihara@FSIT 聖路加版では予約枠メンテナンスは別
'	'予約枠の一覧を取得
'	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
'	j = objSchedule.SelectRsvFraList(vntRsvFraCd, vntRsvFraName)
'	Set objSchedule = Nothing
'
'	'「予約枠指定」選択用
'	For k = 0 To j - 1
'		If IsEmpty(vntEditRsvFraName) Then
'			vntEditRsvFraCd = Array(vntRsvFraCd(k))
'			vntEditRsvFraName = Array(vntRsvFraName(k))
'		Else
'			i = UBound(vntEditRsvFraCd) + 1
'			ReDim Preserve vntEditRsvFraCd(i)
'			vntEditRsvFraCd(i) = vntRsvFraCd(k)
'			i = UBound(vntEditRsvFraName) + 1
'			ReDim Preserve vntEditRsvFraName(i)
'			vntEditRsvFraName(i) = vntRsvFraName(k)
'		End If
'	Next
'### 2004/3/27 Deleted End

	'ドロップダウンリストの編集
	If Not IsEmpty(vntEditRsvFraName) Then
		EditRsvFraList = EditDropDownListFromArray(strName, vntEditRsvFraCd, vntEditRsvFraName, strSelectedRsvFraCd, NON_SELECTED_DEL)
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--<TITLE>予約枠登録</TITLE>-->
<TITLE>休診日設定</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 「デフォルト人数を展開する」がクリックされた時の処理
function SetDefault( defcnt ) {

	var i;

	// フォーム上のエレメントを走査する
	for ( i=0; i<document.entryForm.length; i++ ) {
		// TEXTオブジェクトの時
		if ( document.entryForm.elements[i].type == 'text') {
			// "hidden"（非表示）以外が設定されている時
			if ( document.entryForm.elements[i].value != 'hidden') {
				// デフォルト人数を設定する
				document.entryForm.elements[i].value = defcnt;
			}
		}
	}

	return false;
}

// 「日曜日は全て休診日」が変更された時の処理
function ChangeSunday( targetsel ) {

	var i;
	var elementname;

	// チェックされた時
	if ( targetsel.checked ) {
		// フォーム上のエレメントを走査する
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECTオブジェクトの時
			if ( document.entryForm.elements[i].type == 'select-one') {
				// エレメント名の末尾が"1"（日曜日）の時
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '1') {
					// "1"（休診日）を設定する
					document.entryForm.elements[i].value = '1';
				}
			}
		}
	// チェックがはずされた時
	} else {
		// フォーム上のエレメントを走査する
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECTオブジェクトの時
			if ( document.entryForm.elements[i].type == 'select-one') {
				// エレメント名の末尾が"1"（日曜日）の時
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '1') {
					// "1"（休診日）が設定されている時
					if ( document.entryForm.elements[i].value == '1') {
						// "0"（未設定）を設定する
						document.entryForm.elements[i].value = '0';
					}
				}
			}
		}
	}

	return false;
}

// 「土曜日は全て休診日」が変更された時の処理
function ChangeSaturday( targetsel ) {

	var i;
	var elementname;

	// チェックされた時
	if ( targetsel.checked ) {
		// フォーム上のエレメントを走査する
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECTオブジェクトの時
			if ( document.entryForm.elements[i].type == 'select-one') {
				// エレメント名の末尾が"7"（土曜日）の時
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '7') {
					// "1"（休診日）を設定する
					document.entryForm.elements[i].value = '1';
				}
			}
		}
	// チェックがはずされた時
	} else {
		// フォーム上のエレメントを走査する
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECTオブジェクトの時
			if ( document.entryForm.elements[i].type == 'select-one') {
				// エレメント名の末尾が"7"（土曜日）の時
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '7') {
					// "1"（休診日）が設定されている時
					if ( document.entryForm.elements[i].value == '1') {
						// "0"（未設定）を設定する
						document.entryForm.elements[i].value = '0';
					}
				}
			}
		}
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
td.mnttab { background-color:#FFFFFF }
a.weekday,
a.holiday,
a.saturday { margin-right:20px }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="selectForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
<!--			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">予約枠登録</FONT></B></TD> -->
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">休診日設定</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD>受診年月</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditTimeFraList("timeFra", CStr(lngTimeFra)) %></TD>
					</TR>
				</TABLE>
			</TD>
			<TD>&nbsp;<A HREF="mntCapacityList.asp?year=<%= lngYear %>&month=<%= lngMonth %>">設定状況を見る</A></TD>
		</TR>
		<TR>
			<TD>予約枠</TD>
			<TD>：</TD>
			<TD><%= EditRsvFraList("rsvFraCd", strRsvFraCd, SELECTED_ALL) %></TD>
			<TD VALIGN="bottom" ROWSPAN="3">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="document.selectForm.submit();return false"><IMG SRC="/webHains/images/b_prev.gif" ALT="表示"></A>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="action" VALUE="save">
	<INPUT TYPE="hidden" NAME="year" VALUE="<%= CStr(lngYear) %>">
	<INPUT TYPE="hidden" NAME="month" VALUE="<%= CStr(lngMonth) %>">
	<INPUT TYPE="hidden" NAME="timeFra" VALUE="<%= CStr(lngTimeFra) %>">
	<INPUT TYPE="hidden" NAME="rsvFraCd" VALUE="<%= strRsvFraCd %>">
<%
'メッセージの編集
If strAction <> "" Then

	'保存完了時は「保存完了」の通知
	If strAction = "saveend" Then
		Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)
		Call EditMessage(strArrMessage2, MESSAGETYPE_WARNING)
%>
		<BR>
<%

	'さもなくばエラーメッセージを編集
	Else
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
		<BR>
<%
	End If

End If
%>
<%
'*******************************************************************************
'予約スケジューリングの表示
If strRsvFraCd <> "ALL" And strRsvFraCd <> "" Then
%>
	<SPAN STYLE="font-size:9pt;">
	<FONT COLOR="#ff6600"><B><%= CStr(lngYear) %>年<%= CStr(lngMonth) %>月度　<%= strRsvFraName %></B></FONT>の予約枠情報を表示しています。
	<%= IIf(lngFraType = FRA_TYPE_CS, "（コース枠管理）", "（検査項目枠管理）") %>
	</SPAN>
	<BR><BR>
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD COLSPAN="7"><B><%= CStr(lngYear) %>年<%= CStr(lngMonth) %>月度　<%= strRsvFraName %>予約人数</B></TD>
		</TR>
		<TR ALIGN="right" BGCOLOR="#eeeeee">
			<TD CLASS="holiday"><B>日</B></FONT></TD>
			<TD CLASS="weekday"><B>月</B></TD>
			<TD CLASS="weekday"><B>火</B></TD>
			<TD CLASS="weekday"><B>水</B></TD>
			<TD CLASS="weekday"><B>木</B></TD>
			<TD CLASS="weekday"><B>金</B></TD>
			<TD CLASS="saturday"><B>土</B></FONT></TD>
		</TR>
<%
			'指定年月
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'スタート日（先頭が何曜日かを取得）
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'月末日
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'１週間ごとに処理を行う（最大６週あるので）
			For j = 1 To 6
%>
				<TR ALIGN="right">
<%
				'１日ごとに処理を行う
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						'CLASS属性の編集
						strClass = ""
						'今日の色指定
						If strEditYear = CStr(Year(Date)) And strEditMonth = CStr(Month(Date)) And strEditDay = Day(Date) Then
							strClass = "today"
						Else
							'休診日、祝日の色指定
							If lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS Then
								strClass = "kyusin"
							ElseIf lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL Then
									strClass = "holiday"
							End If
						End If
						If strClass = "" Then
							'土曜、日曜の色指定
							Select	Case 	k
								Case vbSunday
									strClass = "holiday"
								Case vbSaturday
									strClass = "saturday"
								Case Else
									strClass = "weekday"
							End Select
						End If
%>
						<TD WIDTH="50" VALIGN="top">
							<A HREF="/webHains/frontdoor.asp?cslYear=<%= lngYear %>&cslMonth=<%= lngMonth %>&cslDay=<%= strEditDay %>" CLASS="<%= strClass %>">
							<B><I><%= IIf(Len(CStr(strEditDay)) = 1, "&nbsp;" & CStr(strEditDay), CStr(strEditDay)) %></I></B></A><BR>
							<INPUT TYPE="<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "hidden", "text") %>"
								NAME="<%= "day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k %>"
								VALUE="<%= strArrEmptyCount(strEditDay - 1) %>"
								<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "", "SIZE=""4"" MAXLENGTH=""3"" STYLE=""text-align:right""") %>>
								<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "　<BR>　", "人") %>
						</TD>
<%
					Else
%>
						<TD WIDTH="50" VALIGN="top">&nbsp;</TD>
<%
					End If

				Next 
%>
				</TR>
<%
				If strEditDay >= strEndDay Then
					Exit For
				End If

			Next
%>
	</TABLE>
	<BR>
<!--
	<INPUT TYPE="button" NAME="ButtonDefault" VALUE="デフォルト人数を展開する" ONCLICK="JavaScript:SetDefault('<%= CStr(lngDefCnt) %>');">
-->
	<A HREF="javascript:function voi(){};voi()" ONCLICK="SetDefault('<%= CStr(lngDefCnt) %>')">デフォルト人数を展開する</A>
	<BR>
	<BR>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
	<% End IF %>
    <BR>
<%
End If
%>
<%
'*******************************************************************************
'病院スケジューリングの表示
If strRsvFraCd = "ALL" Then
%>
	<SPAN STYLE="font-size:9pt;">
	<FONT COLOR="#ff6600"><B><%= CStr(lngYear) %>年<%= CStr(lngMonth) %>月度　病院スケジュール</B></FONT>情報を表示しています。
	</SPAN>
	<BR><BR>
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD COLSPAN="7"><B><%= CStr(lngYear) %>年<%= CStr(lngMonth) %>月度　病院スケジュール</B></TD>
		</TR>
		<TR ALIGN="right" BGCOLOR="#eeeeee">
			<TD CLASS="holiday"><B>日</B></FONT></TD>
			<TD CLASS="weekday"><B>月</B></TD>
			<TD CLASS="weekday"><B>火</B></TD>
			<TD CLASS="weekday"><B>水</B></TD>
			<TD CLASS="weekday"><B>木</B></TD>
			<TD CLASS="weekday"><B>金</B></TD>
			<TD CLASS="saturday"><B>土</B></FONT></TD>
		</TR>
<%
			'指定年月
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'スタート日（先頭が何曜日かを取得）
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'月末日
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'１週間ごとに処理を行う（最大６週あるので）
			For j = 1 To 6
%>
				<TR ALIGN="right">
<%
				'１日ごとに処理を行う
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						'CLASS属性の編集
						strClass = ""
'						'今日の色指定
'						If strEditYear = CStr(Year(Date)) And strEditMonth = CStr(Month(Date)) And strEditDay = Day(Date) Then
'							strClass = "today"
'						Else
'							'休診日、祝日の色指定
'							If lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS Then
'								strClass = "kyusin"
'							ElseIf lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL Then
'									strClass = "holiday"
'							End If
'						End If
						If strClass = "" Then
							'土曜、日曜の色指定
							Select	Case 	k
								Case vbSunday
									strClass = "holiday"
								Case vbSaturday
									strClass = "saturday"
								Case Else
									strClass = "weekday"
							End Select
						End If
%>
						<TD WIDTH="50" VALIGN="top">
							<A HREF="/webHains/frontdoor.asp?cslYear=<%= lngYear %>&cslMonth=<%= lngMonth %>&cslDay=<%= strEditDay %>" CLASS="<%= strClass %>">
							<B><I><%= IIf(Len(CStr(strEditDay)) = 1, "&nbsp;" & CStr(strEditDay), CStr(strEditDay)) %></I></B></A><BR>
							<SELECT NAME="<%= "day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k %>">
								<OPTION VALUE="<%= HOLIDAY_NON %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_NON, "SELECTED", "") %>>
								<OPTION VALUE="<%= HOLIDAY_CLS %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS, "SELECTED", "") %>>休診日
								<OPTION VALUE="<%= HOLIDAY_HOL %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL, "SELECTED", "") %>>祝日
							</SELECT>
						</TD>
<%
					Else
%>
						<TD WIDTH="50" VALIGN="top">&nbsp;</TD>
<%
					End If

				Next 
%>
				</TR>
<%
				If strEditDay >= strEndDay Then
					Exit For
				End If

			Next
%>
	</TABLE>
	<BR>
	<INPUT TYPE="checkbox" NAME="CheckboxSunday" ONCLICK="JavaScript:ChangeSunday(this);">日曜日は全て休診日<BR>
	<INPUT TYPE="checkbox" NAME="CheckboxSaturday" ONCLICK="JavaScript:ChangeSaturday(this);">土曜日は全て休診日<BR>
	<BR>
	<BR>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
	<% End IF %>
    <BR>
<%
End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
