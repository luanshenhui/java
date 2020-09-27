Option Explicit

Dim ActiveCount		'項目数（行位置）
Dim ActiveColumn	'項目数（列位置）

ActiveCount  = 0
ActiveColumn = 0

Sub Document_OnKeyPress()

	With resultList
		Do
			With .activeCount
				If .value = "" Then
					.value = 0
				End If
				ActiveCount = CLng(.value)
			End With
			With .activeColumn
				If .value = "" Then
					.value = 0
				End If
				ActiveColumn = CLng(.value)
			End With

			If Window.Event.KeyCode = 13 Then

				Window.Event.KeyCode = 0

				If CLng(.count.value) <=0 Then
					Exit Do
				End If

				Select Case CLng(.orientation.value)

					Case CLng(.portrait.value)
						If .dispMode.value = "detail" Then
							Call LandscapeFocusMoveForDetail()
						Else
							Call PortraitFocusMoveForSimple()
						End If
					Case CLng(.landscape.value)
						If .dispMode.value = "detail" Then
							Call PortraitFocusMoveForDetail()
						Else
							Call LandscapeFocusMoveForSimple()
						End If

				End Select

			End If

			.activeCount.value  = ActiveCount
			.activeColumn.value = ActiveColumn

			Exit Do
		Loop

	End With

End Sub

'
' 結果入力項目カーソル移動（詳細表示用・縦移動）
'
Sub PortraitFocusMoveForDetail()

	Dim ItemCount	'全入力項目数（検査結果、結果コメント１・２）
	Dim SrchCount	'入力可能位置検索数（hidden属性以外）
	Dim RowsCount	'項目数（行数）
	Dim Result		'検査結果
	Dim RslCmtCd1	'結果コメント１
	Dim RslCmtCd2	'結果コメント２

	With resultList

		'全項目数
		With .count
			ItemCount = CLng(.value) * 3
			RowsCount = CLng(.value)
		End With
		SrchCount = 0

		Do
			'全項目がhiddenだったら何もしない
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'次項目位置
			ActiveCount = ActiveCount + 1

			'最終項目に達したら先頭へ
			If ActiveCount >= RowsCount Then
				ActiveCount = 0
				ActiveColumn = ActiveColumn + 1
				If ActiveColumn > 2 Then
					ActiveColumn = 0
				End If
			End If

			'hidden以外の場合、フォーカス移動
			Select Case ActiveColumn

				Case 0		'検査結果

					If RowsCount > 1 Then
						Set Result = .result.item(ActiveCount)
					Else
						Set Result = .result
					End If
					If Result.Type <> "hidden" Then
						Result.Focus()
						Exit Do
					End If

				Case 1		'結果コメント１

					If RowsCount > 1 Then
						Set RslCmtCd1 = .rslCmtCd1.item(ActiveCount)
					Else
						Set RslCmtCd1 = .rslCmtCd1
					End If
					If RslCmtCd1.Type <> "hidden" Then
						RslCmtCd1.Focus()
						Exit Do
					End If

				Case 2		'結果コメント２

					If RowsCount > 1 Then
						Set RslCmtCd2 = .rslCmtCd2.item(ActiveCount)
					Else
						Set RslCmtCd2 = .rslCmtCd2
					End If
					If RslCmtCd2.Type <> "hidden" Then
						RslCmtCd2.Focus()
						Exit Do
					End If

			End Select

			SrchCount = SrchCount + 1
		Loop

		Set Result = Nothing
		Set RslCmtCd1 = Nothing
		Set RslCmtCd2 = Nothing

	End With

