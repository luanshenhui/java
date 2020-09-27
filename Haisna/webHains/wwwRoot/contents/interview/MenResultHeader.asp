<%@ LANGUAGE="VBScript" %>
<%
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-003
'�C����  �F2010.08.09
'�S����  �FFJTH)KOMURO
'�C�����e�F�A�g��T�[�o���̕ϊ�
'========================================
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-305
'�C����  �F2011.07.01
'�S����  �FORB)YAGUCHI
'�C�����e�F�咰�R�c�|�b�s�A�򓮖������g�A�����d���A�������b�ʐρA�S�s�S�X�N���[�j���O�̒ǉ�
'========================================
'-----------------------------------------------------------------------------
'      �������ʕ\���i�w�b�_�j (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<!-- #### 2010.08.09 SL-HS-Y0101-003 ADD START   #### -->
<!-- #include virtual = "/webHains/includes/convertAddress.inc" -->
<!-- #### 2010.08.09 SL-HS-Y0101-003 ADD END     #### -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objInterView        '�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode          '�E�B���h�E���[�h
Dim strGrpNo            '�O���[�vNo
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strCsCd             '�R�[�X�R�[�h

Dim lngLastDspMode      '�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp            '�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntPerId            '�l�h�c
Dim vntRsvNo            '�\��ԍ�
Dim vntCslDate          '��f��
Dim vntCsCd             '�R�[�X�R�[�h
Dim vntCsName           '�R�[�X��
Dim vntCsSName          '�R�[�X����
Dim lngHisCount         '�\����

'�S�d�}�A�g�p
Dim strUrlEcgWave       'URL�i�S�d�}�g�`�j

'RayPax�A�g�p
Dim vntOrderNo          '�I�[�_�ԍ�
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
Dim vntSendDate         '���M��
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

'### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈גǉ� Start ###
Dim vntPerIdBefore      '�ύX�O�lID
Dim vntPerIdAfter       '�ύX��lID
Dim vntResultPerId      'RayPax�Ƀ����N����lID
'### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈גǉ� End   ###

Dim strUrlRayPaxReport  'URL�iRayPax���|�[�g�j
Dim strUrlRayPaxImage   'URL�iRayPax�摜�j

'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
Dim strUrlCaviAbiImage  'URL�i�����d���摜�j
'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode          = Request("winmode")
strGrpNo            = Request("grpno")
lngRsvNo            = Request("rsvno")
strCsCd             = Request("cscd")
strSelCsGrp         = Request("csgrp")
strSelCsGrp         = IIf(strSelCsGrp="", "0", strSelCsGrp)
lngEntryMode        = Request("entrymode")
lngEntryMode        = IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
lngHideFlg          = Request("hideflg")
lngHideFlg          = IIf(lngHideFlg="", "1", lngHideFlg)

'�O���[�v���擾
Call GetMenResultGrpInfo(strGrpNo)

Select Case strSelCsGrp
    '���ׂẴR�[�X
    Case "0"
        lngLastDspMode = 0
        vntCsGrp = ""
    '����R�[�X
    Case "1"
        lngLastDspMode = 1
        vntCsGrp = strCsCd
    Case Else
        lngLastDspMode = 2
        vntCsGrp = strSelCsGrp
End Select

