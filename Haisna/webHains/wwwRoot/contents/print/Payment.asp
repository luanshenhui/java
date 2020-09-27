<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	請求書 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-211~212
'       修正日  ：2010.05.13
'       担当者  ：ASC)三浦
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"           -->
<!-- #include virtual = "/webHains/includes/common.inc"                 -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"            -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"         -->
<!-- #include virtual = "/webHains/includes/print.inc"                  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdClassList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editJudClassList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ
Dim strURL			'URL
Dim UID
'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用

'引数値
Dim strSCslDate,strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslDate,strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strOrgCd1, strOrgCd2					'団体コード
Dim strOrgName								'団体名
Dim strBillClass							'請求書分類
Dim strBillNo								'請求書番号
Dim strBillNo2								'請求書番号

Dim strOutPutCls							'出力対象
Dim strUpdFlg								'印刷日付更新対象フラグ
Dim strOutPutCls2							'出力対象
Dim strArrOutputCls()						'出力対象区分
Dim strArrOutputClsName()					'出力対象区分名

Dim strArrOutputCls2()						'出力対象区分
Dim strArrOutputClsName2()					'出力対象区分名
'作業用変数
Dim i, j			'カウンタ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'共通引数値の取得
strMode = Request("mode")

'出力対象区分，名称の生成
Call CreateOutputInfo()

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'開始年
		strSCslMonth  = Month(Now())			'開始月
		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
		strSCslDay    = Request("strCslDay")	'開始日
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'## 2003/12/30 Del Start NSC@birukawa 帳票とのインタフェース対応
''◆ 終了年月日
'	If IsEmpty(Request("endCslYear")) Then
'		strECslYear   = Year(Now())				'終了年
'		strECslMonth  = Month(Now())			'開始月
'		strECslDay    = Day(Now())				'開始日
'	Else
'		strECslYear   = Request("endCslYear")	'終了年
'		strECslMonth  = Request("endCslMonth")	'開始月
'		strECslDay    = Request("endCslDay")	'開始日
'	End If
'	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
''◆ 開始年月日と終了年月日の大小判定と入替
''   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
'	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strECslDay)), 2) Then
'		strSCslYear   = strECslYear
'		strSCslMonth  = strECslMonth
'		strSCslDay    = strECslDay
'		strSCslDate   = strECslDate
'		strECslYear   = Request("strCslYear")	'開始年
'		strECslMonth  = Request("strCslMonth")	'開始月
'		strECslDay    = Request("strCslDay")	'開始日
'		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'	End If
'## 2003/12/30 Del End   NSC@birukawa 帳票とのインタフェース対応

'◆ 出力対象
	strOutputCls	= Request("outputCls")		'対象

	strOutputCls2	= Request("outputCls2")		'対象
'◆ 請求書番号
	strBillNo 		= Request("billNo")
	strBillNo2 		= Request("billNo2")

UID = Session("USERID")
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim vntArrMessage	'エラーメッセージの集合

	'ここにチェック処理を記述
	With objCommon
		If strMode <> "" Then

			'◆ 開始日付整合性チェック
			If Not IsDate(strSCslDate) Then
'## 2003/12/30 Upd Start NSC@birukawa 帳票とのインタフェース対応
'				.AppendArray vntArrMessage, "開始日付が正しくありません。"
'				.AppendArray vntArrMessage, "入金日が正しくありません。"
'## 2004/12/22 Upd Start イーコーポ@張 帳票とのインタフェース対応
				.AppendArray vntArrMessage, "計上日が正しくありません。"
'## 2004/12/22 Upd End イーコーポ@張 帳票とのインタフェース対応
'## 2003/12/30 Upd End   NSC@birukawa 帳票とのインタフェース対応
			End If

'## 2003/12/30 Upd Start NSC@birukawa 帳票とのインタフェース対応
'			'◆ 終了日付整合性チェック
'			If Not IsDate(strECslDate) Then
'				.AppendArray vntArrMessage, "終了日付が正しくありません。"
'			End If
'## 2003/12/30 Upd End   NSC@birukawa 帳票とのインタフェース対応

			'◆ 請求書番号チェック
'			if strBillNo <> ""  then
'				if( isNumeric(strBillNo) = false ) Then
'					.AppendArray vntArrMessage, "請求書番号に間違いがあります。"
'				else
'					.AppendArray vntArrMessage, .CheckNumeric("請求書番号",strBillNo, 9)
'				end if	
'			end If
		End If

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls	'団体一覧出力用COMコンポーネント
	Dim objBill		'請求書テーブル用COMコンポーネント
	Dim PrintRet	'関数戻り値
	Dim UpdateRet	'関数戻り値
Dim objCommon
	If Not IsArray(CheckValue()) Then

	'情報漏えい対策用ログ書き出し
	Call putPrivacyInfoLog("PH027", "入金ジャーナル・入金台帳の印刷を行った")

'■■■■■■■■■■ 画面項目にあわせて編集
		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
