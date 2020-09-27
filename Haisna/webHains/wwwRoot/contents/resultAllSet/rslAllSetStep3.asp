<%
'-----------------------------------------------------------------------------
'		結果一括入力(例外者の選択) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objConsult		'受診情報アクセス用COMオブジェクト

'受診者情報
Dim strRsvNo		'予約番号
Dim strDayId		'当日ID
Dim strLastName		'姓
Dim strFirstName	'名
Dim lngCslCount		'受診者数

Dim lngStrDayId		'開始当日ID
Dim lngEndDayId		'終了当日ID
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'当日IDの編集
lngStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
lngEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

'受診者読み込み
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'lngCslCount = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , strRsvNo, strDayId, , , , strLastName, strFirstName)
'来院済み受診者のみ対象
lngCslCount = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , strRsvNo, strDayId, , , , strLastName, strFirstName, , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

'例外者チェック用の配列作成
If lngCslCount > 0 Then
	ReDim strSelectFlg(lngCslCount - 1)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>例外者の選択</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 選択フラグ編集
function editSelectFlg( checkBox, index ) {

	var myForm = document.step3;

	// チェックボックスの状態をhidden属性のエレメント値として保持
	if ( myForm.selectFlg.length == null ) {
		myForm.selectFlg.value = checkBox.checked ? '1' : '0';
	} else {
		myForm.selectFlg[index].value = checkBox.checked ? '1' : '0';
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step3" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'自分自身のステップ番号を保持し、制御用のASPで使用する
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<!-- 前画面(Step1)からの引継ぎ情報 -->

	<INPUT TYPE="hidden" NAME="year"   VALUE="<%= mlngYear   %>">
	<INPUT TYPE="hidden" NAME="month"  VALUE="<%= mlngMonth  %>">
	<INPUT TYPE="hidden" NAME="day"    VALUE="<%= mlngDay    %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= mstrCsCd   %>">
	<INPUT TYPE="hidden" NAME="dayIdF" VALUE="<%= mstrDayIdF %>">
	<INPUT TYPE="hidden" NAME="dayIdT" VALUE="<%= mstrDayIdT %>">

	<!-- 前画面(Step2)からの引継ぎ情報 -->

	<INPUT TYPE="hidden" NAME="grpCd"          VALUE="<%= mstrGrpCd          %>">
	<INPUT TYPE="hidden" NAME="allResultClear" VALUE="<%= mstrAllResultClear %>">
<%
	 For mlngIndex1 = 0 To UBound(mstrItemCd)
%>
		<INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= mstrItemCd(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= mstrSuffix(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="result" VALUE="<%= mstrResult(mlngIndex1) %>">
<%
	Next
%>
	<BLOCKQUOTE>

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">Step3：例外者の選択</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">●</FONT>&nbsp;この一括結果入力処理で、検査結果をセットしたくない受診者を選択してください。<BR><BR>
<%
	If mstrAllResultClear <> "1" Then
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD><INPUT TYPE="checkbox" NAME="overWrite" VALUE="1"<%= IIf(mstrOverWrite = "1", " CHECKED", "") %>></TD>
				<TD>すでに入力されている結果を上書きする</TD>
			</TR>
		</TABLE>
<%
	End If
%>
	<BR>
<%
	'受診者一覧の編集
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
<%
		'表題の編集
%>
		<TR ALIGN="center" BGCOLOR="#cccccc">
<%
			mlngIndex1 = 0
			Do Until mlngIndex1 = 4 Or mlngIndex1 >= lngCslCount
%>
				<TD NOWRAP>当日ＩＤ</TD>
				<TD NOWRAP WIDTH="115">氏名</TD>
				<TD NOWRAP BGCOLOR="#ffffff"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1"></TD>
<%
				mlngIndex1 = mlngIndex1 + 1
			Loop
%>
		</TR>
<%
		mlngIndex2 = 0
		For mlngIndex1 = 0 To lngCslCount - 1

			If mlngIndex2 = 0 Then
%>
				<TR BGCOLOR="#eeeeee">
<%
			End If
%>
			<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strRsvNo(mlngIndex1)     %>">
			<INPUT TYPE="hidden" NAME="selectFlg" VALUE="<%= strSelectFlg(mlngIndex1) %>">
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" VALUE="<%= strSelectFlg(mlngIndex1) %>"<%= IIf(strSelectFlg(mlngIndex1) = "1", " CHECKED", "") %> ONCLICK="JavaScript:editSelectFlg(this, <%= mlngIndex1 %>)"></TD>
						<TD><%= Right("0000" & strDayId(mlngIndex1), 4) %></TD>
					</TR>
				</TABLE>
			</TD>
			<TD NOWRAP><%= strLastName(mlngIndex1) %>　<%= strFirstName(mlngIndex1) %></TD>
			<TD NOWRAP BGCOLOR="#ffffff"></TD>
<%
			If mlngIndex2 = 3 Or mlngIndex2 = lngCslCount - 1 Then
%>
				</TR>
<%
			End If

			mlngIndex2 = mlngIndex2 + 1
			If mlngIndex2 > 3 Then
				mlngIndex2 = 0
			End If

		Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <INPUT TYPE="image" NAME="step4" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存">
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
