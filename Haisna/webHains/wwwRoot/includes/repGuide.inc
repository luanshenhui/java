<%
'-----------------------------------------------------------------------------
'		オーダレポート一覧ガイド Include File (Ver0.0.1)
'		AUTHER  : Takagi@fsit.Fujitsu.com
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var winReport;	// ウィンドウハンドル

// オーダレポート一覧画面を表示
function showGuideReport( rsvNo ) {

	var opened = false;	// 画面が開かれているか
	var url;			// レポート一覧画面のURL

	// すでにガイドが開かれているかチェック
	if ( winReport != null ) {
		if ( !winReport.closed ) {
			opened = true;
		}
	}

	// レポート一覧画面のURL編集
	url = '/webHains/contents/order/odrOrderReport.asp?rsvNo=' + rsvNo;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winReport.focus();
	} else {
		winReport = window.open(url , '', 'width=700,height=500,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}

	return false;
}

// ガイドを閉じる
function closeGuideReport() {

	if ( winReport != null ) {
		if ( !winReport.closed ) {
			winReport.close();
		}
	}

	winReport = null;
}
//-->
