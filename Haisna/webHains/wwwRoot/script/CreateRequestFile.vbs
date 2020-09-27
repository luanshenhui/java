Option Explicit

Dim objWshShell		'WshShellオブジェクト
Dim objArgs			'WshArgumentsオブジェクト
Dim objRequest		'検査依頼処理用

Dim dtmCslDate		'受診日
Dim strPerId		'個人ＩＤ
Dim blnIncSentData	'送信済みデータを対象とするか

Dim Ret				'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1) 受診日
'(2) 個人ＩＤ
'(3) 送信済みデータを対象とするか

dtmCslDate     = CDate(objArgs(0))
strPerId       = objArgs(1)
blnIncSentData = CBool(objArgs(2))

'検査依頼処理
Set objRequest = CreateObject("HainsCooperation.Request")
Ret = objRequest.CreateFile(dtmCslDate, strPerId, blnIncSentData)
