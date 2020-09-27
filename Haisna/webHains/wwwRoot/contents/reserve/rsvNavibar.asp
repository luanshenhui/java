<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�\����ڍ�(�i�r�o�[) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE          = "save"			'�������[�h(�ۑ�)
Const MODE_CANCEL        = "cancel"			'�������[�h(��t������)
Const MODE_CANCELRECEIPT = "cancelreceipt"	'�������[�h(��t������)
Const MODE_DELETE        = "delete"			'�������[�h(�폜)
Const MODE_RESTORE       = "restore"		'�������[�h(����)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim strRsvNo		'�\��ԍ�

Dim strCancelFlg	'�L�����Z���t���O
Dim strCslDate		'��f��
Dim strDayId		'�����h�c
Dim Ret				'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strRsvNo = Request("rsvNo")

'�\��ԍ����w�肳��Ă���ꍇ
If strRsvNo <> "" Then

	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'��f���ǂݍ���
	Ret = objConsult.SelectConsult(strRsvNo, strCancelFlg, strCslDate, , , , , , , , , , , , , , , , , , , , , , strDayId)

	Set objConsult = Nothing

	If Ret = False Then
		Err.Raise 1000, ,"��f��񂪑��݂��܂���B"
	End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�i�r�Q�[�V�����o�[</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �E�B���h�E�n���h��
var winCalendar;		// �󂫘g�����J�����_�[���
var winCancel;			// �L�����Z�����
var winCancelReceipt;	// ��t���������
var winReceipt;			// ��t���
var winFriends;			// ���A��l�����
var winVisit;			// ���@���
// ## 2004/04/20 Add By T.Takagi@FSIT ��f���ꊇ�ύX
var winChangeDate;		// ��f���ꊇ�ύX���
// ## 2004/04/20 Add End

// ���A��l����ʌĂяo��
function callFriendWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// URL������

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winFriends != null ) {
		if ( !winFriends.closed ) {
			opened = true;
		}
	}

	// URL�ҏW
	url = '/webHains/contents/friends/editFriends.asp';
	url = url + '?rsvno=<%= strRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winFriends.focus();
	} else {
		winFriends = open( url, '', 'width=950,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ���@��ʌĂяo��
function callVisitWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// URL������

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winVisit != null ) {
		if ( !winVisit.closed ) {
			opened = true;
		}
	}

	// URL�ҏW
	url = '/webHains/contents/raiin/ReceiptMain.asp';
	url = url + '?rsvno=<%= strRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winVisit.focus();
	} else {
		winVisit = open( url, '', 'width=700,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// �J�����_�[������ʌĂяo��
function callCalendar() {

	var arrOptCd, arrOptBranchNo;	// �I�v�V�����R�[�h�E�}��
	var opened = false;				// ��ʂ��J����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			opened = true;
		}
	}

	// ��ʂ��J����Ă���ꍇ�͈�U����
	if ( opened ) {
		winCalendar.close();
	}

	// ��̃E�B���h�E���J��
	winCalendar = window.open('', 'cal', 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

	// �I�v�V����������ʂ̎�f�����擾����
	arrOptCd       = new Array();
	arrOptBranchNo = new Array();
	top.convOptCd( top.opt.document.optList, arrOptCd, arrOptBranchNo );

	// �����w��
	var paraForm = document.paramForm;
	var mainForm = top.main.document.entryForm;
	var optForm  = top.opt.document.entryForm;
	paraForm.cslYear.value     = mainForm.cslYear.value;
	paraForm.cslMonth.value    = mainForm.cslMonth.value;
	paraForm.perId.value       = mainForm.perId.value;
	paraForm.orgCd1.value      = mainForm.orgCd1.value;
	paraForm.orgCd2.value      = mainForm.orgCd2.value;
	paraForm.csCd.value        = mainForm.csCd.value;
	paraForm.cslDivCd.value    = mainForm.cslDivCd.value;
	paraForm.rsvGrpCd.value    = mainForm.rsvGrpCd.value;
	paraForm.ctrPtCd.value     = optForm.ctrPtCd.value;
	paraForm.optCd.value       = arrOptCd;
	paraForm.optBranchNo.value = arrOptBranchNo;
<% '## 2003.12.12 Add By T.Takagi@FSIT ���ݓ���n�� %>
	paraForm.curCslYear.value  = mainForm.cslYear.value;
	paraForm.curCslMonth.value = mainForm.cslMonth.value;
	paraForm.curCslDay.value   = mainForm.cslDay.value;
<% '## 2003.12.12 Add End %>

	// �����A�^�[�Q�b�g���w�肵��submit
	paraForm.target = 'cal';
	paraForm.submit();

}

// �J�����_�[��ʂɂđI�����ꂽ���t����ь������ꂽ�\��Q�̕ҏW
function setDate( year, month, day, rsvGrpCd, noContract ) {

	// �ڍ׉�ʂ̓��t���X�V
	var mainForm = top.main.document.entryForm;
	mainForm.cslYear.value  = year;
	mainForm.cslMonth.value = month;
	mainForm.cslDay.value   = day;

	// �\��Q���X�V
	if  ( rsvGrpCd != '' ) {
		mainForm.selRsvGrpCd.value = rsvGrpCd;
		mainForm.rsvGrpCd.value    = rsvGrpCd;
	}

//	// �_����̈قȂ���t��I�������ꍇ�A��f���`�F�b�N����уZ�b�g�̃����[�h���s��
//	if ( noContract != null ) {
//
//		top.main.checkDateChanged();
//
//	} else {
//
//		// �P�����f���̓��e���N���A����
//		top.main.clearFirstCslInfo();
//
//		// ���\�����̌��f���ꗗ��ʂ����
//		top.main.closeConsultWindow();
//
//		// ���s�[�^�����Z�b�g����̂��߂̉�ʓǂݍ���
//		var cslDate = year + '/' + month + '/' + day;
//		var hasRepeaterSet  = top.main.repInfo.hasRepeaterSet.value;
//		var repeaterConsult = top.main.repInfo.repeaterConsult.value;
//		top.replaceCslList( cslDate, mainForm.cslDivCd.value, top.opt.document.entryForm.ctrPtCd.value, mainForm.perId.value, mainForm.gender.value, mainForm.birth.value, hasRepeaterSet, repeaterConsult );
//
//	}

	top.main.checkDateChanged();


}

// �L�����Z����ʌĂяo��
function callCancelWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// �L�����Z����ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCancel != null ) {
		if ( !winCancel.closed ) {
			opened = true;
		}
	}

	// �L�����Z����ʂ�URL�ҏW
	url = 'rsvCancel.asp';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winCancel.focus();
	} else {
		winCancel = open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ��t��������ʌĂяo��
function callCancelReceiptWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// ��t��������ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			opened = true;
		}
	}

	// ��t��������ʂ�URL�ҏW
	url = '/webHains/contents/receipt/rptCancel.asp';
	url = url + '?calledFrom=detail';
	url = url + '&rsvNo=<%= strRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winCancelReceipt.focus();
	} else {
		winCancelReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ��f���ꗗ�\��
function callDayliListWindow() {

	// �l�h�c�̎擾
	var curPerId = top.main.document.entryForm.perId.value;
	if ( curPerId == '' ) {
		return;
	}

	var mainForm = top.main.document.entryForm;	// ���C����ʂ̃t�H�[���G�������g

	// URL�ҏW
	var url = '/webHains/contents/common/dailyList.asp';
	url = url + '?navi='     + '1';
	url = url + '&key='      + 'ID:' + curPerId;
	url = url + '&strYear='  + '1970';
	url = url + '&strMonth=' + '1';
	url = url + '&strDay='   + '1';
	url = url + '&endYear='  + mainForm.cslYear.value;
	url = url + '&endMonth=' + mainForm.cslMonth.value;
	url = url + '&endDay='   + mainForm.cslDay.value;
	url = url + '&sortKey='  + '12';
	url = url + '&sortType=' + '1';

	open( url );

}

// ��t��ʌĂяo��
function callReceiptWindow() {

	var opened   = false;						// ��ʂ��J����Ă��邩
	var mainForm = top.main.document.entryForm;	// ���C����ʂ̃t�H�[���G�������g
	var optForm  = top.opt.document.entryForm;	// �I�v�V����������ʂ̃t�H�[���G�������g
	var url;									// ��t��ʂ�URL

	// ���̓`�F�b�N
	if ( !top.checkValue( 0 ) ) {
		return;
	}

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winReceipt != null ) {
		if ( !winReceipt.closed ) {
			opened = true;
		}
	}

	// ��t��ʂ�URL�ҏW
	url = '/webHains/contents/receipt/rptEntryFromDetail.asp';
	url = url + '?calledFrom=detail';
	url = url + '&perId='    + mainForm.perId.value;
	url = url + '&csCd='     + mainForm.csCd.value;
	url = url + '&cslYear='  + mainForm.cslYear.value;
	url = url + '&cslMonth=' + mainForm.cslMonth.value;
	url = url + '&cslDay='   + mainForm.cslDay.value;
	url = url + '&ctrPtCd='  + optForm.ctrPtCd.value;

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winReceipt.focus();
		winReceipt.location.replace( url );
	} else {
		winReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ��f���̍폜
function deleteConsult() {

	// �m�F���b�Z�[�W�̕\��
	if ( !confirm('���̃L�����Z���������S�ɍ폜���܂��B��낵���ł����H') ) return;

	// submit����
	top.submitForm('<%= MODE_DELETE %>');

}

// ��������
function restoreConsult() {

	// �m�F���b�Z�[�W�̕\��
	if ( !confirm('���̃L�����Z������\���Ԃɖ߂��܂��B��낵���ł����H') ) return;

	// submit����
	top.submitForm('<%= MODE_RESTORE %>');
}

// �ۑ�����
function saveConsult() {

	// ���̓`�F�b�N
	if ( !top.checkValue( 0 ) ) return;

	// �m�F���b�Z�[�W�̕\��
	if ( !confirm('���̓��e�Ŏ�f����ۑ����܂��B��낵���ł����H') ) return;

	// submit����
	top.submitForm('<%= MODE_SAVE %>');
}

// ��t��ʂ����
function closeReceiptWindow() {

	// ��t��ʂ����
	if ( winReceipt != null ) {
		if ( !winReceipt.closed ) {
			winReceipt.close();
		}
	}

	winReceipt = null;

}

// �\���
function showCapacityList() {

	var objForm  = top.main.document.entryForm;
	var cslYear  = parseInt(objForm.cslYear.value);
	var cslMonth = parseInt(objForm.cslMonth.value);
	var cslDay   = parseInt(objForm.cslDay.value);
	var gender   = objForm.gender.value;

	if ( !top.isDate( cslYear, cslMonth, cslDay ) ) {
		alert('��f���̓��͌`��������������܂���B');
		return;
	}

	var url = '/webHains/contents/maintenance/capacity/mntCapacityList.asp';
	url = url + '?cslYear='  + cslYear;
	url = url + '&cslMonth=' + cslMonth;
	url = url + '&cslDay='   + cslDay;
	url = url + '&gender='   + gender;
// ## 2004.02.13 Mod By Ishihara@FSIT
//	url = url + '&mode='     + 'all';
	url = url + '&mode='     + 'disp';
// ## 2004.02.13 Mod End
	open( url );

}

// �T�u��ʂ����
function closeWindow() {

	// ���A��l����ʂ����
	if ( winFriends != null ) {
		if ( !winFriends.closed ) {
			winFriends.close();
		}
	}

	// ���@��ʂ����
	if ( winVisit != null ) {
		if ( !winVisit.closed ) {
			winVisit.close();
		}
	}

	// �L�����Z����ʂ����
	if ( winCancel != null ) {
		if ( !winCancel.closed ) {
			winCancel.close();
		}
	}

	// ��t��������ʂ����
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			winCancelReceipt.close();
		}
	}

	// ��t��ʂ����
	closeReceiptWindow();

	// �J�����_�[������ʂ����
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			winCalendar.close();
		}
	}

	// �R�����g��ʂ����
	noteGuide_closeGuideNote();

	winFriends       = null;
	winCancel        = null;
	winCancelReceipt = null;
	winCalendar      = null;

