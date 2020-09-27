Option Explicit

Dim objWshShell			'WshShellオブジェクト
Dim objArgs				'WshArgumentsオブジェクト
Dim objCooperation		'連携・一括処理用

Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim strDelFlg			'使用中フラグ

Dim Ret					'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1) 団体コード１
'(2) 団体コード２
'(3) 開始受診日
'(4) 終了受診日
'(5) 使用中フラグ

strOrgCd1     = objArgs(0)
strOrgCd2     = objArgs(1)
dtmStrCslDate = CDate(objArgs(2))
dtmEndCslDate = CDate(objArgs(3))
strDelFlg     = objArgs(4)

'個人情報一括更新処理
Set objCooperation = CreateObject("HainsCooperation.PersonAll")
Ret = objCooperation.UpdateStatus(strOrgCd1, strOrgCd2, dtmStrCslDate, dtmEndCslDate, strDelFlg)
