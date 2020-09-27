<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   栄養計算 (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objNutritionCalc	'栄養計算クラス

Dim strAction		'処理状態

Dim strCslDate		'受診日
Dim strCslYear		'受診日（年）
Dim strCslMonth		'受診日（月）
Dim strCslDay		'受診日（日）

Dim strtodayId		'当日ＩＤ指定方法

Dim lngStartId		'当日ＩＤ（範囲指定：開始）
Dim lngEndId		'当日ＩＤ（範囲指定：終了）
Dim strPluralId		'当日ＩＤ（複数指定）

Dim strEiyokeisan	'栄養計算チェック
Dim strActPattern	'Ａ型行動パターンチェック
Dim strPointLost	'失点判定チェック
Dim strStress		'ストレス計算チェック

Dim vntCalcFlg()	'計算対象フラグ
Dim vntArrDayId		'当日ＩＤ（複数指定の場合の計算処理への引数）
Dim strUpdUser		'更新者
Dim strIPAddress	'IPアドレス	

Dim Ret				'関数復帰値

Dim strArrMessage		'エラーメッセージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
Set objNutritionCalc    = Server.CreateObject("HainsNutritionCalc.nutritionCalc")

strAction        = Request("act")

strtodayId       = Request("chktodayId")

strCslYear       = Request("cslyear")
strCslMonth      = Request("cslmonth")
strCslDay        = Request("cslday")

strEiyokeisan    = Request("checkEiyo")
strActPattern	 = Request("checkActPattern")
strPointLost	 = Request("checkPointLost")
strStress	     = Request("checkStress")

lngStartId       = Request("startId")
lngEndId         = Request("endId")
strPluralId      = Request("pluralId")

strtodayId = IIf( strtodayId = "", 0, strtodayId )


'日付未指定の場合、システム年月日を適用する
If strCslYear = "" Then
	strCslYear  = CStr(Year(Now))
	strCslMonth = CStr(Month(Now))
	strCslDay   = CStr(Day(Now))
End If

'計算開始
If strAction = "calc" Then

	'受診日編集
	strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay

	Redim Preserve vntCalcFlg(3)
	If strEiyokeisan = "1" Then
		vntCalcFlg(0) = 1
	Else
		vntCalcFlg(0) = 0
	End If
	If strActPattern = "1" Then
		vntCalcFlg(1) = 1
	Else
		vntCalcFlg(1) = 0
	End If
	If strPointLost = "1" Then
		vntCalcFlg(2) = 1
	Else
		vntCalcFlg(2) = 0
	End If
	If strStress = "1" Then
		vntCalcFlg(3) = 1
	Else
		vntCalcFlg(3) = 0
	End If

	If strtodayId = 2 Then
		vntArrDayId = split( strPluralId, "," )
	Else
		vntArrDayId = Array()
		Redim Preserve vntArrDayId(0)
	End If

'	Err.Raise 1000, , "(" & strCslDate & ")(" & strtodayId & ")(" & vntCalcFlg(0) & ")(" & lngStartId & ")(" & lngEndId  & ")"

	
	strUpdUser        = Session.Contents("userId")
	strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

	Ret = objNutritionCalc.nutritionCalcStart (	strUpdUser, _
												strIPAddress, _
												strCslDate, _
    											strtodayId, _
    									        vntCalcFlg, _
    									        lngStartId, _
    									        lngEndId, _
                                                vntArrDayId, _
												strArrMessage _
                                        		)
	If Ret = 0 Then
		strAction = "calcend"
	End If
	
End If

%>
	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>栄養計算</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var curYear, curMonth, curDay;	// 日付ガイド呼び出し直前の日付退避用変数

// 日付ガイド呼び出し
function callCalGuide() {

	// ガイド呼び出し直前の日付を退避
	curYear  = document.entryForm.cslyear.value;
	curMonth = document.entryForm.cslmonth.value;
	curDay   = document.entryForm.cslday.value;

	// 日付ガイド表示
	calGuide_showGuideCalendar( 'cslyear', 'cslmonth', 'cslday');

}

//当日ＩＤチェック
function checktodayIdAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			todayId.value = (todayId[index].checked ? '1' : '');
		} else if (index == 1 ){
			todayId.value = (todayId[index].checked ? '2' : '');
		}
		chktodayId.value = todayId.value;
	}

}

