<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω��`�\���������ڑI�� (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-305
'�C����  �F2011.07.01
'�S����  �FORB)YAGUCHI
'�C�����e�F�򓮖������g�A�����d���A�������b�ʐρA�S�s�S�X�N���[�j���O�̒ǉ�
'========================================
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objItem				'���ڃK�C�h�A�N�Z�X�pCOM�I�u�W�F�N�g

'�p�����[�^
Dim strAction			'�������(�Z�b�g�I����:"select")
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

Dim strArrItemCd		'���ڃR�[�h
Dim strArrSuffix		'�T�t�B�b�N�X
Dim strArrItemName		'���ږ���
Dim lngArrCUTargetFlg	'CU�o�N�ω��\���Ώ�
Dim lngCount			'���R�[�h����
Dim strHtml				'HTML������
Dim strChk				'�I���t���O
Dim i, j				'�C���f�b�N�X

'�Z�b�g�I��p
Dim lngSetNo			'�I���Z�b�gNo
Dim strArrChkItemCd		'�������ڃR�[�h�i�I�𒆁j
Dim strArrChkSuffix		'�T�t�B�b�N�X�i�I�𒆁j
Dim lngSelCnt			'�I���ςݐ�
Dim strArrSelItem		'�I���ς݌�������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objItem = Server.CreateObject("HainsItem.Item")

'�����l�̎擾
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
lngSetNo			= Request("setno")
strArrChkItemCd		= IIf(Request("itemcd")="",Array(),ConvIStringToArray(Request("itemcd")))
strArrChkSuffix		= IIf(Request("suffix")="",Array(),ConvIStringToArray(Request("suffix")))

Do
	lngSelCnt = -1

	'�Z�b�g�I��
'	If strAction = "select" Then

		'�Z�b�g�I�����̐ݒ�
		Call SelectSetInfo( lngSetNo )

		'�I�𒆂̌������ڂ�����
		For i=0 To UBound(strArrChkItemCd)
			If strArrChkItemCd(i) <> "" And strArrChkSuffix(i) <> "" Then
				lngSelCnt = lngSelCnt + 1
				Redim Preserve strArrSelItem(lngSelCnt) 
				strArrSelItem(lngSelCnt) = strArrChkItemCd(i) & "-" & strArrChkSuffix(i)
			End If
		Next

		strAction = ""
'	End If

	lngArrCUTargetFlg = 1
	'���������𖞂����������ږ��̈ꗗ���擾����
	lngCount = objItem.SelectItem_cList( _
						"", _
						"", _
						1, _
						strArrItemCd, _
						strArrSuffix, _
						strArrItemName, _
						, , , , , _
						lngArrCUTargetFlg _
						)
	If lngCount < 0 Then
		Err.Raise 1000, , "���͂̈ꗗ���擾�ł��܂���B�i�������ڃR�[�h = " & strItemCd & ",���ڃ^�C�v = " & lngItemType & ")"
	End If


Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�b�t�o�N�ω��`�\���������ڑI��</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//�Z�b�g�I��
function selectSet(SetNo) {
	var i;								// �C���f�b�N�X

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	// �I�𒆂̌������ڂ̂ݎc��
	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			if( !document.entryForm.CUSelectItems[i].checked ) {
				document.entryForm.itemcd[i].value = '';
				document.entryForm.suffix[i].value = '';
			}
		}
	} else {
		if( !document.entryForm.CUSelectItems.checked ) {
			document.entryForm.itemcd.value = '';
			document.entryForm.suffix.value = '';
		}
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'select';
	document.entryForm.setno.value = SetNo;
	document.entryForm.submit();

}
//�I���I��
function callCUMainGraph() {
	var url;							// URL������
	var i;								// �C���f�b�N�X
	var SelectItemcd;					// �I�����ꂽ�������ڃR�[�h
	var SelectSuffix;					// �I�����ꂽ�T�t�B�b�N�X
	var SelectCnt;						// �I��

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	SelectCnt = 0;
	SelectItemcd = '';
	SelectSuffix = '';
	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			if( document.entryForm.CUSelectItems[i].checked ) {
				if( SelectCnt > 0 ) {
					SelectItemcd = SelectItemcd + ','
					SelectSuffix = SelectSuffix + ','
				}
				SelectItemcd = SelectItemcd + document.entryForm.itemcd[i].value;
				SelectSuffix = SelectSuffix + document.entryForm.suffix[i].value;
				SelectCnt++;
			}
		}
	} else {
		if( document.entryForm.CUSelectItems.checked ) {
			if( SelectCnt > 0 ) {
				SelectItemcd = SelectItemcd + ','
				SelectSuffix = SelectSuffix + ','
			}
			SelectItemcd = SelectItemcd + document.entryForm.itemcd.value;
			SelectSuffix = SelectSuffix + document.entryForm.suffix.value;
			SelectCnt++;
		}
	}

	if( SelectCnt == 0 ) {
		alert("�\���������ڂ��Œ�P���͑I�����Ă�������");
		return;
	}

	if( SelectCnt > 20 ) {
		alert("�\���������ڂ̍ő�I�𐔂͂Q�O���ł�");
		return;
	}

	url = '/WebHains/contents/interview/CUMainGraphMain.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';
	url = url + '&itemcd=' + SelectItemcd;
	url = url + '&suffix=' + SelectSuffix;

	location.href(url);

}
//�N���A
function clearCUSelectItems() {
	var i;								// �C���f�b�N�X

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			document.entryForm.CUSelectItems[i].checked = false
		}
	} else {
		document.entryForm.CUSelectItems.checked = false
	}
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
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
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="setno"     VALUE="<%= lngSetNo %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�b�t�o�N�ω��`�\���������ڑI��</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<!-- �������ڃZ�b�g�\�� -->
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD>
				<TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(1)">�̊i</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(2)">����</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(3)">�x�@�\</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(4)">���t</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(5)">�����</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(6)">�������</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(7)">�b��B</A></TD>
					</TR>
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(8)">�A�_</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(9)">�̋@�\</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(10)">�t�@�\</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(11)">�d����</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(12)">����</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(13)">�O���B</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(14)">�����x</A></TD>
					</TR>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####%>
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(18)">�������b�ʐ�</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(19)">�S�s�S�X�N���[�j���O</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(16)">�򓮖������g</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(17)">�����d��</A></TD>
					</TR>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####%>
				</TABLE>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD HEIGHT="25"></TD>
		</TR>
		<!-- �������ڈꗗ�\�� -->
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
	strHtml = ""
	For i=0 To lngCount-1
		'�P���
		If ((i+1) Mod 4) = 1 Then
			strHtml = "					<TR>"
		End If

		strHtml = strHtml & vbLf & "						<TD NOWRAP WIDTH=""170"">"
		strChk = ""
		For j=0 To lngSelCnt
			If strArrItemCd(i) & "-" & strArrSuffix(i) = strArrSelItem(j) Then
				strChk = " CHECKED"
				Exit For
			End If
		Next
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""checkbox"" NAME=""CUSelectItems""" & strChk & ">" & strArrItemName(i)
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""hidden"" NAME=""itemcd"" VALUE=""" & strArrItemCd(i) & """>"
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & strArrSuffix(i) & """>"
		strHtml = strHtml & vbLf & "						</TD>"

		'�S���
		If ((i+1) Mod 4) = 0 Then
			strHtml = strHtml & vbLf & "					</TR>" & vbLf
%>
					<%=strHtml%>
<%
			strHtml = ""
		End If
	Next
	If strHtml <> "" Then
		strHtml = strHtml & vbLf & "					</TR>"
%>
					<%=strHtml%>
<%
	End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP VALIGN="top">
				<TABLE WIDTH="64" BORDER="0" CELLSPACING="3" CELLPADDING="3">
					<TR>
						<TD NOWRAP ALIGN="center" BGCOLOR="#eeeeee"><A HREF="JavaScript:callCUMainGraph()">�I���I��</A></TD>
					</TR>
					<TR>
						<TD NOWRAP ALIGN="center" BGCOLOR="#eeeeee"><A HREF="JavaScript:clearCUSelectItems()">�N���A</A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>

<%
'�Z�b�g�I�����
Sub SelectSetInfo(SetNo)

	Select Case SetNo
	Case 1	'�̊i
		strArrSelItem = Array( "10041-00", _
							   "10024-00", _
							   "10033-00" _
							)

	Case 2	'����
		strArrSelItem = Array( "13120-01", _
							   "13120-02" _
							)

	Case 3	'�x�@�\
		strArrSelItem = Array( "13022-00", _
							   "13024-00" _
							)

	Case 4	'���t
		strArrSelItem = Array( "15020-00", _
							   "15021-00", _
							   "15022-00", _
							   "15023-00", _
							   "15027-00" _
							)

	Case 5	'�����
		strArrSelItem = Array( "17520-00", _
							   "17522-00" _
							)

	Case 6	'�������
		strArrSelItem = Array( "17421-00", _
							   "17422-00", _
							   "17423-00", _
							   "17420-00" _
							)

	Case 7	'�b��B
		strArrSelItem = Array( "18425-00", _
							   "18426-00" _
							)

	Case 8	'�A�_
		strArrSelItem = Array( "17320-00" _
							)

	Case 9	'�̋@�\
		strArrSelItem = Array( "17025-00", _
							   "17027-00", _
							   "17028-00", _
							   "17029-00", _
							   "17031-00", _
							   "17030-00", _
							   "17020-00", _
							   "17021-00", _
							   "17022-00" _
							)

	Case 10	'�t�@�\
		strArrSelItem = Array( "17220-00", _
							   "17221-00" _
							)

	Case 11	'�d����
		strArrSelItem = Array( "17820-00", _
							   "17821-00", _
							   "17822-00", _
							   "17823-00", _
							   "17824-00" _
							)

	Case 12	'����
		strArrSelItem = Array( "16124-00", _
							   "16325-00" _
							)

	Case 13	'�O���B
		strArrSelItem = Array( "16324-00" _
							)

	Case 14	'�����x
		strArrSelItem = Array( "26611-00", _
							   "26614-00", _
							   "26615-00" _
							)

