<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォローガイド (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const DOKUMENT_DATAPATH = "D:\webHains\wwwRoot\FollowDocument\"
Const PRT_DIV = 1         '様式分類：依頼状

'データベースアクセス用オブジェクト
Dim objFollow           'フォローアップアクセス用
Dim objConsult          '受診クラス
Dim objWord
Dim objDoc

'パラメータ

Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '判定分類コード
Dim strJudClassName     '検診分類名
Dim strSecEquipName     '病医院名

Dim strFolItem1         '診断・依頼項目１
Dim strFolItem2         '診断・依頼項目２
Dim strFolNote1         '所見１
Dim strFolNote2         '所見２

'受診情報用変数
Dim strCslDate          '受診日
Dim strPerId            '個人ID
Dim strDayId            '当日ID
Dim strName             '氏名
Dim strKName            'カナ名
Dim strBirth            '生年月日
Dim strGender           '性別
Dim strAge              '実年齢
Dim strUpdUser          '更新者ID

Dim blnCount            '戻り値
Dim strSeq              '登録順番
Dim strFileName         '登録されたファイル名
Dim strAddDate          '登録日
Dim strAddUser          '登録者(作成者)
Dim strAddUserName      '更新者名
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFollow     = Server.CreateObject("HainsFollow.Follow")

'パラメータ値の取得
lngRsvNo        = Request("rsvno")
lngJudClassCd   = Request("judClassCd")
strJudClassName = Request("judClassName")
strSecEquipName = Request("hospital")

strFolItem1     = Request("folItem1")
strFolItem2     = Request("folItem2")
strFolNote1     = Request("folNote1")
strFolNote2     = Request("folNote2")

strCslDate      = Request("cslDate")
strPerId        = Request("perId")
strAge          = Request("age")
strDayId        = Request("dayId")
strName         = Request("name")
strKname        = Request("kName")
strBirth        = Request("birth")
strGender       = Request("gender")

strUpdUser     = Request("userId")


Do
    blnCount = objFollow.InsertReqHistory(lngRsvNo, _
                                          lngJudClassCd, _
                                          PRT_DIV, _
                                          strCslDate, _
                                          strUpdUser, _
                                          strSeq, _
                                          strFileName, _
                                          strAddDate, _
                                          strAddUser, _
                                          strAddUserName _
                                         )

    If blnCount = False Then
        Err.Raise 1000, , "依頼状作成時、エラーが発生しました。（予約番号= " & lngRsvNo & " )"
    End If

    Exit Do
Loop


    Set objWord = CreateObject("Word.Application")
    Set objDoc = CreateObject("Word.Document")
        objWord.visible = False
        objDoc = objWord.Documents.Open(DOKUMENT_DATAPATH & "request.doc")
        
        Set myRange = objDoc.Bookmarks("HOSPITAL1").Range
        myRange.text = strSecEquipName
        Set myRange = objWordDoc.Bookmarks("NAME1").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("PRINTDATE").Range
        myRange.text = strAddDate
        Set myRange = objDoc.Bookmarks("HOSPITAL2").Range
        myRange.text = strSecEquipName
        Set myRange = objWordDoc.Bookmarks("NAME2").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("KNAME1").Range
        myRange.text = strKname
        Set myRange = objDoc.Bookmarks("GENDER1").Range
        myRange.text = strGender
        Set myRange = obj.Bookmarks("AGE1").Range
        myRange.text = strAge
        Set myRange = objDoc.Bookmarks("BIRTH1").Range
        myRange.text = strBirth
        Set myRange = objDoc.Bookmarks("CSLDATE1").Range
        myRange.text = strCslDate
        Set myRange = objDoc.Bookmarks("DAYID1").Range
        myRange.text = strDayId
        Set myRange = objDoc.Bookmarks("PERID1").Range
        myRange.text = strPerId
        Set myRange = objDoc.Bookmarks("ITEM1").Range
        myRange.text = strFolItem1
        Set myRange = objDoc.Bookmarks("NOTE1").Range
        myRange.text =strFolNote1
        Set myRange = objDoc.Bookmarks("ITEM2").Range
        myRange.text = strFolItem2
        Set myRange = objDoc.Bookmarks("NOTE2").Range
        myRange.text = strFolNote2
        Set myRange = objWordDoc.Bookmarks("DOCTOR1").Range
        myRange.text = strAddUserName
        Set myRange = objWordDoc.Bookmarks("DOCTOR2").Range
        myRange.text = strAddUserName
        Set myRange = objDoc.Bookmarks("NAME3").Range
        myRange.text = strName
        Set myRange = objDoc.Bookmarks("KNAME2").Range
        myRange.text = strKname
        Set myRange = obj.Bookmarks("GENDER2").Range
        myRange.text = strGender
        Set myRange = objDoc.Bookmarks("AGE2").Range
        myRange.text = strAge
        Set myRange = objDoc.Bookmarks("BIRTH2").Range
        myRange.text = strBirth
        Set myRange = objDoc.Bookmarks("CSLDATE2").Range
        myRange.text = strCslDate
        Set myRange = objDoc.Bookmarks("DAYID2").Range
        myRange.text = strDayId
        Set myRange = objDoc.Bookmarks("PERID2").Range
        myRange.text = strPerId
        Set myRange = nothing
        objWordDoc.SaveAs Application(DOKUMENT_DATAPATH & strFileName)
        objWord.Documents.Close
        objWord.Application.Quit
        Set objDoc = nothing
        Set objWord = nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>依頼状</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    var winWriteLetter;

function writeExecute() {
    var url;                         // URL文字列

    url = '/WebHains/FollowDocument/requestViewLetter.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
}


</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff" onload="javascript:writeExecute()">

<table height="100%" width="100%">
    <tr align="center" valign="center">
        <td align="right"><img src="/webHains/images/zzz.gif"></td>
        <td align='left'><b>処理中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
