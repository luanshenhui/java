<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		今日のコメント (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objBbs 			'BBSアクセス用

Dim strMode 		'起動モード
Dim strDelBbsKey	'コメント削除キー

Dim strUserId		'ユーザID

'今日のコメント用
Dim vntTitle		'タイトル
Dim vntHandle		'投稿者名
Dim vntUpdDate		'更新日
Dim vntStrDate		'表示開始日付
Dim vntEndDate		'表示終了日付
Dim vntMessage		'コメント
Dim vntBbsKey		'キー
Dim vntUpdUser		'更新ユーザー
Dim lngMesCount		'レコード数
Dim strWeekDay		'曜日用文字列

Dim strHtml			'HTML文字列
Dim i				'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objBbs = Server.CreateObject("HainsBbs.Bbs")

'引数値の取得
strMode      = Request("mode")
strDelBbsKey = Request("bbskey")

strUserId    = Session.Contents("userid")

'削除モードで起動されたとき、削除を行う
If strMode = "delete" Then
	objBbs.DeleteBbs strDelBbsKey
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>今日の予定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function deletecheck( jumpUrl, para1, delUserId, userId ) {

	if ( delUserId != userId ) {
		alert( '投稿者とユーザーIDが違います。' );
	} else {
		res = confirm( '指定メッセージを削除します。よろしいですか？' );
		if ( res == true ) {
			location.replace(jumpUrl + '?' + para1); 
		}
	}

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="8"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="3" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
		<TD NOWRAP VALIGN="bottom"><FONT SIZE="3">今 日 の コ メ ン ト</FONT></TD>
		<TD NOWRAP VALIGN="bottom" ALIGN="right"><FONT FACE="Arial Narrow" SIZE="6" COLOR="silver">Today's Comment</FONT></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#cccccc" COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
	</TR>
	<TR>
		
    <%  if Session("PAGEGRANT") = "4" then   %>    
        <TD HEIGHT="30" COLSPAN="2" ALIGN="right"><A HREF="/webHains/contents/common/entryComment.asp" TARGET="_parent"><IMG SRC="/webHains/images/addcoment.gif" WIDTH="120" HEIGHT="24" BORDER="0"></A></TD>
    <%  end if  %>

	</TR>
</TABLE>


<%
	'今日のコメント取得
	lngMesCount = objBbs.SelectAllBbs(Date, vntBbsKey, vntStrDate, vntEndDate, vntHandle, vntTitle, vntMessage, vntUpdDate, vntUpdUser)
%>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
	'今日のコメント表示
	For i = 0 To lngMesCount - 1 

		Select Case WeekDay(vntUpdDate(i))
			Case vbSunday
				strWeekDay =  "(Sun)"
			Case vbMonday
				strWeekDay =  "(Mon)"
			Case vbTuesday
				strWeekDay =  "(Tue)"
			Case vbWednesDay
				strWeekDay =  "(Wen)"
			Case vbThursDay
				strWeekDay =  "(Thr)"
			Case vbFriDay
				strWeekDay =  "(Fri)"
			Case vbSaturDay
				strWeekDay =  "(Sat)"
		End Select

%>
	<TR>
		<TD WIDTH="20" NOWRAP></TD>
		<TD WIDTH="17" NOWRAP><FONT COLOR="#cccccc">■</FONT></TD>
		<TD NOWRAP><FONT COLOR="#777777"><B><%= vntTitle(i) %></B></FONT></TD>
		<TD ALIGN="RIGHT"><FONT COLOR="#999999"><%= vntHandle(i) %></FONT>&nbsp;<FONT SIZE="-1" COLOR="#999999"><%= DateValue(vntUpdDate(i)) %>&nbsp;<%= strWeekDay %>&nbsp;<%= TimeValue(vntUpdDate(i)) %></FONT></TD>
		<TD WIDTH="5"></TD>
		<TD NOWRAP>
			<A HREF="javascript:function voi(){};voi()" onClick="return deletecheck('/webHains/contents/common/todaysComment.asp', 'mode=delete&bbskey=<%= vntBbsKey(i) %>','<%= vntUpdUser(i) %>','<%= strUserId %>')"><IMAGE SRC="/webHains/Images/delicon.gif" ALT="このコメントを削除します"></A>
		</TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>
	<TR>
		<TD COLSPAN="2"></TD>
		<TD COLSPAN="5"><%= Replace(vntMessage(i),Chr(13) & Chr(10),"</BR>") %></TD>
	</TR>
	<TR HEIGHT="5">
		<TD WIDTH="20"></TD>
		<TD WIDTH="17"></TD>
	</TR>		
<%
	Next
%>
</TABLE>
</BODY>
</HTML>


