<%
'-----------------------------------------------------------------------------
'		住所ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'    2003.09 聖路加対応　郵便番号を１つにまとめる FFCS)Fujii
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
var winGuideZip;				// ウィンドウハンドル
var zipGuide_ZipCd1;			// 郵便番号1
var zipGuide_ZipCd2;			// 郵便番号2
var zipGuide_ZipCd;			// 郵便番号
var zipGuide_PrefCd;			// 都道府県コード
var zipGuide_CityName;			// 市区町村名
var zipGuide_Section;			// 字
var zipGuide_CalledFunction;	// 住所選択時に呼び出される関数オブジェクト

// 住所検索ガイド画面を表示
function zipGuide_showGuideZip( keyPrefCd, zipCd, prefCd, cityName, section, calledFunc ) {

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// ガイドとの連結用変数にエレメントを設定

	// ガイド画面との連絡域を使用して処理制御を行う
//	zipGuide_ZipCd1   = zipCd1;
//	zipGuide_ZipCd2   = zipCd2;
	zipGuide_ZipCd    = zipCd;
	zipGuide_PrefCd   = prefCd;
	zipGuide_CityName = cityName;
	zipGuide_Section  = section;

	// すでにガイドが開かれているかチェック
	if ( winGuideZip != null ) {
		if ( !winGuideZip.closed ) {
			opened = true;
		}
	}

	// URL文字列の編集
	url = '/webHains/contents/guide/gdeZip.asp';
	if ( keyPrefCd != null ) {
		url = url + '?keyPrefCd=' + keyPrefCd;
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuideZip.location.replace( url );
		winGuideZip.focus();
	} else {
		winGuideZip = window.open( url, '', 'width=700,height=650,status=yes,directories=no,menubar=no,resizable=no,toolbar=no,scrollbars=yes' );
	}

}

// 住所情報編集用関数
function zipGuide_setZipInfo( zipCd, prefCd, cityName, section ) {

	// 郵便番号1の編集
//	if ( zipGuide_ZipCd1 ) {
//		zipGuide_ZipCd1.value = zipCd1;
//	}

	// 郵便番号2の編集
//	if ( zipGuide_ZipCd2 ) {
//		zipGuide_ZipCd2.value = zipCd2;
//	}

	// 郵便番号の編集
	if ( zipGuide_ZipCd ) {
		zipGuide_ZipCd.value = zipCd;
	}

	// 都道府県コードの編集
	if ( zipGuide_PrefCd ) {
		zipGuide_PrefCd.value = prefCd;
	}

	// 市区町村名の編集
	if ( zipGuide_CityName ) {
		zipGuide_CityName.value = cityName;
	}

	// 字の編集
	if ( zipGuide_Section ) {

		// 字名が存在しない場合のみ編集
// 住所１も編集する　2003.11.21
//		if ( zipGuide_Section.value == '' && section ) {
			zipGuide_Section.value = section;
//		}

	}

	// 関数呼び出し
	if ( zipGuide_CalledFunction ) {
		zipGuide_CalledFunction();
	}

}

// 住所情報のクリア
function zipGuide_clearZipInfo( zipCd1, zipCd2 ) {

	// 郵便番号1エレメントのクリア
	if ( zipCd1 ) {
		zipCd1.value = '';
	}

	// 郵便番号2エレメントのクリア
	if ( zipCd2 ) {
		zipCd2.value = '';
	}

}

// ガイドを閉じる
function zipGuide_closeGuideZip() {

	if ( winGuideZip != null ) {
		if ( !winGuideZip.closed ) {
			winGuideZip.close();
		}
	}

	winGuideZip = null;

}
//-->
</SCRIPT>
