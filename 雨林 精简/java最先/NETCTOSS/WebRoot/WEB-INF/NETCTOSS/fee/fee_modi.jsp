<%@page pageEncoding="utf-8"%>
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
        		document.getElementById("cost").className="fee_on";
        		var nameFlag=false;
        		$("#costName").blur(function(){
        			var id=$("#costId").val();
        			var name=$(this).val();
        			if(name==""||name==null){
        				$("#nameMsg").addClass("error_msg").text("资费名称不能为空");
        				nameFlag=false;
        				return;
        			}
        			$.post('validModiName',{'id':id,'name':name},function(data){
        				if(!data){
        					nameFlag=true;
        					$("#nameMsg").removeClass("error_msg").text("50长度的字母、数字、汉字和下划线的组合");
        				}else{
        					nameFlag=false;
        					$("#nameMsg").addClass("error_msg").text("资费名称重复，请重新输入");
        				}
        			});
        		});
        			$("form").submit(function(){
        			showResult();
        			return nameFlag;
        		});
        		  //保存结果的提示
            function showResult() {
                showResultDiv(nameFlag);
                window.setTimeout(function(){
                	$("#save_result_info").hide();
                }, 3000);
            }
            function showResultDiv(flag) {
            	//alert(flag);
                var divResult =$("#save_result_info");
                if (!flag){
                	 divResult.css('display','block');
                	 return;
                }else{
                	divResult.css('display','none');
                }
            }
        	});
            
            //切换资费类型
            function feeTypeChange(type) {
                var inputArray = document.getElementById("main").getElementsByTagName("input");
                if (type == 0) {
                    inputArray[5].readOnly = true;
                    inputArray[5].value = "";
                    inputArray[5].className += " readonly";
                    inputArray[6].readOnly = false;
                    inputArray[6].className = "width100";
                    inputArray[7].readOnly = true;
                    inputArray[7].className += " readonly";
                    inputArray[7].value = "";
                }
                else if (type == 1) {
                    inputArray[5].readonly = false;
                    inputArray[5].className = "width100";
                    inputArray[6].readonly = false;
                    inputArray[6].className = "width100";
                    inputArray[7].readonly = false;
                    inputArray[7].className = "width100";
                }
                else if (type == 2) {
                    inputArray[5].readOnly = true;
                    inputArray[5].value = "";
                    inputArray[5].className += " readonly";
                    inputArray[6].readOnly = true;
                    inputArray[6].value = "";
                    inputArray[6].className += " readonly";
                    inputArray[7].readOnly = false;
                    inputArray[7].className = "width100";
                }
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
            <div id="save_result_info" class="save_fail">保存失败，表单验证有误</div>
            <form action="modify_cost" method="post" class="main_form">
                <div class="text_info clearfix"><span>资费ID：</span></div>
                <div class="input_info">
                <s:textfield id="costId" cssClass="readonly" readonly="true" name="cost.id"/>
              	</div>
                <div class="text_info clearfix"><span>资费名称：</span></div>
                <div class="input_info">
                	<s:textfield id="costName" name="cost.name" cssClass="width300"/>
                    <span class="required">*</span>
                    <div id="nameMsg" class="validate_msg_short">50长度的字母、数字、汉字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info fee_type">
                  <s:radio list="#{'0':'包月','1':'套餐','2':'计时'}"
                  name="cost.costType" onclick="feeTypeChange(this.value);"/>
                </div>
                <div class="text_info clearfix"><span>基本时长：</span></div>
                <div class="input_info">
                	<s:textfield name="cost.baseDuration" cssClass="width100"/>
                    <span class="info">小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long">1-600之间的整数</div>
                </div>
                <div class="text_info clearfix"><span>基本费用：</span></div>
                <div class="input_info">
                	<s:textfield name="cost.baseCost" cssClass="width100"/>
                    <span class="info">元</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long">0-99999.99之间的数值</div>
                </div>
                <div class="text_info clearfix"><span>单位费用：</span></div>
                <div class="input_info">
                	<s:textfield name="cost.unitCost" cssClass="width100"/>
                    <span class="info">元/小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long">0-99999.99之间的数值</div>
                </div>   
                <div class="text_info clearfix"><span>资费说明：</span></div>
                <div class="input_info_high">
                	<s:textarea cssClass="width300 height70" name="cost.descr"/>
                   
                    <div class="validate_msg_short">100长度的字母、数字、汉字和下划线的组合</div>
                </div>                    
                <div class="button_info clearfix">
                    <input type="submit" value="保存" class="btn_save" />
                    <input type="button" value="取消" class="btn_save" onclick="location='findCost.action';" />
                </div>
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
