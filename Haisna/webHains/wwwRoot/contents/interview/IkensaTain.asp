<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   胃検査、他院での指摘 (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const MONSTOMACH_GRPCD = "X032"		'問診（胃検査）グループコード
Const MONTAIN_GRPCD    = "X033"		'問診（他院での指摘）グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterview		'面接情報アクセス用
Dim objConsult			'受診情報アクセス用

Dim	strWinMode			'ウィンドウモード

Dim lngRsvNo			'予約番号

Dim strPerId			'個人ＩＤ

Dim	vntStomSeq			'胃検査　履歴番号
Dim	vntStomRsvNo		'胃検査　予約番号
Dim	vntStomSuffix		'胃検査　サフィックス
Dim	vntStomItemType		'胃検査　項目コード
Dim	vntStomItemName		'胃検査　項目名
Dim vntStomItemCd		'胃検査　検査項目コード
Dim vntStomResult		'胃検査　回答内容

Dim	lngStomCnt			'胃検査　件数

Dim	vntTainSeq			'他院での指摘　履歴番号
Dim	vntTainRsvNo		'他院での指摘　予約番号
Dim	vntTainSuffix		'他院での指摘　サフィックス
Dim	vntTainItemType		'他院での指摘　項目コード
Dim	vntTainItemName		'他院での指摘　項目名
Dim vntTainItemCd		'他院での指摘　検査項目コード
Dim vntTainResult		'他院での指摘　回答内容

Dim	lngTainCnt			'他院での指摘　件数

Dim i					'ループカウンタ
Dim blnRet				'関数復帰値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")

'引数値の取得

lngRsvNo         = Request("rsvno")
strWinMode		 = Request("winmode")


Do

	'予約番号から個人ＩＤ取得
	blnRet = objConsult.SelectConsult ( _
									lngRsvNo, _
									 ,  , strPerId _
										)

	If blnRet = False Then
		Err.Raise 1000, , "個人ＩＤが取得できませんでした。RsvNo= " & lngRsvNo
	End If




	'問診結果（胃検査）検索
'	lngStomCnt = objInterview.SelectPerResult( _
'					    strPerId, _
'   					vntStomItemCd, _
'    					vntStomSuffix, _
'    					vntStomItemType, _
'    					vntStomItemName, , _
'    					vntStomResult, , _
'						MONSTOMACH_GRPCD _
'						)
	lngStomCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONSTOMACH_GRPCD, _
    					0, _
    					"", _
    					0, _
    					, , _
						, , _
    					, _
    					, _
    					vntStomItemCd, _
    					vntStomSuffix, _
    					 , _
    					vntStomItemType, _
    					vntStomItemName, _
    					vntStomResult _
						)

	'問診結果（他院での指摘）検索
'	lngTainCnt = objInterview.SelectPerResult( _
'					    strPerId, _
'    					vntTainItemCd, _
'    					vntTainSuffix, _
'    					vntTainItemType, _
'    					vntTainItemName, , _
'    					vntTainResult, , _
'						MONTAIN_GRPCD _
'						)
'### 2004/06/28 Updated by Ishihara@FSIT 他院での指摘は、個人検査情報ではなく今回情報で抽出
'	lngTainCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONTAIN_GRPCD, _
'    					0, _
'    					"", _
'    					0, _
'    					, , _
'						, , _
'    					, _
'    					, _
'    					vntTainItemCd, _
'    					vntTainSuffix, _
'    					 , _
'    					vntTainItemType, _
'    					vntTainItemName, _
'    					vntTainResult _
'						)
	lngTainCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONTAIN_GRPCD, _
    					0, _
    					"", _
    					0, _
    					, , _
						, , _
    					, _
    					, _
    					vntTainItemCd, _
    					vntTainSuffix, _
    					 , _
    					vntTainItemType, _
    					vntTainItemName, _
    					vntTainResult _
						)
'### 2004/06/28 Updated End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>胃検査、他院での指摘</TITLE>
<SCRIPT TYPE="text/javascript">
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="./" METHOD="get">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="686">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">胃検査、他院での指摘</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
<%
	If lngStomCnt <= 0 And lngTainCnt <= 0 Then
%>
		<FONT SIZE="+1">表示する項目はありません。</FONT>
<%
	Else
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="628" class="mensetsu-tb">
			<TR ALIGN="center" BGCOLOR="#cccccc">
				<th NOWRAP WIDTH="197">質問内容</th>
				<th NOWRAP WIDTH="599">回答内容</th>
			</TR>
<%
			For i = 0 To lngStomCnt - 1
%>
				<TR BGCOLOR="#ffffff">
					<TD NOWRAP WIDTH="197"><%= vntStomItemName(i) %></TD>
					<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="599"><%= vntStomResult(i) %></TD>
				</TR>
<%
			Next
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP colspan="2" style="border-left:1px solid #fff;border-right:1px solid #fff; height:6px;"></TD>
			</TR>
<%
			For i = 0 To lngTainCnt - 1
%>
				<TR BGCOLOR="#ffffff">
					<TD NOWRAP WIDTH="197"><%= vntTainItemName(i) %></TD>
					<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="599">他院指摘あり</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
	End If
%>
</FORM>
</BODY>
</HTML>