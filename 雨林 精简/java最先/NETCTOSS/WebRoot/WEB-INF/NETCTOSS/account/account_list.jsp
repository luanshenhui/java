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
           		document.getElementById("account").className="account_on";
           	});
            //删除
            function deleteAccount() {
                var r = window.confirm("确定要删除此账务账号吗？\r\n删除后将不能恢复，且会删除其下属的所有业务账号。");
                document.getElementById("operate_result_info").style.display = "block";
            }
            //开通
            function setStart(id) {
                var r = window.confirm("确定要开通此账务账号吗？");
                if(!r){
                	return;
                }
                $.post(
                	'startAccount',
                	{'id':id},
                	function(data){
                		if(data){
                			alert("开通成功！");
                			var currentPage=$("#currentpage").val();
                			toPage(currentPage);
                		}else{
                			alert("开通失败！");
                		}
                	}
                );
            }
            function setPause(id){
            	 var r = window.confirm("确定要暂停此账务账号吗？");
                if(!r){
                	return;
                }
                $.post(
                	'pauseAccount',
                	{'id':id},
                	function(data){
                		if(data){
                			alert("暂停成功，且已暂停其下属的业务账号！！");
                			var currentPage=$("#currentpage").val();
                			toPage(currentPage);
                		}else{
                			alert("暂停失败！");
                		}
                	}
                );
            }
             function setDelete(id){
            	 var r = window.confirm("确定要删除此账务账号吗？");
                if(!r){
                	return;
                }
                $.post(
                	'deleteAccount',
                	{'id':id},
                	function(data){
                		if(data){
                			alert("删除成功，且已删除其下属的业务账号！！");
                			var currentPage=$("#currentpage").val();
                			toPage(currentPage);
                		}else{
                			alert("删除失败！");
                		}
                	}
                );
            }
            function toPage(currentP){
            	document.getElementById("currentpage").value=currentP;
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
            <form  action="findAccount" method="post">
            	<!-- 追加隐藏域，可提交当前页 -->
            	<s:hidden name="page" id="currentpage"></s:hidden>
                <!--查询-->
                <div class="search_add">                        
                    <div>
                    身份证：<s:textfield name="q.idcardNo" cssClass="text_search"></s:textfield>
                    </div>                            
                    <div>姓名：
                    <s:textfield name="q.realName" cssClass="width70 text_search"></s:textfield>
                    </div>
                    <div>登录名：
                    <s:textfield name="q.loginName" cssClass="text_search"></s:textfield>
                    </div>
                    <div>
                        状态：
                        <s:select list="#{'-1':'全部','0':'开通','1':'暂停','2':'删除'}" name="q.status" cssClass="select_search"></s:select>
                    </div>
                    <div><input type="button" value="搜索" class="btn_search" onclick="toPage(1);"/></div>
                    <input type="button" value="增加" class="btn_add" onclick="location.href='toAdd';" />
                </div>  
                <!--删除等的操作提示-->
                <div id="operate_result_info" class="operate_success">
                    <img src="../images/close.png" onclick="this.parentNode.style.display='none';" />
                    删除成功，且已删除其下属的业务账号！
                </div>   
                <!--数据区域：用表格展示数据-->     
                <div id="data">            
                    <table id="datalist">
                    <tr>
                        <th>账号ID</th>
                        <th>姓名</th>
                        <th class="width150">身份证</th>
                        <th>登录名</th>
                        <th>状态</th>
                        <th class="width100">创建日期</th>
                        <th class="width150">上次登录时间</th>                                                        
                        <th class="width200"></th>
                    </tr>
                      <s:iterator value="accounts">
                      	<tr>
                        <td><s:property value="id"/></td>
                        <td><a href="loadAccount?id=${id}"><s:property value="realName"/></a></td>
                        <td><s:property value="idcardNo"/></td>
                        <td><s:property value="loginName"/> </td>
                        <td>
                        	<s:if test="status==0">开通</s:if>
                        	<s:elseif test="status==1">暂停</s:elseif>
                        	<s:else>删除</s:else>
                        </td>
                        <td><s:property value="createDate"/></td>
                        <td><s:property value="lastLoginTime"/></td>                            
                        <td class="td_modi">
                        	<s:if test="status==0">
                        	<input type="button" value="暂停" class="btn_pause" onclick="setPause(${id});" />
                          
                        	</s:if>
                            <s:elseif test="status==1">
                            	<input type="button" value="开通" class="btn_start" onclick="setStart(${id});" />
                            	 <input type="button" value="修改" class="btn_modify" onclick="location.href='toModify?id=${id}';" />
                            <input type="button" value="删除" class="btn_delete" onclick="setDelete(${id});" />
                            </s:elseif>
                            <s:else></s:else>
                        </td>
                    </tr>
                    </s:iterator>
                </table>
                <p>业务说明：<br />
                1、创建则开通，记载创建时间；<br />
                2、暂停后，记载暂停时间；<br />
                3、重新开通后，删除暂停时间；<br />
                4、删除后，记载删除时间，标示为删除，不能再开通、修改、删除；<br />
                5、暂停账务账号，同时暂停下属的所有业务账号；<br />                
                6、暂停后重新开通账务账号，并不同时开启下属的所有业务账号，需要在业务账号管理中单独开启；<br />
                7、删除账务账号，同时删除下属的所有业务账号。</p>
                </div>                   
                <!--分页-->
                <div id="pages">
                    <a href="javascript:toPage(1);">首页</a>
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
                    <a href="javascript:toPage(${totalPage});">末页</a>
                </div>                    
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
