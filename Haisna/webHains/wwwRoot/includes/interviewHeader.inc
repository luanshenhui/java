<% 
'-----------------------------------------------------------------------------
'        面接支援ヘッダ表示 (Ver0.0.1)
'        AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
'========================================
'管理番号：SL-SN-Y0101-305
'修正日  ：2011.07.01
'担当者  ：ORB)YAGUCHI
'修正内容：大腸３Ｄ－ＣＴ、頸動脈超音波、動脈硬化、内臓脂肪面積、心不全スクリーニングの追加
'========================================

Sub interviewHeader(lngRsvNo, lngReqWin)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const OPT_DSP = 4                        'オプション検査表示の折り返し個数
Const BASEINFO_GRPCD = "X039"            '身体情報　検査項目グループコード
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
Dim objSpecialInterview     '特定健診情報アクセス用
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

Dim lngOptCount             'オプション情報数
Dim lngConsCount            '受診回数
Dim lngHealthCount          '身体情報数
Dim Ret                     '復帰値
Dim i, j                    'カウンター
Dim lngCnt

'Dim lngRsvNo                '予約番号
Dim lngOtherWin             '別ウィンドウで開くチェック
Dim strSelectUrl            'URL

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
Dim strOptCd                'オプションコード
Dim strOptBranchNo          'オプション枝番
Dim strOptName              'オプション名称

'個人検査項目情報用変数
Dim vntItemCd               '検査項目コード
Dim vntSuffix               'サフィックス
Dim vntItemName             '検査項目名
Dim vntResult               '検査結果
Dim vntResultType           '結果タイプ
Dim vntItemType             '項目タイプ
Dim vntStcItemCd            '文章参照用項目コード
Dim vntStcCd                '文章コード
Dim vntShortStc             '文章略称
Dim vntIspDate              '検査日
Dim vntImageFileName        'イメージファイル名
Dim lngPerRslCount          '個人検査項目情報数

Dim strEraBirth             '生年月日(和暦)
Dim strRealAge              '実年齢

'ドロップダウンリスト編集用
Dim strArrSelectURL
Dim  strArrSelectName

strArrSelectUrl = Array()
strArrSelectName = Array()

'#### 2011.07.01 SL-SN-Y0101-305 MOD START ####
''## 2004.12.14 MOD STR FJTH)C.M 
''Const SEL_NUM = 31
'Const SEL_NUM = 27
''## 2004.12.14 MOD END
Const SEL_NUM = 32
'#### 2011.07.01 SL-SN-Y0101-305 MOD END ####

Redim Preserve strArrSelectURL(SEL_NUM)         'URL
Redim Preserve strArrSelectName(SEL_NUM)        '名称

Dim strURL                  'ジャンプ先のURL
Dim strArrMessage           'エラーメッセージ

strArrMessage = ""

'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Dim lngSpCheck              '特定保健指導対象かチェック
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objPerbill  = Server.CreateObject("HainsPerBill.PerBill")
Set objInterview= Server.CreateObject("HainsInterview.Interview")
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objPerResult= Server.CreateObject("HainsPerResult.PerResult")

'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###

lngRsvNo     = Request("rsvno")
lngOtherWin  = IIf(Request("otherwin") <> 1, 0, Request("otherwin") )
strSelectUrl = Request("selecturl")

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


    '-------------------------------------------------------------------------------
    ' ジャンプ先のURL編集
    '-------------------------------------------------------------------------------
    strArrSelectURL(0)  = "totalJudView.asp?grpno=0"                : strArrSelectName(0)  = "総合判定"
    strArrSelectURL(1)  = "MenResult.asp?grpno=1"                   : strArrSelectName(1)  = "診察・体格・血圧・肺機能"
    strArrSelectURL(2)  = "MenResult.asp?grpno=2"                   : strArrSelectName(2)  = "心電図"
    strArrSelectURL(3)  = "MenResult.asp?grpno=3"                   : strArrSelectName(3)  = "胸部Ｘ線"
    strArrSelectURL(4)  = "MenResult.asp?grpno=4"                   : strArrSelectName(4)  = "上部消化管Ｘ線内視鏡・大腸便潜血"
    strArrSelectURL(5)  = "MenResult.asp?grpno=5"                   : strArrSelectName(5)  = "上腹部超音波"
    strArrSelectURL(6)  = "MenResult.asp?grpno=6"                   : strArrSelectName(6)  = "血液"
    strArrSelectURL(7)  = "MenResult.asp?grpno=7"                   : strArrSelectName(7)  = "糖代謝・脂質代謝"
    strArrSelectURL(8)  = "MenResult.asp?grpno=8"                   : strArrSelectName(8)  = "尿酸・肝機能・腎機能"
    strArrSelectURL(9)  = "MenResult.asp?grpno=9"                   : strArrSelectName(9)  = "電解質・血清・尿検査・前立腺"
    strArrSelectURL(10) = "MenResult.asp?grpno=10"                  : strArrSelectName(10) = "視力・眼底・聴力・骨密度"
    strArrSelectURL(11) = "MenResult.asp?grpno=11"                  : strArrSelectName(11) = "乳房・婦人科"
    strArrSelectURL(12) = "MenResult.asp?grpno=12"                  : strArrSelectName(12) = "大腸内視鏡"
