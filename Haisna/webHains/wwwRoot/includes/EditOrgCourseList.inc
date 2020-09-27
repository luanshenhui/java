<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体契約管理コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     strName           エレメント名
' 　　　　   (In)     strSelectedCsCd   リストにて選択すべきコースコード
' 　　　　   (In)     blnNeedsEmptyRow  空白行の必要性
'
' 戻り値　 : HTML文字列
'
' 備考　　 : コースコード順
'
'-------------------------------------------------------------------------------
Function EditOrgCourseList(strOrgCd1, strOrgCd2, strName, strSelectedCsCd, blnNeedsEmptyRow)

	Dim objContract	'契約情報アクセス用COMオブジェクト

	Dim strCsCd		'コースコード
	Dim strCsName	'コース名

	Dim lngCount	'件数

	'オブジェクトのインスタンス作成
	Set objContract = Server.CreateObject("HainsContract.Contract")

	'団体契約管理コース情報の読み込み
	lngCount = objContract.SelectCtrMngCourse(strOrgCd1, strOrgCd2, strCsCd, strCsName)

	'空白行の作成
	If blnNeedsEmptyRow Then
		If lngCount = 0 Then
			strCsCd = Array("")
			strCsName = Array("指定なし")
		Else
			ReDim Preserve strCsCd(lngCount)
			ReDim Preserve strCsName(lngCount)
			strCsCd(lngCount) = ""
			strCsName(lngCount) = "指定なし"
		End If
	End If

	'ドロップダウンリストの編集
	EditOrgCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, NON_SELECTED_DEL)

End Function
%>
