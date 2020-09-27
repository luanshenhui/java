<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		������� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ACTMODE_PREVIOUS = "previous"	'���샂�[�h(�O��f�҂�)
Const ACTMODE_NEXT     = "next"		'���샂�[�h(����f�҂�)
Const ACTMODE_SAVEEND  = "saveend"	'���샂�[�h(�ۑ�����)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode		'���샂�[�h
Dim lngCslYear		'��f��(�N)
Dim lngCslMonth		'��f��(��)
Dim lngCslDay		'��f��(��)
Dim strCntlNo		'�Ǘ��ԍ�
Dim lngDayId		'����ID
Dim strCsCd			'�R�[�X�R�[�h
Dim strSortKey		'�\����
Dim strBadJud		'�u����̈����l�v
Dim strUnFinished	'�u���薢�����ҁv
Dim strNoPrevNext	'�O���f�҂ւ̑J�ڂ��s��Ȃ�

'�O���f�ґJ�ڎ��̂ݑ��M�����p�����[�^�l
Dim strRsvNo		'�\��ԍ�

Dim dtmCslDate		'��f��
Dim strPrevRsvNo	'(�O��f�҂�)�\��ԍ�
Dim strPrevDayId	'(�O��f�҂�)����ID
Dim strNextRsvNo	'(����f�҂�)�\��ԍ�
Dim strNextDayId	'(����f�҂�)����ID
Dim strURL			'�W�����v���URL

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strActMode    = Request("actMode")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCntlNo     = Request("cntlNo")
lngDayId      = CLng("0" & Request("dayId"))
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strBadJud     = Request("badJud")
strUnFinished = Request("unFinished")
strNoPrevNext = Request("noPrevNext")

'�O���f�ґJ�ڎ��̂ݑ��M�����p�����[�^�l�̎擾
strRsvNo      = Request("rsvNo")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Select Case strActMode

	'�O��f�ҁE����f�҂�
	Case ACTMODE_PREVIOUS, ACTMODE_NEXT

		'��f���̎擾
		dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

		'�O���f�҂̗\��ԍ��E����ID�擾
		objConsult.SelectCurRsvNoPrevNext dtmCslDate,            _
										  strCsCd,               _
										  strSortKey,            _
										  strCntlNo,             _
										  False,                 _
										  (strBadJud     <> ""), _
										  (strUnFinished <> ""), _
										  strRsvNo,              _
										  strPrevRsvNo,          _
										  strPrevDayId,          _
										  strNextRsvNo,          _
										  strNextDayId

		'�O��f�҂̎�f��񂪑��݂��Ȃ��ꍇ
		If strActMode = ACTMODE_PREVIOUS And strPrevRsvNo = "" Then
			Err.Raise 1000, , "�O��f�҂̎�f���͑��݂��܂���B"
		End If

		'����f�҂̎�f��񂪑��݂��Ȃ��ꍇ
		If strActMode = ACTMODE_NEXT And strNextRsvNo = "" Then
			Err.Raise 1000, , "����f�҂̎�f���͑��݂��܂���B"
		End If

		'���ݎ��̓��_�C���N�g�p��URL��ҏW����

		'������͉�ʂ�URL�ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & IIf(strActMode = ACTMODE_PREVIOUS, strPrevDayId, strNextDayId)
		strURL = strURL & "&csCd="       & strCsCd
		strURL = strURL & "&sortKey="    & strSortKey
		strURL = strURL & "&badJud="     & strBadJud
		strURL = strURL & "&unFinished=" & strUnFinished
		strURL = strURL & "&noPrevNext=" & strNoPrevNext

		'�O���f�҂̔�����͉�ʂ�
		Response.Redirect strURL
		Response.End

End Select
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������</TITLE>
</HEAD>

<FRAMESET ROWS="55,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="YES">
	<FRAME SRC="/webHains/contents/judgement/judNavibar.asp" name="header">
	<FRAMESET COLS="*,355" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'������͉�ʂ�URL�ҏW
		strURL = "judDetail.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & lngDayId
		strURL = strURL & "&csCd="       & strCsCd
		strURL = strURL & "&sortKey="    & strSortKey
		strURL = strURL & "&badJud="     & strBadJud
		strURL = strURL & "&unFinished=" & strUnFinished
		strURL = strURL & "&noPrevNext=" & strNoPrevNext
%>
		<FRAME SRC="<%= strURL %>" name="judge">
		<FRAME SRC="/webHains/contents/common/blank.htm" name="resultinfo">
	</FRAMESET>
</FRAMESET>

</HTML>
