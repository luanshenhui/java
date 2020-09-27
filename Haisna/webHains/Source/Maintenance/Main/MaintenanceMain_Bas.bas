Attribute VB_Name = "MaintenanceMain_Bas"
Option Explicit

Public Sub Main()

    Dim blnCertification    As Boolean
    Dim objForm             As frmMntLogin
    
    'ÉçÉOÉCÉìâÊñ ï\é¶
    Set objForm = New frmMntLogin
    With objForm
        .Show vbModal
        blnCertification = .Certification
    End With

    If blnCertification = True Then
        frmMaster.Show ' vbModal
    End If

    Set objForm = Nothing

End Sub
