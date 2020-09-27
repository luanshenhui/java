<% 
'-----------------------------------------------------------------------------
'       特定健診面接支援ヘッダ表示 (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Sub specialJudHeader(lngRsvNo)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const OPT_DSP = 4                       'オプション検査表示の折り返し個数
Const BASEINFO_GRPCD = "X039"           '身体情報　検査項目グループコード
Const IMGFILE_PATH = "../../images/"    'イメージファイルのPATH名
'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Const IMGFILE_SPECIAL = "physical10.gif"    '特定保健指導
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

Dim objCommon               '共通クラス
Dim objInterview            '面接クラス
Dim objperBill              '個人請求クラス
Dim objConsult              '受診クラス
Dim objPerResult            '個人検査結果情報アクセス用
Dim objFree                 '汎用情報アクセス用
'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Dim objSpecialInterview         '特定健診情報アクセス用
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

Dim lngOptCount             'オプション情報数
Dim lngConsCount            '受診回数
Dim lngHealthCount          '身体情報数
Dim Ret                     '復帰値
Dim i, j                    'カウンター
Dim lngCnt

'Dim lngRsvNo               '予約番号

'受診情報用変数
Dim strPerId                '個人ID
Dim strCslDate              '受診日
Dim strCsCd                 'コースコード
Dim strCsName               'コース名
Dim strLastName             '姓
Dim strFirstName            '名
Dim strLastKName            'カナ姓
Dim strFirstKName           'カナ名
Dim strBirth                '生年月日
Dim strAge                  '年齢
Dim strGender               '性別
Dim strGenderName           '性別名称
Dim strDayId                '当日ID
Dim strOrgName              '団体名称

'オプション検査情報
Dim strOptCd            'オプションコード
Dim strOptBranchNo      'オプション枝番
Dim strOptName          'オプション名称

'個人検査項目情報用変数
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntItemName         '検査項目名
Dim vntResult           '検査結果
Dim vntResultType       '結果タイプ
Dim vntItemType         '項目タイプ
Dim vntStcItemCd        '文章参照用項目コード
Dim vntStcCd            '文章コード
Dim vntShortStc         '文章略称
Dim vntIspDate          '検査日
Dim vntImageFileName    'イメージファイル名
Dim lngPerRslCount      '個人検査項目情報数

Dim strEraBirth         '生年月日(和暦)
Dim strRealAge          '実年齢

Dim strArrMessage       'エラーメッセージ

strArrMessage = ""

'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Dim lngSpCheck    '特定保健指導対象かチェック
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")
Set objInterview = Server.CreateObject("HainsInterview.Interview")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###


lngRsvNo     = Request("rsvno")

Do

    '受診情報検索
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate,    _
                                    strPerId,      _
                                    strCsCd,       _
                                    strCsName,     _
                                    , , _
                                    strOrgName,     _
                                    , , _
                                    strAge,        _
                                    , , , , , , , , , , , , _
                                    strDayId,   _
                                    , , 0, , , , , , , , , , , , , , , _
                                    strLastName,   _
                                    strFirstName,  _
                                    strLastKName,  _
                                    strFirstKName, _
                                    strBirth,      _
                                    strGender, _
                                    , , , , , , lngConsCount )

    '受診情報が存在しない場合はエラーとする
    If Ret = False Then
        Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If


    '生年月日(西暦＋和暦)の編集
    strEraBirth = objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d")

    '実年齢の計算
    If strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '小数点以下の切り捨て
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If

    'オプション検査名称読み込み
    lngOptCount = objInterview.SelectInteviewOptItem( lngRsvNo, strOptName )

    '### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
    '特定保険指導対象者チェック
    lngSpCheck = objSpecialInterview.CheckSpecialTarget(lngRsvNo)
    '### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

    '個人検査結果情報取得
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerID, _
                                                        BASEINFO_GRPCD, _
                                                        2, 0, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate, _
                                                        vntImageFileName _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & strPerID & " )"
    End If

    Exit Do
Loop

%>

<FORM NAME="headerForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" STYLE="margin: 0px;">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">面接支援</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="10"></TD>
        </TR>
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>

            <TD NOWRAP>受診日：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>　コース：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>　当日ＩＤ：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
            <TD NOWRAP>　団体：</TD>
            <TD NOWRAP><%= strOrgName %></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="80" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP>
<%
'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
            If lngSpCheck > 0 Then 
%>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="特定保健指導対象"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%
            End If
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###
%>
            </TD>
<%
            lngCnt = 0
            For i=0 To lngOptCount - 1
                lngCnt = i + 1
                If lngCnt > OPT_DSP Then
                    lngCnt = lngCnt - 1
                    Exit For
                End If
%>
                <TD NOWRAP><%= strOptName(i) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        For i=1 To (Int(Abs(lngOptCount/OPT_DSP) * -1 ) * -1) 
            If lngCnt > lngOptCount Then Exit For
%>
        <TR>
            <TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>
<%
            For j=0 To OPT_DSP - 1
                lngCnt = lngCnt + 1
                If lngCnt > lngOptCount Then Exit For
%>
                <TD NOWRAP><%= strOptName(lngCnt-1) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP><%= strPerId %></TD>
            <TD NOWRAP>　<B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>）</TD>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= strRealAge %>歳（<%= Int(strAge) %>歳）　<%= IIf(strGender = "1", "男性", "女性") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP>　　受診回数：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngConsCount %></B></FONT></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif"></TD>
            <TD NOWRAP ALIGN="RIGHT">　　身体情報：</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
                    <TR>
<%
    For i=0 To lngPerRslCount-1
        If vntImageFileName(i) <> "" Then
%>
                        <TD><IMG SRC="<%= IMGFILE_PATH & vntImageFileName(i) %>" ALT="<%= vntItemName(i) %>" HEIGHT="22" WIDTH="22" BORDER="0"></TD>
<%
        End If
    Next
%>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
<%
End Sub
%>
