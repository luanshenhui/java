Option Explicit

Dim objWshShell		'WshShellオブジェクト
Dim objArgs			'WshArgumentsオブジェクト
Dim objConsult		'一括予約処理用

Dim strUserId		'ユーザＩＤ
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strStrOrgPostCd	'開始所属コード
Dim strEndOrgPostCd	'終了所属コード
Dim lngCtrPtCd		'契約パターンコード
Dim dtmCslDate		'受診日
Dim lngOpMode		'処理モード

Dim Ret				'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1)  ユーザＩＤ
'(2)  団体コード１
'(3)  団体コード２
'(4)  事業部コード
'(5)  室部コード
'(6)  開始所属コード
'(7)  終了所属コード
'(8)  契約パターンコード
'(9)  受診日
'(10) 処理モード

strUserId       = objArgs(0)
strOrgCd1       = objArgs(1)
strOrgCd2       = objArgs(2)
strOrgBsdCd     = objArgs(3)
strOrgRoomCd    = objArgs(4)
strStrOrgPostCd = objArgs(5)
strEndOrgPostCd = objArgs(6)
lngCtrPtCd      = CLng(objArgs(7))
dtmCslDate      = CDate(objArgs(8))
lngOpMode       = CLng(objArgs(9))

'一括予約処理
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.InsertConsultFromPerson(strUserId, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, dtmCslDate, lngOpMode)
