<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       基本情報＆個人検査情報更新  (Ver0.0.1)
'       AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const BASEINFO_GRPCD = "X039"        '基本情報　検査項目グループコード

Dim objCommon               '共通クラス
'Dim objInterview           '面接クラス
Dim objConsult              '受診クラス
Dim objOrganization         '団体情報アクセス用
Dim objPerResult            '個人検査結果情報アクセス用
'Dim objSentence            '文章アクセス用

'パラメータ
Dim strAction               '処理
Dim lngRsvNo                '予約番号

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
Dim strOrgCd1               '団体コード1
Dim strOrgCd2               '団体コード2
Dim strOrgName              '団体名称
Dim strOrgKName             '団体カナ名称

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

Dim vntEdtResult            '検査結果（変更後）

'保存用エリア
Dim vntUpdItemCd            '検査項目コード
Dim vntUpdSuffix            'サフィックス
Dim vntUpdResult            '検査結果
Dim vntUpdIspDate           '検査日
Dim vntUpdUpdDiv            '更新区分

'削除用エリア
Dim vntDelItemCd            '検査項目コード
Dim vntDelSuffix            'サフィックス

'対象検査項目コード、サフィックス
Dim strArrItemCd()
Dim strArrSuffix()

'コンボボックス固定値設定エリア
Dim strArrStcCd1()
Dim strArrShortStc1()
Dim strArrStcCd2()
Dim strArrShortStc2()
Dim strArrStcCd3()
Dim strArrShortStc3()
Dim strArrStcCd4()
Dim strArrShortStc4()
Dim strArrStcCd5()
Dim strArrShortStc5()
Dim strArrStcCd6()
Dim strArrShortStc6()
Dim strArrStcCd7()
Dim strArrShortStc7()
Dim strArrStcCd8()
Dim strArrShortStc8()
Dim strArrStcCd9()
Dim strArrShortStc9()
Dim strArrStcCd10()
Dim strArrShortStc10()
Dim strArrStcCd11()
Dim strArrShortStc11()
Dim strArrStcCd12()
Dim strArrShortStc12()
Dim strArrStcCd13()
Dim strArrShortStc13()
'### 2009/03/23 張 保健指導対象有無チェック項目追加 ###
Dim strArrStcCd14()
Dim strArrShortStc14()

Dim strArrStcCd                '文章コード
Dim strArrShortStc            '文章略称

Dim Ret                        '復帰値
Dim lngConsCount            '受診回数
Dim lngPerRslCount            '個人検査項目情報数
Dim lngStcCount                '文章数
Dim i, j                    'カウンター
Dim lngUpdCount                '登録データ件数
Dim lngDelCount                '削除データ件数

Dim strArrMessage            'エラーメッセージ
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
'Set objInterview = Server.CreateObject("HainsInterview.Interview")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
'Set objSentence = Server.CreateObject("HainsSentence.Sentence")

'引数値の取得
strAction            = Request("action")
lngRsvNo            = Request("rsvno")

vntItemCd            = ConvIStringToArray(Request("itemcd"))
vntSuffix            = ConvIStringToArray(Request("suffix"))
vntResult            = ConvIStringToArray(Request("orgresult"))
vntEdtResult        = ConvIStringToArray(Request("perrsl"))

Call SetDropDownList()

