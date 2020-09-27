<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	健診スケジュール表 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-237
'       修正日  ：2010.05.28
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
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
'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
	Dim l_useID
	Dim l_IPAddress
	Dim vntMessage		'通知メッセージ
'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'

'-------------------------------------------------------------------------------
' 先頭制御部
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
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得
'#### 2010.06.28 SL-UI-Y0101-237 ADD END ####'

'## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) Start ##
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
'    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 Start ##
'    '##            特定受診者（ID：9160750、氏名：澤田　さや夏、性別適合術を受けた受診者）                     ##
''    if l_PerID = "9160750" then
''        l_form_name = "15_prtSchedule_men_7S.mrd"
''    else
'        if l_grpcd = "1" then                           '1群
'            if objSpecialInterview.CheckSetClassCd(l_rsvno, strMMGCd) then
'               l_form_name = "15_prtSchedule_men_1S.mrd"
'            else
'               l_form_name = "15_prtSchedule_men_1.mrd"
'            end if
'
'        elseif l_grpcd = "3" then                       '3群
'           l_form_name = "15_prtSchedule_men_3.mrd"
'
'        elseif l_grpcd = "5" then                       '5群
'           l_form_name = "15_prtSchedule_men_5.mrd"
'
'        elseif l_grpcd = "7" then                       '7群
'            if objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) then
'                l_form_name = "15_prtSchedule_men_7S.mrd"
'            else
'                l_form_name = "15_prtSchedule_men_7.mrd"
'            end if
'        elseif l_grpcd = "100" then                     '肺ドック
'           l_form_name = "15_prtSchedule_men_5.mrd"
'
'        elseif l_grpcd = "2" then                       '2群
'           l_form_name = "15_prtSchedule_women_2.mrd"
'
'        elseif l_grpcd = "4" then                       '4群
'           '## 2006/12/06 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
'           ''l_form_name = "15_prtSchedule_women_4.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_4_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_4_gf.mrd"
'           end if
'           '## 2006/12/06 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##
'
'        elseif l_grpcd = "6" then                       '6群
'           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
'           ''l_form_name = "15_prtSchedule_women_6.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_6_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_6_gf.mrd"
'           end if
'           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##
'
''### 2006/08/05 張 臨時的に８群誘導経路を６群と同じ経路に変更 Start ###
'    '### 2007/02/16 張 元の８群の誘導経路順番に合わせて変更(検査コース区分なし） Start ###
'''        elseif l_grpcd = "8" then                       '8群
'''           l_form_name = "15_prtSchedule_women_8.mrd"
'        elseif l_grpcd = "8" then                       '8群
'           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 Start ##
'           ''l_form_name = "15_prtSchedule_women_6.mrd"
'           if l_giKeiro > 0 then
'                l_form_name = "15_prtSchedule_women_8_gi.mrd"
'           else
'                l_form_name = "15_prtSchedule_women_8_gf.mrd"
'           end if
'           '## 2006/10/24 張 スケジュール表をコース別(GI・GF)に分けて印刷できるように変更 End   ##
'    '### 2007/02/16 張 元の８群の誘導経路順番に合わせて変更(検査コース区分なし） End   ###
'           
''### 2006/08/05 張 臨時的に８群誘導経路を６群と同じ経路に変更 End   ###
'
''### 2007/04/27 張 レジデンス簡易健診コース追加により追加 Start ###
'        elseif l_grpcd = "190" then                                         'レジデンス簡易健診
'           l_form_name = "15_prtSchedule_residence.mrd"
''### 2007/04/27 張 レジデンス簡易健診コース追加により追加 End   ###
'
''### 2007/06/27 張 乳がん検診コース追加により追加 Start ###
'        elseif l_grpcd = "273" or l_grpcd = "274" then                      ' 乳がん検診
'           l_form_name = "15_prtSchedule_breast.mrd"
''### 2007/06/27 張 乳がん検診コース追加により追加 End   ###
'
'        elseif (l_grpcd = "50" and l_dayID = "1") or l_grpcd = "250" then   '午前企業健診(男性)・渡航内科
'           l_form_name = "15_prtSchedule_menAM.mrd"
'
'        elseif l_grpcd = "50" and l_dayID = "2" then                        '午前企業健診(女性)
'           l_form_name = "15_prtSchedule_womenAM.mrd"
'
'        elseif l_grpcd = "51" and l_dayID = "1" then                        '午後企業健診(男性)
'           l_form_name = "15_prtSchedule_menPM.mrd"
'
'        elseif l_grpcd = "51" and l_dayID = "2" then                        '午後企業健診(女性)
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'
''### 2008/06/23 張 後日女性セットコースは午前企業の女性スケジュール表を印刷するように機能追加 ###
'        elseif l_grpcd = "700" then                                         '後日女性セット
'           l_form_name = "15_prtSchedule_womenAM.mrd"
'
'        elseif l_grpcd = "67" then                                          '特定保健指導（積極的）
'           l_form_name = "15_prtSchedule_special.mrd"
'
'        elseif l_grpcd = "20" and l_dayID = "1" then                        '職員健診(男性)
'           l_form_name = "15_prtSchedule_men_1.mrd"
'
'        elseif l_grpcd = "20" and l_dayID = "2" then                        '職員健診(女性)
'           l_form_name = "15_prtSchedule_women_2.mrd"
'
'        else
'           l_form_name = "15_prtSchedule_womenPM.mrd"
'        end if
''    end if
'    '## 2006.03.20 張 特定受診者のみ男性受診者の乳房超音波室検査実施（例外処理）によるスケジュール表変更 End   ##
'
'
''## 2005.11.17 張 乳房超音波室追加(移設)によるスケジュール表変更（郡毎に違うレポートフォーマットを呼び出す) End   ##
'
'        Set objSpecialInterview = Nothing
'
'#### 2010.06.28 SL-UI-Y0101-237 DEL END ####'

