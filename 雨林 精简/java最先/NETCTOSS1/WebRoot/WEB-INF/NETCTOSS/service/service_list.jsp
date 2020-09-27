<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
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
            	document.getElementById("service").className="service_on";
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
            //删除
            function deleteAccount(id) {
                var r = window.confirm("确定要删除此业务账号吗？删除后将不能恢复。");
            	if(!r){
            		return;
            	}
            	$.post(
            	'deleteService',
            	{'id':id},
            	function(data){
            		if(data){
            			alert('删除成功');
            			var currentPage=$('#currentpage').val();
            			toPage(currentPage);
            		}else{
            			alert('删除失败');
            		}
            	}
            	);
            }
            //暂停
            function setPause(id){
            	var r = window.confirm("确定要暂停此业务账号吗？");
            	if(!r){
            		return;
            	}
            	$.post(
            	'pauseService',
            	{'id':id},
            	function(data){
            		if(data){
            			alert('暂停成功');
            			var currentPage=$('#currentpage').val();
            			toPage(currentPage);
            		}else{
            			alert('暂停失败');
            		}
            	}
            	);
            }
            function setStart(id) {
                var r = window.confirm("确定要开通此业务账号吗？");
            	if(!r){
            		return;
            	}
            	$.post(
            	'startService',
            	{'id':id},
            	function(data){
            		if(data==null){
            			alert('开通成功');
            			var currentPage=$('#currentpage').val();
            			toPage(currentPage);
            		}else{
            			alert(data);
            		}
            	}
            	);
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
            <form action="findService" method="post">
            	<s:hidden id="currentpage" name="page"></s:hidden>
                <!--查询-->
                <div class="search_add">                        
                    <div>OS 账号：
                    <s:textfield name="q.osUsername" cssClass="width100 text_search"></s:textfield>
					</div>                            
                    <div>服务器 IP：
                    <s:textfield name="q.unixHost" cssClass="width100 text_search"></s:textfield>
                    </div>
                    <div>身份证：
                    <s:textfield name="q.idcardNo" cssClass="width100 text_search"></s:textfield>
                    </div>
                    <div>状态：
                    <s:select name="q.status" list="#{'-1':'全部','0':'开通','1':'暂停','2':'删除'}" cssClass="select_search" />
                    </div>
                    <div><input type="button" value="搜索" class="btn_search" onclick="toPage(1);"/></div>
                    <input type="button" value="增加" class="btn_add" onclick="location.href='toAddService';" />
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
                        <th class="width70">姓名</th>
                        <th>OS 账号</th>
                        <th class="width50">状态</th>
                        <th class="width100">服务器 IP</th>
                        <th class="width100">资费</th>                                                        
                        <th class="width200"></th>
                    </tr>
                    <s:iterator value="service">

                    	<tr>
                        <td>
<!--               id=${id}大括号里id时元素标签的id？         -->
                        <a href="loadService?id=${id}" title="查看明细"><s:property value="id"/></a>
                        </td> 
                        <td><s:property value="accountId"/></td>
                        <td><s:property value="idcardNo"/></td>
                        <td><s:property value="realName"/></td>
                        <td><s:property value="osUsername"/></td>
                        <td>
                        	<s:if test="status==0">开通</s:if>
                        	<s:elseif test="status==1">暂停</s:elseif>
                        	<s:else>删除</s:else>
                        </td>
                        <td><s:property value="unixHost"/></td>
                        <td>
                            <a class="summary"  onmouseover="showDetail(true,this);" onmouseout="showDetail(false,this);">
                            	<s:property value="costName"/>
                            </a>
                            <!--浮动的详细信息-->
                            <div class="detail_info">
                               <s:property value="descr"/>
                            </div>
                        </td>                            
                        <td class="td_modi">
                        	<s:if test="status==0">
                            <input type="button" value="暂停" class="btn_pause" onclick="setPause(<s:property value='id'/>);" />
                        	</s:if>
                        	<s:elseif test="status==1">
<!--                        		<input type="button" value="开通" class="btn_start" onclick="setStart(<s:property value='id'/>);" />-->
<!--                            	<input type="button" value="修改" class="btn_modify" onclick="location.href='toUpdateService?id=${id}';" />-->
<!--                            	<input type="button" value="删除" class="btn_delete" onclick="deleteAccount(<s:property value='id'/>);" />-->
                        	</s:elseif>
                        	<s:else>
                        	</s:else>
                        </td>
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
                    <a href="javascript:toPage(1);">首页</a>
                    <s:if test="page>1">
                    	<a href="javascript:toPage(<s:property value='page-1'/>)">上一页</a>
                    </s:if>
                    <s:else>
                    	上一页
                    </s:else>
                    <s:iterator begin="1" end="totalPage" var="p">
                    	<s:if test="page==#p">
<!--  if   toPage方法触发事件  <s:property/>显示内容     	第一个<s:property/>就是id==id括号里传的参数-->
                    		<a href="javascript:toPage(<s:property/>);" class="current_page">
                    			<s:property />
                    		</a>
                    	</s:if>
                    	
                    	<s:else>
                    		<a href="javascript:toPage(<s:property/>);" >
                    			<s:property />
                    		</a>
                    	</s:else>
                    </s:iterator>
                    <s:if test="page<totalPage">
                    	 <a href="javascript:toPage(<s:property value="page+1"/>);">下一页</a>
                    </s:if>
                    <s:else>
                    	下一页
                    </s:else>
                    <a href="javascript:toPage(<s:property value='totalPage'/>)">末页</a>
                </div>                    
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
      
</html>
