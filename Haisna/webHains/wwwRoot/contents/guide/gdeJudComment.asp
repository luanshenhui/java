<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����R�����g�̑I�� (Ver0.0.1)
'		AUTHER  : Keiko Fujii@ffcs
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'�J�n�ʒu�̃f�t�H���g�l

Dim strCmtDspMode		'�����\�����[�h�i0:�ꗗ�\�������A1:�ꗗ�\������j

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objJudCmtStc		'����R�����g���A�N�Z�X�p
Dim objJudClass			'���蕪�ޏ��A�N�Z�X�p
Dim objCommon			'���ʊ֐��A�N�Z�X�p

Dim lngCmtCnt			'�R�����g����
Dim vntCmtCd			'�I������Ă���R�����g�R�[�h�Q
Dim vntArrCmtCd			'�I������Ă���R�����g�R�[�h�z��

Dim strJudClassCd		'�������蕪�ރR�[�h
Dim strJudClassName		'�������蕪�ޖ���
Dim strKey				'�����L�[
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������
Dim vntSearchModeFlg	'���������t���O�i0:���蕪�ނ̖����R�����g���擾�A1:���蕪�ނ���v������̂̂݁j

'����R�����g���
Dim strArrJudCmtCd		'����R�����g�R�[�h
Dim strArrJudCmtStc		'����R�����g����
Dim strArrJudClassCd	'���蕪�ރR�[�h
Dim strArrJudClassName	'���蕪�ޖ���
Dim strArrJudCd			'����R�[�h
Dim strArrWeight		'����d��

Dim strDispJudCmtStc	'�ҏW�p�̔���R�����g����
Dim strDispJudCmtCd		'�ҏW�p�̔���R�����g�R�[�h

Dim strCheckJudCmt		'�`�F�b�N�{�b�N�X

Dim strAction			'
Dim strArrKey			'(�������)�����L�[�̏W��
Dim lngAllCount			'�����𖞂����S���R�[�h����
Dim lngCount			'���R�[�h����
Dim strURL				'URL������
Dim i, j				'�C���f�b�N�X

Dim strChecked				'�`�F�b�N�{�b�N�X�̃`�F�b�N���
Dim strBgColor				'�w�i�F
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")
Set objJudClass  = Server.CreateObject("HainsJudClass.JudClass")
Set objCommon    = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strAction     = Request("act")
strJudClassCd = Request("judClassCd")
strCmtDspMode = Request("cmtdspmode")
vntCmtCd      = Request("selCmtCd")
lngCmtcnt     = Request("selCmtCnt")
strKey        = Request("key")
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")

'�R�����g�R�[�h��z���
vntArrCmtCd = Array()
vntArrCmtCd = Split(vntCmtCd, "," )

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))


'���蕪�ޖ��擾
If Not IsEmpty(strJudClassCd) Then
	Call objJudClass.SelectJudClass(strJudClassCd, strJudClassName)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>����R�����g�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ����R�����g�R�[�h�E����R�����g���͂̃Z�b�g
function selectList( ) {

	var icnt;			//���[�v�J�E���g
	var jcnt;			//���[�v�J�E���g
	var kcnt;			//���[�v�J�E���g
	var judCmtCd_length;

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A����R�����g�R�[�h�E����R�����g���͂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	jcnt = 0;
	opener.varSelCmtCd.length = 0;
	opener.varSelCmtStc.length = 0;
	opener.varSelClassCd.length = 0;
	opener.varSelJudCd.length = 0;
	opener.varSelWeight.length = 0;
	judCmtCd_length = document.kensakulist.judCmtCd.length;
	if ( judCmtCd_length == null ){
		judCmtCd_length = 1;
	}
	for ( icnt = 0; icnt < judCmtCd_length; icnt++ ){
		//���ɓo�^�ς̃R�����g�H
		for( kcnt = 0; kcnt < document.entryForm.selCmtCnt.value; kcnt++ ){
			if ( document.kensakulist.judCmtCd.length != null ) {
				if ( document.entryForm.selCmtCnt.value == 1 ){
					if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd.value ){
						break;
					}
				} else {
					if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd[kcnt].value ){
						break;
					}
				}
			} else {
				if ( document.entryForm.selCmtCnt.value == 1 ){
					if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd.value ){
						break;
					}
				} else {
					if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd[kcnt].value ){
						break;
					}
				}
			}
		}
		if (kcnt < document.entryForm.selCmtCnt.value){
			continue;
		}
		if ( document.kensakulist.judCmtCd.length != null ) {
			if ( document.kensakulist.judCmtCd[icnt].checked ) {
				opener.varSelCmtCd.length ++;
				opener.varSelCmtStc.length ++;
		    	opener.varSelClassCd.length ++;
		    	opener.varSelJudCd.length ++;
		    	opener.varSelWeight.length ++;
		    	opener.varSelCmtCd[jcnt] = document.kensakulist.judCmtCd[icnt].value;
		    	opener.varSelCmtStc[jcnt] = document.kensakulist.judCmtStc[icnt].value;
		    	opener.varSelClassCd[jcnt] = document.kensakulist.judClassCd[icnt].value;
		    	opener.varSelJudCd[jcnt] = document.kensakulist.judCd[icnt].value;
		    	opener.varSelWeight[jcnt] = document.kensakulist.weight[icnt].value;
		    	jcnt++;
			}
		} else {
			if ( document.kensakulist.judCmtCd.checked ) {
				opener.varSelCmtCd.length ++;
				opener.varSelCmtStc.length ++;
		    	opener.varSelClassCd.length ++;
		    	opener.varSelJudCd.length ++;
		    	opener.varSelWeight.length ++;
		    	opener.varSelCmtCd[jcnt] = document.kensakulist.judCmtCd.value;
		    	opener.varSelCmtStc[jcnt] = document.kensakulist.judCmtStc.value;
		    	opener.varSelClassCd[jcnt] = document.kensakulist.judClassCd.value;
		    	opener.varSelJudCd[jcnt] = document.kensakulist.judCd.value;
		    	opener.varSelWeight[jcnt] = document.kensakulist.weight.value;
		    	jcnt++;
			}
		}
	}


	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.jcmGuide_CalledFunction != null ) {
		opener.jcmGuide_CalledFunction();
	}

	opener.winJudComment = null;
	close();

	return;
}

