<%@ LANGUAGE="VBScript" %>
<%
'Program ID   : 
'Program Desc : ���O�A�E�g�������C���^�[�l�b�g�G�N�X�v���[���́u�߂�v�{�^���ɂ����
'               ���O�A�E�g���O�̉�ʂɖ߂邱�Ƃ�h�~���邽�߂ɍ쐬
'Created Date : 2006.4.15
'Created By   : �����l
%>
<%
    Option Explicit
    '�y�[�W�L���b�V���͍s��Ȃ�
    Response.Expires = -1

    '�Z�b�V�����ؒf��ԂƂ��ă��O�C����ʂ�\������
    Session.Abandon

%>
<form name="inputform" method="post" action="/webHains/login.asp"></form>
<script TYPE="text/javascript">
       document.inputform.submit();
</script>
