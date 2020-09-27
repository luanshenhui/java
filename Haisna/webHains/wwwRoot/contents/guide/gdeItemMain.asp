<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(メイン部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const SELECT_ALL = "すべて"	'選択条件名デフォルト値

Dim lngMode					'依頼／結果モード　1:依頼、2:結果
Dim lngGroup				'グループ表示有無　0:表示しない、1:表示する
Dim lngItem					'検査項目表示有無　0:表示しない、1:表示する
Dim lngQuestion				'問診項目表示有無　0:表示しない、1:表示する
Dim lngTableDiv				'テーブル選択区分　1:検査項目、　2:グループ　(0:デフォルト値)
Dim strClassCd				'検索分野コード
Dim strClassName			'検索分野名
Dim strSearchChar			'検索用先頭文字列
Dim lngSelectCount			'選択済み項目数

'サーチ部分文字列
Dim strInitSearchHeader		'ヘッダー部
Dim strInitSearchList		'リスト部
Dim strInitSearchSelected	'選択済み表示部

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngMode     = Request("mode")
lngGroup    = Request("group")
lngItem     = Request("item")
lngQuestion = Request("question")

'初期値設定
lngTableDiv    = 0
strClassCd     = ""
strClassName   = SELECT_ALL
strSearchChar  = ""
lngSelectCount = 0

'初期呼び出し部分設定(ヘッダー部、リスト部、選択済み表示部)
strInitSearchHeader   = "?group="      & CStr(lngGroup)    & _
						"&item="       & CStr(lngItem)
strInitSearchList     = "?mode="       & CStr(lngMode)     & _
						"&question="   & CStr(lngQuestion) & _
						"&tablediv="   & CStr(lngTableDiv) & _
						"&classcd="    & strClassCd        & _
						"&classname="  & strClassName      & _
						"&searchchar=" & strSearchChar
strInitSearchSelected = "?count="      & CStr(lngSelectCount)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>項目ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 選択済みの項目を保持するためのオブジェクトを定義
var selectedList  = new Array();

// 呼び元からの引数を保持するための定義
var gdeMode       = <%= lngMode %>;			/* 依頼／結果モード　1:依頼、2:結果 */
var gdeGroup      = <%= lngGroup %>;		/* グループ表示有無　0:表示しない、1:表示する */
var gdeItem       = <%= lngItem %>;			/* 検査項目表示有無　0:表示しない、1:表示する */
var gdeQuestion   = <%= lngQuestion %>;		/* 問診項目表示有無　0:表示しない、1:表示する */

// 絞込検索用の引数を保持するための定義
var gdeTableDiv;							/* テーブル選択区分　1:検査項目、　2:グループ　(0:デフォルト値) */
var gdeClassCd;								/* 検索分野コード */
var gdeClassName;							/* 検索分野名 */
var gdeSearchChar;							/* 検索用先頭文字列 */

// デフォルト値
gdeTableDiv   = 0;
gdeClassCd    = '';
gdeClassName  = 'すべて';
gdeSearchChar = '';

// 選択項目情報検索
function searchItem(searchValue) {

	var i;

	// 選択項目を検索し、成功時はそのインデックスを返す
	for (i = 0; i < selectedList.length; i++ ) {
		if (( selectedList[i][0] == searchValue[0] ) && ( selectedList[i][1] == searchValue[1] )) {
			return i;
		}
	}

	return -1;
}

// 選択項目情報の制御。検査項目チェックボックスのONCLICKイベントから呼び出される。
function controlSelectedItem( element ) {

	var pos;
	var gdeLocation;
	var gdeSearch;

	var wkSelectedList;	// 退避用の選択リスト

	// チェックされた場合
	if ( element.checked ) {

		// すでに選択項目情報として存在するか検索し、存在しない場合は選択項目情報として追加する
		if ( searchItem( element.value.split( ',', 2 ) ) < 0 ) {
			selectedList[selectedList.length] = element.value.split(',');
		}

	// チェックが外された場合
	} else {

		// 現在選択項目情報として存在するか検索し、存在する場合は選択項目情報から除外する
		if ( ( pos = searchItem( element.value.split( ',', 2 ) ) ) >= 0 ) {

			// 選択リストを退避
			wkSelectedList = selectedList;

			// 新しい配列作成
			selectedList  = new Array();

			// チェックをはずした項目以外を追加
			for ( var i = 0; i < wkSelectedList.length; i++ ) {
				if ( i != pos ) {
					selectedList[selectedList.length] = wkSelectedList[i];
				}
			}

		}

	}

	// 選択済み項目表示を更新
	gdeLocation = 'gdeItemSelected.asp';
	gdeSearch   = '?count=' + selectedList.length;
	self.SELECTED.location.replace( gdeLocation + gdeSearch );

	return false;

}

// リスト部に引数を渡す
function setParamToList() {

	var gdeLocation;
	var gdeSearch;

	// 呼び出し先の編集
	gdeLocation = 'gdeItemList.asp';
	gdeSearch   = '?mode=' + gdeMode + '&question=' + gdeQuestion + '&tableDiv=' + gdeTableDiv + '&classCd=' + gdeClassCd + '&className=' + escape(gdeClassName) + '&searchChar=' + escape(gdeSearchChar);

	// リスト部呼び出し
	self.main.location.replace( gdeLocation + gdeSearch );

}

// 項目コード、サフィックス、項目分類をセットして呼び出し元へ返す
function selectList() {

	var i;

	// 返り用バッファへ格納
	var dataDivBuf    = new Array();	// 項目分類
	var itemCdBuf     = new Array();	// 項目コード
	var suffixBuf     = new Array();	// サフィックス(検査項目時のみ有効)
	var itemNameBuf   = new Array();	// 検査項目名
	var resultTypeBuf = new Array();	// 結果タイプ
	var itemTypeBuf   = new Array();	// 項目タイプ
	
	if ( selectedList.length > 0 ) {
		for (i = 0; i < selectedList.length; i++ ) {
			itemCdBuf[ i ]     = selectedList[ i ][ 0 ];
			suffixBuf[ i ]     = selectedList[ i ][ 1 ];
			dataDivBuf[ i ]    = selectedList[ i ][ 2 ];
			itemNameBuf[ i ]   = selectedList[ i ][ 3 ];
			resultTypeBuf[ i ] = selectedList[ i ][ 4 ];
			itemTypeBuf[ i ]   = selectedList[ i ][ 5 ];
		}
	} else {
		dataDivBuf    = '';
		itemCdBuf     = '';
		suffixBuf     = '';
		itemNameBuf   = '';
		resultTypeBuf = '';
		itemTypeBuf   = '';
	}

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、選択した項目分類、項目コード、サフィックス、検査項目名を編集
	if ( opener.itmGuide_dataDiv  != null ) {
		opener.itmGuide_dataDiv  = dataDivBuf;		// 項目分類
	}

	if ( opener.itmGuide_itemCd   != null ) {
		opener.itmGuide_itemCd   = itemCdBuf;		// 項目コード
	}

	if ( opener.itmGuide_suffix   != null ) {
		opener.itmGuide_suffix   = suffixBuf;		// サフィックス
	}

	if ( opener.itmGuide_itemName != null ) {
		opener.itmGuide_itemName = itemNameBuf;		// 検査項目名
	}

	if ( opener.itmGuide_resultType != null ) {
		opener.itmGuide_resultType = resultTypeBuf;	// 結果タイプ
	}

	if ( opener.itmGuide_itemType != null ) {
		opener.itmGuide_itemType = itemTypeBuf;		// 項目タイプ
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.itmGuide_CalledFunction != null ) {
		opener.itmGuide_CalledFunction();
	}

	opener.winGuideItm = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="30,*,48" FRAMEBORDER="no" FRAMESPACING="1" BORDER="1">
	<FRAME NAME="TOP" SRC="gdeItemHeader.asp<%= strInitSearchHeader %>" FRAMEBORDER="NO" SCROLLING="NO">
	<FRAMESET COLS="155,*,160" FRAMEBORDER="NO" FRAMESPACING="0" BORDER="1">
		<FRAME NAME="SUBJECT"  SRC="gdeItemSubject.asp"                              FRAMEBORDER="no" NORESIZE>
		<FRAME NAME="main"     SRC="gdeItemList.asp<%= strInitSearchList %>"         FRAMEBORDER="no" NORESIZE>
		<FRAME NAME="SELECTED" SRC="gdeItemSelected.asp<%= strInitSearchSelected %>" FRAMEBORDER="no" NORESIZE>
	</FRAMESET>
	<FRAME NAME="HEADTOKEN" SRC="gdeItemInitial.asp" FRAMEBORDER="no" NORESIZE>
</FRAMESET>
</HTML>
