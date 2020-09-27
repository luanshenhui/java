<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       団体情報(成績表オプション印刷管理) (Ver0.0.1)
'       AUTHER  : 張
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objFree             '汎用情報アクセス用
Dim objOrganization     '団体情報アクセス用

Dim objConsult          '受診情報アクセス用
Dim objContract         '契約情報アクセス用

'引数値
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２
Dim strRptOptCd         'オプションコード
Dim strValues           '選択状態("1":選択、"0":未選択)

'検査項目情報
Dim strArrRptOptCd      'オプションコード(印刷選択）
Dim strArrRptOptName    'オプション名（印刷選択）
Dim strArrValues        '選択状態("1":選択、"0":未選択)（印刷選択）
Dim lngCount            'レコード数（印刷選択）
Dim strStmts

Dim strArrRptOptCd2     'オプションコード（削除選択）
Dim strArrRptOptName2   'オプション名（削除選択）
Dim strArrValues2       '選択状態("1":選択、"0":未選択)（削除選択）
Dim lngCount2           'レコード数（削除選択）


Dim strOrgName          '団体名
Dim strHTML             'HTML文字列
Dim i, j, k             'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strRptOptCd    = ConvIStringToArray(Request("rptOptCd"))
strValues      = ConvIStringToArray(Request("values"))

'保存ボタン押下時
If Not IsEmpty(Request("save.x")) Then

    'For i = 0 To UBound(strRptOptCd)
    '    response.Write "strRptOptCd : " & strRptOptCd(i) & vbLf
    'Next


    '成績書オプション管理テーブル更新
    '####### ロジック追加が必要
    objOrganization.UpdateRptOpt strOrgCd1, strOrgCd2, Session("USERID"), strRptOptCd, strValues

    'エラーがなければ自身を閉じる
    strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
    strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
    strHTML = strHTML & "</BODY>"
    strHTML = strHTML & "</HTML>"
    Response.Write strHTML
    Response.End

End If


'指定団体に対し、成績書オプション管理状況を取得(印刷オプション項目）
lngCount = objOrganization.SelectRptOpt(strOrgCd1, strOrgCd2, "RPTV%", strArrRptOptCd, strArrRptOptName, strArrValues)

'指定団体に対し、成績書オプション管理状況を取得(削除オプション項目）
lngCount2 = objOrganization.SelectRptOpt(strOrgCd1, strOrgCd2, "RPTD%", strArrRptOptCd2, strArrRptOptName2, strArrValues2)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>成績書オプション管理</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// チェック時の制御
function checkRptOptCd( index, checkBox ) {

    var objValues;    // 受診状態用エレメント

    // オプションが単数、複数の場合による制御
    if ( document.entryForm.rptOptCd.length == null ) {
        objValues = document.entryForm.values;
    } else {
        objValues = document.entryForm.values[ index ];
    }

    // 選択状態の編集
    objValues.value = checkBox.checked ? '1' : '0';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN>成績書オプション管理</B></TD>
        </TR>
    </TABLE>
<%
    '団体名を取得
    objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD HEIGHT="35" WIDTH="100%" NOWRAP>団体名：<FONT COLOR="#FF6600"><B><%= strOrgName %></B></FONT></TD>
<%
            'オプションコードが存在する場合のみ保存ボタンを用意する（必要性はない部分）
            If lngCount > 0 Then
%>
                <TD>
                <% '2005.08.22 権限管理 Add by 李　--- START %>
    			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                    <INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
                <%  else    %>
                     &nbsp;
                <%  end if  %>
                <% '2005.08.22 権限管理 Add by 李  ---- END %>
                </TD>
<%
            End If
%>
            <TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
        </TR>
    </TABLE>
    <FONT COLOR="#cc9999">●</FONT>成績書オプション印刷一覧を表示しています。<BR>
    <BR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR HEIGHT="2">
                <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
            </TR>
        </TABLE>
    <BR>
    <FONT COLOR="#cc9999">●</FONT>印刷するオプション項目に<INPUT TYPE="checkbox" CHECKED>チェックして下さい。<BR><BR>
<%
    Do
        '表示対象オプション項目が存在しない場合
        If lngCount <= 0 Then
%>
            この団体の印刷オプション項目は存在しません。
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR>
                <TD></TD>
                <TD WIDTH="50%"></TD>
                <TD></TD>
                <TD WIDTH="50%"></TD>
            </TR>
<%
            'オプション項目の編集
            i = 0
            Do
%>
            <TR>
<%
                '１行辺り２オプション目を編集
                For j = 1 To 2
%>
                    <TD><INPUT TYPE="hidden" NAME="rptOptCd" VALUE="<%= strArrRptOptCd(i) %>"><INPUT TYPE="hidden" NAME="values" VALUE="<%= strArrValues(i) %>"><INPUT TYPE="checkbox" ONCLICK="checkRptOptCd(<%= i %>,this)"<%= IIf(strArrValues(i) = "1", " CHECKED", "") %>></TD>
                    <TD NOWRAP><%= strArrRptOptName(i) %></TD>
<%
                    i = i + 1
                    If i >= lngCount Then
                    Exit For
                    End If

                Next

                If i >= lngCount Then
%>
                    </TR>
<%
                    Exit Do
                End If

            Loop
%>
        </TABLE>
<%
        Exit Do
    Loop
%>
    <BR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR HEIGHT="2">
                <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
            </TR>
        </TABLE>
    <BR>
    <FONT COLOR="#cc9999">●</FONT>印刷しないオプション項目に<INPUT TYPE="checkbox" CHECKED>チェックして下さい。<BR><BR>
<%
    Do
        '削除対象オプション項目が存在しない場合
        If lngCount2 <= 0 Then
%>
            この団体の印刷オプション項目は存在しません。
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR>
                <TD></TD>
                <TD WIDTH="50%"></TD>
                <TD></TD>
                <TD WIDTH="50%"></TD>
            </TR>
<%
            'オプション項目の編集
            k = i
            Do
%>
            <TR>
<%
                '１行辺り２オプション目を編集
                For j = 1 To 2
%>
                    <TD><INPUT TYPE="hidden" NAME="rptOptCd" VALUE="<%= strArrRptOptCd2(i-k) %>"><INPUT TYPE="hidden" NAME="values" VALUE="<%= strArrValues2(i-k) %>"><INPUT TYPE="checkbox" ONCLICK="checkRptOptCd(<%= i %>,this)"<%= IIf(strArrValues2(i-k) = "1", " CHECKED", "") %>></TD>
                    <TD NOWRAP><%= strArrRptOptName2(i-k) %></TD>
<%
                    i = i + 1
                    If i-k >= lngCount2 Then
                    Exit For
                    End If

                Next

                If i-k >= lngCount2 Then
%>
                    </TR>
<%
                    Exit Do
                End If

            Loop
%>
        </TABLE>
<%
        Exit Do
    Loop
%>

</FORM>
</BODY>
</HTML>