'#### 2017.02.15 張 CT肺気腫検査追加の為、仕様変更 STR ####
'    strArrSelectURL(13) = "MenResult.asp?grpno=13"                  : strArrSelectName(13) = "ヘリカルＣＴ／喀痰"
    strArrSelectURL(13) = "MenResult.asp?grpno=13"                  : strArrSelectName(13) = "ヘリカルＣＴ／喀痰／ＣＴ肺気腫"
'#### 2017.02.15 張 CT肺気腫検査追加の為、仕様変更 END ####

'#### 2013.01.08 SL-SN-Y0101-611 ADD START ####
    strArrSelectName(11) = "乳房・婦人科・婦人科超音波"
'#### 2013.01.08 SL-SN-Y0101-611 ADD END ####

'#### 2011.07.01 SL-SN-Y0101-305 MOD START ####
'    strArrSelectURL(14) = "MenKyoketsu.asp?grpno=14"                : strArrSelectName(14) = "虚血性心疾患指導表パターン"
'    strArrSelectURL(15) = "MenShittenBunpu.asp?grpno=15"            : strArrSelectName(15) = "失点分布"
'    strArrSelectURL(16) = "EntryRecogLevel.asp?grpno=16"            : strArrSelectName(16) = "認識レベル～生活指導"
'    strArrSelectURL(17) = "MenEiyoShido.asp?grpno=17"                : strArrSelectName(17) = "栄養指導"
'    strArrSelectURL(18) = "Shokusyukan.asp?grpno=18"                : strArrSelectName(18) = "食習慣問診"
'    strArrSelectURL(19) = "CUSelectItemsMain.asp?grpno=19"            : strArrSelectName(19) = "ＣＵ経年変化"
'    strArrSelectURL(20) = "rslUpdateHistory.asp?grpno=20"            : strArrSelectName(20) = "変更履歴"
'    strArrSelectURL(21) = "DiseaseHistory.asp?grpno=21"                : strArrSelectName(21) = "病歴情報"

'    strURL = "../comment/commentMainFlame.asp?grpno=22"
'    strURL = strURL & "&PubNoteDivCd=500&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
'    strURL = strURL & "&strYear=" & Year(strCslDate) & "&strMonth=" & Month(strCslDate) & "&strDay=" & Day(strCslDate)
'    strURL = strURL & "&endYear=" & Year(strCslDate) & "&endMonth=" & Month(strCslDate) & "&endDay=" & Day(strCslDate)
'    strArrSelectURL(22) = strURL                                    : strArrSelectName(22) = "チャート情報"

'    strURL = "../comment/commentMainFlame.asp?grpno=22"
'    strURL = strURL & "&PubNoteDivCd=100&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
'    strURL = strURL & "&strYear=" & Year(strCslDate) & "&strMonth=" & Month(strCslDate) & "&strDay=" & Day(strCslDate)
'    strURL = strURL & "&endYear=" & Year(strCslDate) & "&endMonth=" & Month(strCslDate) & "&endDay=" & Day(strCslDate)
'    strArrSelectURL(23) = strURL                                    : strArrSelectName(23) = "注意事項"

