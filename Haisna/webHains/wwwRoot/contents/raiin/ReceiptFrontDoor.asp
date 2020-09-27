<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   来院確認  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス
Dim objFree				'汎用情報アクセス用

'パラメータ
Dim strAction			'処理状態(確定ボタン押下時:"check"→"checkend"→"save")
Dim strGuidanceNo		'ご案内書Ｎｏ
Dim strOcrNo			'ＯＣＲＮｏ

'来院情報用変数
Dim lngRsvNo			'予約番号
Dim vntCancelFlg		'キャンセルフラグ
Dim vntCslDate			'受診日
Dim vntPerId			'個人ID
Dim vntCsCd				'コースコード
Dim vntOrgCd1			'受診時団体コード1
Dim vntOrgCd2			'受診時団体コード2
Dim vntRsvGrpCd			'予約群コード
Dim vntRsvDate			'予約日
Dim vntAge				'受診時年齢
Dim vntCtrPtCd			'契約パターンコード
Dim vntIsrSign			'保険証記号
Dim vntIsrNo			'保険証番号
Dim vntReportAddrDiv	'成績書宛先
Dim vntReportOurEng		'成績書英文出力
Dim vntCollectTicket	'利用券回収
Dim vntIssueCslTicket	'診察券発行
Dim vntBillPrint		'請求書出力
Dim vntVolunteer		'ボランティア
Dim vntVolunteerName	'ボランティア名
Dim vntDayID			'当日ID
Dim vntComeDate			'来院日時
Dim vntComeUser			'来院処理者
Dim vntOcrNo			'OCR番号
Dim vntLockerKey		'ロッカーキー
Dim vntBirth			'生年月日
Dim vntGender			'性別
Dim vntLastName			'姓
Dim vntFirstName		'名
Dim vntLastKName		'カナ姓
Dim vntFirstKName		'カナ名
Dim vntRomeName			'ローマ字名
Dim vntNationCd			'国籍コード
Dim vntNationName		'国籍名
Dim vntCompPerId		'同伴者個人ID
Dim vntCompPerName		'同伴者個人名
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim vntOrgKName			'団体カナ名称
Dim vntOrgName			'団体漢字名称
Dim vntOrgSName			'団体略称
Dim vntTicket			'利用券
Dim vntInsBring			'保険証当日持参
Dim vntRsvGrpName		'予約群名称
Dim vntRsvGrpStrTime	'予約群開始時間
Dim vntRsvGrpEndTime	'予約群終了時間

Dim blnRsvFlg			'予約済フラグ
Dim strEraBirth			'生年月日(和暦)
Dim strRealAge			'実年齢

Dim strArrMessage		'エラーメッセージ
Dim strUpdUser			'更新者
Dim strURL				'URL文字列
Dim Ret					'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strAction		= Request("act")
strGuidanceNo	= Request("GuidanceNo")
strOcrNo		= Request("OcrNo")

lngRsvNo		= strGuidanceNo
strUpdUser		= Session("USERID")

Do
	'受付確認処理
	If strAction = "check" Then
		blnRsvFlg = False

		'値のチェック(ご案内書Ｎｏ)
		strArrMessage = objCommon.CheckNumeric("ご案内書Ｎｏ", lngRsvNo, LENGTH_CONSULT_RSVNO, CHECK_NECESSARY)
		If strArrMessage <> "" Then
			strAction = "checkerr"
			Exit Do
		End If
		'値のチェック(OCR番号)
		strArrMessage = objCommon.CheckAlphabetAndNumeric("ＯＣＲＮｏ", strOcrNo, 10, CHECK_NECESSARY)
		If strArrMessage <> "" Then
			strAction = "checkerr"
			Exit Do
		End If

		'来院情報検索
		Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
											vntCancelFlg,		_
											vntCslDate,			_
											vntPerId,			_
											vntCsCd,			_
											vntOrgCd1,			_
											vntOrgCd2,			_
											vntRsvGrpCd,		_
											vntRsvDate,			_
											vntAge,				_
											vntCtrPtCd,			_
											vntIsrSign,			_
											vntIsrNo,			_
											vntReportAddrDiv,	_
											vntReportOurEng,	_
											vntCollectTicket,	_
											vntIssueCslTicket,	_
											vntBillPrint,		_
											vntVolunteer,		_
											vntVolunteerName,	_
											vntDayID,			_
											vntComeDate,		_
											vntComeUser,		_
											vntOcrNo,			_
											vntLockerKey,		_
											vntBirth,			_
											vntGender,			_
											vntLastName,		_
											vntFirstName,		_
											vntLastKName,		_
											vntFirstKName,		_
											vntRomeName,		_
											vntNationCd,		_
											vntNationName,		_
											vntCompPerId,		_
											vntCompPerName,		_
											vntCsName,			_
											vntCsSName,			_
											vntOrgKName,		_
											vntOrgName,			_
											vntOrgSName,		_
											vntTicket,			_
											vntInsBring,		_
											vntRsvGrpName,		_
											vntRsvGrpStrTime,	_
											vntRsvGrpEndTime	_
										)
		strAction = "checkend"
		blnRsvFlg = Ret
		If Ret = False Then
			strArrMessage = "予約されていません。"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   vntDayID = "" Then
			strArrMessage = "受付されていません。"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   objCommon.FormatString(Date, "yyyy/mm/dd") <> objCommon.FormatString(CDate(vntCslDate), "yyyy/mm/dd") Then
			strArrMessage = "受診日(" & objCommon.FormatString(CDate(vntCslDate), "yyyy/mm/dd") & ")は本日ではありません。"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   vntComeDate <> "" Then
			strArrMessage = "すでに来院済みです。"
			strAction = "checkerr"
		End If
	End If

	'更新処理
	If strAction = "save" Then
		'来院情報(来院、OCR番号)の更新
		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, _
											0, _
											strUpdUser, _
											, _
											1, _
											strOcrNo _
											)
		If Ret = True Then
			strAction = "saveend"
		End If
	End If

	'オブジェクトのインスタンス削除
	Set objConsult = Nothing

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受付入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winReserveMain;						// 予約画面のウィンドウハンドル
var winReceiptMain;						// 来院画面のウィンドウハンドル