//栄養計算チェック
function checkEiyoAct() {

	with ( document.entryForm ) {
		checkEiyo.value = (checkEiyo.checked ? '1' : '');
	}

}
//Ａ型行動パターンチェック
function checkActPatternAct() {

	with ( document.entryForm ) {
		checkActPattern.value = (checkActPattern.checked ? '1' : '');
	}

}
//失点判定チェック
function checkLostPointAct() {

	with ( document.entryForm ) {
		checkPointLost.value = (checkPointLost.checked ? '1' : '');
	}

}
//ストレス点数チェック
function checkStressAct() {

	with ( document.entryForm ) {
		checkStress.value = (checkStress.checked ? '1' : '');
	}

}

//計算処理呼び出し
function callCalc() {

	var myForm;

	myForm = document.entryForm;

	if ( myForm.todayId[0].checked ){
		if ( myForm.startId.value == '' ||
             myForm.endId.value == '' ){
			alert( "当日ＩＤが指定されていません。");
			return;
		}
	}else if ( myForm.todayId[1].checked ){
		if ( myForm.pluralId.value == '' ){
			alert( "当日ＩＤが指定されていません。");
			return;
		}
	}

	if (myForm.checkEiyo.value == '' &&
	    myForm.checkActPattern.value == '' &&
	    myForm.checkPointLost.value == '' &&
	    myForm.checkStress.value == '' ){
		alert( "計算対象が指定されていません。" );
		return;
	}

	myForm.act.value = "calc";
	myForm.submit();
}

function windowClose() {

	// 日付ガイドウインドウを閉じる
	calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY  ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<BLOCKQUOTE>

<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><font color="#000000">栄養計算</font></B></TD>
		</TR>
	</TABLE>

	<BR>

<%
	'メッセージの編集
	If strAction <> "" Then

		Select Case strAction

			'保存完了時は「正常終了」の通知
			Case "calcend"
				Call EditMessage("計算が正常終了しました。", MESSAGETYPE_NORMAL)

			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:callCalGuide()"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" border="0"></A></TD>
			<TD><%= EditSelectNumberList("cslyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strCslYear)) %></TD>
			<TD>年</TD>
			<TD><%= EditSelectNumberList("cslmonth", 1, 12, CLng("0" & strCslMonth)) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("cslday",   1, 31, CLng("0" & strCslDay  )) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<!--- コース -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<INPUT TYPE="hidden" NAME="chktodayId" VALUE="<%= strtodayId %>" >
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>当日ID</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "1", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(0)" BORDER="0">範囲指定<INPUT TYPE="text" NAME="startId" VALUE="<%= lngStartId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;">～<INPUT TYPE="text" NAME="endId" VALUE="<%= lngEndId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;"></SPAN></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD WIDTH="90" NOWRAP></TD>
			<TD></TD>
			<TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "2", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(1)"  BORDER="0">複数指定<INPUT TYPE="text" NAME="pluralId" VALUE="<%= strPluralId %>" SIZE="35" BORDER="0" STYLE="ime-mode:disabled;"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>計算対象</TD>
			<TD>：</TD>
			<TD><INPUT type="checkbox" name="checkEiyo" value="<%= strEiyokeisan %>" <%= IIf(strEiyokeisan <> "", " CHECKED", "") %> ONCLICK="javascript:checkEiyoAct()" border="0">栄養計算</TD>
			<TD><INPUT type="checkbox" name="checkActPattern" value="<%= strActPattern %>" <%= IIf(strActPattern <> "", " CHECKED", "") %> ONCLICK="javascript:checkActPatternAct()" border="0">Ａ型行動パターン</TD>
			<TD><INPUT type="checkbox" name="checkPointLost" value="<%= strPointLost %>" <%= IIf(strPointLost <> "", " CHECKED", "") %> ONCLICK="javascript:checkLostPointAct()" border="0">失点判定</td>
			<TD><INPUT type="checkbox" name="checkStress" value="<%= strStress %>" <%= IIf(strStress <> "", " CHECKED", "") %> ONCLICK="javascript:checkStressAct()" border="0">ストレス点数</td>
		</TR>
	</TABLE>

	<BR><BR>

	<TD><A HREF="javascript:callCalc()"><IMG SRC="../../images/ok.gif" WIDTH="77" HEIGHT="24" ALT="計算を開始します"></A></TD>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>