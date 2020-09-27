<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���A��l���X�V  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DEFAULT_ROW			= 10		'�f�t�H���g�\���s��
Const INCREASE_COUNT		= 5			'�\���s���̑����P��
Const SAMEGRP_SELMAX		= 99		'�ʐړ�����f�̑I�𐔏��(�Ƃ肠�����ݒ肵�Ă���)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f�N���X
Dim objPerson			'�l���A�N�Z�X�p

'�p�����[�^
Dim strAct				'�������
Dim lngRsvNo			'�\��ԍ�
Dim lngDispCnt			'�w��\��f�Ґ�

'��f���p�ϐ�
Dim strPerId			'�lID
Dim strCslDate			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strOrgName			'�c�̖���
Dim strAge				'�N��
Dim strDayId			'����ID
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����

'�l���p�ϐ�
Dim strCompPerId		'�����҂h�c

'���A��l���p�ϐ�
Dim strArrCslDate		'��f���̔z��
Dim strArrSeq			'���A��lSeq�̔z��
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrSameGrp1		'�ʐړ�����f�P�̔z��
Dim strArrSameGrp2		'�ʐړ�����f�Q�̔z��
Dim strArrSameGrp3		'�ʐړ�����f�R�̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrOrgSName		'�c�̖��̂̔z��
Dim strArrLastName		'���̔z��
Dim strArrFirstName		'���̔z��
Dim strArrLastKName		'�J�i���̔z��
Dim strArrFirstKName	'�J�i���̔z��
Dim strArrName			'�����̔z��
Dim strArrKName			'�J�i�����̔z��
Dim strArrRsvGrpName	'�\��Q���̂̔z��
Dim strArrCompOrg		'�����ҌlID�̔z��(�ݒ�O)
Dim strArrCompNew		'�����ҌlID�̔z��(�ݒ��)

'�X�V�p�ϐ�
Dim dtmUpdCslDate		'��f��
Dim lngUpdSeq			'���A��lSeq
Dim vntArrUpdRsvNo		'�\��ԍ��̔z��
Dim vntArrUpdSameGrp1	'�ʐړ�����f�P�̔z��
Dim vntArrUpdSameGrp2	'�ʐړ�����f�P�̔z��
Dim vntArrUpdSameGrp3	'�ʐړ�����f�P�̔z��
Dim lngUpdCount			'�X�V����
Dim strArrMessage		'�G���[���b�Z�[�W
Dim vntArrUpdPerId		'�lID�̔z��
Dim vntArrUpdCompPerId	'�����ҌlID�̔z��
Dim lngUpdCompCount		'�����ҍX�V����

Dim Ret					'�֐��߂�l
Dim lngCount			'�擾����
Dim strHtml				'HTML������
Dim i, j				'�J�E���^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")
Set objPerson		= Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strAct				= Request("act")
lngRsvNo			= Request("rsvno")
lngDispCnt			= CLng("0" & Request("dispCnt"))

strArrCslDate	= ConvIStringToArray(Request("f_csldate"))
strArrSeq		= ConvIStringToArray(Request("f_seq"))
strArrRsvNo		= ConvIStringToArray(Request("f_rsvno"))
strArrSameGrp1	= ConvIStringToArray(Request("f_samegrp1"))
strArrSameGrp2	= ConvIStringToArray(Request("f_samegrp2"))
strArrSameGrp3	= ConvIStringToArray(Request("f_samegrp3"))
strArrPerId		= ConvIStringToArray(Request("f_perid"))
strArrCsName	= ConvIStringToArray(Request("f_csname"))
strArrOrgSName	= ConvIStringToArray(Request("f_orgname"))
strArrName		= ConvIStringToArray(Request("f_name"))
strArrKName		= ConvIStringToArray(Request("f_kname"))
strArrRsvGrpName = ConvIStringToArray(Request("f_rsvgrpname"))
strArrCompOrg	= ConvIStringToArray(Request("comporg"))
strArrCompNew	= ConvIStringToArray(Request("compnew"))

