<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" /> 
        <script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
        <script language="javascript" type="text/javascript">
        	$(function(){
        	    $('#admin').removeClass("admin_off").addClass("admin_on");
        	});
            //显示角色详细信息
            function showDetail(flag, a) {
                var detailDiv = a.parentNode.getElementsByTagName("div")[0];
                if (flag) {
                    detailDiv.style.display = "block";
                }
                else
                    detailDiv.style.display = "none";
            }
            //重置密码
            function resetPwd() {
            	//找到所有选中的复选框
            	var checkObjs=$("[input:name='checkAdmin']:checked");
            	if(checkObjs.length==0){
            		alert("至少选择一个");
            		return;
            	}
				var tdObj=checkObjs.parent().next();
				var ids=new Array();
				for(var i=0;i<tdObj.length;i++){
					var id=tdObj.eq(i).html();
					ids.push(id);
				}
				$.post(
					"resetPassword",
					{"ids":ids.toString()},
					function(data){
						if(data){
							alert("密码重置成功");
						}else{
							alert("密码重置失败");
						}
					}
				);
            }
            //删除
            function deleteAdmin(id) {
                var r = window.confirm("确定要删除此管理员吗？");
                if(r){
                	location.href="deleteAdmin?id="+id;
                }else{
                	return;
                }
            }
            //全选
            function selectAdmins(inputObj) {
                var inputArray = document.getElementById("datalist").getElementsByTagName("input");
                for (var i = 1; i < inputArray.length; i++) {
                    if (inputArray[i].type == "checkbox") {
                        inputArray[i].checked = inputObj.checked;
                    }
                }
            }
            function toPage(currentPage){
            	document.getElementById("currentpage").value=currentPage;
            	document.forms[0].submit();
            }
        </script>       
    </head>
    <body>
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
            <form action="findAdmin" method="post">
            	<s:hidden id="currentpage" name="page"></s:hidden>
                <!--查询-->
                <div class="search_add">
                    <div>
                        模块：
                        <s:select list="privileges" listKey="id" listValue="name"
                        emptyOption="-1" name="privilegeId" cssClass="select_search"/>
                    </div>
                    <div>角色：
                    	<s:select list="roles" listKey="id" listValue="name"
                    	emptyOption="-1" name="roleId" cssClass="select_search"></s:select>
				                    </div>
                    <div><input type="button" value="搜索" class="btn_search" onclick="toPage(1);"/></div>
                    <input type="button" value="密码重置" class="btn_add" onclick="resetPwd();" />
                    <input type="button" value="增加" class="btn_add" onclick="location.href='toAddAdmin';" />
                </div>
                <!--删除和密码重置的操作提示-->
                <div id="operate_result_info" class="operate_fail">
                    <img src="../images/close.png" onclick="this.parentNode.style.display='none';" />
                    <span>删除失败！数据并发错误。</span><!--密码重置失败！数据并发错误。-->
                </div> 
                <!--数据区域：用表格展示数据-->     
                <div id="data">            
                    <table id="datalist">
                        <tr>
                            <th class="th_select_all">
                                <input type="checkbox" onclick="selectAdmins(this);" />
                                <span>全选</span>
                            </th>
                            <th>管理员ID</th>
                            <th>姓名</th>
                            <th>登录名</th>
                            <th>电话</th>
                            <th>电子邮件</th>
                            <th>授权日期</th>
                            <th class="width100">拥有角色</th>
                            <th></th>
                        </tr>   
                        <s:iterator value="admins">
                        	<tr>
                            <td><input type="checkbox" name="checkAdmin"/></td>
                            <td><s:property value="id"/></td>
                            <td><s:property value="name"/></td>
                            <td><s:property value="adminCode"/></td>
                            <td><s:property value="telephone"/> </td>
                            <td><s:property value="email"/></td>
                            <td><s:property value="enrollDate"/> </td>
                            <td>
                                <a class="summary"  onmouseover="showDetail(true,this);" onmouseout="showDetail(false,this);">角色信息</a>
                                <!--浮动的详细信息-->
                                <div class="detail_info">
                                   <s:property value="roleName"/>
                                </div>
                            </td>
                            <td class="td_modi">
                                <input type="button" value="修改" class="btn_modify" onclick="location.href='toUpdateAdmin?id=${id}';" />
                                <input type="button" value="删除" class="btn_delete" onclick="deleteAdmin(${id});" />
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
