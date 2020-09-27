<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       個人情報の削除 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objFree			'汎用情報アクセス用
Dim objHainsUser	'ユーザ情報アクセス用
Dim objPerson		'個人情報アクセス用

Dim strPerID		'個人ＩＤ
Dim strVidFlg		'仮ＩＤフラグ
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGender		'性別
Dim strSpare(6)		'予備
Dim strDelFlg		'削除フラグ
Dim strUpdDate		'更新日付
Dim strUpdUser		'更新者
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgPostCd	'所属部署コード
Dim strTel1			'電話番号１-市外局番
Dim strTel2			'電話番号１-局番
Dim strTel3			'電話番号１-番号
Dim strExtension	'内線
Dim strSubTel1		'電話番号２-市外局番
Dim strSubTel2		'電話番号２-局番
Dim strSubTel3		'電話番号２-番号
Dim strFax1			'ＦＡＸ番号-市外局番
Dim strFax2			'ＦＡＸ番号-局番
Dim strFax3			'ＦＡＸ番号-番号
Dim strPhone1		'携帯-市外局番
Dim strPhone2		'携帯-局番
Dim strPhone3		'携帯-番号
Dim strEMail		'e-Mail
Dim strZipCd1		'郵便番号１
Dim strZipCd2		'郵便番号２
Dim strPrefCd		'都道府県コード
Dim strCityName		'市区町村名
Dim strAddress1		'住所１
Dim strAddress2		'住所２
Dim strIsrNo		'保険者番号
Dim strMarriage		'婚姻区分
Dim strIsrSign		'健保記号（記号）
Dim strIsrMark		'健保記号（符号）
Dim strHeIsrNo		'健保番号
Dim strIsrDiv		'保険区分
Dim strResidentNo	'住民番号
Dim strUnionNo		'組合番号
Dim strKarte		'カルテ番号
Dim strEmpNo		'従業員番号
Dim strNotes		'特記事項
Dim strGenderName	'性別(名称)
Dim strPrefName		'都道府県名称

Dim strOrgName			'団体名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strOrgPostName		'所属名称
Dim strTransferDiv		'出向区分
Dim strJobName			'職名
Dim strDutyName			'職責名称
Dim strQualifyName		'資格名称
Dim strWorkMeasureDivName	'就業措置区分名称
Dim strEmpDiv				'従業員区分
Dim strOverTimeDiv		'超過勤務区分

Dim strRelationCd		'続柄コード
Dim strBranchNo			'枝番
Dim strLostDate			'資格喪失日付
Dim strHireDate			'入社日付
Dim strNightDutyFlg		'夜勤者健診対象フラグ

Dim strSpareName(6)	'予備の表示名称
Dim strFreeName		'汎用名
Dim strUserName		'ユーザ名

Dim strDelFlgName		'削除フラグ名称
Dim strEmpDivName				'従業員区分名称

Dim strHTML			'HTML文字列
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strPerID = Request("perid")

'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objFree      = Server.CreateObject("HainsFree.Free")
Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

'予備の表示名称取得
For i = 0 To UBound(strSpare)

	'汎用名読み込み
	objFree.SelectFree 0, "PERSPARE" & (i + 1), , strFreeName

	'名称が設定されている場合はその内容を保持
	strSpareName(i) = IIf(strFreeName <> "", strFreeName, "汎用キー(" & (i + 1) & ")")

Next

'個人テーブルレコード読み込み
'objPerson.SelectPerson_old strPerID, _
'						   strVidFlg,     strLastName,   strFirstName,      _
'						   strLastKName,  strFirstKName, strBirth,          _
'						   strGender,     strSupportFlg, strSpare(0),       _
'						   strSpare(1),   strUpdDate,    strUpdUser,        _
'						   strOrgCd1,     strOrgCd2,     strOrgPostCd,      _
'						   strTel1,       strTel2,       strTel3,           _
'						   strExtension,  strSubTel1,    strSubTel2,        _
'						   strSubTel3,    strFax1,       strFax2,           _
'						   strFax3,       strPhone1,     strPhone2,         _
'						   strPhone3,     strEMail,      strZipCd1,         _
'						   strZipCd2,     strPrefCd,     strCityName,       _
'						   strAddress1,   strAddress2,   strMarriage,       _
'						   strIsrNo,      strIsrSign,    strIsrMark,        _
'						   strHeIsrNo,    strIsrDiv,     strResidentNo,     _
'						   strUnionNo,    strKarte,      strEmpNo,          _
'						   strNotes,      strSpare(2),   strSpare(3),       _
'						   strSpare(4),   strSpare(5),   strSpare(6), , , , _
'						   strGenderName, strPrefName

	objPerson.SelectPerson strPerId, _
     strLastName,  strFirstName, _
     strLastKName,  strFirstKName, _
     strBirth,  strGender, _
     ,  , _
     , ,  strOrgName, _
     ,  ,  strOrgBsdName, _
     ,  strOrgRoomName,  , _
     ,  strOrgPostName,  , _
     , strJobName , _
     , strDutyName  , _
     , strQualifyName  , _
     strEmpNo,  strIsrSign,  strIsrNo, _
     strRelationCd,  , strBranchNo , _
     strTransferDiv , _
     , _
     strLostDate, strHireDate , _
     strEmpDiv ,  , _
     , strWorkMeasureDivName  , _
     strOverTimeDiv , strNightDutyFlg , _
     strVidflg, strDelFlg , ,_
     strUpdDate,  strUpdUser,  strUserName, _
     strSpare(0),  strSpare(1)


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人情報の削除</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人情報の削除</FONT></B></TD>
	</TR>
</TABLE>

<BR>

