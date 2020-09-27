<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<div class="tip">

    <c:if test="${not empty succInfo }">
    	<p class="success">${succInfo }</p>
    </c:if>
    <c:if test="${not empty errorInfo  }">
    	<p class="failure">${errorInfo }</p>
    </c:if>
    
    <c:if test="${not empty param.succMsg }">
    	<p class="success">${param.succMsg }</p>
    </c:if>
    <c:if test="${not empty param.errorMsg  }">
    	<p class="failure">${param.errorMsg }</p>
    </c:if>
    
    <c:if test="${param.param_msg=='Y' }">
    	<p class="success">操作成功</p>
    </c:if>
    <c:if test="${param.param_msg=='N' }">
    	<p class="failure">操作失败</p>
    </c:if>
    
</div>