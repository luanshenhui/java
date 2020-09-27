<% 
'-----------------------------------------------------------------------------
'		共通関数(予約枠一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約枠ドロップダウンリストの編集
'
' 引数　　 : (In)     strName              エレメント名
' 　　　　   (In)     strSelectedRsvFraCd  リストにて選択すべき予約枠コード
' 　　　　   (In)     strNonSelDelFlg      空白行の要否制御
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRsvFraList(strName, strSelectedRsvFraCd, strNonSelDelFlg)

	Dim objSchedule		'スケジュール情報アクセス用

	Dim strRsvFraCd		'予約枠コード
	Dim strRsvFraName	'予約枠名称

	'オブジェクトのインスタンス作成
	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'予約枠情報の読み込み
	objSchedule.SelectRsvFraList strRsvFraCd, strRsvFraName
	
	'ドロップダウンリストの編集
	EditRsvFraList = EditDropDownListFromArray(strName, strRsvFraCd, strRsvFraName, strSelectedRsvFraCd, strNonSelDelFlg)
	
End Function
%>