Do

    '受診情報検索
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate,    _
                                    strPerId,      _
                                    strCsCd,       _
                                    strCsName,     _
                                    strOrgCd1, _
                                    strOrgCd2, _
                                    strOrgName,     _
                                    , , _
                                    strAge,        _
                                    , , , , , , , , , , , , , , , _
                                    0, , , , , , , , , , , , , , , _
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


    '団体テーブルレコード読み込み
    Ret = objOrganization.SelectOrg_Lukes( strOrgCd1, strOrgCd2, , strOrgKName )
    If Ret = False Then
        Err.Raise 1000, , "団体情報が存在しません。（団体コード= " & strOrgCd1 & "-" & strOrgCd2 & " )"
    End If

    '保存
    If strAction = "save" Then
        strArrMessage = ""
        lngUpdCount = 0
        lngDelCount = 0
        For i = 0 To UBound(vntResult)
            '変更された？
            If ( vntResult(i) <> vntEdtResult(i) ) Then
                'nullに変更された？
                If vntEdtResult(i) = "" Then
                    If lngDelCount = 0 Then
                        vntDelItemCd = Array()
                        vntDelSuffix = Array()
                    End If
                    Redim Preserve vntDelItemCd(lngDelCount)
                    Redim Preserve vntDelSuffix(lngDelCount)
                    vntDelItemCd(lngDelCount)  = vntItemCd(i)
                    vntDelSuffix(lngDelCount)  = vntSuffix(i)
                    lngDelCount = lngDelCount + 1
                Else
                    If lngUpdCount = 0 Then
                        vntUpdItemCd = Array()
                        vntUpdSuffix = Array()
                        vntUpdResult = Array()
                        vntUpdIspDate = Array()
                        vntUpdUpdDiv = Array()
                    End If
                    Redim Preserve vntUpdItemCd(lngUpdCount)
                    Redim Preserve vntUpdSuffix(lngUpdCount)
                    Redim Preserve vntUpdResult(lngUpdCount)
                    Redim Preserve vntUpdIspDate(lngUpdCount)
                    Redim Preserve vntUpdUpdDiv(lngUpdCount)
                    vntUpdItemCd(lngUpdCount)  = vntItemCd(i)
                    vntUpdSuffix(lngUpdCount)  = vntSuffix(i)
                    vntUpdResult(lngUpdCount)  = vntEdtResult(i)
                    vntUpdIspDate(lngUpdCount) = now
                    vntUpdUpdDiv(lngUpdCount) = 0
                    lngUpdCount = lngUpdCount + 1
                End If
            End If 
        Next
        '変更項目あり？
        If lngUpdCount > 0 Then
            Ret = objPerResult.MergePerResult ( _
                                strPerId, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdIspDate, vntUpdUpdDiv )
            If Ret = False Then
                strArrMessage = "保存に失敗しました。"
            End If
        End If
        '削除項目あり？
        If lngDelCount > 0 Then
            Ret = objPerResult.DeletePerResult ( _
                                strPerId, vntDelItemCd, vntDelSuffix )
            If Ret = False Then
                strArrMessage = "保存に失敗しました。"
            End If
        End If
        
        If strArrMessage = "" Then
            strAction = "saveend"
        End If
    End If

    '個人検査結果情報取得
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
                                                        BASEINFO_GRPCD, _
                                                        0, 1, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & strPerId & " )"
    End If

    '保存用エリアに退避
    vntEdtResult = vntResult

    Exit Do
Loop

%>
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 各SELECTタグの配列名称セット
'
' 引数　　 : 
'
' 戻り値　 : 
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function SetDropDownList()

'### 2009/03/23 張 保健指導対象有無チェック項目追加の為修正 ###
'    Redim Preserve strArrItemCd(12)
'    Redim Preserve strArrSuffix(12)
    Redim Preserve strArrItemCd(13)
    Redim Preserve strArrSuffix(13)

    '臨床採血
    strArrItemCd(0) = "80013":strArrSuffix(0) = "00"
    '採血側指示
    strArrItemCd(1) = "80016":strArrSuffix(1) = "00"
    'ＥＤＴＡ
    strArrItemCd(2) = "80015":strArrSuffix(2) = "00"
    '感染症
    strArrItemCd(3) = "80017":strArrSuffix(3) = "00"
    '難聴
    strArrItemCd(4) = "80011":strArrSuffix(4) = "00"
    '視力
    strArrItemCd(5) = "80012":strArrSuffix(5) = "00"
    'ペースメーカ
    strArrItemCd(6) = "80010":strArrSuffix(6) = "00"
    '義足
    strArrItemCd(7) = "80018":strArrSuffix(7) = "00"
    '介護
    strArrItemCd(8) = "80021":strArrSuffix(8) = "00"
    'アルコール
    strArrItemCd(9) = "80014":strArrSuffix(9) = "00"
    '薬アレルギー
    strArrItemCd(10) = "80019":strArrSuffix(10) = "00"
    '胃腸手術
    strArrItemCd(11) = "80020":strArrSuffix(11) = "00"
    'ボランティア種別
    strArrItemCd(12) = "80022":strArrSuffix(12) = "00"
'### 2009/03/23 張 保健指導対象有無チェック項目追加 Start ###
    '保健指導
    strArrItemCd(13) = "80023":strArrSuffix(13) = "00"
'### 2009/03/23 張 保健指導対象有無チェック項目追加 End   ###

    '臨床採血
    Redim Preserve strArrStcCd1(2)
    Redim Preserve strArrShortStc1(2)
    strArrStcCd1(0) = "2":strArrShortStc1(0) = "臨床採血"
    strArrStcCd1(1) = "3":strArrShortStc1(1) = "採血困難"
    strArrStcCd1(2) = "4":strArrShortStc1(2) = "採血後気分不快"

    '採血側指示
    Redim Preserve strArrStcCd2(2)
    Redim Preserve strArrShortStc2(2)
    strArrStcCd2(0) = "2":strArrShortStc2(0) = "採血右腕"
    strArrStcCd2(1) = "3":strArrShortStc2(1) = "採血左腕"
    strArrStcCd2(2) = "4":strArrShortStc2(2) = "採血足"

    'ＥＤＴＡ
    Redim Preserve strArrStcCd3(1)
    Redim Preserve strArrShortStc3(1)
    strArrStcCd3(0) = "2":strArrShortStc3(0) = "ＥＤＴＡ凝集"
    strArrStcCd3(1) = "3":strArrShortStc3(1) = "ＥＤＴＡ凝集即提出"

    '感染症
