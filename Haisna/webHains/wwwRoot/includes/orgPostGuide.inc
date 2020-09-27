<%
'-----------------------------------------------------------------------------
'		所属検索ガイド Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<!-- #include virtual = "/webHains/includes/ptnGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var orgPostGuide_OrgBsdCd;			// 事業部コード
var orgPostGuide_OrgBsdName;		// 事業部名称
var orgPostGuide_OrgRoomCd;			// 室部コード
var orgPostGuide_OrgRoomName;		// 室部名称
var orgPostGuide_OrgPostCd1;		// 所属コード１
var orgPostGuide_OrgPostName1;		// 所属名称１
var orgPostGuide_OrgPostCd2;		// 所属コード２
var orgPostGuide_OrgPostName2;		// 所属名称２

var orgPostGuide_LastOrgCd1;		// 団体コード１
var orgPostGuide_LastOrgCd2;		// 団体コード２
var orgPostGuide_SelectedOrgPost;	// 選択された所属

var orgPostGuide_PerId   = new Array(10);	// 個人ＩＤ
var orgPostGuide_PerName = new Array(10);	// 氏名
var orgPostGuide_SelectedPerson;			// 選択された個人

var orgPostGuide_CtrPtCd;			// 契約パターンコード
var orgPostGuide_CsName;			// コース名
var orgPostGuide_StrDate;			// 契約開始日
var orgPostGuide_EndDate;			// 契約終了日

// エレメントの参照設定
function orgPostGuide_getElement( orgCd1, orgCd2, orgName, orgBsdCd, orgBsdName, orgRoomCd, orgRoomName, orgPostCd1, orgPostName1, orgPostCd2, orgPostName2 ) {

	// 団体検索ガイド用エレメントの参照設定
	orgGuide_OrgCd1  = orgCd1;
	orgGuide_OrgCd2  = orgCd2;
	orgGuide_OrgName = document.getElementById( orgName );
	orgGuide_CalledFunction  = orgPostGuide_checkClearSelectOrg;
	orgGuide_ConnectCodeName = false;

	// 所属検索ガイド用エレメントの参照設定
	orgPostGuide_OrgBsdCd     = orgBsdCd;
	orgPostGuide_OrgBsdName   = document.getElementById( orgBsdName );
	orgPostGuide_OrgRoomCd    = orgRoomCd;
	orgPostGuide_OrgRoomName  = document.getElementById( orgRoomName );
	orgPostGuide_OrgPostCd1   = orgPostCd1;
	orgPostGuide_OrgPostName1 = document.getElementById( orgPostName1 );
	orgPostGuide_OrgPostCd2   = orgPostCd2;
	orgPostGuide_OrgPostName2 = document.getElementById( orgPostName2 );

	// 個人検索ガイド用エレメントの参照設定
	perGuide_CalledFunction = orgPostGuide_checkClearSelectPerson;

	// 契約パターン検索ガイド用エレメントの参照設定
	ptnGuide_CalledFunction = orgPostGuide_checkClearSelectPattern;

}

// 個人情報エレメントの参照設定
function orgPostGuide_getPerElement( perId, perName, index ) {

	var setIndex = 0;	// 参照設定を行うインデックス

	// 参照設定を行うインデックスの設定
	if ( index != null ) {
		setIndex = index;
	}

	// 個人検索ガイド用エレメントの参照設定
	orgPostGuide_PerId[ setIndex ]   = perId;
	orgPostGuide_PerName[ setIndex ] = perName ? document.getElementById( perName ) : null;

}

// 契約情報エレメントの参照設定
function orgPostGuide_getPatternElement( ctrPtCd, csName, strDate, endDate ) {

	orgPostGuide_CtrPtCd = ctrPtCd;

	if ( document.getElementById( csName ) ) {
		orgPostGuide_CsName = csName;
	}

	if ( document.getElementById( strDate ) ) {
		orgPostGuide_StrDate = strDate;
	}

	if ( document.getElementById( endDate ) ) {
		orgPostGuide_EndDate = endDate;
	}

}

