<%
'-----------------------------------------------------------------------------
'		項目ガイド Include File (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var itmGuide_mode;			// 依頼／結果モード(1:依頼、2:結果)
var itmGuide_group;			// グループ表示有無(0:表示しない、1:表示する)
var itmGuide_item;			// 検査項目表示有無(0:表示しない、1:表示する)
var itmGuide_question;		// 問診項目表示有無(0:表示しない、1:表示する)
var itmGuide_dataDiv;		// 項目分類(P:依頼項目、C:検査項目、G:グループ)
var itmGuide_itemCd;		// 項目コード(依頼(検査)項目コードorグループコード)
var itmGuide_suffix;		// サフィックス(検査項目以外は空白)
var itmGuide_itemName;		// 検査項目名
var itmGuide_resultType;	// 結果タイプ(検査項目以外は空白)
var itmGuide_itemType;		// 項目タイプ(検査項目以外は空白)

var itmGuide_CalledFunction;

// ウィンドウハンドル
var winGuideItm;

// 項目ガイド画面を表示
function showGuideItm() {

	var opened = false;

	// ガイド画面との連絡域(戻り値)を初期化
	itmGuide_dataDiv    = '';
	itmGuide_itemCd     = '';
	itmGuide_suffix     = '';
	itmGuide_itemName   = '';
	itmGuide_resultType = '';
	itmGuide_itemType   = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideItm != null ) {
		if ( !winGuideItm.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuideItm.focus();
	} else {
		winGuideItm = window.open('/webHains/contents/guide/gdeItemMain.asp?mode=' + itmGuide_mode + '&group=' + itmGuide_group + '&item=' + itmGuide_item + '&question=' + itmGuide_question, '', 'width=650,height=540,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
	}

	return false;
}

// ガイドを閉じる
function closeGuideItm() {

	if ( winGuideItm != null ) {
		if ( !winGuideItm.closed ) {
			winGuideItm.close();
		}
	}

	winGuideItm = null;
}
//-->
