<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g�o�^�E�C�� (Ver0.0.1)
'		AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'## 2004.03.12 Mod By T.Takagi@FSIT �������Ⴄ
'Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
'## 2004.03.12 Mod End

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------

Dim objCommon			'���ʃN���X
Dim objSchedule			'�\����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngRsvNo				'�\��ԍ�
Dim lngRecord				'���R�[�h�ԍ�

Dim strCslDate          	'��f��
Dim strCsCd		          	'�R�[�X�R�[�h
Dim lngRsvGrpCd         	'�\��Q�R�[�h
Dim strCslYear     			'��f�N�i�J�n�j
Dim strCslMonth     		'��f���i�J�n�j
Dim strCslDay     			'��f���i�J�n�j

Dim vntCslDate          	'��f��
Dim vntCsCd		          	'�R�[�X�R�[�h
Dim vntCsName           	'�R�[�X��
Dim vntWebColor           	'�R�[�X�F
Dim vntRsvGrpCd         	'�\��Q�R�[�h
Dim vntRsvGrpName         	'�\��Q����
Dim vntMngGender			'�j���ʘg�Ǘ�
Dim vntMaxCnt				'�\��\�l���i���ʁj
Dim vntMaxCnt_M	    	   	'�\��\�l���i�j�j
Dim vntMaxCnt_F	       		'�\��\�l���i���j
Dim vntOverCnt		       	'�I�[�o�\�l���i���ʁj
Dim vntOverCnt_M	       	'�I�[�o�\�l���i�j�j
Dim vntOverCnt_F	       	'�I�[�o�\�l���i���j
Dim vntRsvCnt_M	       		'�\��ςݐl���i�j�j
Dim vntRsvCnt_F		        '�\��ςݐl���i���j

Dim strCsName           	'�R�[�X��
Dim strWebColor           	'�R�[�X�F
Dim strRsvGrpName         	'�\��Q����
Dim lngMngGender			'�j���ʘg�Ǘ�
Dim lngMaxCnt				'�\��\�l���i���ʁj
Dim lngMaxCnt_M	    	   	'�\��\�l���i�j�j
Dim lngMaxCnt_F	       		'�\��\�l���i���j
Dim lngOverCnt		       	'�I�[�o�\�l���i���ʁj
Dim lngOverCnt_M	       	'�I�[�o�\�l���i�j�j
Dim lngOverCnt_F	       	'�I�[�o�\�l���i���j
Dim lngRsvCnt_M	       		'�\��ςݐl���i�j�j
Dim lngRsvCnt_F		        '�\��ςݐl���i���j

Dim lngRsvFraCnt				'�\��g��


Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim i						'�C���f�b�N�X
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

strArrMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objSchedule     = Server.CreateObject("HainsSchedule.Schedule")
Set objCourse       = Server.CreateObject("HainsCourse.Course")

'�����l�̎擾

strAction      = Request("action")
strMode        = Request("mode")
strCsCd	       = Request("cscd")
lngRsvGrpCd    = Request("rsvGrpCd")

strCslDate     = Request("cslDate")
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")

lngMaxCnt	   = Request("maxCnt")
lngMaxCnt_M	   = Request("maxCnt_M")
lngMaxCnt_F	   = Request("maxCnt_F")
lngOverCnt	   = Request("overCnt")
lngOverCnt_M   = Request("overCnt_M")
lngOverCnt_F   = Request("overCnt_F")
'lngRsvCnt_M    = Request("rsvCnt_M"	)
'lngRsvCnt_F    = Request("rsvCnt_F" )

