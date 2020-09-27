<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   お連れ様情報更新  (Ver0.0.1)
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
Const DEFAULT_ROW			= 10		'デフォルト表示行数
Const INCREASE_COUNT		= 5			'表示行数の増分単位
Const SAMEGRP_SELMAX		= 99		'面接同時受診の選択数上限(とりあえず設定しておく)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス
Dim objPerson			'個人情報アクセス用

'パラメータ
Dim strAct				'処理状態
Dim lngRsvNo			'予約番号
Dim lngDispCnt			'指定可能受診者数

'受診情報用変数
Dim strPerId			'個人ID
Dim strCslDate			'受診日
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim strOrgName			'団体名称
Dim strAge				'年齢
Dim strDayId			'当日ID
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別

'個人情報用変数
Dim strCompPerId		'同伴者ＩＤ

'お連れ様情報用変数
Dim strArrCslDate		'受診日の配列
Dim strArrSeq			'お連れ様Seqの配列
Dim strArrRsvNo			'予約番号の配列
Dim strArrSameGrp1		'面接同時受診１の配列
Dim strArrSameGrp2		'面接同時受診２の配列
Dim strArrSameGrp3		'面接同時受診３の配列
Dim strArrPerId			'個人IDの配列
Dim strArrCsName		'コース名の配列
Dim strArrOrgSName		'団体名称の配列
Dim strArrLastName		'姓の配列
Dim strArrFirstName		'名の配列
Dim strArrLastKName		'カナ姓の配列
Dim strArrFirstKName	'カナ名の配列
Dim strArrName			'氏名の配列
Dim strArrKName			'カナ氏名の配列
Dim strArrRsvGrpName	'予約群名称の配列
Dim strArrCompOrg		'同伴者個人IDの配列(設定前)
Dim strArrCompNew		'同伴者個人IDの配列(設定後)

'更新用変数
Dim dtmUpdCslDate		'受診日
Dim lngUpdSeq			'お連れ様Seq
Dim vntArrUpdRsvNo		'予約番号の配列
Dim vntArrUpdSameGrp1	'面接同時受診１の配列
Dim vntArrUpdSameGrp2	'面接同時受診１の配列
Dim vntArrUpdSameGrp3	'面接同時受診１の配列
Dim lngUpdCount			'更新件数
Dim strArrMessage		'エラーメッセージ
Dim vntArrUpdPerId		'個人IDの配列
Dim vntArrUpdCompPerId	'同伴者個人IDの配列
Dim lngUpdCompCount		'同伴者更新件数

Dim Ret					'関数戻り値
Dim lngCount			'取得件数
Dim strHtml				'HTML文字列
Dim i, j				'カウンタ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")
Set objPerson		= Server.CreateObject("HainsPerson.Person")

'引数値の取得
strAct				= Request("act")
lngRsvNo			= Request("rsvno")
lngDispCnt			= CLng("0" & Request("dispCnt"))

strArrCslDate	= ConvIStringToArray(Request("f_csldate"))
strArrSeq		= ConvIStringToArray(Request("f_seq"))
strArrRsvNo		= ConvIStringToArray(Request("f_rsvno"))
strArrSameGrp1	= ConvIStringToArray(Request("f_samegrp1"))
strArrSameGrp2	= ConvIStringToArray(Request("f_samegrp2"))
strArrSameGrp3	= ConvIStringToArray(Request("f_samegrp3"))
strArrPerId		= ConvIStringToArray(Request("f_perid"))
strArrCsName	= ConvIStringToArray(Request("f_csname"))
strArrOrgSName	= ConvIStringToArray(Request("f_orgname"))
strArrName		= ConvIStringToArray(Request("f_name"))
strArrKName		= ConvIStringToArray(Request("f_kname"))
strArrRsvGrpName = ConvIStringToArray(Request("f_rsvgrpname"))
strArrCompOrg	= ConvIStringToArray(Request("comporg"))
strArrCompNew	= ConvIStringToArray(Request("compnew"))

