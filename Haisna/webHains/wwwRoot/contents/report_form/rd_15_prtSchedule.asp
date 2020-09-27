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
    '特定健診オブジェクト（一部機能共有）
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

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
    Set objSpecialInterview       = Server.CreateObject("HainsSpecialInterview.SpecialInterview")

    l_cslDate = Request("p_csldate")
    l_PerID = Request("p_perid")
    l_rsvNo = Request("p_rsvno")
    l_dayID = Request("p_dayid")
    l_grpcd = Request("p_grpcd")
    l_giKeiro = Request("p_gi_keiro")

  
'## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) Start ##
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

    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 Start ##
    '##            特定受診者（ID：9160750、氏名：澤田　さや夏、性別適合術を受けた受診者）                     ##
'    if l_PerID = "9160750" then
'        l_form_name = "15_prtSchedule_men_7S.mrd"
'    else
        if l_grpcd = "1" then                           '1群
'           l_form_name = "15_prtSchedule_men_1.mrd"
            if objSpecialInterview.CheckSetClassCd(l_rsvno, strMMGCd) then
               l_form_name = "15_prtSchedule_men_1S.mrd"
            else
               l_form_name = "15_prtSchedule_men_1.mrd"
            end if
        elseif l_grpcd = "3" then                       '3群
           l_form_name = "15_prtSchedule_men_3.mrd"
        elseif l_grpcd = "5" then                       '5群
           l_form_name = "15_prtSchedule_men_5.mrd"
        elseif l_grpcd = "7" then                       '7群
'           l_form_name = "15_prtSchedule_men_7.mrd"
            if objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) then
                l_form_name = "15_prtSchedule_men_7S.mrd"
            else
                l_form_name = "15_prtSchedule_men_7.mrd"
            end if
        elseif l_grpcd = "100" then                     '肺ドック
           l_form_name = "15_prtSchedule_men_5.mrd"

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
    '### 2007/02/16 張 元の８群の誘導経路順番に合わせて変更(検査コース区分なし） Start ###
''        elseif l_grpcd = "8" then                       '8群
''           l_form_name = "15_prtSchedule_women_8.mrd"
        elseif l_grpcd = "8" then                       '8群
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
           ''l_form_name = "15_prtSchedule_women_6.mrd"
           if l_giKeiro > 0 then
                l_form_name = "15_prtSchedule_women_8_gi.mrd"
           else
                l_form_name = "15_prtSchedule_women_8_gf.mrd"
           end if
           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##
    '### 2007/02/16 張 元の８群の誘導経路順番に合わせて変更(検査コース区分なし） End   ###
           
'### 2006/08/05 張 臨時的に８群誘導経路を６群と同じ経路に変更 End   ###

'### 2007/04/27 張 レジデンス簡易健診コース追加により追加 Start ###
        elseif l_grpcd = "190" then                                         'レジデンス簡易健診
           l_form_name = "15_prtSchedule_residence.mrd"
'### 2007/04/27 張 レジデンス簡易健診コース追加により追加 End   ###

'### 2007/06/27 張 乳がん検診コース追加により追加 Start ###
        elseif l_grpcd = "273" or l_grpcd = "274" then                      '　乳がん検診
           l_form_name = "15_prtSchedule_breast.mrd"
'### 2007/06/27 張 乳がん検診コース追加により追加 End   ###

        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then   '午前企業健診(男性)・渡航内科
           l_form_name = "15_prtSchedule_menAM.mrd"
        elseif l_grpcd = "50" and l_dayID = "2" then                        '午前企業健診(女性)
           l_form_name = "15_prtSchedule_womenAM.mrd"
        elseif l_grpcd = "51" and l_dayID = "1" then                        '午後企業健診(男性)
           l_form_name = "15_prtSchedule_menPM.mrd"
        elseif l_grpcd = "51" and l_dayID = "2" then                        '午後企業健診(女性)
           l_form_name = "15_prtSchedule_womenPM.mrd"
'### 2008/06/23 張 後日女性セットコースは午前企業の女性スケジュール表を印刷するように機能追加 ###
        elseif l_grpcd = "700" then                                         '後日女性セット
           l_form_name = "15_prtSchedule_womenAM.mrd"
        elseif l_grpcd = "67" then                                          '特定保健指導（積極的）
           l_form_name = "15_prtSchedule_special.mrd"
        else
           l_form_name = "15_prtSchedule_womenPM.mrd"
        end if
'    end if
    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 End   ##

'## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) End   ##
        Set objSpecialInterview = Nothing

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
<BODY onLoad="LoadForm();">

<%=l_dayID %>
</BODY>
</HTML>