'#### 2010.06.28 SL-UI-Y0101-237 ADD START ####'
'帳票出力処理制御
vntMessage = PrintControl(0)	'モード("0":はがき、"1":一式書式)

Sub GetQueryString()
End Sub

Function CheckValue()
End Function

Function Print()
    Dim objPrintCls     '団体一覧出力用COMコンポーネント
    Dim Ret             '関数戻り値
    Dim strObjName      'オブジェクト名

	'情報漏えい対策用ログ書き出し
	Call putPrivacyInfoLogWithUserID("PH053", "スケジュール表の印刷を行った", l_useID)

    Set objSpecialInterview = Server.CreateObject("HainsSpecialInterview.SpecialInterview")


'########## 2012/09/21 張 受診予定検査項目及び誘導順番は受診者別誘導情報を参照して印刷できるように仕様変更 Start ##########
'    '1群
'    If l_grpcd = "1" Then
'        If objSpecialInterview.CheckSetClassCd(l_rsvno, strMMGCd) Then
'            strObjName = "HainsprtSchedule.prtSchedule_men_1S"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_men"
'        End If
'
'
'    '7群
'    ElseIf l_grpcd = "7" Then
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 Start ########################
''        If objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) Then
''            strObjName = "HainsprtSchedule.prtSchedule_men_7S"
''        Else
''            strObjName = "HainsprtSchedule.prtSchedule_men"
''        End If
''## 2012/09/03 張 7群は元の誘導順に戻す
'        If objSpecialInterview.CheckSetClassCd(l_rsvno, strBreastEchoCd) Then
'            strObjName = "HainsprtSchedule.prtSchedule_men_7S_e"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_men_e"
'        End If
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 End   ########################
'
'
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 Start ########################
''    '3群、5群、肺ドック、職員健診(男性)
''    ElseIf (l_grpcd = "3") Or (l_grpcd = "5") Or (l_grpcd = "100") Or (l_grpcd = "20" And l_dayID = "1") Then
''        strObjName = "HainsprtSchedule.prtSchedule_men"
'    ElseIf (l_grpcd = "3") Or (l_grpcd = "100") Or (l_grpcd = "20" And l_dayID = "1") Then
'        strObjName = "HainsprtSchedule.prtSchedule_men"
'
'    ElseIf (l_grpcd = "5") Then
'        strObjName = "HainsprtSchedule.prtSchedule_men_e"
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 End   ########################
'
'
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 Start ########################
''    '2群、4群、職員健診(女性)
''    ElseIf (l_grpcd = "2") Or (l_grpcd = "4") Or (l_grpcd = "20" And l_dayID = "2") Then
''        strObjName = "HainsprtSchedule.prtSchedule_women"
'    ElseIf (l_grpcd = "2") Or (l_grpcd = "20" And l_dayID = "2") Then
'        strObjName = "HainsprtSchedule.prtSchedule_women"
'
'    ElseIf (l_grpcd = "4") Then
'        strObjName = "HainsprtSchedule.prtSchedule_women_e"
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 End   ########################
'
'
'
''    ElseIf (l_grpcd = "6") Or (l_grpcd = "8") Then
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 Start ########################
''        If l_giKeiro > 0 Then
''            strObjName = "HainsprtSchedule.prtSchedule_women_gi"
''        Else
''            strObjName = "HainsprtSchedule.prtSchedule_women"
''        End If
'
'    '6群、8群
'    ElseIf l_grpcd = "6" Or (l_grpcd = "8") Then
'
'        If l_giKeiro > 0 Then
'            strObjName = "HainsprtSchedule.prtSchedule_women_gi_e"
'        Else
'            strObjName = "HainsprtSchedule.prtSchedule_women_e"
'        End If
'
''## 2012/08/23 張 誘導順序変更トライアルの為臨時変更 End   ########################
'
'    'レジデンス簡易健診
'    ElseIf l_grpcd = "190" Then
'        strObjName = "HainsprtSchedule.prtSchedule_residence"
'
'    '乳がん検診
'    ElseIf l_grpcd = "273" Or l_grpcd = "274" Then
'        strObjName = "HainsprtSchedule.prtSchedule_breast"
'
'    '特定保健指導（積極的）
'    ElseIf l_grpcd = "67" Then
'        strObjName = "HainsprtSchedule.prtSchedule_special"
'
'    '午前企業健診(男性)、渡航内科
'    ElseIf (l_grpcd = "50" And l_dayID = "1") Or (l_grpcd = "250") Then
'        strObjName = "HainsprtSchedule.prtSchedule_menAM"
'
'    '午前企業健診(女性)、後日女性セット
'    ElseIf (l_grpcd = "50" And l_dayID = "2") Or (l_grpcd = "700") Then
'        strObjName = "HainsprtSchedule.prtSchedule_womenAM"
'
'    '午後企業健診(男性)
'    ElseIf l_grpcd = "51" And l_dayID = "1" Then
'        strObjName = "HainsprtSchedule.prtSchedule_menPM"
'
'    '午後企業健診(女性)
'    ElseIf l_grpcd = "51" And l_dayID = "2" Then
'        strObjName = "HainsprtSchedule.prtSchedule_womenPM"
'
'    Else
'        strObjName = "HainsprtSchedule.prtSchedule_womenPM"
'
'    End If

    strObjName = "HainsprtSchedule.prtSchedule_standard"

'########## 2012/09/21 張 受診予定検査項目及び誘導順番は受診者別誘導情報を参照して印刷できるように仕様変更 End   ##########

    'オブジェクトのインスタンス作成
    Set objPrintCls = Server.CreateObject(strObjName)

    'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
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
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
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
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
<!-- '#### 2010.06.28 SL-UI-Y0101-237 ADD END ####' -->
