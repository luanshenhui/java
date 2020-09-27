<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ドック申し込み個人情報 (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'引数値
Dim dtmCslDate	'受診年月日
Dim lngWebNo	'webNo.
Dim dtmBirth	'生年月日
Dim strReadOnly	'読み込み専用

Dim strURL		'ジャンプ先のURL

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
dtmCslDate  = CDate(Request("cslDate"))
lngWebNo    = CLng("0" & Request("webNo"))
dtmBirth    = CDate(Request("birth"))
strReadOnly = Request("readOnly")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ドック申込個人情報</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 基本情報での保持値を設定
function getHeader() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var headerForm = header.document.entryForm;

	// 個人ID
	header.document.getElementById('perId').innerHTML = ( detailForm.perId.value != '' ) ? detailForm.perId.value : '<%= PERID_FOR_NEW_PERSON %>';

	// 姓名
	headerForm.lastName.value   = detailForm.lastName.value;
	headerForm.firstName.value  = detailForm.firstName.value;
	headerForm.lastKName.value  = detailForm.lastKName.value;
	headerForm.firstKName.value = detailForm.firstKName.value;
	headerForm.romeName.value   = detailForm.romeName.value;

	// 性別
	header.document.getElementById('gender').innerHTML = main.editGender( detailForm.gender.value );

}

// 基本情報での保持値を更新
function setHeader() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var headerForm = header.document.entryForm;

	// 姓名
	detailForm.lastName.value   = headerForm.lastName.value;
	detailForm.firstName.value  = headerForm.firstName.value;
	detailForm.lastKName.value  = headerForm.lastKName.value;
	detailForm.firstKName.value = headerForm.firstKName.value;
	detailForm.romeName.value   = headerForm.romeName.value;

}

// 基本情報での保持値を設定
function getBody() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var bodyForm = body.document.entryForm;

	// 住所情報の編集
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// 入力項目
		bodyForm.zipCd[ i ].value    = detailForm.zipCd[ i ].value;
		bodyForm.prefCd[ i ].value   = detailForm.prefCd[ i ].value;
		bodyForm.cityName[ i ].value = detailForm.cityName[ i ].value;
		bodyForm.address1[ i ].value = detailForm.address1[ i ].value;
		bodyForm.address2[ i ].value = detailForm.address2[ i ].value;
		bodyForm.tel1[ i ].value     = detailForm.tel1[ i ].value;
		bodyForm.phone[ i ].value    = detailForm.phone[ i ].value;
		bodyForm.eMail[ i ].value    = detailForm.eMail[ i ].value;

		// 表示項目
		body.document.getElementById('tel2_' + i).innerHTML      = detailForm.tel2[ i ].value;
		body.document.getElementById('extension_' + i).innerHTML = detailForm.extension[ i ].value;
		body.document.getElementById('fax_' + i).innerHTML       = detailForm.fax[ i ].value;

	}

}

// 基本情報での保持値を更新
function setBody() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var bodyForm = body.document.entryForm;

	// 住所情報の編集
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// 入力項目
		detailForm.zipCd[ i ].value    = bodyForm.zipCd[ i ].value;
		detailForm.prefCd[ i ].value   = bodyForm.prefCd[ i ].value;
		detailForm.cityName[ i ].value = bodyForm.cityName[ i ].value;
		detailForm.address1[ i ].value = bodyForm.address1[ i ].value;
		detailForm.address2[ i ].value = bodyForm.address2[ i ].value;
		detailForm.tel1[ i ].value     = bodyForm.tel1[ i ].value;
		detailForm.phone[ i ].value    = bodyForm.phone[ i ].value;
		detailForm.eMail[ i ].value    = bodyForm.eMail[ i ].value;

		// 都道府県名
		var index = bodyForm.prefCd[ i ].selectedIndex;
		if ( index > 0 ) {
			detailForm.prefName[ i ].value = bodyForm.prefCd[ i ].options[ index ].text;
		} else {
			detailForm.prefName[ i ].value = '';
		}

	}

}


// 文字列長オーバー時のメッセージ編集
function editMsgTooLong( addrDivName, fieldName ) {
	return fieldName + '（' + addrDivName + '）の入力内容が長すぎます。';
}

