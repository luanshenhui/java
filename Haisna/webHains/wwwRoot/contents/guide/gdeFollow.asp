<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�t�H���[�K�C�h (Ver0.0.1)
'		AUTHER  : Yaguchi Toru@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFollowUp			'�t�H���[�A�b�v�A�N�Z�X�p
Dim objJud			'������A�N�Z�X�p
Dim objSentence			'���͏��A�N�Z�X�p

'�p�����[�^
Dim strJudClassCd		'����R�[�h
Dim strJudClassName		'���f����
Dim strJudCd			'����
Dim strSecCslDate		'�񎟌�����
Dim strComeFlg			'��
Dim strSecItemCd		'��������
Dim strRsvInfoCd		'�\����
Dim strJudCd2			'����
Dim strQuestionCd		'�A���P�[�g
Dim strfolNote			'���l

Dim strSecCslYear		'�񎟌������i�N�j
Dim strSecCslMonth		'�񎟌������i���j
Dim strSecCslDay		'�񎟌������i���j

Dim strStcCd1			'���̓R�[�h
Dim strShortstc1		'����
Dim strStcCd2			'���̓R�[�h
Dim strShortstc2		'����
Dim strStcCd3			'���̓R�[�h
Dim strShortstc3		'����
Dim strStcCd4			'���̓R�[�h
Dim strShortstc4		'����
Dim strStcCd5			'���̓R�[�h
Dim strShortstc5		'����
Dim strRsvInfoName		'�\����
Dim strQuestionName		'�A���P�[�g��

'����R���{�{�b�N�X
Dim strArrJudCdSeq		'����A��
Dim strArrJudCd			'����R�[�h
Dim strArrWeight		'����p�d��
Dim lngJudListCnt		'���茏��

Dim lngCount			'���R�[�h����

Dim i				'�C���f�b�N�X
Dim Ret				'���A�l

Dim vntArrSecItemCd		'
Dim vntArrSecItemCd2		'

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'�p�����[�^�l�̎擾
strJudClassCd	= Request("judClassCd")
strJudClassName	= Request("judClassName")
strJudCd	= Request("judCd")
strSecCslDate	= Request("secCslDate")
If strSecCslDate <> "" Then
	strSecCslYear   = Year(strSecCslDate)
	strSecCslMonth  = Month(strSecCslDate)
	strSecCslDay    = Day(strSecCslDate)
End If
strComeFlg	= Request("comeFlg")
strSecItemCd	= Request("secItemCd")
vntArrSecItemCd = Split(strSecItemCd,"Z")
vntArrSecItemCd2 = Array()
Redim Preserve vntArrSecItemCd2(5)
i = 0
Do Until i > Ubound(vntArrSecItemCd)
	vntArrSecItemCd2(i) = Trim(vntArrSecItemCd(i))
	i = i +1
Loop
strStcCd1       = vntArrSecItemCd2(0)
strStcCd2       = vntArrSecItemCd2(1)
strStcCd3       = vntArrSecItemCd2(2)
strStcCd4       = vntArrSecItemCd2(3)
strStcCd5       = vntArrSecItemCd2(4)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd1, strShortstc1)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd2, strShortstc2)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd3, strShortstc3)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd4, strShortstc4)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd5, strShortstc5)
strRsvInfoCd	= Request("rsvInfoCd")
Ret 		= objSentence.SelectSentence("89002", 0, strRsvInfoCd, strRsvInfoName)
strJudCd2	= Request("judCd2")
strQuestionCd	= Request("questionCd")
Ret 		= objSentence.SelectSentence("89003", 0, strQuestionCd, strQuestionName)
strFolNote	= Request("folNote")

'����擾
Call EditJudListInfo

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ����̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()



	'����ꗗ�擾
	lngJudListCnt = objJud.SelectJudList( _
    									strArrJudCd, _
										 , , strArrWeight	)

	strArrJudCdSeq = Array()
	Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
	For i = 0 To lngJudListCnt-1
		strArrJudCdSeq(i) = i
	Next


