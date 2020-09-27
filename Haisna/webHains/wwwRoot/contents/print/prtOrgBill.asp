<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	�������i�c�́j (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim UID
Dim strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strOrgCd1, strOrgCd2			'������c�̃R�[�h
Dim strBillNo					'�������ԍ�
Dim strObject					'�o�͑Ώ�
Dim strDelFlg					'����`�[
Dim strSort						'�o�͏�
Dim strBillNote					'�������ē���
'<!--  2004/06/22 ADD STR ORB)R.ARAKI  �敪���ڒǉ�  -->
Dim strKbn					'�敪
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->

'��������������������
'��Ɨp�ϐ�
Dim strOrgName		'�c�̖�
Dim strSCslDate		'�J�n��
Dim strECslDate		'�I����


'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '���ʓ��̕������HTML���ŋL�q�������ڂ̖��̂ƂȂ�܂�

'�� �J�n�N����
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())				'�J�n�N
        strSCslMonth  = Month(Now())			'�J�n��
        strSCslDay    = Day(Now())				'�J�n��
    Else
        strSCslYear   = Request("strCslYear")	'�J�n�N
        strSCslMonth  = Request("strCslMonth")	'�J�n��
        strSCslDay    = Request("strCslDay")	'�J�n��
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
    If IsEmpty(Request("endCslYear")) Then
        strECslYear   = Year(Now())				'�I���N
        strECslMonth  = Month(Now())			'�J�n��
        strECslDay    = Day(Now())				'�J�n��
    Else
        strECslYear   = Request("endCslYear")	'�I���N
        strECslMonth  = Request("endCslMonth")	'�J�n��
        strECslDay    = Request("endCslDay")	'�J�n��
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay

'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")	'�J�n�N
        strECslMonth  = Request("strCslMonth")	'�J�n��
        strECslDay    = Request("strCslDay")	'�J�n��
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If

'�� �c��
    strOrgCd1     = Request("orgCd1")		'�c�̃R�[�h�P
    strOrgCd2     = Request("orgCd2")		'�c�̃R�[�h�Q
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'		objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
    End If

'�� �������ԍ�
    strBillNo	= Request("BillNo")		'�������ԍ�

'�� �o�͑Ώ�
    strObject	= Request("Object")		'�o�͑Ώ�

'�� ����`�[
    strDelflg	= Request("Delflg")		'����`�[

'�� �ē���
    strBillNote = Request("billNote")		'����`�[

'<!--  2004/06/22 ADD STR ORB)R.ARAKI  �敪���ڒǉ�  -->
'�� �敪
    strKbn = Request("Kbn")				'�敪
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->

'��������������������
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
    Dim aryChkString
    
    aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

    '�����Ƀ`�F�b�N�������L�q
    With objCommon

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
            End If
        End If

'		If (Len(Trim(strBillNo)) <> 14) And (Trim(strBillNo) <> "") Then
'			.AppendArray vntArrMessage, "�������������ԍ�����͂��Ă��������B(14���j"
'		End If

    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objPrintCls	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim Ret			'�֐��߂�l

    Dim strURL

    If Not IsArray(CheckValue()) Then

		Dim referer	'URL�ƃp�����[�^�ɕ����������t�@��
		Dim ary		'URL��"/"�ŕ��������z��
		
		'���t�@����URL�ƃp�����[�^�ɕ���
		referer = Split(Request.ServerVariables("HTTP_REFERER"), "?")
		
		'URL��"/"�ŕ���
		ary = Split(referer(0), "/")
		
		'���t�@���̃t�@�C��������o�͂��郍�O������
		Select Case ary(Ubound(ary))
			Case "dmdBurdenModify.asp"
				'���R�����΍��p���O�����o��
				Call putPrivacyInfoLog("PH047", "�c�̐�������{����� �������̈�����s����")
			Case Else
				'���R�����΍��p���O�����o��
				Call putPrivacyInfoLog("PH036", "�������̈�����s����")
		End Select

        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsprtOrgBill.prtOrgBill")

        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'<!--  2004/06/22 UPD STR ORB)R.ARAKI  �敪���ڒǉ�  -->
'		Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, strOrgCd1, strOrgCd2, strBillNo, strObject, strDelflg, strBillNote)
        Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, strOrgCd1, strOrgCd2, strBillNo, strObject, strDelflg, strBillNote, strKbn)
'<!--  2004/06/22 ADD END ORB)R.ARAKI  -->
        print=Ret


    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->
