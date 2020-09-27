<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="../member/commonjsp.js"></script>
<div class="form_template">
<div id="MemberPickSearch" class="list_search">
	<span class="lblKeyword"><s:text name="lblKeyword"></s:text></span><input type="text" id="searchKeyword"/>
    <select id="searchGroupIDs"></select>
	<a id="btnMemberPickSearch"><s:text name="btnSearch"></s:text></a>
</div>
<table>
  <tr>
     <td><select id="select_left" size="20"></select></td>
     <td>
     	<a id="options_right_all" href="#"></a>
        <a id="options_right" href="#"></a>
        <a id="options_left" href="#"></a>
        <a id="options_left_all" href="#"></a>
     </td>
     <td><select id="select_right" size="20"></select></td>
  </tr>
</table>
<div class="operation" style="margin-top:0px;">
	<a id="btnPickMember"><s:text name="btnPickMember"></s:text></a> <a id="btnCancelPickMember"><s:text name="btnCancelOrden"></s:text></a>
</div>
</div>
