<%@ LANGUAGE="VBScript" %>
<%
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-007
'�C����  �F2011.11.17
'�S����  �FFJTH)MURTA
'�C�����e�F�ʐڎx����ʁ@�\���s��Ή�
'========================================
'-----------------------------------------------------------------------------
'	   �H�K���A�����R�����g  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Const DISPMODE_FOODADVICE = 3		'�\�����ށF�H�K��
Const DISPMODE_MENUADVICE = 4		'�\�����ށF����
Const JUDCLASSCD_FOODADVICE = 51	'���蕪�ރR�[�h�F�H�K��
Const JUDCLASSCD_MENUADVICE = 52	'���蕪�ރR�[�h�F����

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h
Dim strAct				'�������

'�H�K���R�����g
Dim vntFoodCmtSeq		'�\����
Dim vntFoodCmtCd		'����R�����g�R�[�h
Dim vntFoodCmtStc		'����R�����g����
Dim vntFoodClassCd		'���蕪�ރR�[�h
Dim lngFoodCmtCnt		'�s��

'�����R�����g
Dim vntMenuCmtSeq		'�\����
Dim vntMenuCmtCd		'����R�����g�R�[�h
Dim vntMenuCmtStc		'����R�����g����
Dim vntMenuClassCd		'���蕪�ރR�[�h
Dim lngMenuCmtCnt		'�s��

'�X�V����R�����g���
Dim vntUpdCmtSeq		'�\����
Dim vntUpdFoodCmtCd		'�H�K���R�����g�R�[�h
Dim vntUpdMenuCmtCd		'�����R�����g�R�[�h
Dim lngUpdCount			'�X�V���ڐ�

'## �ύX����p�@�ǉ� 2004.01.07
Dim vntUpdFoodCmtStc	'�H�K���R�����g
Dim vntUpdMenuCmtStc	'�����R�����g


Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strAct				= Request("act")

'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
'�ؑ֓��ȍ~�̎�f���ł����2012�N�ŗp�̉�ʂ�
If IsVer201210(lngRsvNo) Then
	Response.Redirect "MenFoodComment201210.asp?winmode=" & strWinMode & "&grpno=" & strGrpNo & "&rsvno=" & lngRsvNo & "&cscd=" & strCsCd
End If
'## 2012.09.11 Add End

'�X�V����R�����g���
lngFoodCmtCnt   = Clng("0" & Request("FoodCmtCnt"))
vntUpdFoodCmtCd	= ConvIStringToArray(Request("FoodCmtCd"))
'## �ύX����p�ɒǉ��@2004.01.07
vntUpdFoodCmtStc= ConvIStringToArray(Request("FoodCmtStc"))
lngMenuCmtCnt   = Clng("0" & Request("MenuCmtCnt"))
vntUpdMenuCmtCd	= ConvIStringToArray(Request("MenuCmtCd"))
'## �ύX����p�ɒǉ��@2004.01.07
vntUpdMenuCmtStc= ConvIStringToArray(Request("MenuCmtStc"))

Do
	'�ۑ�
	If strAct = "save" Then

		'�H�K���R�����g�R�����g�̕ۑ�
		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		ReDim vntUpdCmtSeq(-1)
		If lngFoodCmtCnt > 0 Then
			For i = 0 To UBound(vntUpdFoodCmtCd)
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				lngUpdCount = lngUpdCount + 1
			Next
		End If
		'## 2004.01.07 �X�V����p�ɕ��͂ƃ��[�U�h�c�ǉ�
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_FOODADVICE, _
								vntUpdCmtSeq, _
								vntUpdFoodCmtCd, _
								vntUpdFoodCmtStc, _
								Session.Contents("userId")

		'�����R�����g�R�����g�̕ۑ�
		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		ReDim vntUpdCmtSeq(-1)
		If lngMenuCmtCnt > 0 Then
			For i = 0 To UBound(vntUpdMenuCmtCd)
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				lngUpdCount = lngUpdCount + 1
			Next
		End If
		'## 2004.01.07 �X�V����p�ɕ��͂ƃ��[�U�h�c�ǉ�
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_MENUADVICE, _
								vntUpdCmtSeq, _
								vntUpdMenuCmtCd, _
								vntUpdMenuCmtStc, _
								Session.Contents("userId")


		strAct = "saveend"
	End If

	'�H�K���R�����g�擾
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'	lngFoodCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_FOODADVICE, _
'										1, 0,  , 0, _
'										vntFoodCmtSeq, _
'										vntFoodCmtCd, _
'										vntFoodCmtstc, _
'										vntFoodClassCd _
'										)
	lngFoodCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_FOODADVICE, _
										1, 1, strCsCd , 0, _
										vntFoodCmtSeq, _
										vntFoodCmtCd, _
										vntFoodCmtstc, _
										vntFoodClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

	'�����R�����g�擾
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'	lngMenuCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_MENUADVICE, _
'										1, 0,  , 0, _
'										vntMenuCmtSeq, _
'										vntMenuCmtCd, _
'										vntMenuCmtstc, _
'										vntMenuClassCd _
'										)
	lngMenuCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_MENUADVICE, _
										1, 1, strCsCd , 0, _
										vntMenuCmtSeq, _
										vntMenuCmtCd, _
										vntMenuCmtstc, _
										vntMenuClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�H�K���A�����R�����g</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var winJudComment;				// �E�B���h�E�n���h��
