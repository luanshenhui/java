<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       web予約情報登録(申し込み情報) (Ver1.0.0)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.2.27
'担当者  ：T.Takagi@RD
'修正内容：国籍欄を追加
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
<!-- #include virtual = "/webHains/includes/convertWebOption.inc" -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const RSVDIV_NORMAL = "1"        '申し込み区分(一般)
Const RSVDIV_ORG    = "2"        '申し込み区分(契約団体(健康保険組合または会社等))
Const RSVDIV_BURDEN = "3"        '申し込み区分(健康保険組合連合会)

Const SUPPORTDIV_INSURANT = "1"    '本人家族区分(一般(被保険者))
Const SUPPORTDIV_FAMILY   = "2"    '本人家族区分(家族(被扶養者))

'#### 2011/01/20 ADD STA TCS)Y.T ####
Const VOLUNTEER_NOT   = "0"     'ボランティア区分(利用なし)
Const VOLUNTEER_ITPT  = "1"     'ボランティア区分(通訳要)
Const VOLUNTEER_CARE  = "2"     'ボランティア区分(介護要)
Const VOLUNTEER_BOTH  = "3"     'ボランティア区分(通訳＆介護要)
Const VOLUNTEER_CHAIR = "4"     'ボランティア区分(車椅子要)
'#### 2011/01/20 ADD END TCS)Y.T ####

Const STOMAC_XRAY   = "1"        '胃検査オプション(胃X線)
Const STOMAC_CAMERA = "2"        '胃検査オプション(胃内視鏡)

'#### 2011/01/20 ADD STA TCS)Y.T ####
Const CHEST_XRAY   = "1"        '胸部検査(胸部X線)
Const CHEST_CT     = "2"        '胸部検査(胸部CT)
'#### 2011/01/20 ADD END TCS)Y.T ####

Const BREAST_XRAY      = "1"    '乳房検査オプション(乳房X線)
Const BREAST_ECHO      = "2"    '乳房検査オプション(乳房超音波)
Const BREAST_XRAY_ECHO = "3"    '乳房検査オプション(乳房X線＋乳房超音波)

'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objWebRsv               'web予約情報アクセス用

'引数値
Dim dtmCslDate              '受診年月日
Dim lngWebNo                'webNo.

Dim strPerId                '個人ID
Dim strFullName             '姓名
Dim strKanaName             'カナ姓名
Dim strLastName             '(個人情報の)姓
Dim strFirstName            '(個人情報の)名
Dim strLastKName            '(個人情報の)カナ姓
Dim strFirstKName           '(個人情報の)カナ名
Dim strGender               '性別
Dim strBirth                '生年月日
Dim strZipNo                '郵便番号
Dim strAddress1             '住所1
Dim strAddress2             '住所2
Dim strAddress3             '住所3
Dim strTel                  '電話番号
Dim strEMail                'e-mail
Dim strOfficeName           '勤務先名称
Dim strOfficeTel            '勤務先電話番号
Dim strOrgName              '契約団体名
Dim strRsvDiv               '申し込み区分(1:一般、2:契約団体(健康保険組合または会社等)、3:健康保険組合連合会)
Dim strSupportDiv           '本人家族区分(1:本人(被保険者)、2:家族(被扶養者))
Dim strOptionStomac         '胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
Dim strOptionBreast         '乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
'#### 2011/01/20 ADD STA TCS)Y.T ####
Dim strOptionCT             '胸部検査(1:胸部X線、2:胸部CT)
'#### 2011/01/20 ADD END TCS)Y.T ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions           '受診オプション
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'#### 2017.03.20 張 WEB申し込み番号追加 STR ###
Dim strWebReqNo             '申し込み番号
'#### 2017.03.20 張 WEB申し込み番号追加 END ###

