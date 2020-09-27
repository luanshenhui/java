<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="tip">
<c:if test="${not empty rtn && rtn == 'fail'}">
    <p class="failure">操作失败，请重新尝试</p>
</c:if>
<c:if test="${not empty rtn && rtn == 'succ'}">
    <p class="success">操作成功！</p>
</c:if>
<c:if test="${not empty msg && msg != ''}">
    <p class="message">${msg}</p>
</c:if>
<c:if test="${not empty err && err != ''}">
    <p class="failure">${err}</p>
</c:if>
</div>
