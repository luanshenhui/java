<% 
'-----------------------------------------------------------------------------
'		共通関数(判定分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : 基尉
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const JUDCLASSCD_REGULAR = "regular"	'全レポート選択時のレポートコード

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedJudClassCd  リストにて選択すべきコースコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularJudClass  True指定時は全定期健診コース指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditJudClassList(strName, strSelectedJudClassCd, vntNotSelectedRowCtrl, blnAddRegularJudClass)

	Dim objJudClass	'判定分類情報アクセス用COMオブジェクト

	Dim strJudClassCd		'判定分類コード
	Dim strJudClassName		'判定分類名称
	Dim lngCount			'件数
	Dim lngNonSelDelFlg		'リスト未選択行の制御

	Dim i					'インデックス

	'オブジェクトのインスタンス作成
	Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

	'判定分類情報の読み込み
	lngCount = objJudClass.SelectJudClassList(strJudClassCd, strJudClassName)

	'全判定分類指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularJudClass Then
		Call EditList_AppendArray(strJudClassCd, strJudClassName, lngCount, JUDCLASSCD_REGULAR, "■すべての判定分類")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditList_AppendArray(strJudClassCd, strJudClassName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	If lngCount <= 0 Then
		Tokyu_EditJudClassList = "選択できる項目がありません。"
	Else
		Tokyu_EditJudClassList = EditDropDownListFromArray(strName, strJudClassCd, strJudClassName, strSelectedJudClassCd, lngNonSelDelFlg)
	End If

End Function
%>
