<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       ＣＳＶファイルからの一括入金処理 (Ver0.0.1)
'       AUTHER  : 
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const TEMPFILE_PATH  = "/webHains/Temp/"    '処理結果付CSVファイルの書き出しパス
Const APPEND_KEYWORD = "(入金)"             'CSVファイル名をもとに処理結果付CSVファイル名を作成する際に追加する文字列

'COMオブジェクト
Dim objCommon           '共通クラス
Dim objCreateCsv        'ＣＳＶファイル作成用
Dim objImport           '個人情報取り込み用
Dim objParse            'POSTデータ解析用

'POSTされた情報
Dim strName             'エレメント名
Dim strFileName         'ファイル名
Dim strContentType      'content-type値
Dim strContent          'エレメント値

'引数値
Dim strCsvFileName      'CSVファイル名
Dim strStartPos         '読み込み開始位置
Dim strRslFileName      '結果付CSVファイル名
Dim strReadCount        '読み込みレコード数
Dim strWriteCount       '作成受診情報数

'契約情報
Dim strUpdUser          '更新者
Dim vntPostedData       'POSTデータ
Dim lngCnt              'POSTデータのサイズ
Dim strTempFileName     '一時ファイル名
Dim strOutFileName      '出力ファイル名
Dim strMessage          'エラーメッセージ
Dim strURL              'ジャンプ先のURL

Dim objExec             '取り込み処理実行用
Dim strCommand          'コマンドライン文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strStartPos     = Request.QueryString("startPos")
strRslFileName  = Request.QueryString("rslFileName")
strReadCount    = Request.QueryString("readCount")
strWriteCount   = Request.QueryString("writeCount")

'チェック・更新・読み込み処理の制御
Do

    '引数がQueryStringにて渡されている場合
    If strReadCount <> "" Then
        strMessage = "読み込みレコード数＝" & strReadCount & "、作成入金情報数＝" & strWriteCount
        Exit Do
    End If

    'データがPOSTされていなければ何もしない
    lngCnt = Request.TotalBytes
    If lngCnt <= 0 Then
        Exit Do
    End If

    'POSTデータの取得
    vntPostedData = Request.BinaryRead(lngCnt)

    Set objParse = Server.CreateObject("HainsPaymentAuto.Parse")

    '解析
    objParse.ParseMulti Request.ServerVariables("CONTENT_TYPE"), vntPostedData, strName, strFileName, strContentType, strContent

    Set objParse = Nothing

    '引数値の取得
    strCsvFileName = strFileName(0)
    strStartPos    = strContent(1)

    '入力チェック
    strMessage = CheckValue()
    If Not IsEmpty(strMessage) Then
        Exit Do
    End If

    Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

    'POSTデータから一時ファイルを作成
    strFileName = objCreateCsv.ConvertStreamToFile(strContent(0))

    Set objCreateCsv = Nothing

    '作成すべき出力ファイル名の定義

    'パス部を除去
    If InStrRev(strCsvFileName, "\") > 0 Then
        strOutFileName = Right(strCsvFileName, Len(strCsvFileName) - InStrRev(strCsvFileName, "\"))
    Else
        strOutFileName = strCsvFileName
    End If

    '拡張子の直前に文字列を追加
    If InStr(strOutFileName, ".") > 0 Then
        strOutFileName = Replace(strOutFileName, ".", APPEND_KEYWORD & ".", 1, 1)
    Else
        strOutFileName = strOutFileName & APPEND_KEYWORD
    End If

    Set objImport = Server.CreateObject("HainsPaymentAuto.PaymentImportCsv")

    '入金情報の作成
    objImport.ImportCsv strFileName, strUpdUser, CLng("0" & strStartPos), Server.MapPath(TEMPFILE_PATH), strOutFileName, strReadCount, strWriteCount

    Set objImport = Nothing

    Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

    '一時ファイルを削除
    objCreateCsv.DeleteFile strFileName

    Set objCreateCsv = Nothing

    '自画面をリダイレクト
    strURL = Request.ServerVariables("SCRIPT_NAME")
    strURL = strURL & "?startPos="    & strStartPos
    strURL = strURL & "&rslFileName=" & strOutFileName
    strURL = strURL & "&readCount="   & strReadCount
    strURL = strURL & "&writeCount="  & strWriteCount
    Response.Redirect strURL
    Response.End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim strMessage  'エラーメッセージの集合
    Dim i           'インデックス

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    'CSVファイルのチェック
    If strCsvFileName = "" Then
        objCommon.appendArray strMessage, "ＣＳＶファイルを指定して下さい。"
    End If

    '読み込み開始位置のチェック
    If strStartPos <> "" Then
        For i = 1 To Len(strStartPos)
            If InStr("0123456789", Mid(strStartPos, i, 1)) <= 0 Then
                objCommon.appendArray strMessage, "読み込み開始位置は０以上の数字で指定して下さい。"
                Exit For
            End If
        Next
    End If

    '戻り値の編集
    If IsArray(strMessage) Then
        CheckValue = strMessage
    End If

    Set objCommon = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＣＳＶファイルからの一括入金</TITLE>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ENCTYPE="multipart/form-data" ONSUBMIT="javascript:return confirm('この内容で一括入金処理を行います。よろしいですか？')">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">ＣＳＶファイルからの一括入金</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'メッセージの編集
    Do

        '件数未指定時は通常のメッセージ編集
        If strWriteCount = "" then
            EditMessage strMessage, MESSAGETYPE_WARNING
            Exit Do
        End If

        '受診情報の更新メッセージ
        If strWriteCount = "0" Then
            strMessage = strMessage & "<BR>入金情報は作成されませんでした。"
        Else
            strMessage = strMessage & "<BR>" & strWriteCount & "件の入金情報が作成されました。"
        End If

        EditMessage strMessage & "<BR>詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

        Exit Do
    Loop
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="130" NOWRAP>ＣＳＶファイル</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="file" NAME="csvFileName" SIZE="50"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="130" NOWRAP>読み込み開始位置</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="startPos" SIZE="3" VALUE="<%= strStartPos %>" STYLE="ime-mode:disabled"></TD>
        </TR>
    </TABLE>

<%
    If strRslFileName <> "" Then
%>
        <BR><A HREF="/webHains/contents/print/prtPreview.asp?documentFileName=<%= strRslFileName %>">取り込み結果付きＣＳＶデータをダウンロードする</A><BR>
<%
    End If
%>
    <BR><BR>

    <A HREF="dmdMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で入金処理する">
    <%  end if  %>
    <BR><BR>

    <A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGPAYCSV"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

    </BLOCKQUOTE>
</FORM>
</BODY>
</HTML>