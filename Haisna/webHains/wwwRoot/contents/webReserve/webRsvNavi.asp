<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   web予約情報登録(ナビバー) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-107
'修正日  ：2010.08.06（修正）
'担当者  ：TCS)菅原
'修正内容：web予約よりキャンセルの取込も可能とする。
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用
Dim objWebRsv		'web予約情報アクセス用

'引数値
Dim dtmCslDate		'受診年月日
Dim lngWebNo		'webNo.
Dim dtmStrCslDate	'開始受診年月日
Dim dtmEndCslDate	'終了受診年月日
Dim strKey			'検索キー
Dim dtmStrOpDate	'開始処理年月日
Dim dtmEndOpDate	'終了処理年月日
Dim lngOpMode		'処理モード(1:申込日で検索、2:予約処理日で検索)
Dim lngRegFlg		'本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
Dim lngOrder		'出力順(1:受診日順、2:個人ID順)
Dim strRegFlg		'本登録フラグ(1:未登録者、2:編集済み受診者)
'#### 2010.10.28 SL-UI-Y0101-107 ADD START ####'
Dim lngMosFlg		'申込区分(0:指定なし、1:新規、2:キャンセル)
'#### 2010.10.28 SL-UI-Y0101-107 ADD END ####'

Dim strCancelFlg	'キャンセルフラグ
Dim strPerId		'個人ID
Dim strRsvNo		'予約番号

Dim strNextCslDate	'次web予約情報の受診年月日
Dim strNextWebNo	'次web予約情報のwebNo.
Dim strTips			'Tipsの内容
Dim strFunc			'関数の内容
Dim Ret				'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
dtmCslDate    = CDate(Request("cslDate"))
lngWebNo      = CLng("0" & Request("webNo"))
dtmStrCslDate = CDate(Request("strCslDate"))
dtmEndCslDate = CDate(Request("endCslDate"))
strKey        = Request("key")
dtmStrOpDate  = CDate("0" & Request("strOpDate"))
dtmEndOpDate  = CDate("0" & Request("endOpDate"))
lngOpMode     = CLng("0" & Request("opMode"))
lngRegFlg     = CLng("0" & Request("regFlg"))
lngOrder      = CLng("0" & Request("order"))
strRegFlg     = Request("rsvRegFlg")
'#### 2010.10.28 SL-UI-Y0101-107 ADD START ####'
'申込区分の入力がなければ1:新規をデフォルトに
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-107 ADD END ####'
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>ナビゲーションバー</TITLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// コメント画面呼び出し
function callCommentWindow() {

	var detailForm = top.detail.document.paramForm;
	var optForm = top.opt.document.entryForm;

	// 他サブ画面を閉じる
	top.closeWindow( 1 );

	// 引数の設定
	var orgCd1 = ( detailForm.orgCd1.value != '' ) ? detailForm.orgCd1.value : null;
	var orgCd2 = ( detailForm.orgCd2.value != '' ) ? detailForm.orgCd2.value : null;

	var ctrPtCd;
	if ( optForm ) {
		if ( optForm.ctrPtCd ) {
			ctrPtCd = ( optForm.ctrPtCd.value != '' ) ? optForm.ctrPtCd.value : null;
		}
	}
<%
	'編集済み受診者の場合
	If strRegFlg = REGFLG_REGIST Then

		'オブジェクトのインスタンス作成
		Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

		'web予約情報を読み、予約番号を取得
		'#### 2011/01/20 MOD STA TCS)Y.T ####
		''#### 2010.08.06 SL-UI-Y0101-107 MOD START ####
		''※CanDateの対応で、RsvNoの前にカンマ１つ追加
		''objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , , strRsvNo
		'objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strRsvNo
		''#### 2010.08.06 SL-UI-Y0101-107 MOD END ####
		objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , , , , , , , , , , , , , , , , ,  strRsvNo
		'#### 2011/01/20 MOD STA TCS)Y.T ####

		'オブジェクトの解放
		Set objWebRsv = Nothing

		'予約番号が取得できたならば
		If strRsvNo <> "" Then

			'オブジェクトのインスタンス作成
			Set objConsult = Server.CreateObject("HainsConsult.Consult")

			'web予約情報を読み、受診情報上の個人ID、及びキャンセルフラグを取得
			objConsult.SelectConsult strRsvNo, strCancelFlg, , strPerId

			'オブジェクトの解放
			Set objConsult = Nothing

		End If

	End If
%>
	// コメント画面呼び出し
	noteGuide_showGuideNote( '1', '1,1,1,1', '<%= strPerId %>', '<%= strRsvNo %>', orgCd1, orgCd2, ctrPtCd );

}

