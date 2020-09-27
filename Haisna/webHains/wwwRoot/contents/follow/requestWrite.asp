<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[�K�C�h (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const DOKUMENT_DATAPATH = "D:\webHains\wwwRoot\FollowDocument\"
Const PRT_DIV = 1         '�l�����ށF�˗���

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p
Dim objConsult          '��f�N���X
Dim objWord
Dim objDoc

'�p�����[�^

Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '���蕪�ރR�[�h
Dim strJudClassName     '���f���ޖ�
Dim strSecEquipName     '�a��@��

Dim strFolItem1         '�f�f�E�˗����ڂP
Dim strFolItem2         '�f�f�E�˗����ڂQ
Dim strFolNote1         '�����P
Dim strFolNote2         '�����Q

'��f���p�ϐ�
Dim strCslDate          '��f��
Dim strPerId            '�lID
Dim strDayId            '����ID
Dim strName             '����
Dim strKName            '�J�i��
Dim strBirth            '���N����
Dim strGender           '����
Dim strAge              '���N��
Dim strUpdUser          '�X�V��ID

Dim blnCount            '�߂�l
Dim strSeq              '�o�^����
Dim strFileName         '�o�^���ꂽ�t�@�C����
Dim strAddDate          '�o�^��
Dim strAddUser          '�o�^��(�쐬��)
Dim strAddUserName      '�X�V�Җ�
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFollow     = Server.CreateObject("HainsFollow.Follow")

'�p�����[�^�l�̎擾
lngRsvNo        = Request("rsvno")
lngJudClassCd   = Request("judClassCd")
strJudClassName = Request("judClassName")
strSecEquipName = Request("hospital")

strFolItem1     = Request("folItem1")
strFolItem2     = Request("folItem2")
strFolNote1     = Request("folNote1")
strFolNote2     = Request("folNote2")

strCslDate      = Request("cslDate")
strPerId        = Request("perId")
strAge          = Request("age")
strDayId        = Request("dayId")
strName         = Request("name")
strKname        = Request("kName")
strBirth        = Request("birth")
strGender       = Request("gender")

strUpdUser     = Request("userId")


Do
    blnCount = objFollow.InsertReqHistory(lngRsvNo, _
                                          lngJudClassCd, _
                                          PRT_DIV, _
                                          strCslDate, _
                                          strUpdUser, _
                                          strSeq, _
                                          strFileName, _
                                          strAddDate, _
                                          strAddUser, _
                                          strAddUserName _
                                         )

    If blnCount = False Then
        Err.Raise 1000, , "�˗���쐬���A�G���[���������܂����B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    Exit Do
Loop


    Set objWord = CreateObject("Word.Application")
    Set objDoc = CreateObject("Word.Document")
        objWord.visible = False
        objDoc = objWord.Documents.Open(DOKUMENT_DATAPATH & "request.doc")
        
        Set myRange = objDoc.Bookmarks("HOSPITAL1").Range
        myRange.text = strSecEquipName
        Set myRange = objWordDoc.Bookmarks("NAME1").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("PRINTDATE").Range
        myRange.text = strAddDate
        Set myRange = objDoc.Bookmarks("HOSPITAL2").Range
        myRange.text = strSecEquipName
        Set myRange = objWordDoc.Bookmarks("NAME2").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("KNAME1").Range
        myRange.text = strKname
        Set myRange = objDoc.Bookmarks("GENDER1").Range
        myRange.text = strGender
        Set myRange = obj.Bookmarks("AGE1").Range
        myRange.text = strAge
        Set myRange = objDoc.Bookmarks("BIRTH1").Range
        myRange.text = strBirth
        Set myRange = objDoc.Bookmarks("CSLDATE1").Range
        myRange.text = strCslDate
        Set myRange = objDoc.Bookmarks("DAYID1").Range
        myRange.text = strDayId
        Set myRange = objDoc.Bookmarks("PERID1").Range
        myRange.text = strPerId
        Set myRange = objDoc.Bookmarks("ITEM1").Range
        myRange.text = strFolItem1
        Set myRange = objDoc.Bookmarks("NOTE1").Range
        myRange.text =strFolNote1
        Set myRange = objDoc.Bookmarks("ITEM2").Range
        myRange.text = strFolItem2
        Set myRange = objDoc.Bookmarks("NOTE2").Range
        myRange.text = strFolNote2
        Set myRange = objWordDoc.Bookmarks("DOCTOR1").Range
        myRange.text = strAddUserName
        Set myRange = objWordDoc.Bookmarks("DOCTOR2").Range
        myRange.text = strAddUserName
        Set myRange = objDoc.Bookmarks("NAME3").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("KNAME2").Range
        myRange.text = strKname
        Set myRange = obj.Bookmarks("GENDER2").Range
        myRange.text = strGender
        Set myRange = objDoc.Bookmarks("AGE2").Range
        myRange.text = strAge
        Set myRange = objDoc.Bookmarks("BIRTH2").Range
        myRange.text = strBirth
        Set myRange = objDoc.Bookmarks("CSLDATE2").Range
        myRange.text = strCslDate
        Set myRange = objDoc.Bookmarks("DAYID2").Range
        myRange.text = strDayId
        Set myRange = objDoc.Bookmarks("PERID2").Range
        myRange.text = strPerId
        Set myRange = nothing
        objWordDoc.SaveAs Application(DOKUMENT_DATAPATH & strFileName)
        objWord.Documents.Close
        objWord.Application.Quit
        Set objDoc = nothing
        Set objWord = nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�˗���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    var winWriteLetter;

function writeExecute() {
    var url;                         // URL������

    url = '/WebHains/FollowDocument/requestViewLetter.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
}


</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff" onload="javascript:writeExecute()">

<table height="100%" width="100%">
    <tr align="center" valign="center">
        <td align="right"><img src="/webHains/images/zzz.gif"></td>
        <td align='left'><b>�������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
