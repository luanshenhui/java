<%
Const MESSAGETYPE_NORMAL  = 0
Const MESSAGETYPE_WARNING = 1
'-------------------------------------------------------------------------------
'
' 機能　　 : メッセージ編集
'
' 引数　　 : (In)     strMessage      メッセージ
' 　　　　   (In)     lngMessageType  メッセージタイプ
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditMessage(strMessage, lngMessageType)

    Dim strArrMessage           'メッセージの配列
    Dim i                       'インデックス
    Dim strIcon                 'アイコンイメージファイル名

'## 2015.03.04 張 ワーニング指定の場合、赤色で表示できるように仕様変更 START
    Dim strColor                'メッセージの色
    strColor = "#FF9900"
'## 2015.03.04 張 ワーニング指定の場合、赤色で表示できるように仕様変更 END


    'メッセージが存在しない場合は何もしない
    If IsEmpty(strMessage) Then
        Exit Sub
    End If

    '配列形式への変換
    If Not IsArray(strMessage) Then
        strArrMessage = Array(strMessage)
    Else
        strArrMessage = strMessage
    End If

    'ワーニング指定されている場合はアイコンを編集
    If lngMessageType = MESSAGETYPE_WARNING Then

        strIcon = "/webHains/images/ico_w.gif"

'## 2015.03.04 張 ワーニング指定の場合、赤色で表示できるように仕様変更 START
        strColor = "#FF0000"
'## 2015.03.04 張 ワーニング指定の場合、赤色で表示できるように仕様変更 END

    End If


    'ワーニング指定されている場合はアイコンを編集
    If lngMessageType = MESSAGETYPE_NORMAL Then
        strIcon = "/webHains/images/ico_i.gif"
    End If


    'メッセージの編集開始
%>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
<%
        For i = 0 To UBound(strArrMessage)
%>
            <TR>
<%
                If i = 0 Then
%>
                <TD><IMG SRC="<%= strIcon %>" WIDTH="16" HEIGHT="16" ALT=""></TD>
<%
                Else
%>
                <TD></TD>
<%
                End If
%>

                <!--TD VALIGN="BOTTOM"><SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;"><%= strArrMessage(i) %></SPAN></TD-->
                <TD VALIGN="BOTTOM"><SPAN STYLE="color:<%= strColor %>;font-weight:bolder;font-size:14px;"><%= strArrMessage(i) %></SPAN></TD>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub
%>
