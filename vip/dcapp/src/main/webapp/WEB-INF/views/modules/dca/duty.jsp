<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="/static/assets/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/assets/css/detail.css" />

<div class="wrap">
    <div class="container">
        <div class="t-box">
            <div class="index left">
                <a href="${ctx}/index/homepageInfo"><i></i><span class="index-bg"></span><span>首页</span></a>
            </div>

            <div class="t-box-title left">监管职责</div>
			<input type="hidden" id="powerId" value="0101">
            <!-- <div class="right btn-group">
                <ul class="btn">
                    <li class="prev-btn"><span></span><a href="#" ><i class="left-arrow"></i></a></li>
                    <li class="next-btn"><span></span><a href="#" ><i class="right-arrow"></i></a></li>
                </ul>
            </div> -->
        </div>
        <div class="clear"></div>
        <div class="detail-box">
             <div class="img">
               <img src="/static/assets/images/duty-title.jpg" alt="监管职责"/>
               <div class="img-box h787"><img src="/static/assets/images/duty.jpg" alt="监管职责"/></div>
           </div>
        </div>
        <!-- <div class="clear"></div>
        <div class="footer2">截至<span data-id="closingTime"></span></div> -->

    </div>
</div>