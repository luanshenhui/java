<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%
'---------------------------------
'   Programmed by ECO)金雄俊
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

  
'## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) Start ##
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

    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 Start ##
    '##            特定受診者（ID：9160750、氏名：澤田　さや夏、性別適合術を受けた受診者）                     ##
    if l_PerID = "9160750" then
        l_form_name = "15_prtSchedule_men_7S.mrd"
    else
        if l_grpcd = "1" then                           '1群
           l_form_name = "15_prtSchedule_men_1.mrd"
        elseif l_grpcd = "3" then                       '3群
           l_form_name = "15_prtSchedule_men_3.mrd"
        elseif l_grpcd = "5" then                       '5群
           l_form_name = "15_prtSchedule_men_5.mrd"
        elseif l_grpcd = "7" then                       '7群
           l_form_name = "15_prtSchedule_men_7.mrd"

        elseif l_grpcd = "2" then                       '2群
           l_form_name = "15_prtSchedule_women_2.mrd"

        elseif l_grpcd = "4" then                       '4群
           '## 2006/12/06 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
           ''l_form_name = "15_prtSchedule_women_4.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_4_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_4_gf.mrd"
           end if
           '## 2006/12/06 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##

        elseif l_grpcd = "6" then                       '6群
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
           ''l_form_name = "15_prtSchedule_women_6.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_6_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_6_gf.mrd"
           end if
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##

'### 2006/08/05 張 臨時的に８群誘導経路を６群と同じ経路に変更 Start ###
'        elseif l_grpcd = "8" then                       '8群
'           l_form_name = "15_prtSchedule_women_8.mrd"
        elseif l_grpcd = "8" then                       '8群
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
           ''l_form_name = "15_prtSchedule_women_6.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_8_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_8_gf.mrd"
           end if
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##

'### 2006/08/05 張 臨時的に８群誘導経路を６群と同じ経路に変更 End   ###

        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then   '午前企業健診(男性)・渡航内科
           l_form_name = "15_prtSchedule_menAM.mrd"
        elseif l_grpcd = "50" and l_dayID = "2" then                        '午前企業健診(女性)
           l_form_name = "15_prtSchedule_womenAM.mrd"
        elseif l_grpcd = "51" and l_dayID = "1" then                        '午後企業健診(男性)
           l_form_name = "15_prtSchedule_menPM.mrd"
        elseif l_grpcd = "51" and l_dayID = "2" then                        '午後企業健診(女性)
           l_form_name = "15_prtSchedule_womenPM.mrd"
        else
           l_form_name = "15_prtSchedule_womenPM.mrd"
        end if
    end if
    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 End   ##

'## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) End   ##



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
      'Rdviewer.FileOpen "http://www.m2soft.co.kr/ReportDesigner/test/mrd/test_jpn.mrd", "/rop /rwait /rv 名前[田中繁喜] 学科[電子通信工学科] 専攻[電子通信工学科] 副専攻[ ] 住民[1970/11/11] 学番[970501] 教職[0.0] 教必[9.0] 教選[23.0] 専必[3.0] 専選[0.0] 副必[0.0] 副選[0.0] 論文[0.0] 基礎[0.0] 一選[0.0] 申請[41] 取得[41] 平点[106.5] 平均[2.60] /rf [http://www.m2soft.co.kr/ReportDesigner/test/mrd/test_jpn.txt]"
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/<%= l_form_name %>", "/rop /rwait /rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>