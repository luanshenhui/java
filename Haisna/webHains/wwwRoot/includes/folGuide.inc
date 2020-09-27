<%
'-----------------------------------------------------------------------------
'		フォローアップガイド Include File (Ver0.0.1)
'		AUTHER  : Toru Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
%>
<!--
// ガイド画面との連絡域
var folGuide_JudClassCd;		// (In/Out)  
var folGuide_JudClassName;		// (In/Out) 健診項目
var folGuide_JudCd;			// (In/Out) 判定
var folGuide_SecCslDate;		// (In/Out) 二次検査日
var folGuide_ComeFlg;			// (In/Out) 状況
var folGuide_SecItemCd;			// (In/Out) 検査項目
var folGuide_RsvInfoCd;			// (In/Out) 予約状況
var folGuide_JudCd2;			// (In/Out) 結果
var folGuide_QuestionCd;		// (In/Out) アンケート
var folGuide_FolNote;			// (In/Out) 備考
var folGuide_FolName1;			// (In/Out) 検査項目名１
var folGuide_FolName2;			// (In/Out) 検査項目名２
var folGuide_FolName3;			// (In/Out) 検査項目名３
var folGuide_FolName4;			// (In/Out) 検査項目名４
var folGuide_FolName5;			// (In/Out) 検査項目名５
var folGuide_RsvInfoName;		// (In/Out) 予約状況名
var folGuide_QuestionName;		// (In/Out) アンケート名
var folGuide_CalledFunction;	// (In)  ガイド選択後に呼び出す関数
// ウィンドウハンドル
var winGuideFol;

// 文章ガイド画面を表示
function showGuideFol() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// ガイド画面との連絡域(Out)を初期化
	folGuide_FolName1     = '';
	folGuide_FolName2     = '';
	folGuide_FolName3     = '';
	folGuide_FolName4     = '';
	folGuide_FolName5     = '';
	folGuide_RsvInfoName  = '';
	folGuide_QuestionName = '';

	// すでにガイドが開かれているかチェック
	if ( winGuideFol != null ) {
		if ( !winGuideFol.closed ) {
			opened = true;
		}
	}

	// 文章ガイドのURL編集
	url = '/webHains/contents/guide/gdeFollow.asp?judClassCd=' + folGuide_JudClassCd + '&judClassName=' + folGuide_JudClassName + '&judCd=' + folGuide_JudCd + '&secCslDate=' + folGuide_SecCslDate + '&comeFlg=' + folGuide_ComeFlg + '&secItemCd=' + folGuide_SecItemCd + '&rsvInfoCd=' + folGuide_RsvInfoCd + '&judCd2=' + folGuide_JudCd2 + '&questionCd=' + folGuide_QuestionCd + '&folNote=' + folGuide_FolNote;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideFol.focus();
		winGuideFol.location.replace(url);
	} else {
		winGuideFol = window.open(url, '', 'width=550,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

	return false;
}

// ガイドを閉じる
function closeGuideFol() {

	if ( winGuideFol != null ) {
		if ( !winGuideFol.closed ) {
			winGuideFol.close();
		}
	}

	winGuideFol = null;

}
//-->
