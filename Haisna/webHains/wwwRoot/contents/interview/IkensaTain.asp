<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �݌����A���@�ł̎w�E (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
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
Const MONSTOMACH_GRPCD = "X032"		'��f�i�݌����j�O���[�v�R�[�h
Const MONTAIN_GRPCD    = "X033"		'��f�i���@�ł̎w�E�j�O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterview		'�ʐڏ��A�N�Z�X�p
Dim objConsult			'��f���A�N�Z�X�p

Dim	strWinMode			'�E�B���h�E���[�h

Dim lngRsvNo			'�\��ԍ�

Dim strPerId			'�l�h�c

Dim	vntStomSeq			'�݌����@����ԍ�
Dim	vntStomRsvNo		'�݌����@�\��ԍ�
Dim	vntStomSuffix		'�݌����@�T�t�B�b�N�X
Dim	vntStomItemType		'�݌����@���ڃR�[�h
Dim	vntStomItemName		'�݌����@���ږ�
Dim vntStomItemCd		'�݌����@�������ڃR�[�h
Dim vntStomResult		'�݌����@�񓚓��e

Dim	lngStomCnt			'�݌����@����

Dim	vntTainSeq			'���@�ł̎w�E�@����ԍ�
Dim	vntTainRsvNo		'���@�ł̎w�E�@�\��ԍ�
Dim	vntTainSuffix		'���@�ł̎w�E�@�T�t�B�b�N�X
Dim	vntTainItemType		'���@�ł̎w�E�@���ڃR�[�h
Dim	vntTainItemName		'���@�ł̎w�E�@���ږ�
Dim vntTainItemCd		'���@�ł̎w�E�@�������ڃR�[�h
Dim vntTainResult		'���@�ł̎w�E�@�񓚓��e

Dim	lngTainCnt			'���@�ł̎w�E�@����

Dim i					'���[�v�J�E���^
Dim blnRet				'�֐����A�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾

lngRsvNo         = Request("rsvno")
strWinMode		 = Request("winmode")


Do

	'�\��ԍ�����l�h�c�擾
	blnRet = objConsult.SelectConsult ( _
									lngRsvNo, _
									 ,  , strPerId _
										)

	If blnRet = False Then
		Err.Raise 1000, , "�l�h�c���擾�ł��܂���ł����BRsvNo= " & lngRsvNo
	End If




	'��f���ʁi�݌����j����
'	lngStomCnt = objInterview.SelectPerResult( _
'					    strPerId, _
'   					vntStomItemCd, _
'    					vntStomSuffix, _
'    					vntStomItemType, _
'    					vntStomItemName, , _
'    					vntStomResult, , _
'						MONSTOMACH_GRPCD _
'						)
	lngStomCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONSTOMACH_GRPCD, _
    					0, _
    					"", _
    					0, _
    					, , _
						, , _
    					, _
    					, _
    					vntStomItemCd, _
    					vntStomSuffix, _
    					 , _
    					vntStomItemType, _
    					vntStomItemName, _
    					vntStomResult _
						)

	'��f���ʁi���@�ł̎w�E�j����
'	lngTainCnt = objInterview.SelectPerResult( _
'					    strPerId, _
'    					vntTainItemCd, _
'    					vntTainSuffix, _
'    					vntTainItemType, _
'    					vntTainItemName, , _
'    					vntTainResult, , _
'						MONTAIN_GRPCD _
'						)
'### 2004/06/28 Updated by Ishihara@FSIT ���@�ł̎w�E�́A�l�������ł͂Ȃ�������Œ��o
'	lngTainCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONTAIN_GRPCD, _
'    					0, _
'    					"", _
'    					0, _
'    					, , _
'						, , _
'    					, _
'    					, _
'    					vntTainItemCd, _
'    					vntTainSuffix, _
'    					 , _
'    					vntTainItemType, _
'    					vntTainItemName, _
'    					vntTainResult _
'						)
	lngTainCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONTAIN_GRPCD, _
    					0, _
    					"", _
    					0, _
    					, , _
						, , _
    					, _
    					, _
    					vntTainItemCd, _
    					vntTainSuffix, _
    					 , _
    					vntTainItemType, _
    					vntTainItemName, _
    					vntTainResult _
						)
'### 2004/06/28 Updated End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�݌����A���@�ł̎w�E</TITLE>
<SCRIPT TYPE="text/javascript">
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
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
<FORM NAME="entryForm" ACTION="./" METHOD="get">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="686">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�݌����A���@�ł̎w�E</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
<%
	If lngStomCnt <= 0 And lngTainCnt <= 0 Then
%>
		<FONT SIZE="+1">�\�����鍀�ڂ͂���܂���B</FONT>
<%
	Else
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="628" class="mensetsu-tb">
			<TR ALIGN="center" BGCOLOR="#cccccc">
				<th NOWRAP WIDTH="197">������e</th>
				<th NOWRAP WIDTH="599">�񓚓��e</th>
			</TR>
<%
			For i = 0 To lngStomCnt - 1
%>
				<TR BGCOLOR="#ffffff">
					<TD NOWRAP WIDTH="197"><%= vntStomItemName(i) %></TD>
					<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="599"><%= vntStomResult(i) %></TD>
				</TR>
<%
			Next
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP colspan="2" style="border-left:1px solid #fff;border-right:1px solid #fff; height:6px;"></TD>
			</TR>
<%
			For i = 0 To lngTainCnt - 1
%>
				<TR BGCOLOR="#ffffff">
					<TD NOWRAP WIDTH="197"><%= vntTainItemName(i) %></TD>
					<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="599">���@�w�E����</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
	End If
%>
</FORM>
</BODY>
</HTML>