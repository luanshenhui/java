<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(���C����) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const SELECT_ALL = "���ׂ�"	'�I���������f�t�H���g�l

Dim lngMode					'�˗��^���ʃ��[�h�@1:�˗��A2:����
Dim lngGroup				'�O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
Dim lngItem					'�������ڕ\���L���@0:�\�����Ȃ��A1:�\������
Dim lngQuestion				'��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������
Dim lngTableDiv				'�e�[�u���I���敪�@1:�������ځA�@2:�O���[�v�@(0:�f�t�H���g�l)
Dim strClassCd				'��������R�[�h
Dim strClassName			'�������얼
Dim strSearchChar			'�����p�擪������
Dim lngSelectCount			'�I���ςݍ��ڐ�

'�T�[�`����������
Dim strInitSearchHeader		'�w�b�_�[��
Dim strInitSearchList		'���X�g��
Dim strInitSearchSelected	'�I���ςݕ\����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngMode     = Request("mode")
lngGroup    = Request("group")
lngItem     = Request("item")
lngQuestion = Request("question")

'�����l�ݒ�
lngTableDiv    = 0
strClassCd     = ""
strClassName   = SELECT_ALL
strSearchChar  = ""
lngSelectCount = 0

'�����Ăяo�������ݒ�(�w�b�_�[���A���X�g���A�I���ςݕ\����)
strInitSearchHeader   = "?group="      & CStr(lngGroup)    & _
						"&item="       & CStr(lngItem)
strInitSearchList     = "?mode="       & CStr(lngMode)     & _
						"&question="   & CStr(lngQuestion) & _
						"&tablediv="   & CStr(lngTableDiv) & _
						"&classcd="    & strClassCd        & _
						"&classname="  & strClassName      & _
						"&searchchar=" & strSearchChar
strInitSearchSelected = "?count="      & CStr(lngSelectCount)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ڃK�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �I���ς݂̍��ڂ�ێ����邽�߂̃I�u�W�F�N�g���`
var selectedList  = new Array();

// �Ăь�����̈�����ێ����邽�߂̒�`
var gdeMode       = <%= lngMode %>;			/* �˗��^���ʃ��[�h�@1:�˗��A2:���� */
var gdeGroup      = <%= lngGroup %>;		/* �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������ */
var gdeItem       = <%= lngItem %>;			/* �������ڕ\���L���@0:�\�����Ȃ��A1:�\������ */
var gdeQuestion   = <%= lngQuestion %>;		/* ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������ */

// �i�������p�̈�����ێ����邽�߂̒�`
var gdeTableDiv;							/* �e�[�u���I���敪�@1:�������ځA�@2:�O���[�v�@(0:�f�t�H���g�l) */
var gdeClassCd;								/* ��������R�[�h */
var gdeClassName;							/* �������얼 */
var gdeSearchChar;							/* �����p�擪������ */

// �f�t�H���g�l
gdeTableDiv   = 0;
gdeClassCd    = '';
gdeClassName  = '���ׂ�';
gdeSearchChar = '';

// �I�����ڏ�񌟍�
function searchItem(searchValue) {

	var i;

	// �I�����ڂ��������A�������͂��̃C���f�b�N�X��Ԃ�
	for (i = 0; i < selectedList.length; i++ ) {
		if (( selectedList[i][0] == searchValue[0] ) && ( selectedList[i][1] == searchValue[1] )) {
			return i;
		}
	}

	return -1;
}

// �I�����ڏ��̐���B�������ڃ`�F�b�N�{�b�N�X��ONCLICK�C�x���g����Ăяo�����B
function controlSelectedItem( element ) {

	var pos;
	var gdeLocation;
	var gdeSearch;

	var wkSelectedList;	// �ޔ�p�̑I�����X�g

	// �`�F�b�N���ꂽ�ꍇ
	if ( element.checked ) {

		// ���łɑI�����ڏ��Ƃ��đ��݂��邩�������A���݂��Ȃ��ꍇ�͑I�����ڏ��Ƃ��Ēǉ�����
		if ( searchItem( element.value.split( ',', 2 ) ) < 0 ) {
			selectedList[selectedList.length] = element.value.split(',');
		}

	// �`�F�b�N���O���ꂽ�ꍇ
	} else {

		// ���ݑI�����ڏ��Ƃ��đ��݂��邩�������A���݂���ꍇ�͑I�����ڏ�񂩂珜�O����
		if ( ( pos = searchItem( element.value.split( ',', 2 ) ) ) >= 0 ) {

			// �I�����X�g��ޔ�
			wkSelectedList = selectedList;

			// �V�����z��쐬
			selectedList  = new Array();

			// �`�F�b�N���͂��������ڈȊO��ǉ�
			for ( var i = 0; i < wkSelectedList.length; i++ ) {
				if ( i != pos ) {
					selectedList[selectedList.length] = wkSelectedList[i];
				}
			}

		}

	}

	// �I���ςݍ��ڕ\�����X�V
	gdeLocation = 'gdeItemSelected.asp';
	gdeSearch   = '?count=' + selectedList.length;
	self.SELECTED.location.replace( gdeLocation + gdeSearch );

	return false;

}

