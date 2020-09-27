Option Explicit

Dim objWshShell		'WshShellオブジェクト
Dim objArgs			'WshArgumentsオブジェクト
Dim objScreening	'スクリーニング用

Dim strStrCslDate	'開始受診年月日
Dim strEndCslDate	'終了受診年月日
Dim strStrDayId		'開始当日ID
Dim strEndDayId		'終了当日ID
Dim strCsCd			'コースコード
Dim strJudClassCd	'判定分類コード
Dim strPerId		'個人ＩＤ
Dim lngReJudge		'再判定(0:しない、1:する)
Dim lngEntryCheck	'未入力チェック(0:しない、1:する)

Dim Ret				'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1) 開始受診年月日
'(2) 終了受診年月日
'(3) 開始当日ID
'(4) 終了当日ID
'(5) コースコード
'(6) 判定分類コード
'(7) 個人ＩＤ
'(8) 未入力チェック
'(9) 再判定

strStrCslDate = objArgs(0)
strEndCslDate = objArgs(1)
strStrDayId   = objArgs(2)
strEndDayId   = objArgs(3)
strCsCd       = objArgs(4)
strJudClassCd = objArgs(5)
strPerId      = objArgs(6)
lngReJudge    = CLng(objArgs(7))
lngEntryCheck = CLng(objArgs(8))

'スクリーニング
Set objScreening = CreateObject("HainsJudgement.Screening")
Ret = objScreening.Screening(strStrCslDate, strEndCslDate, strStrDayId, strEndDayId, strCsCd, strJudClassCd, strPerId, lngReJudge, lngEntryCheck)