End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�H���[�A�b�v�^�񎟌����\����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var curYear, curMonth, curDay;	// ���t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�

// ���t�K�C�h�܂��̓J�����_�[������ʌĂяo��
function callCalGuide() {

	var myForm = document.folList;	// ����ʂ̃t�H�[���G�������g

	// �K�C�h�Ăяo�����O�̓��t��ޔ�
	curYear  = myForm.secCslYear.value;
	curMonth = myForm.secCslMonth.value;
	curDay   = myForm.secCslDay.value;

	// ���t�K�C�h�\��
	calGuide_showGuideCalendar( 'secCslYear', 'secCslMonth', 'secCslday', dateSelected );

}

function dateSelected() {

}

// ���̓K�C�h�Ăяo��
function callStcGuide( index ) {

	var myForm = document.folList;

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index;

	// �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
	if ( index == 1 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 2 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 3 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 4 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 5 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 6 ) {
		stcGuide_ItemCd ='89002';
	}
	if ( index == 7 ) {
		stcGuide_ItemCd ='89003';
	}

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
	stcGuide_ItemType = '0';

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

	setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

}

// ���͂̕ҏW
function setStc( index, stcCd, shortStc ) {

	var myForm = document.folList;			// ����ʂ̃t�H�[���G�������g
	var objStcCd, objShortStc;			// ���ʁE���͂̃G�������g
	var stcNameElement;				// ���͂̃G�������g

	// �ҏW�G�������g�̐ݒ�
	if ( index == 1 ) {
		objStcCd   	= myForm.stcCd1;
		objShortStc   	= myForm.shortStc1;
	}
	if ( index == 2 ) {
		objStcCd   	= myForm.stcCd2;
		objShortStc   	= myForm.shortStc2;
	}
	if ( index == 3 ) {
		objStcCd   	= myForm.stcCd3;
		objShortStc   	= myForm.shortStc3;
	}
	if ( index == 4 ) {
		objStcCd   	= myForm.stcCd4;
		objShortStc   	= myForm.shortStc4;
	}
	if ( index == 5 ) {
		objStcCd   	= myForm.stcCd5;
		objShortStc   	= myForm.shortStc5;
	}
	if ( index == 6 ) {
		objStcCd   	= myForm.rsvInfoCd;
		objShortStc   	= myForm.rsvInfoName;
	}
	if ( index == 7 ) {
		objStcCd   	= myForm.questionCd;
		objShortStc   	= myForm.questionName;
	}

	stcNameElement = 'stcName' + index;

	// �l�̕ҏW
	objStcCd.value   = stcCd;
	objShortStc.value = shortStc;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = shortStc;
	}

}

// ���͂̃N���A
function callStcClr( index ) {

	var myForm = document.folList;			// ����ʂ̃t�H�[���G�������g
	var objStcCd, objShortStc;			// ���ʁE���͂̃G�������g
	var stcNameElement;				// ���͂̃G�������g

	// �ҏW�G�������g�̐ݒ�
	if ( index == 1 ) {
		objStcCd   	= myForm.stcCd1;
		objShortStc   	= myForm.shortStc1;
	}
	if ( index == 2 ) {
		objStcCd   	= myForm.stcCd2;
		objShortStc   	= myForm.shortStc2;
	}
	if ( index == 3 ) {
		objStcCd   	= myForm.stcCd3;
		objShortStc   	= myForm.shortStc3;
	}
	if ( index == 4 ) {
		objStcCd   	= myForm.stcCd4;
		objShortStc   	= myForm.shortStc4;
	}
	if ( index == 5 ) {
		objStcCd   	= myForm.stcCd5;
		objShortStc   	= myForm.shortStc5;
	}
	if ( index == 6 ) {
		objStcCd   	= myForm.rsvInfoCd;
		objShortStc   	= myForm.rsvInfoName;
	}
	if ( index == 7 ) {
		objStcCd   	= myForm.questionCd;
		objShortStc   	= myForm.questionName;
	}
	stcNameElement = 'stcName' + index;

	// �l�̕ҏW
	objStcCd.value   = '';
	objShortStc.value = '';

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = '';
	}

}


