<%
'-----------------------------------------------------------------------------
'		ノート情報ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
var winNote;					// ウィンドウハンドル

// ノート情報ガイド画面を表示
function noteGuide_showGuideNote( dispMode, cmtMode, perId, rsvNo, orgCd1, orgCd2, ctrptCd ) {

	var opened = false;	// 画面が開かれているか

	// すでにガイドが開かれているかチェック
	if ( winNote != null ) {
		if ( !winNote.closed ) {
			opened = true;
		}
	}

	var url = '/webHains/contents/comment/commentMainFlame.asp';
	url = url + '?dispMode=' + ( dispMode != '' ? dispMode : '' );

	if ( cmtMode != null ) {
		url = url + '&cmtMode=' + cmtMode;
	}

	if ( perId != null ) {
		url = url + '&perId=' + perId;
	}

	if ( rsvNo != null ) {
		url = url + '&rsvNo=' + rsvNo;
	}

	if ( orgCd1 != null ) {
		url = url + '&orgCd1=' + orgCd1;
	}

	if ( orgCd2 != null ) {
		url = url + '&orgCd2=' + orgCd2;
	}

	if ( ctrptCd != null ) {
		url = url + '&ctrptCd=' + ctrptCd;
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winNote.focus();
		winNote.location.replace( url );
	} else {
		winNote = window.open(url, '', 'width=800,height=660,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

// ガイドを閉じる
function noteGuide_closeGuideNote() {

	if ( winNote ) {
		if ( !winNote.closed ) {
			winNote.close();
		}
	}

	winNote = null;
}
//-->
</SCRIPT>
