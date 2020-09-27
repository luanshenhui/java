<%@page pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />       
    	<script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
    	<script type="text/javascript">
    		$(function(){
					document.getElementById("cost").className="fee_on";
    		});
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
            <form action="" method="" class="main_form">
                <div class="text_info clearfix"><span>资费ID：</span></div>
                <div class="input_info"><input type="text" class="readonly" readonly="readonly" value="${cost.id}" /></div>
                <div class="text_info clearfix"><span>资费名称：</span></div>
                <div class="input_info"><input type="text" class="readonly" readonly="readonly" value="${cost.name}"/></div>
                <div class="text_info clearfix"><span>资费状态：</span></div>
                <div class="input_info">
                    <select class="readonly" disabled="disabled">
                    	<c:choose>
                    	<c:when test="${cost.status==0}">
                        <option selected="selected">开通</option>
                        </c:when>
                        <c:when test="${cost.status==1}">
                        <option selected="selected">暂停</option>
                        </c:when>
                        <c:when test="${cost.status==2}">
                        <option selected="selected">删除</option>
                        </c:when>
                        </c:choose>
                    </select>                        
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info fee_type">
                	<c:choose>
                	<c:when test="${cost.costType=='0'}">
                    <input type="radio" name="radFeeType" checked="checked" id="monthly" disabled="disabled" />
                    <label for="monthly">包月</label>
                   	</c:when>
                   	<c:when test="${cost.costType=='1'}">
                    <input type="radio" name="radFeeType" checked="checked" id="package" disabled="disabled" />
                    <label for="package">套餐</label>
                    </c:when>
                    <c:when test="${cost.costType=='2'}">
                    <input type="radio" name="radFeeType" checked="checked" id="timeBased" disabled="disabled" />
                    <label for="timeBased">计时</label>
                    </c:when>
                    <c:otherwise>
                     <input type="radio" name="other" checked="checked" id="other" disabled="disabled" />
                    <label for="other">其他</label>
                    </c:otherwise>
                    </c:choose>
                </div>
                <div class="text_info clearfix"><span>基本时长：</span></div>
                <div class="input_info">
                    <input type="text" class="readonly" readonly="readonly"  value="${cost.baseDuration}"  />
                    <span>小时</span>
                </div>
                <div class="text_info clearfix"><span>基本费用：</span></div>
                <div class="input_info">
                    <input type="text"  class="readonly" readonly="readonly" value="${cost.baseCost}" />
                    <span>元</span>
                </div>
                <div class="text_info clearfix"><span>单位费用：</span></div>
                <div class="input_info">
                    <input type="text"  class="readonly" readonly="readonly" value="${cost.unitCost}" />
                    <span>元/小时</span>
                </div>
                <div class="text_info clearfix"><span>创建时间：</span></div>
                <div class="input_info"><input type="text"  class="readonly" readonly="readonly" value="${cost.createTime}" /></div>      
                <div class="text_info clearfix"><span>启动时间：</span></div>
                <div class="input_info"><input type="text"  class="readonly" readonly="readonly" value="${cost.startTime}" /></div>      
                <div class="text_info clearfix"><span>资费说明：</span></div>
                <div class="input_info_high">
                    <textarea class="width300 height70 readonly" readonly="readonly">${cost.descr}</textarea>
                </div>                    
                <div class="button_info clearfix">
                    <input type="button" value="返回" class="btn_save" onclick="location.href='findCost.action';" />
                </div>
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
