<% 
'-----------------------------------------------------------------------------
'		�ėp���̒��o (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const COLCOUNT = 5		'�������ڂ̕\����

Dim strArrSelItemName	'�������ږ�

'����p
Dim imax, jmax			'���[�v��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�������ڕ\������p���[�v�񐔂̌v�Z
jmax = COLCOUNT
imax = mlngRowCount / jmax

'�������ږ��̂̍Ď擾
ReDim strArrSelItemName(mlngRowCount - 1)
For i = 0 To mlngRowCount - 1
	'�������ڃR�[�h������Ζ��̂��擾�A������΋�
	If Trim(mstrArrSelItemCd(i)) <> "" Then
		Call objItem.SelectItemName(mstrArrSelItemCd(i), mstrArrSelSuffix(i), strArrSelItemName(i))
	Else
		strArrSelItemName(i) = ""
	End If
Next
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���o�f�[�^�̎w��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var lngSelectedIndex;		/* �K�C�h�\�����ɑI�����ꂽ�������ڂ̃C���f�b�N�X */

// ���ڃK�C�h�Ăяo��
function callItmGuide( index ) {

	// �I�����ꂽ���̃C���f�b�N�X��ޔ�
	lngSelectedIndex = index;

	// �K�C�h�Ɉ����n���f�[�^�̃Z�b�g
	itmGuide_mode     = 2;	// �˗��^���ʃ��[�h�@1:�˗��A2:����
	itmGuide_group    = 0;	// �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_item     = 1;	// �������ڕ\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_question = 1;	// ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	itmGuide_CalledFunction = setItmInfo;

	// ���ڃK�C�h�\��
	showGuideItm();

	return false;
}

// �������ڂ̃Z�b�g
function setItmInfo() {

	var itmNameElement = new Array;		/* �������ږ���ҏW����G�������g�̖��� */
	var itmName        = new Array;		/* �������ږ���ҏW����G�������g���g */
	var itmOK          = new Array;		/* �d�����Ă��Ȃ����ڂ̓Y�����̔z�� */
	var itmNG          = new Array;		/* �d�����Ă��鍀�ڂ̓Y�����̔z�� */
	var okFlg;							/* �d���`�F�b�N�t���O */
	var strAlert;						/* �A���[�g���b�Z�[�W */
	var i, j;							/* �C���f�b�N�X */
	var icount;							/* ���[�v�� */

	// ���łɑI���ς݂̍��ڂƂ̏d���`�F�b�N
	itmOK.length = 0; itmNG.length = 0;
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < itmGuide_itemCd.length; i++ ) {
			okFlg = true;
			j = 0;
			do {
				if ((itmGuide_itemCd[i] == document.step1.selItemCd[j].value) && (itmGuide_suffix[i] == document.step1.selSuffix[j].value)) {
					okFlg = false;
					break;
				}
				j = j + 1;
			} while (j < <%= mlngRowCount %>)
			if (okFlg) {
				itmOK[itmOK.length] = i;
			}
			else {
				itmNG[itmNG.length] = i;
			}
		}
		// �d�����ڂ�����΃A���[�g�\��
		if (itmNG.length > 0) {
			strAlert = '�ȉ��̌������ڂ͂��łɑI������Ă��܂��B\n';
			for ( i = 0; i < itmNG.length; i++ ){
				strAlert = strAlert + '�E' + itmGuide_itemName[itmNG[i]] + '\n';
			}
			alert(strAlert);
		}
	} else {
		return false;
	}

	icount = <%= mlngRowCount %> - lngSelectedIndex;			/* ���[�v�񐔂��v�Z */

	// �\�ߑޔ������C���f�b�N�X��̌������ڏ��ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < icount; i++ ) {
			if (i < itmOK.length) {
				document.step1.selItemCd[lngSelectedIndex + i].value = itmGuide_itemCd[itmOK[i]];
				document.step1.selSuffix[lngSelectedIndex + i].value = itmGuide_suffix[itmOK[i]];
			}
		}
	} else {
		return false;
	}

	// �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
	if ( itmGuide_itemCd.length > 0 ) {
		for ( ; ; ) {

			// �G�������g���̕ҏW
			for (i = 0; i < icount; i++) {
				if (i < itmOK.length) {
					itmNameElement[i] = 'itemname' + (lngSelectedIndex + i);
				}
			}

			// IE�̏ꍇ
			if ( document.all ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.all(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
				break;
			}

			// Netscape6�̏ꍇ
			if ( document.getElementById ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.getElementById(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
			}

			break;
		}
	}
	return false;
}

// �������ڃR�[�h�E���̂̃N���A
function clearItemCd( index ) {

	var itmNameElement;			/* �������ږ���ҏW����G�������g�̖��� */
	var itmName;				/* �������ږ���ҏW����G�������g���g */

	// hidden���ڂ̍Đݒ�
	document.step1.selItemCd[index].value = '';
	document.step1.selSuffix[index].value = '';

	// �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		itmNameElement = 'itemname' + index;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(itmNameElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(itmNameElement).innerHTML = '';
		}

		break;
	}

	return false;

}

