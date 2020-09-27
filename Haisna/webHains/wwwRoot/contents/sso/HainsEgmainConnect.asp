<%@ LANGUAGE="VBScript" %>
<%
'########################################
'�Ǘ��ԍ��FSL-UI-Y0101-002
'�쐬��  �F2010.06.04
'�S����  �FFJTH)KOMURO
'�쐬���e�F�V���O�����ґI���@�\��V�K�쐬
'########################################

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%

'�p�����[�^
Dim strFuncCode		'�@�\�ԍ�
Dim strCslDate		'��f��(yyyymmdd)
Dim strUserId		'���p��ID
Dim strPerId		'����ID
Dim strOrderNo		'�I�[�_�[�ԍ�
Dim strStatusCode	'���O�R�[�h
Dim strMedicalCode	'�f�ÉȃR�[�h

'�����l�̎擾
strFuncCode		= "" & Request("funccode")
strCslDate		= "" & Request("csldate")
strUserId		= "" & IIf(Request("userid") = "", Session("USERID"), Request("userid"))
strPerId		= "" & Request("perid")
strOrderNo		= "" & Request("orderno")
strStatusCode	= "" & Request("statuscode")
strMedicalCode	= "" & Request("medicalcode")

'����ID�̕ҏW�i�[���v�f�B���O��10���ɕҏW�j
If strPerId <> "" And Len(strPerId) < 10 Then
	strPerId = Right("0000000000" & strPerId, 10)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�A�g�V�X�e���N��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<script type="text/javascript">
<!--
// ���폈�������b�Z�[�W��������
function createRegularMsg()
{
	var strMsg = '';
	strMsg += '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD HEIGHT="5"></TD>';
	strMsg += '  </TR>';
	strMsg += '  <TR>';
	strMsg += '    <TD VALIGN="BOTTOM">';
	strMsg += '      <SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">';
	strMsg += '�N�����ł��E�E�E';
	strMsg += '      </SPAN>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';

	return strMsg;
}

// �G���[���b�Z�[�W��������
function createErrMsg(pstrCode)
{
	var strMsg = '';

	strMsg += '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD HEIGHT="5"></TD>';
	strMsg += '  </TR>';
	strMsg += '  <TR>';
	strMsg += '    <TD>';
	strMsg += '      <IMG SRC="/webHains/images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="">';
	strMsg += '    </TD>';
	strMsg += '    <TD VALIGN="BOTTOM">';
	strMsg += '      <SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">';
	strMsg += convertErrMsg(pstrCode);
	strMsg += '      </SPAN>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';
	strMsg += '<BR>';
	strMsg += '<TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD>';
	strMsg += '      <A HREF="javascript:close()"><IMG SRC="../../images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�" border="0"></A>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';

	return strMsg;
}

// �G���[�R�[�h�̃��b�Z�[�W�ϊ�
function convertErrMsg(pstrCode)
{
	var strMsg = "";

	switch ( pstrCode ) {
	
		case "10":
			strMsg += "�d�q�`���[�g�V�X�e���ɐڑ��ł��܂���B";
			strMsg += "<BR>";
			strMsg += "�V�X�e���Ǘ��҂ւ��A�����������B";
			break;

		case "11":
			strMsg += "�d�q�`���[�g�V�X�e�����N������Ă��܂���B";
			strMsg += "<BR>";
			strMsg += "�u���E�U��S�ĕ��A�d�q�`���[�g�V�X�e�����N��������ɍēx���s���Ă��������B";
			break;

		case "12":
			strMsg += "�d�q�`���[�g�V�X�e���Ƀ��O�C������Ă��܂���B";
			strMsg += "<BR>";
			strMsg += "�d�q�`���[�g�V�X�e���Ƀ��O�C��������A�ēx���s���Ă��������B";
			break;

		case "13":
			strMsg += "�d�q�`���[�g�V�X�e���ɗ��p�҂��o�^����Ă��܂���B";
			strMsg += "<BR>";
			strMsg += "�V�X�e���Ǘ��҂ւ��A�����������B";
			break;

		case "14":
			strMsg += "���O�C�����Ă��闘�p�҂Ɍ������s�����Ă��܂��B";
			strMsg += "<BR>";
			strMsg += "�V�X�e���Ǘ��҂ւ��A�����������B";
			break;

		case "15":
			strMsg += "���O�C�����Ă��闘�p�҂��Ⴂ�܂��B";
			strMsg += "<BR>";
			strMsg += "�d�q�`���[�g�V�X�e���Ƀ��O�C�����Ă��闘�p�҂Ŏ��s���Ă��������B";
			break;

		case "16":
			strMsg += "�Q�Ƃ��Ă��銳�҃`���[�g��񂪐������𒴂��Ă��܂��B";
			strMsg += "<BR>";
			strMsg += "�Q�ƒ��̊��҃`���[�g������Ă��������B";
			break;

		case "29":
			strMsg += "�\�����ʃG���[���������܂����B";
			strMsg += "<BR>";
			strMsg += "�V�X�e���Ǘ��҂ւ��A�����������B";
			break;

		case "30":
			strMsg += "�d�q�`���[�g�V�X�e���Ɋ���ID���o�^����Ă��܂���B";
			strMsg += "<BR>";
			strMsg += "�㎖�V�X�e������A�K�v�Ȋ��ҏ���o�^���Ă��������B";
			break;

		case "50":
			strMsg += "���|�[�g��񂪑��݂��܂���B";
			strMsg += "<BR>";
			strMsg += "�d�q�`���[�g�V�X�e���̃��|�[�g�����m�F���Ă��������B";
			break;

		default:
			strMsg += "�\�����ʃG���[���������܂����B";
			strMsg += "<BR>";
			strMsg += "�V�X�e���Ǘ��҂ւ��A�����������B";
			strMsg += "<BR>";
			strMsg += "ErrCode : " + pstrCode;
			break;

	}

	return strMsg;
}
-->
</script>
<!-- �A�g�pActiveX -->
<OBJECT ID="HainsEgmainConnect"
	CLASSID="CLSID:55E321EC-E8BE-4389-BBF0-49B0ED821B46"
	     codebase="/webHains/cab/SSo/HainsEgmainConnect.CAB#version=1,0,0,0">
</OBJECT>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�A�g�V�X�e���N��</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<script type="text/javascript">
	<!--
			var strCode;

			// �d�q�`���[�g�A�gActiveX���ďo
			strCode = HainsEgmainConnect.HainsEgmainCall("<%= strFuncCode %>", "<%= strCslDate %>", "<%= strUserId %>", "<%= strPerId %>", "<%= strOrderNo %>", "<%= strStatusCode %>", "<%= strMedicalCode %>");

			// ���^�[���R�[�h�𔻒f
			if (  strCode == '00' ) {
				// ����I���̏ꍇ�A���탁�b�Z�[�W��\��
				document.write(createRegularMsg());
			} else {
				//�ُ�I���̏ꍇ�A�G���[���b�Z�[�W��\��
				document.write(createErrMsg(strCode));
			}
	-->
	</script>
</FORM>
<script type="text/javascript">
<!--
// ���^�[���R�[�h�𔻒f
if ( strCode == "00" ) {
	// ����I���̏ꍇ�A�����I�ɃE�B���h�E�����
	window.opener = 0;
	window.open('', '_self');
	window.close();
}
-->
</script>
</BODY>
</HTML>
