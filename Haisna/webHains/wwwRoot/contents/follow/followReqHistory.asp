<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォロー(依頼状) (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/follow_print.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'Const PRT_DIV  = 1      '様式分類：依頼状
Dim strMessage           'エラーメッセージ
Dim strArrMessage        'エラーメッセージ

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objFollow           'フォローアップアクセス用
Dim objReqHistory       '依頼状履歴アクセス用

'パラメータ
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '判定分類コード

Dim strItemCd           '検査条件検査項目
Dim vntItemCd           'フォロー対象検査項目コード
Dim vntItemName         'フォロー対象検査項目名称

Dim lngItemCount        'フォロー対象検査項目数
Dim lngHisCount         '戻り値

Dim vntRsvNo            '判定分類コード配列
Dim vntJudClassCd       '判定分類コード配列
Dim vntJudClassName     '検査分類名配列
Dim vntJudCd            '判定コード配列
Dim vntFileName         '依頼状名配列
Dim vntSeq              '依頼状番号配列
Dim vntAddDate          '印刷日配列
Dim vntAddUserName      '印刷者配列
Dim vntReqSendDate      '依頼状発送日配列
Dim vntReqSendUser      '依頼状発送者配列
Dim vntPrtDiv           '様式分類配列

Dim i                   'カウンタ
Dim Ret                 '戻り値

Dim lngPrtDiv           '印刷様式分類
Dim lngArrPrtDiv()      '印刷様式分類
Dim strArrPrtDivName()  '印刷様式分類名

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objFollow         = Server.CreateObject("HainsFollow.Follow")
Set objReqHistory     = Server.CreateObject("HainsRequestCard.RequestCard")

'パラメータ値の取得
lngRsvNo        = Request("rsvno")
lngPrtDiv       = Request("prtDiv")
strItemCd       = request("itemCd")

lngPrtDiv = IIf(lngPrtDiv = "", 0, lngPrtDiv)
'strItemCd = IIf(strItemCd = "", 999, strItemCd)

Call CreateOrderByInfo()

Do

    'フォロー対象検査項目（判定分類）を取得
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

        '依頼状履歴取得
        lngHisCount = objReqHistory.folReqHistory(lngRsvNo, _
                                                  lngPrtDiv, _
                                                  strItemCd, _
                                                  vntRsvNo, _
                                                  vntJudClassCd, _
                                                  vntJudClassName, _
                                                  vntJudCd, _
                                                  vntFileName, _
                                                  vntSeq, _
                                                  vntAddDate, _
                                                  vntAddUserName, _
                                                  vntReqSendDate, _
                                                  vntReqSendUser, _
                                                  vntPrtDiv _
                                                 )

    Exit Do

Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 並び替え名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByInfo()


    Redim Preserve lngArrPrtDiv(1)
    Redim Preserve strArrPrtDivName(1)

    lngArrPrtDiv(0) = 1:strArrPrtDivName(0) = "依頼"
    lngArrPrtDiv(1) = 2:strArrPrtDivName(1) = "勧奨"

End Sub


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>依頼状印刷履歴</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    function searchForm() {

        with ( document.entryPrt ) {
            submit();
        }
        return false;
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">依頼状印刷履歴</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '## 受診者個人情報表示
    Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="entryPrt" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="rsvno"            VALUE="<%= lngRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD align="left">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD WIDTH="60" HEIGHT="22">検査項目：</TD>
                        <TD WIDTH="120"><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD WIDTH="60">様式区分：</TD>
                        <TD WIDTH="120"><%= EditDropDownListFromArray("prtDiv", lngArrPrtDiv, strArrPrtDivName, lngPrtDiv, NON_SELECTED_ADD) %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD WIDTH="200">&nbsp;<A HREF="javascript:searchForm()"><IMG SRC="/webHains/images/b_prev.gif" ALT="表示" HEIGHT="28" WIDTH="53" BORDER="0"></A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <BR>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE WIDTH="600" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
        <TR>
            <TD>
                <SPAN STYLE="font-size:9pt;">
                <FONT COLOR="#ff6600">&nbsp;印刷履歴は&nbsp;<B><%= lngHisCount %></B>&nbsp;件です。</FONT>
                </SPAN>
            </TD>
        </TR>
    </TABLE>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="silver">
                        <TD NOWRAP WIDTH="90">検査項目名</TD>
                        <TD NOWRAP WIDTH="60">判定</TD>
                        <TD NOWRAP WIDTH="90">版数</TD>
                        <TD NOWRAP WIDTH="140">作成日</TD>
                        <TD NOWRAP WIDTH="120">作成者</TD>
                        <TD NOWRAP WIDTH="100">印刷ファイル名</TD>
                        <TD NOWRAP WIDTH="140">発送日</TD>
                        <TD NOWRAP WIDTH="120">発送者</TD>
                        <TD NOWRAP WIDTH="140">備考</TD>
                    </TR>
<%

        If lngHisCount > 0 Then

                For i = 0 To UBound(vntRsvNo)

%>
                    <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                        <TD NOWRAP><%= vntJudClassName(i)  %></TD>
                        <TD NOWRAP><%= vntJudCd(i)  %></TD>
                    <%
                        If vntPrtDiv(i) <> 0 Then
                            Select Case vntPrtDiv(i)
                                Case 1
                    %>
                                    <TD NOWRAP>依頼状&nbsp;_&nbsp;<%= vntSeq(i) %>版  </TD>
                    <%
                                Case 2
                    %>
                                    <TD NOWRAP>勧奨&nbsp;_&nbsp;<%= vntSeq(i) %>版  </TD>
                    <%
                            End Select
                        Else 
                    %>
                                    <TD NOWRAP>&nbsp;</TD>
                    <%
                        End If
                    %>
                        <TD NOWRAP><%= vntAddDate(i)       %></TD>
                        <TD NOWRAP><%= vntAddUserName(i)   %></TD>
                        <TD NOWRAP><A HREF="/webHains/contents/follow/prtPreview.asp?documentFileName=<%= vntFileName(i) %>" TARGET="_blank"><%= vntFileName(i) %></A></TD>
                        <TD NOWRAP><%= vntReqSendDate(i)   %></TD>
                        <TD NOWRAP><%= vntReqSendUser(i)   %></TD>
                    <%
                        If vntJudCd(i) = "" Then
                    %>
                            <TD NOWRAP>フォローアップ情報削除</TD>
                    <%
                        Else
                    %>
                            <TD NOWRAP>&nbsp;</TD>
                    <%
                        End If
                    %>

                    </TR>
<%
                Next
        End If
%>
                </TABLE>　　
            </TD>
        </TR>
    </TABLE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
