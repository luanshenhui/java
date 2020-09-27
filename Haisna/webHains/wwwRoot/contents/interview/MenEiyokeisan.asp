<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�{�v�Z (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objNutritionCalc	'�h�{�v�Z�N���X

Dim strAction		'�������

Dim strCslDate		'��f��
Dim strCslYear		'��f���i�N�j
Dim strCslMonth		'��f���i���j
Dim strCslDay		'��f���i���j

Dim strtodayId		'�����h�c�w����@

Dim lngStartId		'�����h�c�i�͈͎w��F�J�n�j
Dim lngEndId		'�����h�c�i�͈͎w��F�I���j
Dim strPluralId		'�����h�c�i�����w��j

Dim strEiyokeisan	'�h�{�v�Z�`�F�b�N
Dim strActPattern	'�`�^�s���p�^�[���`�F�b�N
Dim strPointLost	'���_����`�F�b�N
Dim strStress		'�X�g���X�v�Z�`�F�b�N

Dim vntCalcFlg()	'�v�Z�Ώۃt���O
Dim vntArrDayId		'�����h�c�i�����w��̏ꍇ�̌v�Z�����ւ̈����j
Dim strUpdUser		'�X�V��
Dim strIPAddress	'IP�A�h���X	

Dim Ret				'�֐����A�l

Dim strArrMessage		'�G���[���b�Z�[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
Set objNutritionCalc    = Server.CreateObject("HainsNutritionCalc.nutritionCalc")

strAction        = Request("act")

strtodayId       = Request("chktodayId")

strCslYear       = Request("cslyear")
strCslMonth      = Request("cslmonth")
strCslDay        = Request("cslday")

strEiyokeisan    = Request("checkEiyo")
strActPattern	 = Request("checkActPattern")
strPointLost	 = Request("checkPointLost")
strStress	     = Request("checkStress")

lngStartId       = Request("startId")
lngEndId         = Request("endId")
strPluralId      = Request("pluralId")

strtodayId = IIf( strtodayId = "", 0, strtodayId )


'���t���w��̏ꍇ�A�V�X�e���N������K�p����
If strCslYear = "" Then
	strCslYear  = CStr(Year(Now))
	strCslMonth = CStr(Month(Now))
	strCslDay   = CStr(Day(Now))
End If

'�v�Z�J�n
If strAction = "calc" Then

	'��f���ҏW
	strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay

	Redim Preserve vntCalcFlg(3)
	If strEiyokeisan = "1" Then
		vntCalcFlg(0) = 1
	Else
		vntCalcFlg(0) = 0
	End If
	If strActPattern = "1" Then
		vntCalcFlg(1) = 1
	Else
		vntCalcFlg(1) = 0
	End If
	If strPointLost = "1" Then
		vntCalcFlg(2) = 1
	Else
		vntCalcFlg(2) = 0
	End If
	If strStress = "1" Then
		vntCalcFlg(3) = 1
	Else
		vntCalcFlg(3) = 0
	End If

	If strtodayId = 2 Then
		vntArrDayId = split( strPluralId, "," )
	Else
		vntArrDayId = Array()
		Redim Preserve vntArrDayId(0)
	End If

'	Err.Raise 1000, , "(" & strCslDate & ")(" & strtodayId & ")(" & vntCalcFlg(0) & ")(" & lngStartId & ")(" & lngEndId  & ")"

	
	strUpdUser        = Session.Contents("userId")
	strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

	Ret = objNutritionCalc.nutritionCalcStart (	strUpdUser, _
												strIPAddress, _
												strCslDate, _
    											strtodayId, _
    									        vntCalcFlg, _
    									        lngStartId, _
    									        lngEndId, _
                                                vntArrDayId, _
												strArrMessage _
                                        		)
	If Ret = 0 Then
		strAction = "calcend"
	End If
	
End If

%>
	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>�h�{�v�Z</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var curYear, curMonth, curDay;	// ���t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�

// ���t�K�C�h�Ăяo��
function callCalGuide() {

	// �K�C�h�Ăяo�����O�̓��t��ޔ�
	curYear  = document.entryForm.cslyear.value;
	curMonth = document.entryForm.cslmonth.value;
	curDay   = document.entryForm.cslday.value;

	// ���t�K�C�h�\��
	calGuide_showGuideCalendar( 'cslyear', 'cslmonth', 'cslday');

}

//�����h�c�`�F�b�N
function checktodayIdAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			todayId.value = (todayId[index].checked ? '1' : '');
		} else if (index == 1 ){
			todayId.value = (todayId[index].checked ? '2' : '');
		}
		chktodayId.value = todayId.value;
	}

}

