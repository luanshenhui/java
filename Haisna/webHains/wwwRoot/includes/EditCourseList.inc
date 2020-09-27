<% 
'-----------------------------------------------------------------------------
'		共通関数(コース一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@takumatec.co.jp
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName          エレメント名
' 　　　　   (In)     strSelectedCsCd  リストにて選択すべきコースコード
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditCourseList(strName, strSelectedCsCd, strNonSelDelFlg)

	Dim objCourse	'コース情報アクセス用COMオブジェクト

	Dim strCsCd		'コースコード
	Dim strCsName	'コース名
	Dim lngCount	'件数
	Dim i			'インデックス

	Set objCourse = Server.CreateObject("HainsCourse.Course")

	If ( strNonSelDelFlg = NON_SELECTED_ADD ) OR ( strNonSelDelFlg = NON_SELECTED_DEL ) OR ( strNonSelDelFlg = SELECTED_ALL ) Then
		'コース情報の読み込み
		If objCourse.SelectCourseList(strCsCd, strCsName) > 0 Then
	
			'ドロップダウンリストの編集
			EditCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, strNonSelDelFlg)
	
		End If
	Else
		'コース情報の読み込み
		lngCount = objCourse.SelectCourseList(strCsCd, strCsName)
	
		Redim Preserve strCsCd(lngCount)
		Redim Preserve strCsName(lngCount)

		For i = lngCount To 1 Step -1
			strCsCd(i)   = strCsCd(i - 1)
			strCsName(i) = strCsName(i - 1)
			strCsCd(i - 1)   = ""
			strCsName(i - 1) = ""
		Next

		strCsCd(0)   = ""
		strCsName(0) = strNonSelDelFlg

		'ドロップダウンリストの編集
		EditCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, NON_SELECTED_DEL)
	
	End If

	Set objCourse = Nothing

End Function
%>