// 団体検索ガイド画面を表示
function orgPostGuide_showGuideOrg() {

	// 現在の団体コードを退避
	orgPostGuide_LastOrgCd1 = orgGuide_OrgCd1.value;
	orgPostGuide_LastOrgCd2 = orgGuide_OrgCd2.value;

	// 団体検索ガイド画面を表示
	orgGuide_showGuideOrg( orgGuide_OrgCd1, orgGuide_OrgCd2, orgGuide_OrgName.id, null, null, orgGuide_CalledFunction, orgGuide_ConnectCodeName, null, '0' );

}

// 事業部検索ガイド画面を表示
function orgPostGuide_showGuideOrgBsd() {

	var url;	// URL文字列

	// 現在の団体コードを退避
	orgPostGuide_LastOrgCd1 = orgGuide_OrgCd1.value;
	orgPostGuide_LastOrgCd2 = orgGuide_OrgCd2.value;

	// URLの編集
	url = '/webHains/contents/guide/gdeOrgBusinessDiv.asp';
	url = url + '?orgCd1=' + orgGuide_OrgCd1.value;
	url = url + '&orgCd2=' + orgGuide_OrgCd2.value;

	// ガイド画面を表示
	orgGuide_openWindow( url );

}

// 室部検索ガイド画面を表示
function orgPostGuide_showGuideOrgRoom() {

	var url;	// URL文字列

	// 現在の団体コードを退避
	orgPostGuide_LastOrgCd1 = orgGuide_OrgCd1.value;
	orgPostGuide_LastOrgCd2 = orgGuide_OrgCd2.value;

	// URLの編集
	url = '/webHains/contents/guide/gdeOrgRoom.asp';
	url = url + '?orgCd1=' + orgGuide_OrgCd1.value;
	url = url + '&orgCd2=' + orgGuide_OrgCd2.value;

	// 事業部が決定している場合は追加
	if ( orgPostGuide_OrgBsdCd.value != '' ) {
		url = url + '&orgBsdCd=' + orgPostGuide_OrgBsdCd.value;
	}

	// ガイド画面を表示
	orgGuide_openWindow( url );

}

// 所属検索ガイド画面を表示
function orgPostGuide_showGuideOrgPost( selectedOrgPost ) {

	var url;	// URL文字列

	// 現在の団体コードを退避
	orgPostGuide_LastOrgCd1 = orgGuide_OrgCd1.value;
	orgPostGuide_LastOrgCd2 = orgGuide_OrgCd2.value;

	// 選択された所属を後で識別するために退避
	orgPostGuide_SelectedOrgPost = selectedOrgPost;

	// URLの編集
	url = '/webHains/contents/guide/gdeOrgPost.asp';
	url = url + '?orgCd1=' + orgGuide_OrgCd1.value;
	url = url + '&orgCd2=' + orgGuide_OrgCd2.value;

	// 事業部が決定している場合は追加
	if ( orgPostGuide_OrgBsdCd.value != '' ) {
		url = url + '&orgBsdCd='+ orgPostGuide_OrgBsdCd.value;
	}

	// 室部が決定している場合は追加
	if ( orgPostGuide_OrgRoomCd.value != '' ) {
		url = url + '&orgRoomCd=' + orgPostGuide_OrgRoomCd.value;
	}

	// ガイド画面を表示
	orgGuide_openWindow( url );

}

// 個人検索ガイド画面を表示
function orgPostGuide_showGuidePersonal( index ) {

	var setIndex = 0;	// 参照設定を行うインデックス

	// 参照設定を行うインデックスの設定
	if ( index != null ) {
		setIndex = index;
	}

	// 個人検索ガイド画面を表示
	perGuide_showGuidePersonal( orgPostGuide_PerId[ setIndex ], orgPostGuide_PerName[ setIndex ].id, null, perGuide_CalledFunction, orgGuide_OrgCd1, orgGuide_OrgCd2 );

	// 選択された個人を後で識別するために退避
	orgPostGuide_SelectedPerson = setIndex;

}

