<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   病歴情報  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_DISEASEHISTORY = "X026"	'病歴グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objConsult			'受診クラス
Dim objPerResult			'個人検査結果情報アクセス用
'2004/08/19 ADD STR ORB)T.YAGUCHI 入退院歴の変更
Dim objFolRenkei		'HainsFolRenkeiクラス
'2004/08/19 ADD END

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'検査結果
'Dim lngGetSeqMode		'取得順 0:グループ内表示順＋日付 1:日付＋コード＋サフィックス
'Dim vntPerId			'予約番号
'Dim vntCslDate			'検査項目コード
'Dim vntHisNo			'履歴No.
'Dim vntRsvNo			'予約番号
Dim strPerId			'個人ＩＤ
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim vntStcItemCd		'文章参照用項目コード
Dim vntStcCd			'文章コード
Dim vntShortStc			'文章略称
Dim vntIspDate			'検査日
Dim lngRslCnt			'検査結果数

'外来・入院歴
Dim vntKbn				'入外区分
Dim vntPatientDate		'来院日
Dim vntDeptName			'科名
Dim lngPatientCnt		'件数

'病歴
Dim vntInDate			'入院日
Dim vntDisName			'病名
Dim lngDisCnt			'件数

Dim i, j				'インデックス
Dim strBgColor			'背景色
Dim vntArrDisease		'既往歴

Dim Ret					'関数復帰値
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
'2004/08/19 ADD STR ORB)T.YAGUCHI 入退院歴の変更
Set objFolRenkei = Server.CreateObject("HainsFolRenkei.FolRenkei")
'2004/08/19 ADD END

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

Do
'	lngGetSeqMode = 0
	'指定対象受診者の検査結果を取得する
'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						1, _
'						GRPCD_DISEASEHISTORY, _
'						0, _
'						"", _
'						lngGetSeqMode, _
'						0, _
'						0, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						vntResult _
'						)
	'受診情報検索
'    Ret = objConsult.SelectConsult(lngRsvNo, _
'                                    , _
'                                    , _
'                                    strPerId    )

    If strCsCd <> "" Then
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        , _
                                        strPerId    )
    Else
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        , _
                                        strPerId, _
                                        strCsCd     )
    End If

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'## 個人検査結果から取得する　2003.12.24
'### 2004/06/28 Updated by Ishihara@FSIT 個人検査結果からではない。
'	lngRslCnt = objPerResult.SelectPerResultGrpList( strPerId, _
'														GRPCD_DISEASEHISTORY, _
'														1, 0, _
'														vntItemCd, _
'														vntSuffix, _
'														vntItemName, _
'														vntResult, _
'														vntResultType, _
'														vntItemType, _
'														vntStcItemCd, _
'														vntShortStc, _
'														vntIspDate _
'														)

'''#### 2013.02.01 張 当日複数予約が存在した場合の不具合対応　MOD START #### **
'    lngRslCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_DISEASEHISTORY, _
'                        0, _
'                        "", _
'                        0, _
'                        , , _
'                        , , _
'                        , _
'                        , _
'                        vntItemCd, _
'                        vntSuffix, _
'                         , _
'                        vntResultType, _
'                        vntItemName, _
'                        vntShortStc _
'                        )

    lngRslCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_DISEASEHISTORY, _
                        1, _
                        strCsCd, _
                        0, _
                        , , _
                        , , _
                        , _
                        , _
                        vntItemCd, _
                        vntSuffix, _
                         , _
                        vntResultType, _
                        vntItemName, _
                        vntShortStc _
                        )

'''#### 2013.02.01 張 当日複数予約が存在した場合の不具合対応　MOD END   #### **


'### 2004/06/28 Updated End

	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（個人ＩＤ = " & strPerId & ")"
	End If

	vntArrDisease = Array()
	ReDim vntArrDisease(2, -1)
	j = 0
	For i = 0 To (lngRslCnt/3)-1
'### 2004/06/28 Updated by Ishihara@FSIT 個人検査結果からではない。
'		If vntResult(i*3+0) <> "" Or vntResult(i*3+1) <> "" Or  vntResult(i*3+2) <> "" Then
		If vntItemCd(i*3+0) <> "" Or vntItemCd(i*3+1) <> "" Or  vntItemCd(i*3+2) <> "" Then
