Attribute VB_Name = "modMain"
Option Explicit

Public Sub Main()

    Dim blnCertification    As Boolean
    Dim objForm             As frmSecurityPgmGrp
    
    
    '���O�C����ʕ\��
    Set objForm = New frmSecurityPgmGrp
    
    With objForm
        .Show vbModal
'        blnCertification = .Certification
    End With

    Set objForm = Nothing
    
'    frmAddPgmList.Show

End Sub