// 初期処理
function loadPage() {
	var myForm = document.entryForm;
	var opened = false;					// 画面が開かれているか
	var url;							// URL文字列
	var i;

	// チェックでエラーがなければ更新処理を行う
	if ( myForm.act.value == 'checkend' ) {
		myForm.act.value = 'save';
		myForm.submit();
		return;
	}

	if ( myForm.act.value == 'saveend' ) {
		//
		// 予約画面を開く
		//
		// すでにガイドが開かれているかチェック
		if ( winReserveMain ) {
			if ( !winReserveMain.closed ) {
				opened = true;
			}
		}
		url = '/WebHains/contents/reserve/rsvMain.asp';
		url = url + '?rsvno=' + '<%= lngRsvNo %>';

		// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
		if ( opened ) {
			winReserveMain.focus();
			winReserveMain.location.replace( url );
		} else {
			winReserveMain = window.open( url, '', 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes,top=0,left=0' );
		}

		opened = false;
		//
		// 来院画面を開く
		//
		// すでにガイドが開かれているかチェック
		if ( winReceiptMain ) {
			if ( !winReserveMain.closed ) {
				opened = true;
			}
		}
		url = '/WebHains/contents/raiin/ReceiptMain.asp';
		url = url + '?rsvno=' + '<%= lngRsvNo %>';
		url = url + '&receiptflg=1';

		// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
		if ( opened ) {
			winReceiptMain.focus();
			winReceiptMain.location.replace( url );
		} else {
			winReceiptMain = window.open( url, '', 'width=670,height=700,status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes,top=0,left=0' );
		}
		return;
	}

	// フォーカス設定
	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			if ( myForm.elements[i].value == '' ) {
				myForm.elements[i].focus();
				return;
			}
		}
	}
}

// 確定ボタン押下時の処理
function OkReceipt() {
	var myForm = document.entryForm;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			if ( myForm.elements[i].value == '' ) {
				myForm.elements[i].focus();
				alert( 'ご案内書Ｎｏ、ＯＣＲＮｏとも入力してください。' );
				return;
			}
		}
	}

	myForm.act.value = 'check';
	myForm.submit();
	return;
}

// キー押下時の処理
function Key_Press(){
	var myForm = document.entryForm;
	var i;

	// Enterキー
	if ( event.keyCode == 13 ) {
		if( myForm.elements == null ) return;

		for( i=0; i < myForm.elements.length; i++ ) {
			if ( myForm.elements[i].type == 'text' ) {
				if ( myForm.elements[i].value == '' ) {
					myForm.elements[i].focus();
					return;
				}
			}
		}

		// 確定処理を行う
		OkReceipt();
	}
}

// ウィンドウを閉じる
function windowClose() {

	// 予約画面を閉じる
	if ( winReserveMain != null ) {
		if ( !winReserveMain.closed ) {
			winReserveMain.close();
		}
	}

	// 来院画面を閉じる
	if ( winReceiptMain != null ) {
		if ( !winReceiptMain.closed ) {
			winReceiptMain.close();
		}
	}

	winReserveMain = null;
	winReceiptMain = null;
}

