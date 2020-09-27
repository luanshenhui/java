<%
'-----------------------------------------------------------------------------
'		文章ガイド Include File (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var stcGuide_ItemCd;			// (In)  検査項目コード
var stcGuide_ItemType;			// (In)  項目タイプ
var stcGuide_StcCd;				// (Out) 文章コード
var stcGuide_ShortStc;			// (Out) 略文章
var stcGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideStc;

// 文章ガイド画面を表示
function showGuideStc() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// ガイド画面との連絡域(Out)を初期化
	stcGuide_StcCd    = '';
	stcGuide_ShortStc = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideStc != null ) {
		if ( !winGuideStc.closed ) {
			opened = true;
		}
	}

	// 文章ガイドのURL編集
	url = '/webHains/contents/guide/gdeSentence.asp?itemCd=' + stcGuide_ItemCd + '&itemType=' + stcGuide_ItemType;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideStc.focus();
		winGuideStc.location.replace(url);
	} else {
		winGuideStc = window.open(url, '', 'width=400,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideStc() {

	if ( winGuideStc != null ) {
		if ( !winGuideStc.closed ) {
			winGuideStc.close();
		}
	}

	winGuideStc = null;

}
//-->
