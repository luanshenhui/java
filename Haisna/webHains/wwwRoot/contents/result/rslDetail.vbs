Option Explicit

Dim ActiveCount		'���ڐ��i�s�ʒu�j
Dim ActiveColumn	'���ڐ��i��ʒu�j

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
' ���ʓ��͍��ڃJ�[�\���ړ��i�ڍו\���p�E�c�ړ��j
'
Sub PortraitFocusMoveForDetail()

	Dim ItemCount	'�S���͍��ڐ��i�������ʁA���ʃR�����g�P�E�Q�j
	Dim SrchCount	'���͉\�ʒu�������ihidden�����ȊO�j
	Dim RowsCount	'���ڐ��i�s���j
	Dim Result		'��������
	Dim RslCmtCd1	'���ʃR�����g�P
	Dim RslCmtCd2	'���ʃR�����g�Q

	With resultList

		'�S���ڐ�
		With .count
			ItemCount = CLng(.value) * 3
			RowsCount = CLng(.value)
		End With
		SrchCount = 0

		Do
			'�S���ڂ�hidden�������牽�����Ȃ�
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'�����ڈʒu
			ActiveCount = ActiveCount + 1

			'�ŏI���ڂɒB������擪��
			If ActiveCount >= RowsCount Then
				ActiveCount = 0
				ActiveColumn = ActiveColumn + 1
				If ActiveColumn > 2 Then
					ActiveColumn = 0
				End If
			End If

			'hidden�ȊO�̏ꍇ�A�t�H�[�J�X�ړ�
			Select Case ActiveColumn

				Case 0		'��������

					If RowsCount > 1 Then
						Set Result = .result.item(ActiveCount)
					Else
						Set Result = .result
					End If
					If Result.Type <> "hidden" Then
						Result.Focus()
						Exit Do
					End If

				Case 1		'���ʃR�����g�P

					If RowsCount > 1 Then
						Set RslCmtCd1 = .rslCmtCd1.item(ActiveCount)
					Else
						Set RslCmtCd1 = .rslCmtCd1
					End If
					If RslCmtCd1.Type <> "hidden" Then
						RslCmtCd1.Focus()
						Exit Do
					End If

				Case 2		'���ʃR�����g�Q

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
' ���ʓ��͍��ڃJ�[�\���ړ��i�����\���p�E�c�ړ��j
'
Sub PortraitFocusMoveForSimple()

	Dim ItemCount		'�S���͍��ڐ��i�������ʁA���ʃR�����g�j
	Dim SrchCount		'���͉\�ʒu�������ihidden�����ȊO�j
	Dim RowsCount		'���ڐ��i�s���j
	Dim Result			'��������
	Const MaxCols = 3	'�ő��

	With resultList

		'�S���ڐ�
		ItemCount = CLng(.count.value)
		RowsCount = (ItemCount - 1) \ MaxCols + 1
		SrchCount = 0

		Do
			'�S���ڂ�hidden�������牽�����Ȃ�
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'�����ڈʒu
			ActiveCount = ActiveCount + MaxCols

			'�ŏI���ڂɒB������擪��
			If ActiveCount >= ItemCount Then
				ActiveColumn = ActiveColumn + 1
				If ActiveColumn >= MaxCols Then
					ActiveColumn = 0
				End If
				ActiveCount = ActiveColumn
			End If

			'hidden�ȊO�̏ꍇ�A�t�H�[�J�X�ړ�
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
' ���ʓ��͍��ڃJ�[�\���ړ��i�ڍו\���p�E���ړ��j
'
Sub LandscapeFocusMoveForDetail()

	Dim ItemCount		'�S���͍��ڐ��i�������ʁA���ʃR�����g�P�E�Q�j
	Dim SrchCount		'���͉\�ʒu�������ihidden�����ȊO�j
	Dim RowsCount		'���ڐ��i�s���j
	Dim Result			'��������
	Dim RslCmtCd1		'���ʃR�����g�P
	Dim RslCmtCd2		'���ʃR�����g�Q

	With resultList

		'�S���ڐ�
		With .count
			ItemCount = CLng(.value) * 3
			RowsCount = CLng(.value)
		End With
		SrchCount = 0

		Do
			'�S���ڂ�hidden�������牽�����Ȃ�
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'�����ڈʒu
			ActiveColumn = ActiveColumn + 1

			'�ŏI���ڂɒB������擪��
			If ActiveColumn > 2 Then
				ActiveColumn = 0
				ActiveCount = ActiveCount + 1
				If ActiveCount >= RowsCount Then
					ActiveCount = 0
				End If
			End If

			'hidden�ȊO�̏ꍇ�A�t�H�[�J�X�ړ�
			Select Case ActiveColumn

				Case 0		'��������
					If RowsCount > 1 Then
						Set Result = .result(ActiveCount)
					Else
						Set Result = .result
					End If
					If Result.Type <> "hidden" Then
						Result.Focus()
						Exit Do
					End If

				Case 1		'���ʃR�����g�P
					If RowsCount > 1 Then
						Set RslCmtCd1 = .rslCmtCd1(ActiveCount)
					Else
						Set RslCmtCd1 = .rslCmtCd1
					End If
					If RslCmtCd1.Type <> "hidden" Then
						RslCmtCd1.Focus()
						Exit Do
					End If

				Case 2		'���ʃR�����g�Q
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
' ���ʓ��͍��ڃJ�[�\���ړ��i�����\���p�E���ړ��j
'
Sub LandscapeFocusMoveForSimple()

	Dim ItemCount	'�S���͍��ڐ��i�������ʁA���ʃR�����g�P�E�Q�j
	Dim SrchCount	'���͉\�ʒu�������ihidden�����ȊO�j
	Dim Result		'��������

	With resultList

		'�S���ڐ�
		ItemCount = CLng(.count.value)
		SrchCount = 0

		Do
			'�S���ڂ�hidden�������牽�����Ȃ�
			If SrchCount >= ItemCount Then
				Exit Do
			End If

			'�����ڈʒu
			ActiveCount = CLng(ActiveCount) + 1

			'�ŏI���ڂɒB������擪��
			If ActiveCount >= ItemCount Then
				ActiveCount = 0
				ActiveCount = CLng(ActiveCount)
			End If

			'hidden�ȊO�̏ꍇ�A�t�H�[�J�X�ړ�
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