'### 2004/06/28 Updated End
			ReDim Preserve vntArrDisease(2, j)
			vntArrDisease(0, j) = vntShortStc(i*3+0)	'病名
			vntArrDisease(1, j) = vntShortStc(i*3+1)	'罹患年齢
			vntArrDisease(2, j) = vntShortStc(i*3+2)	'治癒状態
			j = j + 1
		End If
	Next

'2004/08/19 MOD STR ORB)T.YAGUCHI 入退院歴の変更
'	'入院・外来歴取得
'	lngPatientCnt = objInterView.SelectPatientHistory( _
'												lngRsvNo, _
'												vntKbn,   _
'												vntPatientDate, _
'												vntDeptName )
'
'	'病歴取得
'	lngDisCnt = objInterView.SelectDiseaseHistory( _
'												lngRsvNo, _
'												vntInDate,   _
'												vntDisName )
'
	'入院・外来歴取得
	lngPatientCnt = objFolRenkei.SelectPatientHistory( _
												lngRsvNo, _
												vntKbn,   _
												vntPatientDate, _
												vntDeptName )
	'病歴取得
	lngDisCnt = objFolRenkei.SelectDiseaseHistory( _
												lngRsvNo, _
												vntInDate,   _
												vntDisName )
'2004/08/11 MOD END

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>病歴情報</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function openWindow() {
	alert("ＯＣＲ入力結果確認画面を呼び出す！");
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"    VALUE="<%= lngRslCnt %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">病歴情報</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>現病歴・既往歴</B></TD>
						<TD></TD>
<!--
						<TD NOWRAP><A HREF="javascript:openWindow()">入力する</A></TD>
-->
						<TD NOWRAP><A HREF="/webHains/contents/monshin/ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>&anchor=1" TARGET="_blank">入力する</A></TD>
					</TR>
					<TR BGCOLOR="#cccccc">
						<TD WIDTH="100" NOWRAP>病名</TD>
						<TD ALIGN="center" NOWRAP>年齢</TD>
						<TD WIDTH="200" NOWRAP>治療状態</TD>
					</TR>
<%
For i=0 To UBound(vntArrDisease, 2)
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
						<TD NOWRAP><%= IIf(vntArrDisease(0, i)="", "&nbsp;", vntArrDisease(0, i)) %></TD>
						<TD NOWRAP ALIGN="center"><%= IIf(vntArrDisease(1, i)="", "&nbsp;", vntArrDisease(1, i)) %></TD>
						<TD NOWRAP><%= IIf(vntArrDisease(2, i)="", "&nbsp;", vntArrDisease(2, i)) %></TD>
					</TR>
<%
Next
%>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>二次検査項目</B></TD>
<TD><FONT COLOR="#dddddd" SIZE="-1"><B>※未実装</B></FONT></TD>
					</TR>
					<TR BGCOLOR="#cccccc">
						<TD WIDTH="100" NOWRAP>受診日</TD>
						<TD WIDTH="200" NOWRAP>検査項目</TD>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>外来・入院歴</B></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR BGCOLOR="#cccccc">
<!-- 必要か否か検討中？ 2003.12.22
						<TD NOWRAP>入外区分</TD>
-->
						<TD WIDTH="100" NOWRAP>来院日</TD>
						<TD WIDTH="120" NOWRAP>科</TD>
					</TR>
<%
For i=0 To lngPatientCnt - 1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
<!-- 必要か否か検討中？ 2003.12.22
						<TD NOWRAP><%= IIf(vntKbn(i)="1", "外来", "入院") %></TD>
-->
						<TD NOWRAP><%= vntPatientDate(i) %></TD>
						<TD NOWRAP><%= vntDeptName(i) %></TD>
					</TR>
<%
Next
%>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP><B>病名</B></TD>
		</TR>
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="100" NOWRAP>入院日</TD>
			<TD WIDTH="788" NOWRAP>病名</TD>
		</TR>
<%
For i=0 To lngDisCnt - 1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
						<TD NOWRAP><%= vntInDate(i) %></TD>
						<TD NOWRAP><%= vntDisName(i) %></TD>
					</TR>
<%
Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
