<% 
'-----------------------------------------------------------------------------
'		共通関数(コース一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const EDITCOURSELIST_MODE_ALL  = 0	'すべて
Const EDITCOURSELIST_MODE_MAIN = 1	'メインコースのみ（受診可能なもののみ）
Const EDITCOURSELIST_MODE_SUB  = 2	'サブコースのみ
Const EDITCOURSELIST_MODE_ALLMAIN = 3	'メインコースのみ（取得可能なもの全て）

Const CSCD_REGULAR = "regular"	'全定期健診コース選択時のコースコード

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strMode                取得モード
' 　　　　   (In)     strName                エレメント名
' 　　　　   (In)     strSelectedCsCd        リストにて選択すべきコースコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularCourse    True指定時は全定期健診コース指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditCourseList(lngMode, strName, strSelectedCsCd, vntNotSelectedRowCtrl, blnAddRegularCourse)

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

	'全定期健診コース指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularCourse Then
		Call Tokyu_EditCourseList_AppendArray(strCsCd, strCsName, lngCount, CSCD_REGULAR, "■すべての定期健診コース")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call Tokyu_EditCourseList_AppendArray(strCsCd, strCsName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	Tokyu_EditCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, lngNonSelDelFlg)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧テーブルの編集
'
' 引数　　 : (In)     strMode          取得モード
' 　　　　   (In)     strName          エレメント名
' 　　　　   (In)     vntSelectedCsCd  一覧にて選択すべきコースコード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub Tokyu_EditCourseTable(lngMode, strName, vntSelectedCsCd, lngColumnsOfRow)

	Dim objCourse	'コース情報アクセス用

	Dim strCsCd		'コースコード
	Dim strCsName	'コース名
	Dim lngCount	'件数

	DIm blnChecked	'チェックボックスにチェックすべきか
	Dim i, j		'インデックス

	'オブジェクトのインスタンス作成
	Set objCourse = Server.CreateObject("HainsCourse.Course")

	'コース情報の読み込み
	lngCount = objCourse.SelectCourseList(strCsCd, strCsName, , lngMode)
	If lngCount = 0 Then
		Exit Sub
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
		For i = 0 To lngCount - 1

			If i Mod lngColumnsOfRow = 0 Then
%>
				<TR>
<%
			End If

			'読み込んだコースコードが選択すべきコースコードの配列内に存在するかをチェック
			blnChecked = False
			If Not IsEmpty(vntSelectedCsCd) Then
				For j = 0 To UBound(vntSelectedCsCd)
					If vntSelectedCsCd(j) = strCsCd(i) Then
						blnChecked = True
						Exit For
					End If
				Next
			End If
%>
			<TD><INPUT TYPE="checkbox" NAME="<%= strName %>" VALUE="<%= strCsCd(i) %>" <%= IIf(blnChecked, "CHECKED", "") %>></TD>
			<TD><%= strCsName(i) %></TD>
<%
			If (i + 1) Mod lngColumnsOfRow = 0 Then
%>
				</TR>
<%
			End If

		Next
%>
	</TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 配列先頭要素の追加
'
' 引数　　 : (In/Out) strCsCd          コースコード
' 　　　　   (In/Out) strCsName        コース名
' 　　　　   (In/Out) lngCount         配列の要素数
' 　　　　   (In)     strAppendCsCd    追加コースコード
' 　　　　   (In)     strAppendCsName  追加コース名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub Tokyu_EditCourseList_AppendArray(strCsCd, strCsName, lngCount, strAppendCsCd, strAppendCsName)

	Dim i	'インデックス

	'コース情報が存在しない場合は空の配列を作成する
	If lngCount <= 0 Then
		strCsCd   = Array()
		strCsName = Array()
	End If

	'サイズを１つ増やす
	ReDim Preserve strCsCd(lngCount)
	ReDim Preserve strCsName(lngCount)
	lngCount = lngCount + 1

	'全要素を１つずつ後ろにシフトさせる
	For i = UBound(strCsCd) To 1 Step -1
		strCsCd(i)   = strCsCd(i - 1)
		strCsName(i) = strCsName(i - 1)
	Next

	'先頭に引数指定された要素を追加
	strCsCd(0)   = strAppendCsCd
	strCsName(0) = strAppendCsName

End Sub
%>
