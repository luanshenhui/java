<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����K���i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f�N���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strAct				'�������
Dim lngRsvNo			'�\��ԍ��i���񕪁j

'��f���p�ϐ�
Dim strPerId			'�lID
Dim lngAge				'�N��
Dim lngGender			'����

Dim Ret					'���A�l

'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
Dim strCslDate			'��f��

Dim objFree             'OCR���͌��ʃA�N�Z�X�p
Const CHECK_CSLDATE2     = "2010/01/01"    '�ėp�}�X�^�̐ݒ肪�Ȃ��ꍇ�p
Const FREECLASSCD_CHG  = "CHG"           '2011�N�Ή��@�ύX���t�擾�p

dim vntArrFree1
Dim strChgDate          '2011�N�Ή��@�ύX���t
'#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult 		= Server.CreateObject("HainsConsult.Consult")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")

'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
Set objFree         = Server.CreateObject("HainsFree.Free")

'�ėp�}�X�^���؂�ւ����擾
if objFree.SelectFreeByClassCd( 0,FREECLASSCD_CHG, , , , vntArrFree1 )  > 0 then
    strChgDate = vntArrFree1(0)
End if
If strChgDate = "" Then
    strChgDate = CHECK_CSLDATE2
End If
 '#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

Do	

	'��f��񌟍��i�\��ԍ����l���擾�j
'#### 2010.08.19 SL-UI-Y0101-104 MOD START ####�@��f���擾�ǉ�'
'	Ret = objConsult.SelectConsult(lngRsvNo, _
'									, , _
'									strPerId, _
'									, , , , , , , _
'									lngAge, _
'									, , , , , , , , , , , , , , , _
'									0, , , , , , , , , , , , , , , _
'									, , , , , _
'									lngGender _
'									)
'
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, strCslDate, _
									strPerId, _
									, , , , , , , _
									lngAge, _
									, , , , , , , , , , , , , , , _
									0, , , , , , , , , , , , , , , _
									, , , , , _
									lngGender _
									)
'#### 2010.08.19 SL-UI-Y0101-104 MOD END ####'

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult = Nothing

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
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
<TITLE>�����K��</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
var winIkensaTain;				// �E�B���h�E�n���h��
//�݌����E���@�ł̎w�E�E�C���h�E�Ăяo��
function showIkensaTain() {

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩


	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winIkensaTain != null ) {
		if ( !winIkensaTain.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/interview/IkensaTain.asp?rsvno=' + <%= lngRsvNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winIkensaTain.focus();
		winIkensaTain.location.replace( url );
	} else {
		winIkensaTain = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

function windowClose() {

	// �݌����E���@�ł̎w�E�E�C���h�E�����
	if ( winIkensaTain != null ) {
		if ( !winIkensaTain.closed ) {
			winIkensaTain.close();
		}
	}

	winIkensaTain = null;

}

//'#### 2010.08.19 SL-UI-Y0101-104 MOD START ####'
//function fujinkamonshin_popUp( p_rsvNo ) {
//    var width   = screen.width/2-400;
//    var height  = screen.height/2-275;
//    var url     = 'http://157.104.16.195/contents/kensa/fujin/fujin_monzin_kekka.jsp?p_rsvno=' + p_rsvNo + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
//    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=no,width=800,height=550");
//}

function fujinkamonshin_popUp( p_rsvNo, p_perid ) {
    var width   = screen.width/2-400;
    var height  = screen.height/2-275;
    var url     = 'http://lsvwhgui/contents/kensa/fujin/fujin_monzin_kekka.jsp?p_rsvno=' + p_rsvNo + '&p_perid=' + p_perid + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=yes,width=820,height=600");
}
//'#### 2010.08.19 SL-UI-Y0101-104 MOD END ####'

//'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
function fujinkamonshin_popUp2( p_rsvNo, p_perid ) {
    var width   = screen.width/2-400;
    var height  = screen.height/2-275;

    var url     = 'http://lsvwhgui/contents/kensa/fujin/fujin_monzin_kekka_2.jsp?p_rsvno=' + p_rsvNo + '&p_perid=' + p_perid + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=yes,width=1000,height=650");
}
//'#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�����K��</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
'			'�O����R���{�{�b�N�X�\��
'			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="5" WIDTH="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP ALIGN="left"><A HREF="javascript:showIkensaTain()">�݌����E���@�ł̎w�E</A></TD>
			<TD NOWRAP ALIGN="left"><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="24" WIDTH="50"></TD>
			<TD NOWRAP ALIGN="left" WIDTH="100%"><A HREF="/webHains/contents/monshin/ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>&anchor=2" TARGET="_blank">�n�b�q���͌��ʊm�F</A></TD>
<%
	'�����̂Ƃ�
	If lngGender = "2" Then
%>
<!--			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="/webHains/contents/?rsvno=<%= lngRsvNo %>" TARGET="_blank">�w�l�Ȗ�f�ڍ�</A></TD>-->
<% '#### 2010.08.19 SL-UI-Y0101-104 MOD START ####' %>
<!--			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp(<%= lngRsvNo %>)">�w�l�Ȗ�f�ڍ�</A></TD>-->
		<%  If CDate(strCslDate) >= CDate(strChgDate)  Then %>
			<!--�؂�ւ�����̏ꍇ -->
			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp2(<%= lngRsvNo %>, <%= strPerId %>)">�w�l�Ȗ�f�ڍ�</A></TD>
		<%  Else %>
			<!--�؂�ւ����O�̏ꍇ -->
			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp(<%= lngRsvNo %>, <%= strPerId %>)">�w�l�Ȗ�f�ڍ�</A></TD>
		<%  End If %>
<% '#### 2010.08.19 SL-UI-Y0101-104 MOD END ####' %>
<%
	End If
%>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