Do
    '�w�肳�ꂽ�\��ԍ��̎�f���ꗗ���擾����
    lngHisCount = objInterView.SelectConsultHistory( _
                        lngRsvNo, _
                        False, _
                        lngLastDspMode, _
                        vntCsGrp, _
                        3, _
                        0, _
                        vntPerId, _
                        vntRsvNo, _
                        vntCslDate, _
                        vntCsCd, _
                        vntCsName, _
                        vntCsSName _
                        )
    If lngHisCount < 1 Then
        Err.Raise 1000, , "(" & lngLastDspMode & ")(" & vntCsGrp & ")"
        Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If

    '�\���{�^���������ɌĂяo����鎩��ʂ̊֐���ݒ肷��
    DispCalledFunction = "callMenResultTop()"

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������ʕ\��</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//�\��
function callMenResultTop() {

    // Top�ɑI�����ꂽ�R�[�X�O���[�v���w�肵��submit
    parent.params.csgrp = document.entryForm.csgrp.value;

    // ��\���t���O
    parent.params.hideflg = document.entryForm.hideflg.value;

    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

//�\���ؑ�
function chgHideFlg() {

    // ��\���t���O�𔽓]
    if( document.entryForm.hideflg.value == 1 ) {
        document.entryForm.hideflg.value = 0;
    } else {
        document.entryForm.hideflg.value = 1;
    }

    //�\������
    callMenResultTop();
}

//�b�t�o�N�ω���ʌĂяo��
function callCUMainGraph() {
    var myForm = parent.body1.document.entryForm;
    var url;                            // URL������
    var i;                              // �C���f�b�N�X
    var SelectItemcd;                   // �I�����ꂽ�������ڃR�[�h
    var SelectSuffix;                   // �I�����ꂽ�T�t�B�b�N�X
    var SelectCnt;                      // �I��

    SelectCnt = 0;
    SelectItemcd = '';
    SelectSuffix = '';
    if ( myForm.CUSelectItems.length != null ) {
        for( i=0; i<myForm.CUSelectItems.length; i++ ) {
            if( myForm.CUSelectItems[i].checked ) {
                if( SelectCnt > 0 ) {
                    SelectItemcd = SelectItemcd + ',';
                    SelectSuffix = SelectSuffix + ',';
                }
                SelectItemcd = SelectItemcd + myForm.itemcd[i].value;
                SelectSuffix = SelectSuffix + myForm.suffix[i].value;
                SelectCnt++;
            }
        }
    }

    if( SelectCnt == 0 ) {
        alert("�\���������ڂ��Œ�P�͑I�����Ă�������");
        return;
    }

    if( SelectCnt > 20 ) {
        alert("�\���������ڂ̍ő�I�𐔂͂Q�O���ł�");
        return;
    }

    url = '/WebHains/contents/interview/CUMainGraphMain.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&grpno=' + '<%= strGrpNo %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&itemcd=' + SelectItemcd;
    url = url + '&suffix=' + SelectSuffix;

    parent.location.href(url);

}

//�������ʕ\���`�X�V���[�h��ʌĂяo��
function callMenResultEntry() {
    var url;                                // URL������

    url = '/WebHains/contents/interview/MenResult.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&grpno=' + '<%= strGrpNo %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&csgrp=' + '<%= strSelCsGrp %>';
    url = url + '&entrymode=' + '<%= INTERVIEWRESULT_ENTRY %>';

    parent.location.href(url);

}

//�ۑ�
function saveMenResult() {

    // �������̑O�l��
    parent.body3.sortSentenceInfo();

    // ���[�h���w�肵��submit
    parent.body3.document.entryForm.act.value = 'save';
    parent.body3.document.entryForm.submit();

}

//�������ʕ\���`�Q�ƃ��[�h��ʌĂяo��
function callMenResult() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/MenResult.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&grpno=' + '<%= strGrpNo %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&csgrp=' + '<%= strSelCsGrp %>';
    url = url + '&entrymode=' + '<%= INTERVIEWRESULT_REFER %>';

    parent.location.href(url);

}
//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="entrymode" VALUE="<%= lngEntryMode %>">
    <INPUT TYPE="hidden" NAME="hideflg"   VALUE="<%= lngHideFlg %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="920">
        <TR>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000"><%= strMenResultTitle %>�@�������ʕ\��</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
<%
            '�O����R���{�{�b�N�X�\��
            Call  EditCsGrpInfo( lngRsvNo )
%>
        </TR>
    </TABLE>
    <!-- ��f�����̕\�� -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="920">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP HEIGHT="30">�O���f���F</TD>
<%
    If lngHisCount > 1 Then
%>
                        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(1) %>�@<%= vntCsSName(1) %></B></FONT></TD>
<%
    Else
%>
                        <TD NOWRAP>&nbsp;</TD>
<%
    End If
%>
                        <TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
                        <TD NOWRAP>�O�X���f���F</TD>
<%
    If lngHisCount > 2 Then
%>
                        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(2) %>�@<%= vntCsSName(2) %></B></FONT></TD>
<%
    Else
%>
                        <TD NOWRAP>&nbsp;</TD>
<%
    End If
