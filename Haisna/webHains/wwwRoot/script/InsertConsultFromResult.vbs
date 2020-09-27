Option Explicit

Dim objWshShell			'WshShellオブジェクト
Dim objArgs				'WshArgumentsオブジェクト
Dim objConsult			'一括予約処理用

Dim strUserId			'ユーザＩＤ
Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim strArrCsCd			'コースコードの配列
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim lngCtrPtCd			'契約パターンコード
Dim dtmSecStrCslDate	'割り当て開始日
Dim dtmSecEndCslDate	'割り当て終了日

Dim Ret					'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1)  ユーザＩＤ
'(2)  開始受診日
'(3)  終了受診日
'(4)  コースコード
'(5)  団体コード１
'(6)  団体コード２
'(7)  事業部コード
'(8)  室部コード
'(9)  開始所属コード
'(10)  終了所属コード
'(11) 契約パターンコード
'(12) 割り当て開始日
'(13) 割り当て終了日

strUserId        = objArgs(0)
dtmStrCslDate    = CDate(objArgs(1))
dtmEndCslDate    = CDate(objArgs(2))
strArrCsCd       = Split(objArgs(3), ",")
strOrgCd1        = objArgs(4)
strOrgCd2        = objArgs(5)
strOrgBsdCd      = objArgs(6)
strOrgRoomCd     = objArgs(7)
strStrOrgPostCd  = objArgs(8)
strEndOrgPostCd  = objArgs(9)
lngCtrPtCd       = CLng(objArgs(10))
dtmSecStrCslDate = CDate(objArgs(11))
dtmSecEndCslDate = CDate(objArgs(12))

'一括予約処理
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.InsertConsultFromResult(strUserId, dtmStrCslDate, dtmEndCslDate, strArrCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, dtmSecStrCslDate, dtmSecEndCslDate)
