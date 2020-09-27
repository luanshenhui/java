<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- **** head ********************************************************* -->
<div class="dpn-frame-head">
    <table>
        <tr>
            <td><span class="logo" style="width:630px;"> </span></td>
            <td style="font-size: 14px;color: black;margin-top: 30px;a:active{color: black}">
                <%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
            </td>
        </tr>
    </table>
</div>

<div class="dpn-frame-menu">
    <div class="loca">
        <ul class="nav">
            <li>
                <a href="javascript:changeContent('/ciqs/users/findOrganizes');">组织管理</a>
            </li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findUsers');">用户管理</a>
            </li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findRoles');">角色列表</a></li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findAuth');">权限列表</a>
            </li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findRes');">资源列表</a>
            </li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findVisit');">访问列表</a>
            </li>
            <li>
                <a href="javascript:changeContent('/ciqs/users/findUserConf');">访问配置列表</a>
            </li>
        </ul>
    </div>
</div>

<script type="text/javascript">
    function changeContent(targetUrl) {
        if (!targetUrl) {
            return;
        }
       window.location.href=targetUrl;
    }
</script>