'    strArrSelectURL(24) = "MonshinNyuryoku.asp?grpno=24"            : strArrSelectName(24) = "問診"
'    strArrSelectURL(25) = "IkensaTain.asp?grpno=25"                    : strArrSelectName(25) = "胃検査、他院での指摘"
''## 2004.12.14 MOD STR FJTH)C.M 
''    strArrSelectURL(26) = "MenResult.asp?grpno=14"                    : strArrSelectName(26) = "▲後日検査"
''    strArrSelectURL(27) = "MenAnatanokeikou.asp?grpno=27"              : strArrSelectName(27) = "多項目検査からみたあなたの傾向"
''    strArrSelectURL(28) = "no.asp"                                    : strArrSelectName(28) = "▲受診歴一覧"
''    strArrSelectURL(29) = "no.asp"                                    : strArrSelectName(29) = "▲二次検診照会"
''    strArrSelectURL(30) = "no.asp"                                    : strArrSelectName(30) = "▲リファー照会"
'    strArrSelectURL(26) = "MenAnatanokeikou.asp?grpno=27"              : strArrSelectName(26) = "多項目検査からみたあなたの傾向"
''## 2004.12.14 MOD END 
''## 2004.11.01 MOD STR ORB)T.YAGUCHI フォロー画面表示
''    strArrSelectURL(31) = "no.asp"                                    : strArrSelectName(31) = "▲フォローアップ照会"
'    strURL = "../followUp/followupTop.asp?grpno=31"
'    strURL = strURL & "&PubNoteDivCd=100&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
''## 2004.12.14 MOD STR FJTH)C.M 
''    strArrSelectURL(31) = strURL                                    : strArrSelectName(31) = "フォローアップ照会"
'    strArrSelectURL(27) = strURL                                    : strArrSelectName(27) = "フォローアップ照会"
''## 2004.12.14 MOD END 
''## 2004.11.01 MOD END
    strArrSelectURL(14) = "MenResult.asp?grpno=15"                  : strArrSelectName(14) = "大腸３Ｄ－ＣＴ"
    strArrSelectURL(15) = "MenResult.asp?grpno=18"                  : strArrSelectName(15) = "内臓脂肪面積"
    strArrSelectURL(16) = "MenResult.asp?grpno=19"                  : strArrSelectName(16) = "心不全スクリーニング"
    strArrSelectURL(17) = "MenResult.asp?grpno=16"                  : strArrSelectName(17) = "頸動脈超音波"
    strArrSelectURL(18) = "MenResult.asp?grpno=17"                  : strArrSelectName(18) = "動脈硬化"

    strArrSelectURL(19) = "MenKyoketsu.asp?grpno=14"                : strArrSelectName(19) = "虚血性心疾患指導表パターン"
    strArrSelectURL(20) = "MenShittenBunpu.asp?grpno=15"            : strArrSelectName(20) = "失点分布"
    strArrSelectURL(21) = "EntryRecogLevel.asp?grpno=16"            : strArrSelectName(21) = "認識レベル～生活指導"
    strArrSelectURL(22) = "MenEiyoShido.asp?grpno=17"               : strArrSelectName(22) = "栄養指導"
    strArrSelectURL(23) = "Shokusyukan.asp?grpno=18"                : strArrSelectName(23) = "食習慣問診"
    strArrSelectURL(24) = "CUSelectItemsMain.asp?grpno=19"          : strArrSelectName(24) = "ＣＵ経年変化"
    strArrSelectURL(25) = "rslUpdateHistory.asp?grpno=20"           : strArrSelectName(25) = "変更履歴"
    strArrSelectURL(26) = "DiseaseHistory.asp?grpno=21"             : strArrSelectName(26) = "病歴情報"

    strURL = "../comment/commentMainFlame.asp?grpno=22"
    strURL = strURL & "&PubNoteDivCd=500&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
    strURL = strURL & "&strYear=" & Year(strCslDate) & "&strMonth=" & Month(strCslDate) & "&strDay=" & Day(strCslDate)
    strURL = strURL & "&endYear=" & Year(strCslDate) & "&endMonth=" & Month(strCslDate) & "&endDay=" & Day(strCslDate)
    strArrSelectURL(27) = strURL                                    : strArrSelectName(27) = "チャート情報"

    strURL = "../comment/commentMainFlame.asp?grpno=22"
    strURL = strURL & "&PubNoteDivCd=100&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
    strURL = strURL & "&strYear=" & Year(strCslDate) & "&strMonth=" & Month(strCslDate) & "&strDay=" & Day(strCslDate)
    strURL = strURL & "&endYear=" & Year(strCslDate) & "&endMonth=" & Month(strCslDate) & "&endDay=" & Day(strCslDate)
    strArrSelectURL(28) = strURL                                    : strArrSelectName(28) = "注意事項"

    strArrSelectURL(29) = "MonshinNyuryoku.asp?grpno=24"            : strArrSelectName(29) = "問診"
    strArrSelectURL(30) = "IkensaTain.asp?grpno=25"                 : strArrSelectName(30) = "胃検査、他院での指摘"
'## 2004.12.14 MOD STR FJTH)C.M 
'    strArrSelectURL(26) = "MenResult.asp?grpno=14"                  : strArrSelectName(26) = "▲後日検査"
'    strArrSelectURL(27) = "MenAnatanokeikou.asp?grpno=27"           : strArrSelectName(27) = "多項目検査からみたあなたの傾向"
'    strArrSelectURL(28) = "no.asp"                                  : strArrSelectName(28) = "▲受診歴一覧"
'    strArrSelectURL(29) = "no.asp"                                  : strArrSelectName(29) = "▲二次検診照会"
'    strArrSelectURL(30) = "no.asp"                                  : strArrSelectName(30) = "▲リファー照会"
    strArrSelectURL(31) = "MenAnatanokeikou.asp?grpno=27"           : strArrSelectName(31) = "多項目検査からみたあなたの傾向"
