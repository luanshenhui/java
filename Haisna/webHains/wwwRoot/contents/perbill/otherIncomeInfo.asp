<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �Z�b�g�O�����ǉ��\�� (Ver0.0.1)
'       AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------

Dim objCommon               '���ʃN���X
Dim objPerbill              '��f���A�N�Z�X�p

Dim strDmdDate              '������
Dim lngBillSeq              '�������r����
Dim lngBranchNo             '�������}��

Dim Ret                     '�֐��߂�l

'�l���������p�ϐ�
Dim vntDmdDate              '������
Dim vntBillSeq              '�������r����
Dim vntBranchNo             '�������}��
Dim vntDelflg               '����`�[�t���O
Dim vntUpdDate              '�X�V����
Dim vntUpdUser              '���[�U�h�c
Dim vntUserName             '���[�U��������
Dim vntBillcoment           '�������R�����g
Dim vntPaymentDate          '������
Dim vntPaymentSeq           '�����r����
Dim vntPrice                '���z
Dim vntEditPrice            '�������z
Dim vntTaxPrice             '�Ŋz
Dim vntEditTax              '�����Ŋz
Dim vntLineTotal            '���v�i���z�A�������z�A�Ŋz�A�����Ŋz�j

Dim lngCount                '�擾����
Dim lngBillCount            '���������׏�����
Dim lngRsvNo                '�\��ԍ�

Dim strDivCd                '�Z�b�g�O�������׃R�[�h
Dim strDivName              '�Z�b�g�O�������ז���
Dim strLineName             '���ז���
Dim lngPrice                '���z
Dim lngEditPrice            '�������z
Dim lngTaxPrice             '�Ŋz
Dim lngEditTax              '�����Ŋz

Dim strMode                 '�������[�h
Dim strAction               '���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim i                       '�C���f�b�N�X
Dim strHTML
Dim strArrMessage           '�G���[���b�Z�[�W

strArrMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾
lngRsvNo       = Request("rsvno")
lngBillCount   = Request("billcount")

strDmdDate     = Request("dmddate")
lngBillSeq     = Request("billseq")
lngBranchNo    = Request("branchno")

strAction      = Request("act")
strMode        = Request("mode")

strDivCd       = Request("divcd")
strDivName     = Request("divname")
strLineName    = Request("linename")
lngPrice       = Request("price")
lngEditPrice   = Request("editprice")
lngTaxPrice    = Request("taxprice")
lngEditTax     = Request("edittax")


'�p�����^�̃f�t�H���g�l�ݒ�
    lngPrice     = IIf(lngPrice = "", 0, lngPrice )
    lngEditPrice = IIf(lngEditPrice = "", 0, lngEditPrice )
    lngTaxPrice  = IIf(lngTaxPrice = "", 0, lngTaxPrice )
    lngEditTax   = IIf(lngEditTax = "", 0, lngEditTax )

Do

    '�m��{�^��������
    If strAction = "check" Then

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        If (lngBillCount = 0) OR (lngBillCount = 1) Then
            '���̂܂ܕۑ�������
            strAction = "save"

            If lngBillCount = 0 Then
                strDmdDate = ""
                lngBillSeq = 0
                lngBranchNo = 0
            End If

        Else
            '���������I����ʂ�
            strAction = "openwin"
            Response.Redirect "otherIncomeSub.asp?rsvno="&lngRsvNo&"&linename="&strLineName&"&price="&lngPrice&"&editprice="&lngEditPrice&"&taxprice="&lngTaxPrice&"&edittax="&lngEditTax&"&divcd="&strDivCd
            Response.end
        End If

    End If


    '�ۑ��������s
    If strAction = "save" Then
'Err.Raise 1000, , "mode = " & strMode

        '�l�������Ǘ��l���쐬�H
        If strMode = "person" Then

            '�Ăь���ʂ̊֐��Ăяo���Ď��g�����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'#### 2008.07.03 �� �Z�b�g�O�������׃R�[�h�𕶎���Ƃ��Ĉ����ׁi0010�Ȃǂ̃R�[�h�Ή��j�ɏC�� Start ####
'           strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) { opener.setOtherDiv( "
'           strHTML = strHTML &	strDivCd & ", '" & strLineName & "', '" & strDivName & "'," & lngPrice & "," & lngEditPrice & "," & lngTaxPrice & "," & lngEditTax
'           strHTML = strHTML & " ); } close();"">"
'           strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) { opener.setOtherDiv( '"
            strHTML = strHTML & strDivCd & "', '" & strLineName & "', '" & strDivName & "'," & lngPrice & "," & lngEditPrice & "," & lngTaxPrice & "," & lngEditTax
            strHTML = strHTML & " ); } close();"">"
            strHTML = strHTML & "</BODY>"