// ## 2004/04/20 Add By T.Takagi@FSIT ��f���ꊇ�ύX
	// ��f���ꊇ�ύX��ʂ����
	if ( winChangeDate != null ) {
		if ( !winChangeDate.closed ) {
			winChangeDate.close();
		}
	}

	winChangeDate = null;
// ## 2004/04/20 Add End

}

// ## 2004/04/20 Add By T.Takagi@FSIT ��f���ꊇ�ύX
// ��f���ꊇ�ύX��ʌĂяo��
function callChangeDateWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// ��f���ꊇ�ύX��ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winChangeDate != null ) {
		if ( !winChangeDate.closed ) {
			opened = true;
		}
	}

	// ��f���ꊇ�ύX��ʂ�URL�ҏW
	url = 'rsvChangeDateAll.asp';
	url = url + '?rsvNo=<%= strRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winChangeDate.focus();
	} else {
		winChangeDate = open( url, '', 'width=900,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}
// ## 2004/04/20 Add End
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%" style="margin:6px 0 2px 0;">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
		<TD WIDTH="100%">
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
				<TR>
					<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f���ڍ�</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="8" HEIGHT="1" ALT=""></TD>
	</TR>
</TABLE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
		'�L�����Z������������t��f���ɂ��Ắu�L�����Z���v�{�^����ҏW
		If strRsvNo <> "" And strDayId = "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
			<TD>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:callCancelWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="���̗\����L�����Z�����܂�"></A>
            <%  else    %>
                &nbsp;
            <%  end if  %>
			</TD>
			
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
		End If
        
        '2006.07.04 �����Ǘ� �ǉ� by ���@
        if Session("PAGEGRANT") = "4" then 
%>
		<TD><A HREF="rsvMain.asp" TARGET="_top" ONCLICK="javascript:return confirm('�V�����\�����o�^���܂��B��낵���ł����H')"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�K�ɗ\����͂��s���܂�"></A></TD>
<%      End If   %>

		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
		'�ۑ��֘A�{�^���̐���

		'�L�����Z���҂̏ꍇ�́u�폜�v�u�\���Ԃɖ߂��v
		If CLng("0" & strCancelFlg) <> CONSULT_USED Then
%>
			<TD><A HREF="javascript:deleteConsult()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̃L�����Z���������S�ɍ폜���܂�"></A></TD>
			<TD><A HREF="javascript:restoreConsult()"><IMG SRC="/webHains/images/rebornrsv.gif" WIDTH="77" HEIGHT="24" ALT="�\���Ԃɖ߂��܂�"></A></TD>
<%
		'����ȊO�́u�ۑ��v

		Else
			if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
				<TD><A HREF="javascript:saveConsult()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ύX�������e��ۑ����܂�"></A></TD>

<%
			end if
		End If

		'�L�����Z����������f���ɂ��Ắu�R�����g�v�{�^����ҏW
		If strRsvNo <> "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
            <TD><A HREF="javascript:noteGuide_showGuideNote('1', '1,1,1,1', '', <%= strRsvNo %>)"><IMG SRC="/webHains/images/comment.gif" HEIGHT="24" WIDTH="77" ALT="�R�����g��o�^���܂�"></A></TD>
<%
		End If
%>
		<TD><A HREF="javascript:callDayliListWindow()"><IMG SRC="/webHains/images/history.gif" WIDTH="77" HEIGHT="24" ALT="��f����\�����܂�"></A></TD>
<%
		'�L�����Z����������f���ɂ��Ắu���A��l�v�u���z�v�{�^����ҏW
		If strRsvNo <> "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
			<TD><A HREF="javascript:callFriendWindow()"><IMG SRC="/webHains/images/friends.gif" WIDTH="77" HEIGHT="24" ALT="���A��l��o�^���܂�"></A></TD>
			<TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="�\��󋵂�\�����܂�"></A></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD><A HREF="/webHains/contents/perBill/perPaymentInfo.asp?rsvno=<%= strRsvNo %>" TARGET="_blank"><IMG SRC="/webHains/images/price.gif" WIDTH="77" HEIGHT="24" ALT="��f���z����\�����܂�"></A></TD>
<%
		Else
%>
			<TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="�\��󋵂�\�����܂�"></A></TD>
<%
		End If

		'��t�֘A�{�^���̐���
		Do

			'�L�����Z���҂̏ꍇ�͕s�v
			If CLng("0" & strCancelFlg) <> CONSULT_USED Then
				Exit Do
			End If
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
			'��t�ς݂̏ꍇ�́u��t�������v�u���@�v
			If strDayId <> "" Then
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then 
%>
				<TD><A HREF="javascript:callCancelReceiptWindow()"><IMG SRC="/webHains/images/cancelrsv.gif" WIDTH="77" HEIGHT="24" ALT="��t���������܂�"></A></TD>
<%
            End If
%>

		    <TD><A HREF="javascript:callVisitWindow()"><IMG SRC="/webHains/images/visit.gif" WIDTH="77" HEIGHT="24" ALT="���@�������s���܂�"></A></TD>

<%
				Exit Do
			End If

			'����ȊO�́u��t�v

            '2006.07.04 �����Ǘ� �ǉ� by ���@
            if Session("PAGEGRANT") = "4" then 
%>
			<TD><A HREF="javascript:callReceiptWindow()"><IMG SRC="/webHains/images/receiptrsv.gif" WIDTH="77" HEIGHT="24" ALT="��t�������s���܂�"></A></TD>
<%          End If   %>

<% '## 2004/04/20 Add By T.Takagi@FSIT ��f���ꊇ�ύX %>
<%
			'�V�K�ȊO�̏ꍇ�́u��f���ꊇ�ύX�v
			If strRsvNo <> "" Then
                '2006.07.04 �����Ǘ� �ǉ� by ���@
                if Session("PAGEGRANT") = "4" then 
%>
                    <TD><A HREF="javascript:callChangeDateWindow()"><IMG SRC="/webHains/images/allchange.gif" WIDTH="77" HEIGHT="24" ALT="��f���̈ꊇ�ύX�������s���܂�"></A></TD>
<%
                End If
            End If
%>
<% '## 2004/04/20 Add End %>
<%
			Exit Do
		Loop
%>
	</TR>
</TABLE>
<FORM NAME="paramForm" ACTION="/webHains/contents/frameReserve/fraRsvCalendar.asp" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode" VALUE="1">
	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="1">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="perId">
	<INPUT TYPE="hidden" NAME="manCnt">
	<INPUT TYPE="hidden" NAME="gender">
	<INPUT TYPE="hidden" NAME="birth">
	<INPUT TYPE="hidden" NAME="age">
	<INPUT TYPE="hidden" NAME="romeName">
	<INPUT TYPE="hidden" NAME="orgCd1">
	<INPUT TYPE="hidden" NAME="orgCd2">
	<INPUT TYPE="hidden" NAME="cslDivCd">
	<INPUT TYPE="hidden" NAME="csCd">
	<INPUT TYPE="hidden" NAME="rsvGrpCd">
	<INPUT TYPE="hidden" NAME="ctrPtCd">
	<INPUT TYPE="hidden" NAME="optCd">
	<INPUT TYPE="hidden" NAME="optBranchNo">
<% '## 2003.12.12 Add By T.Takagi@FSIT ���ݓ���n�� %>
	<INPUT TYPE="hidden" NAME="curCslYear">
	<INPUT TYPE="hidden" NAME="curCslMonth">
	<INPUT TYPE="hidden" NAME="curCslDay">
<% '## 2003.12.12 Add End %>
</FORM>
</BODY>
</HTML>
