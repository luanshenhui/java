<%@ page contentType="text/xml;charset=UTF-8" import="java.util.*" language="java" %>
<%@ include file="/common/taglibs.jsp"%>

<c:if test="${not empty orgList}">
<c:forEach items="${orgList}" var="org">
    <li onselect="this.text.value = '${org.name}'; document.getElementById('orgcode').value = '${org.org_code}'; ">
        <table width="100%"><tr><td  align="left">${org.name}</td>
        <td align="right"><font color="green">${org.org_code}</font></td></tr></table>
    </li>
</c:forEach>
</c:if>