'#### 2008.07.03 �� �Z�b�g�O�������׃R�[�h�𕶎���Ƃ��Ĉ����ׁi0010�Ȃǂ̃R�[�h�Ή��j�ɏC�� End   ####
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End
            Exit Do

        Else

            ''' �l�������׏��o�^�p�Ƀp�����[�^�ǉ� 2003.12.18 
            '��f�m����z���A�l�������׏��̓o�^
            Ret = objPerbill.InsertPerBill_c(strDmdDate, _
                                            lngBillSeq, _
                                            lngBranchNo, _
                                            lngPrice, _
                                            lngEditPrice, _
                                            lngTaxPrice, _
                                            lngEditTax, _
                                            IIf( strDivName = strLineName, "", strLineName), _
                                            lngRsvNo, _
                                            strDivCd, _
                                            , strLineName )

            '�ۑ��Ɏ��s�����ꍇ
            If Ret <> True Then
                strArrMessage = Array("�Z�b�g�O�������ׂ̒ǉ��Ɏ��s���܂����B")
                Err.Raise 1000, , "�Z�b�g�O�������ׂ��ǉ��ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
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

    End If


    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������R�����g�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '���ʃN���X
    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��

    '���ʃN���X�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�e�l�`�F�b�N����
    With objCommon
        '�������R�����g�`�F�b�N
        If strDivCd = "" Then 
            .AppendArray vntArrMessage, "�Z�b�g�O�������ז��y�H�z��I�����ĉ������B"
        End If
        .AppendArray vntArrMessage, .CheckWideValue("�����ڍז�", strLineName, 40)
''' �}�C�i�X�̒l�����͉\�@2003.12.17
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("�������z", lngPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("�������z", lngEditPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("�����", lngTaxPrice, 7)
        .AppendArray vntArrMessage, objPerBill.CheckNumeric("�����Ŋz", lngEditTax, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("�������z", lngPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("�������z", lngEditPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("�����", lngTaxPrice, 7)
'       .AppendArray vntArrMessage, .CheckNumeric("�����Ŋz", lngEditTax, 7)
    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�Z�b�g�O�������דo�^�E�C��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

var winGuideOther;          // �E�B���h�E�n���h��
var Other_divCd;            // �Z�b�g�O���������׃R�[�h
var Other_divName;          // �Z�b�g�O���������ז�
var Other_lineName;         // ���������ז�
var Other_Price;            // �W���P��
var Other_TaxPrice;         // �W���Ŋz

function showOtherIncomeWindow( divCd, divName, price, taxPrice, lineName ) {

    var objForm = document.entryForm;   // ����ʂ̃t�H�[���G�������g

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩

    // �K�C�h�Ƃ̘A���p�ϐ��ɃG�������g��ݒ�
    Other_divCd     = divCd;
    Other_divName   = divName;
    Other_lineName  = lineName;
    Other_Price     = price;
    Other_TaxPrice  = taxPrice;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winGuideOther != null ) {
        if ( !winGuideOther.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/perbill/gdeOtherIncome.asp'

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winGuideOther.focus();
        winGuideOther.location.replace( url );
    } else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winGuideOther = window.open( url, '', 'width=640,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winGuideOther = window.open( url, '', 'width=400,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
    }
}

// �Z�b�g�O�������׏��ҏW�p�֐�
function setDivInfo( divCd, divName, price, taxPrice ) {

    // �Z�b�g�O�������׃R�[�h�̕ҏW
    if ( Other_divCd ) {
        Other_divCd.value = divCd;
    }

    // �Z�b�g�O�������ז��̕ҏW
    if ( Other_divName ) {
        Other_divName.value = divName;
        Other_lineName.value = divName;
    }

    if ( document.getElementById( 'dspdivname' ) ) {
        document.getElementById( 'dspdivname' ).innerHTML = divName;
    }

    // �W�����z�̕ҏW
    if ( Other_Price ) {
        Other_Price.value = price;
    }

    // �W���Ŋz�̕ҏW
    if ( Other_TaxPrice ) {
        Other_TaxPrice.value = taxPrice;
    }

}

// �K�C�h�����
function closeGuideOther() {

    if ( winGuideOther != null ) {
        if ( !winGuideOther.closed ) {
            winGuideOther.close();
        }
    }

    winGuideOther = null;

}

function checkData() {

    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'check';
    document.entryForm.submit();

}

function windowClose() {

    //�K�C�h�����
    closeGuideOther();
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�Z�b�g�O�������דo�^�E�C��</B></TD>
        </TR>
    </TABLE>
    <!-- ������� -->
    <INPUT TYPE="hidden" NAME="act" VALUE="">
    <INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

    <INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
    <INPUT TYPE="hidden" NAME="divname" VALUE="<%= strDivName %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="billcount" VALUE="<%= lngBillCount %>">
    <INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
    <INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
    <INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">
<%
'���b�Z�[�W�̕ҏW
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

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

    End If
%>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD NOWRAP >������</TD>
            <TD>�F</TD>
            <TD NOWRAP >�l��f</TD>
        </TR>
        <TR>
            <TD NOWRAP >�Z�b�g�O�������ז�</TD>
            <TD>�F</TD>
            <TD>
                <TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP ><A HREF="javascript:showOtherIncomeWindow(document.entryForm.divcd, document.entryForm.divname, document.entryForm.price, document.entryForm.taxprice, document.entryForm.linename )" ><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�Z�b�g�O�������׈ꗗ�\��"></A></TD>
                        <TD NOWRAP ><SPAN ID="dspdivname"><%= strDivName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP >�������ז�</TD>
            <TD>�F</TD>
            <TD>
                <TABLE WIDTH="120" BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP ><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP >�������z</TD>
            <TD>�F</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >�������z</TD>
            <TD>�F</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="editprice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >�����</TD>
            <TD>�F</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="taxprice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
        <TR>
            <TD NOWRAP >�����Ŋz</TD>
            <TD>�F</TD>
            <TD NOWRAP ><INPUT TYPE="text" NAME="edittax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="7"></TD>
        </TR>
    </TABLE>
    <BR>
    <A HREF="javascript:checkData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A>
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
</FORM>
</BODY>
</HTML>
