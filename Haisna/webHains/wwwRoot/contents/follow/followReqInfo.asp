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
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objFollow               'フォローアップアクセス用
Dim objReqHistory           '依頼状履歴アクセス用
Dim objPerson               
Dim objReqSendCheck         '依頼状作成クラス


Dim strMessage              'エラーメッセージ
Dim strMode                 '処理モード
Dim strAct                  '処理状態
Dim strStartCslDate         '検索条件受診年月日（開始）
Dim strStartYear            '検索条件受診年（開始）
Dim strStartMonth           '検索条件受診月（開始）
Dim strStartDay             '検索条件受診日（開始）
Dim strEndCslDate           '検索条件受診年月日（終了）
Dim strEndYear              '検索条件受診年（終了）
Dim strEndMonth             '検索条件受診月（終了）
Dim strEndDay               '検索条件受診日（終了）
Dim strPerId
Dim strPerName
Dim strLastName             '検索条件姓
Dim strFirstName            '検索条件名
Dim strSendFlg
Dim strItemCd               '検査条件検査項目
Dim lngItemCount            'フォロー対象検査項目数

Dim vntCslDate              '受診日
Dim vntDayId                '当日ID
Dim vntPerId                '個人ID
Dim vntPerKname             'カナ氏名
Dim vntPerName              '氏名
Dim vntAge                  '年齢
Dim vntGender               '性別
Dim vntBirth                '生年月日
Dim vntRsvNo                '予約番号
Dim vntJudClassCd           '判定分類コード
Dim vntJudClassName         '判定分類名
Dim vntFileName
Dim vntHanSu
Dim vntAddDate              '登録日（依頼状印刷日）
Dim vntAddUser              '登録者
Dim vntReqSendDate          '発送日
Dim vntReqSendUser          '発送確認者
Dim vntItemCd               'フォロー対象検査項目コード
Dim vntItemName             'フォロー対象検査項目名称
Dim vntClrFlg           	'発送クリアフラグ
Dim vntDelRsvNo				'発送クリア予約番号
Dim vntDelJudClassCd		'発送クリア判定分類コード
Dim vntDelSeq               '発送クリア依頼状版数

Dim strReqSendStat          '依頼状発送ステータス("":すべて、"0":未発送、"1":発送済み)
Dim lngStartPos             '表示開始位置
Dim lngPageMaxLine          '１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()     '１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName() '１ページ表示ＭＡＸ行名の配列
Dim strArrMessage           'エラーメッセージ
Dim lngAllCount             '総件数
Dim lngAllRsvCount          '複数予約なし件数
Dim strBeforeRsvNo          '前行の予約番号

Dim strWebCslDate           '受診日
Dim strWebDayId             '当日ID
Dim strWebPerId             '個人ID
Dim strWebPerName           'カナ氏名・氏名
Dim strWebGender            '性別
Dim strWebAge               '年齢
Dim strWebBirth             '生年月日
Dim strWebRsvNo             '予約番号
Dim strWebJudClassName      '判定分類名
Dim strWebSendUser          '依頼状発送確認者
Dim strWebSendDate
Dim strWebHanSu             '依頼状版数

Dim i                       'カウンタ
Dim j                      
Dim strURL                  'ジャンプ先のURL

'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objReqHistory   = Server.CreateObject("HainsRequestCard.RequestCard")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strMode             = Request("mode")
strAct              = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
strItemCd           = Request("itemCd")
strPerId            = Request("perId")
strSendFlg          = Request("reqSendStat")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("rsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntHanSu            = ConvIStringToArray(Request("seq"))
vntClrFlg           = ConvIStringToArray(Request("checkClrVal"))

'vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
'vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))

'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    strStartYear    = CStr(Year(Now))
    strStartMonth   = CStr(Month(Now))
    strStartDay     = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine)


Call CreatePageMaxLineInfo()
'オブジェクトのインスタンス作成


