<%@LANGUAGE = VBSCRIPT%>
<%
'-----------------------------------------------------------------------------
'       ���f�B���[�J�X���f���O�Ǘ��[��� (Ver0.0.1)
'       AUTHER  : ���@���l
'-----------------------------------------------------------------------------
%>
<%Option Explicit%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"              -->
<%
    '�Z�b�V�����E�����`�F�b�N
    Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

    Dim l_IPAddress
    Dim vntMessage          '�ʒm���b�Z�[�W
    Dim UID
    Dim l_rsvNo 
    Dim l_act
    Dim l_addrdiv
    Dim l_engdiv

    l_rsvNo     = Request("p_rsvNo")
    l_act       = Request("p_act")
    l_addrdiv   = Request("p_addrdiv")
    l_engdiv    = Request("p_engdiv")

    l_IPAddress     = Request.ServerVariables("REMOTE_ADDR")  '���s�[����IP�A�h���X���擾


    '���[�o�͏�������
    vntMessage = PrintControl(0)


    Sub GetQueryString()
        UID = Session("USERID")
    End Sub

    Function CheckValue()
    End Function

    Function Print()
        Dim objCommon       '���ʃN���X

        Dim objPrintCls     '���f���O�Ǘ��[�o�͗pCOM�R���|�[�l���g
        Dim Ret             '�֐��߂�l

        If Not IsArray(CheckValue()) Then
            Set objCommon = Server.CreateObject("HainsCommon.Common")
        End If

        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        '�p���o�̗͂L�����Ƃ̌Ăѐ��`�i�ŏ��͓��{��ł̂݁j
        Select Case l_engdiv
            Case "jap"
                Set objPrintCls = Server.CreateObject("HainsprtReserveMedi.prtReserve_medi")
                '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
                Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_addrdiv, l_engdiv, l_IPAddress)

            Case "eng"
                Set objPrintCls = Server.CreateObject("HainsprtReserveMedi.prtReserve_medi")
                '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
                Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_addrdiv, l_engdiv, l_IPAddress)
            Case Else
        End Select
        Print = Ret
    End Function
%>

