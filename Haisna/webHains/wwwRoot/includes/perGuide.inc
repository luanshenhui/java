<%
'-----------------------------------------------------------------------------
'		個人ガイド Include File (Ver0.0.1)
'		AUTHER  : Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var perGuide_PerId;				// 個人ＩＤ
var perGuide_PerName;			// 氏名
var perGuide_PerKName;			// カナ氏名
var perGuide_CalledFunction;	// ガイドを閉じる際に呼び出す親画面の関数

var winGuidePersonal;			// ウィンドウハンドル

// 個人検索ガイド画面を表示
function perGuide_showGuidePersonal( perId, perName, perKName, calledFunc, orgCd1, orgCd2 ) {

	var url = '/webHains/contents/guide/gdePersonal.asp';	// 個人検索ガイド画面のURL

	// ガイド画面との連絡域を使用して処理制御を行う
	perGuide_PerId    = perId;
	perGuide_PerName  = document.getElementById(perName);
	perGuide_PerKName = document.getElementById(perKName);
	perGuide_CalledFunction = calledFunc;

	// 団体が決定している場合は追加
	if ( orgCd1 && orgCd2 ) {
		url = url + '?orgCd1='+ orgCd1.value;
		url = url + '&orgCd2='+ orgCd2.value;
	}

	// ガイド画面を表示
	perGuide_openWindow( url );

}

// ガイド画面を表示
function perGuide_openWindow( url ) {

	var opened = false;	// 画面が開かれているか

	var dialogWidth = 1000, dialogHeight = 600;
	var dialogTop, dialogLeft;

	// すでにガイドが開かれているかチェック
	if ( winGuidePersonal ) {
		if ( !winGuidePersonal.closed ) {
			opened = true;
		}
	}

	// 画面を中央に表示するための計算
	dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuidePersonal.focus();
		winGuidePersonal.location.replace( url );
	} else {
		winGuidePersonal = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 個人情報のクリア
function perGuide_clearPerInfo( perId, perName, perKName ) {

	// 個人ＩＤのクリア
	if ( perId ) {
		perId.value = '';
	}

	// 氏名エレメントのクリア
	if ( document.getElementById( perName ) ) {
		document.getElementById( perName ).innerHTML = '';
	}

	// カナ氏名エレメントのクリア
	if ( document.getElementById( perKName ) ) {
		document.getElementById( perKName ).innerHTML = '';
	}

}

// 個人情報編集用関数
function perGuide_setPerInfo( perInfo ) {

	// 個人ＩＤの編集
	if ( perGuide_PerId ) {
		perGuide_PerId.value = perInfo.perId;
	}

	// 氏名の編集
	if ( perGuide_PerName ) {
		perGuide_PerName.innerHTML = perInfo.perName;
	}

	// カナ氏名の編集
	if ( perGuide_PerKName ) {
		perGuide_PerKName.innerHTML = perInfo.perKName;
	}

	// 関数呼び出し
	if ( perGuide_CalledFunction ) {
		perGuide_CalledFunction( perInfo );
	}

}

// ガイドを閉じる
function perGuide_closeGuidePersonal() {

	if ( winGuidePersonal != null ) {
		if ( !winGuidePersonal.closed ) {
			winGuidePersonal.close();
		}
	}

	winGuidePersonal = null;
}
//-->
</SCRIPT>