// 契約パターン検索ガイド画面を表示
function orgPostGuide_showGuidePattern() {

	// 契約パターン検索ガイド画面を表示
	ptnGuide_showGuidePattern( orgPostGuide_CtrPtCd, orgPostGuide_CsName, orgPostGuide_StrDate, orgPostGuide_EndDate, ptnGuide_CalledFunction, orgGuide_OrgCd1, orgGuide_OrgCd2 );

}

// 事業部の編集
function orgPostGuide_setOrgBsdInfo( orgBsdCd, orgBsdName ) {

	// 編集直前の事業部と異なる場合は室部以降のクリア
	if ( orgBsdCd != orgPostGuide_OrgBsdCd.value ) {
		orgPostGuide_clearOrgRoomInfo();
	}

	// 事業部の編集
	orgPostGuide_OrgBsdCd.value       = orgBsdCd;
	if ( orgGuide_ConnectCodeName ) {
		orgPostGuide_OrgBsdName.innerHTML = orgBsdCd + '：' + orgBsdName;
	} else {
		orgPostGuide_OrgBsdName.innerHTML = orgBsdName;
	}

}

// 室部の編集
function orgPostGuide_setOrgRoomInfo( orgRoomCd, orgRoomName ) {

	// 編集直前の室部と異なる場合は所属以降のクリア
	if ( orgRoomCd != orgPostGuide_OrgRoomCd.value ) {
		orgPostGuide_clearOrgPostInfo( 1 );
	}

	// 室部の編集
	orgPostGuide_OrgRoomCd.value       = orgRoomCd;
	if ( orgGuide_ConnectCodeName ) {
		orgPostGuide_OrgRoomName.innerHTML = orgRoomCd + '：' + orgRoomName;
	} else {
		orgPostGuide_OrgRoomName.innerHTML = orgRoomName;
	}

}

// 所属の編集
function orgPostGuide_setOrgPostInfo( orgPostCd, orgPostName ) {

	var editOrgPost;	// 編集すべき所属

	// 選択された所属と現在の編集状況より編集すべき所属を決定する
	switch ( orgPostGuide_SelectedOrgPost ) {
		case 1:
			editOrgPost = 1;
			break;
		case 2:
			editOrgPost = ( orgPostGuide_OrgPostCd1.value == '' ) ? 1 : 2;
			break;
		default:
			return;
	}

	// 所属の編集
	switch ( editOrgPost ) {
		case 1:
			orgPostGuide_OrgPostCd1.value = orgPostCd;
			if ( orgGuide_ConnectCodeName ) {
				orgPostGuide_OrgPostName1.innerHTML = orgPostCd + '：' + orgPostName;
			} else {
				orgPostGuide_OrgPostName1.innerHTML = orgPostName;
			}
			break;
		case 2:
			orgPostGuide_OrgPostCd2.value = orgPostCd;
			if ( orgGuide_ConnectCodeName ) {
				orgPostGuide_OrgPostName2.innerHTML = orgPostCd + '：' + orgPostName;
			} else {
				orgPostGuide_OrgPostName2.innerHTML = orgPostName;
			}
	}

}

// 団体選択時の事業部以降クリアのチェック
function orgPostGuide_checkClearSelectOrg() {

	// 先に退避した団体と現在の団体が同一な場合は何もしない
	if ( orgGuide_OrgCd1.value == orgPostGuide_LastOrgCd1 && orgGuide_OrgCd2.value == orgPostGuide_LastOrgCd2 ) {
		return;
	}

	// 事業部以降のクリア
	orgPostGuide_clearOrgBsdInfo();

	// すべての個人のクリア
	orgPostGuide_clearAllPerInfo();

	// 契約パターンのクリア
	ptnGuide_clearPatternInfo( orgPostGuide_CtrPtCd, orgPostGuide_CsName, orgPostGuide_StrDate, orgPostGuide_EndDate );

}