Dim strMessage              'メッセージ
Dim strInsDate              '申し込み年月日
Dim strUpdDate              '予約処理年月日
'#### 2011/01/20 ADD STA TCS)Y.T ####
Dim strIsrSign              '保険書記号
Dim strIsrNo                '保険書番号
Dim strVolunteer            'ボランティア区分(0:利用なし、1:通訳要、2:介護要、3:通訳＆介護要、4:車椅子要)
Dim strCardOutEng           '確認はがき英文出力(0:なし、1:あり)
Dim strFormOutEng           '一式英文出力(0:なし、1:あり)
Dim strReportOutEng         '成績書英文出力(0:なし、1:あり)
'#### 2011/01/20 ADD END TCS)Y.T ####

'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
Dim strNation               '国籍
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####

Dim strEditPerId            '編集用の個人ID
Dim strEditFullName         '編集用の姓名
Dim strEditKanaName         '編集用のカナ姓名
Dim strZipNo1               '郵便番号1
Dim strZipNo2               '郵便番号2
Dim strEditZipNo            '編集用の郵便番号
Dim strEditRsvDiv           '編集用の申し込み区分
Dim strEditSupportDiv       '編集用の本人家族区分
Dim strEditStomac           '編集用の胃検査オプション
Dim strEditBreast           '編集用の乳房検査オプション
'#### 2011/01/20 MOD STA TCS)Y.T ####
Dim strEditChest            '編集用の胸部検査
'#### 2011/01/20 MOD END TCS)Y.T ####

'#### 2011/01/20 MOD STA TCS)Y.T ####
Dim strEditVolunteer        '編集用のボランティア区分
Dim strEditCardOutEng       '編集用の確認はがき英文出力区分
Dim strEditFormOutEng       '編集用の一式書式英文出力区分
Dim strEditReportOutEng     '編集用の成績書英文出力区分
'#### 2011/01/20 MOD END TCS)Y.T ####

Dim Ret                     '関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
dtmCslDate = CDate(Request("cslDate"))
lngWebNo   = CLng("0" & Request("webNo"))

'オブジェクトのインスタンス作成
Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

'web予約情報読み込み
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
''#### 2011/01/20 MOD STA TCS)Y.T ####
'
''Ret = objWebRsv.SelectWebRsv( _
''          dtmCslDate,         _
''          lngWebNo, , , ,     _
''          strPerId,           _
''          strFullName,        _
''          strKanaName,        _
''          strLastName,        _
''          strFirstName,       _
''          strLastKName,       _
''          strFirstKName,      _
''          strGender,          _
''          strBirth,           _
''          strZipNo,           _
''          strAddress1,        _
''          strAddress2,        _
''          strAddress3,        _
''          strTel,             _
''          strEMail,           _
''          strOfficeName,      _
''          strOfficeTel,       _
''          strOrgName,         _
''          strRsvDiv,          _
''          strSupportDiv,      _
''          strOptionStomac,    _
''          strOptionBreast,    _
''          strMessage,         _
''          strInsDate          _
''      )
'
'Ret = objWebRsv.SelectWebRsv( _
'          dtmCslDate,         _
'          lngWebNo,           _
'          ,                   _
'          ,                   _
'          ,                   _
'          strPerId,           _
'          strFullName,        _
'          strKanaName,        _
'          strLastName,        _
'          strFirstName,       _
'          strLastKName,       _
'          strFirstKName,      _
'          strGender,          _
'          strBirth,           _
'          strZipNo,           _
'          strAddress1,        _
'          strAddress2,        _
'          strAddress3,        _
'          strTel,             _
'          strEMail,           _
'          strOfficeName,      _
'          strOfficeTel,       _
'          strOrgName,         _
'          strRsvDiv,          _
'          strSupportDiv,      _
'          strOptionStomac,    _
'          strOptionBreast,    _
'          strMessage,         _
'          strInsDate,         _
'          ,                   _
'          ,                   _
'          strIsrSign,         _
'          strIsrNo,           _
'          strVolunteer,       _
'          strCardOutEng,      _
'          strFormOutEng,      _
'          strReportOutEng,    _
'          strOptionCT         _
'      )
''#### 2011/01/20 MOD END TCS)Y.T ####
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
'Ret = objWebRsv.SelectWebRsv( _
'          dtmCslDate,         _
'          lngWebNo,           _
'          ,                   _
'          ,                   _
'          ,                   _
'          strPerId,           _
'          strFullName,        _
'          strKanaName,        _
'          strLastName,        _
'          strFirstName,       _
'          strLastKName,       _
'          strFirstKName,      _
'          strGender,          _
'          strBirth,           _
'          strZipNo,           _
'          strAddress1,        _
'          strAddress2,        _
'          strAddress3,        _
'          strTel,             _
'          strEMail,           _
'          strOfficeName,      _
'          strOfficeTel,       _
'          strOrgName,         _
'          strRsvDiv,          _
'          strSupportDiv,      _
'          strOptionStomac,    _
'          strOptionBreast,    _
'          strMessage,         _
'          strInsDate,         _
'          ,                   _
'          ,                   _
'          strIsrSign,         _
'          strIsrNo,           _
'          strVolunteer,       _
'          strCardOutEng,      _
'          strFormOutEng,      _
'          strReportOutEng,    _
'          strOptionCT, ,      _
'          strNation,          _
'          strCslOptions       _
'      )

