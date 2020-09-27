<%@ LANGUAGE="VBScript" %>

<%
'-------------------------------------------------------------------------------
'   郵便物受領書印刷(請求書、成績表） (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>

<%
    Dim l_useID             'ログインユーザーID
    Dim l_strSendDate       '作成日
    Dim l_strESendDate       '作成日
    Dim l_Option            '帳票の種類
    Dim l_strUrl            'RD帳票ファイルを設定

    l_useID         = Request("p_Uid")          'ログインユーザID
    l_strSendDate   = Request("p_strSendDate")  '発送日(検索開始日)
    l_strESendDate   = Request("p_strESendDate")  '発送日(検索終了日)
    l_Option        = Request("p_Option")       '成績表チェックリスト種類

    IF l_Option = "0" THEN
        l_strUrl = "35_1_prtReportChecklist.mrd"        '総合判定連絡表（後日判定チェック用）
    ELSEIF l_Option = "1" THEN
        l_strUrl = "35_3_prtReportGyneChecklist.mrd"      '婦人科チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "2" THEN
        l_strUrl = "35_2_prtReportRetiphotoChecklist.mrd"        '眼底チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "3" THEN
        l_strUrl = "35_6_prtReportAbdoEchoChecklist.mrd"      '腹部超音波チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "4" THEN
        l_strUrl = "35_4_prtReportChestXChecklist.mrd"      '胸部X線チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "5" THEN
        l_strUrl = "35_5_1_prtReportGastroChecklist.mrd"      '上部消化管（胃Ｘ線）チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "6" THEN
        l_strUrl = "35_5_2_prtReportEndoChecklist.mrd"        '上部消化管（内視鏡）チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "7" THEN
        l_strUrl = "35_7_prtReportCTChecklist.mrd"      '胸部CTチェックリスト(後日判定チェック用)
    ELSEIF l_Option = "8" THEN  
        l_strUrl = "35_8_prtReportMammoChecklist.mrd"      '乳房Ｘ線チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "9" THEN  
        l_strUrl = "35_8_prtReportBreastsEchoChecklist.mrd"      '乳房超音波チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "10" THEN  
        l_strUrl = "35_8_prtReportClinBreastsChecklist.mrd"      '乳房触診チェックリスト(後日判定チェック用)
    ELSEIF l_Option = "11" THEN  
        l_strUrl = "35_9_prtReportECGlist.mrd"      '心電図判定所見リスト
    ELSEIF l_Option = "12" THEN  
        l_strUrl = "35_99_prtReportMetabolicSyndrome.mrd"      'メタボリックシンドローム 
    ELSEIF l_Option = "13" THEN  
        l_strUrl = "35_98_CTReexamList.mrd"      '胸部CT再検査対象者リスト 

    ELSEIF l_Option = "14" THEN  
        l_strUrl = "35_GF_SekenList.mrd"         'GF生検実施者リスト

    ELSEIF l_Option = "15" THEN  
        l_strUrl = "35_15_prtReportBoneChecklist.mrd"         '骨密度チェックリスト
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