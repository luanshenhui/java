<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      情報コメント（コメント一覧）  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const COMMENTLIST_SELINFO_CSL   = 1     '受診情報
Const COMMENTLIST_SELINFO_PER   = 2     '個人
Const COMMENTLIST_SELINFO_ORG   = 3     '団体
Const COMMENTLIST_SELINFO_CTR   = 4     '契約
Const COMMENTLIST_SELINFO_ALL   = 0     '個人＋受診

Const COMMENTLIST_HISTFLG_NOW   = 0     '今回
Const COMMENTLIST_HISTFLG_OLD   = 1     '過去
Const COMMENTLIST_HISTFLG_ALL   = 2     '全件


'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objConsult          '受診クラス
Dim objPubNote          'ノートクラス

'パラメータ
Dim lngRsvNo            '予約番号
Dim strPerId            '個人ID
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２
Dim strCtrPtCd          '契約パターンコード
Dim lngStrYear          '表示開始年
Dim lngStrMonth         '表示開始月
Dim lngStrDay           '表示開始日
Dim lngEndYear          '表示終了年
Dim lngEndMonth         '表示終了月
Dim lngEndDay           '表示終了日
Dim strPubNoteDivCd     'ノート分類
Dim strPubNoteDivCdCtr  'ノート分類(契約用)
Dim strPubNoteDivCdOrg  'ノート分類(団体用)
Dim lngDispKbn          '表示対象区分
Dim lngDispMode         '表示モード(0:個人＋今回受診＋過去受診, 1:個人・受診＋団体＋契約,
                        '           2:個人・受診, 3:個人, 4:団体, 5:契約)
Dim strType             '表示タイプ
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim lngIncDelNote       '1:削除データも表示
'### 2004/3/24 Added End

'ノート情報
Dim vntSeq              'seq
Dim vntPubNoteDivCd     '受診情報ノート分類コード
Dim vntPubNoteDivName   '受診情報ノート分類名称
Dim vntDefaultDispKbn   '表示対象区分初期値
Dim vntOnlyDispKbn      '表示対象区分しばり
Dim vntDispKbn          '表示対象区分
Dim vntUpdDate          '登録日時
Dim vntUpdUser          '登録者
Dim vntUserName         '登録者名
Dim vntBoldFlg          '太字区分
Dim vntPubNote          'ノート
Dim vntDispColor        '表示色
Dim vntSelInfo          '検索情報
Dim vntRsvNo            '予約番号
Dim vntCslDate          '受診日
Dim vntCsName           'コース名
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim vntDelFlg           '削除フラグ
'### 2004/3/24 Added End

Dim lngSelInfo          '検索情報（1:受診情報、2:個人、3:団体、4:契約、0:個人＋受診）
Dim lngHistFlg          '0:今回のみ、1:過去のみ、2:全件
Dim strStrDate          '表示期間(開始)
Dim strEndDate          '表示期間(終了)

Dim strUpdUser          '更新者

Dim lngCount            '取得件数
Dim Ret                 '復帰値
Dim i, j                'カウンター
Dim strTitle            'タイトル
Dim strMarkColor        'マーク表示色
Dim strArrDataName      'データ名称
Dim strHtml             'Html文字列
Dim strDispKbn          '表示対象区分

'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim strTRColor          '行毎のカラー
'### 2004/3/24 Added End

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objPubNote  = Server.CreateObject("HainsPubNote.PubNote")

'引数値の取得
lngRsvNo            = CLng("0" & Request("rsvno"))
strPerId            = Request("perid")
strOrgCd1           = Request("orgcd1")
strOrgCd2           = Request("orgcd2")
strCtrPtCd          = Request("ctrptcd")
lngStrYear          = CLng("0" & Request("StrYear"))
lngStrMonth         = CLng("0" & Request("StrMonth"))
lngStrDay           = CLng("0" & Request("StrDay"))
lngEndYear          = CLng("0" & Request("EndYear"))
lngEndMonth         = CLng("0" & Request("EndMonth"))
lngEndDay           = CLng("0" & Request("EndDay"))
strPubNoteDivCd     = Request("PubNoteDivCd")
strPubNoteDivCdCtr  = Request("PubNoteDivCdOrg")
strPubNoteDivCdOrg  = Request("PubNoteDivCdCtr")
lngDispKbn          = CLng("0" & Request("DispKbn"))
lngDispMode         = CLng("0" & Request("DispMode"))
strType             = Request("type")
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
lngIncDelNote       = Request("IncDelNote")
'### 2004/3/24 Added End

