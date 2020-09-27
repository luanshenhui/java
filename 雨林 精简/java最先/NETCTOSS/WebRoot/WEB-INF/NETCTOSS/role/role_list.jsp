<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" /> 
        <script language="javascript" type="text/javascript">
            function deleteRole(id,name) {
                var r = window.confirm("确定要删除"+name+"角色吗？");
                if(r){
                	 location.href="deleteRole?id="+id;
                }else{
                	return;
                }
            }
            function toPage(currentP){
            	document.getElementById("currentpage").value=currentP;
            	document.forms[0].submit();
            }
             function load(){
            	document.getElementById("role").className="role_on";
            }
        </script>
    </head>
    <body onload="load();">
        <!--Logo区域开始-->
        <div id="header">
            <img src="../images/logo.png" alt="logo" class="left"/>
            <a href="#">[退出]</a>            
        </div>
        <!--Logo区域结束-->
        <!--导航区域开始-->
         <%@include file="../navigator/navigator.jsp" %>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">
            <form action="findRole" method="post">
				<s:hidden name="page" id="currentpage"></s:hidden>
                <!--查询-->
                <div class="search_add">
                    <input type="button" value="增加" class="btn_add" onclick="location.href='toAddRole';" />
                </div>  
                <!--删除的操作提示-->
                <div id="operate_result_info" class="operate_success">
                    <img src="../images/close.png" onclick="this.parentNode.style.display='none';" />
                    删除成功！
                </div> <!--删除错误！该角色被使用，不能删除。-->
                <!--数据区域：用表格展示数据-->     
                <div id="data">                      
                    <table id="datalist">
                        <tr>                            
                            <th>角色 ID</th>
                            <th>角色名称</th>
                            <th class="width600">拥有的权限</th>
                            <th class="td_modi"></th>
                        </tr>  
                        <s:iterator value="roles">
                        	 <tr>
                            <td><s:property value="id"/></td>
                            <td><s:property value="name"/> </td>
                            <td><s:property value="privilegeName"/> </td>
                            <td>
                                <input type="button" value="修改" class="btn_modify" onclick="location.href='toUpdateRole?id=${id}';"/>
                                <input type="button" value="删除" class="btn_delete" onclick="deleteRole(${id});" />
                            </td>
                        </tr>
                        </s:iterator>                    
                        
                    </table>
                </div> 
                <!--分页-->
                <div id="pages">
        	      <s:if test="page>1">
                    	  <a href="javascript:toPage(${page-1});">上一页</a>
                    </s:if>
                    <s:else>
                    	上一页
                    </s:else>
                    <s:iterator begin="1" end="totalPage" var="p">
                    	<s:if test="page==#p">
                    		<a href="javascript:toPage(<s:property/>);" class="current_page">
                    			<s:property value="#p"/>
                    		</a>
                    	</s:if>
                    	<s:else>
                    		<a href="javascript:toPage(<s:property/>);" >
                    			<s:property value="#p"/>
                    		</a>
                    	</s:else>
                    </s:iterator>
                    <s:if test="page<totalPage">
                    	 <a href="javascript:toPage(${page+1});">下一页</a>
                    </s:if>
                   <s:else>
                   		下一页
                   </s:else>
                </div>
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
