VERSION 5.00
Begin VB.Form frmRsvGrp 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�\��Q�e�[�u�������e�i���X"
   ClientHeight    =   5175
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5340
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRsvGrp.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5175
   ScaleWidth      =   5340
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtRptEndTime 
      Height          =   315
      Left            =   2400
      MaxLength       =   4
      TabIndex        =   9
      Text            =   "@@@@"
      Top             =   1980
      Width           =   555
   End
   Begin VB.TextBox txtEndTime 
      Height          =   315
      Left            =   2400
      MaxLength       =   4
      TabIndex        =   7
      Text            =   "@@@@"
      Top             =   1560
      Width           =   555
   End
   Begin VB.Frame Frame1 
      Caption         =   "��{���"
      Height          =   4575
      Left            =   120
      TabIndex        =   24
      Top             =   120
      Width           =   5115
      Begin VB.CheckBox chkIsOpenGrp 
         Caption         =   "�I�[�v���g�\��Q�Ƃ���(&R)"
         Height          =   195
         Left            =   2280
         TabIndex        =   20
         Top             =   3960
         Width           =   2235
      End
      Begin VB.ComboBox cboRsvSetGrp 
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   2280
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   18
         Top             =   3480
         Width           =   2535
      End
      Begin VB.TextBox txtEndDayId 
         Height          =   285
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   16
         Text            =   "@@@@"
         Top             =   3090
         Width           =   555
      End
      Begin VB.TextBox txtStrDayId 
         Height          =   285
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   14
         Text            =   "@@@@"
         Top             =   2700
         Width           =   555
      End
      Begin VB.OptionButton optLead 
         Caption         =   "�Ώ�(&Y)"
         Height          =   255
         Index           =   1
         Left            =   3480
         TabIndex        =   12
         Top             =   2280
         Width           =   975
      End
      Begin VB.OptionButton optLead 
         Caption         =   "��Ώ�(&N)"
         Height          =   255
         Index           =   0
         Left            =   2280
         TabIndex        =   11
         Top             =   2280
         Value           =   -1  'True
         Width           =   1155
      End
      Begin VB.TextBox txtStrTime 
         Height          =   315
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   5
         Text            =   "@@@@"
         Top             =   1020
         Width           =   555
      End
      Begin VB.TextBox txtRsvGrpName 
         Height          =   318
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   2280
         MaxLength       =   20
         TabIndex        =   3
         Text            =   "�Q"
         Top             =   660
         Width           =   2055
      End
      Begin VB.TextBox txtRsvGrpCd 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   2280
         MaxLength       =   3
         TabIndex        =   1
         Text            =   "@@@"
         Top             =   300
         Width           =   495
      End
      Begin VB.Label Label10 
         AutoSize        =   -1  'True
         Caption         =   "�I�[�v���g(&O):"
         Height          =   180
         Left            =   240
         TabIndex        =   19
         Top             =   3960
         Width           =   1005
      End
      Begin VB.Label Label9 
         Caption         =   "���f��t�I������(&P):"
         Height          =   285
         Left            =   240
         TabIndex        =   8
         Top             =   1920
         Width           =   1800
      End
      Begin VB.Label Label7 
         Caption         =   "�I������(&F):"
         Height          =   405
         Left            =   240
         TabIndex        =   6
         Top             =   1500
         Width           =   1365
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "�\�񎞂̐ݒ�O���[�v(&R):"
         Height          =   180
         Left            =   240
         TabIndex        =   17
         Top             =   3540
         Width           =   1890
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "�I������ID(&E):"
         Height          =   180
         Left            =   240
         TabIndex        =   15
         Top             =   3120
         Width           =   1140
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "�J�n����ID(&S):"
         Height          =   180
         Left            =   240
         TabIndex        =   13
         Top             =   2730
         Width           =   1140
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "�U��(&L):"
         Height          =   180
         Left            =   240
         TabIndex        =   10
         Top             =   2310
         Width           =   600
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "�\��Q��(&G):"
         Height          =   180
         Left            =   240
         TabIndex        =   2
         Top             =   720
         Width           =   990
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�\��Q�R�[�h(&C):"
         Height          =   180
         Left            =   240
         TabIndex        =   0
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label Label8 
         AutoSize        =   -1  'True
         Caption         =   "�J�n����(&T):"
         Height          =   180
         Left            =   240
         TabIndex        =   4
         Top             =   1110
         Width           =   975
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   2550
      TabIndex        =   22
      Top             =   4770
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1170
      TabIndex        =   21
      Top             =   4770
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   3930
      TabIndex        =   23
      Top             =   4770
      Width           =   1275
   End
End
Attribute VB_Name = "frmRsvGrp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.2.25
'�S����  �FT.Takagi@RD
'�C�����e�F�I�[�v���g�\��Q��ǉ�

Option Explicit

'�v���p�e�B�p�̈�
Private mstrRsvGrpCd        As String   '�\��Q�R�[�h
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly        As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s

Private mstrRsvSetGrpCd()   As String   '�\�񎞃Z�b�g�O���[�v�R�[�h�R���{�Ή��L�[�i�[�̈�

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Const mstrListViewKey   As String = "K"

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' �@�\�@�@ : �u�K�p�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p����B��ʂ͕��Ȃ�
'
' ���l�@�@ :
'
Private Sub cmdApply_Click()
    
    '�f�[�^�K�p�������s��
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �t�H�[���R���g���[���̏�����
'
' �@�\���� : �R���g���[����������ԂɕύX����B
'
' ���l�@�@ :
'
Private Sub InitializeForm()

    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
    
End Sub

' @(e)
'
' �@�\�@�@ : ��{�\��Q����ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �\��g�̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditRsvGrp() As Boolean

    Dim objRsvGrp       As Object             '�\��g���A�N�Z�X�p
    
    Dim vntRsvGrpName   As Variant            '�\��g����
    Dim vntStrTime      As Variant            '�J�n����
    Dim vntLead         As Variant            '�U���Ώ�
    Dim vntEndTIme      As Variant            '�I������
    Dim vntRptEndTIme   As Variant            '���f��t�I������
    Dim vntStrDayId     As Variant            '�J�n����ID
    Dim vntEndDayId     As Variant            '�I������ID
    Dim vntRsvSetGrpCd  As Variant            '�I������ID
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim vntIsOpenGrp    As Variant            '�I�[�v���g�\��Q
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

    Dim Ret             As Boolean            '�߂�l
    Dim i               As Integer
    
    EditRsvGrp = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvGrp = CreateObject("HainsSchedule.Schedule")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrRsvGrpCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�\��Q�e�[�u���ǂݍ���
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        If objRsvGrp.SelectRsvGrp(mstrRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTIme, vntRptEndTIme, vntLead, vntStrDayId, vntEndDayId, vntRsvSetGrpCd) = False Then
        If objRsvGrp.SelectRsvGrp(mstrRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTIme, vntRptEndTIme, vntLead, vntStrDayId, vntEndDayId, vntRsvSetGrpCd, vntIsOpenGrp) = False Then
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW�i�R�[�X��{���j
        txtRsvGrpCd.Text = mstrRsvGrpCd
        txtRsvGrpName.Text = vntRsvGrpName
        txtStrTime.Text = IIf(vntStrTime > 0, Format(vntStrTime, "0000"), "")
        txtEndTime.Text = IIf(vntEndTIme > 0, Format(vntEndTIme, "0000"), "")
        txtRptEndTime.Text = IIf(vntRptEndTIme > 0, vntRptEndTIme, "")
        optLead(CInt(vntLead)).Value = True
        txtStrDayId.Text = vntStrDayId
        txtEndDayId.Text = vntEndDayId
        
        For i = 0 To UBound(mstrRsvSetGrpCd)
            If mstrRsvSetGrpCd(i) = vntRsvSetGrpCd Then
                cboRsvSetGrp.ListIndex = i + 1
            End If
        Next i
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        chkIsOpenGrp.Value = IIf(vntIsOpenGrp > 0, vbChecked, vbUnchecked)
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditRsvGrp = Ret
    
    Exit Function

ErrorHandle:

    EditRsvGrp = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �\�񎞃Z�b�g�O���[�v�f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �\�񎞃Z�b�g�O���[�v�f�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditRsvSetGrp() As Boolean

    Dim objFree             As Object   '�ėp���A�N�Z�X�p
    
    Dim vntRsvSetGrpCd      As Variant  '�\�񎞃Z�b�g�O���[�v�R�[�h(�ėp�R�[�h)
    Dim vntRsvSetGrpName    As Variant  '�\�񎞃Z�b�g�O���[�v����(�ėp�t�B�[���h�P)
    Dim lngCount            As Long     '���R�[�h��
    Dim i                   As Long     '�C���f�b�N�X
    
    EditRsvSetGrp = False
    
    cboRsvSetGrp.Clear
    Erase mstrRsvSetGrpCd

    '��̃R���{���쐬
    cboRsvSetGrp.AddItem ""
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    lngCount = objFree.SelectFree(1, "RSVSETGRP", vntRsvSetGrpCd, , , vntRsvSetGrpName)
    
    If lngCount < 0 Then
        MsgBox "�\�񎞃Z�b�g�O���[�v�e�[�u���ǂݍ��ݒ��ɃV�X�e���I�ȃG���[���������܂����B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRsvSetGrpCd(i)
        mstrRsvSetGrpCd(i) = vntRsvSetGrpCd(i)
        cboRsvSetGrp.AddItem vntRsvSetGrpName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    cboRsvSetGrp.ListIndex = 0
    
    EditRsvSetGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �f�[�^�̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �ύX���ꂽ�f�[�^���e�[�u���ɕۑ�����
'
' ���l�@�@ :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then Exit Do
        
        '�\��Q�e�[�u���̓o�^
        If RegistRsvGrp() = False Then Exit Do
        
        '�X�V�ς݂ɂ���
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    

End Function

' @(e)
'
' �@�\�@�@ : �����̃`�F�b�N
'
' �߂�l�@ : TRUE:����AFALSE:�ُ�
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Function CheckInteger(ByRef strExpression As String) As Boolean

    Dim i   As Long
    Dim Ret As Boolean
    
    Ret = True
    
    For i = 1 To Len(strExpression)
        If InStr("0123456789", Mid(strExpression, i, 1)) <= 0 Then
            Ret = False
            Exit For
        End If
    Next i
    
    CheckInteger = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : �o�^�f�[�^�̃`�F�b�N
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�̑Ó������`�F�b�N����
'
' ���l�@�@ :
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim i               As Integer
    
    '��������
    Ret = False
    
    Do
        
        If Trim(txtRsvGrpCd.Text) = "" Then
            MsgBox "�\��Q�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtRsvGrpCd.SetFocus
            Exit Do
        End If

        If CheckInteger(txtRsvGrpCd.Text) = False Then
            MsgBox "�\��Q�R�[�h�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtRsvGrpCd.SetFocus
            Exit Do
        End If

        If Trim(txtRsvGrpName.Text) = "" Then
            MsgBox "�\��Q���̂����͂���Ă��܂���B", vbExclamation, App.Title
            txtRsvGrpName.SetFocus
            Exit Do
        End If
        
        '�J�n���ԃ`�F�b�N
        If Trim(txtStrTime.Text) <> "" Then

            '���l�^�C�v�`�F�b�N
            If CheckInteger(txtStrTime.Text) = False Then
                MsgBox "�J�n���Ԃɂ͐��l�i�����̂S���j����͂��Ă��������B", vbExclamation, App.Title
                txtStrTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtStrTime.Text) <> 0 Then
            
                '�`�F�b�N�p�ɂS���ϊ�
                txtStrTime.Text = Format(Trim(txtStrTime.Text), "0000")
            
                If CInt(Mid((Trim(txtStrTime.Text)), 1, 2)) > 23 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtStrTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtStrTime.Text)), 3, 2)) > 59 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtStrTime.SetFocus
                    Exit Do
                End If

            Else
                txtStrTime.Text = ""
            End If
            
        End If
        
        '�I�����ԃ`�F�b�N
        If Trim(txtEndTime.Text) <> "" Then

            '���l�^�C�v�`�F�b�N
            If CheckInteger(txtEndTime.Text) = False Then
                MsgBox "�I�����Ԃɂ͐��l�i�����̂S���j����͂��Ă��������B", vbExclamation, App.Title
                txtEndTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtEndTime.Text) <> 0 Then
            
                '�`�F�b�N�p�ɂS���ϊ�
                txtEndTime.Text = Format(Trim(txtEndTime.Text), "0000")
            
                If CInt(Mid((Trim(txtEndTime.Text)), 1, 2)) > 23 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtEndTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtEndTime.Text)), 3, 2)) > 59 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtEndTime.SetFocus
                    Exit Do
                End If

            Else
                txtEndTime.Text = ""
            End If
            
        End If
        
        If CLng("0" & txtStrTime.Text) <> 0 And Trim("0" & txtEndTime.Text) <> 0 Then
            If CLng("0" & txtStrTime.Text) > CLng("0" & txtEndTime.Text) Then
                MsgBox "��t���Ԃ̑召�֌W�Ɍ�肪����܂��B", vbExclamation, App.Title
                txtStrTime.SetFocus
                Exit Do
            End If
        End If
        
        '���f��t�I�����ԃ`�F�b�N
        If Trim(txtRptEndTime.Text) <> "" Then

            '���l�^�C�v�`�F�b�N
            If CheckInteger(txtRptEndTime.Text) = False Then
                MsgBox "���f��t�I�����Ԃɂ͐��l�i�����̂S���j����͂��Ă��������B", vbExclamation, App.Title
                txtRptEndTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtRptEndTime.Text) <> 0 Then
            
                '�`�F�b�N�p�ɂS���ϊ�
                txtRptEndTime.Text = Format(Trim(txtRptEndTime.Text), "0000")
            
                If CInt(Mid((Trim(txtRptEndTime.Text)), 1, 2)) > 23 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtRptEndTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtRptEndTime.Text)), 3, 2)) > 59 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    txtRptEndTime.SetFocus
                    Exit Do
                End If
            
            Else
                txtRptEndTime.Text = ""
            End If
            
        End If
        
        '�J�n�����h�c�`�F�b�N
        If Trim(txtStrDayId.Text) <> "" Then
            
            If CheckInteger(txtStrDayId.Text) = False Then
                MsgBox "�J�n����ID�ɂ͐��l(1�`9999)����͂��Ă��������B", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
            
            If CLng(txtStrDayId.Text) <= 0 Then
                MsgBox "�J�n����ID�ɂ͐��l(1�`9999)����͂��Ă��������B", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
            
        End If

        '�I�������h�c�`�F�b�N
        If Trim(txtEndDayId.Text) <> "" Then
            
            '���l�^�C�v�`�F�b�N
            If CheckInteger(txtEndDayId.Text) = False Then
                MsgBox "�I������ID�ɂ͐��l(1�`9999)����͂��Ă��������B", vbExclamation, App.Title
                txtEndDayId.SetFocus
                Exit Do
            End If
            
            If CLng(txtEndDayId.Text) <= 0 Then
                MsgBox "�J�n����ID�ɂ͐��l(1�`9999)����͂��Ă��������B", vbExclamation, App.Title
                txtEndDayId.SetFocus
                Exit Do
            End If
            
        End If
        
        If Trim(txtStrDayId.Text) <> "" And Trim(txtEndDayId.Text) <> "" Then
            If CLng(txtStrDayId.Text) > CLng(txtEndDayId.Text) Then
                MsgBox "����ID�̑召�֌W�Ɍ�肪����܂��B", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
        End If
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        If cboRsvSetGrp.ListIndex <= 0 Then
            MsgBox "�\�񎞂̐ݒ�O���[�v��I�����Ă��������B", vbExclamation, App.Title
            cboRsvSetGrp.SetFocus
            Exit Do
        End If
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : �\��g��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e��\��g�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistRsvGrp() As Boolean

    Dim objSchedule     As Object   '�X�P�W���[�����A�N�Z�X�p
    Dim lngLead         As Long     '�U���Ώ�
    Dim strRsvSetGrpCd  As String   '�\�񎞃Z�b�g�O���[�v�R�[�h
    Dim lngRet          As Long     '�֐��߂�l
    
    On Error GoTo ErrorHandle

    RegistRsvGrp = False

    '�U���Ώۏ��̐ݒ�
    lngLead = 0
    If optLead(1).Value = True Then lngLead = 1

    If cboRsvSetGrp.ListIndex > 0 Then
        strRsvSetGrpCd = mstrRsvSetGrpCd(cboRsvSetGrp.ListIndex - 1)
    End If

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSchedule = CreateObject("HainsSchedule.Schedule")

    '�\��Q�e�[�u�����R�[�h�̓o�^
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    lngRet = objSchedule.RegistRsvGrp( _
'                 IIf(txtRsvGrpCd.Enabled, "INS", "UPD"), _
'                 Trim(txtRsvGrpCd.Text), _
'                 Trim(txtRsvGrpName.Text), _
'                 IIf(Trim(txtStrTime.Text) <> "", Trim(txtStrTime.Text), 0), _
'                 IIf(Trim(txtEndTime.Text) <> "", Trim(txtEndTime.Text), 0), _
'                 IIf(Trim(txtRptEndTime.Text) <> "", Trim(txtRptEndTime.Text), 0), _
'                 lngLead, _
'                 IIf(Trim(txtStrDayId.Text) <> "", Trim(txtStrDayId.Text), 1), _
'                 IIf(Trim(txtEndDayId.Text) <> "", Trim(txtEndDayId.Text), 9999), _
'                 strRsvSetGrpCd _
'             )
    lngRet = objSchedule.RegistRsvGrp( _
                 IIf(txtRsvGrpCd.Enabled, "INS", "UPD"), _
                 Trim(txtRsvGrpCd.Text), _
                 Trim(txtRsvGrpName.Text), _
                 IIf(Trim(txtStrTime.Text) <> "", Trim(txtStrTime.Text), 0), _
                 IIf(Trim(txtEndTime.Text) <> "", Trim(txtEndTime.Text), 0), _
                 IIf(Trim(txtRptEndTime.Text) <> "", Trim(txtRptEndTime.Text), 0), _
                 lngLead, _
                 IIf(Trim(txtStrDayId.Text) <> "", Trim(txtStrDayId.Text), 1), _
                 IIf(Trim(txtEndDayId.Text) <> "", Trim(txtEndDayId.Text), 9999), _
                 strRsvSetGrpCd, _
                 IIf(chkIsOpenGrp.Value = vbUnchecked, 0, 1) _
             )
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####

    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ�\��Q�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistRsvGrp = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistRsvGrp = False
        Exit Function
    End If
    
    mstrRsvGrpCd = Trim(txtRsvGrpCd.Text)
    txtRsvGrpCd.Enabled = (txtRsvGrpCd.Text = "")
    
    RegistRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    RegistRsvGrp = False
    
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub CMDok_Click()
    
    '�f�[�^�K�p�������s���i�G���[���͉�ʂ���Ȃ��j
    If ApplyData() = False Then
        Exit Sub
    End If

    '��ʂ����
    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�t�H�[���vLoad
'
' �@�\���� : �t�H�[���̏����\�����s��
'
' ���l�@�@ :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '�߂�l
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitializeForm

    Do
        
        '�\��g�Z�b�g�O���[�v�̕\���ҏW
        If EditRsvSetGrp() = False Then
            Exit Do
        End If
        
        '�\��g���̕\���ҏW
        If EditRsvGrp() = False Then
            Exit Do
        End If
        
        '�C�l�[�u���ݒ�
        txtRsvGrpCd.Enabled = (txtRsvGrpCd.Text = "")
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        
        txtRsvGrpCd.Enabled = False
        txtRsvGrpName.Enabled = False
        txtStrTime.Enabled = False
        txtEndTime.Enabled = False
        txtRptEndTime.Enabled = False
        optLead(0).Enabled = False
        optLead(1).Enabled = False
        txtStrDayId.Enabled = False
        txtEndDayId.Enabled = False
        cboRsvSetGrp.Enabled = False
    
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Get RsvGrpCd() As Variant

    RsvGrpCd = mstrRsvGrpCd
    
End Property

Friend Property Let RsvGrpCd(ByVal vNewValue As Variant)
    
    mstrRsvGrpCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

