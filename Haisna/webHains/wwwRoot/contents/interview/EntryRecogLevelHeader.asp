<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �F�����x���̓o�^�i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_RECOGLEVEL = "X018"	'�F�����x���O���[�v�R�[�h
Const JUDCLASSCD_LIFEADVICE = 50	'���蕪�ރR�[�h�F�����w��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objResult			'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h
Dim strAct				'�������

'��������
Dim vntPerId			'�\��ԍ�
Dim vntCslDate			'�������ڃR�[�h
Dim vntHisNo			'����No.
Dim vntRsvNo			'�\��ԍ�
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim lngRslCnt			'�������ʐ�
Dim vntRslCmtCd1		'���ʃR�����g�P
Dim vntRslCmtCd2		'���ʃR�����g�Q

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim vntUpdItemCd		'�������ڃR�[�h
Dim vntUpdSuffix		'�T�t�B�b�N�X
Dim vntUpdResult		'��������
Dim vntUpdRslCmtCd1		'���ʃR�����g�P
Dim vntUpdRslCmtCd2		'���ʃR�����g�Q
Dim lngUpdCount			'�X�V���ڐ�
Dim strArrMessage		'�G���[���b�Z�[�W

Dim i, j				'�C���f�b�N�X
Dim index				'�C���f�b�N�X
Dim vntRecogLevelCd		'�F�����x��(�R�[�h)
Dim vntRecogLevelStr	'�F�����x��(������)
Dim strRecogLevel		'�F�����x��

Dim strUpdUser			'�X�V��
Dim strIPAddress		'IP�A�h���X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strAct				= Request("act")

vntUpdItemCd		= ConvIStringToArray(Request("itemcd"))
vntUpdSuffix		= ConvIStringToArray(Request("suffix"))
vntUpdResult		= ConvIStringToArray(Request("recogLevel"))
vntUpdRslCmtCd1		= ConvIStringToArray(Request("cmtcd1"))
vntUpdRslCmtCd2		= ConvIStringToArray(Request("cmtcd2"))

Do	
	'�ۑ�
	If strAct = "save" Then
		If Not IsEmpty(vntUpdItemCd) Then
			'�X�V�҂̐ݒ�
			strUpdUser = Session("USERID")
			'IP�A�h���X�̎擾
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'�������ʍX�V
'			strArrMessage = objResult.UpdateRsl_tk( _
'								strUpdUser, _
'								strIPAddress, _
'								lngRsvNo, _
'								vntUpdItemCd, _
'								vntUpdSuffix, _
'								vntUpdResult, _
'								vntUpdRslCmtCd1, _
'								vntUpdRslCmtCd2 _
'								)
			objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdRslCmtCd1, vntUpdRslCmtCd2, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'�I�u�W�F�N�g�̃C���X�^���X�폜
			Set objResult = Nothing
		End If

		'�ۑ�����
		strAct = "saveend"
	End If
	'�F�����x���擾
	''## 2006.05.10 Mod by ��  *****************************
	''�O���\�����[�h�ݒ�
'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						2, _
'						GRPCD_RECOGLEVEL, _
'						0, _
'						"", _
'						0, _
'						0, _
'						0, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						, _
'						vntResult, , _
'						vntRslCmtCd1, , _
'						vntRslCmtCd2 _
'						)

	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						2, _
						GRPCD_RECOGLEVEL, _
						1, _
						strCsCd, _
						0, _
						0, _
						0, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						, _
						vntResult, , _
						vntRslCmtCd1, , _
						vntRslCmtCd2 _
						)
''## 2006.05.10 Mod End. *********************************


	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�F�����x�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

    vntRecogLevelCd  = Array("1", "2", "3", "4", "5", "0")
    vntRecogLevelStr = Array("��", "����", "������", "��������", "����������", "�ʐږ����{")

	Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�F�����x���̓o�^</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
var varEditchkCmtDel;

