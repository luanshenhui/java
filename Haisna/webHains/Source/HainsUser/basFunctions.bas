Attribute VB_Name = "basFunctions"
Option Explicit

'------------------------------------------------------------------
'   SecretCodeDecode    暗号解読関数
'
'   in :    ID$             (利用者ID
'           Code$           (暗号
'
'   out :   パスワード
'
'   Date :  98/2/12         Imaoka
'------------------------------------------------------------------

Public Function SecretCodeDecode(wk_Code As String) As String
    Dim i       As Integer
    Dim j       As Integer
    Dim c       As Integer
    Dim w       As String * 1
    Dim w1      As String
    Dim w2      As String
    Dim w3      As String
    Dim wCD     As String

    Dim k           As Integer
    Dim wk2         As String

    On Error GoTo Err_Chk

    wk2 = ""

'   暗号の解読
'   作成した暗号をパスワード用のテーブルから解読
    For i = 1 To Len(wk_Code)
        w1 = Mid(wk_Code, i, 1)
        
        '変換しなかった文字列のとき
        If ((w1 >= "0" And w1 <= "9") Or (w1 >= "A" And w1 <= "F")) Then
            w2 = Mid(wk_Code, i + 1, 1)
            If ((w2 >= "0" And w2 <= "9") Or (w2 >= "A" And w2 <= "F")) Then
                '範囲外はそのまま
                wk2 = wk2 & Mid(wk_Code, i, 2)
                i = i + 1
            Else
                Exit Function
            End If
        Else
            For j = 0 To 11
                For k = 0 To 11
                    If (w1 = PASS_TABLE(j, k)) Then
                        wk2 = wk2 & Hex(j) & Hex(k)
                        Exit For
                    End If
                Next k
                If (k <= 11) Then Exit For
            Next j
        End If
    Next i

    '作成した文字列を返す
    w3 = wk2
    
    'w3 = SecretReMake(Code)    '追加(kadowaki)

    w2 = ""
    wCD = ""

    'パスワードの１６進数からＡｓｃ文字に変換する
    For i = 1 To Len(w3) Step 2
        w1 = Mid(w3, i, 2)
            '文字変換
        wCD = wCD & Chr$(Val("&H" & w1))
        w2 = wCD
    Next i
    
    '文字変換
    SecretCodeDecode = w2

Exit Function
Err_Chk:
    SecretCodeDecode = ""
    Exit Function
End Function

'------------------------------------------------------------------
'   SecretCodeMake    暗号作成関数
'
'   in:     Pass$           (パスワード
'
'   out :   暗号
'
'   Date :  98/2/12         Imaoka
'------------------------------------------------------------------

Public Function SecretCodeMake(Pass As String) As String
    Dim i           As Integer
    Dim j           As Integer
    Dim c           As Integer
    Dim w           As String * 1
    Dim wk_pass     As String
    Dim w1          As String
    Dim w2          As String

    Dim wk          As String
    Dim wk2         As String

    On Error GoTo Err_Chk
    
    If Pass = "" Then
        SecretCodeMake = ""
        Exit Function
    End If
    
    wk_pass = ""
    
    'パスワードを１６進数に変換
    For i = 1 To Len(Pass)
        w = Mid(Pass, i, 1)
        wk_pass = wk_pass & Hex(Asc(w))
    Next i

    'SecretCodeMake = SecretMake(wk_pass)

'   暗号の作成
'   作成した暗号をさらにパスワード用のテーブルに照らし合わせて文字を変換

    w1 = ""
    w2 = ""

    wk = wk_pass
    
    For i = 1 To Len(wk) Step 2
        w1 = "&H" & Mid(wk, i, 1)
        w2 = "&H" & Mid(wk, i + 1, 1)
        '１６進数を１０進数に変換してテーブルの範囲内かチェックする
        If (Val(w1) < 12 And Val(w2) < 12) Then
            '範囲内ならば１文字に変換する
            wk2 = wk2 & PASS_TABLE(Val(w1), Val(w2))
        Else
            '範囲外はそのまま
            wk2 = wk2 & Mid(wk, i, 2)
        End If
    
    Next i
    wk2 = StrConv(wk2, vbFromUnicode)
    If LenB(wk2) > 32 Then
        SecretCodeMake = StrConv(MidB(wk2, 1, 32), vbUnicode)
    Else
        SecretCodeMake = StrConv(wk2, vbUnicode)
    End If
    
Exit Function
Err_Chk:
    SecretCodeMake = ""
    Exit Function
End Function

Public Function TBLIni()
    Dim wk           As String
    Dim i            As Integer
    Dim j            As Integer
    Dim k            As Integer

    'パスワード用テーブル作成
    wk = "GHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"                   '46 Word
    wk = wk & "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮｯ"     '55 Word
    wk = wk & "!#$%&'()=-^~|\@`[{;+:*]},<.>/?_｡｢｣･ﾞﾟｰ 《》『』"             '42 Word
    k = 1
    For i = 0 To 11
        For j = 0 To 11
            PASS_TABLE(i, j) = Mid(wk, k, 1)
            k = k + 1
        Next j
    Next i

End Function