'### 2004/02/05 Deleted by Ishihara@FSIT ��`�A�����B���������ꍇ�͂ǂ��Ȃ񂾁B
'### (Select��ŃZ�b�g���Ă��邩��s�v�j
''�{���͖������Ǝv�����ǁE�E�E
'If strCslDate <> "" Then
'	strCslYear  = CStr(Year(strCslDate))
'	strCslMonth = CStr(Month(strCslDate))
'	strCslDay   = CStr(Day(strCslDate))
'End If
'### 2004/02/05 Deleted End

'### 2004/02/05 Modifed by Ishihara@FSIT ���\����
'If strCslYear = "" Then
'	strCslYear  = CStr(Year(now))
'	strCslMonth = CStr(Month(now))
'	strCslDay   = CStr(Day(now))
'End If
If strCslYear = "" Then
	strCslYear  = CStr(Year(now))
End If
If strCslMonth = "" Then
	strCslMonth  = CStr(Month(now))
End If
If strCslDay = "" Then
	strCslDay  = CStr(Day(now))
End If
'### 2004/02/05 Modifed End

Do

	'�V�K���[�h�ł͂Ȃ��Ƃ�
	If strMode <> "insert" And strAction <> "save" Then
'			Err.Raise 1000, , "strCslDate= " & strCslDate & ",strCsCd=" & strCsCd & ", �\��Q�R�[�h=" & lngRsvGrpCd &" )"
		'���������ɏ]���\��l���Ǘ��ꗗ�𒊏o����
		lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
                    strCslDate, strCslDate, _
                    strCsCd & "", _
                    lngRsvGrpCd & "", _
                    vntCslDate, _
                    vntCsCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntRsvGrpCd, _
                    vntRsvGrpName, _
                    vntMngGender, _
                    vntMaxCnt, _
                    vntMaxCnt_M, _
                    vntMaxCnt_F, _
                    vntOverCnt, _
                    vntOverCnt_M, _
                    vntOverCnt_F, _
                    vntRsvCnt_M, _
                    vntRsvCnt_F _
                    )
'			Err.Raise 1000, , "lngRsvFraCnt= " & lngRsvFraCnt
		'�\��l����񂪎擾�ł��Ȃ��ꍇ
 		If lngRsvFraCnt < 1 Then
			Exit Do
		End If

'			Err.Raise 1000, , "vntCslDate= " & vntCslDate(0)
		strCslYear  = CStr(Year(vntCslDate(0)))
		strCslMonth = CStr(Month(vntCslDate(0)))
		strCslDay   = CStr(Day(vntCslDate(0)))

		If strCsName 		= "" Then strCsName 	= vntCsName(0)
		If strWebColor      = "" Then strWebColor  	= vntWebColor(0)
		If strRsvGrpName    = "" Then strRsvGrpName	= vntRsvGrpName(0)
		If lngMngGender	 	= "" Then lngMngGender	= vntMngGender(0)
		If lngMaxCnt		= "" Then lngMaxCnt		= vntMaxCnt(0)
		If lngMaxCnt_M	    = "" Then lngMaxCnt_M	= vntMaxCnt_M(0)
		If lngMaxCnt_F	    = "" Then lngMaxCnt_F	= vntMaxCnt_F(0)
		If lngOverCnt		= "" Then lngOverCnt	= vntOverCnt(0)
		If lngOverCnt_M	 	= "" Then lngOverCnt_M	= vntOverCnt_M(0)
		If lngOverCnt_F	 	= "" Then lngOverCnt_F	= vntOverCnt_F(0)
		If lngRsvCnt_M	    = "" Then lngRsvCnt_M	= vntRsvCnt_M(0)
		If lngRsvCnt_F		= "" Then lngRsvCnt_F	= vntRsvCnt_F(0)
	End If

	'�m��{�^���������A�ۑ��������s
	If strAction = "save" Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'��f���̕ҏW
		strCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

		'�\��l���Ǘ����̓o�^ ==> �\��ςݐl���͓n���Ȃ� 2003.12.16	������߂�������Ă܂����� by Ishihara 2004/02/05
		strArrMessage = objSchedule.UpdateRsvFraMngInfo( _
                    						strMode, _
                    						strCslDate, _
                    						strCsCd, _
                    						lngRsvGrpCd, _
											IIf( lngMaxCnt = "", 0, lngMaxCnt), _
											IIf( lngMaxCnt_M = "", 0, lngMaxCnt_M	), _
											IIf( lngMaxCnt_F = "", 0, lngMaxCnt_F	), _
											IIf( lngOverCnt	 = "", 0, lngOverCnt	), _
											IIf( lngOverCnt_M = "", 0, lngOverCnt_M), _
											IIf( lngOverCnt_F = "", 0, lngOverCnt_F) _
						                    )