// 次の受付入力を行うため初期化する
function nextReceipt() {
	var myForm = document.entryForm;
	var i;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			myForm.elements[i].value = '';
		}
	}
	myForm.GuidanceNo.focus();

	myForm.act.value = '';

	// ウィンドウを閉じる
	windowClose();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:loadPage()" ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			<TD WIDTH="100%">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受付入力</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
		</TR>
	</TABLE>
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD ALIGN="center">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
					</TR>
					<TR VALIGN="center">
						<TD NOWRAP>ご案内書Ｎｏ</TD>
						<TD NOWRAP WIDTH="8">：</TD>
						<TD NOWRAP><INPUT TYPE="text" NAME="GuidanceNo" SIZE="9" MAXLENGTH="9" BORDER="0" VALUE="<%= strGuidanceNo %>" STYLE="ime-mode:disabled" ONKEYPRESS="JavaScript:Key_Press()"></TD>
					</TR>
					<TR VALIGN="center">
						<TD NOWRAP>ＯＣＲＮｏ</TD>
						<TD NOWRAP WIDTH="8">：</TD>
						<TD NOWRAP><INPUT TYPE="text" NAME="OcrNo" SIZE="10" MAXLENGTH="10" BORDER="0" VALUE="<%= strOcrNo %>" STYLE="ime-mode:disabled" ONKEYPRESS="JavaScript:Key_Press()"></TD>
					</TR>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
					</TR>
					<TR>
						<TD NOWRAP COLSPAN="3" ALIGN="center">
						<% '2005.08.22 権限管理 Add by 李　--- START %>
				        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
							<A HREF="JavaScript:OkReceipt()"><IMG SRC="../../images/ok.gif" WIDTH="77" HEIGHT="23" ALT="この内容で受付確定" BORDER="0"></A>
						<%  else    %>
							 &nbsp;
						<%  end if  %>
						<% '2005.08.22 権限管理 Add by 李　--- END %>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<%
	If strAction = "checkerr" Then
%>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
		</TR>
		<TR>
			<TD ALIGN="center">
<%
		If Not IsEmpty(strArrMessage) Then
			'エラーメッセージを編集
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
		If blnRsvFlg = True Then
%>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
		</TR>
		<TR>
			<TD ALIGN="center">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR VALIGN="middle">
									<TD NOWRAP>予約番号：</TD>
									<TD NOWRAP>
										<A HREF="/WebHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">
											<B><%= lngRsvNo %></B>
										</A>
									</TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>当日ＩＤ：</TD>
									<TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntDayID="", "未受付", objCommon.FormatString(vntDayID, "0000")) %></B></FONT></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>来院情報：</TD>
									<TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntComeDate="", "未来院", "来院済み") %></B></FONT></TD>
								</TR>
							</TABLE>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
								</TR>
								<TR VALIGN="middle">
									<TD NOWRAP>コース：</TD>
									<TD NOWRAP><B><%= vntCsName %></B></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>受診日：</TD>
									<TD NOWRAP><B><%= vntCslDate %></B></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>予約群：</TD>
									<TD NOWRAP><B><%= vntRsvGrpName %></B></TD>
								</TR>
							</TABLE>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
								</TR>
								<TR VALIGN="middle">
									<TD NOWRAP><%= vntPerId %></TD>
									<TD WIDTH="10"></TD>
									<TD NOWRAP>
										<B><%= vntLastName & "　" & vntFirstName %></B>
										<FONT COLOR="#999999"> (</FONT><FONT SIZE="-1" COLOR="#999999"><%= vntLastKName & "　" & vntFirstKName %></FONT><FONT COLOR="#999999">)</FONT>
									</TD>
									<TD NOWRAP WIDTH="10"></TD>
<%
	'生年月日(西暦＋和暦)の編集
	strEraBirth = objCommon.FormatString(CDate(vntBirth), "ge（yyyy）.m.d")

	'実年齢の計算
	If vntBirth <> "" Then
		Set objFree = Server.CreateObject("HainsFree.Free")
		strRealAge = objFree.CalcAge(vntBirth)
		Set objFree = Nothing
	Else
		strRealAge = ""
	End If

	'小数点以下の切り捨て
	If IsNumeric(strRealAge) Then
		strRealAge = CStr(Int(strRealAge))
	End If
%>
									<TD NOWRAP><%= strEraBirth %>生　<%= strRealAge %>歳（<%= Int(vntAge) %>歳）　<%= IIf(vntGender = "1", "男性", "女性") %></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<%
		End If
	End If
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