'		Set objPrintCls = Server.CreateObject("HainsBillList.BillList")
'*****  2003/03/07  EDIT  START  E.Yamamoto  帳票用モジュール「PrintDba2」へモジュール移動のため修正
'		Set objBill = Server.CreateObject("HainsBill.Bill")
'		Set objBill = Server.CreateObject("HainsPrintDba2.PrintDba2")
'*****  2003/03/07  EDIT  START  E.Yamamoto  帳票用モジュール「PrintDba2」へモジュール移動のため修正

		'請求書ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'		PrintRet = objPrintCls.PrintBillDetailList( Session("USERID"),  ,  _
'													strOutputCls,  _
'													strBillNo, _
'													strSCslDate, _
'													strECslDate , _
'													strOrgCd1, _
'													strOrgCd2, _
'													strBillClass _
'												  )
'											 
'		If( PrintRet > 0 AND strUpdFlg = "1" ) Then
'			UpdateRet = objBill.UpdateBillPrtDate(   strBillNo, _
'													 strSCslDate, _
'													 strECslDate , _
'													 strOrgCd1, _
'													 strOrgCd2, _
'													 strBillClass _
'											   )
'		End If
'■■■■■■■■■■
'		Print = PrintRet

'#### 2010.05.13 SL-UI-Y0101-211~212 MOD START ####'

'Set objCommon = Server.CreateObject("HainsCommon.Common")
'strURL = "/webHains/contents/report_form/rd_20_Payment.asp"
'strURL = strURL & "?p_Uid=" & UID
''## 2003/12/30 Upd Start NSC@birukawa 帳票とのインタフェース対応
''strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
''strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'strURL = strURL & "&p_PayDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
''## 2003/12/30 Upd End   NSC@birukawa 帳票とのインタフェース不正
'Set objCommon = Nothing
'strURL = strURL & "&p_Option1=" & strOutputCls 
'strURL = strURL & "&p_Option2=" & strOutputCls2 
'Response.Redirect strURL
'Response.End

	'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
	if strOutputCls2 = "0" then
		Set objPrintCls = Server.CreateObject("HainsPaymentJa.PaymentJa")
	Else
		Set objPrintCls = Server.CreateObject("HainsPaymentDai.PaymentDai")
	End if
	'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
	PrintRet = objPrintCls.PrintOut(UID, _
							   strSCslDate, _
							   strOutputCls, _
							   strOutputCls2)

	Print = PrintRet

'#### 2010.05.13 SL-UI-Y0101-211~212 MOD END ####'



	End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 出力対象に関する配列を生成する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Sub CreateOutputInfo()

	Redim Preserve strArrOutputCls(3)
	Redim Preserve strArrOutputClsName(3)
	Redim Preserve strArrOutputCls2(1)
	Redim Preserve strArrOutputClsName2(1)

	strArrOutputCls2(0) = "0":strArrOutputClsName2(0) = "入金ジャーナル"
	strArrOutputCls2(1) = "1":strArrOutputClsName2(1) = "入金台帳"

	strArrOutputCls(0) = "0":strArrOutputClsName(0) = "全指定"
	strArrOutputCls(1) = "1":strArrOutputClsName(1) = "端末１"
     strArrOutputCls(2) = "2":strArrOutputClsName(2) = "端末2"
    strArrOutputCls(3) = "3":strArrOutputClsName(3) = "端末3"



End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>領収書</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {


}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">入金ジャーナル・入金台帳</FONT></B></TD>
		</TR>
	</TABLE>
<%
'エラーメッセージ表示

	'メッセージの編集
	If( strMode <> "" )Then

		'保存完了時は「保存完了」の通知
		Call EditMessage(vntMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

<!--- 日付 -->
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
<!--- ## 2004/12/22 Upd Start イーコーポ@張 帳票とのインタフェース対応 -->
			<!--TD WIDTH="90" NOWRAP>入金日</TD-->
			<TD WIDTH="90" NOWRAP>計上日</TD>
<!--- ## 2004/12/22 Upd End   イーコーポ@張 帳票とのインタフェース対応 -->
<!--- 日付 -->
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>日</TD>

<!-- ##2003/12/30 Upd Start NSC@birukawa 帳票とのインタフェース対応
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>日</TD>
-->
		</TR>
	</TABLE>
			<!--- 請求書番号 -->
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>端末名</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
		</TR>
	</TABLE>
		
			<table border="0" cellpadding="1" cellspacing="2">
				<tr>
					<td><font color="#ff0000">■</font></td>
					<td width="90" nowrap>帳票選択</td>
					<td>：</td>
					<td><%= EditDropDownListFromArray("outputCls2", strArrOutputCls2, strArrOutputClsName2 , strOutputCls2, NON_SELECTED_DEL) %></td>
				</tr>
			</table>
			<p><BR>
				<!--- 印刷モード --><!--  2003/03/05  ADD  START  E.Yamamoto  印刷は全てプレビューとするため固定設定とする  --><INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/03/05  ADD  END    E.Yamamoto  印刷は全てプレビューとするため固定設定とする  --><%
'*****  2003/03/05  DEL  START  E.Yamamoto  印刷は全てプレビューとするため削除  
'	'印刷モードの初期設定
'	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
'*****  2003/03/05  DEL  END    E.Yamamoto  印刷は全てプレビューとするため削除  
%><!--  2003/03/05  DEL  START  E.Yamamoto  印刷は全てプレビューとするため削除  --><!--
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <% ' = IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>プレビュー</TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <% ' = IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>直接出力</TD>
		</TR>
	</TABLE>
--><!--  2003/03/05  DEL  END    E.Yamamoto  印刷は全てプレビューとするため削除  --><BR>
				<BR>
				<!--- 印刷ボタン -->
				<!---2006.07.04 権限管理 追加 by 李  -->
				<% If Session("PAGEGRANT") = "4" Then   %>
					<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
				<%  End if  %>
				<br>
				
</FORM></p>
			<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
		

</BODY>
</HTML>