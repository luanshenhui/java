<%
'-----------------------------------------------------------------------------
'		データ抽出 Include File (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------

'CSVファイル定義
Const CSV_DATAPATH      = "/webHains/temp/"		'ファイルパス名(仮想パス)
Const CSV_CONSULT       = "datCslList.csv"		'汎用データファイル
Const CSV_CONSULTTMP    = "datCslList.tmp"		'一時ファイル
Const CSV_PERSONAL      = "datPerList.csv"		'個人情報ファイル
Const CSV_ORGANIZATION  = "datOrgList.csv"		'団体情報ファイル
Const CSV_DEMAND        = "datDemand.csv"		'請求情報ファイル

'汎用データ抽出　抽出項目選択用
Const CHK_ON            = "on"					'チェックボックス選択
Const CASE_NOTSELECT    = "notselect"			'検査結果を抽出しない
Const CASE_ALLSELECT    = "allselect"			'すべての検査結果を抽出する
Const CASE_SELECT       = "select"				'抽出する項目を指定する

'汎用データ抽出　項目表示数デフォルト値
Const ROWCOUNT_ITEM     = 10					'検査結果の表示数デフォルト値
Const ROWCOUNT_JUDCLASS = 5						'総合判定の表示数デフォルト値

'-------------------------------------------------------------------------------
'
' 機能　　 : 性別のドロップダウンリスト編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelDelFlg     未選択用空リスト削除フラグ(2:未選択なし)
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditGenderList(strName, strSelectedCode, strNonSelDelFlg)

	Dim strArrGenderKind(2)	'性別
	Dim strArrGenderName(2)	'名称

	'固定値の編集
	strArrGenderKind(0) = "0"
	strArrGenderName(0) = "男女"
	strArrGenderKind(1) = "1"
	strArrGenderName(1) = "男性のみ"
	strArrGenderKind(2) = "2"
	strArrGenderName(2) = "女性のみ"

	EditGenderList = EditDropDownListFromArray(strName, strArrGenderKind, strArrGenderName, strSelectedCode, strNonSelDelFlg)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 条件指定符号のドロップダウンリスト編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelAddFlg     未選択用空リストフラグ(1:未選択あり)
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function EditSignList(strName, strSelectedCode, strNonSelAddFlg)

	Dim strArrSignKind(2)	'符号モード
	Dim strArrSignName(2)	'符号名

	'固定値の編集
	strArrSignKind(0) = "1"
	strArrSignName(0) = "と同じ"
	strArrSignKind(1) = "2"
	strArrSignName(1) = "以上"
	strArrSignKind(2) = "3"
	strArrSignName(2) = "以下"

	EditSignList = EditDropDownListFromArray(strName, strArrSignKind, strArrSignName, strSelectedCode, strNonSelAddFlg)

End Function

%>