'### 2016.07.18 張 ＨＩＶ追加の為修正 STR ################################
'    Redim Preserve strArrStcCd4(4)
'    Redim Preserve strArrShortStc4(4)
    Redim Preserve strArrStcCd4(5)
    Redim Preserve strArrShortStc4(5)
'### 2016.07.18 張 ＨＩＶ追加の為修正 END ################################
    strArrStcCd4(0) = "2":strArrShortStc4(0) = "不明"
    strArrStcCd4(1) = "3":strArrShortStc4(1) = "ＨＢｓ"
    strArrStcCd4(2) = "4":strArrShortStc4(2) = "ＨＣＶ"
    strArrStcCd4(3) = "5":strArrShortStc4(3) = "ＶＤＲＬ"
    strArrStcCd4(4) = "6":strArrShortStc4(4) = "ＴＰＨＡ"
'### 2016.07.18 張 ＨＩＶ追加 STR ########################################
    strArrStcCd4(5) = "7":strArrShortStc4(5) = "ＨＩＶ"
'### 2016.07.18 張 ＨＩＶ追加 END ########################################

    '難聴
    Redim Preserve strArrStcCd5(4)
    Redim Preserve strArrShortStc5(4)
    strArrStcCd5(0) = "2":strArrShortStc5(0) = "左"
    strArrStcCd5(1) = "3":strArrShortStc5(1) = "右"
    strArrStcCd5(2) = "4":strArrShortStc5(2) = "両方"
    strArrStcCd5(3) = "5":strArrShortStc5(3) = "ろうあ"
    strArrStcCd5(4) = "6":strArrShortStc5(4) = "補聴器"

    '視力
    Redim Preserve strArrStcCd6(7)
    Redim Preserve strArrShortStc6(7)
    strArrStcCd6(0) = "2":strArrShortStc6(0) = "失明左"
    strArrStcCd6(1) = "3":strArrShortStc6(1) = "失明右"
    strArrStcCd6(2) = "4":strArrShortStc6(2) = "両失明"
    strArrStcCd6(3) = "5":strArrShortStc6(3) = "弱視左"
    strArrStcCd6(4) = "6":strArrShortStc6(4) = "弱視右"
    strArrStcCd6(5) = "7":strArrShortStc6(5) = "弱視両方"
    strArrStcCd6(6) = "8":strArrShortStc6(6) = "義眼左"
    strArrStcCd6(7) = "9":strArrShortStc6(7) = "義眼右"

    'ペースメーカ
    Redim Preserve strArrStcCd7(0)
    Redim Preserve strArrShortStc7(0)
    strArrStcCd7(0) = "2":strArrShortStc7(0) = "あり"

    '義足
    Redim Preserve strArrStcCd8(1)
    Redim Preserve strArrShortStc8(1)
    strArrStcCd8(0) = "2":strArrShortStc8(0) = "義肢装着"
    strArrStcCd8(1) = "3":strArrShortStc8(1) = "装具装着"

    '介護
    Redim Preserve strArrStcCd9(1)
    Redim Preserve strArrShortStc9(1)
    strArrStcCd9(0) = "2":strArrShortStc9(0) = "要・いちご"
    strArrStcCd9(1) = "3":strArrShortStc9(1) = "車椅子"

    'アルコール
    Redim Preserve strArrStcCd10(0)
    Redim Preserve strArrShortStc10(0)
    strArrStcCd10(0) = "2":strArrShortStc10(0) = "あり"

    '薬アレルギー
    Redim Preserve strArrStcCd11(0)
    Redim Preserve strArrShortStc11(0)
    strArrStcCd11(0) = "2":strArrShortStc11(0) = "あり"

    '胃腸手術
    Redim Preserve strArrStcCd12(3)
    Redim Preserve strArrShortStc12(3)
    strArrStcCd12(0) = "2":strArrShortStc12(0) = "胃全摘"
    strArrStcCd12(1) = "3":strArrShortStc12(1) = "胃亜全摘"
    strArrStcCd12(2) = "4":strArrShortStc12(2) = "ストーマ"
    strArrStcCd12(3) = "5":strArrShortStc12(3) = "ＧＩ後気分不快"

    'ボランティア種別
    Redim Preserve strArrStcCd13(2)
    Redim Preserve strArrShortStc13(2)
    strArrStcCd13(0) = "2":strArrShortStc13(0) = "通訳要"
    strArrStcCd13(1) = "3":strArrShortStc13(1) = "介護用"
    strArrStcCd13(2) = "4":strArrShortStc13(2) = "通訳＆介護要"