'## 2004.12.14 MOD END 
'## 2004.11.01 MOD STR ORB)T.YAGUCHI フォロー画面表示
'    strArrSelectURL(31) = "no.asp"                                  : strArrSelectName(31) = "▲フォローアップ照会"
    strURL = "../followUp/followupTop.asp?grpno=31"
    strURL = strURL & "&PubNoteDivCd=100&DispKbn=1&DispMode=2&cmtMode=1,1,0,0"
'## 2004.12.14 MOD STR FJTH)C.M 
'    strArrSelectURL(31) = strURL                                    : strArrSelectName(31) = "フォローアップ照会"
    strArrSelectURL(32) = strURL                                    : strArrSelectName(32) = "フォローアップ照会"
'## 2004.12.14 MOD END 
'## 2004.11.01 MOD END

'#### 2011.07.01 SL-SN-Y0101-305 MOD END ####

    '-------------------------------------------------------------------------------

'## 2012.09.11 Add by T.Takagi@RD 切替日付以降の場合、栄養指導をメニューから除去
    If Not IsVer201210(lngRsvNo) Then
        Exit Do
    End If

    For i = 23 To SEL_NUM
        strArrSelectURL(i - 1)  = strArrSelectURL(i)
        strArrSelectName(i - 1) = strArrSelectName(i)
    Next

    Redim Preserve strArrSelectURL(SEL_NUM - 1)
    Redim Preserve strArrSelectName(SEL_NUM - 1)
'## 2012.09.11 Add End

    Exit Do
Loop
%>
<SCRIPT TYPE="text/javascript">
<!--
function movePage() {
    var myForm = document.headerForm;
    var    url;
    var    mainurl;
    var winmode;

    if ( myForm.selecturl.value == '' ) {
        return;
    }

    winmode = (myForm.otherwin.checked ? '1' : '0');
    myForm.otherwin.value = (myForm.otherwin.checked ? '1' : '0');
    if ( myForm.otherwin.value != 1 ){
        url = 'interviewTop.asp';
        url = url + '?rsvno=' + '<%= lngRsvNo %>';
        url = url + '&index=' + myForm.selecturl.selectedIndex;
        url = url + '&urlname='
        mainurl = myForm.selecturl.value;
        mainurl = mainurl + '&rsvno=' + '<%= lngRsvNo %>';
        mainurl = mainurl + '&cscd=' + '<%= strCsCd %>';
        mainurl = mainurl + '&winmode=' + winmode;

        url = url + escape(mainurl);
        top.location.href = url;
    } else {
        url = myForm.selecturl.value;
        url = url + '&rsvno=' + '<%= lngRsvNo %>';
        url = url + '&cscd=' + '<%= strCsCd %>';
        url = url + '&winmode=' + winmode;
        open( url, '', 'width=950,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

//-->
</SCRIPT>
<FORM NAME="headerForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" STYLE="margin: 0px;">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="<%= IIf(lngReqWin<>0,"100%","910") %>">
        <TR>
<%            
            If lngReqWin <> 0 Then 
%>
                <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%            
            End If
%>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">面接支援</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
<%            
            If lngReqWin <> 0 Then 
%>
                <TD><IMG SRC="../../images/spacer.gif" WIDTH="5" HEIGHT="1" ALT=""></TD>
                <TD><A HREF="/webHains/contents/interview/interviewTop.asp?rsvno=<%= lngRsvNo %>" TARGET="_top"><IMG SRC="../../images/today.gif" WIDTH="21" HEIGHT="21" ALT="総合判定画面へ"></A></TD>
                <TD><IMG SRC="../../images/spacer.gif" WIDTH="5" HEIGHT="1" ALT=""></TD>
                <TD NOWRAP><%= EditDropDownListFromArray("selecturl", strArrSelectURL, strArrSelectName, strSelectUrl, NON_SELECTED_DEL) %></TD>
                <TD NOWRAP>を<INPUT TYPE="CHECKBOX" NAME="otherwin" VALUE="1" <%= IIf( lngOtherWin = "1", "CHECKED", "") %>>別ウインドウで</TD>
                <TD><A HREF="javascript:movePage()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
<%            
            End If
%>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
<%            
            If lngReqWin <> 0 Then 
%>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%            
            End If
%>
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
            If lngSpCheck > 0 Then 
%>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="特定保健指導対象"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%
            End If
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
<%            
            If lngReqWin <> 0 Then 
%>
            <TD></TD>
<%            
            End If
%>
            <TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>
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
<%
            If lngReqWin <> 0 Then 
%>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
            End If
%>
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
