<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%
'---------------------------------
'   Programmed by ECO)���Y�r
'   Date : 2003.12.15
'   File : prtSchedule.asp
'---------------------------------
%>

<%
    Dim l_cslDate
    Dim l_PerID 
    Dim l_rsvNo 
    Dim l_dayID
    Dim l_grpcd
    Dim l_form_name 
    Dim l_giKeiro

    l_cslDate = Request("p_csldate")
    l_PerID = Request("p_perid")
    l_rsvNo = Request("p_rsvno")
    l_dayID = Request("p_dayid")
    l_grpcd = Request("p_grpcd")
    l_giKeiro = Request("p_gi_keiro")

  
'## 2005.11.17 �� ���[�����g���ǉ�(�ڐ�)�ɂ��X�P�W���[���\�ύX�i�S���ɈႤ���|�[�g�t�H�[�}�b�g���Ăяo��) Start ##
'        if l_grpcd = "1" or l_grpcd = "3" or l_grpcd = "5" or l_grpcd = "7" then
'           l_form_name = "15_prtSchedule_men.mrd"
'        elseif l_grpcd = "2" or l_grpcd = "4" or l_grpcd = "6" or l_grpcd = "8" then
'           l_form_name = "15_prtSchedule_women.mrd"
'        elseif l_grpcd = "50" and l_dayID = "1" then
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

    '## 2006.03.20 �� �����f�҂̂ݒj����f�҂̓��[�����g���������{�i��O�����j�ɂ��X�P�W���[���\�ύX Start ##
    '##            �����f�ҁiID�F9160750�A�����F�V�c�@����āA���ʓK���p���󂯂���f�ҁj                     ##
    if l_PerID = "9160750" then
        l_form_name = "15_prtSchedule_men_7S.mrd"
    else
        if l_grpcd = "1" then                           '1�Q
           l_form_name = "15_prtSchedule_men_1.mrd"
        elseif l_grpcd = "3" then                       '3�Q
           l_form_name = "15_prtSchedule_men_3.mrd"
        elseif l_grpcd = "5" then                       '5�Q
           l_form_name = "15_prtSchedule_men_5.mrd"
        elseif l_grpcd = "7" then                       '7�Q
           l_form_name = "15_prtSchedule_men_7.mrd"

        elseif l_grpcd = "2" then                       '2�Q
           l_form_name = "15_prtSchedule_women_2.mrd"

        elseif l_grpcd = "4" then                       '4�Q
           '## 2006/12/06 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
           ''l_form_name = "15_prtSchedule_women_4.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_4_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_4_gf.mrd"
           end if
           '## 2006/12/06 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##

        elseif l_grpcd = "6" then                       '6�Q
           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
           ''l_form_name = "15_prtSchedule_women_6.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_6_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_6_gf.mrd"
           end if
           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##

'### 2006/08/05 �� �Վ��I�ɂW�Q�U���o�H���U�Q�Ɠ����o�H�ɕύX Start ###
'        elseif l_grpcd = "8" then                       '8�Q
'           l_form_name = "15_prtSchedule_women_8.mrd"
        elseif l_grpcd = "8" then                       '8�Q
           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX Start ##
           ''l_form_name = "15_prtSchedule_women_6.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_8_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_8_gf.mrd"
           end if
           '## 2006/10/24 �� �X�P�W���[���\���R�[�X��(GI�EGF)�ɕ����Ĉ���ł���悤�ɕύX End   ##

'### 2006/08/05 �� �Վ��I�ɂW�Q�U���o�H���U�Q�Ɠ����o�H�ɕύX End   ###

        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then   '�ߑO��ƌ��f(�j��)�E�n�q����
           l_form_name = "15_prtSchedule_menAM.mrd"
        elseif l_grpcd = "50" and l_dayID = "2" then                        '�ߑO��ƌ��f(����)
           l_form_name = "15_prtSchedule_womenAM.mrd"
        elseif l_grpcd = "51" and l_dayID = "1" then                        '�ߌ��ƌ��f(�j��)
           l_form_name = "15_prtSchedule_menPM.mrd"
        elseif l_grpcd = "51" and l_dayID = "2" then                        '�ߌ��ƌ��f(����)
           l_form_name = "15_prtSchedule_womenPM.mrd"
        else
           l_form_name = "15_prtSchedule_womenPM.mrd"
        end if
    end if
    '## 2006.03.20 �� �����f�҂̂ݒj����f�҂̓��[�����g���������{�i��O�����j�ɂ��X�P�W���[���\�ύX End   ##

'## 2005.11.17 �� ���[�����g���ǉ�(�ڐ�)�ɂ��X�P�W���[���\�ύX�i�S���ɈႤ���|�[�g�t�H�[�}�b�g���Ăяo��) End   ##



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
    name=Rdviewer 
    width=100% height=100%>
</OBJECT>


<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm()
    {
        Rdviewer.DisplayNoDataMsg(false);
        Rdviewer.SetBackgroundColor(255, 255, 255);
        Rdviewer.AutoAdjust = false;
        Rdviewer.ZoomRatio  = 100;
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_form_name %>", "/rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>]" );

      //self.close();
      //window.close();
    }
//-->
</SCRIPT>
</HEAD>
<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
<!--
   sub window_onload()
      'Rdviewer.FileOpen "http://www.m2soft.co.kr/ReportDesigner/test/mrd/test_jpn.mrd", "/rop /rwait /rv ���O[�c���Ɋ�] �w��[�d�q�ʐM�H�w��] ��U[�d�q�ʐM�H�w��] ����U[ ] �Z��[1970/11/11] �w��[970501] ���E[0.0] ���K[9.0] ���I[23.0] ��K[3.0] ��I[0.0] ���K[0.0] ���I[0.0] �_��[0.0] ��b[0.0] ��I[0.0] �\��[41] �擾[41] ���_[106.5] ����[2.60] /rf [http://www.m2soft.co.kr/ReportDesigner/test/mrd/test_jpn.txt]"
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/<%= l_form_name %>", "/rop /rwait /rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>