'### 2009/03/23 張 保健指導対象有無チェック項目追加 Start ###
    '保健指導
    Redim Preserve strArrStcCd14(0)
    Redim Preserve strArrShortStc14(0)
    strArrStcCd14(0) = "2":strArrShortStc14(0) = "対象"
'### 2009/03/23 張 保健指導対象有無チェック項目追加 End   ###

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : コード・名称配列からのSELECTタグ生成（選択時イベント処理あり）
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strArrCode          コードの配列
' 　　　　   (In)     strArrName          名称の配列
' 　　　　   (In)     strSelectedCode     デフォルトの選択コード値
' 　　　　   (In)     strNonSelDelFlg     未選択用空リスト削除フラグ(1:削除)
' 　　　　   (In)     strStyle            SELECTタグのSTYLE指定
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDropDownListFromArray3(strName, strArrCode, strArrName, strSelectedCode, strNonSelDelFlg, strStyle)

    Dim strHTML     'HTML文字列
    Dim i           'インデックス
    Dim objCommon    '

    Set objCommon = CreateObject("HainsCommon.Common")

    'SELECTタグの開始
    strHTML = "<SELECT NAME=""" & strName & """ " & strStyle & ">"

    '未選択用の空リストを作成
    If strNonSelDelFlg = NON_SELECTED_ADD Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">&nbsp;"
    End If

    '「すべて」選択用のリストを作成
    If strNonSelDelFlg = SELECTED_ALL Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">すべて"
    End If

    '配列添字数分のリストを追加
    If Not IsEmpty(strArrCode) Then
        For i = 0 To UBound(strArrCode)
            strHTML = strHTML & "<OPTION VALUE=""" & strArrCode(i) & """" & IIf(CStr(strArrCode(i)) = CStr(strSelectedCode), " SELECTED", "") & ">" & strArrName(i)
        Next
    End If

    strHTML = strHTML & vbLf & "</SELECT>"

    EditDropDownListFromArray3 = strHTML

End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>基本情報</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function savePerRsl() {

    if ( !confirm('個人基本情報を登録します。よろしいですか？')){
        return;
    }

    document.baseInfo.action.value = "save";
    document.baseInfo.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<style type="text/css">
    body { margin: 0 0 0 3px; }
</style>
</HEAD>
<BODY>
<FORM NAME="baseInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">基本情報</FONT></B></TD>
        </TR>
    </TABLE>
    <!-- 基本情報の表示 -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" style="margin: 5px 0 0 0;">
        <TR>
            <TD VALIGN="top" NOWRAP>個人名</TD>
            <TD VALIGN="top">：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><%=strPerId%></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= strLastName %>　<%= strFirstName %>　<FONT COLOR="#999999">（<%= strLastKName %>　<%= strFirstKName %>）</FONT></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>生 <%= Int(strAge) %>歳 <%= IIf(strGender = "1", "男性", "女性") %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD VALIGN="top"  nowrap>団体名</TD>
            <TD VALIGN="top">：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><%= strOrgCd1 %>-<%= strOrgCd2 %></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= strOrgName %>　<FONT COLOR="#999999">（<%= strOrgKName %>）</FONT></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD nowrap>受診回数</TD>
            <TD VALIGN="top">：</TD>
            <TD><%= lngConsCount %></TD>
        </TR>
        <TR>
            <TD><IMG SRC="../../images/space.gif" ALT="" HEIGHT="5" WIDTH="1" BORDER="0"></TD>
        </TR>
        <TR>
            <TD NOWRAP colspan="3">
            <% '2005.08.22 権限管理 Add by 李　--- START %>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="JavaScript:savePerRsl()"><IMG SRC="../../images/save.gif" ALT="基本情報の登録を行います" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>
        </TR>
    </TABLE>

<%
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <!-- 個人検査情報 -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
<%
lngPerRslCount = IIf(lngPerRslCount=0, -1, lngPerRslCount)
For i=0 To lngPerRslCount-1
    lngStcCount = 0
    Select Case CStr(Trim(vntItemCd(i)) & Trim(vntSuffix(i)))
        Case CStr(Trim(strArrItemCd(0)) & Trim(strArrSuffix(0)))
            strArrStcCd    = strArrStcCd1
            strArrShortStc = strArrShortStc1
            lngStcCount = UBound(strArrStcCd1) + 1
        Case CStr(Trim(strArrItemCd(1)) & Trim(strArrSuffix(1)))
            strArrStcCd    = strArrStcCd2
            strArrShortStc = strArrShortStc2
            lngStcCount = UBound(strArrStcCd2) + 1
        Case CStr(Trim(strArrItemCd(2)) & Trim(strArrSuffix(2)))
            strArrStcCd    = strArrStcCd3
            strArrShortStc = strArrShortStc3
            lngStcCount = UBound(strArrStcCd3) + 1
        Case CStr(Trim(strArrItemCd(3)) & Trim(strArrSuffix(3)))
            strArrStcCd    = strArrStcCd4
            strArrShortStc = strArrShortStc4
            lngStcCount = UBound(strArrStcCd4) + 1
        Case CStr(Trim(strArrItemCd(4)) & Trim(strArrSuffix(4)))
            strArrStcCd    = strArrStcCd5
            strArrShortStc = strArrShortStc5
            lngStcCount = UBound(strArrStcCd5) + 1
        Case CStr(Trim(strArrItemCd(5)) & Trim(strArrSuffix(5)))
            strArrStcCd    = strArrStcCd6
            strArrShortStc = strArrShortStc6
            lngStcCount = UBound(strArrStcCd6) + 1
        Case CStr(Trim(strArrItemCd(6)) & Trim(strArrSuffix(6)))
            strArrStcCd    = strArrStcCd7
            strArrShortStc = strArrShortStc7
            lngStcCount = UBound(strArrStcCd7) + 1
        Case CStr(Trim(strArrItemCd(7)) & Trim(strArrSuffix(7)))
            strArrStcCd    = strArrStcCd8
            strArrShortStc = strArrShortStc8
            lngStcCount = UBound(strArrStcCd8) + 1
        Case CStr(Trim(strArrItemCd(8)) & Trim(strArrSuffix(8)))
            strArrStcCd    = strArrStcCd9
            strArrShortStc = strArrShortStc9
            lngStcCount = UBound(strArrStcCd9) + 1
        Case CStr(Trim(strArrItemCd(9)) & Trim(strArrSuffix(9)))
            strArrStcCd    = strArrStcCd10
            strArrShortStc = strArrShortStc10
            lngStcCount = UBound(strArrStcCd10) + 1
        Case CStr(Trim(strArrItemCd(10)) & Trim(strArrSuffix(10)))
            strArrStcCd    = strArrStcCd11
            strArrShortStc = strArrShortStc11
            lngStcCount = UBound(strArrStcCd11) + 1
        Case CStr(Trim(strArrItemCd(11)) & Trim(strArrSuffix(11)))
            strArrStcCd    = strArrStcCd12
            strArrShortStc = strArrShortStc12
            lngStcCount = UBound(strArrStcCd12) + 1
        Case CStr(Trim(strArrItemCd(12)) & Trim(strArrSuffix(12)))
            strArrStcCd    = strArrStcCd13
            strArrShortStc = strArrShortStc13
            lngStcCount = UBound(strArrStcCd13) + 1

        '### 2009/03/23 張 保健指導対象有無チェック項目追加 Start ###
        Case CStr(Trim(strArrItemCd(13)) & Trim(strArrSuffix(13)))
            strArrStcCd    = strArrStcCd14
            strArrShortStc = strArrShortStc14
            lngStcCount = UBound(strArrStcCd14) + 1
        '### 2009/03/23 張 保健指導対象有無チェック項目追加 End   ###

        Case Else
            Exit For
    End Select

%>
        <TR>
            <INPUT TYPE="hidden" NAME="itemcd" VALUE="<%= vntItemCd(i) %>">
            <INPUT TYPE="hidden" NAME="suffix" VALUE="<%= vntSuffix(i) %>">
            <INPUT TYPE="hidden" NAME="orgresult" VALUE="<%= vntResult(i) %>">
            <TD NOWRAP><%= vntItemName(i) %></TD>
            <TD WIDTH="12">：</TD>
<%
    If lngStcCount > 0 Then
%>
            <TD><%= EditDropDownListFromArray3("perrsl", strArrStcCd, strArrShortStc, vntEdtResult(i), NON_SELECTED_ADD, "STYLE=""width:130px""") %></TD>
<%
    End If
%>
        </TR>
<%
Next
%>
    </TABLE>
</FORM>
</BODY>
</HTML>
