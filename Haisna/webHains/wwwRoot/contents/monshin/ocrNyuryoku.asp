<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR���͌��ʊm�F  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-103
'�C����  �F2010.06.03
'�S����  �FTCS)�c��
'�C�����e�F�n�b�q�V�[�g�ύX�Ή�
'�Ǘ��ԍ��FSL-SN-Y0101-607
'�C����  �F2011.12.13
'�S����  �FSOAR)�|���
'�C�����e�F�O�񕡎ʃ{�^��


Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objRslOcrSp         'OCR���͌��ʃA�N�Z�X�p
'#### 2010.06.03 SL-UI-Y0101-103 ADD START ####'
Dim objFree             'OCR���͌��ʃA�N�Z�X�p
Const CHECK_CSLDATE2    = "2010/01/01"    '�ėp�}�X�^�̐ݒ肪�Ȃ��ꍇ�p
Const FREECLASSCD_CHG   = "CHG"           '2011�N�Ή��@�ύX���t�擾�p

dim vntArrFree1
Dim strChgDate          '2011�N�Ή��@�ύX���t
'#### 2010.06.03 SL-UI-Y0101-103 ADD END ####'

'### 2008.03.26 �� ���茒�f�֘A��f���ڒǉ��ɂ��A��f���m�F��ʎd�l�ύX�̂���
'                  ���茒�f�J�n������ŉ�ʐؑ�
Const CHECK_CSLDATE     = "2008/04/01"    '��f���m�F��ʐؑ֊��
Const CHECK_CSCD        = "100"           '��f���m�F��ʐؑ֊�R�[�X�R�[�h�i1���l�ԃh�b�N�j

'### 2010.04.05 �� �E��������N�f�f�i�h�b�N�j�R�[�X�ǉ��ɂ��A�ǉ�
Const CHECK_CSCD_COMP   = "105"           '��f���m�F��ʐؑ֊�R�[�X�R�[�h�i�E��������N�f�f�i�h�b�N�j�j

