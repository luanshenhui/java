<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib uri="/struts-tags" prefix="s" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" /> 
         <script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
        <script language="javascript" type="text/javascript">
        	//分页
            function toPage(currpage){
            	document.getElementById("currpage").value = currpage;
            	document.forms[0].submit();
            }
            //显示角色详细信息
            function showDetail(flag, a) {
                var detailDiv = a.parentNode.getElementsByTagName("div")[0];
                if (flag) {
                    detailDiv.style.display = "block";
                }
                else
                    detailDiv.style.display = "none";
            }
            //删除
            function deleteService(id) {
                var r = window.confirm("确定要删除此账务账号吗？\r\n删除后将不能恢复，且会删除其下属的所有业务账号。");
                if(r){
                	alert(id);
                	location.href='del?id='+id;
                }
                document.getElementById("operate_result_info").style.display = "block";
            }
            //开通
            function start(id){
            	var r = window.confirm("确定要开通账务账号吗？");
            	if(!r){
            		return;
            	}
            	$.post(
            		"startAccount",{"id":id},function(date){
            			var ok = data;
            			if(ok){
            				alert("开通成功!");
            				var currpage = $("#currpage").val();
            				toPage(currpage);
            			}else{
            				alert("开通失败!");
            			}
            		}
            	);
            }
            //暂停
            function pause(id){
            	var r = window.confirm("确定要暂停账务账号吗？");
            	if(!r){
            		return;
            	}
            	$.post(
            		"pauseAccount",{"id":id},function(data){
            			var ok = data;
            			if(ok){
            				alert("暂停成功！");
            				var currpage = $("#currpage").val();
            				toPage(currpage);
            			}else{
            				alert("暂停失败！");
            			}
            		}
            	); 
            }
            //开通或暂停
            function setState() {
                var r = window.confirm("确定要开通此业务账号吗？");
                document.getElementById("operate_result_info").style.display = "block";
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
        <div id="navi">                        
            <ul id="menu">
                <li><a href="../index.html" class="index_off"></a></li>
                <li><a href="../role/role_list.html" class="role_off"></a></li>
                <li><a href="../admin/admin_list.html" class="admin_off"></a></li>
                <li><a href="../cost/costFee" class="fee_off"></a></li>
                <li><a href="../account/findAccount" class="account_off"></a></li>
                <li><a href="../service/findService" class="service_on"></a></li>
                <li><a href="../bill/bill_list.html" class="bill_off"></a></li>
                <li><a href="../report/report_list.html" class="report_off"></a></li>
                <li><a href="../user/user_info.html" class="information_off"></a></li>
                <li><a href="../user/user_modi_pwd.html" class="password_off"></a></li>
            </ul>            
        </div>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">
            <form action="findService" method="post">
                <s:hidden name="page" id="currpage"></s:hidden>
                <!--查询-->
                <div class="search_add">                        
                    <div>OS 账号：<input type="text" name="os_username" value="" class="width100 text_search" /></div>                            
                    <div>服务器 IP：<input type="text" name="unix_host" value="" class="width100 text_search" /></div>
                    <div>身份证：<input type="text" name="idcard_no" value="" class="text_search" /></div>
                    <div>状态：
                         <select name="status" class="select_search">
                            <option value="-1">全部</option>
                            <option value="0">开通</option>
                            <option value="1">暂停</option>
                            <option value="2">删除</option>
                        </select>
                    </div>
                    <div><input type="submit" value="搜索" class="btn_search" /></div>
                    <input type="button" value="增加" class="btn_add" onclick="location.href='serviceAdd';" />
                </div>  
                <!--删除的操作提示-->
                <div id="operate_result_info" class="operate_success">
                    <img src="../images/close.png" onclick="this.parentNode.style.display='none';" />
                    删除成功！
                </div>   
                <!--数据区域：用表格展示数据-->     
                <div id="data">            
                    <table id="datalist">
                    <tr>
                        <th class="width50">业务ID</th>
                        <th class="width70">账务账号ID</th>
                        <th class="width150">身份证</th>
                        <th class="width70">OS 账号</th>
                        <th>服务器IP</th>
                        <th class="width50">状态</th>
                        <th class="width100">服务器 IP</th>
                        <th class="width100">资费</th>                                                        
                        <th class="width200"></th>
                    </tr>
                    <s:iterator value="list">
                    <tr>
                        <td><a href="service_detail.html" title="查看明细"><s:property value="id"/></a></td>
                        <td><s:property value="account_id"/></td>
                        <td><s:property value="idcard_no"/></td>
                        <td><s:property value="os_username"/></td>
                        <td><s:property value="unix_host"/></td>
                        <s:if test="status==0">         
                       		 <td>开通</td>
                        </s:if>
                        <s:elseif test="status==1">
                        	 <td>暂停</td>
                        </s:elseif>
                        <td><s:property value="name"/></td>
                        <td>
                            <a class="summary"  onmouseover="showDetail(true,this);" onmouseout="showDetail(false,this);">包 20 小时</a>
                            <!--浮动的详细信息-->
                            <div class="detail_info">
                               <s:property value="descr"/>
                            </div>
                        </td>                            
                        <s:if test="status==0">                      
	                        <td class="td_modi">
	                            <input type="button" value="暂停" class="btn_pause" onclick="pause(<s:property value="id"/>);" />
	                         <!--   <input type="button" value="修改" class="btn_modify" onclick="location.href='accountUp?id=<s:property value="id"/>';" />
	                            <input type="button" value="删除" class="btn_delete" onclick="deleteService('<s:property value="id"/>');" /> --> 
	                        </td>
                        </s:if>  
                        <s:elseif test="status==1">                      
	                        <td class="td_modi">
	                            <input type="button" value="开通" class="btn_start" onclick="start(<s:property value="id" />);" />
	                            <input type="button" value="修改" class="btn_modify" onclick="location.href='serviceUp?id=<s:property value="id"/>';" />
	                            <input type="button" value="删除" class="btn_delete" onclick="deleteService('<s:property value="id"/>');" />
	                        </td>
                        </s:elseif>  
                    </tr>
                    </s:iterator>
                                                                                   
                </table>                
                <p>业务说明：<br />
                1、创建即开通，记载创建时间；<br />
                2、暂停后，记载暂停时间；<br />
                3、重新开通后，删除暂停时间；<br />
                4、删除后，记载删除时间，标示为删除，不能再开通、修改、删除；<br />
                5、业务账号不设计修改密码功能，由用户自服务功能实现；<br />
                6、暂停和删除状态的账务账号下属的业务账号不能被开通。</p>
                </div>                    
                <!--分页-->
                <div id="pages">
                    <s:if test="page==1">
                    <a href="#">首页</a>
        	        <a href="#">上一页</a>
        	     </s:if>
        	     <s:else>
        	     	<a href="#">首页</a>
        	     	<a href="javascript:toPage(<s:property value="page-1"/>)">上一页</a>
        	     </s:else>
        	     <s:iterator begin="1" end="totalPage" var="p">
        	    	<s:if test="#p==page">
        	    		<a href="javascript:toPage(<s:property />)" class="current_page"><s:property/></a>
        	    	</s:if>
        	    	<s:else>
        	    		<a href="javascript:toPage(<s:property/>)"><s:property/></a>
        	    	</s:else>
        	    </s:iterator>
        	    <s:if test="page==totalPage">
        	        <a href="#">下一页</a>
        	        <a href="#">末页</a>
        	    </s:if>
        	    <s:else>
        	    	  <a href="javascript:toPage(<s:property value="page+1"/>)">下一页</a>
        	    	  <a href="#">末页</a>
        	    </s:else>
                </div>                    
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
           
        </div>
    </body>
</html>
