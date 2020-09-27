<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" isELIgnored="false"%>
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
        		$("#name").blur(function(){
        			var name=$(this).val();
        			if(name==""||name==null){
        				$("#validName").addClass("error_msg").html("资费名称不能为空");
        				nameFlag=false;
        				return;
        			}
        			$.post('validName.action',{'name':name},function(data){
        				if(!data){
        					nameFlag=false;
        					$("#validName").addClass("error_msg").html("资费名称重复，请重新输入");
        				}else{
        					nameFlag=true;
        					$("#validName").removeClass("error_msg")
        					.html("50长度的字母、数字、汉字和下划线的组合");
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
                if (type == 1) {
                    inputArray[4].readOnly = true;
                    inputArray[4].value = "";
                    inputArray[4].className += " readonly";
                    inputArray[5].readOnly = false;
                    inputArray[5].className = "width100";
                    inputArray[6].readOnly = true;
                    inputArray[6].className += " readonly";
                    inputArray[6].value = "";
                }
                else if (type == 2) {
                    inputArray[4].readOnly = false;
                    inputArray[4].className = "width100";
                    inputArray[5].readOnly = false;
                    inputArray[5].className = "width100";
                    inputArray[6].readOnly = false;
                    inputArray[6].className = "width100";
                }
                else if (type == 3) {
                    inputArray[4].readOnly = true;
                    inputArray[4].value = "";
                    inputArray[4].className += " readonly";
                    inputArray[5].readOnly = true;
                    inputArray[5].value = "";
                    inputArray[5].className += " readonly";
                    inputArray[6].readOnly = false;
                    inputArray[6].className = "width100";
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
            <div id="save_result_info" class="save_fail">保存失败，表单数据验证失败！</div>
            <form action="addCost" method="post" class="main_form">
                <div class="text_info clearfix"><span>资费名称：</span></div>
                <div class="input_info">
                    <input type="text" id="name" class="width300" name="cost.name" value=""/>
                    <span class="required">*</span>
                    <div id="validName" class="validate_msg_short">50长度的字母、数字、汉字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info fee_type">
                    <input type="radio" name="cost.costType" id="monthly" value="0" onclick="feeTypeChange(1);" />
                    <label for="monthly">包月</label>
                    <input type="radio" name="cost.costType" checked="checked" value="1" id="package" onclick="feeTypeChange(2);" />
                    <label for="package">套餐</label>
                    <input type="radio" name="cost.costType" id="timeBased" value="2" onclick="feeTypeChange(3);" />
                    <label for="timeBased">计时</label>
                </div>
                <div class="text_info clearfix"><span>基本时长：</span></div>
                <div class="input_info">
                    <input type="text" name="cost.baseDuration" value="" class="width100" />
                    <span class="info">小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long">1-600之间的整数</div>
                </div>
                <div class="text_info clearfix"><span>基本费用：</span></div>
                <div class="input_info">
                    <input type="text" name="cost.baseCost" value="" class="width100" />
                    <span class="info">元</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long error_msg">0-99999.99之间的数值</div>
                </div>
                <div class="text_info clearfix"><span>单位费用：</span></div>
                <div class="input_info">
                    <input type="text" name="cost.unitCost" value="" class="width100" />
                    <span class="info">元/小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long error_msg">0-99999.99之间的数值</div>
                </div>
                <div class="text_info clearfix"><span>资费说明：</span></div>
                <div class="input_info_high">
                    <textarea name="cost.descr" class="width300 height70"></textarea>
                    <div class="validate_msg_short error_msg">100长度的字母、数字、汉字和下划线的组合</div>
                </div>                    
                <div class="button_info clearfix">
                    <input type="submit" value="保存" class="btn_save"  />
                    <input type="button" value="取消" class="btn_save" onclick="window.location.href='findCost'" />
                </div>
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
