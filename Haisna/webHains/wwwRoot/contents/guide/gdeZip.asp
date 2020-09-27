<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�X�֔ԍ������K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'�\�������̃f�t�H���g�l

Dim strKeyPrefCd	'�s���{���R�[�h
Dim strKey			'�����L�[
Dim lngStartPos		'�����J�n�ʒu
Dim lngGetCount		'�\������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strKeyPrefCd = Request("keyPrefCd") & ""
strKey       = Request("key") & ""
lngStartPos  = Request("startpos") & ""
lngStartPos  = CLng(IIf(lngStartPos = "", 1, lngStartPos))
lngGetCount  = Request("getcount") & ""
lngGetCount  = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �Z�����ꗗ�̕ҏW
'
' �����@�@ : (In)     strKeyPrefCd  �s���{���R�[�h
' �@�@�@�@ : (In)     strKey        �����L�[
' �@�@�@�@ : (In)     lngStartPos   �����J�n�ʒu
' �@�@�@�@ : (In)     lngGetCount   �\������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditZipList(strKeyPrefCd, strKey, lngStartPos, lngGetCount)

	Dim strArrKey		'(�������)�����L�[�̏W��

	Dim objZip			'�X�֔ԍ����A�N�Z�X�pCOM�I�u�W�F�N�g
	Dim objPref			'�s���{�����A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim blnZip			'���������ɗX�֔ԍ������݂����True
	Dim strKeyPrefName	'�s���{����
	Dim strCountInf		'���R�[�h�������

	Dim strZipCd1		'�X�֔ԍ�1
	Dim strZipCd2		'�X�֔ԍ�2
	Dim strPrefCd		'�s���{���R�[�h
	Dim strPrefName		'�s���{����
	Dim strCityName		'�s�撬����
	Dim strSection		'��

'### 2004/3/18 Added by Ishihara@FSIT �J�i�����ǉ�
	Dim strCityKName	'�s�撬���J�i��
	Dim strSectionKName	'�J�i��
