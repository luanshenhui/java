<%@ LANGUAGE="VBScript" %>

<%
'-------------------------------------------------------------------------------
'   �X�֕���̏����(�������A���ѕ\�j (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>

<%
    Dim l_useID             '���O�C�����[�U�[ID
    Dim l_strSendDate       '�쐬��
    Dim l_strESendDate       '�쐬��
    Dim l_Option            '���[�̎��
    Dim l_strUrl            'RD���[�t�@�C����ݒ�

    l_useID         = Request("p_Uid")          '���O�C�����[�UID
    l_strSendDate   = Request("p_strSendDate")  '������(�����J�n��)
    l_strESendDate   = Request("p_strESendDate")  '������(�����I����)
    l_Option        = Request("p_Option")       '���ѕ\�`�F�b�N���X�g���

    IF l_Option = "0" THEN
        l_strUrl = "35_1_prtReportChecklist.mrd"        '��������A���\�i�������`�F�b�N�p�j
    ELSEIF l_Option = "1" THEN
        l_strUrl = "35_3_prtReportGyneChecklist.mrd"      '�w�l�ȃ`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "2" THEN
        l_strUrl = "35_2_prtReportRetiphotoChecklist.mrd"        '���`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "3" THEN
        l_strUrl = "35_6_prtReportAbdoEchoChecklist.mrd"      '���������g�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "4" THEN
        l_strUrl = "35_4_prtReportChestXChecklist.mrd"      '����X���`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "5" THEN
        l_strUrl = "35_5_1_prtReportGastroChecklist.mrd"      '�㕔�����ǁi�݂w���j�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "6" THEN
        l_strUrl = "35_5_2_prtReportEndoChecklist.mrd"        '�㕔�����ǁi�������j�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "7" THEN
        l_strUrl = "35_7_prtReportCTChecklist.mrd"      '����CT�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "8" THEN  
        l_strUrl = "35_8_prtReportMammoChecklist.mrd"      '���[�w���`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "9" THEN  
        l_strUrl = "35_8_prtReportBreastsEchoChecklist.mrd"      '���[�����g�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "10" THEN  
        l_strUrl = "35_8_prtReportClinBreastsChecklist.mrd"      '���[�G�f�`�F�b�N���X�g(�������`�F�b�N�p)
    ELSEIF l_Option = "11" THEN  
        l_strUrl = "35_9_prtReportECGlist.mrd"      '�S�d�}���菊�����X�g
    ELSEIF l_Option = "12" THEN  
        l_strUrl = "35_99_prtReportMetabolicSyndrome.mrd"      '���^�{���b�N�V���h���[�� 
    ELSEIF l_Option = "13" THEN  
        l_strUrl = "35_98_CTReexamList.mrd"      '����CT�Č����Ώێ҃��X�g 

    ELSEIF l_Option = "14" THEN  
        l_strUrl = "35_GF_SekenList.mrd"         'GF�������{�҃��X�g

    ELSEIF l_Option = "15" THEN  
        l_strUrl = "35_15_prtReportBoneChecklist.mrd"         '�����x�`�F�b�N���X�g
    END IF
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<OBJECT 
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
    name=Rdviewer width="100%" height="100%">
</OBJECT>

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm()
    {
        Rdviewer.DisplayNoDataMsg(false);
        Rdviewer.SetBackgroundColor(255, 255, 255);
        Rdviewer.AutoAdjust = false;
        Rdviewer.ZoomRatio = 100;
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%=l_strSendDate%>] [<%=l_strESendDate%>] ");
    }
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();"></BODY>
</HTML>