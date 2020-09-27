<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加</title>
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
        
        .tdCls{
        	width:20%;
        	height:60px;
        }
    </style>
    <script type="text/javascript">
        jQuery(function(){
        	//表单验证
            jQuery("#resForm").validate({
                rules : {
                    borth : {
                    	required : true,
                    	digits : true,
                    	rangelength:[0,8],
                    	min : 0
                    },
                },
                messages : {
                    borth : {
	                    required : "必须填写",
	                    digits : "请输入整数",
                    	rangelength: jQuery.format("长度请控制在8位数"),
                    	min : "值不能小于0"
                    }
                },
                errorPlacement : function(error, element) {
                    error.css("color","red").appendTo(element.parent());
                },
                submitHandler : function (form) {
		       		$.post("${ctx}/web/updateUserOne",{
			       		phone:$("#phone").val(),
			       		xl:$("#xl").val(),
			       		midetel:$("#midetel").val(),
			       		id:$("#id").val(),
			       		borth:$("#borth").val(),
			       		name:$("#name").val(),
			       		personName:$("#personName").val(),
			       		hukou:$("#hukou").val(),
			       		city:$("#city").val(),
			       		content:$("#content").val(),
			       		age:$("#age").val()
					}, function(res) {
						if(res=="success"){
							alert("操作成功");
							parent.location.reload();
						}
					});
                }
            });
        });
	</script>
</head>
<body>
    <form method="post" action="" id="resForm">
    <div style="width:100%;text-align:center;padding-top:5px;">
    	<input name="id" value="${id}" type="hidden" id="id" readonly="readonly"/>
    	<div style="width:100%">序号<c:out value="${id}"></c:out></div>
    </div>
        <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0" style="margin: 0px 40px 0px 40px">
            <tr class="thead">
             	<td>最终电话</td> 
                <td class="tdCls" align="center"><input  name="phone" id="phone" value="${obj.phone}"/></td>
  				<td>学历</td>
				<td class="tdCls" align="center"><input  name="xl"  id="xl"  value="${obj.xl}"/></td>
            </tr>
            <tr>
                <td>中间电话</td>
				<td class="tdCls" align="center"><input name="midetel" id="midetel" value="${obj.midetel}"/></td>
				<td>姓名</td>
				<td class="tdCls" align="center"><input id="name" value="${obj.name}"/></td>
			</tr>
            <tr>
                <td>生日</td>
				<td class="tdCls" align="center"><input class="required" name="borth" id="borth" value="${obj.borth}"/></td>
                <td>住址</td>
				<td class="tdCls" align="center"><input id="city" name="city" value="${obj.city}"/></td>
            </tr>
             <tr>
                <td>职业</td>
				<td class="tdCls" align="center"><input  name="age" id="age" value="${obj.age}"/></td>
                <td>中间姓名</td>
				<td class="tdCls" align="center"><input id="personName" value="${obj.personName}"/></td>
            </tr>
            <tr>
                <td>个人信息</td>
				<td class="tdCls" align="center"><input  name="hukou" id="hukou"  value="${obj.hukou}"/></td>
                <td>内容</td>
				<td class="tdCls" align="center"><input id="content" value="${obj.content}"/></td>
            </tr>
        </table>
         <div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
	        <input type="submit" value="submit" class="mbutton"/>
         </div>
		</form>
</body>
</html>
