<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	���f�X�P�W���[���\ (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-237
'       �C����  �F2010.05.28
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'---------------------------------
'   Programmed by ECO)���Y�r
'   Date : 2003.12.15
'   File : prtSchedule.asp
'---------------------------------
%>

<%
    '���茒�f�I�u�W�F�N�g�i�ꕔ�@�\���L�j
    Dim objSpecialInterview

    CONST strMMGCd          = "010"
    CONST strBreastEchoCd   = "011"

    Dim l_cslDate
    Dim l_PerID 
    Dim l_rsvNo 
    Dim l_dayID
    Dim l_grpcd
    Dim l_giKeiro
    Dim l_form_name 
'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
	Dim l_useID
	Dim l_IPAddress
	Dim vntMessage		'�ʒm���b�Z�[�W
'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
	'#### 2010.06.28 SL-UI-Y0101-237 DEL START ####'
'    Set objSpecialInterview       = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
	'#### 2010.06.28 SL-UI-Y0101-237 DEL END ####'

    l_cslDate   = Request("p_csldate")
    l_PerID     = Request("p_perid")
    l_rsvNo     = Request("p_rsvno")
    l_dayID     = Request("p_dayid")
    l_grpcd     = Request("p_grpcd")
    l_giKeiro   = Request("p_gi_keiro")
'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
    l_useID     = Request("p_Uid")
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '���s�[����IP�A�h���X���擾
'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'

'## 2005.11.17 �� ���[�����g���ǉ�(�ڐ�)�ɂ��X�P�W���[���\�ύX�i�S���ɈႤ���|�[�g�t�H�[�}�b�g���Ăяo��) Start ##
'
'        if l_grpcd = "1" or l_grpcd = "3" or l_grpcd = "5" or l_grpcd = "7" or l_grpcd = "100" then
'           l_form_name = "15_prtSchedule_men.mrd"
'        elseif l_grpcd = "2" or l_grpcd = "4" or l_grpcd = "6" or l_grpcd = "8" then
'           l_form_name = "15_prtSchedule_women.mrd"
'        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then
'           l_form_name = "15_prtSchedule_menAM.mrd"
'        elseif l_grpcd = "50" and l_dayID = "2" then
'           l_form_name = "15_prtSchedule_womenAM.mrd"
'        elseif l_grpcd = "51" and l_dayID = "1" then
'           l_form_name = "15_prtSchedule_menPM.mrd"
'        elseif l_grpcd = "51" and l_dayID = "2" then
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'        else
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'        end if

'#### 2010.06.28 SL-UI-Y0101-237 DEL START ####'
'
'    '## 2006.03.20 �� �����f�҂̂ݒj����f�҂̓��[�����g���������{�i��O�����j�ɂ��X�P�W���[���\�ύX Start ##
'    '##            �����f�ҁiID�F9160750�A�����F�V�c�@����āA���ʓK���p���󂯂���f�ҁj                     ##
''    if l_PerID = "9160750" then
''        l_form_name = "15_prtSchedule_men_7S.mrd"
''    else
'        if l_grpcd = "1" then                           '1�Q
'            if objSpecialInterview.CheckSetClassCd(l_rsvno, strMMGCd) then
'               l_form_name = "15_prtSchedule_men_1S.mrd"
'            else
'               l_form_name = "15_prtSchedule_men_1.mrd"
'            end if
'
'        elseif l_grpcd = "3" then                       '3�Q
'           l_form_name = "15_prtSchedule_men_3.mrd"
'
'        elseif l_grpcd = "5" then                       '5�Q
'           l_form_name = "15_prtSchedule_men_5.mrd"
'
'        elseif l_grpcd = "7" then                       '7�Q
'            if objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) then
'                l_form_name = "15_prtSchedule_men_7S.mrd"
'            else
'                l_form_name = "15_prtSchedule_men_7.mrd"
'            end if
'        elseif l_grpcd = "100" then                     '�x�h�b�N
'           l_form_name = "15_prtSchedule_men_5.mrd"
'
'        elseif l_grpcd = "2" then                       '2�Q
'           l_form_name = "15_prtSchedule_women_2.mrd"
'
'        elseif l_grpcd = "4" then                       '4�Q
'           '## 2006/12/06 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
'           ''l_form_name = "15_prtSchedule_women_4.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_4_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_4_gf.mrd"
'           end if
'           '## 2006/12/06 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##
'
'        elseif l_grpcd = "6" then                       '6�Q
'           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
'           ''l_form_name = "15_prtSchedule_women_6.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_6_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_6_gf.mrd"
'           end if
'           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##
'
''### 2006/08/05 �� �Վ��I�ɂW�Q�U���o�H���U�Q�Ɠ����o�H�ɕύX Start ###
'    '### 2007/02/16 �� ���̂W�Q�̗U���o�H���Ԃɍ��킹�ĕύX(�����R�[�X�敪�Ȃ��j Start ###
'''        elseif l_grpcd = "8" then                       '8�Q
'''           l_form_name = "15_prtSchedule_women_8.mrd"
'        elseif l_grpcd = "8" then                       '8�Q
'           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
'           ''l_form_name = "15_prtSchedule_women_6.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_8_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_8_gf.mrd"
'           end if
'           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##
'    '### 2007/02/16 �� ���̂W�Q�̗U���o�H���Ԃɍ��킹�ĕύX(�����R�[�X�敪�Ȃ��j End   ###
'           
''### 2006/08/05 �� �Վ��I�ɂW�Q�U���o�H���U�Q�Ɠ����o�H�ɕύX End   ###
'
''### 2007/04/27 �� ���W�f���X�ȈՌ��f�R�[�X�ǉ��ɂ��ǉ� Start ###
'        elseif l_grpcd = "190" then                                         '���W�f���X�ȈՌ��f
'           l_form_name = "15_prtSchedule_residence.mrd"
''### 2007/04/27 �� ���W�f���X�ȈՌ��f�R�[�X�ǉ��ɂ��ǉ� End   ###
'
''### 2007/06/27 �� �����񌟐f�R�[�X�ǉ��ɂ��ǉ� Start ###
'        elseif l_grpcd = "273" or l_grpcd = "274" then                      ' �����񌟐f
'           l_form_name = "15_prtSchedule_breast.mrd"
''### 2007/06/27 �� �����񌟐f�R�[�X�ǉ��ɂ��ǉ� End   ###
'
'        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then   '�ߑO��ƌ��f(�j��)�E�n�q����
'           l_form_name = "15_prtSchedule_menAM.mrd"
'
'        elseif l_grpcd = "50" and l_dayID = "2" then                        '�ߑO��ƌ��f(����)
'           l_form_name = "15_prtSchedule_womenAM.mrd"
'
'        elseif l_grpcd = "51" and l_dayID = "1" then                        '�ߌ��ƌ��f(�j��)
'           l_form_name = "15_prtSchedule_menPM.mrd"
'
'        elseif l_grpcd = "51" and l_dayID = "2" then                        '�ߌ��ƌ��f(����)
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'
''### 2008/06/23 �� ��������Z�b�g�R�[�X�͌ߑO��Ƃ̏����X�P�W���[���\���������悤�ɋ@�\�ǉ� ###
'        elseif l_grpcd = "700" then                                         '��������Z�b�g
'           l_form_name = "15_prtSchedule_womenAM.mrd"
'
'        elseif l_grpcd = "67" then                                          '����ی��w���i�ϋɓI�j
'           l_form_name = "15_prtSchedule_special.mrd"
'
'        elseif l_grpcd = "20" and l_dayID = "1" then                        '�E�����f(�j��)
'           l_form_name = "15_prtSchedule_men_1.mrd"
'
'        elseif l_grpcd = "20" and l_dayID = "2" then                        '�E�����f(����)
'           l_form_name = "15_prtSchedule_women_2.mrd"
'
'        else
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'        end if
''    end if
'    '## 2006.03.20 �� �����f�҂̂ݒj����f�҂̓��[�����g���������{�i��O�����j�ɂ��X�P�W���[���\�ύX End   ##
'
'
''## 2005.11.17 �� ���[�����g���ǉ�(�ڐ�)�ɂ��X�P�W���[���\�ύX�i�S���ɈႤ���|�[�g�t�H�[�}�b�g���Ăяo��) End   ##
'
'        Set objSpecialInterview = Nothing
'
'#### 2010.06.28 SL-UI-Y0101-237 DEL END ####'

'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
'���[�o�͏�������
vntMessage = PrintControl(0)	'���[�h("0":�͂����A"1":�ꎮ����)

Sub GetQueryString()
End Sub

Function CheckValue()
End Function

Function Print()
    Dim objPrintCls     '�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim Ret             '�֐��߂�l
    Dim strObjName      '�I�u�W�F�N�g��

	'���R�����΍��p���O�����o��
	Call putPrivacyInfoLogWithUserID("PH053", "�X�P�W���[���\�̈�����s����", l_useID)

    Set objSpecialInterview = Server.CreateObject("HainsSpecialInterview.SpecialInterview")


'########## 2012/09/21 �� ��f�\�茟�����ڋy�їU�����Ԃ͎�f�ҕʗU�������Q�Ƃ��Ĉ���ł���悤�Ɏd�l�ύX Start ##########
'    '1�Q
'    If l_grpcd = "1" Then
'        If objSpecialInterview.CheckSetClassCd(l_rsvno, strMMGCd) Then
'            strObjName = "HainsprtSchedule.prtSchedule_men_1S"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_men"
'        End If
'
'
'    '7�Q
'    ElseIf l_grpcd = "7" Then
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX Start ########################
''        If objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) Then
''            strObjName = "HainsprtSchedule.prtSchedule_men_7S"
''        Else
''            strObjName = "HainsprtSchedule.prtSchedule_men"
''        End If
''## 2012/09/03 �� 7�Q�͌��̗U�����ɖ߂�
'        If objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) Then
'            strObjName = "HainsprtSchedule.prtSchedule_men_7S_e"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_men_e"
'        End If
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX End   ########################
'
'
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX Start ########################
''    '3�Q�A5�Q�A�x�h�b�N�A�E�����f(�j��)
''    ElseIf (l_grpcd = "3") Or (l_grpcd = "5") Or (l_grpcd = "100") Or (l_grpcd = "20" And l_dayID = "1") Then
''        strObjName = "HainsprtSchedule.prtSchedule_men"
'    ElseIf (l_grpcd = "3") Or (l_grpcd = "100") Or (l_grpcd = "20" And l_dayID = "1") Then
'        strObjName = "HainsprtSchedule.prtSchedule_men"
'
'    ElseIf (l_grpcd = "5") Then
'        strObjName = "HainsprtSchedule.prtSchedule_men_e"
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX End   ########################
'
'
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX Start ########################
''    '2�Q�A4�Q�A�E�����f(����)
''    ElseIf (l_grpcd = "2") Or (l_grpcd = "4") Or (l_grpcd = "20" And l_dayID = "2") Then
''        strObjName = "HainsprtSchedule.prtSchedule_women"
'    ElseIf (l_grpcd = "2") Or (l_grpcd = "20" And l_dayID = "2") Then
'        strObjName = "HainsprtSchedule.prtSchedule_women"
'
'    ElseIf (l_grpcd = "4") Then
'        strObjName = "HainsprtSchedule.prtSchedule_women_e"
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX End   ########################
'
'
'
''    ElseIf (l_grpcd = "6") Or (l_grpcd = "8") Then
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX Start ########################
''        If l_giKeiro > 0 Then
''            strObjName = "HainsprtSchedule.prtSchedule_women_gi"
''        Else
''            strObjName = "HainsprtSchedule.prtSchedule_women"
''        End If
'
'    '6�Q�A8�Q
'    ElseIf l_grpcd = "6" Or (l_grpcd = "8") Then
'
'        If l_giKeiro > 0 Then
'            strObjName = "HainsprtSchedule.prtSchedule_women_gi_e"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_women_e"
'        End If
'
''## 2012/08/23 �� �U�������ύX�g���C�A���̈חՎ��ύX End   ########################
'
'    '���W�f���X�ȈՌ��f
'    ElseIf l_grpcd = "190" Then
'        strObjName = "HainsprtSchedule.prtSchedule_residence"
'
'    '�����񌟐f
'    ElseIf l_grpcd = "273" Or l_grpcd = "274" Then
'        strObjName = "HainsprtSchedule.prtSchedule_breast"
'
'    '����ی��w���i�ϋɓI�j
'    ElseIf l_grpcd = "67" Then
'        strObjName = "HainsprtSchedule.prtSchedule_special"
'
'    '�ߑO��ƌ��f(�j��)�A�n�q����
'    ElseIf (l_grpcd = "50" And l_dayID = "1") Or (l_grpcd = "250") Then
'        strObjName = "HainsprtSchedule.prtSchedule_menAM"
'
'    '�ߑO��ƌ��f(����)�A��������Z�b�g
'    ElseIf (l_grpcd = "50" And l_dayID = "2") Or (l_grpcd = "700") Then
'        strObjName = "HainsprtSchedule.prtSchedule_womenAM"
'
'    '�ߌ��ƌ��f(�j��)
'    ElseIf l_grpcd = "51" And l_dayID = "1" Then
'        strObjName = "HainsprtSchedule.prtSchedule_menPM"
'
'    '�ߌ��ƌ��f(����)
'    ElseIf l_grpcd = "51" And l_dayID = "2" Then
'        strObjName = "HainsprtSchedule.prtSchedule_womenPM"
'
'    Else
'        strObjName = "HainsprtSchedule.prtSchedule_womenPM"
'
'    End If

    strObjName = "HainsprtSchedule.prtSchedule_standard"

'########## 2012/09/21 �� ��f�\�茟�����ڋy�їU�����Ԃ͎�f�ҕʗU�������Q�Ƃ��Ĉ���ł���悤�Ɏd�l�ύX End   ##########

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPrintCls = Server.CreateObject(strObjName)

    '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
    Ret = objPrintCls.PrintOut(l_useID, _
                               l_PerID, _
                               l_rsvNo, _
                               l_cslDate, _
                               l_IPAddress)

    Set objSpecialInterview = Nothing

    Print = Ret

End Function

'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'
%>

<!--
'#### 2010.06.28 SL-UI-Y0101-237 DEL START ####'


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
    name=Rdviewer 
    width=0% height=0%>
</OBJECT>


<HEAD>
</HEAD>
<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-237 DEL END ####'
//-->
<!--
   sub window_onload()
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/<%= l_form_name %>", "/rop /rwait /rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-237 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-237 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-237 ADD START ####' -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm() 
    {
      window.opener = window.self.name;
      window.close();
    }
-->
</SCRIPT>
</HEAD>
<BODY onLoad="LoadForm();">

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
<!-- '#### 2010.06.28 SL-UI-Y0101-237 ADD END ####' -->
