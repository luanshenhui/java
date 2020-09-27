<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script src="<%=request.getContextPath() %>/pages/coder/listjsp.js"></script>
<style type="text/css">
 table#border{ border-top:#e2e3ea 1px solid; border-left:#e2e3ea 1px solid; } 
 table#border td{ border-bottom:#e2e3ea 1px solid; border-right:#e2e3ea 1px solid;text-align: center; } 
 h3{height:30px;}
</style>
<div STYLE="margin: 0px auto;text-align: center;width:600px;">
<h3 align="center" id="coder_title"><s:text name="coder_title"></s:text></h3>
<table width="600" border="0" align="center" cellspacing="0"  id="border">  
  <tr>
    <td rowspan="2" id="coder_kgml"><s:text name="coder_kgml"></s:text></td>
    <td height="30" id="coder_kgmlbh"><s:text name="coder_kgmlbh"></s:text></td>
    <td>&lt;--&gt;</td>
    <td id="coder_hlbh"><s:text name="coder_hlbh"></s:text></td>
  </tr>
  <tr>
    <td height="60">
        <input type="text" name="retailerCodeT" id="retailerCodeT" size="12"/>
    </td>
    <td>
        <input type="button" name="redCode" id="redCode" value="&#60;&#60;" />
        <input type="button" name="retailerCode" id="retailerCode" value="&#62;&#62;" />
    </td>
    <td>
      <input type="text" name="redCodeT" id="redCodeT" size="12"/>
    </td>
  </tr>
  <tr>
    <td rowspan="2" id="coder_fzks"><s:text name="coder_fzks"></s:text></td>
    <td height="30" id="coder_scks"><s:text name="coder_scks"></s:text></td>
    <td>&lt;--&gt;</td>
    <td id="coder_jbbh"><s:text name="coder_jbbh"></s:text></td>
  </tr>
  <tr>
    <td height="60">
      <input type="text" name="modelT" id="modelT" size="12"/>
    </td>
    <td>        
    	<input type="button" name="basiscoding" id="basiscoding" value="&#60;&#60;" />
        <input type="button" name="model" id="model" value="&#62;&#62;" />
	</td>
    <td>
      <input type="text" name="basiscodingT" id="basiscodingT" size="12"/>
    </td>
  </tr>
</table><br><br>
<h3 align="center" id="coder_jscxBOM"><s:text name="coder_jscxBOM"></s:text></h3>
<table width="600" border="0"  align="center" cellspacing="0"  id="border">
  <tr>
    <td rowspan="2" id="coder_jsBOM"><s:text name="coder_jsBOM"></s:text></td>
    <td height="50"><s:label value="%{getText('coder_ks')}"></s:label>
      <input type="text" name="model2T" id="model2T" size="12"/>
    </td>
    <td><s:label value="%{getText('coder_ml')}"></s:label>
      <input type="text" name="fabricsT" id="fabricsT" size="12"/>
    </td>
    <td>
     <input type="button" name="bom" id="bom" value="GO"/>
    </td>
  </tr>
  <tr>
    <td height="70" colspan="3">
   	  <textarea name="showbom" id="showbom" style="width:390px;height:70px;resize:none;"></textarea>
    </td>
  </tr>
</table>
</div>