// 次へ
function showNext() {
	top.showNext();
}

// 確定処理
function regist( next ) {
	top.regist( ( next > 0 ) );
}

// 画面を閉じる
function closeWindow() {
	top.close();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:noteGuide_closeGuideNote()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">web予約情報登録</FONT></B></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="464">
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2" WIDTH="100%">
				<TR>
<%
					'確定ボタンは編集済み受診者でない場合に表示する
					If strRegFlg <> REGFLG_REGIST Then
%>
						<TD><A HREF="javascript:regist(0)"><IMG SRC="/webhains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="現在の内容で予約情報を登録します"></A></TD>
<%
					End If

					'オブジェクトのインスタンス作成
					Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

					'web予約情報を読み、次キーを求める
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
					'Ret = objWebRsv.SelectWebRsvNext( _
					'		  dtmStrCslDate,          _
					'		  dtmEndCslDate,          _
					'		  strKey,                 _
					'		  dtmStrOpDate,           _
					'		  dtmEndOpDate,           _
					'		  lngOpMode,              _
					'		  lngRegFlg,              _
					'		  lngOrder,               _
					'		  dtmCslDate,             _
					'		  lngWebNo,               _
					'		  strNextCslDate,         _
					'		  strNextWebNo            _
					'	  )
					Ret = objWebRsv.SelectWebRsvNext( _
							  dtmStrCslDate,          _
							  dtmEndCslDate,          _
							  strKey,                 _
							  dtmStrOpDate,           _
							  dtmEndOpDate,           _
							  lngOpMode,              _
							  lngRegFlg,              _
							  lngMosFlg,              _
							  lngOrder,               _
							  dtmCslDate,             _
							  lngWebNo,               _
							  strNextCslDate,         _
							  strNextWebNo            _
						  )
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

					'オブジェクトの解放
					Set objWebRsv = Nothing

					'レコード存在時は「次へ」ボタンを表示
					If Ret = True Then

						'Tipsの編集
						If strRegFlg <> REGFLG_REGIST Then
							strTips = "現在の内容で予約情報を登録し、次のweb予約情報を表示します"
						Else
							strTips = "次のweb予約情報を表示します"
						End If

						'関数の編集
						If strRegFlg <> REGFLG_REGIST Then
							strFunc = "regist(1)"
						Else
							strFunc = "showNext()"
						End If
%>
						<TD><A HREF="javascript:<%= strFunc %>"><IMG SRC="/webhains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="<%= strTips %>"></A></TD>
<%
					End If

					'コメントボタンは未編集、または編集済みで非キャンセル者の場合に表示
					If strCancelFlg = "" Or CStr(strCancelFlg) = CStr(CONSULT_USED) Then
%>
						<TD><A HREF="javascript:callCommentWindow()"><IMG SRC="/webhains/images/comment.gif" WIDTH="77" HEIGHT="24" ALT="コメントを表示します"></A></TD>
<%
					End If
%>
					<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:closeWindow()"><IMG SRC="/webhains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
				</TR>
			</TABLE>
		</TD>
<%
		'編集済み受診者の場合はメッセージを表示する
		If strRegFlg = REGFLG_REGIST Then
%>
			<TD ALIGN="right"><B><FONT COLOR="#ff6600">編集済み受診者</FONT></B></TD>
<%
		Else
%>
			<TD></TD>
<%
		End If
%>
	</TR>
</TABLE>
</BODY>
</HTML>
