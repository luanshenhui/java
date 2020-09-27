<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>食品备案</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
	function fileSubmit(){
		var filepath = $("#myfile").val();
		if(filepath == ''){
			alert("请选择一个Excel文件!");
			return;
		}
		var type = filepath.substring(filepath.lastIndexOf('.')+1,filepath.length);
		if(type == 'xls'){
			$("#uploadForm").attr("action","<%=request.getContextPath()%>/expFoodPOF/createPsy?type=2");
			$("#uploadForm").submit();
		}else{
			alert("请选择一个xls文件!");
			return;
		}
	}
		
	jQuery(document).ready(function(){
		$(".user-info").css("color","white");
	});
	
	function getPath(obj)    
	{    
	  if(obj)    
	    {    
	   
	    if (window.navigator.userAgent.indexOf("MSIE")>=1)    
	      {    
	        obj.select();    
	   
	      return document.selection.createRange().text;    
	      }    
	   
	    else if(window.navigator.userAgent.indexOf("Firefox")>=1)    
	      {    
	      if(obj.files)    
	        {    
	   
	        return obj.files.item(0).getAsDataURL();    
	        }    
	      return obj.value;    
	      }    
	    return obj.value;    
	    }    
	}    
</script>

</head>
<body>
<div class="dpn-frame-head">
        <table>
        	<tr>
        		<td>
        		<span class="logo" style="width:630px;">
        		</span>
        		</td>
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
                    <a href="javascript:void();">人员随机</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/expFoodPOF/psyList2">评审员管理</a>
                </li>
            </ul>
        </div>
    </div>
	<div class="dpn-content">
		<div class="crumb">
			 当前位置：<a href="#">出口食品生产企业备案核准</a>
			&gt;<a href="<%=request.getContextPath()%>/expFoodPOF/psyList">评审员管理</a>&gt;<span class="tpinfo">新增</span>
		</div>
		<div class="search">
			<div class="main" style="background-image:none">
				<form action="" method="post" enctype="multipart/form-data" id="uploadForm">
					<table>
						<tr>	
							<th style="width:200px;font-size: 15px;"><div style="margin-top: 15px;">选择文件:</div></th>
							<td style="height:52px;">
								<input id="myfile" type="file" name="file" style="margin-left: 43px;margin-top: 15px;margin-bottom: 10px"/>
								<input id="filepath" type="hidden" name="filepath"/>
							</td>
						</tr>
						<tr>
							<th align="right"></th>		
							<td style="height:52px;text-align:center;margin-top:50px;">
			    				<button id="upload" style="margin-top:-25px;" onclick="fileSubmit()">提交</button>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
