<%
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化（生活習慣） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_CULIFEHABIT = "X017"	'ＣＵ経年変化（生活習慣）グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'受診歴一覧用変数
Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntHisPerId			'個人ＩＤ
Dim vntHisRsvNo			'予約番号
Dim vntHisCslDate		'受診日
Dim vntCsCd				'コースコード
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim lngHisCount			'表示歴数

'検査結果用変数
Dim vntPerId			'予約番号
Dim vntCslDate			'検査項目コード
Dim vntHisNo			'履歴No.
Dim vntRsvNo			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim lngRslCnt			'検査結果数

Dim lngItemCnt			'表示する検査項目数
Dim strArrItemInfo()	'表示する検査項目情報
Dim strArrResult()		'表示する検査項目結果
Dim strItem				'処理対象の検査項目
Dim strItemName			'項目名称
Dim strArrImageName		'イメージファイル群
Dim strImage			'表示するイメージ
Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
	'すべてのコース
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'同一コース
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	

	'指定された個人ＩＤの受診歴一覧を取得する
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						10, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName, _
						1 _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'指定対象受診者の検査結果を取得する
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						lngHisCount, _
						GRPCD_CULIFEHABIT, _
						lngLastDspMode, _
						vntCsGrp, _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						, , , , , , , , , , _
						, , , , , , , , _
						1 _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 3, -1 )
	Redim strArrResult( lngHisCount-1, -1 )
	'選択されている検査項目を抽出
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
				lngItemCnt = lngItemCnt + 1
				Redim Preserve strArrItemInfo( 3, lngItemCnt ) 
				Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)
		'過去の結果が左にくるようにする
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next
Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＣＵ経年変化</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winBigIcon;						// アイコン拡大ウィンドウハンドル

// アイコン拡大
function callBigIcon( itemno, iconno ) {
	var url;							// URL文字列
	var opened = false;					// 画面がすでに開かれているか

	url = '/WebHains/contents/interview/CULifeHabitIcon.asp';
	url = url + '?itemno=' + itemno;
	url = url + '&iconno=' + iconno;

	// すでにウィンドウが開かれているかチェック
	if ( winBigIcon != null ) {
		if ( !winBigIcon.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winBigIcon.focus();
		winBigIcon.location.replace( url );
	} else {
		winBigIcon = window.open( url, '', 'width=300,height=300,status=no,directories=no,menubar=no,resizable=no,scrollbars=no,toolbar=no,location=no');
	}

}

// サブ画面を閉じる
function closeWindow() {

	// 所見選択画面を閉じる
	if ( winBigIcon != null ) {
		if ( !winBigIcon.closed ) {
			winBigIcon.close();
		}
	}

	winBigIcon  = null;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- 生活習慣の表示 -->
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD WIDTH="130" NOWRAP>&nbsp;</TD>
<%
	For i=0 To lngHisCount-1
%>
			<TD WIDTH="60" NOWRAP><%= vntHisCslDate(i) %></TD>
<%
	Next
%>
		</TR>
<%
	For i=1 To lngItemCnt
		Select Case i
		Case "1"
			strItemName = "飲酒"
			strArrImageName = Array( _
									"../../images/drinker0.jpg", _
									"../../images/drinker1.jpg", _
									"../../images/drinker2.jpg", _
									"../../images/drinker3.jpg" _
									)
		Case "2"
			strItemName = "喫煙"
			strArrImageName = Array( _
									"../../images/smoker0.jpg", _
									"../../images/smoker1.jpg", _
									"../../images/smoker2.jpg", _
									"../../images/smoker3.jpg" _
									)
		Case "3"
			strItemName = "運動"
			strArrImageName = Array( _
									"../../images/sports0.jpg", _
									"../../images/sports1.jpg", _
									"../../images/sports2.jpg", _
									"../../images/sports3.jpg" _
									)
		Case "4"
'### 2004/3/4 Updated by Ishihara@FSIT 名称が誤っている
'			strItemName = "生活"
			strItemName = "Ａ型行動"
			strArrImageName = Array( _
									"../../images/life0.jpg",_
									"../../images/life1.jpg", _
									"../../images/life2.jpg", _
									"../../images/life3.jpg" _
									)
		End Select
%>	
		<TR ALIGN="right">
			<TD NOWRAP HEIGHT="40" ALIGN="left"><FONT SIZE="6"><%= strItemName %></FONT></TD>
<%
		For j=0 To lngHisCount-1
			strImage = ""

			Select Case strArrResult(j, i)
			Case "0","1","2","3"
				strImage = strArrImageName(strArrResult(j, i))
			End Select
			If strImage <> "" Then
%>
				<TD NOWRAP ALIGN="center"><A HREF="javascript:callBigIcon(<%= i %>, <%= strArrResult(j, i) %>)"><IMG SRC="<%= strImage %>" ALT="<%= strArrResult(j, i) %>" HEIGHT="40" WIDTH="40"></A></TD>
<%
			Else
%>
				<TD NOWRAP>&nbsp;</TD>
<%
			End If
		Next
%>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
