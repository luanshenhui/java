<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���я��쐬�i���m�F (Ver0.0.2)
'	   AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objOrg				'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objReportSendDate	'���я��������A�N�Z�X�p

Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")


'Dim strKey              	'�����L�[
Dim strArrKey              	'�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartCslDate     	'����������f�N�����i�J�n�j
Dim strStartYear     		'����������f�N�i�J�n�j
Dim strStartMonth     		'����������f���i�J�n�j
Dim strStartDay     		'����������f���i�J�n�j
Dim strEndCslDate     		'����������f�N�����i�I���j
Dim strEndYear     			'����������f�N�i�I���j
Dim strEndMonth     		'����������f���i�I���j
Dim strEndDay     			'����������f���i�I���j
Dim strOrgCd1		   		'���������c�̃R�[�h�P
Dim strOrgCd2		   		'���������c�̃R�[�h�Q
Dim strOrgName		   		'���������c�̖�

Dim strOrgGrpCd				'�c�̃O���[�v�R�[�h
Dim strCsCd					'�R�[�X�R�[�h
Dim strPerId
Dim strPerName

'Dim strPerId		   		'���������l�h�c
'Dim strPerName		   		'���������l��
Dim strLastName         	'����������
Dim strFirstName        	'����������

Dim vntRsvNo	          	'�\��ԍ�
Dim vntCslDate          	'��f��
Dim vntPerId	          	'�l�h�c
Dim vntLastName         	'��
Dim vntFirstName        	'��
Dim vntLastKName         	'�J�i��
Dim vntFirstKName        	'�J�i��
Dim vntOrgCd1    	      	'�c�̃R�[�h�P
Dim vntOrgCd2	          	'�c�̃R�[�h�Q
Dim vntOrgSName          	'�c�̗���
Dim vntDayId         		'�����h�c
Dim vntReportSendDate		'�����m�F����
Dim vntPubNote 		       	'���я��R�����g
Dim vntClrFlg           	'�����N���A�t���O

Dim vntGFFlg				'���GF��f�t���O
Dim vntCFFlg				'���GF��f�t���O
Dim vntSeq					'SEQ
Dim vntCsName				'�R�[�X��
Dim vntwebColor				'�R�[�X�J���[
Dim vntReportOutEng			'�p�����я��o��
Dim vntChargeUserName		'�����m�F�Җ�

Dim lngAllCount				'����
Dim lngGetCount				'����
Dim i						'�J�E���^
Dim j

Dim lngStartPos				'�\���J�n�ʒu
Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��

Dim lngArrSendMode()		'�������m�F��Ԃ̔z��
Dim strArrSendModeName()	'�������m�F��Ԗ��̔z��

Dim lngSendMode

Dim Ret						'�֐��߂�l
Dim strURL					'�W�����v���URL

Dim vntDelRsvNo				'
Dim vntDelSeq				'

'��ʕ\������p��������
Dim strBeforeRsvNo			'�O�s�̗\��ԍ�

Dim strWebCslDate			'
Dim strWebDayId				'
Dim strWebCsInfo			'
Dim strWebPerId				'
Dim strWebPerName			'
Dim strWebOrgName			'
Dim strWebGFFlg				'
Dim strWebCFFlg				'
Dim strWebReportOutEng		'

Dim strMessage
Dim strArrMessage	'�G���[���b�Z�[�W�̔z��

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objReportSendDate = Server.CreateObject("HainsReportSendDate.ReportSendDate")

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
'strKey            = Request("textKey")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
vntRsvNo          = ConvIStringToArray(Request("rsvno"))
vntSeq            = ConvIStringToArray(Request("seq"))
vntClrFlg         = ConvIStringToArray(Request("checkClrVal"))
lngSendMode       = Request("sendMode")
strCsCd           = Request("csCd")
strOrgGrpCd       = Request("OrgGrpCd")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'���̓`�F�b�N
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		strAction = ""
		Exit Do
	End If

	'�ۑ��{�^���N���b�N
	If strAction = "save" Then

		vntDelRsvNo = Array()
		vntDelSeq   = Array()

		For i = 0 To UBound(vntClrFlg)

			'�`�F�b�N���ꂽ�ꍇ�ɁA�������s
			If vntClrFlg(i) = "1" Then

				ReDim Preserve vntDelRsvNo(j)
				ReDim Preserve vntDelSeq(j)

				vntDelRsvNo(j) = vntRsvNo(i)
				vntDelSeq(j)   = vntSeq(i)
				j = j + 1

			End If

		Next

		if j > 0 Then

			'�������N���A
			If objReportSendDate.DeleteConsult_ReptSend("SEL", vntDelRsvNo, vntDelSeq) Then
				strAction = "saveend"
			Else
				strAction = "saveerr"
			End If

		Else
		
			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			objCommon.AppendArray strArrMessage, "�N���A���鐬�я�������I������Ă��܂���"
			strMessage = strArrMessage

		End If

	End If

	If strAction <> "" Then

'		If strKey <> "" Then
'			'�����L�[���󔒂ŕ�������
'			strArrKey = SplitByBlank(strKey)
'		Else 
'			strArrKey  = Array()
'			ReDim Preserve strArrKey(0)
'		End if

		'�����J�n�I����f���̕ҏW
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

		'�S�����擾����
		lngAllCount = objReportSendDate.SelectReportSendDateList("CNT", _
		                                                         strPerId, _
		                                                         cDate(strStartCslDate), _
		                                                         cDate(strEndCslDate), _
		                                                         strCsCd, _
		                                                         strOrgCd1, _
		                                                         strOrgCd2, _
		                                                         strOrgGrpCd, _
		                                                         lngSendMode, _
		                                                         lngStartPos, _
		                                                         lngPageMaxLine)


		If lngAllCount > 0 Then

			'���������ɏ]�����я����ꗗ�𒊏o����
			lngGetCount = objReportSendDate.SelectReportSendDateList("", _
			                                                         strPerId, _
			                                                         cDate(strStartCslDate), _
			                                                         cDate(strEndCslDate), _
			                                                         strCsCd, _
			                                                         strOrgCd1, _
			                                                         strOrgCd2, _
			                                                         strOrgGrpCd, _
			                                                         lngSendMode, _
			                                                         lngStartPos, _
			                                                         lngPageMaxLine, _
			                                                         vntRsvNo, _
			                                                         vntCslDate, _
			                                                         vntDayId, _
			                                                         vntPerId, _
			                                                         , _
			                                                         vntCsName, _
			                                                         vntwebColor, _
			                                                         vntLastName, _
			                                                         vntFirstName, _
			                                                         vntLastKName, _
			                                                         vntFirstkName, _
			                                                         , _
			                                                         , _
			                                                         vntOrgSName, _
			                                                         , _
			                                                         vntGFFlg, _
			                                                         vntCFFlg, _
			                                                         vntSeq, _
			                                                         , _
			                                                         vntReportSendDate, _
			                                                         , _
			                                                         vntChargeUserName, _
			                                                         vntPubNote, _
			                                                         vntReportOutEng)


			vntClrFlg = Array()
			Redim Preserve vntClrFlg(UBound(vntCslDate))

		End If

		'�c�̃R�[�h����H
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName 
		Else
			strOrgName = ""
		End If 

		'�lID�̎w�肪����ꍇ�A���̎擾
		If strPerId <> "" Then
			ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
			strPerName = strLastName & "�@" & strFirstName
		Else
			strPerName = ""
		End If 

	End If

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	'�����J�n�I����f���̕ҏW
	strStartCslDate = strStartYear & "/" & strStartMonth & "/" & strStartDay
	strEndCslDate   = strEndYear & "/" & strEndMonth & "/" & strEndDay

	With objCommon

		If Not IsDate(strStartCslDate) Then
			.AppendArray strArrMessage, "�w�肳�ꂽ�J�n��f�������������t�ł͂���܂���B"
		End If

		If Not IsDate(strEndCslDate) Then
			.AppendArray strArrMessage, "�w�肳�ꂽ�I����f�������������t�ł͂���܂���B"
		End If

	End With

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(2)
	Redim Preserve strArrPageMaxLineName(2)

	Redim Preserve lngArrSendMode(2)
	Redim Preserve strArrSendModeName(2)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50�s����"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100�s����"
	lngArrPageMaxLine(2) = 999:strArrPageMaxLineName(2) = "���ׂ�"

	lngArrSendMode(0)     = 0
	strArrSendModeName(0) = "���ׂ�"

	lngArrSendMode(1)     = 1
	strArrSendModeName(1) = "�����ς݂̂�"

	lngArrSendMode(2)     = 2
	strArrSendModeName(2) = "�������̂�"

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���я��쐬�i���m�F</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �N���A�`�F�b�N
function checkClrAct( index ) {

	with ( document.entryReportInfo ) {
		if ( checkClr.length == null ) {
			checkClr.value = (checkClr.checked ? '1' : '0');
			checkClrVal.value = (checkClr.checked ? '1' : '0');
		} else {
			checkClr[index].value = (checkClr[index].checked ? '1' : '0');
			checkClrVal[index].value = (checkClr[index].checked ? '1' : '0');
		}
	}

}
// �����{�^���N���b�N
function searchClick() {

	with ( document.entryReportInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// �ۑ��{�^���N���b�N
function setReportSendDateClr() {

	if( !confirm('�I�����ꂽ���я����������N���A���܂��B��낵���ł����H' ) ) return;

	with ( document.entryReportInfo ) {
		action.value = 'save';
		submit();
	}

	return false;

}

// �A�����[�h���̏���
function closeGuideWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	// �l�����K�C�h�����
	perGuide_closeGuidePersonal();

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryReportInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>"> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">���я������i���m�F</FONT></B></TD>
	</TR>
</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>��f��</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;���`&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;��</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>�R�[�X</TD>
		<TD>�F</TD>
		<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
	</TR>
	<TR>
		<TD>�c��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryReportInfo.orgCd1, document.entryReportInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="�c�̌����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryReportInfo.orgCd1, document.entryReportInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD NOWRAP COLSPAN="2">�c�̃O���[�v�F<%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
	</TR>
	<TR>
		<TD>�lID</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryReportInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryReportInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
						<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
						<SPAN ID="perName"><%= strPerName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD><%= EditDropDownListFromArray("sendMode", lngArrSendMode, strArrSendModeName, lngSendMode, NON_SELECTED_DEL) %>�@</TD>
		<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>�@</TD>
		<TD><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<!--�����͌�����������-->
<%
	If strAction <> "" Then
%>

<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>
			<SPAN STYLE="font-size:9pt;">
			�u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>���`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��</B></FONT>�v�̐��я��쐬���ꗗ��\�����Ă��܂��B<BR>
					�������ʂ�<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>���i���я������P�ʁj�ł��B 
<%
	If lngAllCount > 0 Then
%>
			<FONT COLOR="#999999">�i����f�Җ��̂��N���b�N����ƃR�����g��񂪊J���܂��j</FONT>
<%
	End If
%>
			</SPAN>
		</TD>
<%
	If lngAllCount > 0 Then
%>
		<TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
		<TD><A HREF="javascript:setReportSendDateClr()"><IMG SRC="../../images/save.gif" ALT="�����m�F�������N���A���܂�" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
<%
	End If
%>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP>��f��</TD>
		<TD ALIGN="left" NOWRAP>�����h�c</TD>
		<TD ALIGN="left" NOWRAP>�R�[�X</TD>
		<TD ALIGN="left" NOWRAP>�l�h�c</TD>
		<TD ALIGN="left" NOWRAP>��f�Җ�</TD>
		<TD ALIGN="left" NOWRAP>�c�̖�</TD>
		<TD ALIGN="left" NOWRAP>���GF</TD>
		<TD ALIGN="left" NOWRAP>���CF</TD>
		<TD ALIGN="left" NOWRAP>�p��</TD>
		<TD ALIGN="left" NOWRAP>�����m�F����</TD>
		<TD ALIGN="left" NOWRAP>�S����</TD>
		<TD ALIGN="left" NOWRAP>�m�F�N���A</TD>
		<TD ALIGN="left" NOWRAP>���ӎ���</td>
		<TD ALIGN="left" NOWRAP>�\��ԍ�</td>
	</TR>
<%
	End If

	If lngAllCount > 0 Then
		strBeforeRsvNo = ""

		For i = 0 To UBound(vntCslDate)

			strWebCslDate  = ""
			strWebDayId    = ""
			strWebCsInfo   = ""
			strWebPerId    = ""
			strWebPerName  = ""
			strWebOrgName  = ""
			strWebGFFlg    = ""
			strWebCFFlg    = ""


			If strBeforeRsvNo <> vntRsvNo(i) Then

				strWebCslDate  = vntCslDate(i)
				strWebDayId    = objCommon.FormatString(vntDayId(i), "0000")
				strWebCsInfo   = "<FONT COLOR=""#" & vntwebColor(i) & """>��</FONT>" & vntCsName(i) 
				strWebPerId    = vntPerId(i)
				strWebPerName  = "<SPAN STYLE=""font-size:9px;"">" & vntLastKName(i) & "�@" & vntFirstKName(i) & "</SPAN><BR>" & vntLastName(i) & "�@" & vntFirstName(i)
				strWebOrgName  = vntOrgSName(i)
				strWebGFFlg    = IIf(vntGFflg(i) > "0", "GF", "")
				strWebCFFlg    = IIf(vntCFflg(i) > "0", "CF", "")

			End If
%>
			<TR HEIGHT="18" BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strWebCslDate %></TD>
				<TD NOWRAP><%= strWebDayId   %></TD>
				<TD NOWRAP><%= strWebCsInfo  %></TD>
				<TD NOWRAP><%= strWebPerId   %></TD>
				<TD NOWRAP><A HREF="javascript:noteGuide_showGuideNote('1', '1,1,0,0', '', <%= vntRsvNo(i) %>)" ALT="�N���b�N����ƃR�����g��񂪊J���܂�"><%= strWebPerName %></A></TD>
				<TD NOWRAP><%= strWebOrgName %></TD>

				<TD NOWRAP ALIGN="CENTER"><%= strWebGFFlg %></TD>
				<TD NOWRAP ALIGN="CENTER"><%= strWebCFFlg %></TD>

				<TD NOWRAP ALIGN="CENTER"><%= IIf(vntReportOutEng(i) = "1", "Eng", "") %></TD>
				<TD NOWRAP><%= vntReportSendDate(i) %></TD>
				<TD NOWRAP><%= vntChargeUserName(i) %></TD>
				<INPUT TYPE="hidden" NAME="checkClrVal" VALUE="<%= vntClrFlg(i) %>">
				<TD NOWRAP>
<%
	If vntReportSendDate(i) <> "" Then
%>
					<INPUT TYPE="checkbox" NAME="checkClr" VALUE="1" <%= IIf(vntClrflg(i) <> "", " CHECKED", "") %>  ONCLICK="javascript:checkClrAct(<%= i %>)" border="0">�N���A
<%
	Else
%>
					<INPUT TYPE="checkbox" NAME="checkClr" VALUE="0" BORDER="0" STYLE="visibility:hidden">
<%
	End If
%>
				</TD>
				<TD NOWRAP><FONT COLOR="black"><%= vntPubNote(i) %></FONT></TD>
				<TD><%= vntRsvNo(i) %></TD>
				<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= vntRsvNo(i) %>">
				<INPUT TYPE="hidden" NAME="seq"   VALUE="<%= vntSeq(i) %>">
			</TR>
<%
			strBeforeRsvNo = vntRsvno(i)
		Next
	ENd If
%>
</TABLE>
<%
	If lngAllCount > 0 Then
		'�S���������̓y�[�W���O�i�r�Q�[�^�s�v
     	If lngPageMaxLine <= 0 Then
		Else
			'URL�̕ҏW
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?mode="        & strMode
			strURL = strURL & "&action="      & strAction
			strURL = strURL & "&startYear="   & strStartYear
			strURL = strURL & "&startMonth="  & strStartMonth
			strURL = strURL & "&startDay="    & strStartDay
			strURL = strURL & "&endYear="     & strEndYear
			strURL = strURL & "&endMonth="    & strEndMonth
			strURL = strURL & "&endDay="      & strEndDay
			strURL = strURL & "&orgCd1="      & strOrgCd1
			strURL = strURL & "&orgCd2="      & strOrgCd2
'			strURL = strURL & "&textKey="     & strKey
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
'### 2004/06/04 Added by Ishihara@FSIT �y�[�W���O�i�r�g�p���Ɉ��������X�g
			strURL = strURL & "&sendMode="    & lngSendMode
			strURL = strURL & "&OrgGrpCd="    & strOrgGrpCd
			strURL = strURL & "&csCd="        & strCsCd
'### 2004/06/04 Added End
			'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
			<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
		End If
%>
		<BR>
<%
	End If
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>