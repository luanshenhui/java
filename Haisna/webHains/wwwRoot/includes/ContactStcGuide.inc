<%
'-----------------------------------------------------------------------------
'		面接文書ガイド Include File (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var contactStcGuide_GuidanceDiv;		// 指導内容区分
var contactStcGuide_StdContactStcCd;	// 定型面接文章コード
var contactStcGuide_ContactStc;			// 面接文章

var winGuideContactStc;				// ウィンドウハンドル

// 面接文書検索ガイド画面を表示
function contactStcGuide_showGuideContactStc( guidanceDiv, stdContactStcCd, contactStc , calledFunc, connectCodeName ) {

	var opened = false;												// 画面が開かれているか
	var url    = '/webHains/contents/guide/gdeStdContactStc.asp';	// 面接ガイド画面のURL

	url = url + '?GuidanceDiv=' + guidanceDiv.value

	// ガイド画面との連絡域を使用して処理制御を行う
	contactStcGuide_GuidanceDiv   	= guidanceDiv;
	contactStcGuide_StdContactStcCd = stdContactStcCd;
	contactStcGuide_ContactStc  	= document.getElementById( contactStc );

	contactStcGuide_CalledFunction  = calledFunc;
	contactStcGuide_ConnectCodeName = connectCodeName;

	// すでにガイドが開かれているかチェック
	if ( winGuideContactStc ) {
		if ( !winGuideContactStc.closed ) {
			opened = true;
		}
	}

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideContactStc.focus();
		winGuideContactStc.location.replace(url);
	} else {
		winGuideContactStc = window.open(url, '', 'width=700,height=570,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
	}

}

// 面接文書編集用関数
function contactStcGuide_setContactStcInfo( guidanceDiv, stdContactStcCd, contactStc ) {

	// 指導内容区分の編集
	if ( contactStcGuide_GuidanceDiv ) {
		contactStcGuide_GuidanceDiv.value = guidanceDiv;
	}

	// 定型面接文章コードの編集
	if ( contactStcGuide_StdContactStcCd ) {
		contactStcGuide_StdContactStcCd.value = stdContactStcCd;
	}

	// 面接文章の編集
	if ( contactStcGuide_StdContactStcCd ) {
		if ( contactStcGuide_ConnectCodeName ) {
			contactStcGuide_ContactStc.innerHTML = stdContactStcCd + '：' + contactStc;
		} else {
			contactStcGuide_ContactStc.innerHTML = contactStc;
		}
	}

	// 関数呼び出し
	if ( contactStcGuide_CalledFunction ) {
		contactStcGuide_CalledFunction();
	}

}

// 面接文章情報のクリア
function contactStcGuide_clearContactStcInfo( guidanceDiv, stdContactStcCd, contactStc ) {

	// 指導内容区分のクリア
/*
	2003.02.13 Deleted by Ishihara@FSIT
	if ( guidanceDiv ) {
		guidanceDiv.value = '';
	}
*/

	// 定型面接文章コードのクリア
	if ( stdContactStcCd ) {
		stdContactStcCd.value = '';
	}

	// 病名エレメントのクリア
	if ( document.getElementById(contactStc) ) {
		document.getElementById(contactStc).innerHTML = '';
	}


}

// ガイドを閉じる
function contactStcGuide_closeGuideContactStc() {

	if ( winGuideContactStc ) {
		if ( !winGuideContactStc.closed ) {
			winGuideContactStc.close();
		}
	}

	winGuideContactStc = null;
}
//-->
</SCRIPT>
