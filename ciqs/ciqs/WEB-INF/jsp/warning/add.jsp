<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>风险预警</title>
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
		       		$.post("${ctx}/warning/add",{
							good_category:$("#good_category").val(),
							good_type:$("#good_type").val(),
							max_time:$("#max_time").val(),
							min_time:$("#min_time").val(),
							average_time:$("#average_time").val()
					}, function(res) {
						if(res=="success"){
							alert("操作成功");
								window.location.href="/ciqs/warning/warningList";
						}else if(res=="have"){
							alert("货物类别和货物类型重复");
						}
					});
                }
            });
        });
	</script>
    
    <script type="text/javascript">
        function pageUtil(page) {
            $("#warning").attr("action", "/ciqs/warning/warningList?page=" + page);
            $("#warning").submit();
        }
    </script>
</head>
<body class="bg-gary">
<div class="freeze_div_list">
    <div class="title-bg">
        <div class=" title-position margin-auto white">
            <div class="title">
                <span class="font-24px" style="color:white;">预警时长规则维护 /查询</span>
            </div>
            <%@ include file="/WEB-INF/jsp/userinfo.jsp" %>
        </div>
    </div>
</div>
<div class="blank_div_list">
	<div class="margin-auto width-1200" style="height: 50px;margin-top: 20px">当前位置：预警时长规则维护 - 查询</div>
</div>

<div class="margin-auto width-1200  data-box">
    <div class="margin-cxjg">
    <form method="post" action="" id="resForm">
        <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
            <tr class="thead">
                <td height="25" >货物类别:</td>
                <td height="25">贸易类型:</td>
                <td height="25">最小平均时长:</td>
            </tr>
            <tr>
                <td height="25"><input type="text" class="search-input input-440px" style="width:250px"
                                    name="good_type" id="good_type" value=""/></td>
                <td height="25">
	                <select name="good_category" id="good_category"  class="search-input input-440px" style="width:250px">
	                	<option value="0">出口</option>
	                	<option value="1">进口</option>
	                </select>                  
                </td>
                <td height="25"><input type="text" class="search-input input-440px" style="width:250px"
                                      name="min_time"  id="min_time" value=""/></td>
            </tr>
  			<tr class="thead">                
                <td height="25">标准平均时长:</td>
                <td height="25">最大平均时长:</td>
                <td height="25"></td>
            </tr>
             <tr>
                <td height="25"><input type="text" class="search-input input-440px" style="width:250px"
                                         name="average_time" id="average_time" value=""/></td>
                <td height="25"><input type="text" class="search-input input-440px" style="width:250px"
                                         name="max_time" id="max_time" value=""/></td>
                <td height="25"></td>
            </tr>

        </table>
        <div style="text-align: center;margin: auto;margin-top: 10px;width:450px;padding-bottom: 10px;">
			<input type="submit" class="search-btn" style="display: inline" value="确定" />
			<input type="button" class="search-btn" style="display: inline" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
		</form>
    </div>
</div>
<div class="margin-auto width-1200 tips"></div>
</body>
</html>