Do
	'��f��񌟍�
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									strCslDate,    _
									strPerId,      _
									strCsCd,       _
									strCsName,     _
									, , _
									strOrgName,    _
									, , _
									strAge,        _
									, , , , , , , , , , , , _
									strDayId,      _
									, , 0, , , , , , , , , , , , , , , _
									strLastName,   _
									strFirstName,  _
									strLastKName,  _
									strFirstKName, _
									strBirth,      _
									strGender )
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	'���A��l���̍폜
	If strAct = "delete" Then
		dtmUpdCslDate = CDate(strArrCslDate(0))
		lngUpdSeq = CLng("0" & strArrSeq(0))

		If lngUpdSeq > 0 Then
			'���A��l���̍폜
			objConsult.DeleteFriends dtmUpdCslDate, lngUpdSeq
			strAct = "deleteend"
		Else
			strAct = ""
		End If

	End If

	'���A��l���̕ۑ�
	If strAct = "save" Then
		vntArrUpdRsvNo = Array()
		vntArrUpdSameGrp1 = Array()
		vntArrUpdSameGrp2 = Array()
		vntArrUpdSameGrp3 = Array()
		lngUpdCount = 0
		vntArrUpdPerId = Array()
		vntArrUpdCompPerId = Array()
		lngUpdCompCount = 0

		For i=0 To UBound(strArrRsvNo)
			If strArrRsvNo(i) <> "" Then
				Redim Preserve vntArrUpdRsvNo(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp1(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp2(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp3(lngUpdCount)
				vntArrUpdRsvNo(lngUpdCount) = strArrRsvNo(i)
				vntArrUpdSameGrp1(lngUpdCount) = strArrSameGrp1(i)
				vntArrUpdSameGrp2(lngUpdCount) = strArrSameGrp2(i)
				vntArrUpdSameGrp3(lngUpdCount) = strArrSameGrp3(i)
'## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
				If strArrCompOrg(i) <> strArrCompNew(i) Then
					Redim Preserve vntArrUpdPerId(lngUpdCompCount)
					Redim Preserve vntArrUpdCompPerId(lngUpdCompCount)
					vntArrUpdPerId(lngUpdCompCount) = strArrPerId(i)
					vntArrUpdCompPerId(lngUpdCompCount) = strArrCompNew(i)
					lngUpdCompCount = lngUpdCompCount + 1
				End If
'## 2004.01.20 Add End
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		If lngUpdCount > 0 Then
			dtmUpdCslDate = CDate(strArrCslDate(0))
			'�V�K�̂Ƃ��͂��A��lSeq��0�Ƃ���i�ۑ����Ɏ������Ԃ���j
			lngUpdSeq = CLng("0" & strArrSeq(0))

			'���A��l����l�����Ȃ��ŕۑ����悤�Ƃ��Ă���
			If lngUpdCount = 1 Then
				If lngUpdSeq > 0 Then
					'���A��l���̍폜
					objConsult.DeleteFriends dtmUpdCslDate, lngUpdSeq
				Else
					strArrMessage = "���A��l����l�����Ȃ��ꍇ�͕ۑ��ł��܂���B"
					Exit Do
				End If
			Else
				'���A��l���̕ۑ�
'## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
				objConsult.UpdateFriends dtmUpdCslDate, lngUpdSeq, vntArrUpdRsvNo, vntArrUpdSameGrp1, vntArrUpdSameGrp2, vntArrUpdSameGrp3, strArrMessage, _
										 vntArrUpdPerId, vntArrUpdCompPerId
'## 2004.01.20 Add End
				If Not IsEmpty(strArrMessage) Then
					Exit Do
				End If
			End If
		End If
		strAct = "saveend"
	End If

	'�\���s���̕ύX�̂Ƃ��͂��A��l�����擾���Ȃ�
	If strAct <> "redisp" Then
		'���A��l�����擾
'## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
		lngCount = objConsult.SelectFriends(strCslDate, _
											lngRsvNo, _
											strArrCslDate,    _
											strArrSeq,        _
											strArrRsvNo,      _
											strArrSameGrp1,   _
											strArrSameGrp2,   _
											strArrSameGrp3,   _
											strArrPerId,      _
											, _
											strArrCsName,     _
											, , , _
											strArrOrgSName,   _
											strArrLastName,   _
											strArrFirstName,  _
											strArrLastKName,  _
											strArrFirstKName, _
											, _
											strArrRsvGrpName, _
											strArrCompOrg   _
											)
'## 2004.01.20 Add End
		If lngCount < 0 Then
			Err.Raise 1000, , "���A��l��񂪑��݂��܂���B�i��f��= " & strCslDate & " �\��ԍ�= " & lngRsvNo & " )"
		End If

		If lngCount = 0 Then
			strArrCslDate = Array()
			strArrSeq = Array()
			strArrRsvNo = Array()
			strArrSameGrp1 = Array()
			strArrSameGrp2 = Array()
			strArrSameGrp3 = Array()
			strArrPerId = Array()
			strArrOrgSName = Array()
			strArrCsName = Array()
			strArrName = Array()
			strArrKName = Array()
			strArrRsvGrpName = Array()
			strArrCompOrg = Array()
			strArrCompNew = Array()

			lngDispCnt = DEFAULT_ROW
		Else
			'�����̕ҏW
			strArrName = Array()
			Redim strArrName(lngCount-1)
			strArrKName = Array()
			Redim strArrKName(lngCount-1)
			For i=0 To lngCount-1
				strArrName(i) = strArrLastName(i) & "�@" & strArrFirstName(i)
				strArrKName(i) = strArrLastKName(i) & "�@" & strArrFirstKName(i)
			Next
'## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
			strArrCompNew = Array()
			Redim strArrCompNew(lngCount-1)
			For i=0 To lngCount-1
				strArrCompNew(i) = strArrCompOrg(i)
			Next
'## 2004.01.20 Add End

			'�w��\��f�Ґ��̔��f
			lngDispCnt = DEFAULT_ROW
			Do
				If lngDispCnt > lngCount Then
					Exit Do
				End If
				lngDispCnt = lngDispCnt + INCREASE_COUNT
			Loop
		End If
	End If

	'��ł��̈���쐬���Ă���
	Redim Preserve strArrCslDate(lngDispCnt)
	Redim Preserve strArrSeq(lngDispCnt)
	Redim Preserve strArrRsvNo(lngDispCnt)
	Redim Preserve strArrSameGrp1(lngDispCnt)
	Redim Preserve strArrSameGrp2(lngDispCnt)
	Redim Preserve strArrSameGrp3(lngDispCnt)
	Redim Preserve strArrPerId(lngDispCnt)
	Redim Preserve strArrOrgSName(lngDispCnt)
	Redim Preserve strArrCsName(lngDispCnt)
	Redim Preserve strArrName(lngDispCnt)
	Redim Preserve strArrKName(lngDispCnt)
	Redim Preserve strArrRsvGrpName(lngDispCnt)
	Redim Preserve strArrCompOrg(lngDispCnt)
	Redim Preserve strArrCompNew(lngDispCnt)

	'�l���ǂݍ���
	Ret = objPerson.SelectPerson_lukes(strPerId, _
										, , , , , , , , , , _
										strCompPerId )
	If Ret = False Then
		Err.Raise 1000, , "�l��񂪑��݂��܂���B�i�lID= " & strPerId & " )"
	End If

	Exit Do
Loop
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���A��l���X�V</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winGuide;						// �l�����K�C�h�E�B���h�E�n���h��
var SelectLineNo;					// �I���ʒu

// �l�����K�C�h�̕\��
function callGuide( index ) {
	var url;							// URL������
	var opened = false;					// ��ʂ����łɊJ����Ă��邩

	// �I���ʒu��ێ�
	SelectLineNo = index;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winGuide != null ) {
		if ( !winGuide.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/guide/gdeConsultList.asp';
	url = url + '?csldate=<%= strCslDate %>';
	url = url + '&perid=<%= strPerId %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winGuide.focus();
		winGuide.location.replace( url );
	} else {
		winGuide = window.open( url, '', 'width=500,height=600,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}
}

// �T�u��ʂ����
function closeWindow() {

	// �����I����ʂ����
	if ( winGuide != null ) {
		if ( !winGuide.closed ) {
			winGuide.close();
		}
	}

	winGuide  = null;
}

// ���A��l���̃N���A
function clearFriends( index ) {
	var myForm = document.entryForm;

	myForm.f_csldate[index].value = '';
	myForm.f_rsvno[index].value   = '';
	myForm.f_perid[index].value   = '';
	myForm.f_orgname[index].value = '';
	myForm.f_csname[index].value  = '';
	myForm.f_name[index].value    = '';
	myForm.f_kname[index].value   = '';
	myForm.f_rsvgrpname[index].value = '';
	myForm.f_samegrp1[index].value   = '';
	myForm.f_samegrp2[index].value   = '';
	myForm.f_samegrp3[index].value   = '';
	myForm.comporg[index].value   = '';
	myForm.compnew[index].value   = '';

	// ���A��l���X�g�̍ĕ\��
	dispFriendsList();
}

// ���A��l���X�g�̕\��
function dispFriendsList() {
	var myForm = document.entryForm;
	var elem   = document.getElementById('FriendsList');
	var strHtml;
	var i, j;

	strHtml = '<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">\n';
	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>�l�h�c</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>����</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>�\��ԍ�</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>��f�c��</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>��f�R�[�X</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>�\��Q</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="3" ALIGN="center" BGCOLOR="#CCFFFF">�ʐڂ𓯎���f</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP BGCOLOR="#FFCCFF">������</TD>\n';
	strHtml = strHtml + '</TR>\n';

	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="12" ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="3" ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD NOWRAP ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '</TR>\n';

	for ( i = 0; i <= <%= lngDispCnt %>; i++ ) {
		strHtml = strHtml + '<TR>\n';
		if( myForm.f_rsvno[i].value == '<%= lngRsvNo %>' ) {
			strHtml = strHtml + '<TD NOWRAP><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
			strHtml = strHtml + '<TD NOWRAP><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
		} else if( myForm.f_perid[i].value != '' && myForm.f_perid[i].value == '<%= strCompPerId %>' ) {
			strHtml = strHtml + '<TD NOWRAP COLSPAN=2>������</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:callGuide(' + i + ')"><IMG SRC="../../images/question.gif" ALT="�l�����K�C�h��\�����܂�" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>\n';
			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:clearFriends(' + i + ')"><IMG SRC="../../images/delicon.gif" ALT="���̎�f�҂����A��l��񂩂�폜���܂�" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>\n';
		}

		if( myForm.f_perid[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_perid[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_name[i].value == '' && myForm.f_kname[i].value == '') {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_name[i].value + '�i<SPAN STYLE="font-size:9px;"><B>' + myForm.f_kname[i].value + '</B></SPAN>�j</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_rsvno[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_rsvno[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_orgname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_orgname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_csname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_csname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_rsvgrpname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_rsvgrpname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		// �ʐړ�����f
		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp1[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk1" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk1" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';

		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp2[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk2" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk2" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';

		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp3[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk3" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk3" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

// ## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
		// ������
		strHtml = strHtml + '<TD NOWRAP ALIGN="left" BGCOLOR="#FFCCFF">';
		if( myForm.f_perid[i].value != '' ) {
			strHtml = strHtml + '<SELECT NAME="complist" STYLE="width:180px" ONCHANGE="javascript:document.entryForm.compnew[' + i + '].value = this.value">\n';
			strHtml = strHtml + '<OPTION VALUE="">\n';
			for ( j = 0; j <= <%= lngDispCnt %>; j++ ) {
				if( i == j ) continue;
				if( myForm.f_perid[j].value != '' ) {
					strHtml = strHtml + '<OPTION VALUE="' + myForm.f_perid[j].value + '"';
					if( myForm.compnew[i].value == myForm.f_perid[j].value ) {
						strHtml = strHtml + ' SELECTED';
					}
					strHtml = strHtml + '>' + myForm.f_perid[j].value + ' ' + myForm.f_name[j].value + '\n';
				}
			}
			strHtml = strHtml + '</SELECT>\n';
		}
		strHtml = strHtml + '</TD>\n';
// ## 2004.01.20 Add End

		strHtml = strHtml + '</TR>\n';
	}
	strHtml = strHtml + '</TABLE>\n';
	elem.innerHTML = strHtml;
}

// ���A��l���̍폜
function deleteFriends() {

	if( '<%= strCompPerId %>' != '' ) {
		alert( '�����҂����邽�߁A���̂��A��l���͍폜�ł��܂���' );
		return;
	}

// ## 2003.11.26 Add By T.Takagi@FSIT �A���[�g�Ȃ��͂܂���
	if ( !confirm('���̂��A��l�������ׂč폜���܂��B��낵���ł����H' ) ) {
		return;
	}
// ## 2003.11.26 Add End

	document.entryForm.act.value = 'delete';
	document.entryForm.submit();
}

// ���A��l���̕ۑ�
function saveFriends() {
	var myForm = document.entryForm;
	var count;
	var i, j;

	// �ʐړ�����f�̓��̓`�F�b�N
	if ( myForm.f_rsvno.length ) {
		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk1[i].checked ) {
				myForm.f_samegrp1[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp1[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '�ʐړ�����f��I������ɂ�2�l�ȏ�I�����Ă�������' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '�ʐړ�����f�͍ő�<%= SAMEGRP_SELMAX %>�l�܂ł����I���ł��܂���' );
			return;
		}

		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk2[i].checked ) {
				myForm.f_samegrp2[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp2[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '�ʐړ�����f��I������ɂ�2�l�ȏ�I�����Ă�������' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '�ʐړ�����f�͍ő�<%= SAMEGRP_SELMAX %>�l�܂ł����I���ł��܂���' );
			return;
		}

		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk3[i].checked ) {
				myForm.f_samegrp3[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp3[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '�ʐړ�����f��I������ɂ�2�l�ȏ�I�����Ă�������' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '�ʐړ�����f�͍ő�<%= SAMEGRP_SELMAX %>�l�܂ł����I���ł��܂���' );
			return;
		}

// ## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.compnew[i].value == '' ) continue;
			// ���A��l���ɓ����҂����Ȃ��ꍇ�̓`�F�b�N�ΏۊO
			if( myForm.compnew[i].value == myForm.comporg[i].value ) continue;
			count=0;
			for( j=0; j<myForm.f_rsvno.length; j++ ) {
				if( i == j ) continue;
				if( myForm.compnew[i].value == myForm.f_perid[j].value ) {
					if( myForm.f_perid[i].value == myForm.compnew[j].value ) {
						count++;
					}
				}
			}
			if( count != 1 ) {
				alert( '�����Ґݒ�͕K���P�΂P�ɂȂ�悤�ɂ��Ă������� count='+count );
				return;
			}
		}
	}
// ## 2004.01.20 Add End

	document.entryForm.act.value = 'save';
	document.entryForm.submit();
}

// �\���s���̕ύX
function changeRow() {
	var myForm = document.entryForm;
	var i;

	if ( myForm.f_rsvno.length ) {
		// �ʐړ�����f�̏�ԕێ�
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk1[i].checked ) {
				myForm.f_samegrp1[i].value = '1';
			} else {
				myForm.f_samegrp1[i].value = '';
			}
		}

		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk2[i].checked ) {
				myForm.f_samegrp2[i].value = '1';
			} else {
				myForm.f_samegrp2[i].value = '';
			}
		}

		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk3[i].checked ) {
				myForm.f_samegrp3[i].value = '1';
			} else {
				myForm.f_samegrp3[i].value = '';
			}
		}
	}

	document.entryForm.act.value = 'redisp';
	document.entryForm.submit();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()" ONLOAD="JavaScript:dispFriendsList()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
<!-- ## 2003.11.26 Del By T.Takagi@FSIT -->
<!--
<BLOCKQUOTE>
-->
<!-- ## 2003.11.26 Del End -->
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAct %>">

	<!-- �^�C�g���̕\�� -->
<!-- ## 2003.11.26 Mod By T.Takagi@FSIT -->
<!--
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">�����A��l�`�����ҏ��X�V</SPAN></B></TD>
		</TR>
	</TABLE>
-->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN>���A��l�`�����ҏ��X�V</B></TD>
		</TR>
	</TABLE>
<!-- ## 2003.11.26 Mod End -->
	<BR>

	<!-- ��f���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD NOWRAP>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD NOWRAP>�\��ԍ�</TD>
			<TD NOWRAP>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>��f�R�[�X</TD>
			<TD NOWRAP>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="371">
		<TR HEIGHT="9">
			<TD COLSPAN="3"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top" WIDTH="96"><%= strPerId %></TD>
			<TD NOWRAP ROWSPAN="2" WIDTH="16"></TD>
			<TD NOWRAP WIDTH="247"><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="247"><%= FormatDateTime(strBirth, 1) %>���@<%= Int(strAge) %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP WIDTH="391"><SPAN STYLE="color:#cc9999">��</SPAN>���A��l�Ƃ��ēo�^�����f�҂�I�����Ă��������B</TD>

			<TD NOWRAP WIDTH="77">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4"  then   %>
				<A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:deleteFriends();return false;"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���A��l����S�č폜���܂�"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>


			<TD NOWRAP WIDTH="77">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4"  then   %>
				<A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:saveFriends();return false;"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�w�肳�ꂽ���A��l����ۑ����܂�"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>	
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strAct <> "" Then
		Select Case strAct
		Case "saveend"
			'�ۑ��������́u�ۑ������v�̒ʒm
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		Case "deleteend"
			'�폜�������́u�폜�����v�̒ʒm
			Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

		Case Else
			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select

	End If
%>
	<BR>

<%
	For i=0 To lngDispCnt
		strHtml = ""
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_csldate"" VALUE=""" & strArrCslDate(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_seq""     VALUE=""" & strArrSeq(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_rsvno""   VALUE=""" & strArrRsvNo(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_perid""   VALUE=""" & strArrPerId(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_orgname"" VALUE=""" & strArrOrgSName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_csname""  VALUE=""" & strArrCsName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_name""    VALUE=""" & strArrName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_kname""   VALUE=""" & strArrKName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_rsvgrpname"" VALUE=""" & strArrRsvGrpName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp1"" VALUE=""" & strArrSameGrp1(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp2"" VALUE=""" & strArrSameGrp2(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp3"" VALUE=""" & strArrSameGrp3(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""comporg"" VALUE=""" & strArrCompOrg(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""compnew"" VALUE=""" & strArrCompNew(i) & """>"
		strHtml = strHtml & vbLf
		Response.Write strHTML
	Next
%>
	<!-- ���A��l���X�g -->
	<SPAN ID="FriendsList">�@</SPAN>

	<!-- �w���f�Ґ��̕\�� -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD></TD>
			<TD NOWRAP>�w���f�҂�</TD>
			<TD>
				<SELECT NAME="dispCnt">
<%
				'�s���I�����X�g�̕ҏW
				i = DEFAULT_ROW
				Do
					'���݂̍s���ȏ�̍s����I���\�Ƃ���
					If i >= lngDispCnt Then
%>
						<OPTION VALUE="<%= i %>" <%= IIf(i = lngDispCnt, "SELECTED", "") %>><%= i %>�l
<%
					End If

					'�ҏW�s�����\���s���𒴂����ꍇ�͏������I������
					If i > lngDispCnt Then
						Exit Do
					End If

					i = i + INCREASE_COUNT
				Loop
%>
				</SELECT>
			</TD>
			<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��" BORDER="0"></A></TD>
		</TR>
	</TABLE>
<!-- ## 2003.11.26 Mod By T.Takagi@FSIT -->
<!--
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
-->
</FORM>
<!-- ## 2003.11.26 Mod End -->
</BODY>
</HTML>
