<% 
'-----------------------------------------------------------------------------
'		共通関数(請求明細分類一覧ドロップダウンリスト編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const EDITDMDLINECLASSLIST_MODE_ALL    = 0	'すべて
Const EDITDMDLINECLASSLIST_MODE_NORMAL = 1	'一般で使用する請求明細分類のみ
Const EDITDMDLINECLASSLIST_MODE_ISR    = 2	'健保で使用する請求明細分類のみ

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求明細分類一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strMode                    取得モード
' 　　　　   (In)     strName                    エレメント名
' 　　　　   (In)     strSelectedDmdLineClassCd  リストにて選択すべき請求明細分類コード
' 　　　　   (In)     lngNotSelectedRowCtrl      リスト未選択行の制御
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Tokyu_EditDmdLineClassList(lngMode, strName, strSelectedDmdLineClassCd, lngNotSelectedRowCtrl)

	Dim objDmdLineClass		'請求明細分類情報アクセス用COMオブジェクト

	Dim strDmdLineClassCd	'請求明細分類コード
	Dim strDmdLineClassName	'請求明細分類名
	Dim lngCount			'件数
	Dim strNonSelDelFlg		'未選択用リスト制御フラグ

	'オブジェクトのインスタンス作成
	Set objDmdLineClass = Server.CreateObject("HainsDmdClass.DmdClass")

	'請求明細分類情報の読み込み
	lngCount = objDmdLineClass.SelectDmdLineClassList(strDmdLineClassCd, strDmdLineClassName, lngMode)

	'ドロップダウンリストの編集
	Tokyu_EditDmdLineClassList = EditDropDownListFromArray(strName, strDmdLineClassCd, strDmdLineClassName, strSelectedDmdLineClassCd, lngNotSelectedRowCtrl)

End Function
%>
