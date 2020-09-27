<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   生活習慣（ヘッダ） (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
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
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strAct				'処理状態
Dim lngRsvNo			'予約番号（今回分）

'受診情報用変数
Dim strPerId			'個人ID
Dim lngAge				'年齢
Dim lngGender			'性別

Dim Ret					'復帰値

'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
Dim strCslDate			'受診日

Dim objFree             'OCR入力結果アクセス用
Const CHECK_CSLDATE2     = "2010/01/01"    '汎用マスタの設定がない場合用
Const FREECLASSCD_CHG  = "CHG"           '2011年対応　変更日付取得用

dim vntArrFree1
Dim strChgDate          '2011年対応　変更日付
'#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult 		= Server.CreateObject("HainsConsult.Consult")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")

'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
Set objFree         = Server.CreateObject("HainsFree.Free")

'汎用マスタより切り替え日取得
if objFree.SelectFreeByClassCd( 0,FREECLASSCD_CHG, , , , vntArrFree1 )  > 0 then
    strChgDate = vntArrFree1(0)
End if
If strChgDate = "" Then
    strChgDate = CHECK_CSLDATE2
End If
 '#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

Do	

	'受診情報検索（予約番号より個人情報取得）
'#### 2010.08.19 SL-UI-Y0101-104 MOD START ####　受診日取得追加'
'	Ret = objConsult.SelectConsult(lngRsvNo, _
'									, , _
'									strPerId, _
'									, , , , , , , _
'									lngAge, _
'									, , , , , , , , , , , , , , , _
'									0, , , , , , , , , , , , , , , _
'									, , , , , _
'									lngGender _
'									)
'
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, strCslDate, _
									strPerId, _
									, , , , , , , _
									lngAge, _
									, , , , , , , , , , , , , , , _
									0, , , , , , , , , , , , , , , _
									, , , , , _
									lngGender _
									)
'#### 2010.08.19 SL-UI-Y0101-104 MOD END ####'

	'オブジェクトのインスタンス削除
	Set objConsult = Nothing

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>生活習慣</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
var winIkensaTain;				// ウィンドウハンドル
//胃検査・他院での指摘ウインドウ呼び出し
function showIkensaTain() {

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか


	// すでにガイドが開かれているかチェック
	if ( winIkensaTain != null ) {
		if ( !winIkensaTain.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/interview/IkensaTain.asp?rsvno=' + <%= lngRsvNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winIkensaTain.focus();
		winIkensaTain.location.replace( url );
	} else {
		winIkensaTain = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

function windowClose() {

	// 胃検査・他院での指摘ウインドウを閉じる
	if ( winIkensaTain != null ) {
		if ( !winIkensaTain.closed ) {
			winIkensaTain.close();
		}
	}

	winIkensaTain = null;

}

//'#### 2010.08.19 SL-UI-Y0101-104 MOD START ####'
//function fujinkamonshin_popUp( p_rsvNo ) {
//    var width   = screen.width/2-400;
//    var height  = screen.height/2-275;
//    var url     = 'http://157.104.16.195/contents/kensa/fujin/fujin_monzin_kekka.jsp?p_rsvno=' + p_rsvNo + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
//    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=no,width=800,height=550");
//}

function fujinkamonshin_popUp( p_rsvNo, p_perid ) {
    var width   = screen.width/2-400;
    var height  = screen.height/2-275;
    var url     = 'http://lsvwhgui/contents/kensa/fujin/fujin_monzin_kekka.jsp?p_rsvno=' + p_rsvNo + '&p_perid=' + p_perid + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=yes,width=820,height=600");
}
//'#### 2010.08.19 SL-UI-Y0101-104 MOD END ####'

//'#### 2010.08.19 SL-UI-Y0101-104 ADD START ####'
function fujinkamonshin_popUp2( p_rsvNo, p_perid ) {
    var width   = screen.width/2-400;
    var height  = screen.height/2-275;

    var url     = 'http://lsvwhgui/contents/kensa/fujin/fujin_monzin_kekka_2.jsp?p_rsvno=' + p_rsvNo + '&p_perid=' + p_perid + '&HUSR=' + '<%= Server.HTMLEncode(Session("USERID")) %>'
    window.open(url,"","left="+width+",top="+height+",toolbar=no,status=no,resizable=yes,scrollbars=yes,width=1000,height=650");
}
//'#### 2010.08.19 SL-UI-Y0101-104 ADD END ####'

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">生活習慣</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
'			'前回歴コンボボックス表示
'			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="5" WIDTH="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP ALIGN="left"><A HREF="javascript:showIkensaTain()">胃検査・他院での指摘</A></TD>
			<TD NOWRAP ALIGN="left"><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="24" WIDTH="50"></TD>
			<TD NOWRAP ALIGN="left" WIDTH="100%"><A HREF="/webHains/contents/monshin/ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>&anchor=2" TARGET="_blank">ＯＣＲ入力結果確認</A></TD>
<%
	'女性のとき
	If lngGender = "2" Then
%>
<!--			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="/webHains/contents/?rsvno=<%= lngRsvNo %>" TARGET="_blank">婦人科問診詳細</A></TD>-->
<% '#### 2010.08.19 SL-UI-Y0101-104 MOD START ####' %>
<!--			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp(<%= lngRsvNo %>)">婦人科問診詳細</A></TD>-->
		<%  If CDate(strCslDate) >= CDate(strChgDate)  Then %>
			<!--切り替え日後の場合 -->
			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp2(<%= lngRsvNo %>, <%= strPerId %>)">婦人科問診詳細</A></TD>
		<%  Else %>
			<!--切り替え日前の場合 -->
			<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="javascript:fujinkamonshin_popUp(<%= lngRsvNo %>, <%= strPerId %>)">婦人科問診詳細</A></TD>
		<%  End If %>
<% '#### 2010.08.19 SL-UI-Y0101-104 MOD END ####' %>
<%
	End If
%>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