// �R�����g�̑I��
function selectComment() {
	var myForm = parent.list.document.entryForm;
	var i;

	// �R�����g��ҏW�G���A�ɃZ�b�g
	cmtGuide_editcnt = myForm.CmtCnt.value;
	cmtGuide_varEditCmtCd = new Array();
	varEditCmtCd = new Array();
	varEditCmtStc = new Array();
	varEditClassCd = new Array();
	varEditchkCmtDel = new Array();

	cmtGuide_varEditCmtCd.length = 0;
	varEditCmtCd.length = 0;
	varEditCmtStc.length = 0;
	varEditClassCd.length = 0;
	varEditchkCmtDel.length = 0;

	for ( i = 0; i < cmtGuide_editcnt; i++ ){
		cmtGuide_varEditCmtCd.length ++;
		varEditCmtCd.length ++;
		varEditCmtStc.length ++;
		varEditClassCd.length ++;
		varEditchkCmtDel.length ++;

		if ( isNaN(myForm.TtlJudCmtCd.length) ){
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length - 1] = myForm.TtlJudCmtCd.value;
			varEditCmtCd[varEditCmtCd.length - 1] = myForm.TtlJudCmtCd.value;
			varEditCmtStc[varEditCmtStc.length - 1] = myForm.TtlJudCmtstc.value;
			varEditClassCd[varEditClassCd.length - 1] = myForm.TtlJudClassCd.value;
			varEditchkCmtDel[varEditchkCmtDel.length - 1] = (myForm.chkCmtDel.checked ? 'CHECKED' : '');
		} else {
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length - 1] = myForm.TtlJudCmtCd[i].value;
			varEditCmtCd[varEditCmtCd.length - 1] = myForm.TtlJudCmtCd[i].value;
			varEditCmtStc[varEditCmtStc.length - 1] = myForm.TtlJudCmtstc[i].value;
			varEditClassCd[varEditClassCd.length - 1] = myForm.TtlJudClassCd[i].value;
			varEditchkCmtDel[varEditchkCmtDel.length - 1] = (myForm.chkCmtDel[i].checked ? 'CHECKED' : '');
		}
	}
	// ### 2004/11/12 Add by Gouda@FSIT �����w���R�����g�̕\������
	// �R�����g�K�C�h�̌ďo
	//cmtGuide_showAdviceComment(<%= JUDCLASSCD_LIFEADVICE %>, setComment);
	cmtGuide_showAdviceComment(<%= JUDCLASSCD_LIFEADVICE %>, setComment, entryForm.recogLevel.value);
	// ### 2004/11/12 Add End
}

// �R�����g���Z�b�g
function setComment() {
	var myForm = parent.list.document.entryForm;
	var elem   = parent.list.document.getElementById('LifeAdviceList');
	var strHtml;
	var i;

	// �����w���R�����g�̍ĕ`��
	for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
		varEditCmtCd.length ++;
		varEditCmtStc.length ++;
		varEditClassCd.length ++;

		varEditCmtCd[varEditCmtCd.length - 1] = cmtGuide_varSelCmtCd[i];
		varEditCmtStc[varEditCmtStc.length - 1] = cmtGuide_varSelCmtStc[i];
		varEditClassCd[varEditClassCd.length - 1] = cmtGuide_varSelClassCd[i];
	}
	cmtGuide_editcnt = eval(cmtGuide_editcnt) + eval(cmtGuide_varSelCmtCd.length);

	strHtml = '<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0" WIDTH="908">\n';
	for ( i = 0; i < cmtGuide_editcnt; i++ ) {
		strHtml = strHtml + '<TR>\n';
		strHtml = strHtml + '<TD WIDTH="100%">' + varEditCmtStc[i] + '</TD>\n';
		strHtml = strHtml + '<TD NOWRAP VALIGN="top"><INPUT TYPE="checkbox" NAME="chkCmtDel" ' + varEditchkCmtDel[i] + '>�폜</TD>\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudCmtCd"   VALUE="' + varEditCmtCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudCmtstc"  VALUE="' + varEditCmtStc[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudClassCd" VALUE="' + varEditClassCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="CmtDelFlag" VALUE="">\n';
		strHtml = strHtml + '</TR>\n';
		strHtml = strHtml + '<TR>\n';
		strHtml = strHtml + '<TD HEIGHT="1" BGCOLOR="#999999"></TD>\n';
		strHtml = strHtml + '<TD NOWRAP VALIGN="top" HEIGHT="1" BGCOLOR="#999999"></TD>\n';
		strHtml = strHtml + '</TR>\n';
	}
	strHtml = strHtml + '</TABLE>\n';

	elem.innerHTML = strHtml;
	myForm.CmtCnt.value = cmtGuide_editcnt;

}

