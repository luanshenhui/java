Option Explicit

Dim objWshShell		'WshShellオブジェクト
Dim objArgs			'WshArgumentsオブジェクト
Dim objImport		'一括予約処理用
Dim objFso			'ファイルシステムオブジェクト

Dim strFileName		'取り込みファイル名
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strUserId		'ユーザＩＤ
Dim lngCtrPtCd		'契約パターンコード

'引数値の取得
Set objArgs = WScript.Arguments

'(1) 取り込みファイル名
'(2) 団体コード１
'(3) 団体コード２
'(4) ユーザＩＤ
'(5) 契約パターンコード

strFileName = objArgs(0)
strOrgCd1   = objArgs(1)
strOrgCd2   = objArgs(2)
strUserId   = objArgs(3)
lngCtrPtCd  = CLng(objArgs(4))

'一括予約処理
Set objImport = CreateObject("HainsCooperation.ImportPerson")
objImport.ImportPerson strFileName, strOrgCd1, strOrgCd2, strUserId, lngCtrPtCd, , , , False

'ファイルの削除
Set objFso = CreateObject("Scripting.FileSystemObject")
objFso.DeleteFile(strFileName)