Do

    'フォロー対象検査項目（判定分類）を取得
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName)

	'保存ボタンクリック
	If strAct = "save" Then
		vntDelRsvNo         = Array()
        vntDelJudClassCd    = Array()
		vntDelSeq           = Array()

		For i = 0 To UBound(vntClrFlg)
			'チェックされた場合に、処理実行
			If vntClrFlg(i) = "1" Then
				ReDim Preserve vntDelRsvNo(j)
                ReDim Preserve vntDelJudClassCd(j)
				ReDim Preserve vntDelSeq(j)

				vntDelRsvNo(j)      = vntRsvNo(i)
                vntDelJudClassCd(j) = vntJudClassCd(i)
				vntDelSeq(j)        = vntHanSu(i)
				j = j + 1
			End If
		Next

		if j > 0 Then
			'発送日クリア
			If objReqHistory.ClearSendDate(vntDelRsvNo,vntDelJudClassCd, vntDelSeq) Then
				strAct = "saveend"
			Else
				strArrMessage = Array("発送日クリア処理に失敗しました。")
			End If
		Else
			'オブジェクトのインスタンス作成
			objCommon.AppendArray strArrMessage, "クリアする依頼状が一つも選択されていません"
			strMessage = strArrMessage
		End If
	End If


    '検索ボタンクリック
    If strAct <> "" Then

        '受診日(自)の日付チェック
        If strStartYear <> "" Or strStartMonth <> "" Or strStartDay <> "" Then
            If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
                strArrMessage = Array("受診日の指定に誤りがあります。")
                Exit Do
            End If
        End If

        '受診日(至)の日付チェック
        If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
            If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
                strArrMessage = Array("受診日の指定に誤りがあります。")
                Exit Do
            End If
            strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
        Else
            strEndCslDate = strStartCslDate
        End If

        '検索開始終了受診日の編集
        strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)


        lngAllCount =objReqHistory.SelectReqPrtSendList( strStartCslDate, strEndCslDate, _
                                                    strItemCd, strPerId, _
                                                    strSendFlg, 1, _
                                                    lngStartPos,lngPageMaxLine, _
                                                    vntCslDate, vntDayId, _
                                                    vntPerId, _
                                                    vntPerName, vntPerKName, _
                                                    vntGender, vntAge, _
                                                    vntBirth, vntRsvNo, _
                                                    vntJudClassCd, vntJudClassName, _
                                                    vntFileName, vntHanSu, _
                                                    vntAddDate, vntAddUser, _
                                                    vntReqSendDate, vntReqSendUser _
                                                    )
        '個人IDの指定がある場合、名称取得
        If strPerId <> "" Then
            ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
            strPerName = strLastName & "　" & strFirstName
        Else
            strPerName = ""
        End If 

    End If
    Exit Do
Loop



'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()
    Redim Preserve lngArrPageMaxLine(4)
    Redim Preserve strArrPageMaxLineName(4)

    lngArrPageMaxLine(0) = 10:strArrPageMaxLineName(0) = "10行ずつ"
    lngArrPageMaxLine(1) = 20:strArrPageMaxLineName(1) = "20行ずつ"
    lngArrPageMaxLine(2) = 50:strArrPageMaxLineName(2) = "50行ずつ"
    lngArrPageMaxLine(3) = 100:strArrPageMaxLineName(3) = "100行ずつ"
    lngArrPageMaxLine(4) = 999:strArrPageMaxLineName(4) = "すべて"

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>依頼状発送進捗照会</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //フォローアップ画面ハンドル
    var winMenResult;       // ドック結果参照ウィンドウハンドル
    var winRslFol;          // フォロー結果登録ウィンドウハンドル
    var winReqCheck;

    // エレメント参照用変数
    var calCheck_Year;				// 年
    var calCheck_Month;				// 月
    var calCheck_Day;				// 日
    var calCheck_CalledFunction;	// 日付選択時に呼び出される関数オブジェクト
    var winGuideCalendar;			// ウィンドウハンドル

    // ユーザーガイド呼び出し
    function callGuideUsr() {

        usrGuide_CalledFunction = SetUpdUser;

        // ユーザーガイド表示
        showGuideUsr();

    }

    // ユーザーセット
    function SetUpdUser() {

        document.entryForm.upduser.value = usrGuide_UserCd;
        document.entryForm.updusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;
    }


    // ユーザー指定クリア
    function clearUpdUser() {
        document.entryForm.upduser.value = '';
        document.entryForm.updusername.value = '';
        document.getElementById('username').innerHTML = '';

    }

    // 日付ガイド呼び出し
    function callCalGuide(year, month, day) {
        // 日付ガイド表示
        calGuide_showGuideCalendar( year, month, day);
    }

    function submitForm(act) {
        with ( document.entryForm) {
            if (act == "search" ) {
                startPos.value = 1 ;
            }
            action.value = act;
            submit();
        }
        return false;
    }

