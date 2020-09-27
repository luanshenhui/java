<%@ LANGUAGE="VBScript" %>
<%
'Program ID   : 
'Program Desc : ログアウト処理ごインターネットエクスプローラの「戻る」ボタンによって
'               ログアウト直前の画面に戻ることを防止するために作成
'Created Date : 2006.4.15
'Created By   : 張成斗
%>
<%
    Option Explicit
    'ページキャッシュは行わない
    Response.Expires = -1

    'セッション切断状態としてログイン画面を表示する
    Session.Abandon

%>
<form name="inputform" method="post" action="/webHains/login.asp"></form>
<script TYPE="text/javascript">
       document.inputform.submit();
</script>
