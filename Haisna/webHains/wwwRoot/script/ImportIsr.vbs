Option Explicit

Dim objWshShell		'WshShellオブジェクト
Dim objArgs			'WshArgumentsオブジェクト
Dim objConsult		'取り込み処理用

Dim strDataDiv		'取り込みデータ区分
Dim strFileName		'取り込みファイル名
Dim strUserId		'ユーザＩＤ

'引数値の取得
'(1) 区分("SELF":本人、"FAMILY":家族)
'(2) 取り込みファイル名
'(3) ユーザＩＤ
Set objArgs = WScript.Arguments

'区分の取得(エラーなら異常終了する。絶対指定されている前提でロジック構築。)
strDataDiv = objArgs(0)

'ファイル名の取得(なくても取り込み処理を行い、取り込み時のログに委ねる。)
If objArgs.Count > 1 Then
	strFileName = objArgs(1)
End If

'ユーザＩＤの取得
If objArgs.Count > 2 Then
	strUserId = objArgs(2)
End If

'データ区分ごとの処理振り分け
Select Case UCase(strDataDiv)

	Case "SELF"		'本人の場合

		'健保本人データ取り込み
		Set objConsult = CreateObject("HainsCooperation.ImportSelf")
		objConsult.ImportIsrSelf strFileName, strUserId

	Case "FAMILY"	'家族の場合

		Set objConsult = CreateObject("HainsCooperation.ImportFamily")
		objConsult.ImportIsrFamily strFileName, strUserId

End Select