%>
                    </TR>
                </TABLE>
            </TD>
<%
    '�X�V���[�h
    Select Case Clng(lngEntryMode)
    Case INTERVIEWRESULT_REFER

        If lngMenResultTypeNo = INTERVIEWRESULT_TYPE1 Or _
           lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callCUMainGraph()">�b�t�o�N�ω�</A></TD>
<%
        End If

        If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
           lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="JavaScript:chgHideFlg()">�\���ؑ�</A></TD>

            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="JavaScript:callMenResultEntry()">�����C�����</A></TD>
            <%  end if  %>
<%
        End If

    Case INTERVIEWRESULT_ENTRY
%>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD NOWRAP>�@<A HREF="JavaScript:saveMenResult()"><IMG SRC="../../images/save.gif" ALT="�ۑ�" HEIGHT="24" WIDTH="77"></A></TD>
            <%  end if  %>

            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callMenResult()">�Q�Ɛ�p��ʂ�</A></TD>
<%
    End Select

'#### 2011.07.01 SL-SN-Y0101-305 MOD START ####
'    If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
'       lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Then
    If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
       lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Or _
      (lngMenResultTypeNo = INTERVIEWRESULT_TYPE1 And _
       strMenResultTitle  = "�������b�ʐ�") Then
'#### 2011.07.01 SL-SN-Y0101-305 MOD END ####

'### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈גǉ� Start ###
            vntPerIdBefore = ""
            vntPerIdAfter = ""
            vntResultPerId = ""

            objInterView.SelectChangePerId lngRsvNo, vntPerIdBefore, vntPerIdAfter
            If vntPerIdBefore <> "" Then
                vntResultPerId = vntPerIdAfter
            Else
                vntResultPerId = vntPerId(0)
            End If

'### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈גǉ� End   ###

        '�S�d�}�̂Ƃ�
        If strMenResultTitle = "�S�d�}" Then
            '---------------------------------------------------------------------------------
            '�S�d�}�A�g
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax�摜���|�[�g�\������
            If strRayPaxOrdDiv <> "" Then
                '�I�[�_�ԍ����擾����
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo

                If vntOrderNo <> "" Then
                    '�S�d�}�g�`��URL
                    '#### 2009.01.22 �� �V���������V�X�e�������ɔ����d�l�ύX ####
                    'strUrlEcgWave = "http://157.104.34.11/disReport/bin/fr_mainref.asp"
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlEcgWave = "http://157.104.34.11/VitaWeb/Start.aspx?USER=yweb&PASS=yweb"
'                    strUrlEcgWave = strUrlEcgWave & "&order=" & vntOrderNo
                    strUrlEcgWave = ""
                    strUrlEcgWave = strUrlEcgWave & "http://" & convertAddress("Ecg") & "/VitaWeb/Start.aspx"
                    strUrlEcgWave = strUrlEcgWave & "?id="    & Right("0000000000" & vntPerId(0), 10)
                    strUrlEcgWave = strUrlEcgWave & "&sdate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd") & "000000"
                    strUrlEcgWave = strUrlEcgWave & "&edate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd") & "235959"
                    strUrlEcgWave = strUrlEcgWave & "&SORT3=JHA999"
