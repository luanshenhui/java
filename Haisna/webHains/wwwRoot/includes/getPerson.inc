<% 
'-----------------------------------------------------------------------------
'		共通関数(個人情報の主要データ取得) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報の主要データ取得
'
' 引数　　 : (In)     strPerId       個人ID
' 　　　　 : (Out)    strLastName    姓
' 　　　　 : (Out)    strFirstName   名
' 　　　　 : (Out)    strLastKName   カナ姓
' 　　　　 : (Out)    strFirstKName  カナ名
' 　　　　 : (Out)    dtmBirth       生年月日
' 　　　　 : (Out)    lngGender      性別
' 　　　　 : (Out)    strGenderName  性別の日本語名称
' 　　　　 : (Out)    strZipCd1      郵便番号1
' 　　　　 : (Out)    strZipCd2      郵便番号2
' 　　　　 : (Out)    strPrefName    都道府県名
' 　　　　 : (Out)    strCityName    市区町村名
' 　　　　 : (Out)    strAddress1    住所1
' 　　　　 : (Out)    strAddress2    住所2
' 　　　　 : (Out)    strTel1        電話番号1-市外局番
' 　　　　 : (Out)    strTel2        電話番号1-局番
' 　　　　 : (Out)    strTel3        電話番号1-番号
'
' 戻り値　 : True   レコードあり
' 　　　　 : False  レコードなし
'
' 備考　　 : 予約詳細および個人検索ガイド画面で使用することを想定
'
'-------------------------------------------------------------------------------
Function GetPerson ( _
	strPerId, _
	strLastName, _
	strFirstName, _
	strLastKName, _
	strFirstKName, _
	dtmBirth, _
	lngGender, _
	strGenderName, _
	strZipCd1, _
	strZipCd2, _
	strPrefName, _
	strCityName, _
	strAddress1, _
	strAddress2, _
	strTel1, _
	strTel2, _
	strTel3 _
)

	Dim objPerson	'個人情報アクセス用
	Dim Ret			'関数戻り値

	'個人ID未指定時は何もしない
	If strPerId = "" Then
		GetPerson = False
		Exit Function
	End If

	'オブジェクトのインスタンス作成
	Set objPerson = Server.CreateObject("HainsPerson.Person")

	'個人情報読み込み
	Ret = objPerson.SelectPerson(strPerID, _
								 Empty, _
								 strLastName, strFirstName, strLastKName, strFirstKName, dtmBirth, lngGender, _
								 Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, _
								 strTel1, strTel2, strTel3, _
								 Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, _
								 strZipCd1, strZipCd2, _
								 Empty, _
								 strCityName, strAddress1, strAddress2, _
								 Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty,,,, _
								 strGenderName, strPrefName)

	GetPerson = Ret

	Set objPerson = Nothing

End Function
%>
