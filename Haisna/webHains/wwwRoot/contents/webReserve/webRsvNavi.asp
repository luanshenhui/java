<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   web�\����o�^(�i�r�o�[) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-107
'�C����  �F2010.08.06�i�C���j
'�S����  �FTCS)����
'�C�����e�Fweb�\����L�����Z���̎捞���\�Ƃ���B
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p
Dim objWebRsv		'web�\����A�N�Z�X�p

'�����l
Dim dtmCslDate		'��f�N����
Dim lngWebNo		'webNo.
Dim dtmStrCslDate	'�J�n��f�N����
Dim dtmEndCslDate	'�I����f�N����
Dim strKey			'�����L�[
Dim dtmStrOpDate	'�J�n�����N����
Dim dtmEndOpDate	'�I�������N����
Dim lngOpMode		'�������[�h(1:�\�����Ō����A2:�\�񏈗����Ō���)
Dim lngRegFlg		'�{�o�^�t���O(0:�w��Ȃ��A1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim lngOrder		'�o�͏�(1:��f�����A2:�lID��)
Dim strRegFlg		'�{�o�^�t���O(1:���o�^�ҁA2:�ҏW�ςݎ�f��)
'#### 2010.10.28 SL-UI-Y0101-107 ADD START ####'
Dim lngMosFlg		'�\���敪(0:�w��Ȃ��A1:�V�K�A2:�L�����Z��)
'#### 2010.10.28 SL-UI-Y0101-107 ADD END ####'

Dim strCancelFlg	'�L�����Z���t���O
Dim strPerId		'�lID
Dim strRsvNo		'�\��ԍ�

Dim strNextCslDate	'��web�\����̎�f�N����
Dim strNextWebNo	'��web�\�����webNo.
Dim strTips			'Tips�̓��e
Dim strFunc			'�֐��̓��e
Dim Ret				'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate    = CDate(Request("cslDate"))
lngWebNo      = CLng("0" & Request("webNo"))
dtmStrCslDate = CDate(Request("strCslDate"))
dtmEndCslDate = CDate(Request("endCslDate"))
strKey        = Request("key")
dtmStrOpDate  = CDate("0" & Request("strOpDate"))
dtmEndOpDate  = CDate("0" & Request("endOpDate"))
lngOpMode     = CLng("0" & Request("opMode"))
lngRegFlg     = CLng("0" & Request("regFlg"))
lngOrder      = CLng("0" & Request("order"))
strRegFlg     = Request("rsvRegFlg")
'#### 2010.10.28 SL-UI-Y0101-107 ADD START ####'
'�\���敪�̓��͂��Ȃ����1:�V�K���f�t�H���g��
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-107 ADD END ####'
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�i�r�Q�[�V�����o�[</TITLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �R�����g��ʌĂяo��
function callCommentWindow() {

	var detailForm = top.detail.document.paramForm;
	var optForm = top.opt.document.entryForm;

	// ���T�u��ʂ����
	top.closeWindow( 1 );

	// �����̐ݒ�
	var orgCd1 = ( detailForm.orgCd1.value != '' ) ? detailForm.orgCd1.value : null;
	var orgCd2 = ( detailForm.orgCd2.value != '' ) ? detailForm.orgCd2.value : null;

	var ctrPtCd;
	if ( optForm ) {
		if ( optForm.ctrPtCd ) {
			ctrPtCd = ( optForm.ctrPtCd.value != '' ) ? optForm.ctrPtCd.value : null;
		}
	}
<%
	'�ҏW�ςݎ�f�҂̏ꍇ
	If strRegFlg = REGFLG_REGIST Then

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

		'web�\�����ǂ݁A�\��ԍ����擾
		'#### 2011/01/20 MOD STA TCS)Y.T ####
		''#### 2010.08.06 SL-UI-Y0101-107 MOD START ####
		''��CanDate�̑Ή��ŁARsvNo�̑O�ɃJ���}�P�ǉ�
		''objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , , strRsvNo
		'objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strRsvNo
		''#### 2010.08.06 SL-UI-Y0101-107 MOD END ####
		objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , ,  strRsvNo
		'#### 2011/01/20 MOD STA TCS)Y.T ####

		'�I�u�W�F�N�g�̉��
		Set objWebRsv = Nothing

		'�\��ԍ����擾�ł����Ȃ��
		If strRsvNo <> "" Then

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set objConsult = Server.CreateObject("HainsConsult.Consult")

			'web�\�����ǂ݁A��f����̌lID�A�y�уL�����Z���t���O���擾
			objConsult.SelectConsult strRsvNo, strCancelFlg, , strPerId

			'�I�u�W�F�N�g�̉��
			Set objConsult = Nothing

		End If

	End If
%>
	// �R�����g��ʌĂяo��
	noteGuide_showGuideNote( '1', '1,1,1,1', '<%= strPerId %>', '<%= strRsvNo %>', orgCd1, orgCd2, ctrPtCd );

}

// ����
function showNext() {
	top.showNext();
}

// �m�菈��
function regist( next ) {
	top.regist( ( next > 0 ) );
}

// ��ʂ����
function closeWindow() {
	top.close();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:noteGuide_closeGuideNote()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">web�\����o�^</FONT></B></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="464">
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2" WIDTH="100%">
				<TR>
<%
					'�m��{�^���͕ҏW�ςݎ�f�҂łȂ��ꍇ�ɕ\������
					If strRegFlg <> REGFLG_REGIST Then
%>
						<TD><A HREF="javascript:regist(0)"><IMG SRC="/webhains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���݂̓��e�ŗ\�����o�^���܂�"></A></TD>
<%
					End If

					'�I�u�W�F�N�g�̃C���X�^���X�쐬
					Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

					'web�\�����ǂ݁A���L�[�����߂�
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
					'Ret = objWebRsv.SelectWebRsvNext( _
					'		  dtmStrCslDate,          _
					'		  dtmEndCslDate,          _
					'		  strKey,                 _
					'		  dtmStrOpDate,           _
					'		  dtmEndOpDate,           _
					'		  lngOpMode,              _
					'		  lngRegFlg,              _
					'		  lngOrder,               _
					'		  dtmCslDate,             _
					'		  lngWebNo,               _
					'		  strNextCslDate,         _
					'		  strNextWebNo            _
					'	  )
					Ret = objWebRsv.SelectWebRsvNext( _
							  dtmStrCslDate,          _
							  dtmEndCslDate,          _
							  strKey,                 _
							  dtmStrOpDate,           _
							  dtmEndOpDate,           _
							  lngOpMode,              _
							  lngRegFlg,              _
							  lngMosFlg,              _
							  lngOrder,               _
							  dtmCslDate,             _
							  lngWebNo,               _
							  strNextCslDate,         _
							  strNextWebNo            _
						  )
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

					'�I�u�W�F�N�g�̉��
					Set objWebRsv = Nothing

					'���R�[�h���ݎ��́u���ցv�{�^����\��
					If Ret = True Then

						'Tips�̕ҏW
						If strRegFlg <> REGFLG_REGIST Then
							strTips = "���݂̓��e�ŗ\�����o�^���A����web�\�����\�����܂�"
						Else
							strTips = "����web�\�����\�����܂�"
						End If

						'�֐��̕ҏW
						If strRegFlg <> REGFLG_REGIST Then
							strFunc = "regist(1)"
						Else
							strFunc = "showNext()"
						End If
%>
						<TD><A HREF="javascript:<%= strFunc %>"><IMG SRC="/webhains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="<%= strTips %>"></A></TD>
<%
					End If

					'�R�����g�{�^���͖��ҏW�A�܂��͕ҏW�ς݂Ŕ�L�����Z���҂̏ꍇ�ɕ\��
					If strCancelFlg = "" Or CStr(strCancelFlg) = CStr(CONSULT_USED) Then
%>
						<TD><A HREF="javascript:callCommentWindow()"><IMG SRC="/webhains/images/comment.gif" WIDTH="77" HEIGHT="24" ALT="�R�����g��\�����܂�"></A></TD>
<%
					End If
%>
					<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:closeWindow()"><IMG SRC="/webhains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
				</TR>
			</TABLE>
		</TD>
<%
		'�ҏW�ςݎ�f�҂̏ꍇ�̓��b�Z�[�W��\������
		If strRegFlg = REGFLG_REGIST Then
%>
			<TD ALIGN="right"><B><FONT COLOR="#ff6600">�ҏW�ςݎ�f��</FONT></B></TD>
<%
		Else
%>
			<TD></TD>
<%
		End If
%>
	</TR>
</TABLE>
</BODY>
</HTML>
