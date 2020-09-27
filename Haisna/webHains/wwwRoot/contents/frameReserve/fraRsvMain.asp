<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠検索 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CONDITION_COUNT = 4	'入力条件数

Const MODE_NORMAL      = "0"	'予約人数再帰検索モード(オーバを空きなしとして判定)
Const MODE_SAME_RSVGRP = "1"	'予約人数再帰検索モード(オーバを空きありとして判定)

Const PRTFIELD_SET = "RSVLIST2"	'前回セット表示のための出力フィールド定義

Dim strArray()	'汎用配列変数
Dim i			'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>予約枠検索</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件情報クラス
'
' 引数　　 : (In)     index  条件検索画面フォームのインデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function entryInfo( index ) {

	var arrOptCd;		// オプションコード
	var arrOptBranchNo;	// オプション枝番
	var selOptCd;		// オプションコード、枝番

	var objForm = main.document.entryForm[ index ];

	// オプションコードの取得開始
	arrOptCd = new Array();
	arrOptBranchNo = new Array();

	// 全エレメントを検索
	for ( var i = 0, j = 0; i < objForm.elements.length; i++ ) {

		// オプションコード以外のエレメントはスキップ
		if ( objForm.elements[ i ].name.indexOf( 'opt' ) != 0 ) {
			continue;
		}

		// タイプを判断
		switch ( objForm.elements[ i ].type ) {

			case 'checkbox':	// チェックボックス、ラジオボタンの場合
			case 'radio':

				// 選択されていれば
				if ( objForm.elements[ i ].checked ) {

					// カンマでコードと枝番を分離し、追加
					selOptCd = objForm.elements[ i ].value.split(',');
					arrOptCd[ j ] = selOptCd[ 0 ];
					arrOptBranchNo[ j ] = selOptCd[ 1 ];
					j++;

				}

				break;

			default:

		}

	}

	// プロパティの設定
	this.index       = index;
	this.perId       = objForm.perId.value;
	this.manCnt      = objForm.manCnt.value;
	this.gender      = objForm.gender.value;
	this.birth       = objForm.birth.value;
	this.age         = objForm.age.value;
	this.romeName    = objForm.romeName.value.toUpperCase();
	this.orgCd1      = objForm.orgCd1.value;
	this.orgCd2      = objForm.orgCd2.value;
	this.cslDivCd    = objForm.cslDivCd.value;
	this.csCd        = objForm.csCd.value;
	this.rsvGrpCd    = objForm.rsvGrpCd.value;
	this.ctrPtCd     = objForm.ctrPtCd.value;
	this.rsvNo       = objForm.rsvNo.value;
	this.optCd       = arrOptCd;
	this.optBranchNo = arrOptBranchNo;

	// 検索可能な条件を満たしているかのチェック
	function _conditionFilled() {

		for ( var ret = false; ; ) {

			// 個人未確定、かつ人数・性別・年齢条件が揃っていなければ条件は満たさない
			if ( this.perId == '' && ( this.manCnt == '' || this.gender == '' || this.age == '' ) ) break;

			// 契約パターン未確定、またはパターン確定ながらも受診区分未確定であれば条件は満たさない
			if ( this.ctrPtCd == '' || this.cslDivCd == '' ) break;

			ret = true;
			break;
		}

		return ret;

	}

	// 外部からメソッドとして利用
	entryInfo.prototype.conditionFilled = _conditionFilled;

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : コード＆名称のクラス
'
' 引数　　 : (In)     code      コード
' 　　　　   (In)     codeName  名称
'
'-------------------------------------------------------------------------------
%>
function codeAndName( code, codeName ) {
	this.code     = code;
	this.codeName = codeName;
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : セレクションボックスの編集
'
' 引数　　 : (In)     elementName   エレメント名
' 　　　　   (In)     index         インデックス
' 　　　　   (In)     codeNameInfo  コード、名称情報
' 　　　　   (In)     selectedCode  選択すべきコード
' 　　　　   (In)     emptyRows     true指定時は常に空行を必要とする
'
'-------------------------------------------------------------------------------
%>
function editSelectionBox( elementName, index, codeNameInfo, selectedCode, emptyRows ) {

	// 対象エレメントの設定
	var selectionElement = main.document.entryForm[ index ].elements(elementName);

	// コード情報が存在しなければ終了
	if ( !codeNameInfo ) {
		selectionElement.length = 0;
		return;
	}

	// 選択すべき要素の存在チェック
	var exists = false;
	for ( var i = 0; i < codeNameInfo.length; i++ ) {
		if ( codeNameInfo[ i ].code == selectedCode ) {
			exists = true;
			break;
		}
	}

	// 要素数の設定
	selectionElement.length = codeNameInfo.length + ( ( !exists || emptyRows ) ? 1 : 0 );

	// 要素の追加開始
	var optIndex = 0;

	// 選択すべき要素が存在しない、または常に空行を必要とする場合は空行を追加
	if ( !exists || emptyRows ) {
		selectionElement.options[ optIndex ].value = '';
		selectionElement.options[ optIndex ].text  = '';
		selectionElement.options[ optIndex ].selected = !exists;
		optIndex++;
	}

	// 要素の追加開始
	for ( var i = 0; i < codeNameInfo.length; i++ ) {

		// 要素の追加
		selectionElement.options[ optIndex ].value = codeNameInfo[ i ].code;
		selectionElement.options[ optIndex ].text  = codeNameInfo[ i ].codeName;

		// 選択すべき要素であれば選択状態にする
		if ( codeNameInfo[ i ].code == selectedCode ) {
			selectionElement.options[ optIndex ].selected = true;
		}

		optIndex++;
	}

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報の編集
'
' 引数　　 : (In)     index         インデックス
' 　　　　   (In)     perId         個人ＩＤ
' 　　　　   (In)     perName       氏名
' 　　　　   (In)     perKName      カナ氏名
' 　　　　   (In)     birth         生年月日
' 　　　　   (In)     age           受診時年齢
' 　　　　   (In)     gender        性別
' 　　　　   (In)     compPerId     同伴者個人ＩＤ
' 　　　　   (In)     mode          個人指定モードか(0:はい、1:いいえ)
' 　　　　   (In)     conditionAge  年齢テキストに表示すべき年齢

' 　　　　   (In)     rsvNo         最後の予約番号
' 　　　　   (In)     perCmt      　コメント件数（0:なし、1：あり）
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
// 20080417 予約枠検査画面にコメントボタン追加のため変更 START
//function editPerson( index, perId, perName, perKName, birth, age, gender, compPerId, mode, conditionAge ) {
// 20080417 予約枠検査画面にコメントボタン追加のため変更 END

function editPerson( index, perId, perName, perKName, birth, age, gender, compPerId, mode, conditionAge, rsvNo, perCmt ) {


    var objDoc   = main.document;
	var objForm  = objDoc.entryForm[ index ];
	var dateForm = objDoc.dateForm;

	// 個人ＩＤ～年齢までの編集
	objForm.perId.value = perId;
	objDoc.getElementById('perId'    + index).innerHTML = perId;
	objDoc.getElementById('perName'  + index).innerHTML = perName;
	objDoc.getElementById('perKName' + index).innerHTML = ( perKName != '' ) ? '（' + perKName + '）' : '';
	objDoc.getElementById('birth'    + index).innerHTML = ( birth    != '' ) ? birth + '生' : '';
	objDoc.getElementById('age'      + index).innerHTML = ( age      != '' ) ? age + '歳' : '';

	// 性別の編集
	switch ( gender ) {
		case '<%= GENDER_MALE %>':
			objDoc.getElementById('gender' + index).innerHTML = '男性';
			break;
		case '<%= GENDER_FEMALE %>':
			objDoc.getElementById('gender' + index).innerHTML = '女性';
			break;
		default:
			objDoc.getElementById('gender' + index).innerHTML = '';
	}

	// 前回セット参照用アンカー制御
	if ( perId != '' ) {

		var url = '/webHains/contents/common/dailyList.asp';
		url = url + '?navi='     + '1';
		url = url + '&key='      + 'ID:' + perId;
		url = url + '&strYear='  + '1970';
		url = url + '&strMonth=' + '1';
		url = url + '&strDay='   + '1';
		url = url + '&endYear='  + dateForm.cslYear.value;
		url = url + '&endMonth=' + dateForm.cslMonth.value;
		url = url + '&endDay='   + dateForm.cslDay.value;
		url = url + '&prtField=' + '<%= PRTFIELD_SET %>';
		url = url + '&sortKey='  + '12';
		url = url + '&sortType=' + '1';

		objDoc.getElementById('showSet' + index).innerHTML = '<A HREF="' + url + '" TARGET="_blank"><IMG SRC="/webHains/images/history.gif" WIDTH="77" HEIGHT="24" ALT="受診歴を表示します"><\/A>';

    // 20080417 予約枠検査画面にコメントボタン追加 START

    // 個人かまたは受信情報コメントがある場合
            if ( rsvNo != 0 ) {
                url = '/WebHains/contents/comment/commentMainFlame.asp';
                url = url + '?dispMode='    + '0';
                url = url + '&cmtMode='     + '1,1,1,1';
                url = url + '&strYear='     + '1970';
		        url = url + '&strMonth='    + '1';
		        url = url + '&strDay='      + '1';
		        url = url + '&endYear='     + dateForm.cslYear.value;
		        url = url + '&endMonth='    + dateForm.cslMonth.value;
		        url = url + '&endDay='      + dateForm.cslDay.value;
                url = url + '&perId='       + main.document.entryForm[ index ].perId.value;
                url = url + '&orgCd1='      + main.document.entryForm[ index ].orgCd1.value;
                url = url + '&orgCd2='      + main.document.entryForm[ index ].orgCd2.value;
                url = url + '&ctrPtCd='     + main.document.entryForm[ index ].ctrPtCd.value;
                url = url + '&rsvNo='       + rsvNo;
                
                main.document.entryForm[ index ].hiddenUrl.value = url;
                if ( perCmt > 0 ) {
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:showComment('+index+');"><IMG SRC="/webHains/images/comment_b.gif" WIDTH="77" HEIGHT="24" ALT="コメント情報を表示します"><\/A>';
                } else {
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:showComment('+index+');"><IMG SRC="/webHains/images/comment.gif" WIDTH="77" HEIGHT="24" ALT="コメント情報を表示します"><\/A>';
                }

            } else {
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:alert(\'初診者のため、コメント情報表示できません。\');"><IMG SRC="/webHains/images/comment.gif" WIDTH="77" HEIGHT="24"><\/A>';
            }
        // 20080417 予約枠検査画面にコメントボタン追加 END


	} else {
		objDoc.getElementById('showSet' + index).innerHTML = '';
		objDoc.getElementById('showComment' + index).innerHTML = '';
	}

	// 同伴者個人ＩＤの編集
	objForm.compPerId.value = compPerId;

	// 個人指定モードでなければ年齢テキストの編集を行う
	if ( mode == 1 ) {
		objForm.entAge.value = conditionAge;
		objForm.age.value    = conditionAge;
	}

	// １番目の条件についての編集時以外はここで終了
	if ( index != 0 ) return;

	// 「夫婦でセット」機能の制御
	var html = '';

	// 個人が指定され、かつ同伴者個人ＩＤをもつ場合のみ有効
	if ( objForm.perId.value != '' && objForm.compPerId.value != '' ) {
//		html = '<A HREF="javascript:compSetControl()">夫婦でセット<\/A>';
		html = '<A HREF="javascript:compSetControl()"><IMG SRC="/webHains/images/friendSet.gif" WIDTH="110" HEIGHT="24" ALT="同伴者をセット"><\/A>';
	}

	objDoc.getElementById('compSet').innerHTML = html;

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報の編集
'
' 引数　　 : (In)     index     インデックス
' 　　　　   (In)     orgCd1    団体コード１
' 　　　　   (In)     orgCd2    団体コード２
' 　　　　   (In)     orgName   団体名称
' 　　　　   (In)     orgKName  団体カナ名称
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
/************************************************************************************
function editOrg( index, orgCd1, orgCd2, orgName, orgKName ) {

    var objDoc  = main.document;
    var objForm = objDoc.entryForm[ index ];

    objForm.orgCd1.value = orgCd1;
    objForm.orgCd2.value = orgCd2;
    objDoc.getElementById('dspOrgCd' + index).innerHTML = orgCd1 + '-' + orgCd2;
    objDoc.getElementById('orgName'  + index).innerHTML = orgName;
    objDoc.getElementById('orgKName' + index).innerHTML = '（' + orgKName + '）';

}
************************************************************************************/

function editOrg( index, orgCd1, orgCd2, orgName, orgKName, orgHighLight ) {


    var objDoc  = main.document;
    var objForm = objDoc.entryForm[ index ];

    objForm.orgCd1.value = orgCd1;
    objForm.orgCd2.value = orgCd2;
    if (orgHighLight == "1") {
        objDoc.getElementById('dspOrgCd' + index).innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgCd1 + '-' + orgCd2+'<\/b><\/font>';
        objDoc.getElementById('orgName'  + index).innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgName+'<\/b><\/font>';
        objDoc.getElementById('orgKName' + index).innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+'（' + orgKName + '）'+'<\/b><\/font>';
    } else {
        objDoc.getElementById('dspOrgCd' + index).innerHTML = orgCd1 + '-' + orgCd2;
        objDoc.getElementById('orgName'  + index).innerHTML = orgName;
        objDoc.getElementById('orgKName' + index).innerHTML = '（' + orgKName + '）';
    }

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 契約パターン情報の編集
'
' 引数　　 : (In)     index    インデックス
' 　　　　   (In)     ctrPtCd  契約パターンコード
' 　　　　   (In)     orgCd1   団体コード１
' 　　　　   (In)     orgCd2   団体コード２
' 　　　　   (In)     csCd     コースコード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function editCtrPtInfo( index, ctrPtCd, orgCd1, orgCd2, csCd ) {

	// 編集エレメントの設定
	var objCtrPtCd = main.document.entryForm[ index ].ctrPtCd;
	var objElem    = main.document.getElementById('refCtr' + index);

	// 契約パターンが存在しない場合
	if ( ctrPtCd == '' ) {
		objCtrPtCd.value  = '';
		objElem.innerHTML = '';
		return;
	}

	// アンカー編集
	var url = '/webHains/contents/contract/ctrDetail.asp';
	url = url + '?orgCd1='  + orgCd1;
	url = url + '&orgCd2='  + orgCd2;
	url = url + '&csCd='    + csCd;
	url = url + '&ctrPtCd=' + ctrPtCd;

	objCtrPtCd.value  = ctrPtCd;
//	objElem.innerHTML = '<A HREF="' + url + '" TARGET="_blank">この契約を参照<\/A>';
	objElem.innerHTML = '<A HREF="' + url + '" TARGET="_blank"><IMG SRC="/webHains/images/prevCtrpt.gif" ALT="この契約を参照"><\/A>';

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : セットの編集
'
' 引数　　 : (In)     index  インデックス
' 　　　　   (In)     html   編集すべきHTML文字列
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function editSet( index, html ) {
	main.document.getElementById('optTable' + index).innerHTML = html;
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 「この受診者のみ検索」アンカーの可否制御
'
' 引数　　 : (In)     index  インデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function editAnchor( index ) {

	var html = '';	// HTML文字列

	// 検索条件情報クラスのインスタンス作成
	var	entry = new entryInfo( index );

	// 検索可能な条件を満たしていればアンカーを編集
	if ( entry.conditionFilled() ) {
//		html = '<A HREF="javascript:search(' + '<%= MODE_NORMAL %>' + ', ' + index + ')">この受診者のみ検索<\/A>';
//		html = '<A HREF="javascript:search(' + index + ')">この受診者のみ検索<\/A>';
		html = '<A HREF="javascript:search(' + index + ')"><IMG SRC="/webHains/images/SearchOnly.gif" ALT="この受診者だけ検索します。"><\/A>';
	}

	main.document.getElementById('search' + index).innerHTML = html;

}
//-->
</SCRIPT>
</HEAD>
<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="0" ROWS="67,*">
	<FRAME NAME="naviBar" NORESIZE SRC="fraRsvNavibar.asp">
	<FRAMESET COLS="*,0" FRAMEBORDER="no">
		<FRAME NAME="main" SRC="fraRsvCondition.asp">
<%
		'アスタリスクのカンマ付き文字列を作成する
		ReDim Preserve strArray(CONDITION_COUNT - 1)
		For i = 0 To CONDITION_COUNT - 1
			strArray(i) = "*"
		Next
%>
		<FRAMESET ROWS="<%= Join(strArray, ",") %>" FRAMEBORDER="no">
<%
			For i = 0 To CONDITION_COUNT - 1
%>
				<FRAME NAME="ctrl<%= i %>">
<%
			Next
%>
		</FRAMESET>
	</FRAMESET>
</FRAMESET>
</HTML>