// 入力チェック
function checkValue() {

	var main = opener.top;
	var headerForm = header.document.entryForm;
	var bodyForm   = body.document.entryForm;

	var addrDivName = new Array('自宅', '勤務先', 'その他');
	var message     = new Array();
	var ret         = true;

	// カナ姓は必須
	if ( headerForm.lastKName.value == '' ) {
		message[ message.length ] = 'カナ姓を入力して下さい。';
	}

	// 姓は必須
	if ( headerForm.lastName.value == '' ) {
		message[ message.length ] = '姓を入力して下さい。';
	}

	// ローマ字名の文字列長チェック
	if ( main.getByte( headerForm.romeName.value ) > 60 ) {
		message[ message.length ] = 'ローマ字名の入力内容が長すぎます。';
	}

	// 住所情報の文字列長チェック
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// 郵便番号
		if ( main.getByte( bodyForm.zipCd[ i ].value ) > 7 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '郵便番号' );
		}

		// 市区町村
		if ( main.getByte( bodyForm.cityName[ i ].value ) > <%= LENGTH_CITYNAME %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '市区町村' );
		}

		// 住所１
		if ( main.getByte( bodyForm.address1[ i ].value ) > <%= LENGTH_ADDRESS %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '住所１' );
		}

		// 住所２
		if ( main.getByte( bodyForm.address2[ i ].value ) > <%= LENGTH_ADDRESS %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '住所２' );
		}

		// 電話番号１
		if ( main.getByte( bodyForm.tel1[ i ].value ) > 15 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '電話番号１' );
		}

		// 携帯番号
		if ( main.getByte( bodyForm.phone[ i ].value ) > 15 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '携帯番号' );
		}

		// e-Mail
		if ( main.getByte( bodyForm.eMail[ i ].value ) > <%= LENGTH_EMAIL %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], 'E-Mailアドレス' );
		} else {
			if ( !checkEMail( bodyForm.eMail[ i ].value ) ) {
				message[ message.length ] = 'E-Mailアドレス（' + addrDivName[ i ] + '）の形式が正しくありません。';
			}
		}

	}

	// メッセージ存在時は編集
	if ( message.length > 0 ) {
		main.editMessage( header.document.getElementById('errMsg'), message, true );
		ret = false;
	}

	return ret;
}

// e-Mail形式チェック
function checkEMail( stream ) {

	var pos;
	var ret = false;

    for ( ; ; ) {

		if ( stream == '' ) {
			ret = true;
			break;
		}

		// (1-1)"@"の存在チェック
		pos = stream.indexOf('@');
		if ( pos < 0 ) {
			break;
		}

		// (1-2)"@"がもう1つ存在すれば不可
		if ( stream.indexOf( '@', pos + 1 ) >= 0 ) {
			break;
		}

		// (2)"@"は先頭でも最後部でも不可
		if ( pos == 0 || pos == stream.length - 1 ) {
			break;
		}

		// (3)"@"の後に"."が存在
		if ( stream.substring( pos + 1, pos + 2 ) == '.' ) {
			break;
		}

		ret = true;
		break;
	}

	return ret;

}

// 登録処理
function regist() {

	// 入力チェックを行い、正常ならば
	if ( checkValue() ) {

		// 基本情報での保持値を更新
		setHeader();
		setBody();

		var headerForm = header.document.entryForm;

		// 個人情報の編集
		opener.top.editPerson(
			null,
			headerForm.lastName.value,
			headerForm.firstName.value,
			headerForm.lastKName.value,
			headerForm.firstKName.value
		);

		// 画面を閉じる
		opener.closeEditPersonalWindow();

	}

}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="400,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
	'ヘッダ画面のURL編集
	strURL = "webRsvEditPersonHeader.asp"
	strURL = strURL & "?cslDate="  & dtmCslDate
	strURL = strURL & "&webNo="    & lngWebNo
	strURL = strURL & "&birth="    & dtmBirth
	strURL = strURL & "&readOnly=" & strReadOnly
%>
	<FRAME SRC="<%= strURL %>" NAME="header">
<%
	'ボディ画面のURL編集
	strURL = "webRsvEditPersonBody.asp"
	strURL = strURL & "?readOnly=" & strReadOnly
%>
	<FRAME SRC="<%= strURL %>" NAME="body">
</FRAMESET>
</HTML>
