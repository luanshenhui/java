<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const CONDITION_COUNT = 4	'���͏�����

Const MODE_NORMAL      = "0"	'�\��l���ċA�������[�h(�I�[�o���󂫂Ȃ��Ƃ��Ĕ���)
Const MODE_SAME_RSVGRP = "1"	'�\��l���ċA�������[�h(�I�[�o���󂫂���Ƃ��Ĕ���)

Const PRTFIELD_SET = "RSVLIST2"	'�O��Z�b�g�\���̂��߂̏o�̓t�B�[���h��`

Dim strArray()	'�ėp�z��ϐ�
Dim i			'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�\��g����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����������N���X
'
' �����@�@ : (In)     index  ����������ʃt�H�[���̃C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function entryInfo( index ) {

	var arrOptCd;		// �I�v�V�����R�[�h
	var arrOptBranchNo;	// �I�v�V�����}��
	var selOptCd;		// �I�v�V�����R�[�h�A�}��

	var objForm = main.document.entryForm[ index ];

	// �I�v�V�����R�[�h�̎擾�J�n
	arrOptCd = new Array();
	arrOptBranchNo = new Array();

	// �S�G�������g������
	for ( var i = 0, j = 0; i < objForm.elements.length; i++ ) {

		// �I�v�V�����R�[�h�ȊO�̃G�������g�̓X�L�b�v
		if ( objForm.elements[ i ].name.indexOf( 'opt' ) != 0 ) {
			continue;
		}

		// �^�C�v�𔻒f
		switch ( objForm.elements[ i ].type ) {

			case 'checkbox':	// �`�F�b�N�{�b�N�X�A���W�I�{�^���̏ꍇ
			case 'radio':

				// �I������Ă����
				if ( objForm.elements[ i ].checked ) {

					// �J���}�ŃR�[�h�Ǝ}�Ԃ𕪗����A�ǉ�
					selOptCd = objForm.elements[ i ].value.split(',');
					arrOptCd[ j ] = selOptCd[ 0 ];
					arrOptBranchNo[ j ] = selOptCd[ 1 ];
					j++;

				}

				break;

			default:

		}

	}

	// �v���p�e�B�̐ݒ�
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

	// �����\�ȏ����𖞂����Ă��邩�̃`�F�b�N
	function _conditionFilled() {

		for ( var ret = false; ; ) {

			// �l���m��A���l���E���ʁE�N������������Ă��Ȃ���Ώ����͖������Ȃ�
			if ( this.perId == '' && ( this.manCnt == '' || this.gender == '' || this.age == '' ) ) break;

			// �_��p�^�[�����m��A�܂��̓p�^�[���m��Ȃ������f�敪���m��ł���Ώ����͖������Ȃ�
			if ( this.ctrPtCd == '' || this.cslDivCd == '' ) break;

			ret = true;
			break;
		}

		return ret;

	}

	// �O�����烁�\�b�h�Ƃ��ė��p
	entryInfo.prototype.conditionFilled = _conditionFilled;

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�[�h�����̂̃N���X
'
' �����@�@ : (In)     code      �R�[�h
' �@�@�@�@   (In)     codeName  ����
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
' �@�\�@�@ : �Z���N�V�����{�b�N�X�̕ҏW
'
' �����@�@ : (In)     elementName   �G�������g��
' �@�@�@�@   (In)     index         �C���f�b�N�X
' �@�@�@�@   (In)     codeNameInfo  �R�[�h�A���̏��
' �@�@�@�@   (In)     selectedCode  �I�����ׂ��R�[�h
' �@�@�@�@   (In)     emptyRows     true�w�莞�͏�ɋ�s��K�v�Ƃ���
'
'-------------------------------------------------------------------------------
%>
function editSelectionBox( elementName, index, codeNameInfo, selectedCode, emptyRows ) {

	// �ΏۃG�������g�̐ݒ�
	var selectionElement = main.document.entryForm[ index ].elements(elementName);

	// �R�[�h��񂪑��݂��Ȃ���ΏI��
	if ( !codeNameInfo ) {
		selectionElement.length = 0;
		return;
	}

	// �I�����ׂ��v�f�̑��݃`�F�b�N
	var exists = false;
	for ( var i = 0; i < codeNameInfo.length; i++ ) {
		if ( codeNameInfo[ i ].code == selectedCode ) {
			exists = true;
			break;
		}
	}

	// �v�f���̐ݒ�
	selectionElement.length = codeNameInfo.length + ( ( !exists || emptyRows ) ? 1 : 0 );

	// �v�f�̒ǉ��J�n
	var optIndex = 0;

	// �I�����ׂ��v�f�����݂��Ȃ��A�܂��͏�ɋ�s��K�v�Ƃ���ꍇ�͋�s��ǉ�
	if ( !exists || emptyRows ) {
		selectionElement.options[ optIndex ].value = '';
		selectionElement.options[ optIndex ].text  = '';
		selectionElement.options[ optIndex ].selected = !exists;
		optIndex++;
	}

	// �v�f�̒ǉ��J�n
	for ( var i = 0; i < codeNameInfo.length; i++ ) {

		// �v�f�̒ǉ�
		selectionElement.options[ optIndex ].value = codeNameInfo[ i ].code;
		selectionElement.options[ optIndex ].text  = codeNameInfo[ i ].codeName;

		// �I�����ׂ��v�f�ł���ΑI����Ԃɂ���
		if ( codeNameInfo[ i ].code == selectedCode ) {
			selectionElement.options[ optIndex ].selected = true;
		}

		optIndex++;
	}

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���̕ҏW
'
' �����@�@ : (In)     index         �C���f�b�N�X
' �@�@�@�@   (In)     perId         �l�h�c
' �@�@�@�@   (In)     perName       ����
' �@�@�@�@   (In)     perKName      �J�i����
' �@�@�@�@   (In)     birth         ���N����
' �@�@�@�@   (In)     age           ��f���N��
' �@�@�@�@   (In)     gender        ����
' �@�@�@�@   (In)     compPerId     �����Ҍl�h�c
' �@�@�@�@   (In)     mode          �l�w�胂�[�h��(0:�͂��A1:������)
' �@�@�@�@   (In)     conditionAge  �N��e�L�X�g�ɕ\�����ׂ��N��

' �@�@�@�@   (In)     rsvNo         �Ō�̗\��ԍ�
' �@�@�@�@   (In)     perCmt      �@�R�����g�����i0:�Ȃ��A1�F����j
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
// 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��ߕύX START
//function editPerson( index, perId, perName, perKName, birth, age, gender, compPerId, mode, conditionAge ) {
// 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��ߕύX END

function editPerson( index, perId, perName, perKName, birth, age, gender, compPerId, mode, conditionAge, rsvNo, perCmt ) {


    var objDoc   = main.document;
	var objForm  = objDoc.entryForm[ index ];
	var dateForm = objDoc.dateForm;

	// �l�h�c�`�N��܂ł̕ҏW
	objForm.perId.value = perId;
	objDoc.getElementById('perId'    + index).innerHTML = perId;
	objDoc.getElementById('perName'  + index).innerHTML = perName;
	objDoc.getElementById('perKName' + index).innerHTML = ( perKName != '' ) ? '�i' + perKName + '�j' : '';
	objDoc.getElementById('birth'    + index).innerHTML = ( birth    != '' ) ? birth + '��' : '';
	objDoc.getElementById('age'      + index).innerHTML = ( age      != '' ) ? age + '��' : '';

	// ���ʂ̕ҏW
	switch ( gender ) {
		case '<%= GENDER_MALE %>':
			objDoc.getElementById('gender' + index).innerHTML = '�j��';
			break;
		case '<%= GENDER_FEMALE %>':
			objDoc.getElementById('gender' + index).innerHTML = '����';
			break;
		default:
			objDoc.getElementById('gender' + index).innerHTML = '';
	}

	// �O��Z�b�g�Q�Ɨp�A���J�[����
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

		objDoc.getElementById('showSet' + index).innerHTML = '<A HREF="' + url + '" TARGET="_blank"><IMG SRC="/webHains/images/history.gif" WIDTH="77" HEIGHT="24" ALT="��f����\�����܂�"><\/A>';

    // 20080417 �\��g������ʂɃR�����g�{�^���ǉ� START

    // �l���܂��͎�M���R�����g������ꍇ
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
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:showComment('+index+');"><IMG SRC="/webHains/images/comment_b.gif" WIDTH="77" HEIGHT="24" ALT="�R�����g����\�����܂�"><\/A>';
                } else {
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:showComment('+index+');"><IMG SRC="/webHains/images/comment.gif" WIDTH="77" HEIGHT="24" ALT="�R�����g����\�����܂�"><\/A>';
                }

            } else {
                objDoc.getElementById('showComment' + index).innerHTML = '<A HREF="javascript:alert(\'���f�҂̂��߁A�R�����g���\���ł��܂���B\');"><IMG SRC="/webHains/images/comment.gif" WIDTH="77" HEIGHT="24"><\/A>';
            }
        // 20080417 �\��g������ʂɃR�����g�{�^���ǉ� END


	} else {
		objDoc.getElementById('showSet' + index).innerHTML = '';
		objDoc.getElementById('showComment' + index).innerHTML = '';
	}

	// �����Ҍl�h�c�̕ҏW
	objForm.compPerId.value = compPerId;

	// �l�w�胂�[�h�łȂ���ΔN��e�L�X�g�̕ҏW���s��
	if ( mode == 1 ) {
		objForm.entAge.value = conditionAge;
		objForm.age.value    = conditionAge;
	}

	// �P�Ԗڂ̏����ɂ��Ă̕ҏW���ȊO�͂����ŏI��
	if ( index != 0 ) return;

	// �u�v�w�ŃZ�b�g�v�@�\�̐���
	var html = '';

	// �l���w�肳��A�������Ҍl�h�c�����ꍇ�̂ݗL��
	if ( objForm.perId.value != '' && objForm.compPerId.value != '' ) {
//		html = '<A HREF="javascript:compSetControl()">�v�w�ŃZ�b�g<\/A>';
		html = '<A HREF="javascript:compSetControl()"><IMG SRC="/webHains/images/friendSet.gif" WIDTH="110" HEIGHT="24" ALT="�����҂��Z�b�g"><\/A>';
	}

	objDoc.getElementById('compSet').innerHTML = html;

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̏��̕ҏW
'
' �����@�@ : (In)     index     �C���f�b�N�X
' �@�@�@�@   (In)     orgCd1    �c�̃R�[�h�P
' �@�@�@�@   (In)     orgCd2    �c�̃R�[�h�Q
' �@�@�@�@   (In)     orgName   �c�̖���
' �@�@�@�@   (In)     orgKName  �c�̃J�i����
'
' �߂�l�@ :
'
' ���l�@�@ :
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
    objDoc.getElementById('orgKName' + index).innerHTML = '�i' + orgKName + '�j';

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
        objDoc.getElementById('orgKName' + index).innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+'�i' + orgKName + '�j'+'<\/b><\/font>';
    } else {
        objDoc.getElementById('dspOrgCd' + index).innerHTML = orgCd1 + '-' + orgCd2;
        objDoc.getElementById('orgName'  + index).innerHTML = orgName;
        objDoc.getElementById('orgKName' + index).innerHTML = '�i' + orgKName + '�j';
    }

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �_��p�^�[�����̕ҏW
'
' �����@�@ : (In)     index    �C���f�b�N�X
' �@�@�@�@   (In)     ctrPtCd  �_��p�^�[���R�[�h
' �@�@�@�@   (In)     orgCd1   �c�̃R�[�h�P
' �@�@�@�@   (In)     orgCd2   �c�̃R�[�h�Q
' �@�@�@�@   (In)     csCd     �R�[�X�R�[�h
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function editCtrPtInfo( index, ctrPtCd, orgCd1, orgCd2, csCd ) {

	// �ҏW�G�������g�̐ݒ�
	var objCtrPtCd = main.document.entryForm[ index ].ctrPtCd;
	var objElem    = main.document.getElementById('refCtr' + index);

	// �_��p�^�[�������݂��Ȃ��ꍇ
	if ( ctrPtCd == '' ) {
		objCtrPtCd.value  = '';
		objElem.innerHTML = '';
		return;
	}

	// �A���J�[�ҏW
	var url = '/webHains/contents/contract/ctrDetail.asp';
	url = url + '?orgCd1='  + orgCd1;
	url = url + '&orgCd2='  + orgCd2;
	url = url + '&csCd='    + csCd;
	url = url + '&ctrPtCd=' + ctrPtCd;

	objCtrPtCd.value  = ctrPtCd;
//	objElem.innerHTML = '<A HREF="' + url + '" TARGET="_blank">���̌_����Q��<\/A>';
	objElem.innerHTML = '<A HREF="' + url + '" TARGET="_blank"><IMG SRC="/webHains/images/prevCtrpt.gif" ALT="���̌_����Q��"><\/A>';

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �Z�b�g�̕ҏW
'
' �����@�@ : (In)     index  �C���f�b�N�X
' �@�@�@�@   (In)     html   �ҏW���ׂ�HTML������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function editSet( index, html ) {
	main.document.getElementById('optTable' + index).innerHTML = html;
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �u���̎�f�҂̂݌����v�A���J�[�̉ې���
'
' �����@�@ : (In)     index  �C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function editAnchor( index ) {

	var html = '';	// HTML������

	// �����������N���X�̃C���X�^���X�쐬
	var	entry = new entryInfo( index );

	// �����\�ȏ����𖞂����Ă���΃A���J�[��ҏW
	if ( entry.conditionFilled() ) {
//		html = '<A HREF="javascript:search(' + '<%= MODE_NORMAL %>' + ', ' + index + ')">���̎�f�҂̂݌���<\/A>';
//		html = '<A HREF="javascript:search(' + index + ')">���̎�f�҂̂݌���<\/A>';
		html = '<A HREF="javascript:search(' + index + ')"><IMG SRC="/webHains/images/SearchOnly.gif" ALT="���̎�f�҂����������܂��B"><\/A>';
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
		'�A�X�^���X�N�̃J���}�t����������쐬����
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