Do
	'受診情報検索
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									strCslDate,    _
									strPerId,      _
									strCsCd,       _
									strCsName,     _
									, , _
									strOrgName,    _
									, , _
									strAge,        _
									, , , , , , , , , , , , _
									strDayId,      _
									, , 0, , , , , , , , , , , , , , , _
									strLastName,   _
									strFirstName,  _
									strLastKName,  _
									strFirstKName, _
									strBirth,      _
									strGender )
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'お連れ様情報の削除
	If strAct = "delete" Then
		dtmUpdCslDate = CDate(strArrCslDate(0))
		lngUpdSeq = CLng("0" & strArrSeq(0))

		If lngUpdSeq > 0 Then
			'お連れ様情報の削除
			objConsult.DeleteFriends dtmUpdCslDate, lngUpdSeq
			strAct = "deleteend"
		Else
			strAct = ""
		End If

	End If

	'お連れ様情報の保存
	If strAct = "save" Then
		vntArrUpdRsvNo = Array()
		vntArrUpdSameGrp1 = Array()
		vntArrUpdSameGrp2 = Array()
		vntArrUpdSameGrp3 = Array()
		lngUpdCount = 0
		vntArrUpdPerId = Array()
		vntArrUpdCompPerId = Array()
		lngUpdCompCount = 0

		For i=0 To UBound(strArrRsvNo)
			If strArrRsvNo(i) <> "" Then
				Redim Preserve vntArrUpdRsvNo(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp1(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp2(lngUpdCount)
				Redim Preserve vntArrUpdSameGrp3(lngUpdCount)
				vntArrUpdRsvNo(lngUpdCount) = strArrRsvNo(i)
				vntArrUpdSameGrp1(lngUpdCount) = strArrSameGrp1(i)
				vntArrUpdSameGrp2(lngUpdCount) = strArrSameGrp2(i)
				vntArrUpdSameGrp3(lngUpdCount) = strArrSameGrp3(i)
'## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
				If strArrCompOrg(i) <> strArrCompNew(i) Then
					Redim Preserve vntArrUpdPerId(lngUpdCompCount)
					Redim Preserve vntArrUpdCompPerId(lngUpdCompCount)
					vntArrUpdPerId(lngUpdCompCount) = strArrPerId(i)
					vntArrUpdCompPerId(lngUpdCompCount) = strArrCompNew(i)
					lngUpdCompCount = lngUpdCompCount + 1
				End If
'## 2004.01.20 Add End
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		If lngUpdCount > 0 Then
			dtmUpdCslDate = CDate(strArrCslDate(0))
			'新規のときはお連れ様Seqを0とする（保存時に自動発番する）
			lngUpdSeq = CLng("0" & strArrSeq(0))

			'お連れ様が一人もいないで保存しようとしている
			If lngUpdCount = 1 Then
				If lngUpdSeq > 0 Then
					'お連れ様情報の削除
					objConsult.DeleteFriends dtmUpdCslDate, lngUpdSeq
				Else
					strArrMessage = "お連れ様が一人もいない場合は保存できません。"
					Exit Do
				End If
			Else
				'お連れ様情報の保存
'## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
				objConsult.UpdateFriends dtmUpdCslDate, lngUpdSeq, vntArrUpdRsvNo, vntArrUpdSameGrp1, vntArrUpdSameGrp2, vntArrUpdSameGrp3, strArrMessage, _
										 vntArrUpdPerId, vntArrUpdCompPerId
'## 2004.01.20 Add End
				If Not IsEmpty(strArrMessage) Then
					Exit Do
				End If
			End If
		End If
		strAct = "saveend"
	End If

	'表示行数の変更のときはお連れ様情報を取得しない
	If strAct <> "redisp" Then
		'お連れ様情報を取得
'## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
		lngCount = objConsult.SelectFriends(strCslDate, _
											lngRsvNo, _
											strArrCslDate,    _
											strArrSeq,        _
											strArrRsvNo,      _
											strArrSameGrp1,   _
											strArrSameGrp2,   _
											strArrSameGrp3,   _
											strArrPerId,      _
											, _
											strArrCsName,     _
											, , , _
											strArrOrgSName,   _
											strArrLastName,   _
											strArrFirstName,  _
											strArrLastKName,  _
											strArrFirstKName, _
											, _
											strArrRsvGrpName, _
											strArrCompOrg   _
											)
'## 2004.01.20 Add End
		If lngCount < 0 Then
			Err.Raise 1000, , "お連れ様情報が存在しません。（受診日= " & strCslDate & " 予約番号= " & lngRsvNo & " )"
		End If

		If lngCount = 0 Then
			strArrCslDate = Array()
			strArrSeq = Array()
			strArrRsvNo = Array()
			strArrSameGrp1 = Array()
			strArrSameGrp2 = Array()
			strArrSameGrp3 = Array()
			strArrPerId = Array()
			strArrOrgSName = Array()
			strArrCsName = Array()
			strArrName = Array()
			strArrKName = Array()
			strArrRsvGrpName = Array()
			strArrCompOrg = Array()
			strArrCompNew = Array()

			lngDispCnt = DEFAULT_ROW
		Else
			'氏名の編集
			strArrName = Array()
			Redim strArrName(lngCount-1)
			strArrKName = Array()
			Redim strArrKName(lngCount-1)
			For i=0 To lngCount-1
				strArrName(i) = strArrLastName(i) & "　" & strArrFirstName(i)
				strArrKName(i) = strArrLastKName(i) & "　" & strArrFirstKName(i)
			Next
'## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
			strArrCompNew = Array()
			Redim strArrCompNew(lngCount-1)
			For i=0 To lngCount-1
				strArrCompNew(i) = strArrCompOrg(i)
			Next
'## 2004.01.20 Add End

			'指定可能受診者数の判断
			lngDispCnt = DEFAULT_ROW
			Do
				If lngDispCnt > lngCount Then
					Exit Do
				End If
				lngDispCnt = lngDispCnt + INCREASE_COUNT
			Loop
		End If
	End If

	'空でも領域を作成しておく
	Redim Preserve strArrCslDate(lngDispCnt)
	Redim Preserve strArrSeq(lngDispCnt)
	Redim Preserve strArrRsvNo(lngDispCnt)
	Redim Preserve strArrSameGrp1(lngDispCnt)
	Redim Preserve strArrSameGrp2(lngDispCnt)
	Redim Preserve strArrSameGrp3(lngDispCnt)
	Redim Preserve strArrPerId(lngDispCnt)
	Redim Preserve strArrOrgSName(lngDispCnt)
	Redim Preserve strArrCsName(lngDispCnt)
	Redim Preserve strArrName(lngDispCnt)
	Redim Preserve strArrKName(lngDispCnt)
	Redim Preserve strArrRsvGrpName(lngDispCnt)
	Redim Preserve strArrCompOrg(lngDispCnt)
	Redim Preserve strArrCompNew(lngDispCnt)

	'個人情報読み込み
	Ret = objPerson.SelectPerson_lukes(strPerId, _
										, , , , , , , , , , _
										strCompPerId )
	If Ret = False Then
		Err.Raise 1000, , "個人情報が存在しません。（個人ID= " & strPerId & " )"
	End If

	Exit Do
Loop
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>お連れ様情報更新</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winGuide;						// 個人検索ガイドウィンドウハンドル
var SelectLineNo;					// 選択位置

// 個人検索ガイドの表示
function callGuide( index ) {
	var url;							// URL文字列
	var opened = false;					// 画面がすでに開かれているか

	// 選択位置を保持
	SelectLineNo = index;

	// すでにガイドが開かれているかチェック
	if ( winGuide != null ) {
		if ( !winGuide.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/guide/gdeConsultList.asp';
	url = url + '?csldate=<%= strCslDate %>';
	url = url + '&perid=<%= strPerId %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winGuide.focus();
		winGuide.location.replace( url );
	} else {
		winGuide = window.open( url, '', 'width=500,height=600,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}
}

// サブ画面を閉じる
function closeWindow() {

	// 所見選択画面を閉じる
	if ( winGuide != null ) {
		if ( !winGuide.closed ) {
			winGuide.close();
		}
	}

	winGuide  = null;
}

// お連れ様情報のクリア
function clearFriends( index ) {
	var myForm = document.entryForm;

	myForm.f_csldate[index].value = '';
	myForm.f_rsvno[index].value   = '';
	myForm.f_perid[index].value   = '';
	myForm.f_orgname[index].value = '';
	myForm.f_csname[index].value  = '';
	myForm.f_name[index].value    = '';
	myForm.f_kname[index].value   = '';
	myForm.f_rsvgrpname[index].value = '';
	myForm.f_samegrp1[index].value   = '';
	myForm.f_samegrp2[index].value   = '';
	myForm.f_samegrp3[index].value   = '';
	myForm.comporg[index].value   = '';
	myForm.compnew[index].value   = '';

	// お連れ様リストの再表示
	dispFriendsList();
}

// お連れ様リストの表示
function dispFriendsList() {
	var myForm = document.entryForm;
	var elem   = document.getElementById('FriendsList');
	var strHtml;
	var i, j;

	strHtml = '<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">\n';
	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>個人ＩＤ</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>氏名</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>予約番号</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>受診団体</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>受診コース</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP>予約群</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="3" ALIGN="center" BGCOLOR="#CCFFFF">面接を同時受診</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP BGCOLOR="#FFCCFF">同伴者</TD>\n';
	strHtml = strHtml + '</TR>\n';

	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="12" ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD NOWRAP COLSPAN="3" ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '<TD></TD>\n';
	strHtml = strHtml + '<TD NOWRAP ALIGN="left" BGCOLOR="#999999"><IMG SRC="../../images/spacer.gif" HEIGHT="1" WIDTH="1" BORDER="0"></TD>\n';
	strHtml = strHtml + '</TR>\n';

	for ( i = 0; i <= <%= lngDispCnt %>; i++ ) {
		strHtml = strHtml + '<TR>\n';
		if( myForm.f_rsvno[i].value == '<%= lngRsvNo %>' ) {
			strHtml = strHtml + '<TD NOWRAP><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
			strHtml = strHtml + '<TD NOWRAP><IMG SRC="../../images/spacer.gif" HEIGHT="21" WIDTH="21" BORDER="0"></TD>\n';
		} else if( myForm.f_perid[i].value != '' && myForm.f_perid[i].value == '<%= strCompPerId %>' ) {
			strHtml = strHtml + '<TD NOWRAP COLSPAN=2>同伴者</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:callGuide(' + i + ')"><IMG SRC="../../images/question.gif" ALT="個人検索ガイドを表示します" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>\n';
			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:clearFriends(' + i + ')"><IMG SRC="../../images/delicon.gif" ALT="この受診者をお連れ様情報から削除します" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>\n';
		}

		if( myForm.f_perid[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_perid[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_name[i].value == '' && myForm.f_kname[i].value == '') {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_name[i].value + '（<SPAN STYLE="font-size:9px;"><B>' + myForm.f_kname[i].value + '</B></SPAN>）</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_rsvno[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_rsvno[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_orgname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_orgname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_csname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_csname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		if( myForm.f_rsvgrpname[i].value == '' ) {
			strHtml = strHtml + '<TD NOWRAP>&nbsp;</TD>\n';
		} else {
			strHtml = strHtml + '<TD NOWRAP>' + myForm.f_rsvgrpname[i].value + '</TD>\n';
		}
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

		// 面接同時受診
		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp1[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk1" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk1" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';

		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp2[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk2" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk2" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';

		strHtml = strHtml + '<TD NOWRAP ALIGN="center" BGCOLOR="#CCFFFF">';
		if( myForm.f_samegrp3[i].value == 1 ) {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk3" VALUE="1" BORDER="0" CHECKED>';
		} else {
			strHtml = strHtml + '<INPUT TYPE="checkbox" NAME="chk3" VALUE="1" BORDER="0">';
		}
		strHtml = strHtml + '</TD>\n';
		strHtml = strHtml + '<TD NOWRAP WIDTH="10"></TD>\n';

// ## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
		// 同伴者
		strHtml = strHtml + '<TD NOWRAP ALIGN="left" BGCOLOR="#FFCCFF">';
		if( myForm.f_perid[i].value != '' ) {
			strHtml = strHtml + '<SELECT NAME="complist" STYLE="width:180px" ONCHANGE="javascript:document.entryForm.compnew[' + i + '].value = this.value">\n';
			strHtml = strHtml + '<OPTION VALUE="">\n';
			for ( j = 0; j <= <%= lngDispCnt %>; j++ ) {
				if( i == j ) continue;
				if( myForm.f_perid[j].value != '' ) {
					strHtml = strHtml + '<OPTION VALUE="' + myForm.f_perid[j].value + '"';
					if( myForm.compnew[i].value == myForm.f_perid[j].value ) {
						strHtml = strHtml + ' SELECTED';
					}
					strHtml = strHtml + '>' + myForm.f_perid[j].value + ' ' + myForm.f_name[j].value + '\n';
				}
			}
			strHtml = strHtml + '</SELECT>\n';
		}
		strHtml = strHtml + '</TD>\n';
// ## 2004.01.20 Add End

		strHtml = strHtml + '</TR>\n';
	}
	strHtml = strHtml + '</TABLE>\n';
	elem.innerHTML = strHtml;
}

// お連れ様情報の削除
function deleteFriends() {

	if( '<%= strCompPerId %>' != '' ) {
		alert( '同伴者がいるため、このお連れ様情報は削除できません' );
		return;
	}

// ## 2003.11.26 Add By T.Takagi@FSIT アラートなしはまずい
	if ( !confirm('このお連れ様情報をすべて削除します。よろしいですか？' ) ) {
		return;
	}
// ## 2003.11.26 Add End

	document.entryForm.act.value = 'delete';
	document.entryForm.submit();
}

// お連れ様情報の保存
function saveFriends() {
	var myForm = document.entryForm;
	var count;
	var i, j;

	// 面接同時受診の入力チェック
	if ( myForm.f_rsvno.length ) {
		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk1[i].checked ) {
				myForm.f_samegrp1[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp1[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '面接同時受診を選択するには2人以上選択してください' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '面接同時受診は最大<%= SAMEGRP_SELMAX %>人までしか選択できません' );
			return;
		}

		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk2[i].checked ) {
				myForm.f_samegrp2[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp2[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '面接同時受診を選択するには2人以上選択してください' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '面接同時受診は最大<%= SAMEGRP_SELMAX %>人までしか選択できません' );
			return;
		}

		count=0;
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk3[i].checked ) {
				myForm.f_samegrp3[i].value = '1';
				count++;
			} else {
				myForm.f_samegrp3[i].value = '';
			}
		}
		if( count == 1 ) {
			alert( '面接同時受診を選択するには2人以上選択してください' );
			return;
		} else if( count > <%= SAMEGRP_SELMAX %> ) {
			alert( '面接同時受診は最大<%= SAMEGRP_SELMAX %>人までしか選択できません' );
			return;
		}

// ## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.compnew[i].value == '' ) continue;
			// お連れ様内に同伴者がいない場合はチェック対象外
			if( myForm.compnew[i].value == myForm.comporg[i].value ) continue;
			count=0;
			for( j=0; j<myForm.f_rsvno.length; j++ ) {
				if( i == j ) continue;
				if( myForm.compnew[i].value == myForm.f_perid[j].value ) {
					if( myForm.f_perid[i].value == myForm.compnew[j].value ) {
						count++;
					}
				}
			}
			if( count != 1 ) {
				alert( '同伴者設定は必ず１対１になるようにしてください count='+count );
				return;
			}
		}
	}
// ## 2004.01.20 Add End

	document.entryForm.act.value = 'save';
	document.entryForm.submit();
}

// 表示行数の変更
function changeRow() {
	var myForm = document.entryForm;
	var i;

	if ( myForm.f_rsvno.length ) {
		// 面接同時受診の状態保持
		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk1[i].checked ) {
				myForm.f_samegrp1[i].value = '1';
			} else {
				myForm.f_samegrp1[i].value = '';
			}
		}

		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk2[i].checked ) {
				myForm.f_samegrp2[i].value = '1';
			} else {
				myForm.f_samegrp2[i].value = '';
			}
		}

		for( i=0; i<myForm.f_rsvno.length; i++ ) {
			if( myForm.f_rsvno[i].value != '' && myForm.chk3[i].checked ) {
				myForm.f_samegrp3[i].value = '1';
			} else {
				myForm.f_samegrp3[i].value = '';
			}
		}
	}

	document.entryForm.act.value = 'redisp';
	document.entryForm.submit();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()" ONLOAD="JavaScript:dispFriendsList()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
<!-- ## 2003.11.26 Del By T.Takagi@FSIT -->
<!--
<BLOCKQUOTE>
-->
<!-- ## 2003.11.26 Del End -->
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAct %>">

	<!-- タイトルの表示 -->
<!-- ## 2003.11.26 Mod By T.Takagi@FSIT -->
<!--
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">■お連れ様～同伴者情報更新</SPAN></B></TD>
		</TR>
	</TABLE>
-->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN>お連れ様～同伴者情報更新</B></TD>
		</TR>
	</TABLE>
<!-- ## 2003.11.26 Mod End -->
	<BR>

	<!-- 受診情報の表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD NOWRAP>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD NOWRAP>予約番号</TD>
			<TD NOWRAP>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診コース</TD>
			<TD NOWRAP>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="371">
		<TR HEIGHT="9">
			<TD COLSPAN="3"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top" WIDTH="96"><%= strPerId %></TD>
			<TD NOWRAP ROWSPAN="2" WIDTH="16"></TD>
			<TD NOWRAP WIDTH="247"><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="247"><%= FormatDateTime(strBirth, 1) %>生　<%= Int(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP WIDTH="391"><SPAN STYLE="color:#cc9999">●</SPAN>お連れ様として登録する受診者を選択してください。</TD>

			<TD NOWRAP WIDTH="77">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4"  then   %>
				<A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:deleteFriends();return false;"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="お連れ様情報を全て削除します"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>


			<TD NOWRAP WIDTH="77">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4"  then   %>
				<A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:saveFriends();return false;"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="指定されたお連れ様情報を保存します"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>	
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strAct <> "" Then
		Select Case strAct
		Case "saveend"
			'保存完了時は「保存完了」の通知
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		Case "deleteend"
			'削除完了時は「削除完了」の通知
			Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

		Case Else
			'さもなくばエラーメッセージを編集
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select

	End If
%>
	<BR>

<%
	For i=0 To lngDispCnt
		strHtml = ""
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_csldate"" VALUE=""" & strArrCslDate(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_seq""     VALUE=""" & strArrSeq(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_rsvno""   VALUE=""" & strArrRsvNo(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_perid""   VALUE=""" & strArrPerId(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_orgname"" VALUE=""" & strArrOrgSName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_csname""  VALUE=""" & strArrCsName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_name""    VALUE=""" & strArrName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_kname""   VALUE=""" & strArrKName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_rsvgrpname"" VALUE=""" & strArrRsvGrpName(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp1"" VALUE=""" & strArrSameGrp1(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp2"" VALUE=""" & strArrSameGrp2(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""f_samegrp3"" VALUE=""" & strArrSameGrp3(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""comporg"" VALUE=""" & strArrCompOrg(i) & """>"
		strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""compnew"" VALUE=""" & strArrCompNew(i) & """>"
		strHtml = strHtml & vbLf
		Response.Write strHTML
	Next
%>
	<!-- お連れ様リスト -->
	<SPAN ID="FriendsList">　</SPAN>

	<!-- 指定受診者数の表示 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD></TD>
			<TD NOWRAP>指定受診者を</TD>
			<TD>
				<SELECT NAME="dispCnt">
<%
				'行数選択リストの編集
				i = DEFAULT_ROW
				Do
					'現在の行数以上の行数を選択可能とする
					If i >= lngDispCnt Then
%>
						<OPTION VALUE="<%= i %>" <%= IIf(i = lngDispCnt, "SELECTED", "") %>><%= i %>人
<%
					End If

					'編集行数が表示行数を超えた場合は処理を終了する
					If i > lngDispCnt Then
						Exit Do
					End If

					i = i + INCREASE_COUNT
				Loop
%>
				</SELECT>
			</TD>
			<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示" BORDER="0"></A></TD>
		</TR>
	</TABLE>
<!-- ## 2003.11.26 Mod By T.Takagi@FSIT -->
<!--
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
-->
</FORM>
<!-- ## 2003.11.26 Mod End -->
</BODY>
</HTML>
