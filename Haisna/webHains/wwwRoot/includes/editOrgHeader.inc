<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報の編集
'
' 引数　　 : (In)     strOrgCd1  団体コード1
' 　　　　 : (In)     strOrgCd1  団体コード2
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditOrgHeader(strOrgCd1, strOrgCd2)

    Dim objOrganization     '団体情報アクセス用

    Dim strOrgKName         '団体カナ名
    Dim strOrgName          '団体名
    Dim strZipCd1           '郵便番号1
    Dim strZipCd2           '郵便番号2
'## 2003.11.18 Add by T.Takagi@FSIT 不要項目削除
    Dim strZipCd            '郵便番号
'## 2003.11.18 Add End
    Dim strPrefName         '都道府県名
    Dim strCityName         '市区町村名
    Dim strAddress1         '住所1
    Dim strAddress2         '住所2
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    Dim strTel1            '電話番号代表－市外局番
'    Dim strTel2            '電話番号代表－局番
'    Dim strTel3            '電話番号代表－番号
    Dim strTel              '電話番号代表
'## 2003.11.18 Mod End
    Dim strChargeName       '担当者氏名
    Dim strChargePost       '担当者部署名

    Dim strBuffer           '文字列編集用バッファ
    Dim strTelBuffer        '電話番号文字列編集用バッファ
    Dim strTelCapBuffer     '電話番号文字列編集用バッファ
    Dim strChargeBuffer     '担当者名編集用バッファ

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
    Dim strHighLight        '団体名称ハイライト表示区分
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###

    'オブジェクトのインスタンス作成
    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

    '団体情報の読み込み
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    If objOrganization.SelectOrgHeader(strOrgCd1, strOrgCd2, strOrgKName, strOrgName, _
'                                       strZipCd1, strZipCd2, strPrefName, strCityName,   strAddress1, strAddress2, _
'                                       strTel1,   strTel2,   strTel3,     strChargeName, strChargePost) = False Then

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
'    If objOrganization.SelectOrgHeader(strOrgCd1, strOrgCd2, strOrgKName, strOrgName, strZipCd, strPrefName, strCityName, strAddress1, strAddress2, strTel, strChargeName, strChargePost) = False Then
    If objOrganization.SelectOrgHeader(strOrgCd1, strOrgCd2, strOrgKName, strOrgName, strZipCd, strPrefName, strCityName, strAddress1, strAddress2, strTel, strChargeName, strChargePost, strHighLight) = False Then
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###

'## 2003.11.18 Mod End
        Err.Raise 1000, , "団体情報が存在しません。"
    End If

    '住所の編集
'## 2003.11.18 Add by T.Takagi@FSIT 不要項目削除
    strZipCd1 = Trim(Left(strZipCd, 3))
    strZipCd2 = Trim(Mid(strZipCd, 4, 4))
'## 2003.11.18 Add End
    strBuffer = strZipCd1
    strBuffer = strBuffer & IIf(strZipCd2 <> "", "-" & strZipCd2, "")
    strBuffer = strBuffer & IIf(strBuffer <> "", " ", "")
    strBuffer = strBuffer & strPrefName & strCityName & strAddress1
    strBuffer = IIf(strAddress2 <> "", Trim(strBuffer) & " " & strAddress2, strBuffer)

    '電話番号の編集
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strTelBuffer = IIf(strTel1 <> "", "(" & strTel1 & ")", "")
'    strTelBuffer = strTelBuffer & strTel2
'    strTelBuffer = strTelBuffer & IIf(strTel2 <> "" And strTel3 <> "", "-", "") & strTel3
    strTelBuffer = strTel
'## 2003.11.18 Mod End

    If Trim(strTelBuffer) <> "" Then
        strTelCapBuffer = "TEL："
    End If

    '担当の編集
    strChargeBuffer = "" & strChargePost & IIf(strChargePost <> "" And strChargeName <> "", " ", "") & strChargeName

'## 2004.03.18 Added by H.Ishihara@FSIT 団体名称からアンカー
    strOrgName = "<A HREF=""/webHains/contents/maintenance/organization/mntOrganization.asp?mode=update&orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2 & """>" & strOrgName & "</A>"
'## 2004.03.18 Added End

%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>

<% '### 2013.12.25 張 団体名称ハイライト表示有無をチェックの為追加　Start ### %>
<%  If strHighLight = "1" Then  %>
        <TD ROWSPAN="4" VALIGN="top" NOWRAP><font style='font-weight:bold; background-color:#00FFFF;'><b><%= strOrgCd1 & "-" & strOrgCd2 %></b></font></TD>
        <TD COLSPAN="4"><FONT SIZE="-2"><%= strOrgKName %></FONT></TD>
<%  Else                        %>
        <TD ROWSPAN="4" VALIGN="top" NOWRAP><%= strOrgCd1 & "-" & strOrgCd2 %></TD>
        <TD COLSPAN="4"><FONT SIZE="-2"><%= strOrgKName %></FONT></TD>
<%  End If                      %>
<% '### 2013.12.25 張 団体名称ハイライト表示有無をチェックの為追加　End   ### %>

    </TR>
    <TR>
        <TD COLSPAN="4" NOWRAP><B><FONT SIZE="+1"><%= strOrgName %></FONT></B></TD>
    </TR>
<TR>
<%
        If (Trim(strBuffer) <> "") Or (Trim(strTelBuffer) <> "")  Then
%>
<TD>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><%= strBuffer %></TD>
            <TD WIDTH="25"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5"></TD>
            <TD NOWRAP><%= strTelCapBuffer %></TD>
            <TD NOWRAP><%= strTelBuffer %></TD>
        </TR>
    </TABLE>
</TD>
<%
        End If
%>

<%
        If Trim(strChargeBuffer) <> "" Then
%>
<TD NOWRAP>担当：<%= strChargeBuffer %></TD>
<%
        End If
%>
</TR>
</TABLE>
<%
End Sub
%>