次の個人情報を削除します。よろしければ削除ボタンをクリックして下さい。<BR><BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right" WIDTH="138">個人ID</TD>
		<TD WIDTH="5"></TD>
		<TD><%= strPerID %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">フリガナ</TD>
		<TD></TD>
		<TD><%= strLastKName & "　" & strFirstKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">名前</TD>
		<TD></TD>
		<TD><%= strLastName & "　" & strFirstName %></TD>
   	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">性別</TD>
		<TD></TD>
		<TD><%= IIf(strGender = "1", "男性", "女性") %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">生年月日</TD>
		<TD></TD>
		<TD><%= objCommon.FormatString(strBirth, "ggge年m月d日") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">団体</TD>
		<TD></TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">事業部</TD>
		<TD></TD>
		<TD><%= strOrgBsdName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">室部</TD>
		<TD></TD>
		<TD><%= strOrgRoomName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">所属</TD>
		<TD></TD>
		<TD><%= strOrgPostName %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">従業員番号</TD>
		<TD></TD>
		<TD><%= strEmpNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">削除フラグ</TD>
		<TD></TD>
<%
		Select Case strDelFlg
			Case "0": strDelFlgName = "使用中"
			Case "1": strDelFlgName = "削除済（退職扱い）"
			Case "2": strDelFlgName = "休職中"
		End Select
%>
		<TD><%= strDelFlgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">出向区分</TD>
		<TD></TD>
		<TD><%= IIf(strTransferDiv = "0", "出向なし", "出向中") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">職名</TD>
		<TD></TD>
		<TD><%= strJobName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">職責</TD>
		<TD></TD>
		<TD><%= strDutyName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">資格</TD>
		<TD></TD>
		<TD><%= strQualifyName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">就業措置区分</TD>
		<TD></TD>
		<TD><%= strWorkMeasureDivName %></TD>
	</TR>
<%
	'従業員区分取得
	objFree.SelectFree 0, strEmpDiv, , , , strEmpDivName
%>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">従業員区分</TD>
		<TD></TD>
		<TD><%= strEmpDivName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">超過勤務区分</TD>
		<TD></TD>
		<TD><%= IIf(strOverTimeDiv = "0", "なし", "あり") %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">夜勤者健診</TD>
		<TD></TD>
		<TD><%= IIf(strNightDutyFlg <> "", "あり", "") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号１</TD>
		<TD></TD>
		<TD><%= strTel1 & IIf(strTel2 <> "", "-", "") & strTel2 & IIf(strTel3 <> "", "-", "") & strTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">内線</TD>
		<TD></TD>
		<TD><%= strExtension %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号２</TD>
		<TD></TD>
		<TD><%= strSubTel1 & IIf(strSubTel2 <> "", "-", "") & strSubTel2 & IIf(strSubTel3 <> "", "-", "") & strSubTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
		<TD></TD>
		<TD><%= strFax1 & IIf(strFax2 <> "", "-", "") & strFax2 & IIf(strFax3 <> "", "-", "") & strFax3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">携帯番号</TD>
		<TD></TD>
		<TD><%= strPhone1 & IIf(strPhone2 <> "", "-", "") & strPhone2 & IIf(strPhone3 <> "", "-", "") & strPhone3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">E-mailアドレス</TD>
		<TD></TD>
		<TD><%= strEMail %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">郵便番号</TD>
		<TD></TD>
		<TD><%= strZipCd1 & IIf(strZipCd2 <> "", "-" & strZipCd2, "") %></TD>
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
		<TD BGCOLOR="#eeeeee" ALIGN="right">番地</TD>
		<TD></TD>
		<TD><%= strAddress1 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">屋号</TD>
		<TD></TD>
		<TD><%= strAddress2 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">婚姻区分</TD>
		<TD></TD>
		<TD><%= objCommon.SelectMarriageName(strMarriage) %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">保険者番号</TD>
		<TD></TD>
		<TD><%= strIsrNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">健保記号</TD>
		<TD></TD>
<%
		strHTML = IIf(strIsrSign <> "", "(記号)", "") & strIsrSign
		If strHTML <> "" Then
			strHTML = strHTML & "　"
		End If
		strHTML = strHTML & IIf(strIsrMark <> "", "(符号)", "") & strIsrMark
%>
		<TD><%= strHTML %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">健保番号</TD>
		<TD></TD>
		<TD><%= strHeIsrNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">保険区分</TD>
		<TD></TD>
		<TD><%= objCommon.SelectIsrDivName(strIsrDiv) %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">住民番号</TD>
		<TD></TD>
		<TD><%= strResidentNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">組合番号</TD>
		<TD></TD>
		<TD><%= strUnionNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">カルテ番号</TD>
		<TD></TD>
		<TD><%= strKarte %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">従業員番号</TD>
		<TD></TD>
		<TD><%= strEmpNo %></TD>
	</TR>
<%
	For i = 0 To UBound(strSpare)
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right"><%= strSpareName(i) %></TD>
			<TD></TD>
			<TD><%= strSpare(i) %></TD>
		</TR>
<%
	Next
%>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">特記事項</TD>
		<TD></TD>
		<TD><%= strNotes %></TD>
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
<%
		'ユーザ名読み込み
		If strUpdUser <> "" Then
			objHainsUser.SelectHainsUser strUpdUser, strUserName
		End If
%>
		<TD><%= strUserName %></TD>
	</TR>

</TABLE>

<BR><BR>

<A HREF="mntDeletePerson.asp?perid=<%= strPerID %>&lastname=<%= Server.URLEncode(strLastName) %>&firstname=<%= Server.URLEncode(strFirstName) %>"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="削除"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>