'### 2004/3/18 Added End

	Dim lngAllCount		'�����𖞂����S���R�[�h����
	Dim lngCount		'���R�[�h����

	Dim strHTML			'HTML������
	Dim strDispCityName	'�ҏW�p�̎s�撬��
	Dim strDispSection	'�ҏW�p�̎�
	Dim strDispPrefName '�ҏW�p�̓s���{��

	Dim strBasedURL		'�i�r�Q�[�^�p�̊�{URL

	Dim i, j			'�C���f�b�N�X

	'�X�֔ԍ����A�N�Z�X�p�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objZip = Server.CreateObject("HainsZip.Zip")

	'�����������w�肳��Ă���ꍇ
	If strKey <> "" Then

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������ɗX�֔ԍ������݂��邩���`�F�b�N
		For i = 0 To UBound(strArrKey)
			If objZip.isZipCd(strArrKey(i)) = True Then
				blnZip = True
				Exit For
			End If
		Next

	End If

	'�X�֔ԍ��w�肪�Ȃ��A���s���{�����w�肳��Ă��Ȃ��ꍇ�͌������Ȃ�
	If blnZip = False And strKeyPrefCd = "" Then
		Exit Sub
	End If

	'���������𖞂������R�[�h�������擾
	lngAllCount = objZip.SelectZipListCount(strKeyPrefCd, strArrKey)

	Do
%>
		<FORM NAME="ziplist" action="#">
		<BLOCKQUOTE>
<%
		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂����Z�����͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If

		'�X�֔ԍ������݂��Ȃ��ꍇ�A�s���{�������擾
		If blnZip = False And strKeyPrefCd <> "" Then
			Set objPref = Server.CreateObject("HainsPref.Pref")
			objPref.SelectPref strKeyPrefCd, strKeyPrefName
			set objPref = Nothing
		End If

		'���R�[�h��������ҏW
		If strKeyPrefName <> "" Then
			strCountInf = "�u<FONT COLOR=""#ff6600""><B>" & strKeyPrefName & "</B></FONT>�v"
		End If

		If strKey <> "" Then
			strCountInf = strCountInf & "�u<FONT COLOR=""#ff6600""><B>" & strKey & "</B></FONT>�v"
		End If

		If strKeyPrefName <> "" Or Trim(strKey) <> "" Then
			strCountInf = strCountInf & "��"
		End If

		strCountInf = strCountInf & "�������ʂ� <FONT COLOR=""#ff6600""><B>" & CStr(lngAllCount) & "</B></FONT>������܂����B<BR>"
%>
		<%= strCountInf %>
<%

		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
'### 2004/3/18 Added by Ishihara@FSIT �J�i�����ǉ�
'		lngCount = objZip.SelectZipList(strKeyPrefCd, strArrKey, lngStartPos, lngGetCount, strZipCd1, strZipCd2, strPrefCd, strPrefName, strCityName, strSection)
		lngCount = objZip.SelectZipList(strKeyPrefCd, strArrKey, lngStartPos, lngGetCount, strZipCd1, strZipCd2, strPrefCd, strPrefName, strCityName, strSection, strCityKName, strSectionKName)
'### 2004/3/18 Added End

		'�Z���ꗗ�̕ҏW�J�n
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
		For i = 0 To lngCount - 1

			'�Z�����̎擾
			strDispCityName = strCityName(i)
			strDispSection  = strSection(i)
			strDispPrefName = strPrefName(i)

			'�����L�[�ɍ��v���镔����<B>�^�O��t��
			If Not IsEmpty(strArrKey) Then
				For j = 0 To UBound(strArrKey)
					strDispCityName = Replace(strDispCityName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispSection  = Replace(strDispSection,  strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next
			End If

			'�Z�����̕ҏW
%>
			<INPUT TYPE="hidden" NAME="zipcd1"   VALUE="<%= strZipCd1(i)   %>">
			<INPUT TYPE="hidden" NAME="zipcd2"   VALUE="<%= strZipCd2(i)   %>">
			<INPUT TYPE="hidden" NAME="prefcd"   VALUE="<%= strPrefCd(i)   %>">
			<INPUT TYPE="hidden" NAME="prefname" VALUE="<%= strPrefName(i) %>">
			<INPUT TYPE="hidden" NAME="cityname" VALUE="<%= strCityName(i) %>">
			<INPUT TYPE="hidden" NAME="section"  VALUE="<%= strSection(i)  %>">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strZipCd1(i) %>-<%= strZipCd2(i) %></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><A HREF="JavaScript:selectList(<%= i %>)" CLASS="guideItem"><%= strDispPrefName %>�@<%= strDispCityName %>�@<%= strDispSection %></A></TD>
				<TD WIDTH="10"></TD>
				<TD><FONT COLOR="#666666"><%= strCityKName(i) & "�@" & strSectionKName(i) %></FONT></TD>
			</TR>
<%
		Next

		'�������̕ҏW
%>
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�p��URL��{����ҏW
		strBasedURL = Request.ServerVariables("SCRIPT_NAME") & "?"
		If strKeyPrefCd <> "" Then
			strBasedURL = strBasedURL & "keyPrefCd=" & strKeyPrefCd & "&"
		End If
		strBasedURL = strBasedURL & "key=" & Server.URLEncode(strKey)

		'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
		<%= EditPageNavi(strBasedURL, lngAllCount, lngStartPos, lngGetCount) %>

		</BLOCKQUOTE>
		</FORM>
<%
		Exit Do
	Loop

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�Z���̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �����J�n����
function startSearching() {

	var word;		// ���������̔z��
	var wideOnly;	// ���������ɑS�p�����������݂��Ȃ�
	var i;			// �C���f�b�N�X

	// �����������󔒂ŕ���
	word = document.entryForm.key.value.replace(/[�@ ]+/g, ' ').split(' ');
	if ( word.length == 0 ) {
		return false;
	}

	// ���������ɔF���ł��Ȃ��X�֔ԍ��`�������݂��邩�𔻒�
	for ( i = 0, wideOnly = true; i < word.length; i++ ) {

		// �����񂪑��݂��Ȃ���΃X�L�b�v
		if ( word[i] == '' ) {
			continue;
		}

		// �S�p�������܂܂�Ă���ꍇ�̓X�L�b�v
		if ( isWide(word[i]) ) {
			continue;
		}

		// 3���̐�����ł���ΐ���
		if ( word[i].length == 3 && word[i].match(/[0-9]{3}/) != null ) {
			wideOnly = false;
			continue;
		}

		// 7���̐�����ł���ΐ���
		if ( word[i].length == 7 && word[i].match('[0-9]{7}') != null ) {
			wideOnly = false;
			continue;
		}

		// 999-9999�̌`���ł���ΐ���
		if ( word[i].length == 8 && word[i].match(/[0-9]{3}-[0-9]{4}/) != null ) {
			wideOnly = false;
			continue;
		}

		// �ǂ̏����ɂ����v���Ȃ��ꍇ�̓G���[
		alert('�X�֔ԍ��̎w��`���Ɍ�肪����܂��B');
		return false;

	}

	// �S�p�������܂܂�Ă���ꍇ�A�s���{���͕K�{
	if ( wideOnly && document.entryForm.keyPrefCd.value == '' ) {
		alert('�s���{���͕K���w�肵�ĉ������B');
		return false;
	}

	// �����J�n
	return true;
}