'''' 2003.12.16 �폜						IIf( lngRsvCnt_M = "", 0, lngRsvCnt_M	), _
'''' 2003.12.16 �폜						IIf( lngRsvCnt_F  = "", 0, lngRsvCnt_F ) _


		'�X�V�G���[���͏����𔲂���
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�ۑ��ɐ��������ꍇ
		'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End
		Exit Do

	End If

	'�폜�{�^���������A�폜�������s
	If strAction = "delete" Then

		'��f�m����z���A�l�������׏��̍폜
		Ret = objSchedule.DeleteRsvFraMng( strCslDate, strCsCd, lngRsvGrpCd )


		'�폜�Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�\��l���Ǘ����̍폜�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�\��l���Ǘ������폜�ł��܂���B"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	Exit Do
Loop

'### 2004/02/05 Added by Ishihara@FSIT �X�V���ɃG���[�ɂȂ�Ɖ�ʕ\�����ނ��Ⴍ����(--;)
'�X�V���[�h�i���̍X�V���[�h�̔��f���N�Z���m�����ǁj�A���G���[���ݎ��݂̂��̏������s��
If Not IsEmpty(strArrMessage) And strMode = "update" Then

	'�G���[���ɖ��̂Ȃǂ��S�����X�g����
	'�i���܂�����̂������@�ł͂Ȃ����A�����l����C�͂Ȃ��j
	lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
	            strCslDate, strCslDate, _
	            strCsCd & "", _
	            lngRsvGrpCd & "", _
	            vntCslDate, _
	            vntCsCd, _
	            vntCsName, _
	            vntWebColor, _
	            vntRsvGrpCd, _
	            vntRsvGrpName, _
	            vntMngGender, _
                , _
                , _
                , _
                , _
                , _
                , _
                vntRsvCnt_M, _
                vntRsvCnt_F _
                )


	'�\������ɕK�v�Ȃ��̂����ăZ�b�g
	If strCsName 		= "" Then strCsName 	= vntCsName(0)
	If strRsvGrpName    = "" Then strRsvGrpName	= vntRsvGrpName(0)
	If lngMngGender	 	= "" Then lngMngGender	= vntMngGender(0)
	If lngRsvCnt_M	    = "" Then lngRsvCnt_M	= vntRsvCnt_M(0)
	If lngRsvCnt_F		= "" Then lngRsvCnt_F	= vntRsvCnt_F(0)

End If

