<%
Const ADD_FIRST = 1
Const ADD_LAST  = 2
Const ADD_NONE  = 3
'-------------------------------------------------------------------------------
'
' 機能　　 : 検査グループ一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedGrpCd    リストにて選択すべきグループコード
' 　　　　   (In)     strAddValue         リストに追加する選択値
' 　　　　   (In)     strAddValueName     リストに追加する選択名称
' 　　　　　 (In)     strAddPoint         リストに追加する位置
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 検査結果グループのみ、グループコード順
'
'-------------------------------------------------------------------------------
Function EditGrpIList_GrpDiv(strName, strSelectedGrpCd, strAddValue, strAddValueName, strAddPoint)

	Dim objGrp		'グループ情報アクセス用COMオブジェクト

	Dim strGrpCd	'グループコード
	Dim strGrpName	'グループ名

	Dim lngCount	'件数

	Dim i			'インデックス

	Set objGrp = Server.CreateObject("HainsGrp.Grp")

	'検査グループ情報の読み込み
'### 2003.02.17 Updated by Ishihara@FSIT システムグループは表示しない。
'	lngCount = objGrp.SelectGrp_IList_GrpDiv(GRPDIV_I, strGrpCd, strGrpName)
	lngCount = objGrp.SelectGrp_IList_GrpDiv(GRPDIV_I, strGrpCd, strGrpName, , , , , , ,True)

	'追加場所
	Select Case strAddPoint
		Case ADD_FIRST
			If lngCount = 0 Then
				strGrpCd = Array(strAddValue)
				strGrpName = Array(strAddValueName)
			Else
				Redim Preserve strGrpCd(lngCount)
				Redim Preserve strGrpName(lngCount)
				For i = lngCount To 1 Step - 1
					strGrpCd(i) = strGrpCd(i - 1)
					strGrpName(i) = strGrpName(i - 1)
					strGrpCd(i - 1) = ""
					strGrpName(i - 1) = ""
				Next
				strGrpCd(0) = strAddValue
				strGrpName(0) = strAddValueName
			End If
		Case ADD_LAST
			If lngCount = 0 Then
				strGrpCd = Array(strAddValue)
				strGrpName = Array(strAddValueName)
			Else
				ReDim Preserve strGrpCd(lngCount)
				ReDim Preserve strGrpName(lngCount)
				strGrpCd(lngCount) = strAddValue
				strGrpName(lngCount) = strAddValueName
			End If
	End Select

	'ドロップダウンリストの編集
	EditGrpIList_GrpDiv = EditDropDownListFromArray(strName, strGrpCd, strGrpName, strSelectedGrpCd, NON_SELECTED_DEL)

	Set objGrp = Nothing

End Function
%>
