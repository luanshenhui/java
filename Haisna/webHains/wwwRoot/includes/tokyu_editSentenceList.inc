<% 
'-----------------------------------------------------------------------------
'		共通関数(判定分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : 基尉
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const SENTENCECD_REGULAR = "regular"	'全レポート選択時のレポートコード

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strItemCd              検査項目コード
' 　　　　   (In)     strItemType            項目タイプ
' 　　　　   (In)     strSelectedJudClassCd  リストにて選択すべきコースコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularSentence  True指定時は全定期健診コース指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditSentenceList(strName, strItemCd, strItemType, strSelectedJudClassCd, vntNotSelectedRowCtrl, blnAddRegularSentence)

	Dim objSentence			'文章情報アクセス用COMオブジェクト

	Dim strStcCD			'文章コード
	Dim strShortStc			'略文章
'*****  2003/02/28  ADD  START  E.Yamamoto
	Dim strStcName			'略文章
'*****  2003/02/28  ADD  END    E.Yamamoto
	Dim lngCount			'件数
	Dim lngNonSelDelFlg		'リスト未選択行の制御

	Dim i					'インデックス

	'オブジェクトのインスタンス作成
	Set objSentence = Server.CreateObject("HainsSentence.Sentence")

	'判定分類情報の読み込み
	lngCount = objSentence.SelectSentenceList(strItemCd, strItemType, strStcCD, strShortStc)

	'全判定分類指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularSentence Then
		Call EditList_AppendArray(strStcCd, strStcName, lngCount, SENTENCECD_REGULAR, "■すべて")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditList_AppendArray(strStcCd, strStcName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	If lngCount <= 0 Then
		Tokyu_EditSentenceList = "選択できる項目がありません。"
	Else
'*****  2003/02/28  EDIT  START  E.Yamamoto
'		Tokyu_EditSentenceList = EditDropDownListFromArray(strName, strStcCd, strStcName, strSelectedSentenceCd, lngNonSelDelFlg)
		Tokyu_EditSentenceList = EditDropDownListFromArray(strName, strStcCd, strShortStc, strSelectedJudClassCd, lngNonSelDelFlg)
'*****  2003/02/28  EDIT  END    E.Yamamoto
	End If

End Function
%>