var jcmGuide_CmtType;			// �R�����g�^�C�v(�H�K���R�����g or �����R�����g)
var jcmGuide_CmtMode;			// �������[�h(�ǉ��A�}���A�C���A�폜)
var jcmGuide_SelectedIndex;	  	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
// �ҏW�O
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
// �ҏW��
var varNewCmtCd;
var varNewCmtStc;
var varNewClassCd;

// �R�����g�̑I��
function selectComment( cmttype, cmtmode ) {
	var myForm = document.entryForm;
	var dispmode;
	var elemCmtCd;
	var elemCmtStc;
	var elemClassCd;
	var i;

	jcmGuide_CmtType = cmttype;
	jcmGuide_CmtMode = cmtmode;

	if ( cmttype == 'Food' ) {
		jcmGuide_SelectedIndex = myForm.selectFoodList.value;
		cmtGuide_editcnt = myForm.FoodCmtCnt.value;
		dispmode = <%= JUDCLASSCD_FOODADVICE %>
		elemCmtCd = myForm.FoodCmtCd;
		elemCmtStc = myForm.FoodCmtStc;
		elemClassCd = myForm.FoodClassCd;
	} else
	if ( cmttype == 'Menu' ) {
		jcmGuide_SelectedIndex = myForm.selectMenuList.value;
		cmtGuide_editcnt = myForm.MenuCmtCnt.value;
		dispmode = <%= JUDCLASSCD_MENUADVICE %>
		elemCmtCd = myForm.MenuCmtCd;
		elemCmtStc = myForm.MenuCmtStc;
		elemClassCd = myForm.MenuClassCd;
	} else {
		return;
	}

	if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' || jcmGuide_CmtMode == 'delete' ){
		if ( jcmGuide_SelectedIndex == 0 ){
			alert( "�ҏW����s���I������Ă��܂���B" );
			return;
		}
	}

	// �R�����g��ҏW�G���A�ɃZ�b�g
	cmtGuide_varEditCmtCd = new Array(0);
	varEditCmtCd = new Array(0);
	varEditCmtStc = new Array(0);
	varEditClassCd = new Array(0);
	for ( i = 0; i < cmtGuide_editcnt; i++ ){
		if ( isNaN(elemCmtCd.length) ){
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd.value;
			varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd.value;
			varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc.value;
			varEditClassCd[varEditClassCd.length ++] = elemClassCd.value;
		} else {
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd[i].value;
			varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd[i].value;
			varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc[i].value;
			varEditClassCd[varEditClassCd.length ++] = elemClassCd[i].value;
		}
	}

	if ( jcmGuide_CmtMode == 'delete' ) {
		// �폜�̂Ƃ��̓R�����g�K�C�h�K�v�Ȃ�
		setComment();
	} else {
		// �R�����g�K�C�h�̌ďo
		cmtGuide_showAdviceComment(dispmode, setComment);
	}
}