'#### 2010.08.09 SL-HS-Y0101-003 MOD END   ####
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@�@<A HREF="<%= strUrlEcgWave %>" TARGET="_blank">�g�`</A></TD>
<%
                End If
            End If
'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
        '�����d���̂Ƃ�
        ElseIf strMenResultTitle = "�����d��" Then
            '---------------------------------------------------------------------------------
            '�����d���A�g
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax�摜���|�[�g�\������
            If strRayPaxOrdDiv <> "" Then
                '�I�[�_�ԍ����擾����
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo

                If vntOrderNo <> "" Then
                    '�����d����URL
                    strUrlCaviAbiImage = ""
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "http://" & convertAddress("CaviABi") & "/scripts8800/ecg_idx.exe"
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "?PID="   & vntPerId(0)
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "&ORDER=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yyyymmdd")

                    '�����d�����|�[�g��URL
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo

%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@�@<A HREF="<%= strUrlCaviAbiImage %>" TARGET="_blank">�摜</A></TD>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">���|�[�g</A></TD>
<%
                End If
            End If
'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####
        Else
            '---------------------------------------------------------------------------------
            'RayPax�A�g���̂P
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax�摜���|�[�g�\������
            If strRayPaxOrdDiv <> "" Then
                '�I�[�_�ԍ����擾����
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo, vntSendDate
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

                If vntOrderNo <> "" Then
                    'RayPax�摜��URL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = "http://157.104.35.15/ext/ShowImage.asp"
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX Start ###
''                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntResultPerId
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX End   ###
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&Date=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&Accession=" & vntOrderNo
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&System=H"
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = ""
'                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
                If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
                    strUrlRayPaxImage = ""
                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
		ELSE
                    strUrlRayPaxImage = ""
                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
                End If
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####
'#### 2010.08.09 SL-HS-Y0101-003 MOD END   ####

                    'RayPax���|�[�g��URL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxReport = "http://157.104.35.15/ext/ShowReport.asp"
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX Start ###
''                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntResultPerId
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX End   ###
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&Date=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&Accession=" & vntOrderNo
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&System=H"
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
'#### 2010.08.09 SL-HS-Y0101-003 MOD END   ####
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@�@<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">�摜</A></TD>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">���|�[�g</A></TD>
<%
                End If
            End If

            '---------------------------------------------------------------------------------
            'RayPax�A�g���̂Q
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax�摜���|�[�g�\������
            If strRayPaxOrdDiv2 <> "" Then
                '�I�[�_�ԍ����擾����
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv2, vntOrderNo
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv2, vntOrderNo, vntSendDate
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

                If vntOrderNo <> "" Then
                    'RayPax�摜��URL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = "http://157.104.35.15/ext/ShowImage.asp"
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX Start ###
''                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntResultPerId
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX End   ###
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&Date=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&Accession=" & vntOrderNo
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&System=H"
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = ""
'                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
'                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
                If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
                    strUrlRayPaxImage = ""
                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
		ELSE
                    strUrlRayPaxImage = ""
                    strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                    strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                    strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
                End If
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####
'#### 2010.08.09 SL-HS-Y0101-003 MOD END   ####

                    'RayPax���|�[�g��URL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxReport = "http://157.104.35.15/ext/ShowReport.asp"
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX Start ###
''                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntResultPerId
''### 2006.02.10 �� ���f������ύX���ꂽ��f�ҌlID�ǐՂ̈וύX End   ###
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&Date=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&Accession=" & vntOrderNo
'                    strUrlRayPaxReport = strUrlRayPaxReport & "&System=H"
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
'#### 2010.08.09 SL-HS-Y0101-003 MOD END   ####
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">�@�@<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">�摜</A></TD>
<!-- #### 2010.08.09 SL-HS-Y0101-003 MOD START #### 
<!--            <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">���|�[�g</A></TD> -->
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="javascript:void(window.open('<%= strUrlRayPaxReport %>', '', 'width=400,height=200'));">���|�[�g</A></TD>
<!-- #### 2010.08.09 SL-HS-Y0101-003 MOD END   #### -->
<%
                End If
            End If

'#### 2013.01.08 SL-SN-Y0101-611 ADD START ####
            '---------------------------------------------------------------------------------
            'RayPax�A�g���̂R
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax�摜���|�[�g�\������
            If strRayPaxOrdDiv3 <> "" Then

                '�I�[�_�ԍ����擾����
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv3, vntOrderNo, vntSendDate

                If vntOrderNo <> "" Then

                    'RayPax�摜��URL
                    If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
                        strUrlRayPaxImage = ""
                        strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                        strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                        strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
                    Else
                        strUrlRayPaxImage = ""
                        strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
                        strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
                        strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
                    End If

                    'RayPax���|�[�g��URL
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
%>
                    <TD NOWRAP WIDTH="100%" ALIGN="right">�@�@<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">�摜</A></TD>
                    <TD NOWRAP WIDTH="100%" ALIGN="right">�@<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">���|�[�g</A></TD>
<%
                End If
            End If
'#### 2013.01.08 SL-SN-Y0101-611 ADD END ####

        End If

    End If
%>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
<%
    Set objInterView = Nothing
%>
