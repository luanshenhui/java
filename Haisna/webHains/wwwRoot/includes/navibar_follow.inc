<% 
'-----------------------------------------------------------------------------
'		ナビゲーションバー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<!-- Logo -->
<FORM STYLE="margin: 0px;" NAME="NaviBar" ACTION="/webHains/contents/common/dailyList.asp" TARGET="_top" method="get" ONSUBMIT="javascript:return ( document.NaviBar.key.value != '');">
<INPUT TYPE="hidden" NAME="navi" VALUE="1">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%" VALIGN="top" BGCOLOR="#eeeeee">
<TR><TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="2"></TD></TR>
<TR>
<TD NOWRAP><SPAN STYLE="font-size:12px">&nbsp;<A HREF="/webHains/frontdoor.asp" TARGET="_top">ホーム</A>&nbsp;</SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP><SPAN STYLE="font-size:12px">&nbsp;<A HREF="javaScript:screenSave();">画面保護</A>&nbsp;</SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP><SPAN style="font-size:12px;font-weight:bolder;color:#666666">&nbsp;Login：</SPAN></TD>
<TD WIDTH="100%" NOWRAP><SPAN style="font-size:11px;color:#666666"><%= Server.HTMLEncode(Session("USERNAME")) %></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS="rsvtab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/reserve/rsvMenu.asp" CLASS="nabia" TARGET="_top">予約</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS=""><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/raiin/ReceiptMenu.asp" CLASS="nabia" TARGET="_top">当日</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS="rsltab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/result/rslMenu.asp" CLASS="nabia" TARGET="_top">結果</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS="judtab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/judgement/judMenu.asp" CLASS="nabia" TARGET="_top">判定</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="60" CLASS="inqtab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/inquiry/inqwiz.asp" CLASS="nabia" TARGET="_top">結果参照</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS="prttab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/print/prtMenu.asp" CLASS="nabia" TARGET="_top">印刷</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="35" CLASS="dmdtab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/demand/dmdMenu.asp" CLASS="nabia" TARGET="_top">請求</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="45" CLASS="datatab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/download/datMenu.asp" CLASS="nabia" TARGET="_top">データ</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="76" CLASS="mnttab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/maintenance/mntMenu.asp" CLASS="nabia" TARGET="_top">メンテナンス</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD NOWRAP ALIGN="center" WIDTH="80" CLASS="mnttab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/contents/follow/folMenu.asp" CLASS="nabia" TARGET="_top">フォローアップ</A></SPAN></TD>
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<!--## 2006.04.15 張 ログアウト後直前の画面に戻ることが出来ないように変更 Start ##-->
<!--TD NOWRAP ALIGN="center" WIDTH="60" CLASS="logouttab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/login.asp" CLASS="nabia" TARGET="_top">ログアウト</A></SPAN></TD-->
<TD NOWRAP ALIGN="center" WIDTH="60" CLASS="logouttab"><SPAN STYLE="font-size:12px"><A HREF="/webHains/logout.asp" CLASS="nabia" TARGET="_top">ログアウト</A></SPAN></TD>
<!--## 2006.04.15 張 ログアウト後直前の画面に戻ることが出来ないように変更 Start ##-->
<TD NOWRAP WIDTH="2"><IMG HEIGHT="20" WIDTH="2" SRC="/webHains/images/sep.gif"></TD>
<TD><SPAN STYLE="font-size:12px">&nbsp;</SPAN></TD>
<TD WIDTH="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="3"></TD>
<TD><SPAN style="font-size:12px"><FONT color="#999999" face="Arial"><B>Search:&nbsp;</B></FONT></SPAN></TD>
<TD><INPUT TYPE="text" NAME="key" SIZE="25" ACCESSKEY="S"></TD>
<TD WIDTH="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="3"></TD>
<TD><INPUT TYPE="IMAGE" Name="" SRC="/webHains/images/go.gif" ALT="指定した文字列で検索します"></TD>
<TD WIDTH="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="3"></TD>
<TD><A HREF="/webHains/frontdoor.asp?cslYear=<%= Year(Now()) %>&cslMonth=<%= Month(Now()) %>&cslDay=<%= Day(Now()) %>" TARGET="_top"><IMG WIDTH="21" HEIGHT="21" SRC="/webHains/images/today.gif" ALT="今日の受診者一覧"></A></TD>
<TD WIDTH="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="3"></TD>
</TR>
<TR><TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="2"></TD></TR>
</TABLE>
</FORM>