// ���͗̈�f�[�^�̃Z�b�g
function selectList() {

	var secCslDate;
	var secCslDateLen;
	var folStcCd = new Array(5);
	var folShortStc = new Array(5);
	var i, j;
	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A���̓R�[�h�E�����͂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// �񎟌�����f��
	if ( opener.folGuide_SecCslDate != null ) {
		secCslDate = '';
		if (document.folList.secCslYear.value != '' || document.folList.secCslMonth.value != '' || document.folList.secCslDay.value != '') {
			secCslDate = document.folList.secCslYear.value + '/' + document.folList.secCslMonth.value + '/' + document.folList.secCslDay.value;
		}
		opener.folGuide_SecCslDate = secCslDate;
	}

	// ���@
	if ( opener.folGuide_ComeFlg != null ) {
		if ( document.folList.comeFlg.checked ) {
			opener.folGuide_ComeFlg = document.folList.comeFlg.value;
		} else {
			opener.folGuide_ComeFlg = '';
		}
	}

	// ��������
	folStcCd[0] = document.folList.stcCd1.value;
	folStcCd[1] = document.folList.stcCd2.value;
	folStcCd[2] = document.folList.stcCd3.value;
	folStcCd[3] = document.folList.stcCd4.value;
	folStcCd[4] = document.folList.stcCd5.value;
	folShortStc[0] = document.folList.shortStc1.value;
	folShortStc[1] = document.folList.shortStc2.value;
	folShortStc[2] = document.folList.shortStc3.value;
	folShortStc[3] = document.folList.shortStc4.value;
	folShortStc[4] = document.folList.shortStc5.value;
	for ( i = 0; i < 5; i++ ) {
		for ( j = i + 1; j < 5; j++ ) {
			//�����������ڂ̏ꍇ�͋�ɂ���
			if ( folStcCd[i] == folStcCd[j] ) {
				folStcCd[j] = '';
				folShortStc[j] = '';
			}
		}
	}
	if ( opener.folGuide_SecItemCd != null ) {
		secItemCd = '';
		secCslDateLen = 0;
		if ( folStcCd[0] != '' ) {
			secItemCd = folStcCd[0];
			secCslDateLen = (folStcCd[0] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName1 = folShortStc[0];
		}
		if ( folStcCd[1] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[1]:folStcCd[1];
			secCslDateLen = (folStcCd[1] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName2 = folShortStc[1];
		}
		if ( folStcCd[2] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[2]:folStcCd[2];
			secCslDateLen = (folStcCd[2] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName3 = folShortStc[2];
		}
		if ( folStcCd[3] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[3]:folStcCd[3];
			secCslDateLen = (folStcCd[3] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName4 = folShortStc[3];
		}
		if ( folStcCd[4] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[4]:folStcCd[4];
			secCslDateLen = (folStcCd[4] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName5 = folShortStc[4];
		}
		opener.folGuide_SecItemCd = secItemCd;
	}

/*
	if ( opener.folGuide_SecItemCd != null ) {
		secItemCd = '';
		secCslDateLen = 0;
		if ( document.folList.stcCd1.value != '' ) {
			secItemCd = document.folList.stcCd1.value;
			secCslDateLen = (document.folList.stcCd1.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName1 = document.folList.shortStc1.value;
		}
		if ( document.folList.stcCd2.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd2.value:document.folList.stcCd2.value;
			secCslDateLen = (document.folList.stcCd2.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName2 = document.folList.shortStc2.value;
		}
		if ( document.folList.stcCd3.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd3.value:document.folList.stcCd3.value;
			secCslDateLen = (document.folList.stcCd3.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName3 = document.folList.shortStc3.value;
		}
		if ( document.folList.stcCd4.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd4.value:document.folList.stcCd4.value;
			secCslDateLen = (document.folList.stcCd4.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName4 = document.folList.shortStc4.value;
		}
		if ( document.folList.stcCd5.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd5.value:document.folList.stcCd5.value;
			secCslDateLen = (document.folList.stcCd5.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName5 = document.folList.shortStc5.value;
		}
		opener.folGuide_SecItemCd = secItemCd;
	}
*/
	// �\����
	if ( opener.folGuide_RsvInfoCd != null ) {
//		if ( document.folList.rsvInfoCd.value != '' ) {
			opener.folGuide_RsvInfoCd = document.folList.rsvInfoCd.value;
			opener.folGuide_RsvInfoName = document.folList.rsvInfoName.value;
//		}
	}

	// ��������
	if ( opener.folGuide_JudCd2 != null ) {
//		if ( document.folList.judCd2.value != '' ) {
			opener.folGuide_JudCd2 = document.folList.judCd2.value;
//		}
	}

	// �A���P�[�g
	if ( opener.folGuide_QuestionCd != null ) {
//		if ( document.folList.questionCd.value != '' ) {
			opener.folGuide_QuestionCd = document.folList.questionCd.value;
			opener.folGuide_QuestionName = document.folList.questionName.value;
//		}
	}

	// ���l
	if ( opener.folGuide_FolNote != null ) {
//		if ( document.folList.folNote.value != '' ) {
			opener.folGuide_FolNote = document.folList.folNote.value;
//		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.folGuide_CalledFunction != null ) {
		opener.folGuide_CalledFunction();
	}

	opener.winGuideFol = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<INPUT TYPE="hidden" NAME="judClassCd"   VALUE="<%= strJudClassCd   %>">
	<INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= strJudClassName %>">
	<INPUT TYPE="hidden" NAME="judCd"        VALUE="<%= strJudCd        %>">

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="500">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�o�^</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="javascript:close()"><IMG SRC="../../images/back.gif"  ALT="�t�H���[�A�b�v��ʂɖ߂�܂�" border="0"></A></TD>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<!--						<TD><A HREF="javascript:close()"><IMG SRC="../../images/delete.gif"  ALT="���f���ڂ��폜���܂��B" border="0"></A></TD>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>-->

						<TD>
						<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	           			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
							<A HREF="javascript:selectList()"><IMG SRC="../../images/ok.gif"  ALT="���͂����f�[�^���m�肵�܂��B" border="0"></A>
						<%  else    %>
							 &nbsp;
						<%  end if  %>
						<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
						</TD>
						
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
		</TR>
	</TABLE>

	<BR>
</FORM>
<FORM NAME="folList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD>���f����</TD>
			<TD><SPAN STYLE=color:"#903000";><%= strJudClassName %></SPAN></TD>
			<TD>����</TD>
			<TD><SPAN STYLE=color:"#903000";><%= strJudCd %></SPAN></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP>�񎟌�����f��</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
						<TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD COLSPAN="4">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
								<TR>
									<TD><%= EditNumberList("secCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
									<TD>�N</TD>
									<TD><%= EditNumberList("secCslMonth", 1, 12, strSecCslMonth, True) %></TD>
									<TD>��</TD>
									<TD><%= EditNumberList("secCslDay", 1, 31, strSecCslDay, True) %></TD>
									<TD>��</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>���@</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP HEIGHT="35"><INPUT TYPE="checkbox" NAME="comeFlg" VALUE="1" <%= IIf(strComeFlg = "1", " CHECKED", "") %>></TD>
						<TD COLSPAN="6"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ڂP</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('1')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('1')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd1" VALUE="<%= strStcCd1 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc1" VALUE="<%= strShortstc1 %>"></TD>
						<TD><SPAN ID="stcName1"><%= strShortStc1 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ڂQ</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('2')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('2')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd2" VALUE="<%= strStcCd2 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc2" VALUE="<%= strShortstc2 %>"></TD>
						<TD><SPAN ID="stcName2"><%= strShortStc2 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ڂR</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('3')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('3')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd3" VALUE="<%= strStcCd3 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc3" VALUE="<%= strShortstc3 %>"></TD>
						<TD><SPAN ID="stcName3"><%= strShortStc3 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ڂS</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('4')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('4')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd4" VALUE="<%= strStcCd4 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc4" VALUE="<%= strShortstc4 %>"></TD>
						<TD><SPAN ID="stcName4"><%= strShortStc4 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ڂT</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('5')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('5')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd5" VALUE="<%= strStcCd5 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc5" VALUE="<%= strShortstc5 %>"></TD>
						<TD><SPAN ID="stcName5"><%= strShortStc5 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�\����</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('6')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('6')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="rsvInfoCd" VALUE="<%= strRsvInfoCd %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="rsvInfoName" VALUE="<%= strRsvInfoName %>"></TD>
						<TD><SPAN ID="stcName6"><%= strRsvInfoName %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>��������</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP COLSPAN="2"><%= EditDropDownListFromArray("judCd2", strArrJudCd, strArrJudCd, strJudCd2, NON_SELECTED_ADD) %></TD>
						<TD COLSPAN="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�A���P�[�g</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><A HREF="javascript:callStcGuide('7')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃK�C�h�\��"></A></TD>
						<TD><A HREF="javascript:callStcClr('7')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�������ڃN���A"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="questionCd" VALUE="<%= strQuestionCd %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="questionName" VALUE="<%= strQuestionName %>"></TD>
						<TD><SPAN ID="stcName7"><%= strQuestionName %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>���l</TD>
			<TD COLSPAN="7"><TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="50" ROWS="4"><%= strfolNote %></TEXTAREA></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
