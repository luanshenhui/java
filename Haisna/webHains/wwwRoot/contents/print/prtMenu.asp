<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		������j���[ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���</TITLE>
<STYLE TYPE="text/css">
#container h3 {
border-bottom: 1px solid #999999;
border-left: 10px solid #999999;
width: 625px;
margin: 20px 0 0 10px;
padding: 3px 0 2px 8px;
}

#container ul { 
list-style-type: none; 
margin: 12px 0 15px 20px;
font-size: 120%;
}

#container li {
height: 1.4em;
}

td.prttab { background-color:#ffffff }
</style>

</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
<TR VALIGN="bottom">
<TD COLSPAN="2"><FONT SIZE="+2"><B>���</B></FONT></TD>
</TR>
<TR HEIGHT="2">
<TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
</TR>
</TABLE>

<div id="container">
<h3>���f�������� </h3>
<ul>
  <li><a href="prtAfterPostcard.asp">����N�ڂ͂���</a></li>
  <li><a href="prtFaxPaper.asp">���݂���FAX�p��</a></li>
  <li><a href="prtInvitation.asp">���ꊇ���t�ē�</a></li>
  <li><a href="prtInstructionList.asp">�����ē������t�`�F�b�N���X�g</a></li>
  <li><a href="prtCheckDoubleID.asp">���Q�d�h�c�o�^�`�F�b�N���X�g</a></li>
  <li><a href="prtPatientList.asp">���V���o�^���X�g </a></li>
  <li><a href="prtCsvStudy.asp">�����O�`���[�g�X�^�f�B�p��f�҃��X�gCSV�o��</a></li>
</ul>
<h3>��������</h3>
<ul>
  <li><a href="prtReserveList.asp">���\��҈ꗗ�\</a></li>
  <li><a href="prtConsultCheck.asp">����f�\��҃`�F�b�N�V�[�g</a></li>
  <li><a href="PrtEndoscopeList.asp">����������t�ꗗ</a></li>
  <li><a href="PrtEndoscopeDisinfection.asp">�������������ŗ���</a></li>
  <li><a href="prtNurseCheck.asp">���i�[�X�`�F�b�N���X�g</a></li>
  <li><a href="prtWorkSheetCheck.asp">�����[�N�V�[�g�W����</a></li>
  <li><a href="Payment.asp">�������W���[�i���E�����䒠</a></li>
  <li><a href="prtWorkSheetPatient.asp">�����[�N�V�[�g�l�[�`�F�b�N���X�g</a></li>
  <li><a href="prtPatient.asp">���l�[</a></li>
  <li><a href="prtWomanList.asp">��������f�҃��X�g</a></li>
  <li><a href="prtSpecialList.asp">�����茒�f��f�҃��X�g</a></li>
  <li><a href="prtFollowList.asp">���t�H���[�A�b�v�Ώێ҃��X�g</a></li>
</ul>
<h3>���f���ʊ֘A</h3>
<ul>
  <li><a href="prtWorkSheetLast.asp">�����[�N�V�[�g�O��l�Q�Ɓi�����j</a></li>
  <li><a href="prtEndoscopeCheck.asp">���������`�F�b�N���X�g</a></li>
  <li><a href="prtWarningList_New.asp">���l�ُ�l���X�g</a></li>
  <li><a href="prtReport6.asp">�����я�</a></li>
  <li><a href="prtReportCheckList.asp">�����я��`�F�b�N���X�g</a></li>
  <li><a href="prtPostList.asp">���X�֕���̏�</a></li>
</ul>
<h3>�������</h3>
<ul>
  <li><a href="prtReceivable.asp">��������</a></li>
  <li><a href="prtOrgBill.asp">��������</a></li>
  <li><a href="prtBillCheck.asp">���������`�F�b�N���X�g</a></li>
  <li><a href="prtBillReportCheck.asp">���������`�F�b�N���X�g�i���я��j</a></li>
  <li><a href="prtPaymentList.asp">���c�̓����䒠</a></li>
  <li><a href="prtOrgArrears.asp">�������c�̈ꗗ�\</a></li>
  <li><a href="prtDirectMail.asp">���c�̃_�C���N�g���[��</a></li>
  <!--li><a href="prtcsv.asp">���ԉ�CSV�o��</a></li>
  <li><a href="prtcsvsony.asp">���\�j�[�}�[�P�e�B���OCSV�o��</a></li>
  <li><a href="prtcsvunyu.asp">���O���^�ACSV�o��</a></li>
  <li><a href="prtcsvden.asp">���d��TXT�o��</a></li>
  <li><a href="prtcsvkousei.asp">�������J����CSV�o��</a></li>
  <li><a href="prtcsvaioi.asp">��������������CSV�o��</a></li>
  <li><a href="prtcsvuo.asp">���z�n�s��CSV�o��</a></li>
  <li><a href="prtcsvNomura.asp">���W���i�쑺暌��`���jFD�o�� </a></li-->
  <!--li><a href="prtcsvNissay.asp">���j�b�Z�C���aCSV�o�� </a></li-->
  <li><a href="prtcsvOrgJudCount.asp">����������ʐl��CSV�o�� </a></li>
  <li><a href="prtcsvOrgjudrsl.asp">���c�̕ʔ��茋��CSV�o�� </a></li>
  <li><a href="prtcsvBasicInfo.asp">���c�̕ʎ�f�ҁi���f��{���jCSV�o�� </a></li>
  <!--li><a href="prtcsvCityGrp.asp">���V�e�B�O���[�v���f���ʎ捞�pCSV�o��</a></li-->
  <li><a href="prtcsvSpecialXML.asp">�����茒�f���ڌ��f����XML�ϊ��pCSV�o�́@�@�B</a></li>
  <li><a href="prtcsvSpecialDir.asp">�����茒�f���ڌ��f����CSV�o�́i��a�����`���j�@�A</a></li>
  <li><a href="prtcsvNTTData.asp">�����H���t�H�[�}�b�g���f����CSV�o�́i�m�s�s�f�[�^�`���j�@�C</a></li>
  <li><a href="prtcsvKensin.asp">���c�̌��f���zCSV�o��</a></li>
  <li></li>
  <li><a href="prtcsvResidence.asp">�����H�����W�f���X�񋟗pCSV�o��</a></li>

</ul>
<h3>�c�̌_��֘A</h3>
<ul>
  <li><a href="prtCompanyConduct.asp">���_��c�̒����[</a></li>
  <li><a href="prtcsvCompany.asp">���c�̕ʌ_��Z�b�g���CSV�o��</a></li>
</ul>
<h3>���v�֘A</h3>
<ul>
  <li><a href="prtDockStatistics.asp">���l�ԃh�b�N�Ǘ�ʐl�����v</a></li>
  <li><a href="prtCrsOption2.asp">���I�v�V�����R�[�X�̗��p��</a></li>
  <li><a href="prtConsultConditions.asp">����f�ҏ�</a></li>
  <li><a href="prtGFConditions.asp">���s�������t���{��</a></li>
  <li><a href="prtOrgConsultCount.asp">���c�̕ʗ\���f�l�����v</a></li>
  <li><a href="prtOrgConsultPay.asp">���c�̕ʗ\���f�������v</a></li>
  <li><a href="prtCompany.asp">���J���p�j�[�v���t�@�C��</a></li>
  <li><a href="prtRsvMngDay.asp">���\��Ǘ��\�iDay�j</a></li>
  <li><a href="prtRsvMngWeekly.asp">���\��Ǘ��\�iWeekly�j</a></li>
  <li><a href="prtRsvMngMonthly.asp">���\��Ǘ��\�iMonthly�j</a></li>
  <li><a href="prtJHEPconsult.asp">�����{�������f��w��</a></li>
  <li><a href="prtAneiho.asp">���J����ē����v</a></li>
  <li><a href="prtXrecord.asp">���Ǝ˘^</a></li>
  <li><a href="prtCreateCsvClog.asp">���c�̊����ҏo��</a></li>
  <li><a href="prtXsituationsMonth.asp">���w����f�󋵁i��)</a></li>
  <li><a href="prtXsituationsYear.asp">���w����f�󋵁i�N)</a></li>
</ul>
<h3>������O</h3>
<ul>
  <li><a href="dispReportLog.asp">��������O</a></li>
</ul>
</div>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>