// �ĕ\��
function redirectPage() {

	var i;

	// �u�S�Ă̌������ڒ��o�v�I�����̃A���[�g
	if (document.step1.optResult[1].checked) {
		alert('�S�Ă̌������ڂ𒊏o����ƁA1�s������256��𒴂���\��������܂��B\n' + 
			  '�������s��Excel�ł͕ҏW�ł��܂��񂪂�낵���ł����B');
	}

	// �u�������ڂ��w��v�I�����͌������ڂ����p���A����ȊO�̓��Z�b�g
	if (document.step1.optResult[2].checked) {
		document.step1.rowCountItem.value = <%= mlngRowCount %>;
		for (i = 0; i < <%= mlngRowCount %>; i++) {
			document.step1.itemCd[i].value = document.step1.selItemCd[i].value;
			document.step1.suffix[i].value = document.step1.selSuffix[i].value;
		}
	}
	else {
		document.step1.rowCountItem.value = '<%= ROWCOUNT_ITEM %>';
		for (i = 0; i < <%= ROWCOUNT_ITEM %>; i++) {
			document.step1.itemCd[i].value = '';
			document.step1.suffix[i].value = '';
		}
	}

	document.step1.step2.value = '1';
	document.step1.submit();						/* ���M */

}

function changeItemCount() {
	document.step1.step2.value = '';
	document.step1.submit();
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step1" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="rowCountItem" VALUE="<%= mlngRowCount %>">
<%
	For i = 0 To mlngRowCount - 1
%>
		<INPUT TYPE="hidden" NAME="itemCd" VALUE="">
		<INPUT TYPE="hidden" NAME="suffix" VALUE="">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">���o�f�[�^�̎w��</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">��f�����</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkDate"   <%= IIf(mstrChkDate   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>��f��</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkCsCd"   <%= IIf(mstrChkCsCd   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>�R�[�X</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkAge"    <%= IIf(mstrChkAge    = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>��f���N��</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkJud"    <%= IIf(mstrChkJud    = CHK_ON, "CHECKED", "") %>></TD>
						<TD WIDTH="70" NOWRAP>��������</TD>
					</TR>
<!--
					<tr>
						<td><INPUT TYPE="checkbox" NAME="chkOrgCd"  <%= IIf(mstrChkOrgCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>��f�c��</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgBsdCd"  <%= IIf(mstrChkOrgBsdCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>���ƕ�</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgRoomCd"  <%= IIf(mstrChkOrgRoomCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>����</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgPostCd"  <%= IIf(mstrChkOrgPostCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>����</td>
					</tr>
-->
				</TABLE>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">�l���</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkPerID"  <%= IIf(mstrChkPerID  = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>�l�h�c</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkName"   <%= IIf(mstrChkName   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>����</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkBirth"  <%= IIf(mstrChkBirth  = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>���N����</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkGender" <%= IIf(mstrChkGender = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>����</TD>
<!--			
						<td width="20" nowrap><INPUT TYPE="checkbox" NAME="chkEmpNo" <%= IIf(mstrChkEmpNo = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>�]�ƈ��ԍ�</td>
-->
		</TR>
<!--
					<tr>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgCd"  <%= IIf(mstrchkPOrgCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>�����c��</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgBsdCd"  <%= IIf(mstrchkPOrgBsdCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>���ƕ�</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgRoomCd"  <%= IIf(mstrchkPOrgRoomCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>����</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgPostCd"  <%= IIf(mstrchkPOrgPostCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>����</td>
						<td width="20" nowrap><INPUT TYPE="checkbox" NAME="chkOverTime"  <%= IIf(mstrchkOverTime  = CHK_ON, "CHECKED", "") %>></td>
						<td width="100" nowrap>���ߋΖ�����</td>
					</tr>
-->
				</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">��������</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_NOTSELECT %>" <%= IIf(mstrOptResult = CASE_NOTSELECT, "CHECKED", "") %>></TD>
			<TD COLSPAN="10">�������ʂ𒊏o���Ȃ�</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_ALLSELECT %>" <%= IIf(mstrOptResult = CASE_ALLSELECT, "CHECKED", "") %>></TD>
			<TD COLSPAN="10">���ׂĂ̌������ʂ𒊏o����</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_SELECT %>"    <%= IIf(mstrOptResult = CASE_SELECT,    "CHECKED", "") %>></TD>
			<TD COLSPAN="10">���o���鍀�ڂ��w�肷��</TD>
		</TR>
		<TR>
			<TD></TD>
			<% For j = 1 To jmax %>
				<TD BGCOLOR="#eeeeee" COLSPAN="2" NOWRAP>��������</TD>
			<% Next %>
		</TR>
		<% For i = 1 To imax %>
			<TR>
				<TD></TD>
				<% For j = 1 To jmax %>
					<% k = jmax * ( i - 1 ) + j - 1 %>
					<TD>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callItmGuide(<%= k %>)"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���ڃK�C�h��\��"  ></A>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return clearItemCd(<%= k %>)" ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A>
					</TD>
					<TD WIDTH="90" NOWRAP>
						<INPUT TYPE="hidden" NAME="selItemCd" VALUE="<%= mstrArrSelItemCd(k) %>">
						<INPUT TYPE="hidden" NAME="selSuffix" VALUE="<%= mstrArrSelSuffix(k) %>">
						<SPAN  ID="itemname<%= k %>"><%= strArrSelItemName(k) %></SPAN>
					</TD>
				<% Next %>
			</TR>
		<% Next %>
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkOption" <%= IIf(mstrChkOption = CHK_ON, "CHECKED", "") %>></TD>
			<TD COLSPAN="5">���ʃR�����g�E����l�t���O�𒊏o�f�[�^�Ɋ܂�</TD>
			<TD ALIGN="right" COLSPAN="5">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>�ǉ��������ڂ�&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCount">
							<% For i = 10 To 50 Step 10 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCount, "SELECTED", "") %>><%= i %>��
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<a href="#" onclick="return changeItemCount();"><img src="/webhains/images/b_prev.gif" width="53" height="28" alt="�\��" /></a>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<input type="hidden" name="step2" value="" />
	<a href="#" onclick="return redirectPage();"><img src="/webHains/images/next.gif" width="72" height="24" alt="����" /></a>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>