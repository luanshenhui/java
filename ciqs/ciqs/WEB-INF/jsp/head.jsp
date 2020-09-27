<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.dpn.com.cn/dpn" prefix="dpn"%>
    <div class="dpn-frame-head">
        <span class="logo">
            <a href="<dpn:path path="/page/wel" />"><img src="<dpn:path path="/static/dec/images/dpn.logo.jpg" />" /></a>
        </span>
        <span class="tollbar">
            <span id="sso_header_user_name">${user.name}</span>&nbsp;&nbsp;[<span id="sso_header_orga_name">口岸物流网有限公司</span>]&nbsp;&nbsp;<a id="header_config" href="javascript:void(0);" target="_blank">设置</a>&nbsp;|&nbsp;<a id="header_help" href="javascript:void(0);">帮助</a>&nbsp;|&nbsp;<a id="header_login" href="<dpn:path path="/login/login"/>">登录</a>&nbsp;|&nbsp;<a id="header_exit" href="<dpn:path path="/login/logout"/>">退出</a>
        </span>
        <span class="jump">
            <select id="sso_products"></select>
        </span>
    </div>
    <script type="text/javascript" src="http://apollo.dpn.com.cn/sso/sso.js"></script>
    <script type="text/javascript">
        addProdAutoSwitch("sso_products", "BLANK");
        var ssoHeaderUserNameNode = document.getElementById("sso_header_user_name");
        var ssoHeaderOrgaNameNode = document.getElementById("sso_header_orga_name");
        if (document.all) {
            var ssoHeaderUserName = ssoHeaderUserNameNode.innerText;
            var ssoHeaderOrgaName = ssoHeaderOrgaNameNode.innerText;
            var ssoHeaderNameSumLength = ssoHeaderUserName.length + ssoHeaderOrgaName.length;
            if (ssoHeaderNameSumLength > 15) {
                if (ssoHeaderUserName.length > 8) {
                    ssoHeaderUserNameNode.innerText = ssoHeaderUserName.substring(0, 6) + "...";
                    ssoHeaderOrgaNameNode.innerText = ssoHeaderOrgaName.substring(0, 6) + "...";
                } else {
                    ssoHeaderOrgaNameNode.innerText = ssoHeaderOrgaName.substring(0, (ssoHeaderOrgaName.length - (ssoHeaderNameSumLength - 15) - 2)) + "...";
                }
            }
        } else {
            var ssoHeaderUserName = ssoHeaderUserNameNode.textContent;
            var ssoHeaderOrgaName = ssoHeaderOrgaNameNode.textContent;
            var ssoHeaderNameSumLength = ssoHeaderUserName.length + ssoHeaderOrgaName.length;
            if (ssoHeaderNameSumLength > 15) {
                if (ssoHeaderUserName.length > 8) {
                    ssoHeaderUserNameNode.textContent = ssoHeaderUserName.substring(0, 6) + "...";
                    ssoHeaderOrgaNameNode.textContent = ssoHeaderOrgaName.substring(0, 6) + "...";
                } else {
                    ssoHeaderOrgaNameNode.textContent = ssoHeaderOrgaName.substring(0, (ssoHeaderOrgaName.length - (ssoHeaderNameSumLength - 15) - 2)) + "...";
                }
            }
        }
    </script>