// 個人選択時の事業部以降クリアのチェック
function orgPostGuide_checkClearSelectPerson( perInfo ) {

	// 氏名の再編集
	orgPostGuide_PerName[ orgPostGuide_SelectedPerson ].innerHTML = perInfo.empNo + ( perInfo.empNo != '' ? '：' : '' ) + perGuide_PerName.innerHTML;

	// 現在の団体と選択された個人の団体が同一な場合は何もしない
	if ( orgGuide_OrgCd1.value == perInfo.orgCd1 && orgGuide_OrgCd2.value == perInfo.orgCd2 ) {
		return;
	}

	// 団体情報の編集
	orgGuide_setOrgInfo( perInfo.orgCd1, perInfo.orgCd2, perInfo.orgName );

	// 事業部以降のクリア
	orgPostGuide_clearOrgBsdInfo();

	// 選択された個人以外のクリア
	orgPostGuide_clearAllPerInfo( orgPostGuide_SelectedPerson );

}

// 契約パターン選択時の事業部以降クリアのチェック
function orgPostGuide_checkClearSelectPattern() {

	// 現在の団体と契約パターン検索ガイドにて決定された団体が同一な場合は何もしない
	if ( orgGuide_OrgCd1.value == ptnGuide_Val_OrgCd1 && orgGuide_OrgCd2.value == ptnGuide_Val_OrgCd2 ) {
		return;
	}

	// 団体情報の編集
	orgGuide_setOrgInfo( ptnGuide_Val_OrgCd1, ptnGuide_Val_OrgCd2, ptnGuide_Val_OrgName );

	// 事業部以降のクリア
	orgPostGuide_clearOrgBsdInfo();

}

// 団体以降のクリア
function orgPostGuide_clearOrgInfo() {

	// 団体のクリア
	orgGuide_clearOrgInfo( orgGuide_OrgCd1, orgGuide_OrgCd2, orgGuide_OrgName.id );

	// 事業部以降のクリア
	orgPostGuide_clearOrgBsdInfo();

	// すべての個人のクリア
	orgPostGuide_clearAllPerInfo();

	// 契約パターンのクリア
	ptnGuide_clearPatternInfo( orgPostGuide_CtrPtCd, orgPostGuide_CsName, orgPostGuide_StrDate, orgPostGuide_EndDate );

}

// 事業部以降のクリア
function orgPostGuide_clearOrgBsdInfo() {

	// 事業部のクリア
	orgPostGuide_clearCodeName( orgPostGuide_OrgBsdCd, orgPostGuide_OrgBsdName );

	// 室部以降のクリア
	orgPostGuide_clearOrgRoomInfo();

}

// 室部以降のクリア
function orgPostGuide_clearOrgRoomInfo() {

	// 室部のクリア
	orgPostGuide_clearCodeName( orgPostGuide_OrgRoomCd,  orgPostGuide_OrgRoomName  );

	// 所属のクリア
	orgPostGuide_clearOrgPostInfo( 1 );

}

// 所属のクリア
function orgPostGuide_clearOrgPostInfo( clearOrgPost ) {

	// 所属コード１が指定された場合は両方ともクリアさせる
	switch ( clearOrgPost ) {
		case 1:
			orgPostGuide_clearCodeName( orgPostGuide_OrgPostCd1, orgPostGuide_OrgPostName1 );
			break;
		case 2:
			break;
		default:
			return;
	}

	orgPostGuide_clearCodeName( orgPostGuide_OrgPostCd2, orgPostGuide_OrgPostName2 );

}

// すべての個人のクリア
function orgPostGuide_clearAllPerInfo( exceptedIndex ) {

	var i	// インデックス

	// すべての個人のクリア
	for ( i = 0; i < orgPostGuide_PerId.length; i++ ) {

		// 除外インデックスは除く
		if ( exceptedIndex != null ) {
			if ( i == exceptedIndex ) {
				continue;
			}
		}

		// 個人のクリア
		orgPostGuide_clearPerInfo( i );

	}

}

// 個人のクリア
function orgPostGuide_clearPerInfo( index ) {

	// インデックス未指定はすべての個人のクリア
	if ( index == null ) {
		orgPostGuide_clearAllPerInfo();
		return;
	}

	orgPostGuide_clearCodeName( orgPostGuide_PerId[ index ], orgPostGuide_PerName[ index ] );

}

// コード・名称のクリア
function orgPostGuide_clearCodeName( code, name ) {

	if ( code ) {
		code.value = '';
	}

	if ( name ) {
		name.innerHTML = '';
	}

}
//-->
</SCRIPT>
