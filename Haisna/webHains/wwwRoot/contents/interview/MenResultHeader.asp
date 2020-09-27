<%@ LANGUAGE="VBScript" %>
<%
'========================================
'管理番号：SL-HS-Y0101-003
'修正日  ：2010.08.09
'担当者  ：FJTH)KOMURO
'修正内容：連携先サーバ名の変換
'========================================
'========================================
'管理番号：SL-SN-Y0101-305
'修正日  ：2011.07.01
'担当者  ：ORB)YAGUCHI
'修正内容：大腸３Ｄ－ＣＴ、頸動脈超音波、動脈硬化、内臓脂肪面積、心不全スクリーニングの追加
'========================================
'-----------------------------------------------------------------------------
'      検査結果表示（ヘッダ） (Ver0.0.1)
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
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objInterView        '面接情報アクセス用

'パラメータ
Dim	strWinMode          'ウィンドウモード
Dim strGrpNo            'グループNo
Dim lngRsvNo            '予約番号（今回分）
Dim strCsCd             'コースコード

Dim lngLastDspMode      '前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp            '前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntPerId            '個人ＩＤ
Dim vntRsvNo            '予約番号
Dim vntCslDate          '受診日
Dim vntCsCd             'コースコード
Dim vntCsName           'コース名
Dim vntCsSName          'コース略称
Dim lngHisCount         '表示歴数

'心電図連携用
Dim strUrlEcgWave       'URL（心電図波形）

'RayPax連携用
Dim vntOrderNo          'オーダ番号
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
Dim vntSendDate         '送信日
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

'### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為追加 Start ###
Dim vntPerIdBefore      '変更前個人ID
Dim vntPerIdAfter       '変更後個人ID
Dim vntResultPerId      'RayPaxにリンクする個人ID
'### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為追加 End   ###

Dim strUrlRayPaxReport  'URL（RayPaxレポート）
Dim strUrlRayPaxImage   'URL（RayPax画像）

'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
Dim strUrlCaviAbiImage  'URL（動脈硬化画像）
'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'引数値の取得
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

'グループ情報取得
Call GetMenResultGrpInfo(strGrpNo)

Select Case strSelCsGrp
    'すべてのコース
    Case "0"
        lngLastDspMode = 0
        vntCsGrp = ""
    '同一コース
    Case "1"
        lngLastDspMode = 1
        vntCsGrp = strCsCd
    Case Else
        lngLastDspMode = 2
        vntCsGrp = strSelCsGrp
End Select