//�`�F�b�N�{�b�N�X�I������
//���ɓo�^�ς̃R�����g�̃`�F�b�N�͂͂����Ȃ�
function checkJudCmtAct( index ) {
	var icnt;			//���[�v�J�E���g
	var jcnt;			//���[�v�J�E���g

	//���ɓo�^�ς̃R�����g�H
	if( document.entryForm.selCmtCnt.value == 1 ) {
		if ( document.kensakulist.judCmtCd.length != null ) {
			if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd.value ){
				document.kensakulist.judCmtCd[index].checked = " CHECKED";
			}
		} else {
			if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd.value ){
				document.kensakulist.judCmtCd.checked = " CHECKED";
			}
		}
	} else {
		for( icnt = 0; icnt < document.entryForm.selCmtCnt.value; icnt++ ){
			if ( document.kensakulist.judCmtCd.length != null ) {
				if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd[icnt].value ){
					document.kensakulist.judCmtCd[index].checked = " CHECKED";
					break;
				}
			} else {
				if ( document.kensakulist.judCmtCd.value == document.entryForm.selArrCmtCd[icnt].value ){
					document.kensakulist.judCmtCd.checked = " CHECKED";
					break;
				}
			}
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<INPUT TYPE="hidden" NAME="act" VALUE="select">
	<INPUT TYPE="hidden" NAME="cmtdspmode" VALUE="<%= strCmtDspMode %>">
	<INPUT TYPE="hidden" NAME="selCmtCd" VALUE="<%= vntCmtCd %>">
	<INPUT TYPE="hidden" NAME="selCmtCnt" VALUE="<%= lngCmtCnt %>">
<%
	For i = 0 To lngCmtCnt-1
%>
		<INPUT TYPE="hidden" NAME="selArrCmtCd" VALUE="<%= vntArrCmtCd(i) %>">
<%
	Next		
%>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">����R�����g�̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Do
		If strCmtDspMode = 0 Then
			Exit Do
		End If

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'' ����������ǉ����� 2003.12.18 modify start 
		'���ׂĂ̕���
		If strJudClassCd = "" Then
			vntSearchModeFlg = 0
		Else
			vntSearchModeFlg = 1
		End If

		'���������𖞂������R�[�h�������擾
'		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)
		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, vntSearchModeFlg)


		'���������𖞂��S�������̃��R�[�h���擾
		lngGetCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)
'		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName, , , , strArrJudCd, strArrWeight)
		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName, , , vntSearchModeFlg, strArrJudCd, strArrWeight)
		'' ����������ǉ����� 2003.12.18 modify end  

		strCheckJudCmt = Array()
		Redim Preserve strCheckJudCmt(lngCount-1)
%>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR><TD COLSPAN="2">������������͂��ĉ������B</TD></TR>
		<TR><TD HEIGHT="5"></TD></TR>
		<TR>
			<TD><%= EditJudClassList("judClassCd", strJudClassCd, "�S�Ă̔��蕪��") %></TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.cmtdspmode.value=1;document.entryForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
<%
		'�f�[�^�������ꍇ�͊m��{�^���͕\�����Ȃ�
		If lngCount <= 0 Then
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="77" HEIGHT="24" ></TD>
<%
		Else
%>
			<TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
                <A HREF="javascript:selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�m�肵�܂�"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>
<%
		End If
%>
		</TR>
	</TABLE>

</FORM>

<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂�������R�����g���͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1

			'�\���p����R�����g���͂̕ҏW
			strDispJudCmtStc = strArrJudCmtStc(i)
			strDispJudCmtCd  = strArrJudCmtCd(i)

			If strKey <> "" Then

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				For j = 0 To UBound(strArrKey)
					strDispJudCmtStc = Replace(strDispJudCmtStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispJudCmtCd  = Replace(strDispJudCmtCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'���ɑI���ς��`�F�b�N
			strChecked = ""
			strBgColor = ""
			For j = 0 to lngCmtCnt-1
				If strArrJudCmtCd(i) = vntArrCmtCd(j) Then
					strChecked = " CHECKED"
					strBgColor="#eeeeee" 
					Exit For
				End If
			Next
%>
			<TR VALIGN="top">
				<TD>
					<INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
					<INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strArrJudClassCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCd" VALUE="<%= strArrJudCd(i) %>">
					<INPUT TYPE="hidden" NAME="weight" VALUE="<%= strArrWeight(i) %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
				</TD>
				<TD><INPUT TYPE="checkbox" NAME="judCmtCd" VALUE="<%= strArrJudCmtCd(i) %>" <%= strChecked %> ONCLICK="javascript:checkJudCmtAct( <%= i %> )" BORDER="0"></TD>
				<TD BGCOLOR="<%= strBgColor %>"><%= strDispJudCmtStc %></TD>
				<TD NOWRAP>
				</TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
