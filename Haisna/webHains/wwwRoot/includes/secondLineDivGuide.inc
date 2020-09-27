<%
'-----------------------------------------------------------------------------
'		２次請求明細ガイド Include File (Ver0.0.1)
'		AUTHER  : Miyoshi T.Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var secondLineDivGuide_SecondLineDivCd;		// (Out) ２次請求明細コード
var secondLineDivGuide_SecondLineDivName;	// (Out) ２次請求明細名
var secondLineDivGuide_stdPrice;		// (Out) 標準単価
var secondLineDivGuide_stdTax;			// (Out) 標準税額
var secondLineDivGuide_CalledFunction;		// (In)  ガイド選択後に呼び出す関数

// ウィンドウハンドル
var winGuideSecondLineDiv;

// 文章ガイド画面を表示
function showGuideSecondLineDiv() {

	var opened = false;	// 画面が開かれているか
	var url;		// URL文字列

	// ガイド画面との連絡域(Out)を初期化
	secondLineDivGuide_SecondLineDivCd    = '';
	secondLineDivGuide_SecondLineDivName = '';
	secondLineDivGuide_stdPrice = '';
	secondLineDivGuide_stdTax = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideSecondLineDiv != null ) {
		if ( !winGuideSecondLineDiv.closed ) {
			opened = true;
		}
	}

	// 文章ガイドのURL編集
	url = '/webHains/contents/guide/gdeSecondLineDiv.asp';

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideSecondLineDiv.focus();
		winGuideSecondLineDiv.location.replace(url);
	} else {
		winGuideSecondLineDiv = window.open(url, '', 'width=400,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideSecondLineDiv() {

	if ( winGuideSecondLineDiv != null ) {
		if ( !winGuideSecondLineDiv.closed ) {
			winGuideSecondLineDiv.close();
		}
	}

	winGuideSecondLineDiv = null;

}
//-->
