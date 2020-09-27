<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   認識レベルの登録（ボディ） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Const DISPMODE_LIFEADVICE = 2	'表示分類：生活指導

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterview		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード
Dim strAct				'処理状態

'総合コメント
Dim lngDispMode			'表示分類
Dim vntCmtSeq			'表示順
Dim vntTtlJudCmtCd		'判定コメントコード
Dim vntTtlJudCmtstc		'判定コメント文章
Dim vntTtlJudClassCd	'判定分類コード
Dim lngTtlCmtCnt		'行数

'生活指導コメント情報
Dim vntEditTtlJudCmtCd	'判定コメントコード
Dim vntEditCmtDelFlag	'削除フラグ
'## 変更履歴用　追加 2004.01.07
Dim vntEditTtlJudCmtStc	'判定コメント

'実際に更新する生活指導コメント
Dim vntUpdCmtSeq		'表示順
Dim vntUpdTtlJudCmtCd	'判定コメントコード
Dim lngUpdCount			'更新項目数
'## 変更履歴用　追加 2004.01.07
Dim vntUpdTtlJudCmtStc	'判定コメント

Dim i,j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterview	= Server.CreateObject("HainsInterview.Interview")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strAct				= Request("act")

'生活指導コメント情報
vntEditTtlJudCmtCd	= ConvIStringToArray(Request("TtlJudCmtCd"))
vntEditCmtDelFlag	= ConvIStringToArray(Request("CmtDelFlag"))
'## 変更履歴用　追加 2004.01.07
vntEditTtlJudCmtStc	= ConvIStringToArray(Request("TtlJudCmtStc"))

Do
	'保存
	If strAct = "save" Then

		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		vntUpdTtlJudCmtCd = Array()
		ReDim vntUpdCmtSeq(-1)
		ReDim vntUpdTtlJudCmtCd(-1)
		'## 変更履歴用　追加 2004.01.07
		vntUpdTtlJudCmtStc = Array()
		ReDim vntUpdTtlJudCmtSTc(-1)

		'実際に更新を行う項目のみを抽出
		For i = 0 To UBound(vntEditTtlJudCmtCd)
			If vntEditCmtDelFlag(i) <> "1" Then
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				ReDim Preserve vntUpdTtlJudCmtCd(lngUpdCount)
				'## 変更履歴用　追加 2004.01.07
				ReDim Preserve vntUpdTtlJudCmtStc(lngUpdCount)

				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				vntUpdTtlJudCmtCd(lngUpdCount) = vntEditTtlJudCmtCd(i)
				'## 変更履歴用　追加 2004.01.07
				vntUpdTtlJudCmtStc(lngUpdCount) = vntEditTtlJudCmtStc(i)
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		'総合コメントの保存
		'## 2004.01.07 更新履歴用に文章とユーザＩＤ追加
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_LIFEADVICE, _
								vntUpdCmtSeq, _
								vntUpdTtlJudCmtCd, _
								vntUpdTtlJudCmtSTc, _
								Session.Contents("userId")
	End If

	'総合コメント取得
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_LIFEADVICE, _
'										1, 0,  , 0, _
'										vntCmtSeq, _
'										vntTtlJudCmtCd, _
'										vntTtlJudCmtstc, _
'										vntTtlJudClassCd _
'										)
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_LIFEADVICE, _
										1, 1, strCsCd , 0, _
										vntCmtSeq, _
										vntTtlJudCmtCd, _
										vntTtlJudCmtstc, _
										vntTtlJudClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **

	Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>認識レベルの登録</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="CmtCnt"  VALUE="<%= lngTtlCmtCnt %>">

	<!-- 生活指導コメントの表示 -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">生活指導コメント</FONT></B></TD>
		</TR>
	</TABLE>
	<SPAN ID="LifeAdviceList">
	<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0" WIDTH="908">
<%
	For i=0 To lngTtlCmtCnt - 1
%>
		<TR>
			<TD WIDTH="100%"><%= vntTtlJudCmtstc(i) %></TD>
			<TD NOWRAP VALIGN="top"><INPUT TYPE="checkbox" NAME="chkCmtDel">削除</TD>
			<INPUT TYPE="hidden" NAME="TtlJudCmtCd"   VALUE="<%= vntTtlJudCmtCd(i) %>">
			<INPUT TYPE="hidden" NAME="TtlJudCmtstc"  VALUE="<%= vntTtlJudCmtstc(i) %>">
			<INPUT TYPE="hidden" NAME="TtlJudClassCd" VALUE="<%= vntTtlJudClassCd(i) %>">
			<INPUT TYPE="hidden" NAME="CmtDelFlag" VALUE="">
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999"></TD>
			<TD NOWRAP VALIGN="top" HEIGHT="1" BGCOLOR="#999999"></TD>
		</TR>
<%
	Next
%>
	</TABLE>
	</SPAN>
</FORM>
</BODY>
</HTML>