Ret = objWebRsv.SelectWebRsv( _
          dtmCslDate,         _
          lngWebNo,           _
          ,                   _
          ,                   _
          ,                   _
          strPerId,           _
          strFullName,        _
          strKanaName,        _
          strLastName,        _
          strFirstName,       _
          strLastKName,       _
          strFirstKName,      _
          strGender,          _
          strBirth,           _
          strZipNo,           _
          strAddress1,        _
          strAddress2,        _
          strAddress3,        _
          strTel,             _
          strEMail,           _
          strOfficeName,      _
          strOfficeTel,       _
          strOrgName,         _
          strRsvDiv,          _
          strSupportDiv,      _
          strOptionStomac,    _
          strOptionBreast,    _
          strMessage,         _
          strInsDate,         _
          ,                   _
          ,                   _
          strIsrSign,         _
          strIsrNo,           _
          strVolunteer,       _
          strCardOutEng,      _
          strFormOutEng,      _
          strReportOutEng,    _
          strOptionCT, ,      _
          strNation,          _
          strCslOptions,      _
          strWebReqNo         _
      )
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###

'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####

'オブジェクトの解放
Set objWebRsv = Nothing

'レコードが存在しない場合は処理終了
If Ret = False Then
    Response.End
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>web予約情報登録(申し込み情報)</TITLE>
<style type="text/css">
    body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">申し込み情報</FONT></B></TD>
    </TR>
</TABLE>
<%
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
<%'#### 2017.03.20 張 WEB申し込み番号追加 STR ####%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>申込番号</TD>
        <TD>：</TD>
        <TD WIDTH="100%" NOWRAP><%= strWebReqNo %></TD>
    </TR>
<%'#### 2017.03.20 張 WEB申し込み番号追加 END ####%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>申込日</TD>
        <TD>：</TD>
        <TD WIDTH="100%" NOWRAP><%= objCommon.FormatString(CDate(strInsDate), "yyyy年m月d日 hh:nn:ss") %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="bottom">
        <TD>氏名</TD>
        <TD>：</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
<%
                    '氏名については、個人ID存在時は個人情報から、さもなくばweb予約情報から取得
                    If strPerId <> "" Then
                        strEditPerId    = strPerId
                        strEditFullName = Trim(strLastName  & "　" & strFirstName)
                        strEditKanaName = Trim(strLastKName & "　" & strFirstKName)
                        If strEditFullName = "" Then
                            strEditFullName = strFullName
                        End If
                        If strEditKanaName = "" Then
                            strEditKanaName = strKanaName
                        End If
                    Else
                        strEditPerId    = PERID_FOR_NEW_PERSON
                        strEditFullName = strFullName
                        strEditKanaName = strKanaName
                    End If