//�h�{�v�Z�`�F�b�N
function checkEiyoAct() {

	with ( document.entryForm ) {
		checkEiyo.value = (checkEiyo.checked ? '1' : '');
	}

}
//�`�^�s���p�^�[���`�F�b�N
function checkActPatternAct() {

	with ( document.entryForm ) {
		checkActPattern.value = (checkActPattern.checked ? '1' : '');
	}

}
//���_����`�F�b�N
function checkLostPointAct() {

	with ( document.entryForm ) {
		checkPointLost.value = (checkPointLost.checked ? '1' : '');
	}

}
//�X�g���X�_���`�F�b�N
function checkStressAct() {

	with ( document.entryForm ) {
		checkStress.value = (checkStress.checked ? '1' : '');
	}

}

//�v�Z�����Ăяo��
function callCalc() {

	var myForm;

	myForm = document.entryForm;

	if ( myForm.todayId[0].checked ){
		if ( myForm.startId.value == '' ||
             myForm.endId.value == '' ){
			alert( "�����h�c���w�肳��Ă��܂���B");
			return;
		}
	}else if ( myForm.todayId[1].checked ){
		if ( myForm.pluralId.value == '' ){
			alert( "�����h�c���w�肳��Ă��܂���B");
			return;
		}
	}

	if (myForm.checkEiyo.value == '' &&
	    myForm.checkActPattern.value == '' &&
	    myForm.checkPointLost.value == '' &&
	    myForm.checkStress.value == '' ){
		alert( "�v�Z�Ώۂ��w�肳��Ă��܂���B" );
		return;
	}

	myForm.act.value = "calc";
	myForm.submit();
}

function windowClose() {

	// ���t�K�C�h�E�C���h�E�����
	calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY  ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><font color="#000000">�h�{�v�Z</font></B></TD>
		</TR>
	</TABLE>

	<BR>

<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		Select Case strAction

			'�ۑ��������́u����I���v�̒ʒm
			Case "calcend"
				Call EditMessage("�v�Z������I�����܂����B", MESSAGETYPE_NORMAL)

			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:callCalGuide()"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" border="0"></A></TD>
			<TD><%= EditSelectNumberList("cslyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strCslYear)) %></TD>
			<TD>�N</TD>
			<TD><%= EditSelectNumberList("cslmonth", 1, 12, CLng("0" & strCslMonth)) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("cslday",   1, 31, CLng("0" & strCslDay  )) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<!--- �R�[�X -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<INPUT TYPE="hidden" NAME="chktodayId" VALUE="<%= strtodayId %>" >
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>����ID</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "1", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(0)" BORDER="0">�͈͎w��<INPUT TYPE="text" NAME="startId" VALUE="<%= lngStartId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;">�`<INPUT TYPE="text" NAME="endId" VALUE="<%= lngEndId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;"></SPAN></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD WIDTH="90" NOWRAP></TD>
			<TD></TD>
			<TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "2", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(1)"  BORDER="0">�����w��<INPUT TYPE="text" NAME="pluralId" VALUE="<%= strPluralId %>" SIZE="35" BORDER="0" STYLE="ime-mode:disabled;"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�v�Z�Ώ�</TD>
			<TD>�F</TD>
			<TD><INPUT type="checkbox" name="checkEiyo" value="<%= strEiyokeisan %>" <%= IIf(strEiyokeisan <> "", " CHECKED", "") %> ONCLICK="javascript:checkEiyoAct()" border="0">�h�{�v�Z</TD>
			<TD><INPUT type="checkbox" name="checkActPattern" value="<%= strActPattern %>" <%= IIf(strActPattern <> "", " CHECKED", "") %> ONCLICK="javascript:checkActPatternAct()" border="0">�`�^�s���p�^�[��</TD>
			<TD><INPUT type="checkbox" name="checkPointLost" value="<%= strPointLost %>" <%= IIf(strPointLost <> "", " CHECKED", "") %> ONCLICK="javascript:checkLostPointAct()" border="0">���_����</td>
			<TD><INPUT type="checkbox" name="checkStress" value="<%= strStress %>" <%= IIf(strStress <> "", " CHECKED", "") %> ONCLICK="javascript:checkStressAct()" border="0">�X�g���X�_��</td>
		</TR>
	</TABLE>

	<BR><BR>

	<TD><A HREF="javascript:callCalc()"><IMG SRC="../../images/ok.gif" WIDTH="77" HEIGHT="24" ALT="�v�Z���J�n���܂�"></A></TD>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>