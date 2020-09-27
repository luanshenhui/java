<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �S���ғo�^ (Ver0.0.1)
'       AUTHER  : Keiko Fujii@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MENDOC_ITEMCD = "30950"       '�ʐڈ�@�������ڃR�[�h
Const MENDOC_SUFFIX = "00"          '�ʐڈ�@�T�t�B�b�N�X
Const JUDDOC_ITEMCD = "30910"       '�����@�������ڃR�[�h
Const JUDDOC_SUFFIX = "00"          '�����@�T�t�B�b�N�X
Const KANDOC_ITEMCD = "30960"       '�Ō�t�@�������ڃR�[�h
Const KANDOC_SUFFIX = "00"          '�Ō�t�@�T�t�B�b�N�X
Const EIDOC_ITEMCD  = "30970"       '�h�{�m�@�������ڃR�[�h
Const EIDOC_SUFFIX  = "00"          '�h�{�m�@�T�t�B�b�N�X
'### 2004.02.20 Mod by Ishihara@FSIT �R�[�h������Ă���
Const SHINDOC_ITEMCD = "39230"      '�f�@��@�������ڃR�[�h
Const SHINDOC_SUFFIX = "00"         '�f�@��@�T�t�B�b�N�X
Const NAIDOC_ITEMCD = "23320"       '��������@�������ڃR�[�h
Const NAIDOC_SUFFIX = "00"          '��������@�T�t�B�b�N�X
'Const SHINDOC_ITEMCD = "30980"      '�f�@��@�������ڃR�[�h
'Const SHINDOC_SUFFIX = "00"        '�f�@��@�T�t�B�b�N�X
''### 2003.12.22 add start
'Const NAIDOC_ITEMCD = "30990"      '��������@�������ڃR�[�h
'Const NAIDOC_SUFFIX = "00"         '��������@�T�t�B�b�N�X
''### 2003.12.22 add end
'### 2004.02.20 Mod End

Const JUDDOC_ITEMTYPE = 0           '�����@���ڃ^�C�v

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSentence         '���͏��A�N�Z�X�p
Dim objResult           '�������ʏ��A�N�Z�X�p
Dim objHainsUser        '���[�U���A�N�Z�X�p

Dim strHTML             'HTML �i�[�̈�

'�p�����[�^
Dim strAct              '�������

Dim strRsvNo            '�\��ԍ�

'UpdateResult_tk �p�����[�^
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResult           '��������
Dim vntRslCmtCd1        '���ʃR�����g�P
Dim vntRslCmtCd2        '���ʃR�����g�Q
Dim strIPAddress        'IP�A�h���X

Dim strArrJudDocIndex()     '�C���f�b�N�X
Dim strArrJudDocItemCd()    '�������ڃR�[�h
Dim strArrJudDocSuffix()    '�T�t�B�b�N�X
Dim strArrSentenceCd()      '���̓R�[�h
Dim strArrJudDocName()      '����㖼��
Dim lngFlgChk               '�����t���O�`�F�b�N����

Dim strMenFlg           '�ʐڈ�t���O
Dim strHanFlg           '�����t���O
Dim strKanFlg           '�Ō�t�t���O
Dim strEiFlg            '�h�{�m�t���O
Dim strShinFlg          '�f�@��t���O
'### 2003.12.22 add start
Dim strNaiFlg           '��������t���O
Dim strSentenceCd       '���[�U�Ή����̓R�[�h
'### 2003.12.22 add end

Dim lngDocIndex         '�C���f�b�N�X
Dim strShortStc         '������


Dim strUserId           '���[�U�h�c
Dim strUserName         '���[�U��

Dim RetSentence         '���͌������A�l
Dim strMessage          '���ʓo�^���A�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSentence = Server.CreateObject("HainsSentence.Sentence")
Set objResult = Server.CreateObject("HainsResult.Result")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")

'�p�����[�^�l�̎擾
strAct       = Request("action")
strRsvNo     = Request("rsvno")
lngDocIndex  = Request("judDocIndex")

strUserId        = Session.Contents("userId")

lngDocIndex = IIf( lngDocIndex="", 0, lngDocIndex )

strIPAddress      = Request.ServerVariables("REMOTE_ADDR")


'����㖼�̂̔z��쐬
Call CreateJudDocInfo()

Do

    '�m��
    If strAct = "save" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = strArrJudDocItemCd(lngDocIndex)

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = strArrJudDocSuffix(lngDocIndex)

        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strArrSentenceCd(lngDocIndex)

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)
'## 2003.11.16 Mod By T.Takagi@FSIT
'       strMessage = objResult.UpdateRsl_tk( _
'                           strUserId, _
'                           strIPAddress, _
'                           strRsvNo, _
'                           vntItemCd, _
'                           vntSuffix, _
'                           vntResult, _
'                           vntRslCmtCd1, _
'                           vntRslCmtCd2 _
'                         ) 
'           Err.Raise 1000, , strRsvNo & " " & strIPAddress & " " & strUserId & " " & vntItemCd(0) & " " & vntSuffix(0) & " " & vntResult(0)
        objResult.UpdateResult strRsvNo, strIPAddress, strUserId, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage
'## 2003.11.16 Mod End

        If Not IsEmpty(strMessage) Then
            Err.Raise 1000, , strMessage(0) & " " & vntResult(0)
            Err.Raise 1000, , "�S���҂̓o�^���ł��܂���ł����B"
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

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ����㖼�̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateJudDocInfo()

    '���[�U���ǂݍ���
    If strUserId <> "" Then
        '### ��������t���O(strNaiFlg) �ǉ� 2003.12.22 
        objHainsUser.SelectHainsUser strUserId, strUserName, _
                                      , , , , , , , , , , _
                                      , , , , , , , _
                                     strMenFlg, strHanFlg, strKanFlg, _
                                     strEiFlg, strShinFlg, , , , strNaiFlg, strSentenceCd
    End If


    lngFlgChk = 0

    '�ʐڈ�ΏہH
    If strMenFlg = 1 Then

        '�ʐڈ�Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( MENDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, MENDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = MENDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = MENDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "�ʐڈ�"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '�����ΏہH
    If strHanFlg = 1 Then
        '�����Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( JUDDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, JUDDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = JUDDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = JUDDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "�����"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '�Ō�t�ΏہH
    If strKanFlg = 1 Then
        '�Ō�t�Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( KANDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, KANDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = KANDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = KANDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "�Ō�t"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '�h�{�m�ΏہH
    If strEiFlg = 1 Then
        '�h�{�m�Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( EIDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, EIDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = EIDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = EIDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "�h�{�m"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '�f�@��ΏہH
    If strShinFlg = 1 Then
        '�f�@��Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( SHINDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, SHINDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = SHINDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = SHINDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "�f�@��"
            lngFlgChk = lngFlgChk + 1
        End If
    End If

    '#### 2003.12.22 add start 
    '��������ΏہH
    If strNaiFlg = 1 Then
        '��������Ƃ��ĕ��̓e�[�u���ɓo�^����Ă��邩�`�F�b�N
        '���͎Q�ƃR�[�h�Ō������郂�[�h�ǉ��@2004.01.02
        RetSentence = objSentence.SelectSentence( NAIDOC_ITEMCD, _
                                    JUDDOC_ITEMTYPE, _
                                    strSentenceCd, _
                                    strShortStc, _
                                    , , , , , , , , , _
                                    1, NAIDOC_SUFFIX _
                                )
        If RetSentence = True Then
            Redim Preserve strArrJudDocIndex(lngFlgChk)
            Redim Preserve strArrJudDocItemCd(lngFlgChk)
            Redim Preserve strArrJudDocSuffix(lngFlgChk)
            Redim Preserve strArrJudDocName(lngFlgChk)
            Redim Preserve strArrSentenceCd(lngFlgChk)

            strArrJudDocItemCd(lngFlgChk) = NAIDOC_ITEMCD
            strArrJudDocSuffix(lngFlgChk) = NAIDOC_SUFFIX
            strArrSentenceCd(lngFlgChk) = strSentenceCd

            strArrJudDocIndex(lngFlgChk) = lngFlgChk:strArrJudDocName(lngFlgChk) = "��������"
            lngFlgChk = lngFlgChk + 1
        End If
    End If
    '#### 2003.12.22 add end 

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�S���ғo�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    function saveAuther(){


/** 2006/03/08 �� �S���ҕ��ރ`�F�b�N�L���̊m�F�̈גǉ� Start **/
/**               �`�F�b�N����Ă��Ȃ��ƃG���[���b�Z�[�W�\�� **/
        var objRadio = document.entryForm;
        var j = 0;

        for(i=0 ; i < objRadio.elements.length ; i++)
        {
            if(objRadio.elements[i].type == "radio" || objRadio.elements[i].type == "RADIO" )
            {
                if(objRadio.elements[i].checked == true) {
                    j = j + 1;
                }
            }
        }
        if(j == 0){
            alert("�Y������y�@�S���ҋ敪�@�z��I�����Ă��������B");
            return;
        }
/** 2006/03/08 �� �S���ҕ��ރ`�F�b�N�L���̊m�F�̈גǉ� End   **/
        
        document.entryForm.action.value = "save";
        document.entryForm.submit();

/** 2006/03/08 �� �S���ҕ��ނ��R���{���X�g�{�b�N�X�Ή��̏ꍇ�A�ēx�m�F���b�Z�[�W�\���ׁ̈A�ǉ� Start **/
        /**
        var doctorKind;
        with(document.entryForm){
            doctorKind = judDocIndex.options[judDocIndex.selectedIndex].text;
            if(confirm("<%= strUserName %>������@�y�@"+doctorKind+"�@�z�@�Ƃ��ēo�^���܂��B\n�ۑ����܂����H")){
                document.entryForm.action.value = "save";
                document.entryForm.submit();
            }else{
                return;
            }
        }
        **/
/** 2006/03/08 �� �S���ҕ��ނ��R���{���X�g�{�b�N�X�Ή��̏ꍇ�A�ēx�m�F���b�Z�[�W�\���ׁ̈A�ǉ� End   **/

    }

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= strRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�S���ғo�^</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    ���݂̒S���҂́A<%= strUserName %>����ł��B<BR>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<%
            If lngFlgChk = 0 Then
%>
                <TD><%= strUserName %>����ɑΉ����锻���h�c���o�^����Ă��܂���B�Ǘ��҂ɘA�����Ă��������B</TD>
<% 
            Else
%>
                <!--TD><%= strUserName %>�����<%= EditDropDownListFromArray("judDocIndex", strArrJudDocIndex, strArrJudDocName, lngDocIndex, NON_SELECTED_DEL) %>�Ƃ��ēo�^���܂��B�@��낵���ł����H</TD-->

                <TD nowrap><%= strUserName %>�����&nbsp;&nbsp;</TD>
                <TD bgcolor="#cccccc" width="100" nowrap><%= EditRadioFromArray("judDocIndex", strArrJudDocIndex, strArrJudDocName, lngDocIndex, NON_SELECTED_ADD) %></TD>
                <TD nowrap>&nbsp;&nbsp;�Ƃ��ēo�^���܂��B�@��낵���ł����H</TD>
<%
            End If
%>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
<%
            If lngFlgChk > 0 Then
%>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD>
                    <A HREF="javascript:saveAuther()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" border="0"></A>
                </TD>
            <%  end if  %>
<%
            End If
%>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��" border="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>