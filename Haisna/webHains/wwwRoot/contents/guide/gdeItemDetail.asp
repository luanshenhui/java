<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������ڐ��� (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const RSLTYPE_0 = 0			'���ʃ^�C�v�i���l�j�̒l
Const RSLTYPE_5 = 5			'���ʃ^�C�v�i�v�Z�j�̒l

Dim strItemCd				'�������ڃR�[�h
Dim strSuffix				'�T�t�B�b�N�X
Dim strCsCd					'�R�[�X�R�[�h
Dim strCslDateYear			'��f���i�N�j
Dim strCslDateMonth			'��f���i���j
Dim strCslDateDay			'��f���i���j
Dim strAge					'�N��
Dim strGender				'����

Dim objItem					'�������ڃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objStdValue				'��l�A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strItemName				'�������ږ�
Dim strItemEName			'�p�ꍀ�ږ�
Dim strClassName			'�������ޖ���
Dim lngRslque				'���ʖ�f�t���O
Dim strRslqueName			'���ʖ�f�t���O����
Dim lngItemType				'���ڃ^�C�v
Dim strItemTypeName			'���ڃ^�C�v����
Dim lngResultType			'���ʃ^�C�v
Dim strResultTypeName		'���ʃ^�C�v����

Dim lngHistoryCount			'�����Ǘ����R�[�h����
Dim strUnit					'�P��
Dim lngFigure1				'����������
Dim lngFigure2				'����������
Dim strMaxValue				'�ő�l
Dim strMinValue				'�ŏ��l

Dim lngAgeFlg				'��l�����̔N��Ǘ��L���i0:��,1:�L�j
Dim lngGenderFlg			'��l�����̐��ʊǗ��L���i0:��,1:�L�j
Dim strArrCsCd				'�R�[�X�R�[�h(�z��)
Dim strArrCsName			'�R�[�X��(�z��)
Dim strArrGender			'����(�z��)
Dim strArrStrAge			'�J�n�N��(�z��)
Dim strArrEndAge			'�I���N��(�z��)
Dim strArrLowerValue		'�����l(�z��)
Dim strArrUpperValue		'����l(�z��)
Dim strArrStdFlg			'��l�t���O(�z��)
Dim strArrStdFlgColor		'��l�t���O�\���F(�z��)
Dim strArrJudCd				'����R�[�h(�z��)
Dim strArrHealthPoint		'�w���X�|�C���g(�z��)

Dim blnRetCd1				'���^�[���R�[�h
Dim blnRetCd2				'���^�[���R�[�h
Dim lngCount				'����

Dim strDispHistoryCount		'�ҏW�p�̗����Ǘ���

Dim strDispItemName			'�ҏW�p�̌������ږ�
Dim strDispItemEName		'�ҏW�p�̉p�ꍀ�ږ�
Dim strDispClassName		'�ҏW�p�̌������ޖ���
Dim strDispRslque			'�ҏW�p�̌��ʖ�f�t���O
Dim strDispRslqueName		'�ҏW�p�̌��ʖ�f�t���O����
Dim strDispItemType			'�ҏW�p�̍��ڃ^�C�v
Dim strDispItemTypeName		'�ҏW�p�̍��ڃ^�C�v����
Dim strDispResultType		'�ҏW�p�̌��ʃ^�C�v
Dim strDispResultTypeName	'�ҏW�p�̌��ʃ^�C�v����

Dim strDispUnit				'�ҏW�p�̒P��
Dim strDispFigure1			'�ҏW�p�̐���������
Dim strDispFigure2			'�ҏW�p�̏���������
Dim strDispMaxValue			'�ҏW�p�̍ő�l
Dim strDispMinValue			'�ҏW�p�̍ŏ��l

Dim strDispCsCd				'�R�[�X�R�[�h
Dim strDispCsName			'�R�[�X��
Dim strDispGender			'����
Dim strDispStrAge			'�J�n�N��
Dim strDispEndAge			'�I���N��
Dim strDispLowerValue		'�����l
Dim strDispUpperValue		'����l
Dim strDispStdFlg			'��l�t���O
Dim strDispStdFlgColor		'��l�t���O�\���F
Dim strDispJudCd			'����R�[�h
Dim strDispHealthPoint		'�w���X�|�C���g

Dim blnConditionFlg			'�K�p�����w��t���O(True:�R�[�X�A�N��A���ʎw�肠��AFalse:�w��Ȃ�)
Dim blnTableEndFlg			'�e�[�u���I���t���O(True:�e�[�u���I���AFalse:�p��)
Dim lngDisp					'��l�K�p�����\������p
Dim i, j					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strItemCd       = Request("itemCd") & ""
strSuffix       = Request("suffix") & ""
strCsCd         = Request("csCd") & ""
strCslDateYear  = Request("cslDateYear") & ""
strCslDateYear  = IIf(strCslDateYear = "", Year(Date), strCslDateYear)
strCslDateMonth = Request("cslDateMonth") & ""
strCslDateMonth = IIf(strCslDateMonth = "", Month(Date), strCslDateMonth)
strCslDateDay   = Request("cslDateDay") & ""
strCslDateDay   = IIf(strCslDateDay = "", Day(Date), strCslDateDay)
strAge          = Request("age") & ""
strGender       = Request("gender") & ""

'�K�p�����w��t���O�̐ݒ�
If strCsCd <> "" And strAge <>"" And strGender <> "" Then
	blnConditionFlg = True
Else
	blnConditionFlg = False
End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������ڐ���</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<%
	'�������ڂ̊�{���A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
	Set objItem     = Server.CreateObject("HainsItem.Item")
	Set objStdValue = Server.CreateObject("HainsStdValue.StdValue")

	Do
		'�������������݂��Ȃ��ꍇ�͉������Ȃ�
		If IsEmpty(strItemCd) Or IsEmpty(strSuffix) Or IsEmpty(strCsCd) Then
%>
			<BR><BR>
			<BLOCKQUOTE>
<%
			Exit Do
		End If

		'�������ڂ̊�{�����擾
		blnRetCd1 = objItem.SelectItemHeader(strItemCd, strSuffix, _
											 strItemName, strItemEName, strClassName, _
											 lngRslque, strRslqueName, _
											 lngItemType, strItemTypeName, _
											 lngResultType, strResultTypeName _
											)

		'�������ڊ�{���̕ҏW
		If blnRetCd1 = True Then

			'�������ڊ�{���̎擾
			strDispItemName       = RTrim(strItemName)
			strDispItemEName      = RTrim(strItemEName)
			strDispClassName      = RTrim(strClassName)
			strDispRslque         = CStr(lngRslque)
			strDispRslqueName     = RTrim(strRslqueName)
			strDispItemType       = CStr(lngItemType)
			strDispItemTypeName   = RTrim(strItemTypeName)
			strDispResultType     = CStr(lngResultType)
			strDispResultTypeName = RTrim(strResultTypeName)

			'�������ڊ�{���̕ҏW
%>
			<FONT SIZE="+2"><B><%= strDispItemName %></B></FONT>
<%
			'�p�ꍀ�ږ��͋󔒂łȂ����̂ݕ\��
			If strDispItemEName <> "" Then
%>
				(<%= strDispItemEName %>)
<%
			End If
%>
			<BR><BR>
			<BLOCKQUOTE>
			<B>�������ڊ�{���</B><BR><BR>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="262">
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">���ڃR�[�h</TD>
					<TD NOWRAP><%= strItemCd %>-<%= strSuffix %></TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">����</TD>
					<TD NOWRAP><%= strDispClassName %>�i<%= strDispRslqueName %>�j</TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">�������ڃ^�C�v</TD>
					<TD NOWRAP><%= strDispItemTypeName %></TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">�������ʃ^�C�v</TD>
					<TD NOWRAP><%= strDispResultTypeName %></TD>
				</TR>
				<TR>
					<TD NOWRAP COLSPAN="2">�@</TD>
				</TR>
<%
			'�������ڂ̗��������擾
			blnRetCd2 = objItem.SelectItemHistory(strItemCd, strSuffix, _
												  strCslDateYear, strCslDateMonth, strCslDateDay, _
												  lngHistoryCount, strUnit, _
												  lngFigure1, lngFigure2, _
												  strMaxValue, strMinValue _
												 )

			'�������͌��ʃ^�C�v�����l�܂��͌v�Z���ڂ̎��̂ݕ\��
			If lngResultType = RSLTYPE_0 Or lngResultType = RSLTYPE_5  Then

				'�K�p�����͗����Ǘ����s���Ă��鎞�̂ݕ\��
				If lngHistoryCount > 1 Then
%>
					<TR>
						<TD NOWRAP COLSPAN="2">��f���F<FONT COLOR="#ff6600">
							<B><%= strCslDateYear %>�N<%= strCslDateMonth %>��<%= strCslDateDay %>��</B>
							</FONT>�ɓK�p�����ݒ�l</TD>
					</TR>
<%
				End If

				'�������͊Y����f���̃��R�[�h�������ł������̂ݕ\��
				If blnRetCd2 = True Then
					'�������ڗ������̎擾
					strDispUnit     = RTrim(strUnit)
					strDispFigure1  = CStr(lngFigure1)
					strDispFigure2  = CStr(lngFigure2)
					strDispMaxValue = RTrim(strMaxValue)
					strDispMinValue = RTrim(strMinValue)
	
					'�������ڊ�{���̕ҏW
%>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">�P��</TD>
						<TD NOWRAP><%= strDispUnit %></TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">����</TD>
						<TD NOWRAP>������<%= strDispFigure1 %>���A������<%= strDispFigure2 %>��</TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">���͍ő�l</TD>
						<TD NOWRAP><%= strDispMaxValue %></TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">���͍ŏ��l</TD>
						<TD NOWRAP><%= strDispMinValue %></TD>
					</TR>
<%
				End If
%>
				<TR>
					<TD NOWRAP COLSPAN="2">�@</TD>
				</TR>
<%
			End If

			'�����Ǘ����̕ҏW(0�ȉ���0�Ƃ���)
			strDispHistoryCount = CStr(IIf(lngHistoryCount - 1 < 0, 0, lngHistoryCount - 1))
%>
			</TABLE>
			<FONT COLOR="#666666">���������ڂ̗����Ǘ���=<B><%= strDispHistoryCount %></B></FONT><BR><BR>
			<HR WIDTH="450" ALIGN="left">
			<BR>
			<B>��l�֘A���</B><BR><BR>
<%

			'�������ڂ̊�l�����擾
			lngCount = objStdValue.SelectItemStdValue(strItemCd, strSuffix, strCsCd, _
													  strCslDateYear, strCslDateMonth, strCslDateDay, _
													  strAge, strGender, _
													  lngHistoryCount, lngAgeFlg, lngGenderFlg, _
													  strArrCsCd, strArrCsName, _
													  strArrGender, strArrStrAge, strArrEndAge, _
													  strArrLowerValue, strArrUpperValue, _
													  strArrStdFlg, strArrStdFlgColor, _
													  strArrJudCd, strArrHealthPoint)

			'�R�[�X�A��f���N��A���ʂ����ׂĎw�肳��Ă���Ƃ��͓K�p�����̕\��������s��
			If blnConditionFlg Then

				'�K�p�����̕\������
				lngDisp = 0
		
				'��f���K�p�����͗����Ǘ����s���Ă��鎞�̂ݕ\��
				If lngHistoryCount > 1 Then
%>
				��f���F<FONT COLOR="#ff6600"><B><%= strCslDateYear %>�N<%= strCslDateMonth %>��<%= strCslDateDay %>��</B></FONT>�@
<%
					lngDisp = 1
				End If
		
				'�N��K�p�����͗����Ǘ����s���Ă��鎞�̂ݕ\��
				If lngAgeFlg = 1 Then
%>
				��f���N��F<FONT COLOR="#ff6600"><B><%= strAge %>��</B></FONT>�@
<%
					lngDisp = 1
				End If

				'���ʓK�p�����͗����Ǘ����s���Ă��鎞�̂ݕ\��
				If lngGenderFlg = 1 Then
%>
				<FONT COLOR="#ff6600"><B><%= IIf(strGender = "1", "�j��", IIf(strGender = "2", "����", "(�s��)")) %></B></FONT>
<%
					lngDisp = 1
				End If
		
				'�K�p�����̕\������
				If lngDisp = 1 Then
%>
				�ɓK�p�����ݒ�l<BR>
<%
				End If

			End If

			'���R�[�h�������Ƃ�
			If lngCount = 0 Then
%>
			<BR>
			<FONT COLOR="#666666">����l�̗����Ǘ���=<B>0</B></FONT><BR>
			<BR>
<%				
				Exit Do
			End If

			'�������ڊ�l���̕ҏW�J�n
			j = 0
			For i = 0 To lngCount - 1

				'�w�b�_�[���̕ҏW
				If j = 0 Then

					'�w�b�_�[���̎擾
					strDispCsCd    = RTrim(strArrCsCd(i))
					strDispCsName  = IIf(RTrim(strArrCsName(i)) = "", "�i���ʁj", RTrim(strArrCsName(i)))
					strDispGender  = RTrim(strArrGender(i))

					'�w�b�_�[���o��(�R�[�X�C�N��C���ʖ��w�莞)
					If Not blnConditionFlg Then
%>
						�R�[�X�F<FONT COLOR="#ff6600"><B><%= strDispCsCd %>�@<%= strDispCsName %></B></FONT>�@���ʁF<FONT COLOR="#ff6600"><B><%= strDispGender %></B></FONT><BR>
<%
					End If

					'�e�[�u���w�b�_�[���o��
%>
					<TABLE BORDER="1" CELLPADDING="1" CELLSPACING="1">
						<TR BGCOLOR="#eeeeee">
							<TD NOWRAP ALIGN="right">No</TD>
							<TD NOWRAP ALIGN="center">�N��</TD>
<%
							Select Case lngResultType

								'�萫�̏ꍇ
								Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
									<TD NOWRAP>��������</TD>
<%
								'���̓^�C�v�̏ꍇ
								Case RESULTTYPE_SENTENCE
%>
									<TD NOWRAP>��������</TD>
									<TD NOWRAP>��������</TD>
<%
								'��L�ȊO
								Case Else
%>
									<TD NOWRAP ALIGN="right">�����l</TD>
									<TD NOWRAP ALIGN="center">&nbsp;</TD>
									<TD NOWRAP>����l</TD>
<%
							End Select
%>
							<TD NOWRAP>��l�t���O</TD>
							<TD NOWRAP>����</TD>
							<TD NOWRAP>�w���X�|�C���g</TD>
						</TR>
<%
				End If

				'�������ڊ�l���̎擾
				strDispStrAge      = RTrim(strArrStrAge(i))
				strDispEndAge      = RTrim(strArrEndAge(i))
				strDispLowerValue  = RTrim(strArrLowerValue(i))
				strDispUpperValue  = RTrim(strArrUpperValue(i))
				strDispStdFlg      = RTrim(strArrStdFlg(i))
				strDispStdFlgColor = RTrim(strArrStdFlgColor(i))
				strDispJudCd       = RTrim(strArrJudCd(i))
				strDispHealthPoint = RTrim(strArrHealthPoint(i))

				'�������ڊ�l���̕ҏW
%>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right"><%= CStr(j + 1) %></TD>
					<TD NOWRAP>
						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
							<TR>
								<TD NOWRAP ALIGN="right"><%= IIf(strDispStrAge = "", "�@", strDispStrAge) %></TD>
								<TD NOWRAP ALIGN="center">�`</TD>
								<TD NOWRAP><%= IIf(strDispEndAge = "", "�@", strDispEndAge) %></TD>
							</TR>
						</TABLE>
					</TD>
<%
					Select Case lngResultType

						'�萫�̏ꍇ
						Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
							<TD NOWRAP><%= strDispLowerValue %></TD>
<%
						'���̓^�C�v�̏ꍇ
						Case RESULTTYPE_SENTENCE
%>
							<TD NOWRAP><%= strDispLowerValue %></TD>
							<TD NOWRAP><%= strDispUpperValue %></TD>
<%
						'��L�ȊO
						Case Else
%>
							<TD NOWRAP ALIGN="right"><%= IIf(strDispLowerValue = "", "�@", strDispLowerValue) %></TD>
							<TD NOWRAP ALIGN="center">�`</TD>
							<TD NOWRAP><%= IIf(strDispUpperValue = "", "�@", strDispUpperValue) %></TD>
<%
					End Select
%>
					<TD NOWRAP><%= IIf(strDispStdFlgColor = "", "", "<FONT COLOR=" & strDispStdFlgColor & ">") %>
						<B><%= IIf(strDispStdFlg = "", "�@", strDispStdFlg) %></B>
						<%= IIf(strDispStdFlgColor = "", "", "</FONT>") %></TD>
					<TD NOWRAP><%= IIf(strDispJudCd = "", "�@", strDispJudCd) %></TD>
					<TD NOWRAP><%= IIf(strDispHealthPoint = "", "�@", strDispHealthPoint) %></TD>
				</TR>
<%
				'�ŏI�s���邢�͎��f�[�^�ƃR�[�X�C���ʂ��ς�鎞�e�[�u���I���t���O���Z�b�g
				blnTableEndFlg = False
				If i = lngCount - 1 Then
					blnTableEndFlg = True
				Else
					If RTrim(strArrCsCd(i + 1))   <> strDispCsCd   Or _
					   RTrim(strArrGender(i + 1)) <> strDispGender Then
						blnTableEndFlg = True
					End If
				End If

				'�e�[�u���I��
				If blnTableEndFlg Then
%>				
			</TABLE>
			<BR>
<%
					'�����Ǘ����̕ҏW(0�ȉ���0�Ƃ���)
					If blnConditionFlg Then
						strDispHistoryCount = CStr(IIf(lngHistoryCount - 1 < 0, 0, lngHistoryCount - 1))
%>
			<FONT COLOR="#666666">����l�̗����Ǘ���=<B><%= strDispHistoryCount %></B></FONT><BR>
			<BR>
<%
					End If
					j = 0
				Else
					j = j + 1
				End If

			Next

		'�������ڊ�{��񂪑��݂��Ȃ��ꍇ�͉������Ȃ�
		Else
%>
			<BR><BR>
			<BLOCKQUOTE>
<%
		End If
	
		Exit Do
	Loop

	Set objItem = Nothing

%>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>

	</BLOCKQUOTE>
</BODY>
</HTML>
