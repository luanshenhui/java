<%@ LANGUAGE="VBScript" %>
<%
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkAgent.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strUserId		'ユーザID
Dim strPassWord		'パスワード
Dim strTarget		'ターゲット先のURL
Dim strMessage		'メッセージ

Dim objLogin 		'ユーザーＩＤ、パスワードチェック用ＣＯＭオブジェクト

'ユーザーＩＤ、パスワードチェック
Dim lngErrNo		'戻り値
Dim strUserName		'利用者漢字氏名
Dim lngAuthTblMnt	'テーブルメンテナンス権限
Dim lngAuthRsv		'予約業務権限
Dim lngAuthRsl		'結果入力業務権限
Dim lngAuthJud		'判定入力業務権限
Dim lngAuthPrn		'印刷、データ抽出業務権限
Dim lngAuthDmd		'請求業務権限
Dim lngIgnoreFlg	'予約枠無視フラグ
Dim strElementName	'エレメント名

'2005.07.27 ADD By 李 
Dim objAuthority
Dim lngDeptCd           '
Dim lngUsrGrpCd         '
Dim strPwdInfo          '
Dim bolAlert
'2005.07.27 ADD End  

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'ページキャッシュは行わない
Response.Expires = -1

'引数値の取得
strUserId   = Trim(Request.Form("userId"))
strPassWord = Request.Form("password")
strTarget   = Request("target")

'フォーカスを移すエレメント名の初期設定
strElementName = "userId"

'## 2005.08.06 Add by 李
bolAlert = False
'## 2005.08.06 Add End


Do

	'ユーザIDが存在しない場合は何もしない
	If strUserId = "" Then
        strMessage = "ユーザＩＤとパスワードを入力して下さい。"
		Exit Do
	End If

	'オブジェクトのインスタンス作成
	Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

	'ユーザＩＤ、パスワードチェック
'	lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , lngIgnoreFlg)


'## 2005.07.26 Edit by 李  ####
	lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , lngIgnoreFlg, , lngDeptCd, lngUsrGrpCd)
'## 2005.07.26 Edit End.   ####

    Select Case lngErrNo
		Case 0

		'#### 2005.08.04 ADD By 李 ：パスワードの有効期間をチェックする。################# 
			'If Session("USERID")  = "" then
				'オブジェクトのインスタンス作成
				Set objAuthority = Server.CreateObject("HainsAuthority.CheckAuthority")
				lngErrNo = objAuthority.CheckPwdDate(strUserId, strMessage)

				Select Case lngErrNo
					Case 0

					Case 1			'【Alert】使用可能期間確認 
                        			Session("EXPDATE")    = strMessage                
                    			Case 2
					'パスワードの有効期間が満了
						Exit Do
				End Select
			'End If
		'#### 2005.08.04 ADD End   ####################################################


		Case 1
			strMessage = "入力されたユーザＩＤは存在しません。"
			Exit Do

		Case 2
            strMessage = "パスワードが正しくありません。"

			'パスワード不正時のみパスワードにフォーカスを移させるための処理
			strElementName = "password"
			Exit Do

		Case 3
            strMessage = "webHainsを使用する権限がありません。管理者に連絡してください。"
			Exit Do

		Case 9
            strMessage = "ユーザＩＤとパスワードを入力して下さい。"
			Exit Do
	End Select


	'Session変数にユーザ情報を格納する
	Session("USERID")      = UCase(strUserId)
	Session("USERNAME")    = strUserName
	Session("AUTH_TBLMNT") = lngAuthTblMnt
	Session("AUTH_RSV")    = lngAuthRsv
	Session("AUTH_RSL")    = lngAuthRsl
	Session("AUTH_JUD")    = lngAuthJud
	Session("AUTH_PRN")    = lngAuthPrn
	Session("AUTH_DMD")    = lngAuthDmd
	Session("IGNORE")      = lngIgnoreFlg
'2005.07.27 ADD By 李 
	Session("DEPTCD")      = lngDeptCd
	Session("USRGRPCD")    = lngUsrGrpCd
'2005.07.27 ADD End 

	'ターゲット先の編集
	If strTarget = "" Then
		strTarget = Application("STARTPAGE")
	End If

	'ターゲット先のページへ
	Response.Redirect strTarget

	Exit Do
Loop


'セッション切断状態としてログイン画面を表示する
Session.Abandon


%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css?v=20151114">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>webH@ins - ログイン</TITLE>
<style TYPE="text/css">
input.texttype {
	ime-mode: disabled;
	width: 80px;
	height: 20px;
}
input.loginbutton {
	width: 100px;
	height: 20px;
}
</style>

<SCRIPT TYPE="text/javascript" language="javascript">
<!-- 
    function pwdClear(){
        document.idandpass.password.value = "";
        return;
    }

    /** Enterキーにより、次の欄にカーソル移動 **/
    function handleEnter (field, event) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
                var i;
                for (i = 0; i < field.form.elements.length; i++)
                        if (field == field.form.elements[i])
                                break;
                i = (i + 1) % field.form.elements.length;
                field.form.elements[i].focus();
                return false;
        }
        else
        return true;
    }

    function submitEnter (field, event) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
            with(document.idandpass){
                if(password.value.length == 0){
                    alert("ユーザＩＤとパスワードを入力して下さい。");
                    return;
                /** 2006.06.17 張 パスワードは６桁以上入力しないとログインできないように変更 **/
                //} else if(password.value.length < 4){
                } else if(password.value.length < 6){
                    alert("パスワードは６桁以上入力してください。\n６桁以上のパスワードに変更し、もう一度ログインしてください。");
                    return;
                }
                submit();
            }
        }
        else
        return;
    }

    function submitCheck(){
        with(document.idandpass){
            if(password.value.length == 0){
                alert("ユーザＩＤとパスワードを入力して下さい。");
                return;
            /** 2006.06.17 張 パスワードは６桁以上入力しないとログインできないように変更 **/
            //} else if(password.value.length < 4){
            //    alert("パスワードは４桁以上入力してください。");
            } else if(password.value.length < 6){
                alert("パスワードは６桁以上入力してください。\n６桁以上のパスワードに変更し、もう一度ログインしてください。");
                return;
            }
            submit();
        }
    }

//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.idandpass.<%= strElementName %>.focus()">
<FORM NAME="idandpass" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<DIV ALIGN="center">
<BR><BR><BR>
<IMG SRC="/webHains/images/login.gif" ALT="ログイン">
<BR><BR><%= strMessage %>
<BR><BR>

<TABLE>
	<TR>
		<TD ALIGN="right">ユーザＩＤ：</TD>
		<TD><INPUT TYPE="text" SIZE="10" MAXLENGTH="20" NAME="userId" VALUE="<%= strUserId %>" onBlur="pwdClear();" onkeypress="return handleEnter(this, event)" class="texttype"></TD>
	</TR>
	<TR>
		<TD ALIGN="right">パスワード：</TD>
		<TD><INPUT TYPE="password" SIZE="10" MAXLENGTH="64" NAME="password" onFocus="pwdClear();" onkeypress="submitEnter(this, event);" class="texttype"></TD>
	</TR>
</TABLE>
<BR>
<!--INPUT TYPE="submit" VALUE="ログイン"-->
<INPUT TYPE="button" VALUE="ログイン" onClick="javascript:submitCheck()" class="loginbutton">
<BR><BR><BR><BR>
<A HREF="/webHains/ChangePassword.asp">パスワードを変更する</A>
<BR><BR><BR>
<IMG WIDTH="170" HEIGHT="45" SRC="/webHains/images/logobig.gif" ALT="webHains"><BR><BR>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
