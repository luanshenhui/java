<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���o�Ǐ���͉��  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJikakushoujyou.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_JIKAKUSYOUJYOU = "X025"	'���o�Ǐ�O���[�v�R�[�h


'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objResult			'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g

'�p�����[�^
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strGrpNo			'�O���[�vNo
Dim strCsCd				'�R�[�X�R�[�h

'�������ʏ��
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
Dim vntRslValue			'��������
Dim vntUnit				'�P��
Dim vntItemQName		'��f����
Dim vntGrpSeq			'�\������
Dim vntRslFlg			'�������ʑ��݃t���O
Dim lngRslCnt			'�������ʐ�

'�������ʍX�V���
Dim vntUpdItemCd		'�������ڃR�[�h
Dim vntUpdSuffix		'�T�t�B�b�N�X
Dim vntUpdResult		'��������
Dim strArrMessage		'�G���[���b�Z�[�W

Dim strUpdUser			'�X�V��
Dim strIPAddress		'IP�A�h���X

Dim lngIndex			'�C���f�b�N�X
Dim Ret					'���A�l
Dim strHTML				'HTML������
Dim i, j				'�J�E���^�[

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

'�������ʍX�V���
vntUpdItemCd		= ConvIStringToArray(Request("ItemCd"))
vntUpdSuffix		= ConvIStringToArray(Request("Suffix"))
vntUpdResult		= ConvIStringToArray(Request("ChgRsl"))

Do
	'�ۑ�
	If strAction = "save" Then
		If Not IsEmpty(vntUpdItemCd) Then
			'�X�V�҂̐ݒ�
			strUpdUser = Session("USERID")
			'IP�A�h���X�̎擾
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'�������ʍX�V
			Ret = objResult.UpdateResultNoCmt( lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, strArrMessage )

			'�I�u�W�F�N�g�̃C���X�^���X�폜
			Set objResult = Nothing

			If Ret Then
				'�ۑ�����
				strAction = "saveend"

				'�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
				strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
				strHtml = strHtml & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
				strHtml = strHtml & "</BODY>"
				strHtml = strHtml & "</HTML>"
				Response.Write strHtml
				Response.End
				Exit Do
			End If
		End If
	End If

	'�w��Ώێ�f�҂̌������ʂ��擾����
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_JIKAKUSYOUJYOU, _
						0, _
						"", _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						vntRslValue, _
						, , , , , _
						vntUnit, _
						, , , , , _
						vntItemQName, _
						vntGrpSeq, _
						vntRslFlg _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'OCR���͉�ʂƕ\�����������ʂƂ��邽��
	For i = 0 To lngRslCnt-1
		vntResult(i) = vntRslValue(i)
	Next

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objInterView = Nothing
Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���o�Ǐ󃁃��e�i���X</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//�ۑ�
function saveJikakushoujyou() {
	var myForm	= document.entryForm;
	var count;
	var buff	= new Array();
	var i, j;

	if ( myForm.ChgRsl == null ) return;

	// ���̓`�F�b�N
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		count = 0;
		for( j=0; j < 4; j++ ) {
			if( myForm.ChgRsl[i*4+j].value != "" ) {
				count ++;
			}
		}
		if( count != 0 && count != 4 ) {
			alert( "���͂���Ă��Ȃ����ڂ�����܂��B" );
			return;
		}
	}

	// �O�l��
	count = 0;
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		if( myForm.ChgRsl[i*4+0].value != "" ) {
			for( j=0; j < 4; j++ ) {
				buff[count*4+j] =  myForm.ChgRsl[i*4+j].value;
			}
			count ++;
		}
	}
	for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
		if( i < count ) {
			for( j=0; j < 4; j++ ) {
				myForm.ChgRsl[i*4+j].value = buff[i*4+j];
			}
		} else {
			for( j=0; j < 4; j++ ) {
				myForm.ChgRsl[i*4+j].value = "";
			}
		}
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">�����o�Ǐ󃁃��e�i���X</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strAction = "saveend" Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>

<%
	If lngRslCnt = JIKAKUSHOUJYOU_COUNT*4 Then
		'���o�Ǐ�̕\��
		Call EditJikakushoujyou( 0 )
	End If
%>
	<BR>
	    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="JavaScript:saveJikakushoujyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" BORDER="0"></A>
        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
	<BR>
<%
	'�ۑ��p
	strHtml = ""
	For i=0 To lngRslCnt-1
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntResult(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntResult(i) & """>"
	Next
	Response.Write(strHtml)
%>
</FORM>
</BODY>
</HTML>
