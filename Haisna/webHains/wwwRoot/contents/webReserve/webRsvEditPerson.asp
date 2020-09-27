<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�b�N�\�����݌l��� (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�����l
Dim dtmCslDate	'��f�N����
Dim lngWebNo	'webNo.
Dim dtmBirth	'���N����
Dim strReadOnly	'�ǂݍ��ݐ�p

Dim strURL		'�W�����v���URL

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
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
<TITLE>�h�b�N�\���l���</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ��{���ł̕ێ��l��ݒ�
function getHeader() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var headerForm = header.document.entryForm;

	// �lID
	header.document.getElementById('perId').innerHTML = ( detailForm.perId.value != '' ) ? detailForm.perId.value : '<%= PERID_FOR_NEW_PERSON %>';

	// ����
	headerForm.lastName.value   = detailForm.lastName.value;
	headerForm.firstName.value  = detailForm.firstName.value;
	headerForm.lastKName.value  = detailForm.lastKName.value;
	headerForm.firstKName.value = detailForm.firstKName.value;
	headerForm.romeName.value   = detailForm.romeName.value;

	// ����
	header.document.getElementById('gender').innerHTML = main.editGender( detailForm.gender.value );

}

// ��{���ł̕ێ��l���X�V
function setHeader() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var headerForm = header.document.entryForm;

	// ����
	detailForm.lastName.value   = headerForm.lastName.value;
	detailForm.firstName.value  = headerForm.firstName.value;
	detailForm.lastKName.value  = headerForm.lastKName.value;
	detailForm.firstKName.value = headerForm.firstKName.value;
	detailForm.romeName.value   = headerForm.romeName.value;

}

// ��{���ł̕ێ��l��ݒ�
function getBody() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var bodyForm = body.document.entryForm;

	// �Z�����̕ҏW
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// ���͍���
		bodyForm.zipCd[ i ].value    = detailForm.zipCd[ i ].value;
		bodyForm.prefCd[ i ].value   = detailForm.prefCd[ i ].value;
		bodyForm.cityName[ i ].value = detailForm.cityName[ i ].value;
		bodyForm.address1[ i ].value = detailForm.address1[ i ].value;
		bodyForm.address2[ i ].value = detailForm.address2[ i ].value;
		bodyForm.tel1[ i ].value     = detailForm.tel1[ i ].value;
		bodyForm.phone[ i ].value    = detailForm.phone[ i ].value;
		bodyForm.eMail[ i ].value    = detailForm.eMail[ i ].value;

		// �\������
		body.document.getElementById('tel2_' + i).innerHTML      = detailForm.tel2[ i ].value;
		body.document.getElementById('extension_' + i).innerHTML = detailForm.extension[ i ].value;
		body.document.getElementById('fax_' + i).innerHTML       = detailForm.fax[ i ].value;

	}

}

// ��{���ł̕ێ��l���X�V
function setBody() {

	var main = opener.top;
	var detailForm = main.detail.paramForm;
	var bodyForm = body.document.entryForm;

	// �Z�����̕ҏW
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// ���͍���
		detailForm.zipCd[ i ].value    = bodyForm.zipCd[ i ].value;
		detailForm.prefCd[ i ].value   = bodyForm.prefCd[ i ].value;
		detailForm.cityName[ i ].value = bodyForm.cityName[ i ].value;
		detailForm.address1[ i ].value = bodyForm.address1[ i ].value;
		detailForm.address2[ i ].value = bodyForm.address2[ i ].value;
		detailForm.tel1[ i ].value     = bodyForm.tel1[ i ].value;
		detailForm.phone[ i ].value    = bodyForm.phone[ i ].value;
		detailForm.eMail[ i ].value    = bodyForm.eMail[ i ].value;

		// �s���{����
		var index = bodyForm.prefCd[ i ].selectedIndex;
		if ( index > 0 ) {
			detailForm.prefName[ i ].value = bodyForm.prefCd[ i ].options[ index ].text;
		} else {
			detailForm.prefName[ i ].value = '';
		}

	}

}


// �����񒷃I�[�o�[���̃��b�Z�[�W�ҏW
function editMsgTooLong( addrDivName, fieldName ) {
	return fieldName + '�i' + addrDivName + '�j�̓��͓��e���������܂��B';
}