'�p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strGrpNo            '�O���[�vNo
Dim strCsCd             '�R�[�X�R�[�h
Dim lngAnchor           '�\���J�n�ʒu

Dim strUrlPara          '�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
Dim strCslDate          '�t���[���ւ̃p�����[�^
Dim strCheckCSCD        '�R�[�X�R�[�h�擾
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp.OcrNyuryokuSp")
'#### 2010.06.03 SL-UI-Y0101-103 ADD START ####'
Set objFree         = Server.CreateObject("HainsFree.Free")

'�ėp�}�X�^���؂�ւ����擾
if objFree.SelectFreeByClassCd( 0,FREECLASSCD_CHG, , , , vntArrFree1 )  > 0 then
    strChgDate = vntArrFree1(0)
End if
If strChgDate = "" Then
    strChgDate = CHECK_CSLDATE2
End If
 '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####'

'�����l�̎擾
strWinMode      = Request("winmode")
strGrpNo        = Request("grpno")
lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
lngAnchor       = CLng("0" & Request("anchor"))

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?rsvno=" & lngRsvNo

'�t���[���̕\���J�n�ʒu�ݒ�
Select Case lngAnchor
Case 1
    strUrlPara = strUrlPara & "&anchor=Anchor-DiseaseHistory"
Case 2
    strUrlPara = strUrlPara & "&anchor=Anchor-LifeHabit1"
Case 3
    strUrlPara = strUrlPara & "&anchor=Anchor-LifeHabit2"
Case 4
    strUrlPara = strUrlPara & "&anchor=Anchor-Fujinka"
Case 5
    strUrlPara = strUrlPara & "&anchor=Anchor-Syokusyukan"
Case 6
    strUrlPara = strUrlPara & "&anchor=Anchor-Morning"
Case 7
    strUrlPara = strUrlPara & "&anchor=Anchor-Lunch"
Case 8
    strUrlPara = strUrlPara & "&anchor=Anchor-Dinner"
'### 2008.03.25 �� ���茒�f���ڒǉ��ɂ���Ēǉ� Start ###
Case 9
    strUrlPara = strUrlPara & "&anchor=Anchor-Special"
'### 2008.03.25 �� ���茒�f���ڒǉ��ɂ���Ēǉ� End   ###

'### 2016.03.31 �� �������֘A���ڕ\���̈גǉ� Start ###
Case 10
    strUrlPara = strUrlPara & "&anchor=Anchor-Stomach"
'### 2016.03.31 �� �������֘A���ڕ\���̈גǉ� End   ###

End Select

'### 2008.03.25 �� �\��ԍ����L�[�ɂ��ĊY����f�҂̎�f�����擾���A�Y����f���ɍ��킹�Ė�f�o�^��ʕ\�����邽�߂ɒǉ� ###
strCslDate = objRslOcrSp.CheckCslDate(lngRsvNo,strCheckCSCD)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>OCR���͌��ʊm�F</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �G���[���͊e�t���[���ŋ���
var lngErrCount;        // �G���[��
var varErrNo;           // �G���[No
var varErrState;        // �G���[���
var varErrMessage;      // �G���[���b�Z�[�W

// �G���[���̏�����
function initErrInfo() {

    // �G���[���̏�����
    lngErrCount = 0;
    varErrNo = new Array();
    varErrState = new Array();
    varErrMessage = new Array();
    varErrState.length = 0;
    varErrMessage.length = 0;
}

// �G���[���ǉ�
function addErrInfo(no, state, message) {

    varErrNo.length ++;
    varErrState.length ++;
    varErrMessage.length ++;
    varErrNo[lngErrCount] = no;
    varErrState[lngErrCount] = state;
    varErrMessage[lngErrCount] = message;
    lngErrCount ++;
}

// SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� Start
// �G���[���폜
function delErrInfo(no, state, message) {
    for(i = 0; i < varErrMessage.length; i++){
        if(varErrMessage[i] == message){
            lngErrCount --;
            varErrMessage.splice(i,1);
            varErrNo.splice(i,1); 
            varErrState.splice(i,1); 
            break;
        }
    }
}
// SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� End

var params = {
    winmode: "<%= strWinMode %>",
    grpno:   "<%= strGrpNo %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    nomsg:   ""
};
//-->
</SCRIPT>
</HEAD>
    <FRAMESET ROWS="130,*,100">
<%
'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
    '�ؑ֓��ȍ~�̎�f���ł����2012�N�ŗp�̉�ʂ�
    If IsVer201210(lngRsvNo) Then
%>
        <FRAME NAME="header" SRC="ocrNyuryokuSpHeader201210.asp<%= strUrlPara %>">
        <FRAME NAME="list"   SRC="ocrNyuryokuSpBody201210.asp<%= strUrlPara %>">
        <FRAME NAME="error"  SRC="ocrNyuryokuSpErr201210.asp<%= strUrlPara %>">
<%
    Else
'## 2012.09.11 Add End
%>
    <!--#### 2008.03.25 �� ��f���ɂ���Ė�f���m�F��ʂ�؂�ւ���悤�ɏC�� Start ####-->

    <!--#### 2010.04.05 �� �E��������N�f�f�i�h�b�N�j�R�[�X�ǉ��ɂ��A�C�� Start ####-->
    <%  'If CDate(strCslDate) >= CDate(CHECK_CSLDATE) and strCheckCSCD = CHECK_CSCD Then     %>
    <%  If CDate(strCslDate) >= CDate(CHECK_CSLDATE) and (strCheckCSCD = CHECK_CSCD or strCheckCSCD = CHECK_CSCD_COMP) Then     %>
    <!--#### 2010.04.05 �� �E��������N�f�f�i�h�b�N�j�R�[�X�ǉ��ɂ��A�C�� End   ####-->
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD START ####' %>
        <% 'OCR�V�[�g�ύX�Ή� �����N����ǉ��@%>
        <%  If CDate(strCslDate) >= CDate(strChgDate)  Then     %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader2.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody2.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr2.asp<%= strUrlPara %>">
        <%  Else     %>
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####' %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr.asp<%= strUrlPara %>">
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD START ####' %>
        <%  End If     %>
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####' %>
    <%  Else     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD START ####' %>
        <% 'OCR�V�[�g�ύX�Ή� �����N����ǉ��@%>
        <%  If CDate(strCslDate) >= CDate(strChgDate)  Then     %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader2.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody2.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr2.asp<%= strUrlPara %>">
        <%  Else     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD END ####' %>
            <FRAME NAME="header" SRC="ocrNyuryokuHeader.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuBody.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuErr.asp<%= strUrlPara %>">
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD START ####' %>
        <%  End If     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD END ####' %>
    <%  End If     %>
    <!--#### 2008.03.25 �� ��f���ɂ���Ė�f���m�F��ʂ�؂�ւ���悤�ɏC�� End   ####-->
<%
'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
    End If
%>
        <NOFRAMES>
            <BODY BGCOLOR="#ffffff">
                <P></P>
            </BODY>
        </NOFRAMES>
    </FRAMESET>
</HTML>
