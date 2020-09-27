<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>编辑</title>
    <%@ include file="/common/resource_show.jsp" %>
    <style type="text/css">
        input.datepick {
            background: #FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right
        }

        #title_a {
            color: #ccc
        }

        #title_a:hover {
            color: white;
        }

        .box-img-bg {
            background-image: url(../static/show/disc/bg.png);
            box-sizing: border-box;
            width: 1198px;
            height: 164px;
            padding: 0 200px;
            position: absolute;
            display: none;
            font-size: 20px;
            line-height: 35px;
            color: white;
        }

        .box-content-style {
            display: table-cell;
            vertical-align: middle;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        jQuery(function(){
        	//表单验证
            jQuery("#resForm").validate({
                rules : {
                    min_time : {
                    	required : true,
                    	digits : true,
                    	rangelength:[0,2],
                    	min : 0
                    },
                    average_time : {
                    	required : true,
                    	digits : true,
                    	rangelength:[0,2],
                    	min : 0
                    },
                    max_time : {
                    	required : true,
                    	digits : true,
                    	rangelength:[0,2],
                    	min : 0
                    },
                    good_category : {
                    	required : true
                    },
                    good_type : {
                    	required : true,
                    	digits : true,
                    	rangelength:[0,2],
                    	min : 0
                    },
                },
                messages : {
                	good_category : {
	                    required : "必须填写"
                    },
                    good_type : {
	                    required : "必须填写",
	                    digits : "请输入整数",
                    	rangelength: jQuery.format("长度请控制在2位数"),
                    	min : "值不能小于0"
                    },
                    average_time : {
	                    required : "必须填写",
                    	digits : "请输入整数",
                    	rangelength: jQuery.format("长度请控制在2位数"),
                    	min : "值不能小于0"
                    },
                    max_time : {
                    	required : "必须填写",
                    	digits : "请输入整数",
                    	rangelength: jQuery.format("长度请控制在2位数"),
                    	min : "值不能小于0"
                    },
                    min_time : {
                    	required : "必须填写",
                    	digits : "请输入整数",
                    	rangelength: jQuery.format("长度请控制在2位数"),
                    	min : "值不能小于0"
                    }
                },
                errorPlacement : function(error, element) {
                    error.css("color","red").appendTo(element.parent());
                },
                submitHandler : function (form) {
		       		$.post("${ctx}/web/update",{
// 							ruld_id:$("#ruld_id").val(),
// 							good_category:$("#good_category").val(),
// 							good_type:$("#good_type").val(),
// 							max_time:$("#max_time").val(),
// 							min_time:$("#min_time").val(),
// 							average_time:$("#average_time").val()
					}, function(res) {
						if(res=="success"){
							alert("操作成功");
								window.location.href="/ciqs/web/list";
						}else if(res=="have"){
// 							alert("货物类别和货物类型重复");
						}
					});
                }
            });
        });
	</script>
    <script type="text/javascript">
    
   	function dele(){
   	$.post("${ctx}/web/update",{
						tel:$("#tel").val(),
					}, function(res) {
						if(res=="success"){
							alert("操作成功");
								window.location.href="${ctx}/web/list";
						}
					});
   	
   	}
    </script>
</head>
<body class="bg-gary">
<div class="margin-auto width-1200  data-box">
    <div class="margin-cxjg">
    <form method="post" action="" id="resForm">
    <input type="hidden" id="tel" value="${list[0].tel}"/>
        <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
          <c:if test="${not empty list }">
                <c:forEach items="${list}" var="row">
            <tr class="thead">
             	<td>电话</td> 
  				<td>学历</td>
                <td>学校</td>
				<td>姓名</td>
                <td>性别</td>
                <td>年龄</td>
                <td></td>
            </tr>
            <tr>
				<td width="17%" height="90" align="center">${row.tel}</td> 
				<td width="17%" height="90" align="center">${row.xl}</td> 
				<td width="17%" height="90" align="center">${row.sch}</td>
				<td width="17%" height="90" align="center">${row.name}</td>
				<td width="16%" height="90" align="center">${row.sex}</td>
				<td width="16%" height="90" align="center">${row.age}</td>
				<td></td>
            </tr>
  			<tr class="thead">                
                <td>生日</td>
                <td>地址</td>
                <td>户口</td>
                <td>邮箱</td>
                <td>工作履历</td>
                <td>工作意愿</td>
                <td>图片</td>
            </tr>
            <tr>
                <td width="20%" height="90" align="center">${row.borth}</td>
				<td width="20%" height="90" align="center">${row.address}</td>
				<td width="8%" height="90" align="center">${row.city}</td>
				<td width="8%" height="90" align="center">${row.emil}</td>
				<td width="8%" height="90" align="center">${row.workyear}</td>
				<td width="8%" height="90" align="center">${row.desireindustry}</td>
				<td width="20%" height="90" align="center"><img src="${row.image}"  /></td>
            </tr>
            <tr>
            <td colspan="7"></td>
            </tr>
            
			</c:forEach>
			</c:if>
        </table>
        <div style="text-align: center;margin: auto;margin-top: 10px;width:450px;padding-bottom: 10px;">
			<input type="button" class="search-btn"  style="display: inline" onclick="dele()" value="删除"/>
			<input type="button" class="search-btn" style="display: inline" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
		</form>
    </div>
</div>
<div class="margin-auto width-1200 tips"></div>
</body>
</html>