// ���̓`�F�b�N
function checkValue() {

	var main = opener.top;
	var headerForm = header.document.entryForm;
	var bodyForm   = body.document.entryForm;

	var addrDivName = new Array('����', '�Ζ���', '���̑�');
	var message     = new Array();
	var ret         = true;

	// �J�i���͕K�{
	if ( headerForm.lastKName.value == '' ) {
		message[ message.length ] = '�J�i������͂��ĉ������B';
	}

	// ���͕K�{
	if ( headerForm.lastName.value == '' ) {
		message[ message.length ] = '������͂��ĉ������B';
	}

	// ���[�}�����̕����񒷃`�F�b�N
	if ( main.getByte( headerForm.romeName.value ) > 60 ) {
		message[ message.length ] = '���[�}�����̓��͓��e���������܂��B';
	}

	// �Z�����̕����񒷃`�F�b�N
	for ( var i = 0; i < bodyForm.zipCd.length; i++ ) {

		// �X�֔ԍ�
		if ( main.getByte( bodyForm.zipCd[ i ].value ) > 7 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�X�֔ԍ�' );
		}

		// �s�撬��
		if ( main.getByte( bodyForm.cityName[ i ].value ) > <%= LENGTH_CITYNAME %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�s�撬��' );
		}

		// �Z���P
		if ( main.getByte( bodyForm.address1[ i ].value ) > <%= LENGTH_ADDRESS %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�Z���P' );
		}

		// �Z���Q
		if ( main.getByte( bodyForm.address2[ i ].value ) > <%= LENGTH_ADDRESS %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�Z���Q' );
		}

		// �d�b�ԍ��P
		if ( main.getByte( bodyForm.tel1[ i ].value ) > 15 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�d�b�ԍ��P' );
		}

		// �g�єԍ�
		if ( main.getByte( bodyForm.phone[ i ].value ) > 15 ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], '�g�єԍ�' );
		}

		// e-Mail
		if ( main.getByte( bodyForm.eMail[ i ].value ) > <%= LENGTH_EMAIL %> ) {
			message[ message.length ] = editMsgTooLong( addrDivName[ i ], 'E-Mail�A�h���X' );
		} else {
			if ( !checkEMail( bodyForm.eMail[ i ].value ) ) {
				message[ message.length ] = 'E-Mail�A�h���X�i' + addrDivName[ i ] + '�j�̌`��������������܂���B';
			}
		}

	}

	// ���b�Z�[�W���ݎ��͕ҏW
	if ( message.length > 0 ) {
		main.editMessage( header.document.getElementById('errMsg'), message, true );
		ret = false;
	}

	return ret;
}

// e-Mail�`���`�F�b�N
function checkEMail( stream ) {

	var pos;
	var ret = false;

    for ( ; ; ) {

		if ( stream == '' ) {
			ret = true;
			break;
		}

		// (1-1)"@"�̑��݃`�F�b�N
		pos = stream.indexOf('@');
		if ( pos < 0 ) {
			break;
		}

		// (1-2)"@"������1���݂���Εs��
		if ( stream.indexOf( '@', pos + 1 ) >= 0 ) {
			break;
		}

		// (2)"@"�͐擪�ł��Ō㕔�ł��s��
		if ( pos == 0 || pos == stream.length - 1 ) {
			break;
		}

		// (3)"@"�̌��"."������
		if ( stream.substring( pos + 1, pos + 2 ) == '.' ) {
			break;
		}

		ret = true;
		break;
	}

	return ret;

}

// �o�^����
function regist() {

	// ���̓`�F�b�N���s���A����Ȃ��
	if ( checkValue() ) {

		// ��{���ł̕ێ��l���X�V
		setHeader();
		setBody();

		var headerForm = header.document.entryForm;

		// �l���̕ҏW
		opener.top.editPerson(
			null,
			headerForm.lastName.value,
			headerForm.firstName.value,
			headerForm.lastKName.value,
			headerForm.firstKName.value
		);

		// ��ʂ����
		opener.closeEditPersonalWindow();

	}

}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="400,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
	'�w�b�_��ʂ�URL�ҏW
	strURL = "webRsvEditPersonHeader.asp"
	strURL = strURL & "?cslDate="  & dtmCslDate
	strURL = strURL & "&webNo="    & lngWebNo
	strURL = strURL & "&birth="    & dtmBirth
	strURL = strURL & "&readOnly=" & strReadOnly
%>
	<FRAME SRC="<%= strURL %>" NAME="header">
<%
	'�{�f�B��ʂ�URL�ҏW
	strURL = "webRsvEditPersonBody.asp"
	strURL = strURL & "?readOnly=" & strReadOnly
%>
	<FRAME SRC="<%= strURL %>" NAME="body">
</FRAMESET>
</HTML>
