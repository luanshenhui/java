<%@ LANGUAGE="VBScript" %>
<%
'========================================
'管理番号：SL-HS-Y0101-003
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：連携先サーバ名の変換
'========================================

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkAgent.inc" -->
<!-- #### 2010.07.16 SL-HS-Y0101-003 ADD START   #### -->
<!-- #include virtual = "/webHains/includes/convertAddress.inc" -->
<!-- #### 2010.07.16 SL-HS-Y0101-003 ADD END     #### -->
<%
'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strUserId           'ユーザID
Dim strPassWord         '旧パスワード
Dim strNewPassWord      '新パスワード
Dim strTarget           'ターゲット先のURL
Dim strMessage          'メッセージ
Dim objLogin            'ユーザーＩＤ、パスワードチェック用ＣＯＭオブジェクト
'#### 2005.09.09 追加 張 ######################################################
Dim strSysKind          'ログイン画面表示の為、基のシステム区分を取得

'ユーザーＩＤ、パスワードチェック
Dim lngErrNo            '戻り値
Dim lngRet              '戻り値
Dim strUserName         '利用者漢字氏名
Dim lngAuthTblMnt       'テーブルメンテナンス権限
Dim lngAuthRsv          '予約業務権限
Dim lngAuthRsl          '結果入力業務権限
Dim lngAuthJud          '判定入力業務権限
Dim lngAuthPrn          '印刷、データ抽出業務権限
Dim lngAuthDmd          '請求業務権限
Dim blnComplete         'TRUE:パスワード変更正常終了

Dim strElementName      'エレメント名

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'ページキャッシュは行わない
Response.Expires = -1

'引数値の取得
strUserId           = Request.Form("userId")
strPassWord         = Request.Form("oldPassword")
strNewPassWord      = Request.Form("newPassword")
strTarget           = Request("target")
strSysKind          = Request("sysKind")

'フォーカスを移すエレメント名の初期設定
strElementName      = "userId"

blnComplete         = False
Do
    'ユーザIDが存在しない場合は何もしない
    If strUserId = "" Then
        strMessage  = "ユーザＩＤとパスワードを入力して下さい。"
        Exit Do
    End If

    'パスワードチェック
    If strPassWord = "" Then
        strMessage      = "パスワードを空白指定することはできません。"
        strElementName  = "oldPassword"
        Exit Do
    End If

    If strNewPassWord = "" Then
        strMessage      = "パスワードを空白指定することはできません。"
        strElementName  = "newPassword"
        Exit Do
    End If

    'オブジェクトのインスタンス作成
    Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

    'ユーザＩＤ、パスワードチェック
    lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd)
    Select Case lngErrNo
        Case 0
        Case 1
            strMessage = "入力されたユーザＩＤは存在しません。"
            Exit Do
        Case 2
            strMessage = "パスワードが正しくありません。"

            'パスワード不正時のみパスワードにフォーカスを移させるための処理
            strElementName = "oldPassword"

            Exit Do
        Case 3
            strMessage = "webHainsを使用する権限がありません。管理者に連絡してください。"
            Exit Do
        Case 9
            strMessage = "ユーザＩＤとパスワードを入力して下さい。"
            Exit Do
    End Select

    'ユーザＩＤ、パスワードチェック
    lngRet = objLogin.RegistHainsUser("PWD", strUserId, strUserName, strNewPassWord)
    If lngRet <> INSERT_NORMAL Then
        strMessage = "入力されたユーザＩＤは存在しません。"
        Exit Do
    End If

    strMessage = "パスワードは正常に更新されました。"
    blnComplete = True

    Exit Do
Loop

'セッション切断状態としてログイン画面を表示する
Session.Abandon
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
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
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
<%
    If blnComplete = False Then
