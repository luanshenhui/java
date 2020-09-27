<?xml version="1.0" encoding="Shift_JIS" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" media-type="text/html" encoding="Shift_JIS" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"/>

<xsl:template match="CONSULT">
<html>
<head>
<title>�\��X�V���</title>
<link rel="stylesheet" type="text/css" href="/webHains/contents/css/default.css" />
</head>
<body bgcolor="#ffffff">

<table border="0" cellpadding="2" cellspacing="1" bgcolor="#999999" width="100%">
	<tr>
		<td height="15" bgcolor="#ffffff"><b><span class="reserve">��</span><font color="#000000">�\��X�V���</font></b></td>
	</tr>
</table>

<br/>

<table border="0" cellpadding="1" cellspacing="2">
	<tr>
		<td bgcolor="#eeeeee">����</td>
		<td><xsl:value-of select="UPDMODENAME" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�\��ԍ�</td>
		<td><xsl:value-of select="RSVNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�L�����Z���t���O</td>
		<td><xsl:value-of select="CANCELFLG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">��f��</td>
		<td><xsl:value-of select="CSLDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�l�h�c</td>
		<td><xsl:value-of select="PERID" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�R�[�X�R�[�h</td>
		<td><xsl:value-of select="CSCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">��f���c�̃R�[�h�P</td>
		<td><xsl:value-of select="ORGCD1" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">��f���c�̃R�[�h�Q</td>
		<td><xsl:value-of select="ORGCD2" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�\��Q�R�[�h</td>
		<td><xsl:value-of select="RSVGRPCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�\���</td>
		<td><xsl:value-of select="RSVDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">��f���N��</td>
		<td><xsl:value-of select="AGE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�X�V����</td>
		<td><xsl:value-of select="UPDDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�_��p�^�[���R�[�h</td>
		<td><xsl:value-of select="CTRPTCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">��f�敪�R�[�h</td>
		<td><xsl:value-of select="CSLDIVCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�\���</td>
		<td><xsl:value-of select="RSVSTATUS" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ۑ������</td>
		<td><xsl:value-of select="PRTONSAVE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�X�V��</td>
		<td><xsl:value-of select="UPDUSER" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">���я��o�͓�</td>
		<td><xsl:value-of select="REPORTPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">���я�������</td>
		<td><xsl:value-of select="REPORTSENDDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�P�����f�̗\��ԍ�</td>
		<td><xsl:value-of select="FIRSTRSVNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ی��؋L��</td>
		<td><xsl:value-of select="ISRSIGN" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ی��ؔԍ�</td>
		<td><xsl:value-of select="ISRNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�m�F�͂�������</td>
		<td><xsl:value-of select="CARDADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�m�F�͂����p���o��</td>
		<td><xsl:value-of select="CARDOUTENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�m�F�͂����o�͓�</td>
		<td><xsl:value-of select="CARDPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ꎮ��������</td>
		<td><xsl:value-of select="FORMADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ꎮ�����p���o��</td>
		<td><xsl:value-of select="FORMOUTENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ꎮ�����o�͓�</td>
		<td><xsl:value-of select="FORMPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">���я�����</td>
		<td><xsl:value-of select="REPORTADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">���я��p���o��</td>
		<td><xsl:value-of select="REPORTOURENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">���p�����</td>
		<td><xsl:value-of select="COLLECTTICKET" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�f�@�����s</td>
		<td><xsl:value-of select="ISSUECSLTICKET" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�������o��</td>
		<td><xsl:value-of select="BILLPRINT" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�ی��Ҕԍ�</td>
		<td><xsl:value-of select="ISRMANNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�Ј��ԍ�</td>
		<td><xsl:value-of select="EMPNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�Љ��</td>
		<td><xsl:value-of select="INTRODUCTOR" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�{�����e�B�A</td>
		<td><xsl:value-of select="VOLUNTEER" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�{�����e�B�A��</td>
		<td><xsl:value-of select="VOLUNTEERNAME" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">�\��m�F���[�����M��</td>
		<td><xsl:value-of select="SENDMAILDIV" /></td>
	</tr>

	<xsl:for-each select="CSLSET/CSLSET_ROW">

		<tr>
			<td bgcolor="#eeeeee">�Z�b�g�R�[�h</td>
			<td><xsl:value-of select="SETCD" /></td>
		</tr>

	</xsl:for-each>

	<xsl:for-each select="DELITEM/DELITEM_ROW">

		<tr>
			<td bgcolor="#eeeeee">�폜�˗����ڃR�[�h</td>
			<td><xsl:value-of select="ITEMCD" /></td>
		</tr>

	</xsl:for-each>

</table>

</body>
</html>

</xsl:template>

</xsl:stylesheet>