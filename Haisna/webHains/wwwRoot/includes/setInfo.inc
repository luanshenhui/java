<%
'-----------------------------------------------------------------------------
'		セット情報 Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
var winSetInfo;	// ウィンドウハンドル

// セット情報画面呼び出し
function callSetInfoWindow( ctrPtCd, selOptCd, selOptBranchNo ) {

	var opened = false;	// 画面が開かれているか
	var url;			// セット内項目削除画面のURL

	// すでにガイドが開かれているかチェック
	if ( winSetInfo != null ) {
		if ( !winSetInfo.closed ) {
			opened = true;
		}
	}

	// セット情報画面のURL編集
	url = '/webHains/contents/guide/gdeSetInfo.asp?ctrPtCd=' + ctrPtCd + '&optCd=' + selOptCd + '&optBranchNo=' + selOptBranchNo;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winSetInfo.focus();
		winSetInfo.location.replace( url );
	} else {
		winSetInfo = open( url, '', 'width=550,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ガイドを閉じる
function closeSetInfoWindow() {

	if ( winSetInfo ) {
		if ( !winSetInfo.closed ) {
			winSetInfo.close();
		}
	}

	winSetInfo = null;
}
//-->
</SCRIPT>