%>
                    <TD VALIGN="bottom" NOWRAP><%= strEditPerId %></TD>
                    <TD>&nbsp;</TD>
                    <TD><FONT SIZE="1"><%= strEditKanaName %><BR></FONT><%= strEditFullName %></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD></TD>
        <TD></TD>
        <TD><%= objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d") %>生&nbsp;&nbsp;<%= IIf(CLng(strGender) = GENDER_MALE, "男性", "女性") %></TD>
    </TR>
<%
    'オブジェクトの解放
    Set objCommon = Nothing
%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="top">
        <TD NOWRAP>自宅住所</TD>
        <TD>：</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR VALIGN="top">
<%
                    '郵便番号指定時のみ列を表示
                    If strZipNo <> "" Then

                        strZipNo1 = Left(strZipNo, 3)
                        strZipNo2 = Mid(strZipNo, 4, 4)
                        strEditZipNo = strZipNo1 & IIf(strZipNo2 <> "", "-", "") & strZipNo2
%>
                        <TD NOWRAP><%= strEditZipNo %></TD>
                        <TD>&nbsp;</TD>
<%
                    End If
%>
                    <TD><%= strAddress1 & strAddress2 & strAddress3 %></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD>TEL</TD>
        <TD>：</TD>
        <TD><%= strTel %></TD>
    </TR>
    <TR>
        <TD>e-mail</TD>
        <TD>：</TD>
        <TD><%= strEMail %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>勤務先</TD>
        <TD>：</TD>
        <TD><%= strOfficeName %></TD>
    </TR>
    <TR>
        <TD>TEL</TD>
        <TD>：</TD>
        <TD><%= strOfficeTel %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
<% '#### 2013.2.27 SL-SN-Y0101-612 ADD START #### %>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    </TR>
        <TD>国籍</TD>
        <TD>：</TD>
        <TD><%= strNation %></TD>
    </TR>
<% '#### 2013.2.27 SL-SN-Y0101-612 ADD END   #### %>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD NOWRAP>申込団体</TD>
        <TD>：</TD>
        <TD><%= strOrgName %></TD>
    </TR>
    <TR>
        <TD>区分</TD>
        <TD>：</TD>
<%
        '申し込み区分の名称変換
        Select Case strRsvDiv
            Case RSVDIV_NORMAL
                strEditRsvDiv = "一般"
            Case RSVDIV_ORG
                strEditRsvDiv = "契約団体"
            Case RSVDIV_BURDEN
                strEditRsvDiv = "健康保険組合連合会"
        End Select

        '本人家族区分の名称変換
        Select Case strSupportDiv
            Case SUPPORTDIV_INSURANT
                strEditSupportDiv = "本人（被保険者）"
            Case SUPPORTDIV_FAMILY
                strEditSupportDiv = "家族（被扶養者）"
        End Select
%>
        <TD NOWRAP><%= strEditRsvDiv & IIf(strEditRsvDiv <> "" And  strEditSupportDiv <> "", "&nbsp;&nbsp;", "") & strEditSupportDiv %></TD>
    </TR>
<% '#### 2011/01/20 ADD STA TCS)Y.T #### %>

    <TR>
        <TD NOWRAP>保険証記号</TD>
        <TD>：</TD>
        <TD><%= strIsrSign %></TD>
    </TR>
    <TR>
        <TD NOWRAP>保険証番号</TD>
        <TD>：</TD>
        <TD><%= strIsrNo %></TD>
    </TR>

<%
        'ボランティア区分変換
        Select Case strVolunteer
            Case VOLUNTEER_NOT
                strEditVolunteer = "利用なし"
            Case VOLUNTEER_ITPT
                strEditVolunteer = "通訳要"
            Case VOLUNTEER_CARE
                strEditVolunteer = "介護要"
            Case VOLUNTEER_BOTH
                strEditVolunteer = "通訳＆介護要"
            Case VOLUNTEER_CHAIR
                strEditVolunteer = "車椅子要"
        End Select
