<%
'-----------------------------------------------------------------------------
'		検査項目説明 Include File (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// 説明画面との連絡域
var dtlGuide_ItemCd;		// (In)  検査項目コード
var dtlGuide_Suffix;		// (In)  サフィックス
var dtlGuide_CsCd;		// (In)  コースコード
var dtlGuide_CslDateYear;	// (In)  受診日（年）
var dtlGuide_CslDateMonth;	// (In)  受診日（月）
var dtlGuide_CslDateDay;	// (In)  受診日（日）
var dtlGuide_Age;		// (In)  受診時年齢
var dtlGuide_Gender;		// (In)  性別

// ウィンドウハンドル
var winGuideDtl;

// 検査項目説明画面を表示
function showGuideDtl() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// すでに説明画面が開かれているかチェック
	if ( winGuideDtl != null ) {
		if ( !winGuideDtl.closed ) {
			opened = true;
		}
	}

	// 検査項目説明ガイドのURL編集
	url = '/webHains/contents/guide/gdeItemDetail.asp';
	url = url + '?itemCd='       + dtlGuide_ItemCd;
	url = url + '&suffix='       + dtlGuide_Suffix;
	url = url + '&csCd='         + dtlGuide_CsCd;
	url = url + '&cslDateYear='  + dtlGuide_CslDateYear;
	url = url + '&cslDateMonth=' + dtlGuide_CslDateMonth;
	url = url + '&cslDateDay='   + dtlGuide_CslDateDay;
	url = url + '&age='          + dtlGuide_Age;
	url = url + '&gender='       + dtlGuide_Gender;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideDtl.focus();
		winGuideDtl.location.replace(url);
	} else {
		winGuideDtl = window.open(url, '', 'width=800,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// 説明画面を閉じる
function closeGuideDtl() {

	if ( winGuideDtl != null ) {
		if ( !winGuideDtl.closed ) {
			winGuideDtl.close();
		}
	}

	winGuideDtl = null;
}
//-->