End Sub
'
' 結果入力項目カーソル移動（略式表示用・縦移動）
'
Sub PortraitFocusMoveForSimple()

	Dim ItemCount		'全入力項目数（検査結果、結果コメント）
	Dim SrchCount		'入力可能位置検索数（hidden属性以外）
	Dim RowsCount		'項目数（行数）
	Dim Result			'検査結果
	Const MaxCols = 3	'最大列数

	With resultList

		'全項目数
		ItemCount = CLng(.count.value)
		RowsCount = (ItemCount - 1) \ MaxCols + 1
		SrchCount = 0

		Do
			'全項目がhiddenだったら何もしない
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'次項目位置
			ActiveCount = ActiveCount + MaxCols

			'最終項目に達したら先頭へ
			If ActiveCount >= ItemCount Then
				ActiveColumn = ActiveColumn + 1
				If ActiveColumn >= MaxCols Then
					ActiveColumn = 0
				End If
				ActiveCount = ActiveColumn
			End If

			'hidden以外の場合、フォーカス移動
			If ItemCount > 1 Then
				Set Result = .result(ActiveCount)
			Else
				Set Result = .result
			End If

			If Result.Type <> "hidden" Then
				Result.Focus()
				Exit Do
			End If

			SrchCount = SrchCount + 1
		Loop

		Set Result = Nothing

	End With

End Sub
'
' 結果入力項目カーソル移動（詳細表示用・横移動）
'
Sub LandscapeFocusMoveForDetail()

	Dim ItemCount		'全入力項目数（検査結果、結果コメント１・２）
	Dim SrchCount		'入力可能位置検索数（hidden属性以外）
	Dim RowsCount		'項目数（行数）
	Dim Result			'検査結果
	Dim RslCmtCd1		'結果コメント１
	Dim RslCmtCd2		'結果コメント２

	With resultList

		'全項目数
		With .count
			ItemCount = CLng(.value) * 3
			RowsCount = CLng(.value)
		End With
		SrchCount = 0

		Do
			'全項目がhiddenだったら何もしない
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'次項目位置
			ActiveColumn = ActiveColumn + 1

			'最終項目に達したら先頭へ
			If ActiveColumn > 2 Then
				ActiveColumn = 0
				ActiveCount = ActiveCount + 1
				If ActiveCount >= RowsCount Then
					ActiveCount = 0
				End If
			End If

			'hidden以外の場合、フォーカス移動
			Select Case ActiveColumn

				Case 0		'検査結果
					If RowsCount > 1 Then
						Set Result = .result(ActiveCount)
					Else
						Set Result = .result
					End If
					If Result.Type <> "hidden" Then
						Result.Focus()
						Exit Do
					End If

				Case 1		'結果コメント１
					If RowsCount > 1 Then
						Set RslCmtCd1 = .rslCmtCd1(ActiveCount)
					Else
						Set RslCmtCd1 = .rslCmtCd1
					End If
					If RslCmtCd1.Type <> "hidden" Then
						RslCmtCd1.Focus()
						Exit Do
					End If

				Case 2		'結果コメント２
					If RowsCount > 1 Then
						Set RslCmtCd2 = .rslCmtCd2(ActiveCount)
					Else
						Set RslCmtCd2 = .rslCmtCd2
					End If
					If RslCmtCd2.Type <> "hidden" Then
						RslCmtCd2.Focus()
						Exit Do
					End If

			End Select

			SrchCount = SrchCount + 1
		Loop

		Set Result = Nothing
		Set RslCmtCd1 = Nothing
		Set RslCmtCd2 = Nothing

	End With

End Sub
'
' 結果入力項目カーソル移動（略式表示用・横移動）
'
Sub LandscapeFocusMoveForSimple()

	Dim ItemCount	'全入力項目数（検査結果、結果コメント１・２）
	Dim SrchCount	'入力可能位置検索数（hidden属性以外）
	Dim Result		'検査結果

	With resultList

		'全項目数
		ItemCount = CLng(.count.value)
		SrchCount = 0

		Do
			'全項目がhiddenだったら何もしない
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'次項目位置
			ActiveCount = CLng(ActiveCount) + 1

			'最終項目に達したら先頭へ
			If ActiveCount >= ItemCount Then
				ActiveCount = 0
				ActiveCount = CLng(ActiveCount)
			End If

			'hidden以外の場合、フォーカス移動
			If ItemCount > 1 Then
				Set Result = .result.item(ActiveCount)
			Else
				Set Result = .result
			End If

			If Result.Type <> "hidden" Then
				Result.Focus()
				Exit Do
			End If

			SrchCount = SrchCount + 1
		Loop

		Set Result = Nothing

	End With

End Sub
