<% 
'-----------------------------------------------------------------------------
'		共通関数(請求明細分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求明細分類ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                     エレメント名
' 　　　　   (In)     strSelectedDmdLineClassCd  リストにて選択すべき請求書分類コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDmdLineClassList(strName, strSelectedDmdLineClassCd, strNonSelDelFlg)

	Dim objDmdClass				'請求書分類情報アクセス用COMオブジェクト

	Dim strDmdLineClassCd		'請求明細分類コード
	Dim strDmdLineClassName		'請求明細分類名
	Dim lngCount				'件数
	Dim i						'インデックス

	Set objDmdClass = Server.CreateObject("HainsDmdClass.DmdClass")

	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR ( strNonSelDelFlg = NON_SELECTED_DEL ) OR ( strNonSelDelFlg = SELECTED_ALL ) Then
		'請求明細分類情報の読み込み
		If objDmdClass.SelectDmdLineClassItemList(strDmdLineClassCd, strDmdLineClassName) > 0 Then
	
			'ドロップダウンリストの編集
			EditDmdLineClassList = EditDropDownListFromArray(strName, strDmdLineClassCd, strDmdLineClassName, strSelectedDmdLineClassCd, strNonSelDelFlg)
	
		End If
	Else
		'請求明細分類情報の読み込み
		lngCount = objDmdClass.SelectDmdLineClassItemList(strDmdLineClassCd, strDmdLineClassName)
	
		Redim Preserve strDmdLineClassCd(lngCount)
		Redim Preserve strDmdLineClassName(lngCount)

		For i = lngCount To 1 Step -1
			strDmdLineClassCd(i)   = strDmdLineClassCd(i - 1)
			strDmdLineClassName(i) = strDmdLineClassName(i - 1)
			strDmdLineClassCd(i - 1)   = ""
			strDmdLineClassName(i - 1) = ""
		Next

		strDmdLineClassCd(0)   = ""
		strDmdLineClassName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditDmdLineClassList = EditDropDownListFromArray(strName, strDmdLineClassCd, strDmdLineClassName, strSelectedDmdLineClassCd, NON_SELECTED_DEL)
	
	End If

	Set objDmdClass = Nothing

End Function
%>