'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
	Case 16	'�򓮖������g
		strArrSelItem = Array( "22520-00", "22521-00", "22522-00", _
					"22528-00", "22529-00", "22530-00", _
					"22536-00", "22537-00", "22538-00", _
					"22539-00", "22545-00", "22546-00", _
					"22547-00", "22620-00", "22621-00", _
					"22622-00", "22628-00", "22629-00", _
					"22630-00", "22636-00", "22637-00", _
					"22638-00", "22639-00", "22645-00", _
					"22646-00", "22647-00" _
							)

	Case 17	'�����d��
		strArrSelItem = Array( "22710-01", "22710-02", "22720-01", _
					"22720-02", "22730-01", "22730-02", _
					"22731-01", "22731-02", "22740-01", _
					"22740-02", "22741-01", "22741-02" _
							)

	Case 18	'�������b�ʐ�
		strArrSelItem = Array( "24910-00", _
							   "24911-00", _
							   "24912-00", _
							   "24913-00", _
							   "24914-00", _
							   "24915-00" _
							)

	Case 19	'�S�s�S�X�N���[�j���O
		strArrSelItem = Array( "43470-00" _
							)

'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####

	Case Else
		strArrSelItem = Array( )

	End Select

	'�I���ςݐ�
	lngSelCnt = Ubound(strArrSelItem)

End Sub
%>
