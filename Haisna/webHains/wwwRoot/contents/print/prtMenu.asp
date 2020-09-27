<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		印刷メニュー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>印刷</TITLE>
<STYLE TYPE="text/css">
#container h3 {
border-bottom: 1px solid #999999;
border-left: 10px solid #999999;
width: 625px;
margin: 20px 0 0 10px;
padding: 3px 0 2px 8px;
}

#container ul { 
list-style-type: none; 
margin: 12px 0 15px 20px;
font-size: 120%;
}

#container li {
height: 1.4em;
}

td.prttab { background-color:#ffffff }
</style>

</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
<TR VALIGN="bottom">
<TD COLSPAN="2"><FONT SIZE="+2"><B>印刷</B></FONT></TD>
</TR>
<TR HEIGHT="2">
<TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
</TR>
</TABLE>

<div id="container">
<h3>健診準備処理 </h3>
<ul>
  <li><a href="prtAfterPostcard.asp">■一年目はがき</a></li>
  <li><a href="prtFaxPaper.asp">■みずほFAX用紙</a></li>
  <li><a href="prtInvitation.asp">■一括送付案内</a></li>
  <li><a href="prtInstructionList.asp">■ご案内書送付チェックリスト</a></li>
  <li><a href="prtCheckDoubleID.asp">■２重ＩＤ登録チェックリスト</a></li>
  <li><a href="prtPatientList.asp">■新患登録リスト </a></li>
  <li><a href="prtCsvStudy.asp">■事前チャートスタディ用受診者リストCSV出力</a></li>
</ul>
<h3>当日処理</h3>
<ul>
  <li><a href="prtReserveList.asp">■予約者一覧表</a></li>
  <li><a href="prtConsultCheck.asp">■受診予定者チェックシート</a></li>
  <li><a href="PrtEndoscopeList.asp">■内視鏡受付一覧</a></li>
  <li><a href="PrtEndoscopeDisinfection.asp">■内視鏡洗浄消毒履歴</a></li>
  <li><a href="prtNurseCheck.asp">■ナースチェックリスト</a></li>
  <li><a href="prtWorkSheetCheck.asp">■ワークシート８項目</a></li>
  <li><a href="Payment.asp">■入金ジャーナル・入金台帳</a></li>
  <li><a href="prtWorkSheetPatient.asp">■ワークシート個人票チェックリスト</a></li>
  <li><a href="prtPatient.asp">■個人票</a></li>
  <li><a href="prtWomanList.asp">■女性受診者リスト</a></li>
  <li><a href="prtSpecialList.asp">■特定健診受診者リスト</a></li>
  <li><a href="prtFollowList.asp">■フォローアップ対象者リスト</a></li>
</ul>
<h3>健診結果関連</h3>
<ul>
  <li><a href="prtWorkSheetLast.asp">■ワークシート前回値参照（血清）</a></li>
  <li><a href="prtEndoscopeCheck.asp">■内視鏡チェックリスト</a></li>
  <li><a href="prtWarningList_New.asp">■個人異常値リスト</a></li>
  <li><a href="prtReport6.asp">■成績書</a></li>
  <li><a href="prtReportCheckList.asp">■成績書チェックリスト</a></li>
  <li><a href="prtPostList.asp">■郵便物受領証</a></li>
</ul>
<h3>後日処理</h3>
<ul>
  <li><a href="prtReceivable.asp">■未収金</a></li>
  <li><a href="prtOrgBill.asp">■請求書</a></li>
  <li><a href="prtBillCheck.asp">■請求書チェックリスト</a></li>
  <li><a href="prtBillReportCheck.asp">■請求書チェックリスト（成績書）</a></li>
  <li><a href="prtPaymentList.asp">■団体入金台帳</a></li>
  <li><a href="prtOrgArrears.asp">■未収団体一覧表</a></li>
  <li><a href="prtDirectMail.asp">■団体ダイレクトメール</a></li>
  <!--li><a href="prtcsv.asp">■花王CSV出力</a></li>
  <li><a href="prtcsvsony.asp">■ソニーマーケティングCSV出力</a></li>
  <li><a href="prtcsvunyu.asp">■外国運輸CSV出力</a></li>
  <li><a href="prtcsvden.asp">■電通TXT出力</a></li>
  <li><a href="prtcsvkousei.asp">■厚生労働省CSV出力</a></li>
  <li><a href="prtcsvaioi.asp">■あいおい健保CSV出力</a></li>
  <li><a href="prtcsvuo.asp">■築地市場CSV出力</a></li>
  <li><a href="prtcsvNomura.asp">■標準（野村證券形式）FD出力 </a></li-->
  <!--li><a href="prtcsvNissay.asp">■ニッセイ同和CSV出力 </a></li-->
  <li><a href="prtcsvOrgJudCount.asp">■総合判定別人数CSV出力 </a></li>
  <li><a href="prtcsvOrgjudrsl.asp">■団体別判定結果CSV出力 </a></li>
  <li><a href="prtcsvBasicInfo.asp">■団体別受診者（健診基本情報）CSV出力 </a></li>
  <!--li><a href="prtcsvCityGrp.asp">■シティグループ健診結果取込用CSV出力</a></li-->
  <li><a href="prtcsvSpecialXML.asp">■特定健診項目健診結果XML変換用CSV出力　①③</a></li>
  <li><a href="prtcsvSpecialDir.asp">■特定健診項目健診結果CSV出力（大和総研形式）　②</a></li>
  <li><a href="prtcsvNTTData.asp">■聖路加フォーマット健診結果CSV出力（ＮＴＴデータ形式）　④</a></li>
  <li><a href="prtcsvKensin.asp">■団体健診金額CSV出力</a></li>
  <li></li>
  <li><a href="prtcsvResidence.asp">■聖路加レジデンス提供用CSV出力</a></li>

</ul>
<h3>団体契約関連</h3>
<ul>
  <li><a href="prtCompanyConduct.asp">■契約団体調査票</a></li>
  <li><a href="prtcsvCompany.asp">■団体別契約セット情報CSV出力</a></li>
</ul>
<h3>統計関連</h3>
<ul>
  <li><a href="prtDockStatistics.asp">■人間ドック症例別人数統計</a></li>
  <li><a href="prtCrsOption2.asp">■オプションコースの利用状況</a></li>
  <li><a href="prtConsultConditions.asp">■受診者状況</a></li>
  <li><a href="prtGFConditions.asp">■《内視鏡》実施状況</a></li>
  <li><a href="prtOrgConsultCount.asp">■団体別予約受診人数統計</a></li>
  <li><a href="prtOrgConsultPay.asp">■団体別予約受診料金統計</a></li>
  <li><a href="prtCompany.asp">■カンパニープロファイル</a></li>
  <li><a href="prtRsvMngDay.asp">■予約管理表（Day）</a></li>
  <li><a href="prtRsvMngWeekly.asp">■予約管理表（Weekly）</a></li>
  <li><a href="prtRsvMngMonthly.asp">■予約管理表（Monthly）</a></li>
  <li><a href="prtJHEPconsult.asp">■日本総合健診医学会</a></li>
  <li><a href="prtAneiho.asp">■労働基準監督署統計</a></li>
  <li><a href="prtXrecord.asp">■照射録</a></li>
  <li><a href="prtCreateCsvClog.asp">■団体勧告者出力</a></li>
  <li><a href="prtXsituationsMonth.asp">■Ｘ線受診状況（月)</a></li>
  <li><a href="prtXsituationsYear.asp">■Ｘ線受診状況（年)</a></li>
</ul>
<h3>印刷ログ</h3>
<ul>
  <li><a href="dispReportLog.asp">■印刷ログ</a></li>
</ul>
</div>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>