strUpdUser          = Session("USERID")

Do
    '表示タイプより表示する内容を決定
    Select Case strType
    Case "1"    '個人
        lngSelInfo = COMMENTLIST_SELINFO_PER
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "red"
        strTitle = "個人に対するコメント一覧"
        strArrDataName = Array( "コメント種類", _
                                "内容", _
                                "オペレータ名", _
                                "更新日時" )

    Case "2"    '今回受診情報
        lngSelInfo = COMMENTLIST_SELINFO_CSL
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "blue"
        strTitle = "今回受診情報に対するコメント一覧"
        strArrDataName = Array( "コメント種類", _
                                "内容", _
                                "オペレータ名", _
                                "更新日時" )

    Case "3"    '過去受診情報
        lngSelInfo = COMMENTLIST_SELINFO_CSL
        lngHistFlg = COMMENTLIST_HISTFLG_OLD
        strMarkColor = "yellow"
        strTitle = "過去受診情報に対するコメント一覧"
'### 2009.10.24 張 表示順序変更依頼によって修正 Start ###
'        strArrDataName = Array( "コメント種類", _
'                                "内容", _
'                                "受診日", _
'                                "コース", _
'                                "オペレータ名", _
'                                "更新日時" )
        strArrDataName = Array( "コメント種類", _
                                "受診日", _
                                "内容", _
                                "コース", _
                                "オペレータ名", _
                                "更新日時" )
'### 2009.10.24 張 表示順序変更依頼によって修正 End   ###

    Case "4"    '個人＋受診情報
        lngSelInfo = COMMENTLIST_SELINFO_ALL
        lngHistFlg = COMMENTLIST_HISTFLG_ALL
        strMarkColor = ""
        strTitle = ""
'### 2009.10.24 張 表示順序変更依頼によって修正 Start ###
'        strArrDataName = Array( "コメント種類", _
'                                "内容", _
'                                "受診日", _
'                                "対象コメント", _
'                                "オペレータ名", _
'                                "更新日時" )
        strArrDataName = Array( "コメント種類", _
                                "対象コメント", _
                                "受診日", _
                                "内容", _
                                "オペレータ名", _
                                "更新日時" )
'### 2009.10.24 張 表示順序変更依頼によって修正 End   ###

    Case "5"    '契約
        lngSelInfo = COMMENTLIST_SELINFO_CTR
'### 2004/4/24 Updated by Ishihata@FSIT 契約は団体コード指定の場合、有効範囲がきく
'       lngHistFlg = COMMENTLIST_HISTFLG_NOW
        lngHistFlg = COMMENTLIST_HISTFLG_ALL