/* �S�p�������܂܂�Ă��邩 */
function isWide(expression) {

	var token;
	var ret = false;
	var i;

	// 1�����P�ʂŃ`�F�b�N
	for ( i = 0; i < expression.length; i++ ) {

		token = escape(expression.charAt(i));

		// IE�̏ꍇ(UniCode�Ŕ��f)
		if ( document.all ) {

			// �S�p�����E���p�J�i�̔��f
			if ( token.length == 6 ) {
				ret = true;
				break;
			}

			continue;
		}

		// NC4�̏ꍇ(SJIS�Ŕ��f)
		if ( document.layers || document.getElementById ) {

			// �S�p�����E���p�J�i�̔��f
			if ( token.length >= 3 && token.indexOf('%') != -1 ) {
				ret = true;
				break;
			}

		}

	}

	return ret;
}

// �X�֔ԍ��E�Z���̃Z�b�g
function selectList( index ) {

	var objForm;		// ����ʂ̃t�H�[���G�������g
	var zipCd1   = '';	// �X�֔ԍ�1
	var zipCd2   = '';	// �X�֔ԍ�2
	var zipCd    = '';	// �X�֔ԍ�    2003.09.01 ���H���Ή��@�ǉ�
	var prefCd   = '';	// �s���{���R�[�h
	var cityName = '';	// �s�撬����
	var section  = '';	// ��

	objForm = document.ziplist;

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	// �X�֔ԍ�1�̎擾
	if ( objForm.zipcd1.length != null ) {
		zipCd1 = objForm.zipcd1[ index ].value;
	} else {
		zipCd1 = objForm.zipcd1.value;
	}

	// �X�֔ԍ�2�̎擾
	if ( objForm.zipcd2.length != null ) {
		zipCd2 = objForm.zipcd2[ index ].value;
	} else {
		zipCd2 = objForm.zipcd2.value;
	}

	// �s���{���R�[�h�̎擾
	if ( objForm.prefcd.length != null ) {
		prefCd = objForm.prefcd[ index ].value;
	} else {
		prefCd = objForm.prefcd.value;
	}

	// �s�撬�����̎擾
	if ( objForm.cityname.length != null ) {
		cityName = objForm.cityname[ index ].value;
	} else {
		cityName = objForm.cityname.value;
	}

	// ���̎擾
	if ( objForm.section.length != null ) {
		if ( objForm.section[ index ].value != '�ȉ��Ɍf�ڂ��Ȃ��ꍇ' ) {
			section = objForm.section[ index ].value;
		}
	} else {
		if ( objForm.section.value != '�ȉ��Ɍf�ڂ��Ȃ��ꍇ' ) {
			section = objForm.section.value;
		}
	}

	// �Z���ҏW�p�֐��Ăяo��
//	opener.zipGuide_setZipInfo( zipCd1, zipCd2, prefCd, cityName, section );
	// ���H���Ή� start 2003.09.01 =======>
	zipCd = zipCd1 + zipCd2;
	opener.zipGuide_setZipInfo( zipCd, prefCd, cityName, section );
	// <======== ���H���Ή��@end 

	// ��ʂ����
	opener.winGuideZip = null;
	close();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 0; }
	td.mnttab  { background-color:#FFFFFF }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="return startSearching();">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�Z���̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD>�s���{���F</TD>
			<TD COLSPAN="2"><%= EditPrefList("keyPrefCd", strKeyPrefCd) %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>���������F</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<%
	'�Z�����ꗗ�̕ҏW
	Call EditZipList(strKeyPrefCd, strKey, lngStartPos, lngGetCount)
%>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