// �R�����g���Z�b�g
function setComment() {
	var myForm = document.entryForm;
	var optList;
	var strHtml;
	var i;

	if ( jcmGuide_CmtType == 'Food' ) {
		optList = myForm.selectFoodList;
	} else
	if ( jcmGuide_CmtType == 'Menu' ) {
		optList = myForm.selectMenuList;
	} else {
		return;
	}

	// �R�����g�̕ҏW
	varNewCmtCd = new Array(0);
	varNewCmtStc = new Array(0);
	varNewClassCd = new Array(0);
		// �ǉ�
	if ( jcmGuide_CmtMode == 'add' ) {
		for ( i = 0; i < varEditCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
		for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
		}
	} else
		// �}���A�C��
	if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' ) {
		for ( i = 0; i < jcmGuide_SelectedIndex - 1; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
		for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
		}
		for ( i = jcmGuide_SelectedIndex - 1; i < varEditCmtCd.length; i++ ){
			// �C���̂Ƃ��I���s�͊O��
			if ( jcmGuide_CmtMode == 'edit' && i == jcmGuide_SelectedIndex - 1 ) continue;

			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
	} else
		// �폜
	if ( jcmGuide_CmtMode == 'delete' ) {
		for ( i = 0; i < varEditCmtCd.length; i++ ){
			// �폜�̂Ƃ��I���s�͊O��
			if ( i == jcmGuide_SelectedIndex - 1 ) continue;

			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
	}

	// �R�����g�̍ĕ`��
	strHtml = '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCnt"  VALUE="' + varNewCmtCd.length + '">\n';
	for ( i = 0; i < varNewCmtCd.length; i++ ) {
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCd"   VALUE="' + varNewCmtCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtStc"  VALUE="' + varNewCmtStc[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'ClassCd" VALUE="' + varNewClassCd[i] + '">\n';
	}
	document.getElementById(jcmGuide_CmtType + 'List').innerHTML = strHtml;

	// SELECT�I�u�W�F�N�g�̍ĕ`��
	while ( optList.length > 0 ) {
		optList.options[0] = null;
	}
	for ( i = 0; i < varNewCmtCd.length; i++ ){
		optList.options[optList.length] = new Option( varNewCmtStc[i], i+1 );
	}
}

// �����R�����g�K�C�h�����
function windowClose() {

	// �����R�����g�K�C�h�����
	if ( winJudComment != null ) {
		if ( !winJudComment.closed ) {
			winJudComment.close();
		}
	}

	winJudComment = null;
}

// �ۑ�
function saveMenFoodComment() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�H�K���A�����R�����g</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="10">
			</TD>
		</TR>
		<TR>
			<TD WIDTH="100%" ALIGN="RIGHT">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:saveMenFoodComment()"><IMG SRC="../../images/save.gif" ALT="���͓��e��ۑ����܂�" HEIGHT="24" WIDTH="77"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>	
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			<BR>
			</TD>
		</TR>
	</TABLE>
	<!-- �H�K���R�����g�̕\�� -->
	<TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2"><B><SPAN CLASS="result">��</SPAN></B>�H�K���R�����g</TD>
		</TR>
		<TR>
			<TD>
				<SELECT STYLE="width:600px" NAME="selectFoodList" SIZE="7">

<%
	For i = 0 To lngFoodCmtCnt - 1
%>
					<OPTION VALUE="<%= vntFoodCmtSeq(i) %>"><%= vntFoodCmtStc(i) %></OPTION>
<%
	Next
%>
				</SELECT>
			</TD>
			<TD VALIGN="top">
				<TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
					<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','add')">�ǉ�</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','insert')">�}��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','edit')">�C��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','delete')">�폜</A></TD>
                        </TR>
                    <%  end if  %>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<!-- �����R�����g�̕\�� -->
	<TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2"><B><SPAN CLASS="result">��</SPAN></B>�����R�����g</TD>
		</TR>
		<TR>
			<TD>
				<SELECT STYLE="width:600px" NAME="selectMenuList" SIZE="7">
<%
	For i = 0 To lngMenuCmtCnt - 1
%>
					<OPTION VALUE="<%= vntMenuCmtSeq(i) %>"><%= vntMenuCmtStc(i) %></OPTION>
<%
	Next
%>
				</SELECT>
			</TD>
			<TD VALIGN="top">
				<TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','add')">�ǉ�</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','insert')">�}��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','edit')">�C��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','delete')">�폜</A></TD>
                        </TR>
                    <%  end if  %>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<SPAN ID="FoodList">
		<INPUT TYPE="hidden" NAME="FoodCmtCnt" VALUE="<%= lngFoodCmtCnt %>">
<%
For i = 0 To lngFoodCmtCnt - 1
%>
		<INPUT TYPE="hidden" NAME="FoodCmtSeq"  VALUE="<%= vntFoodCmtSeq(i) %>">
		<INPUT TYPE="hidden" NAME="FoodCmtCd"   VALUE="<%= vntFoodCmtCd(i) %>">
		<INPUT TYPE="hidden" NAME="FoodCmtStc"  VALUE="<%= vntFoodCmtStc(i) %>">
		<INPUT TYPE="hidden" NAME="FoodClassCd" VALUE="<%= vntFoodClassCd(i) %>">
<%
Next
%>
	</SPAN>
	<SPAN ID="MenuList">
		<INPUT TYPE="hidden" NAME="MenuCmtCnt" VALUE="<%= lngMenuCmtCnt %>">
<%
For i = 0 To lngMenuCmtCnt - 1
%>
		<INPUT TYPE="hidden" NAME="MenuCmtSeq"  VALUE="<%= vntMenuCmtSeq(i) %>">
		<INPUT TYPE="hidden" NAME="MenuCmtCd"   VALUE="<%= vntMenuCmtCd(i) %>">
		<INPUT TYPE="hidden" NAME="MenuCmtStc"  VALUE="<%= vntMenuCmtStc(i) %>">
		<INPUT TYPE="hidden" NAME="MenuClassCd" VALUE="<%= vntMenuClassCd(i) %>">
<%
Next
%>
	</SPAN>
</FORM>
</BODY>
</HTML>
