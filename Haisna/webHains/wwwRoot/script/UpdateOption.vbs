Option Explicit

Dim objWshShell			'WshShellオブジェクト
Dim objArgs				'WshArgumentsオブジェクト
Dim objConsult			'一括予約処理用

Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim lngCtrPtCd			'契約パターンコード
Dim strReCreatePrice	'金額を再作成するか

Dim Ret					'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1) 開始受診日
'(2) 終了受診日
'(3) 団体コード１
'(4) 団体コード２
'(5) 契約パターンコード
'(6) 金額を再作成するか

dtmStrCslDate    = CDate(objArgs(0))
dtmEndCslDate    = CDate(objArgs(1))
strOrgCd1        = objArgs(2)
strOrgCd2        = objArgs(3)
lngCtrPtCd       = CLng(objArgs(4))
strReCreatePrice = objArgs(5)

'オプション検査更新処理
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.UpdateOption(dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, lngCtrPtCd, strReCreatePrice)
