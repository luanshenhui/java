<% 
'-----------------------------------------------------------------------------
'		共通関数(コース一覧チェックリスト編集) (Ver0.0.1)
'		AUTHER  : Motoi
'       動作条件 tokyu_editCourseListがincludeされていること
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧の編集
'
' 引数　　 : (In)     strMode                取得モード
' 　　　　   (In)     strArrSelectedCsCd     リストにて選択すべきコースコード
' 　　　　   (In)     intColsNum             列数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditCourseTable(lngMode, strArrSelectedCsCd, intColsNum)

	Dim objCourse	'コース情報アクセス用COMオブジェクト

	Dim strCsCd			'コースコード
	Dim strCsName		'コース名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCourse = Server.CreateObject("HainsCourse.Course")

	'コース情報の読み込み
	lngCount = objCourse.SelectCourseList(strCsCd, strCsName, , lngMode)

	'一覧の編集
'	If lngMode = EDITCOURSELIST_MODE_MAIN Then
	If ( lngMode = EDITCOURSELIST_MODE_MAIN ) Or ( lngMode = EDITCOURSELIST_MODE_ALLMAIN ) Then
		Tokyu_EditCourseTable = EditCheckTableFromArray(strCsCd, strCsName, strArrSelectedCsCd, intColsNum, "MAIN_")
	ElseIf lngMode = EDITCOURSELIST_MODE_Sub Then
		Tokyu_EditCourseTable = EditCheckTableFromArray(strCsCd, strCsName, strArrSelectedCsCd, intColsNum, "SUB_")
	Else
		Tokyu_EditCourseTable = EditCheckTableFromArray(strCsCd, strCsName, strArrSelectedCsCd, intColsNum, "")
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧の取得
'
' 引数　　 : (In)     strMode                取得モード
'
' 戻り値　 : コースコード配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_CourseList(lngMode)

	Dim objCourse	'コース情報アクセス用COMオブジェクト

	Dim strCsCd			'コースコード
	Dim strCsName		'コース名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCourse = Server.CreateObject("HainsCourse.Course")

	'コース情報の読み込み
	lngCount = objCourse.SelectCourseList(strCsCd, strCsName, , lngMode)

	'ドロップダウンリストの編集
	Tokyu_CourseList = strCsCd

End Function
%>

