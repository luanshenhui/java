<% 
'-----------------------------------------------------------------------------
'		共通関数(コース一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CST_DMDLINECLASS_MODE_ALL = 0
Const CST_DMDLINECLASS_MODE_IPPAN = 0
Const CST_DMDLINECLASS_MODE_KENPO = 0

Const CST_REGULARCD = "regular"	'全選択時のコード

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書分類一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedBillClassCd リストにて選択すべき請求書分類コード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularBillClass True指定時は全請求書分類指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditBillClassList(strName, strSelectedBillClassCd, vntNotSelectedRowCtrl, blnAddRegularBillClass)

	Dim objReport	'コース情報アクセス用COMオブジェクト

	Dim strBillClassCd			'請求書分類コード
	Dim strBillClassName		'請求書分類名
	Dim lngCount				'件数
	Dim lngNonSelDelFlg			'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objReport = Server.CreateObject("HainsDmdClass.DmdClass")

	'請求書分類の読み込み
	lngCount = objReport.SelectBillClassList(strBillClassCd, strBillClassName)

	'全請求書分類指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularBillClass Then
		Call EditList_AppendArray(strBillClassCd, strBillClassName, lngCount, CST_REGULARCD, "■すべての請求書分類")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditList_AppendArray(strBillClassCd, strBillClassName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	If lngCount <= 0 Then
		Tokyu_EditBillClassList = "選択できる項目がありません。"
	Else
		Tokyu_EditBillClassList = EditDropDownListFromArray(strName, strBillClassCd, strBillClassName, strSelectedBillClassCd, lngNonSelDelFlg)
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求明細分類一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     lngMode                取得モード
' 　　　　   (In)     strName                エレメント名
' 　　　　   (In)     strSelectedBillClassCd リストにて選択すべき請求明細分類コード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularDmdLineClass    True指定時は全請求明細分類指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditDmdLineClassList(lngMode, strName, strSelectedDmdLineClassCd, vntNotSelectedRowCtrl, blnAddRegularDmdLineClass)

	Dim objReport	'コース情報アクセス用COMオブジェクト

	Dim strDmdLineClassCd		'請求明細分類コード
	Dim strDmdLineClassName		'請求明細分類名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objReport = Server.CreateObject("HainsDmdClass.DmdClass")

	'請求明細分類の読み込み
	lngCount = objReport.SelectDmdLineClassList(strDmdLineClassCd, strDmdLineClassName, lngMode)

	'全請求明細分類指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularDmdLineClass Then
		Call EditList_AppendArray(strDmdLineClassCd, strDmdLineClassName, lngCount, CST_REGULARCD, "■すべての請求明細分類")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditList_AppendArray(strDmdLineClassCd, strDmdLineClassName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	If lngCount <= 0 Then
		Tokyu_EditDmdLineClassList = "選択できる項目がありません。"
	Else
		Tokyu_EditDmdLineClassList = EditDropDownListFromArray(strName, strDmdLineClassCd, strDmdLineClassName, strSelectedDmdLineClassCd, lngNonSelDelFlg)
	End If

End Function
%>