// ���X�g���Ɉ�����n��
function setParamToList() {

	var gdeLocation;
	var gdeSearch;

	// �Ăяo����̕ҏW
	gdeLocation = 'gdeItemList.asp';
	gdeSearch   = '?mode=' + gdeMode + '&question=' + gdeQuestion + '&tableDiv=' + gdeTableDiv + '&classCd=' + gdeClassCd + '&className=' + escape(gdeClassName) + '&searchChar=' + escape(gdeSearchChar);

	// ���X�g���Ăяo��
	self.main.location.replace( gdeLocation + gdeSearch );

}

// ���ڃR�[�h�A�T�t�B�b�N�X�A���ڕ��ނ��Z�b�g���ČĂяo�����֕Ԃ�
function selectList() {

	var i;

	// �Ԃ�p�o�b�t�@�֊i�[
	var dataDivBuf    = new Array();	// ���ڕ���
	var itemCdBuf     = new Array();	// ���ڃR�[�h
	var suffixBuf     = new Array();	// �T�t�B�b�N�X(�������ڎ��̂ݗL��)
	var itemNameBuf   = new Array();	// �������ږ�
	var resultTypeBuf = new Array();	// ���ʃ^�C�v
	var itemTypeBuf   = new Array();	// ���ڃ^�C�v
	
	if ( selectedList.length > 0 ) {
		for (i = 0; i < selectedList.length; i++ ) {
			itemCdBuf[ i ]     = selectedList[ i ][ 0 ];
			suffixBuf[ i ]     = selectedList[ i ][ 1 ];
			dataDivBuf[ i ]    = selectedList[ i ][ 2 ];
			itemNameBuf[ i ]   = selectedList[ i ][ 3 ];
			resultTypeBuf[ i ] = selectedList[ i ][ 4 ];
			itemTypeBuf[ i ]   = selectedList[ i ][ 5 ];
		}
	} else {
		dataDivBuf    = '';
		itemCdBuf     = '';
		suffixBuf     = '';
		itemNameBuf   = '';
		resultTypeBuf = '';
		itemTypeBuf   = '';
	}

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A�I���������ڕ��ށA���ڃR�[�h�A�T�t�B�b�N�X�A�������ږ���ҏW
	if ( opener.itmGuide_dataDiv  != null ) {
		opener.itmGuide_dataDiv  = dataDivBuf;		// ���ڕ���
	}

	if ( opener.itmGuide_itemCd   != null ) {
		opener.itmGuide_itemCd   = itemCdBuf;		// ���ڃR�[�h
	}

	if ( opener.itmGuide_suffix   != null ) {
		opener.itmGuide_suffix   = suffixBuf;		// �T�t�B�b�N�X
	}

	if ( opener.itmGuide_itemName != null ) {
		opener.itmGuide_itemName = itemNameBuf;		// �������ږ�
	}

	if ( opener.itmGuide_resultType != null ) {
		opener.itmGuide_resultType = resultTypeBuf;	// ���ʃ^�C�v
	}

	if ( opener.itmGuide_itemType != null ) {
		opener.itmGuide_itemType = itemTypeBuf;		// ���ڃ^�C�v
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.itmGuide_CalledFunction != null ) {
		opener.itmGuide_CalledFunction();
	}

	opener.winGuideItm = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="30,*,48" FRAMEBORDER="no" FRAMESPACING="1" BORDER="1">
	<FRAME NAME="TOP" SRC="gdeItemHeader.asp<%= strInitSearchHeader %>" FRAMEBORDER="NO" SCROLLING="NO">
	<FRAMESET COLS="155,*,160" FRAMEBORDER="NO" FRAMESPACING="0" BORDER="1">
		<FRAME NAME="SUBJECT"  SRC="gdeItemSubject.asp"                              FRAMEBORDER="no" NORESIZE>
		<FRAME NAME="main"     SRC="gdeItemList.asp<%= strInitSearchList %>"         FRAMEBORDER="no" NORESIZE>
		<FRAME NAME="SELECTED" SRC="gdeItemSelected.asp<%= strInitSearchSelected %>" FRAMEBORDER="no" NORESIZE>
	</FRAMESET>
	<FRAME NAME="HEADTOKEN" SRC="gdeItemInitial.asp" FRAMEBORDER="no" NORESIZE>
</FRAMESET>
</HTML>