%>
function CheckNewPassWord() {

    var myForm      = document.idandpass;    // 自画面のフォームエレメント
    var strAlpha    = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var strNumber   = '1234567890';
    var strChk      = '';
    var cntAlp      = '';
    var cntNum      = 77;

    if ( myForm.userId.value == '' ) {
        alert ('ユーザ名を入力してください。');
        myForm.userId.focus();
        return false;
    }

    if ( myForm.oldPassword.value == '' ) {
        alert ('現在のパスワードを入力してください。');
        myForm.oldPassword.focus();
        return false;
    }

    if ( myForm.newPassword.value == '' ) {
        alert ('新しいパスワードを入力してください。');
        myForm.newPassword.focus();
        return false;
    }

    if ( myForm.newPassword2.value == '' ) {
        alert ('新しいパスワードは２回入力してください。');
        myForm.newPassword2.focus();
        return false;
    }

    if ( myForm.newPassword.value != myForm.newPassword2.value ) {
        alert ('入力された２つの新しいパスワードが異なっています。');
        return false;
    }
    /************************************************************************************/
    /** 2006.06.17 張 パスワードは６桁以上入力しないとログインできないように変更 Start **/
    /************************************************************************************
    if ( myForm.newPassword.value.length < 4 ) {
        alert ('パスワードは 4けた以上に指定しなければならないです。');
        myForm.newPassword.focus();
        return false;
    }
    *******************************************************************************/

    /************************************************************************************/
    /** 2014.06.30 張 パスワードは６桁→英字と数字を含む８文字以上に変更 Start         **/
    /************************************************************************************
    if ( myForm.newPassword.value.length < 6 ) {
        alert ('パスワードは ６けた以上に指定しなければならないです。');
        myForm.newPassword.focus();
        return false;
    }
    *******************************************************************************/

    cntAlpha    = 0;
    cntNum      = 0;

    if ( myForm.newPassword.value.length < 8 ) {

        alert ('パスワードは 英字と数字を含む８文字以上に設定してください。');
        myForm.newPassword.focus();
        return false;

    } else {

        strChk = '';
        for (ki=0; ki < myForm.newPassword.value.length; ki++) {
            strChk = myForm.newPassword.value.charAt(ki);

            if (strAlpha.indexOf(strChk) != -1){
                cntAlpha = 1;
            }
            
            if(strNumber.indexOf(strChk) != -1){
                cntNum = 1;
            }
        }

        if (cntAlpha + cntNum < 2){
            alert ('パスワードは 英字と数字を含む８文字以上に設定してください。');
            myForm.newPassword.focus();
            return false;
        }
    }
    /** 2014.06.30 張 パスワードは６桁→英字と数字を含む８文字以上に変更 End           **/
    /************************************************************************************/

    /** 2006.06.17 張 パスワードは６桁以上入力しないとログインできないように変更 End   **/
    /************************************************************************************/


    /** 2005.09.09 追加 張 :*******************************************************/
    if ( myForm.oldPassword.value == myForm.newPassword.value ) {
        alert ('新しいパスワードが現在パスワードと同じです。新しいパスワードを入力してください。');
        myForm.newPassword.focus();
        return false;
    }

    myForm.submit();
    return false;
}
<%
    End If
%>
-->
</SCRIPT>
</HEAD>
<%
    If blnComplete = True Then
%>
<BODY>
<%
    Else
%>
<BODY ONLOAD="JavaScript:document.idandpass.<%= strElementName %>.focus()">
<%
    End If
%>

<FORM NAME="idandpass" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<INPUT TYPE="hidden" NAME="sysKind" VALUE="<%= strSysKind %>">
<DIV ALIGN="center">
<BR><BR><BR>
<BR><BR><%= strMessage %>
<BR><BR>
<%
    '#### 2005.09.09 追加 張 ######################################################
    If blnComplete = True Then
        If strSysKind = "GUIDE" Then
%>
<!-- #### 2010.07.16 SL-HS-Y0101-003 MOD START #### -->
<%'    <A HREF="http://157.104.16.195/login.jsp">ログイン画面へ</A> %>
    <A HREF="http://<%= convertAddress("Guide") %>/login.jsp">ログイン画面へ</A>
<!-- #### 2010.07.16 SL-HS-Y0101-003 MOD END     #### -->
<%
        Else
%>
    <A HREF="/webHains/login.asp">ログイン画面へ</A>
<%
        End if
    Else
%>
<TABLE>
    <TR>
        <TD ALIGN="right">ユーザＩＤ：</TD>
        <TD><INPUT TYPE="text" SIZE="12" MAXLENGTH="20" NAME="userId" VALUE="<%= strUserId %>" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">今のパスワード：</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="oldPassword" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD HEIGHT="20"></TD>
    </TR>

    <TR>
        <TD COLSPAN="3" ALIGN="center">※ 新しいパスワードは<FONT COLOR="#ff6600"><B>英字と数字を含む８文字以上</B></FONT>で設定してください。</TD>
    </TR>

    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">新しいパスワード：</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="newPassword" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">新しいパスワード：</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="newPassword2" CLASS="texttype"></TD>
        <TD><FONT COLOR="#999999">確認のため、もう一度</FONT></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>


    <TR>
        <TD></TD>
        <TD><INPUT TYPE="button" ONCLICK="JavaScript:return CheckNewPassWord()" VALUE="変更する">
        </TD>
    </TR>
</TABLE>
<%
    End If
%>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
