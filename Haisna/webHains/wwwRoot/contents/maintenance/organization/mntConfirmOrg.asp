<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体情報メンテナンス(団体情報の削除) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objOrganization	'団体情報アクセス用

Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2
Dim strOrgKName		'団体カナ名
Dim strOrgName		'団体名
Dim strOrgSName		'団体略称
Dim strZipCd1		'郵便番号1
Dim strZipCd2		'郵便番号2
Dim strPrefCd		'都道府県コード
Dim strPrefName		'都道府県名
Dim strCityName		'市区町村名
Dim strAddress1		'住所1
Dim strAddress2		'住所2
Dim strTel1			'電話番号代表－市外局番
Dim strTel2			'電話番号代表－局番
Dim strTel3			'電話番号代表－番号
Dim strDirectTel1	'電話番号直通－市外局番
Dim strDirectTel2	'電話番号直通－局番
Dim strDirectTel3	'電話番号直通－番号
Dim strExtension	'内線
Dim strFax1			'ＦＡＸ－市外局番
Dim strFax2			'ＦＡＸ－局番
Dim strFax3			'ＦＡＸ－番号
Dim strChargeName	'担当者氏名
Dim strChargeKName	'担当者カナ氏名
Dim strChargeEMail	'担当者E-Mailアドレス
Dim strChargePost	'担当者部署名
Dim strGovMngCd		'政府管掌コード
Dim strIsrNo		'保険者番号
Dim strIsrSign		'健保記号(記号)
Dim strIsrMark		'健保記号(符号)
Dim strHeIsrNo		'健保番号
Dim strIsrDiv		'保険区分
Dim strBank			'銀行名
Dim strBranch		'支店名
Dim strAccountKind	'口座種別
Dim strAccountNo	'口座番号
Dim strNotes		'特記事項
Dim strSpare1		'予備1
Dim strSpare2		'予備2
Dim strSpare3		'予備3
Dim strUpdDate		'更新日時
Dim strUpdUser		'更新者
Dim strUserName		'更新者名

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")

'団体テーブルレコード読み込み
objOrganization.SelectOrg strOrgCd1, strOrgCd2, _
						  strOrgKName, strOrgName, strOrgSName, _
						  strZipCd1, strZipCd2, _
						  strPrefCd, strPrefName, strCityName, _
						  strAddress1, strAddress2, _
						  strTel1, strTel2, strTel3, _
						  strDirectTel1, strDirectTel2, strDirectTel3, strExtension, _
						  strFax1, strFax2, strFax3, _
						  strChargeName, strChargeKName, strChargeEmail, strChargePost, _
						  strGovMngCd, _
						  strIsrNo, strIsrSign, strIsrMark, strHeIsrNo, strIsrDiv, _
						  strBank, strBranch, strAccountKind, strAccountNo, _
						  strNotes, _
						  strSpare1, strSpare2, strSpare3, _
						  strUpdDate, strUpdUser, strUserName
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>団体情報の削除</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">団体情報の削除</FONT></B></TD>
	</TR>
</TABLE>

<BR>

次の団体情報を削除します。よろしければ削除ボタンをクリックして下さい。<BR><BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">団体コード</TD>
		<TD WIDTH="5"></TD>
		<TD><%= strOrgCd1 & "-" & strOrgCd2 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">団体カナ名称</TD>
		<TD></TD>
		<TD><%= strOrgKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">団体名称</TD>
		<TD></TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">団体略称</TD>
		<TD></TD>
		<TD><%= strOrgSName %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">郵便番号</TD>
		<TD></TD>
		<TD><%= strZipCd1 & IIf(strZipCd2 <> "", "-", "") & strZipCd2 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">都道府県</TD>
		<TD></TD>
		<TD><%= strPrefName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">市区町村</TD>
		<TD></TD>
		<TD><%= strCityName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">住所１</TD>
		<TD></TD>
		<TD><%= strAddress1 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">住所２</TD>
		<TD></TD>
		<TD><%= strAddress2 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号代表</TD>
		<TD></TD>
		<TD><%= strTel1 & IIf(strTel2 <> "", "-", "") & strTel2 & IIf(strTel3 <> "", "-", "") & strTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号直通</TD>
		<TD></TD>
		<TD><%= strDirectTel1 & IIf(strDirectTel2 <> "", "-", "") & strDirectTel2 & IIf(strDirectTel3 <> "", "-", "") & strDirectTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">内線</TD>
		<TD></TD>
		<TD><%= strExtension %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
		<TD></TD>
		<TD><%= strFax1 & IIf(strFax2 <> "", "-", "") & strFax2 & IIf(strFax3 <> "", "-", "") & strFax3 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">担当者カナ名</TD>
		<TD></TD>
		<TD><%= strChargeKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">担当者名</TD>
		<TD></TD>
		<TD><%= strChargeName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">担当者E-Mailアドレス</TD>
		<TD></TD>
		<TD><%= strChargeEMail %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">担当部署名</TD>
		<TD></TD>
		<TD><%= strChargePost %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">更新日時</TD>
		<TD></TD>
		<TD><%= strUpdDate %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">更新者</TD>
		<TD></TD>
		<TD><%= strUserName %></TD>
	</TR>
</TABLE>

<BR>

<A HREF="mntDeleteOrg.asp?orgCd1=<%= strOrgcd1 %>&orgCd2=<%= strOrgcd2 %>&orgName=<%= Server.URLEncode(strOrgName) %>"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この団体情報を削除します"></A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