function checkClrAct( index ) {

	with ( document.entryForm ) {
		if ( checkClr.length == null ) {
			checkClr.value = (checkClr.checked ? '1' : '0');
			checkClrVal.value = (checkClr.checked ? '1' : '0');
		} else {
			checkClr[index].value = (checkClr[index].checked ? '1' : '0');
			checkClrVal[index].value = (checkClr[index].checked ? '1' : '0');
		}
	}
}

function setReqSendDateClr() {
	if( !confirm('選択された依頼状発送日をクリアします。よろしいですか？' ) ) return;

	with ( document.entryForm ) {
		action.value = 'save';
		submit();
	}
	return false;
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	td.flwtab { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action"      VALUE="">
    <INPUT TYPE="hidden" NAME="startPos"    VALUE="<%= lngStartPos %>">

<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">依頼状発送進捗照会</FONT></B></TD>
    </TR>
</TABLE>

<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">受診日</TD>
        <TD WIDTH="10">：</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;日～&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="日付ガイドを表示"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="設定日付をクリア"></A></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;日</TD>
                    <TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>

                    <TD align="right">
                        <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <TD WIDTH="100"><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>
                                <TD align="right">
                                    <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>

                </TR>
            </TABLE>
        </TD>

    </TR>
</TABLE>


<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">検査項目</TD>
        <TD WIDTH="10">：</TD>
        <TD><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>

        <TD WIDTH="60" NOWRAP>発送区分 </TD>
        <TD WIDTH="10">：</TD>
        <TD WIDTH="110">
            <SELECT NAME="reqSendStat">
                <OPTION VALUE=""  <%= IIf(strSendFlg = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strSendFlg = "0", "SELECTED", "") %>>未発送
                <OPTION VALUE="1" <%= IIf(strSendFlg = "1", "SELECTED", "") %>>発送済み
            </SELECT>
        </TD>
        <TD WIDTH="400"></TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">個人ID</TD>
        <TD NOWRAP WIDTH="10">：</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
                        <INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
                        <SPAN ID="perName"><%= strPerName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>


<%
    Do
    'メッセージの編集
        If strAct <> "" Then

            Select Case strAct
                '保存完了時は「保存完了」の通知
                Case "saveend"
                    Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
                'さもなくばエラーメッセージを編集
                Case Else
                    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
            End Select

%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        <SPAN STYLE="font-size:9pt;">
                        「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日<% End IF%></B></FONT>」のフォローアップ対象者一覧を表示しています。<BR>
                                （検索結果&nbsp;：&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;件）
                        </SPAN>
                    </TD>

                <%
                    If lngAllCount > 0 Then
                %>
                    <TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
                    <TD><A HREF="javascript:setReqSendDateClr()"><IMG SRC="../../images/save.gif" ALT="発送確認日時をクリアします" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
                <%
                    End If
                %>
                <TD WIDTH="300"> </TD>
                </TR>
            </TABLE>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP >受診日</TD>
                    <TD ALIGN="center" NOWRAP >当日ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP >個人ＩＤ</TD>
                    <TD ALIGN="center" NOWRAP  WIDTH="70">受診者名</TD>
                    <TD ALIGN="center" NOWRAP >性別</TD>
                    <TD ALIGN="center" NOWRAP >年齢</TD>
                    <TD ALIGN="center" NOWRAP >生年月日</TD>
                    <TD ALIGN="center" NOWRAP  WIDTH="110">検査項目<BR>（判定分類）</TD>
                    <TD ALIGN="center" NOWRAP >依頼状版数</TD>
                    <TD ALIGN="center" NOWRAP  >発送確認日</TD>
                    <TD ALIGN="center" NOWRAP  >発送確認者</TD>
                    <TD ALIGN="center" NOWRAP >発送クリア</TD>
                </TR>
                
<%
        End If

        If lngAllCount > 0 Then
            strBeforeRsvNo = ""

            vntClrFlg = Array()
			Redim Preserve vntClrFlg(lngAllCount)

            For i = 0 To UBound(vntRsvNo)
                strWebCslDate       = ""
                strWebDayId         = ""
                strWebPerId         = ""
                strWebPerName       = ""
                strWebGender        = ""
                strWebAge           = ""
                strWebBirth         = ""
                strWebHanSu         = vntHanSu(i)
                strWebJudClassName  = vntJudClassName(i)
                strWebRsvNo         = ""
                strWebSendUser      = vntReqSendUser(i)
                strWebSendDate      = vntReqSendDate(i)

                If strBeforeRsvNo <> vntRsvNo(i) Then
                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKname(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebGender    = vntGender(i)
                    strWebAge       = vntAge(i) & "歳"
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebSendUser  = vntReqSendUser(i)
                    strWebHanSu     = vntHanSu(i)
                    
                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'" onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebDayId %></TD>
                    <TD NOWRAP><%= strWebPerId %></TD>
                    <TD NOWRAP><%= strWebPerName %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebGender %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebAge %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebBirth %></TD>
<%
                    strBeforeRsvNo = vntRsvno(i)
%>
                    <TD NOWRAP ALIGN="center">
                        <%= strWebJudClassName   %>
                        <INPUT TYPE="hidden"    NAME="rsvNo"         VALUE="<%=vntRsvNo(i)%>">
                        <INPUT TYPE="hidden"    NAME="judClassCd"    VALUE="<%=vntJudClassCd(i)%>">
                        <INPUT TYPE="hidden"    NAME="seq"           VALUE="<%=vntHanSu(i)%>">
                    </TD>
                    <TD NOWRAP ALIGN="center"> <%= strWebHanSu %></TD>
                    <TD NOWRAP ALIGN="center"  WIDTH="140"> <% If vntReqSendDate(i) = "" Then %>-<% End If %> <%= strWebSendDate %></TD>
                    <TD NOWRAP ALIGN="center"  WIDTH="70"> <% If vntReqSendUser(i) = "" Then %>-<% End If %> <%= strWebSendUser %></TD>
                    <TD NOWRAP>
                        <INPUT TYPE="hidden" NAME="checkClrVal" VALUE="<%= vntClrFlg(i) %>">
                    <%
                        If strWebSendDate <> "" Then
                    %>
                            <INPUT TYPE="checkbox" NAME="checkClr" VALUE="1" <%= IIf(vntClrflg(i) <> "", " CHECKED", "") %>  ONCLICK="javascript:checkClrAct(<%= i %>)" border="0">クリア
                    <%
                        Else
                    %>
                             <INPUT TYPE="checkbox" NAME="checkClr" VALUE="0" BORDER="0" STYLE="visibility:hidden">
                    <%
                        End If
                    %>
                    </TD>
                </TR>
<%
                    strBeforeRsvNo = vntRsvno(i)
            Next
        End If
%>

        </TABLE>

<%
        If lngAllCount > 0 Then
            '全件検索時はページングナビゲータ不要
                If lngPageMaxLine <= 0 Then
            Else
                'URLの編集
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?mode="        & strMode
                strURL = strURL & "&action="      & "search"
                strURL = strURL & "&startYear="   & strStartYear
                strURL = strURL & "&startMonth="  & strStartMonth
                strURL = strURL & "&startDay="    & strStartDay
                strURL = strURL & "&endYear="     & strEndYear
                strURL = strURL & "&endMonth="    & strEndMonth
                strURL = strURL & "&endDay="      & strEndDay
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&perId="       & strPerId
                strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
                'ページングナビゲータの編集
%>
                <%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
            End If
%>
            <BR>
<%
        End If
        Exit Do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
