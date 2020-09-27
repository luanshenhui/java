<% 
'-----------------------------------------------------------------------------
'		共通関数(コース一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const ReportCD_REGULAR = "regular"	'全レポート選択時のレポートコード

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
Function Tokyu_EditReportList(lngMode, strName, strSelectedReportCd, vntNotSelectedRowCtrl, blnAddRegularReport)

	Dim objReport	'コース情報アクセス用COMオブジェクト

	Dim strReportCd			'コースコード
	Dim strReportName		'コース名
	Dim lngCount		'件数
	Dim lngNonSelDelFlg	'リスト未選択行の制御

	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objReport = Server.CreateObject("HainsReport.Report")

	'コース情報の読み込み
	lngCount = objReport.SelectReportList2(strReportCd, strReportName, lngMode)

	'全定期健診コース指定行を追加する場合、配列の先頭に要素を追加する
	If blnAddRegularReport Then
		Call Tokyu_EditReportList_AppendArray(strReportCd, strReportName, lngCount, ReportCD_REGULAR, "■すべてのレポート")
	End If

	'空白行の扱いについて個別指定を行う場合は要素を追加
	If vntNotSelectedRowCtrl <> NON_SELECTED_ADD And vntNotSelectedRowCtrl <> NON_SELECTED_DEL And vntNotSelectedRowCtrl <> SELECTED_ALL Then
		Call Tokyu_EditReportList_AppendArray(strReportCd, strReportName, lngCount, "", vntNotSelectedRowCtrl)
		lngNonSelDelFlg = NON_SELECTED_DEL
	Else
		lngNonSelDelFlg = vntNotSelectedRowCtrl
	End If

	'ドロップダウンリストの編集
	Tokyu_EditReportList = EditDropDownListFromArray(strName, strReportCd, strReportName, strSelectedReportCd, lngNonSelDelFlg)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 配列先頭要素の追加
'
' 引数　　 : (In/Out) strReportCd          コースコード
' 　　　　   (In/Out) strReportName        コース名
' 　　　　   (In/Out) lngCount         配列の要素数
' 　　　　   (In)     strAppendReportCd    追加コースコード
' 　　　　   (In)     strAppendReportName  追加コース名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub Tokyu_EditReportList_AppendArray(strReportCd, strReportName, lngCount, strAppendReportCd, strAppendReportName)

	'コース情報が存在しない場合は空の配列を作成する
	If lngCount <= 0 Then
		strReportCd   = Array()
		strReportName = Array()
	End If

	'サイズを１つ増やす
	ReDim Preserve strReportCd(lngCount)
	ReDim Preserve strReportName(lngCount)
	lngCount = lngCount + 1

	'全要素を１つずつ後ろにシフトさせる
	For i = UBound(strReportCd) To 1 Step -1
		strReportCd(i)   = strReportCd(i - 1)
		strReportName(i) = strReportName(i - 1)
	Next

	'先頭に引数指定された要素を追加
	strReportCd(0)   = strAppendReportCd
	strReportName(0) = strAppendReportName

End Sub
%>