%>
    <TR>
        <TD NOWRAP>ボランティア</TD>
        <TD>：</TD>
        <TD><%= strEditVolunteer %></TD>
    </TR>

<%
        '確認はがき英文出力区分の名称変換
        Select Case strCardOutEng
            Case "0"
                strEditCardOutEng = "無"
            Case "1"
                strEditCardOutEng = "有"
        End Select

        '一式書式英文出力区分の名称変換
        Select Case strFormOutEng
            Case "0"
                strEditFormOutEng = "無"
            Case "1"
                strEditFormOutEng = "有"
        End Select

        '成績書英文出力区分の名称変換
        Select Case strReportOutEng
            Case "0"
                strEditReportOutEng = "無"
            Case "1"
                strEditReportOutEng = "有"
        End Select
%>
    <TR>
        <TD NOWRAP>確認はがき英文出力</TD>
        <TD>：</TD>
        <TD><%= strEditCardOutEng %></TD>
    </TR>
    <TR>
        <TD NOWRAP>一式書式英文出力</TD>
        <TD>：</TD>
        <TD><%= strEditFormOutEng %></TD>
    </TR>
    <TR>
        <TD NOWRAP>成績表英文出力</TD>
        <TD>：</TD>
        <TD><%= strEditReportOutEng %></TD>
    </TR>
<% '#### 2011/01/20 ADD END TCS)Y.T #### %>

    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="top">
        <TD>セット</TD>
        <TD>：</TD>
<%
        '胃検査の名称変換
        Select Case strOptionStomac
            Case STOMAC_XRAY
                strEditStomac = "胃Ｘ線"
            Case STOMAC_CAMERA
                strEditStomac = "胃内視鏡"
        End Select

'#### 2011/01/20 ADD STA TCS)Y.T ####
        '胸部検査の名称変換
        Select Case strOptionCT
'胸部CTのみ表示
'            Case CHEST_XRAY
'                strEditChest = "胸部Ｘ線"
            Case CHEST_CT
                strEditChest = "胸部ＣＴ"
        End Select
'#### 2011/01/20 ADD END TCS)Y.T ####

        '乳房検査の名称変換
        Select Case strOptionBreast
            Case BREAST_XRAY
                strEditBreast = "乳房Ｘ線"
            Case BREAST_ECHO
                strEditBreast = "乳房超音波"
            Case BREAST_XRAY_ECHO
                strEditBreast = "乳房Ｘ線・乳房超音波"
        End Select
%>
<% '#### 2011/01/20 MOD STA TCS)Y.T #### %>
<%
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
        '受診オプションコードのカンマ結合文字列が存在する場合はその内容をもとにオプション名を表示
        If strCslOptions <> "" Then
%>
            <TD NOWRAP><%= Join(ToMapWebOptName(strCslOptions), "<BR>") %></TD>
<%
        Else
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####
%>
        <!--TD NOWRAP><%= strEditStomac & IIf(strEditStomac <> "" And strEditBreast <> "", "、", "") & strEditBreast %></TD-->
        <TD NOWRAP><%= strEditStomac & IIf(strEditStomac <> "" And strEditBreast <> "", "、", "") & strEditBreast & IIf((strEditStomac <> "" or strEditBreast <> "") And strEditChest <> "", "、", "") & strEditChest %></TD>
<%
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
        End If
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####
%>
<% '#### 2011/01/20 MOD END TCS)Y.T #### %>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
    <TR><TD BGCOLOR="#999999"></TD></TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>予約時メッセージ：</TD>
    </TR>
    <TR>
        <TD><%= strMessage %></TD>
    </TR>
</TABLE>
</BODY>
</HTML>