'### 2004/4/24 Updated End
        strMarkColor = "magenta"
        strTitle = "契約に対するコメント一覧"
        strArrDataName = Array( "コメント種類", _
                                "内容", _
                                "オペレータ名", _
                                "更新日時" )
        '契約用のノート分類が指定されている
        If strPubNoteDivCdCtr <> "" Then
            strPubNoteDivCd = strPubNoteDivCdCtr
        End If

    Case "6"	'団体
        lngSelInfo = COMMENTLIST_SELINFO_ORG
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "cyan"
        strTitle = "団体に対するコメント一覧"
        strArrDataName = Array( "コメント種類", _
                                "内容", _
                                "オペレータ名", _
                                "更新日時" )
        '団体用のノート分類が指定されている
        If strPubNoteDivCdOrg <> "" Then
            strPubNoteDivCd = strPubNoteDivCdOrg
        End If

    Case Else
        Err.Raise 1000, , "表示タイプが不当（type= " & strType & " )"
    End Select

    If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
        strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
    Else
        strStrDate = ""
    End If
    If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
        strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
    Else
        strEndDate = ""
    End If

    'ノート情報の取得
    lngCount = objPubNote.SelectPubNote(lngSelInfo,           _
                                        lngHistFlg,          _
                                        strStrDate,          _
                                        strEndDate,          _
                                        lngRsvNo,            _
                                        strPerId,            _
                                        strOrgCd1,           _
                                        strOrgCd2,           _
                                        strCtrPtCd,          _
                                        0,                   _
                                        strPubNoteDivCd,     _
                                        lngDispKbn,          _
                                        strUpdUser,          _
                                        vntSeq,              _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntUpdUser,          _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor,        _
                                        vntSelInfo,          _
                                        vntRsvNo,            _
                                        vntCslDate,          _
                                        vntCsName,           _
                                        lngIncDelNote,       _
                                        vntDelFlg )

    If lngCount < 0 Then
        Err.Raise 1000, , "ノート情報が存在しません。"
    End If

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>コメント一覧</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCommentDetail;           // コメント情報詳細ウィンドウハンドル

// 修正
function calCommentDetail( index ) {
    var myForm = document.entryForm;
    var url;                    // URL文字列
    var opened = false;         // 画面がすでに開かれているか
    var selinfo;

    url = '/WebHains/contents/comment/commentDetail2.asp';
    url = url + '?rsvno='   + myForm.rsvno.value;
    url = url + '&perid='   + myForm.perid.value;
    url = url + '&orgcd1='  + myForm.orgcd1.value;
    url = url + '&orgcd2='  + myForm.orgcd2.value;
    url = url + '&ctrptcd=' + myForm.ctrptcd.value;
    if ( myForm.selInfo.length != null ) {
        selinfo = document.entryForm.selInfo[index].value;
    } else {
        selinfo = document.entryForm.selInfo.value;
    }
    switch( selinfo ) {
    case '1':
        url = url + '&cmtMode=1,0,0,0';
        break;
    case '2':
        url = url + '&cmtMode=0,1,0,0';
        break;
    case '3':
        url = url + '&cmtMode=0,0,1,0';
        break;
    case '4':
        url = url + '&cmtMode=0,0,0,1';
        break;
    }
    if ( myForm.seq.length != null ) {
        url = url + '&seq=' + document.entryForm.seq[index].value;
    } else {
        url = url + '&seq=' + document.entryForm.seq.value;
    }

    // すでにガイドが開かれているかチェック
    if ( winCommentDetail != null ) {
        if ( !winCommentDetail.closed ) {
            opened = true;
        }
    }

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winCommentDetail.focus();
        winCommentDetail.location.replace( url );
    } else {
        winCommentDetail = window.open( url, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
    }
}