<TITLE>�������i�c�́j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setBillNote() {

    var wk_billNote;
    
    with ( document.entryForm ) {

        if ( billNoteDiv.value == 1 ) {
            wk_billNote = ''
            wk_billNote = wk_billNote + '�q�[�@�M�Ђ܂��܂������˂̂��ƂƂ���ѐ\���グ�܂��B\n';
            wk_billNote = wk_billNote + '�������@�l�ԃh�b�N�������p�����������肪�Ƃ��������܂��B\n';
            wk_billNote = wk_billNote + '���āA�挎�ɂ��󂯂����������l�ԃh�b�N�̐�������������\���グ�܂��B\n';
            wk_billNote = wk_billNote + '���m�F�̏�A�w������܂ł������������܂��悤���肢�\���グ�܂��B\n';
            wk_billNote = wk_billNote + '����Ƃ��A����w�̂����������܂��悤���肢�\���グ�܂��B\n';
            wk_billNote = wk_billNote + '�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�h��';
            billNote.value = wk_billNote;

        }

        if ( billNoteDiv.value == 2 ) {
//### 2015.12.01 �� �ē����Q�ɌŒ蕶�̓f�t�H���g�\�� START ###################################################################
//            billNote.value = '';
            wk_billNote = ''
            wk_billNote = wk_billNote + '�q�[�@�M�Ђ܂��܂������˂̂��ƂƂ���ѐ\���グ�܂��B\n';
            wk_billNote = wk_billNote + '�������@�l�ԃh�b�N�������p�����������肪�Ƃ��������܂��B\n';
            wk_billNote = wk_billNote + '���āA�挎�ɂ��󂯂����������l�ԃh�b�N�̐�������������\���グ�܂��B\n';
            wk_billNote = wk_billNote + '���m�F�̏�A�w������܂ł������������܂��悤���肢�\���グ�܂��B\n';
            wk_billNote = wk_billNote + '����Ȃ���A�x�������͂���f���̗������܂łƂ����Ă��������܂��B\n';
            wk_billNote = wk_billNote + '����Ƃ��A����w�̂����������܂��悤���肢�\���グ�܂��B\n';
            wk_billNote = wk_billNote + '�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�h��';
            billNote.value = wk_billNote;
//### 2015.12.01 �� �ē����Q�ɌŒ蕶�̓f�t�H���g�\�� END   ###################################################################
        }

    }

}
// �G�������g�̎Q�Ɛݒ�
function setElement() {

    with ( document.entryForm ) {

        // �c�́E�������G�������g�̎Q�Ɛݒ�i���͍��ڂɒc�́E�����������ꍇ�͕s�v�j
        orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );

    
    }

}
//-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement();setBillNote();checkRunState();">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
    <INPUT TYPE="hidden" NAME="runstate" VALUE="">
    <BLOCKQUOTE>
<!--- �^�C�g�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN>�������i�c�́j</B></TD>
        </TR>
    </TABLE>
    <BR>

<%
'�G���[���b�Z�[�W�\��
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>������</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
                        <TD>��</TD>
                        <TD>�`</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!-- �������� -->
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>������</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
                        <TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
                        <TD NOWRAP><SPAN ID="orgName"></SPAN>
                            <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
                            <INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!-- �������ԍ� -->
        <TR>
            <TD><font color="black">��</font></TD>
            <TD WIDTH="90" NOWRAP>�������ԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="BillNo" MAXLENGTH="14" SIZE="20" VALUE="<%= strBillNo %>"></TD>
        </TR>
        <!--�����Ώ�-->
        <TR>
            <TD><font color="black">��</font></TD>
            <TD WIDTH="90" NOWRAP>�����Ώ�</TD>
            <TD>�F</TD>
            <TD>
                <select name="Object" size="1">
                    <option selected value="1">�S�ďo��</option>
                    <option value="2">������̂�</option>
                    <option value="3">����ς̂�</option>
                </select>
            </TD>
        </TR>
        <!--����`�[-->
        <TR>
            <TD><font color="black">��</font></TD>
            <TD WIDTH="90" NOWRAP>����`�[</TD>
            <TD>�F</TD>
            <TD>
                <select name="Delflg" size="1">
                    <option selected value="2">�o�͂��Ȃ�</option>
                    <option value="1">�o�͂���</option>
                </select>
            </TD>
        </TR>
        <!--�R�����g-->
        <TR>
            <TD ROWSPAN="2" VALIGN="TOP"><font color="black">��</font></TD>
            <TD ROWSPAN="2" VALIGN="TOP" WIDTH="90" NOWRAP>�ē���</TD>
            <TD ROWSPAN="2" VALIGN="TOP">�F</TD>
            <TD>
                <select name="billNoteDiv" size="1" ONCHANGE="javascript:setBillNote()">
                    <option selected value="1">�ē����P</option>
                    <option value="2">�ē����Q</option>
                </select>
            </TD>
        </TR>
        <TR>
            <TD COLSPAN="15">
                <TEXTAREA NAME="billNote" ROWS="10" COLS="80" WRAP="SOFT"></TEXTAREA>
            </TD>
        </TR>
        
<!--  2004/06/22 ADD STR ORB)R.ARAKI  -->
        <!--- �敪 -->
        
        <TR>
            <TD><font color="black">��</font></TD>
            <TD WIDTH="90" NOWRAP>�敪</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="0" <%= "CHECKED" %> >�P��</TD>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="1" >�Q��</TD>
                        <TD><INPUT TYPE="Radio" NAME="Kbn" VALUE="2" >�S��</TD>
                    </TR>
                </TABLE>
            </TD>			
        </TR>
<!--  2004/06/22 ADD END ORB)R.ARAKI  -->
        
        
    </TABLE>
<BR>
<!--- ������[�h -->
<%
    '������[�h�̏����ݒ�
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
            <TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
            <TD NOWRAP>�v���r���[</TD>

            <TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
            <TD NOWRAP>���ڏo��</TD>
        </TR>
--><!--  2003/02/27  DEL  END    E.Yamamoto  -->
                </TABLE>

    <BR><BR>

<!--- ����{�^�� -->
    <!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
    <%  End if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>