//�ۑ�
function saveRecogLevel() {
	var i;

	// ���[�h���w�肵��submit(�w�b�_�[)
	with ( parent.header.document.entryForm ) {
		act.value = 'save';
		submit();
	}

	// ���[�h���w�肵��submit(�{�f�B)
	with ( parent.list.document.entryForm ) {
		if( CmtCnt.value > 0  ) {
			if( chkCmtDel.length > 1 ) {
				for ( i = 0; i < chkCmtDel.length; i++ ) {
					CmtDelFlag[i].value = (chkCmtDel[i].checked ? '1' : '');
				}
			} else {
				CmtDelFlag.value = (chkCmtDel.checked ? '1' : '');
			}
			act.value = 'save';
			submit();
		}
	}

}

//�������S������ʌĂяo��
function callMenKyoketsu() {
	var url;							// URL������

	url = '/WebHains/contents/interview/MenKyoketsu.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	parent.location.href(url);

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:cmtGuide_closeAdviceComment()">
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�F�����x���̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="900">
		<TR>
			<TD NOWRAP>�F�����x���F</TD>
<%
	index = -1
	For i=0 To lngRslCnt -1
		If vntHisNo(i) = 1 Then
			index = i
			Exit For
		End If
	Next
	If index > -1 Then
%>
			<INPUT TYPE="hidden" NAME="itemcd" VALUE="<%= vntItemCd(index) %>">
			<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= vntSuffix(index) %>">
			<INPUT TYPE="hidden" NAME="cmtcd1" VALUE="<%= vntRslCmtCd1(index) %>">
			<INPUT TYPE="hidden" NAME="cmtcd2" VALUE="<%= vntRslCmtCd2(index) %>">
			<TD><%= EditDropDownListFromArray("recogLevel", vntRecogLevelCd, vntRecogLevelStr, vntResult(index), NON_SELECTED_ADD) %></TD>
<%
	Else
%>
			<TD><%= EditDropDownListFromArray("recogLevel", vntRecogLevelCd, vntRecogLevelStr, -1, NON_SELECTED_ADD) %></TD>
<%
	End If
%>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP>�O��F�����x���F</TD>
<%
	index = -1
	strRecogLevel = "&nbsp;"
	For i=0 To lngRslCnt -1
		If vntHisNo(i) = 2 Then
			For j=0 TO UBound(vntRecogLevelCd)
				If vntResult(i) = vntRecogLevelCd(j) Then
					index = j
					Exit For
				End If
			Next
		End If
		If index > -1 Then 
			strRecogLevel = vntRecogLevelStr(index)
			Exit For
		End IF
	Next
%>
			<TD NOWRAP><%= strRecogLevel %></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="javascript:selectComment()">�R�����g�̑I��</A></TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			
			<TD>
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:saveRecogLevel()"><IMG SRC="../../images/save.gif" ALT="�ۑ�" HEIGHT="24" WIDTH="77"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ��  ---- END %>
			</TD>
			
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			<TD NOWRAP><A HREF="JavaScript:callMenKyoketsu()">�������S������ʂ�</A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>