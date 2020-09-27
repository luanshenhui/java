<% 
'-----------------------------------------------------------------------------
'		共通関数(団体グループ一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体グループ一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedGrpCd       リストにて選択すべき団体グループコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditOrgGrp_PList(strName, strSelectedGrpCd, vntNotSelectedRowCtrl)

	Dim objOrgGrp		'団体グループ情報アクセス用COMオブジェクト

	Dim strGrpCd		'団体グループコード
	Dim strGrpName		'団体グループ名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objOrgGrp = Server.CreateObject("HainsOrgGrp_P.OrgGrp_P")

	'コース情報の読み込み
	lngCount = objOrgGrp.SelectOrgGrp_PList(strGrpCd, strGrpName)

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditOrgGrp_PList_AppendArray(strGrpCd, strGrpName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	EditOrgGrp_PList = EditDropDownListFromArray(strName, strGrpCd, strGrpName, strSelectedGrpCd, lngNonSelDelFlg)

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 団体グループ一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedGrpCd       リストにて選択すべき団体グループコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
'            (In)    vntUseGrp		     使用区分
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditOrgGrp_PList2(strName, strSelectedGrpCd, vntNotSelectedRowCtrl, vntUseGrp)

	Dim objOrgGrp		'団体グループ情報アクセス用COMオブジェクト

	Dim strGrpCd		'団体グループコード
	Dim strGrpName		'団体グループ名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objOrgGrp = Server.CreateObject("HainsOrgGrp_P.OrgGrp_P")

	'コース情報の読み込み
	lngCount = objOrgGrp.SelectOrgGrp_PList2(strGrpCd, strGrpName,  vntUseGrp)

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call EditOrgGrp_PList_AppendArray(strGrpCd, strGrpName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	EditOrgGrp_PList2 = EditDropDownListFromArray(strName, strGrpCd, strGrpName, strSelectedGrpCd, lngNonSelDelFlg)

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 配列先頭要素の追加
'
' 引数　　 : (In/Out) strGrpCd         団体グループコード
' 　　　　   (In/Out) strGrpName       団体グループ名
' 　　　　   (In/Out) lngCount         配列の要素数
' 　　　　   (In)     strAppendGrpCd   追加団体グループコード
' 　　　　   (In)     strAppendGrpName 追加団体グループ名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditOrgGrp_PList_AppendArray(strGrpCd, strGrpName, lngCount, strAppendGrpCd, strAppendGrpName)

	Dim i	'インデックス

	'団体グループ情報が存在しない場合は空の配列を作成する
	If lngCount <= 0 Then
		strGrpCd   = Array()
		strGrpName = Array()
	End If

	'サイズを１つ増やす
	ReDim Preserve strGrpCd(lngCount)
	ReDim Preserve strGrpName(lngCount)
	lngCount = lngCount + 1

	'全要素を１つずつ後ろにシフトさせる
	For i = UBound(strCsCd) To 1 Step -1
		strGrpCd(i)   = strGrpCd(i - 1)
		strGrpName(i) = strGrpName(i - 1)
	Next

	'先頭に引数指定された要素を追加
	strGrpCd(0)   = strAppendGrpCd
	strGrpName(0) = strAppendGrpName

End Sub
%>