// ウィンドウを閉じる
function windowClose() {

    // コメント情報詳細を閉じる
    if ( winCommentDetail != null ) {
        if ( !winCommentDetail.closed ) {
            winCommentDetail.close();
        }
    }

    winCommentDetail  = null;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 20px 0 0 <%= IIF(lngDispMode="2","20px","5px") %>; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="perid"   VALUE="<%= strPerId %>">
    <INPUT TYPE="hidden" NAME="orgcd1"  VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgcd2"  VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="ctrptcd" VALUE="<%= strCtrPtCd %>">

    <!-- タイトルの表示 -->
<%
    If strTitle <> "" Then
%>
    <TABLE WIDTH="600" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef"><FONT COLOR="<%= strMarkColor %>">■</FONT></SPAN><FONT COLOR="#000000"><%= strTitle %></FONT></B></TD>
        </TR>
    </TABLE>
<%
    End If
%>
    <!-- コメント一覧の表示 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR BGCOLOR="#cccccc">
<%
    strHtml = ""
    For j=0 To UBound(strArrDataName)
        Select Case strArrDataName(j)
        Case "コメント種類"
'### 2009.10.24 張 デフォルト表示サイズ変更 Start ###
'            strHtml = strHtml & "<TD NOWRAP WIDTH=""150"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"
'### 2009.10.24 張 デフォルト表示サイズ変更 End   ###

        Case "内容"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""360"">" & strArrDataName(j) & "</TD>"

        Case "オペレータ名"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""150"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"

        Case "更新日時"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""130"">" & strArrDataName(j) & "</TD>"

        Case "受診日"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""85"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""75"">" & strArrDataName(j) & "</TD>"

        Case "コース"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"

        Case "対象コメント"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""80"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""70"">" & strArrDataName(j) & "</TD>"

        End Select
    Next
    Response.Write strHTML
%>
        </TR>
<%
    For i = 0 To lngCount - 1

        '行毎の表示色変更
        If i mod 2 = 0 Then
            strTRColor = "#ffffff"
        Else
            strTRColor = "#eeeeee"
        End If

        '削除データの表示色変更
        If vntDelFlg(i) = "1" Then
            strTRColor = "#FFC0CB"
        End If

%>
        <TR VALIGN="top" BGCOLOR="<%= strTRColor %>">
<%
        strHtml = ""
        For j=0 To UBound(strArrDataName)
            Select Case strArrDataName(j)
            Case "コメント種類"
                strHtml = strHtml & "<TD NOWRAP>" & vntPubNoteDivName(i) & "</TD>"

            Case "内容"
                '表示対象区分をマークで表示
                Select Case vntDispKbn(i)
                Case "1"    '医療
                    strDispKbn = "<FONT COLOR=""#FF6666"">■</FONT>"
                Case "2"    '事務
                    strDispKbn = "<FONT COLOR=""#6666FF"">■</FONT>"
                Case "3"    '共通
                    strDispKbn = "<FONT COLOR=""#66FF66"">■</FONT>"
                End Select

'### 2009.10.24 張 内容の折り返し表示ができるように変更 Start ###
'                strHtml = strHtml & "<TD NOWRAP>" & strDispKbn & IIf(vntBoldFlg(i)=1, "<B>", "")
                strHtml = strHtml & "<TD>" & strDispKbn & IIf(vntBoldFlg(i)=1, "<B>", "")
'### 2009.10.24 張 内容の折り返し表示ができるように変更 End   ###
                If vntRsvNo(i) = "" Or vntRsvNo(i) = CStr(lngRsvNo) Then
                    strHtml = strHtml & "<A HREF=""JavaScript:calCommentDetail(" &  i & ")"">"
                    strHtml = strHtml & "<SPAN " & IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") & ">" & vntPubNote(i) & "</SPAN>"
                    strHtml = strHtml & "</A>"
                Else
                    '過去受診情報ノートは修正不可
                    strHtml = strHtml & "<SPAN " & IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") & ">" & vntPubNote(i) & "</SPAN>"
                End If
                strHtml = strHtml & IIf(vntBoldFlg(i)=1, "</B>", "") & "</TD>"

            Case "オペレータ名"
                strHtml = strHtml & "<TD NOWRAP>" & vntUserName(i) & "</TD>"

            Case "更新日時"
                strHtml = strHtml & "<TD NOWRAP>" & vntUpdDate(i) & "</TD>"

            Case "受診日"
                strHtml = strHtml & "<TD NOWRAP>" & vntCslDate(i) & "</TD>"

            Case "コース"
                strHtml = strHtml & "<TD NOWRAP>" & vntCsName(i) & "</TD>"

            Case "対象コメント"
                strHtml = strHtml & "<TD NOWRAP>" & IIf(vntRsvNo(i)="","個人","受診歴") & "</TD>"

            End Select
        Next
        Response.Write strHTML
%>
            <INPUT TYPE="hidden" NAME="selInfo" VALUE="<%= vntSelInfo(i) %>">
            <INPUT TYPE="hidden" NAME="seq" VALUE="<%= vntSeq(i) %>">
        </TR>
<%
    Next
%>
    </TABLE>
</FORM>
</BODY>
</HTML>