Do
    '指定された予約番号の受診歴一覧を取得する
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
        Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If

    '表示ボタン押下時に呼び出される自画面の関数を設定する
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
<TITLE>検査結果表示</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//表示
function callMenResultTop() {

    // Topに選択されたコースグループを指定してsubmit
    parent.params.csgrp = document.entryForm.csgrp.value;

    // 非表示フラグ
    parent.params.hideflg = document.entryForm.hideflg.value;

    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

//表示切替
function chgHideFlg() {

    // 非表示フラグを反転
    if( document.entryForm.hideflg.value == 1 ) {
        document.entryForm.hideflg.value = 0;
    } else {
        document.entryForm.hideflg.value = 1;
    }

    //表示処理
    callMenResultTop();
}

//ＣＵ経年変化画面呼び出し
function callCUMainGraph() {
    var myForm = parent.body1.document.entryForm;
    var url;                            // URL文字列
    var i;                              // インデックス
    var SelectItemcd;                   // 選択された検査項目コード
    var SelectSuffix;                   // 選択されたサフィックス
    var SelectCnt;                      // 選択数

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
        alert("表示検査項目を最低１つは選択してください");
        return;
    }

    if( SelectCnt > 20 ) {
        alert("表示検査項目の最大選択数は２０件です");
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

//検査結果表示～更新モード画面呼び出し
function callMenResultEntry() {
    var url;                                // URL文字列

    url = '/WebHains/contents/interview/MenResult.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&grpno=' + '<%= strGrpNo %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&csgrp=' + '<%= strSelCsGrp %>';
    url = url + '&entrymode=' + '<%= INTERVIEWRESULT_ENTRY %>';

    parent.location.href(url);

}

//保存
function saveMenResult() {

    // 所見情報の前詰め
    parent.body3.sortSentenceInfo();

    // モードを指定してsubmit
    parent.body3.document.entryForm.act.value = 'save';
    parent.body3.document.entryForm.submit();

}

//検査結果表示～参照モード画面呼び出し
function callMenResult() {
    var url;                            // URL文字列

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
    '「別ウィンドウで表示」の場合、ヘッダー部分表示
    If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="entrymode" VALUE="<%= lngEntryMode %>">
    <INPUT TYPE="hidden" NAME="hideflg"   VALUE="<%= lngHideFlg %>">

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="920">
        <TR>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000"><%= strMenResultTitle %>　検査結果表示</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
<%
            '前回歴コンボボックス表示
            Call  EditCsGrpInfo( lngRsvNo )
%>
        </TR>
    </TABLE>
    <!-- 受診履歴の表示 -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="920">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP HEIGHT="30">前回受診日：</TD>
<%
    If lngHisCount > 1 Then
%>
                        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(1) %>　<%= vntCsSName(1) %></B></FONT></TD>
<%
    Else
%>
                        <TD NOWRAP>&nbsp;</TD>
<%
    End If
%>
                        <TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
                        <TD NOWRAP>前々回受診日：</TD>
<%
    If lngHisCount > 2 Then
%>
                        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(2) %>　<%= vntCsSName(2) %></B></FONT></TD>
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
    '更新モード
    Select Case Clng(lngEntryMode)
    Case INTERVIEWRESULT_REFER

        If lngMenResultTypeNo = INTERVIEWRESULT_TYPE1 Or _
           lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callCUMainGraph()">ＣＵ経年変化</A></TD>
<%
        End If

        If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
           lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="JavaScript:chgHideFlg()">表示切替</A></TD>

            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="JavaScript:callMenResultEntry()">所見修正画面</A></TD>
            <%  end if  %>
<%
        End If

    Case INTERVIEWRESULT_ENTRY
%>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD NOWRAP>　<A HREF="JavaScript:saveMenResult()"><IMG SRC="../../images/save.gif" ALT="保存" HEIGHT="24" WIDTH="77"></A></TD>
            <%  end if  %>

            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callMenResult()">参照専用画面へ</A></TD>
<%
    End Select

'#### 2011.07.01 SL-SN-Y0101-305 MOD START ####
'    If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
'       lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Then
    If lngMenResultTypeNo = INTERVIEWRESULT_TYPE2 Or _
       lngMenResultTypeNo = INTERVIEWRESULT_TYPE3 Or _
      (lngMenResultTypeNo = INTERVIEWRESULT_TYPE1 And _
       strMenResultTitle  = "内臓脂肪面積") Then
'#### 2011.07.01 SL-SN-Y0101-305 MOD END ####

'### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為追加 Start ###
            vntPerIdBefore = ""
            vntPerIdAfter = ""
            vntResultPerId = ""

            objInterView.SelectChangePerId lngRsvNo, vntPerIdBefore, vntPerIdAfter
            If vntPerIdBefore <> "" Then
                vntResultPerId = vntPerIdAfter
            Else
                vntResultPerId = vntPerId(0)
            End If

'### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為追加 End   ###

        '心電図のとき
        If strMenResultTitle = "心電図" Then
            '---------------------------------------------------------------------------------
            '心電図連携
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax画像レポート表示あり
            If strRayPaxOrdDiv <> "" Then
                'オーダ番号を取得する
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo

                If vntOrderNo <> "" Then
                    '心電図波形のURL
                    '#### 2009.01.22 張 新生理検査システム導入に伴う仕様変更 ####
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
            <TD NOWRAP WIDTH="100%" ALIGN="right">　　<A HREF="<%= strUrlEcgWave %>" TARGET="_blank">波形</A></TD>
<%
                End If
            End If
'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
        '動脈硬化のとき
        ElseIf strMenResultTitle = "動脈硬化" Then
            '---------------------------------------------------------------------------------
            '動脈硬化連携
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax画像レポート表示あり
            If strRayPaxOrdDiv <> "" Then
                'オーダ番号を取得する
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo

                If vntOrderNo <> "" Then
                    '動脈硬化のURL
                    strUrlCaviAbiImage = ""
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "http://" & convertAddress("CaviABi") & "/scripts8800/ecg_idx.exe"
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "?PID="   & vntPerId(0)
                    strUrlCaviAbiImage = strUrlCaviAbiImage & "&ORDER=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yyyymmdd")

                    '動脈硬化レポートのURL
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo

%>
            <TD NOWRAP WIDTH="100%" ALIGN="right">　　<A HREF="<%= strUrlCaviAbiImage %>" TARGET="_blank">画像</A></TD>
            <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">レポート</A></TD>
<%
                End If
            End If
'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####
        Else
            '---------------------------------------------------------------------------------
            'RayPax連携その１
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax画像レポート表示あり
            If strRayPaxOrdDiv <> "" Then
                'オーダ番号を取得する
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv, vntOrderNo, vntSendDate
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

                If vntOrderNo <> "" Then
                    'RayPax画像のURL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = "http://157.104.35.15/ext/ShowImage.asp"
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 Start ###
''                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntResultPerId
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 End   ###
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

                    'RayPaxレポートのURL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxReport = "http://157.104.35.15/ext/ShowReport.asp"
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 Start ###
''                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntResultPerId
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 End   ###
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
            <TD NOWRAP WIDTH="100%" ALIGN="right">　　<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">画像</A></TD>
            <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">レポート</A></TD>
<%
                End If
            End If

            '---------------------------------------------------------------------------------
            'RayPax連携その２
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax画像レポート表示あり
            If strRayPaxOrdDiv2 <> "" Then
                'オーダ番号を取得する
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv2, vntOrderNo
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv2, vntOrderNo, vntSendDate
'#### 2011.01.20 SL-HS-Y0101-003 MOD END   ####

                If vntOrderNo <> "" Then
                    'RayPax画像のURL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxImage = "http://157.104.35.15/ext/ShowImage.asp"
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 Start ###
''                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxImage = strUrlRayPaxImage & "?PatientID=" & vntResultPerId
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 End   ###
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

                    'RayPaxレポートのURL
'#### 2010.08.09 SL-HS-Y0101-003 MOD START ####
'                    strUrlRayPaxReport = "http://157.104.35.15/ext/ShowReport.asp"
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 Start ###
''                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntPerId(0)
'                    strUrlRayPaxReport = strUrlRayPaxReport & "?PatientID=" & vntResultPerId
''### 2006.02.10 張 健診完了後変更された受診者個人ID追跡の為変更 End   ###
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
            <TD NOWRAP WIDTH="100%" ALIGN="right">　　<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">画像</A></TD>
<!-- #### 2010.08.09 SL-HS-Y0101-003 MOD START #### 
<!--            <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">レポート</A></TD> -->
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="javascript:void(window.open('<%= strUrlRayPaxReport %>', '', 'width=400,height=200'));">レポート</A></TD>
<!-- #### 2010.08.09 SL-HS-Y0101-003 MOD END   #### -->
<%
                End If
            End If

'#### 2013.01.08 SL-SN-Y0101-611 ADD START ####
            '---------------------------------------------------------------------------------
            'RayPax連携その３
            '---------------------------------------------------------------------------------
            vntOrderNo = ""
            'RayPax画像レポート表示あり
            If strRayPaxOrdDiv3 <> "" Then

                'オーダ番号を取得する
                objInterView.SelectOrderNo lngRsvNo, strRayPaxOrdDiv3, vntOrderNo, vntSendDate

                If vntOrderNo <> "" Then

                    'RayPax画像のURL
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

                    'RayPaxレポートのURL
                    strUrlRayPaxReport = ""
                    strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
                    strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
                    strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&userid="  & Session("USERID")
                    strUrlRayPaxReport = strUrlRayPaxReport & "&perid="   & vntPerId(0)
                    strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
%>
                    <TD NOWRAP WIDTH="100%" ALIGN="right">　　<A HREF="<%= strUrlRayPaxImage %>" TARGET="_blank">画像</A></TD>
                    <TD NOWRAP WIDTH="100%" ALIGN="right">　<A HREF="<%= strUrlRayPaxReport %>" TARGET="_blank">レポート</A></TD>
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
