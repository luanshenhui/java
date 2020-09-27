Option Explicit

Dim objWshShell			'WshShellオブジェクト
Dim objArgs				'WshArgumentsオブジェクト
Dim objConsult			'一括予約処理用

Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim lngCtrPtCd			'契約パターンコード
Dim lngNotFixedOnly		'受診日未確定分削除指定("1":受診日未確定分のみを削除)
Dim lngNotCancelForce	'強制削除可否("1":問診が入力されている受診情報は削除しない)
Dim lngNotExistsOptOnly	'"1":オプション検査が１つも存在しない受診情報のみ削除

Dim Ret					'関数戻り値

'引数値の取得
Set objArgs = WScript.Arguments

'(1)  開始受診日
'(2)  終了受診日
'(3)  団体コード１
'(4)  団体コード２
'(5)  事業部コード
'(6)  室部コード
'(7)  開始所属コード
'(8)  終了所属コード
'(9)  契約パターンコード
'(10) 受診日未確定分削除指定
'(11) 強制削除可否
'(12) オプション検査有無チェック

dtmStrCslDate     = CDate(objArgs(0))
dtmEndCslDate     = CDate(objArgs(1))
strOrgCd1         = objArgs(2)
strOrgCd2         = objArgs(3)
strOrgBsdCd       = objArgs(4)
strOrgRoomCd      = objArgs(5)
strStrOrgPostCd   = objArgs(6)
strEndOrgPostCd   = objArgs(7)
lngCtrPtCd        = CLng(objArgs(8))
lngNotFixedOnly   = CLng(objArgs(9))
lngNotCancelForce = CLng(objArgs(10))
lngNotExistsOptOnly = CLng(objArgs(11))

'一括予約削除処理
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.DeleteConsultAll(dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, lngNotFixedOnly, lngNotCancelForce, lngNotExistsOptOnly)
