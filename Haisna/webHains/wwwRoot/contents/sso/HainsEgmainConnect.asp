<%@ LANGUAGE="VBScript" %>
<%
'########################################
'管理番号：SL-UI-Y0101-002
'作成日  ：2010.06.04
'担当者  ：FJTH)KOMURO
'作成内容：シングル患者選択機能を新規作成
'########################################

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%

'パラメータ
Dim strFuncCode		'機能番号
Dim strCslDate		'受診日(yyyymmdd)
Dim strUserId		'利用者ID
Dim strPerId		'患者ID
Dim strOrderNo		'オーダー番号
Dim strStatusCode	'入外コード
Dim strMedicalCode	'診療科コード

'引数値の取得
strFuncCode		= "" & Request("funccode")
strCslDate		= "" & Request("csldate")
strUserId		= "" & IIf(Request("userid") = "", Session("USERID"), Request("userid"))
strPerId		= "" & Request("perid")
strOrderNo		= "" & Request("orderno")
strStatusCode	= "" & Request("statuscode")
strMedicalCode	= "" & Request("medicalcode")

'患者IDの編集（ゼロプディングで10桁に編集）
If strPerId <> "" And Len(strPerId) < 10 Then
	strPerId = Right("0000000000" & strPerId, 10)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>連携システム起動</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<script type="text/javascript">
<!--
// 正常処理中メッセージ生成処理
function createRegularMsg()
{
	var strMsg = '';
	strMsg += '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD HEIGHT="5"></TD>';
	strMsg += '  </TR>';
	strMsg += '  <TR>';
	strMsg += '    <TD VALIGN="BOTTOM">';
	strMsg += '      <SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">';
	strMsg += '起動中です・・・';
	strMsg += '      </SPAN>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';

	return strMsg;
}

// エラーメッセージ生成処理
function createErrMsg(pstrCode)
{
	var strMsg = '';

	strMsg += '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD HEIGHT="5"></TD>';
	strMsg += '  </TR>';
	strMsg += '  <TR>';
	strMsg += '    <TD>';
	strMsg += '      <IMG SRC="/webHains/images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="">';
	strMsg += '    </TD>';
	strMsg += '    <TD VALIGN="BOTTOM">';
	strMsg += '      <SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">';
	strMsg += convertErrMsg(pstrCode);
	strMsg += '      </SPAN>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';
	strMsg += '<BR>';
	strMsg += '<TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">';
	strMsg += '  <TR>';
	strMsg += '    <TD>';
	strMsg += '      <A HREF="javascript:close()"><IMG SRC="../../images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る" border="0"></A>';
	strMsg += '    </TD>';
	strMsg += '  </TR>';
	strMsg += '</TABLE>';
	strMsg += '<BR>';

	return strMsg;
}

// エラーコードのメッセージ変換
function convertErrMsg(pstrCode)
{
	var strMsg = "";

	switch ( pstrCode ) {
	
		case "10":
			strMsg += "電子チャートシステムに接続できません。";
			strMsg += "<BR>";
			strMsg += "システム管理者へご連絡ください。";
			break;

		case "11":
			strMsg += "電子チャートシステムが起動されていません。";
			strMsg += "<BR>";
			strMsg += "ブラウザを全て閉じ、電子チャートシステムを起動した後に再度実行してください。";
			break;

		case "12":
			strMsg += "電子チャートシステムにログインされていません。";
			strMsg += "<BR>";
			strMsg += "電子チャートシステムにログインした後、再度実行してください。";
			break;

		case "13":
			strMsg += "電子チャートシステムに利用者が登録されていません。";
			strMsg += "<BR>";
			strMsg += "システム管理者へご連絡ください。";
			break;

		case "14":
			strMsg += "ログインしている利用者に権限が不足しています。";
			strMsg += "<BR>";
			strMsg += "システム管理者へご連絡ください。";
			break;

		case "15":
			strMsg += "ログインしている利用者が違います。";
			strMsg += "<BR>";
			strMsg += "電子チャートシステムにログインしている利用者で実行してください。";
			break;

		case "16":
			strMsg += "参照している患者チャート情報が制限数を超えています。";
			strMsg += "<BR>";
			strMsg += "参照中の患者チャート情報を閉じてください。";
			break;

		case "29":
			strMsg += "予期せぬエラーが発生しました。";
			strMsg += "<BR>";
			strMsg += "システム管理者へご連絡ください。";
			break;

		case "30":
			strMsg += "電子チャートシステムに患者IDが登録されていません。";
			strMsg += "<BR>";
			strMsg += "医事システムから、必要な患者情報を登録してください。";
			break;

		case "50":
			strMsg += "レポート情報が存在しません。";
			strMsg += "<BR>";
			strMsg += "電子チャートシステムのレポート情報を確認してください。";
			break;

		default:
			strMsg += "予期せぬエラーが発生しました。";
			strMsg += "<BR>";
			strMsg += "システム管理者へご連絡ください。";
			strMsg += "<BR>";
			strMsg += "ErrCode : " + pstrCode;
			break;

	}

	return strMsg;
}
-->
</script>
<!-- 連携用ActiveX -->
<OBJECT ID="HainsEgmainConnect"
	CLASSID="CLSID:55E321EC-E8BE-4389-BBF0-49B0ED821B46"
	     codebase="/webHains/cab/SSo/HainsEgmainConnect.CAB#version=1,0,0,0">
</OBJECT>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">連携システム起動</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<script type="text/javascript">
	<!--
			var strCode;

			// 電子チャート連携ActiveXを呼出
			strCode = HainsEgmainConnect.HainsEgmainCall("<%= strFuncCode %>", "<%= strCslDate %>", "<%= strUserId %>", "<%= strPerId %>", "<%= strOrderNo %>", "<%= strStatusCode %>", "<%= strMedicalCode %>");

			// リターンコードを判断
			if (  strCode == '00' ) {
				// 正常終了の場合、正常メッセージを表示
				document.write(createRegularMsg());
			} else {
				//異常終了の場合、エラーメッセージを表示
				document.write(createErrMsg(strCode));
			}
	-->
	</script>
</FORM>
<script type="text/javascript">
<!--
// リターンコードを判断
if ( strCode == "00" ) {
	// 正常終了の場合、自動的にウィンドウを閉じる
	window.opener = 0;
	window.open('', '_self');
	window.close();
}
-->
</script>
</BODY>
</HTML>
