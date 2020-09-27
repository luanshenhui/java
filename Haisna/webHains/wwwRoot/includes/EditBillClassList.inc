<% 
'-----------------------------------------------------------------------------
'		共通関数(請求書分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書分類ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　   (In)     strSelectedBillClassCd  リストにて選択すべき請求書分類コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditBillClassList(strName, strSelectedBillClassCd, strNonSelDelFlg)

	Dim objDmdClass				'請求書分類情報アクセス用COMオブジェクト

	Dim strBillClassCd				'請求書分類コード
	Dim strBillClassName			'請求書分類名
	Dim lngCount					'件数
	Dim i							'インデックス

	Set objDmdClass = Server.CreateObject("HainsDmdClass.DmdClass")

	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR ( strNonSelDelFlg = NON_SELECTED_DEL ) OR ( strNonSelDelFlg = SELECTED_ALL ) Then
		'請求書分類情報の読み込み
		If objDmdClass.SelectBillClassList(strBillClassCd, strBillClassName) > 0 Then
	
			'ドロップダウンリストの編集
			EditBillClassList = EditDropDownListFromArray(strName, strBillClassCd, strBillClassName, strSelectedBillClassCd, strNonSelDelFlg)
	
		End If
	Else
		'請求書分類情報の読み込み
		lngCount = objDmdClass.SelectBillClassList(strBillClassCd, strBillClassName)
	
		Redim Preserve strBillClassCd(lngCount)
		Redim Preserve strBillClassName(lngCount)

		For i = lngCount To 1 Step -1
			strBillClassCd(i)   = strBillClassCd(i - 1)
			strBillClassName(i) = strBillClassName(i - 1)
			strBillClassCd(i - 1)   = ""
			strBillClassName(i - 1) = ""
		Next

		strBillClassCd(0)   = ""
		strBillClassName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditBillClassList = EditDropDownListFromArray(strName, strBillClassCd, strBillClassName, strSelectedBillClassCd, NON_SELECTED_DEL)
	
	End If

	Set objDmdClass = Nothing

End Function
%>
