<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/cuplayer/blockui.js"></script>
<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->
<div id="CuPlayerMiniV" style="display:none; cursor:default;width:620px;height:500px;position:fixed;margin:-100px 0px 0px -100;z-index:300000;">
    <div id="CuPlayer" style="position: fixed;left:100px;top:100px;margin:-100px 0px 0px -100;z-index:300000;"> 
        <strong>提示：您的Flash Player版本过低！</strong>
    </div>
    <div id="CuPlayerClose" style="width:30px;margin-top:410px;margin-left:295px;background:white;cursor: pointer;" onclick="hideVideo()">关闭</div>
</div>
<script type="text/javascript">
    function CuPlayerMiniV(path){
        var so = new SWFObject("<%=request.getContextPath()%>/cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
        so.addParam("allowfullscreen","true");
        so.addParam("allowscriptaccess","always");
        so.addParam("wmode","opaque");
        so.addParam("quality","high");
        so.addParam("salign","lt");
        so.addVariable("CuPlayerFile","<%=request.getContextPath()%>/showVideo?imgPath="+path);
        so.addVariable("CuPlayerImage","<%=request.getContextPath()%>/cuplayer/Images/flashChangfa2.jpg");
        so.addVariable("CuPlayerLogo","<%=request.getContextPath()%>/cuplayer/Images/Logo.png");
        so.addVariable("CuPlayerShowImage","true");
        so.addVariable("CuPlayerWidth","600");
        so.addVariable("CuPlayerHeight","400");
        so.addVariable("CuPlayerAutoPlay","false");
        so.addVariable("CuPlayerAutoRepeat","false");
        so.addVariable("CuPlayerShowControl","true");
        so.addVariable("CuPlayerAutoHideControl","false");
        so.addVariable("CuPlayerAutoHideTime","6");
        so.addVariable("CuPlayerVolume","80");
        so.addVariable("CuPlayerGetNext","false");
        so.write("CuPlayer");
    }
    function showVideo(path){
//     path="201712/20171212/V_SP_F_D_67_20171212101514013.mp4";//好用
// 	   path="201712/20171220/V_BGSC_CZ_JL_20171220113457999.mp4";//不好用
        var leftPx = (jQuery(document.body).width() - jQuery("#CuPlayerMiniV").width()) / 2;
        jQuery("#CuPlayerMiniV").css("left", leftPx);
        jQuery("#CuPlayer").css("left", leftPx);
        var topPx = (jQuery(document.body).height() - jQuery("#CuPlayerMiniV").height()) / 2;
        jQuery("#CuPlayerMiniV").css("top", topPx);
        jQuery("#CuPlayer").css("top", topPx);
        jQuery.blockUI({
            message : jQuery('#CuPlayerMiniV')
        });
        CuPlayerMiniV(path);
    }
    function hideVideo(){
        jQuery.unblockUI();
    }
</script>