'### 2004/02/05 Added End

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓f�[�^�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon
		.AppendArray vntArrMessage, .CheckNumeric("�\��\�l���i���ʁj", lngMaxCnt, 3)
		.AppendArray vntArrMessage, .CheckNumeric("�\��\�l���i�j�j", lngMaxCnt_M, 3)
		.AppendArray vntArrMessage, .CheckNumeric("�\��\�l���i���j", lngMaxCnt_F, 3)
		.AppendArray vntArrMessage, .CheckNumeric("�I�[�o�\�l���i���ʁj", lngOverCnt, 3)
		.AppendArray vntArrMessage, .CheckNumeric("�I�[�o�\�l���i�j�j", lngOverCnt_M, 3)
		.AppendArray vntArrMessage, .CheckNumeric("�I�[�o�\�l���i���j", lngOverCnt_F, 3)
'		.AppendArray vntArrMessage, .CheckNumeric("�\��ςݐl���i�j�j", lngRsvCnt_M, 3)
'		.AppendArray vntArrMessage, .CheckNumeric("�\��ςݐl���i���j", lngRsvCnt_F, 3)
	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�[�X�R�[�h�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ :
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CsCdList()

	Dim strArrCsCdID		'�R�[�X�R�[�h
	Dim strArrCsCdName		'�R�[�X��

	Dim lngCsCsCnt			'����

	lngCsCsCnt = objCourse.SelectCourseList ( strArrCsCdID, strArrCsCdName )

	If lngCsCsCnt = 0 Then
		strArrCsCdID = Array()
		Redim Preserve strArrCsCdID(0)
		strArrCsCdName = Array()
		Redim Preserve strArrCsCdName(0)
	End If

	CsCdList = EditDropDownListFromArray("cscd", strArrCsCdID, strArrCsCdName, strCsCd, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��Q�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ :
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function RsvGrpList()

	Dim strArrRsvGrpID			'�\��Q�R�[�h
	Dim strArrRsvGrpName		'�\��Q��

	Dim lngRsvGrpCnt			'����

	lngRsvGrpCnt = objSchedule.SelectRsvGrpList ( 0, strArrRsvGrpID, strArrRsvGrpName )

	If lngRsvGrpCnt = 0 Then
		strArrRsvGrpID = Array()
		Redim Preserve strArrRsvGrpID(0)
		strArrRsvGrpName = Array()
		Redim Preserve strArrRsvGrpName(0)
	End If

	RsvGrpList = EditDropDownListFromArray("rsvGrpCd", strArrRsvGrpID, strArrRsvGrpName, lngRsvGrpCd, NON_SELECTED_ADD)

End Function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�\��g�C��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function saveData() {

	// ���[�h���w�肵��submit
	document.entryForm.action.value = 'save';
	document.entryForm.submit();

}

// �폜�m�F���b�Z�[�W
function deleteData() {

	if ( !confirm( '���̗\��g�����폜���܂��B��낵���ł����H' ) ) {
		return;
	}


	// ���[�h���w�肵��submit
	document.entryForm.action.value = 'delete';
	document.entryForm.submit();

}

function windowClose() {

	// ���t�K�C�h�����
	calGuide_closeGuideCalendar();

}
//-->

</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="POST">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN>�\��g�o�^�E�C��</B></TD>
	</TR>
</TABLE>
<!-- ������� -->
<INPUT TYPE="hidden" NAME="action"   VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode"     VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="cslDate"  VALUE="<%= strCslDate %>">
<BR>
<%
	'���b�Z�[�W�̕ҏW
	Select Case strAction

		Case ""

		'�ۑ��������́u�ۑ������v�̒ʒm
		Case "saveend"
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�폜�������́u�폜�����v�̒ʒm
		Case "deleteend"
			Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Case Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End Select
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
	'�V�K�o�^���[�h�̂Ƃ�
	If strMode = "insert" Then
%>
		<TR>
			<TD WIDTH="132">��f��</TD>
			<TD>�F</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strCslYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("cslMonth", 1, 12, Clng("0" & strCslMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("cslDay",   1, 31, Clng("0" & strCslDay  )) %></TD>
					<TD>&nbsp;��</TD>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD WIDTH="132">�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= CsCdList() %></TD>
		</TR>
		<TR>
			<TD WIDTH="132">�\��Q</TD>
			<TD>�F</TD>
			<TD><%= RsvGrpList() %></TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">��f��</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= strCslYear %>&nbsp;�N&nbsp;<%= strCslMonth %>&nbsp;��&nbsp;<%= strCslDay %>&nbsp;��
<!-- 2004/02/05 Added by Ishihara@FSIT -->
			<INPUT TYPE="hidden" VALUE="<%= strCslYear %>"  NAME="cslYear">
			<INPUT TYPE="hidden" VALUE="<%= strCslMonth %>" NAME="cslMonth">
			<INPUT TYPE="hidden" VALUE="<%= strCslDay %>"   NAME="cslDay">
			</TD>
		</TR>
		<TR>
			<TD WIDTH="132">�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= strCsName %></TD>
			<INPUT TYPE="hidden" NAME="cscd"  VALUE="<%= strCsCd %>">
		</TR>
		<TR>
			<TD WIDTH="132">�\��Q</TD>
			<TD>�F</TD>
			<TD><%= strRsvGrpName %></TD>
			<INPUT TYPE="hidden" NAME="rsvGrpCd"  VALUE="<%= lngRsvGrpCd %>">
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">�\��\�l���i���ʁj</TD>
		<TD>�F</TD>
<%
		'�j���ʘg�Ǘ����Ȃ� �܂��͐V�K
		If lngMngGender = 0 Or strMode = "insert" Then
%>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt" SIZE="10" MAXLENGTH="8" VALUE="<%= lngMaxCnt %>" STYLE="ime-mode:disabled;"></TD>
<%
		Else
%>
			<TD>�w��s�\</TD>
<%
		End If
%>
	</TR>
<%
	'�j���ʘg�Ǘ����Ȃ��i�X�V�̂Ƃ��j
	If lngMngGender = 0 And strMode = "update" Then
%>
		<TR>
			<TD WIDTH="132">�\��\�l���i�j���j</TD>
			<TD>�F</TD>
			<TD>�w��s�\</TD>
		</TR>
		<TR>
			<TD WIDTH="132">�\��\�l���i�����j</TD>
			<TD>�F</TD>
			<TD>�w��s�\</TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">�\��\�l���i�j���j</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt_M" SIZE="10" MAXLENGTH="3" VALUE="<%= lngMaxCnt_M %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD WIDTH="132">�\��\�l���i�����j</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="maxCnt_F" SIZE="10" MAXLENGTH="3" VALUE="<%= lngMaxCnt_F %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">�I�[�o�\�l���i���ʁj</TD>
		<TD>�F</TD>
<%
		'�j���ʘg�Ǘ����Ȃ� �܂��͐V�K
		If lngMngGender = 0 Or strMode = "insert" Then
%>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt %>" STYLE="ime-mode:disabled;"></TD>
<%
		Else
%>
			<TD>�w��s�\</TD>
<%
		End If
%>
	</TR>
<%
	'�j���ʘg�Ǘ����Ȃ��i�X�V�̂Ƃ��j
	If lngMngGender = 0 And strMode = "update" Then
%>
		<TR>
			<TD WIDTH="132">�I�[�o�\�l���i�j���j</TD>
			<TD>�F</TD>
			<TD>�w��s�\</TD>
		</TR>
		<TR>
			<TD WIDTH="132">�I�[�o�\�l���i�����j</TD>
			<TD>�F</TD>
			<TD>�w��s�\</TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD WIDTH="132">�I�[�o�\�l���i�j���j</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt_M" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt_M %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD WIDTH="132">�I�[�o�\�l���i�����j</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overCnt_F" SIZE="10" MAXLENGTH="3" VALUE="<%= lngOverCnt_F %>" STYLE="ime-mode:disabled;"></TD>
		</TR>
<%
	End If
%>
	<TR>
		<TD WIDTH="132"><IMG SRC="../../images/spacer.gif" BORDER="0" WIDTH="10" HEIGHT="10" </TD>
		<TD></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD WIDTH="132">�\��ςݐl���i�j�j</TD>
		<TD>�F</TD>
		<TD NOWRAP><%= lngRsvCnt_M %>�l</TD>
		<INPUT TYPE="hidden" NAME="rsvCnt_M"  VALUE="<%= lngRsvCnt_M %>">
	</TR>
	<TR>
		<TD WIDTH="132">�\��ςݐl���i���j</TD>
		<TD>�F</TD>
		<TD NOWRAP><%= lngRsvCnt_F %>�l</TD>
		<INPUT TYPE="hidden" NAME="rsvCnt_F"  VALUE="<%= lngRsvCnt_F %>">
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<TR><!-- �C���� -->
<%
	If strMode = "update" Then
%>
	    <% If Session("PAGEGRANT") = "4" Then %>	
            <TD WIDTH="190"><A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e���폜���܂�"></A></TD>
        <% End IF %>

<%
	Else
%>
		<TD WIDTH="190"></TD>
<%
	End If
%>
	<TD WIDTH="5"></TD>
	<TD>
	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
		<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm�肵�܂�"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
	</TD>


	<TD WIDTH="5"></TD>
	<TD>
		<A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z�����܂�"></A></TD>
	</TD>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
