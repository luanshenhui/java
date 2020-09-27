<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
	<title>行政执法全过程监管平台</title>
	<link rel="stylesheet" type="text/css" href="static/index/css/normalize.css" />
	<link rel="stylesheet" type="text/css" href="static/index/css/demo.css" />
	<link rel="stylesheet" type="text/css" href="static/index/css/component.css" />
	<script src="static/index/js/demo.js"></script>
</head>
<body style="background-image: url(static/index/img/NAV-bg.png); background-repeat:repeat-x; background-color:#e6e6e6;">
<!-- Code Start -->
<div style="width:100%; height:80px; padding-top:25px;"><div class="loge" style="width:600px; float:left; padding-left:30px;">
            <img src="static/index/img/logo.png" />
        <img src="static/index/img/name.png" />
        </div>
         <div style="width:160px; float:right; padding-right:40px;"><table border="0" cellpadding="0" cellspacing="0" style="font-size:12px; color:#FFF;">
          <tr>
            <td width="60" height="70" align="center" valign="middle"><a href="index.jsp"><img src="static/index/img/home.png" width="33" height="33" border="0" title="返回首页"/></a></td>
            <td width="60" height="70" align="center" valign="middle"><a href="common/dpnPage"><img src="static/index/img/ICON1.png" width="33" height="33" border="0" title="操作平台"/></a></td>
            <td width="60" height="70" align="center" valign="middle"><a href="login/logout"><img src="static/index/img/ICON3.png" width="33" height="33" border="0" title="退出登录"/></a></td>
          </tr>
</table></div></div>
<div class="container">
    <div class="fullname" style="100%">

    </div>
  <div class="grid" >
        <figure class="effect-lily">
            <img src="static/index/img/1.jpg" alt="img01"/>
            <figcaption >
                <div class="mainname" style="display: block">
                    <h2 style="color: #000000;font-size: 20px;font-weight:600;margin-bottom: 5px;margin-top: -85px;opacity: 1">行政确认</h2>
                </div>
                <div style="padding-top:20px;">
                <h2>行政确认</h2>
                
                <a href="affirm/showtransports_jsp" style="margin-top: 10px;">进出境货轮检疫</a>
                <a href="mailSteamer/showenforcementprocess">进出境邮轮检疫</a>
                <a href="mail/findMail">进境邮寄物检疫</a>
                <a href="Belongings/Intercepe">进出境旅客携带物检疫</a>
                <a href="origplace/origList">原产地证书签发</a>
                <a href="quartn/list">隔离、留验与就地诊验</a>
                <a href="billlading/billladingList">动植物产品及废料</a>
                </div>
            </figcaption>
        </figure>
        <figure class="effect-lily">
            <img src="static/index/img/2.jpg" alt="img02"/>
            <figcaption  style="height:35%">
                <div class="PERMISSION">
                    <h2 style="color: #000000;font-size: 20px;font-weight:600;margin-bottom: 5px;margin-top: -85px;opacity: 1">行政许可</h2>
                </div>
                <div style="padding-top:20px;">
                <h2>行政许可</h2>
                
                <a href="expFoodPOF/expFoodList" style="margin-top: 10px;margin-left: -2px">出口食品生产企业备案核准</a>
                <a href="cp/findLists" style="margin-top: 10px;margin-left: -2px">口岸卫生许可证核发</a>
                </div>
            </figcaption>
        </figure>
        <figure class="effect-lily">
            <img src="static/index/img/3.jpg" alt="img07"/>
            <figcaption style="height:35%">
                <div class="INSPECT">
                    <h2 style="color: #000000;font-size: 20px;font-weight:600;margin-bottom: 5px;margin-top: -85px;opacity: 1">行政检查</h2>
                </div>
                <div style="padding-top:20px;">
                <h2>行政检查</h2>
                
                <a href="expFoodProd/list" style="margin-top: 5px;text-align: left">出口食品生产企业监督检查</a>
                </div>
            </figcaption>
        </figure>
        <figure class="effect-lily">
            <img src="static/index/img/4.jpg" alt="img04"/>
            <figcaption style="height:35%">
                <div class="PUNISH">
                    <h2 style="color: #000000;font-size: 20px;font-weight:600;margin-bottom: 5px;margin-top: -85px;opacity: 1">行政处罚</h2>
                </div>
                <div style="padding-top:20px;">
                <h2>行政处罚</h2>
                <a href="generalPunishment/listNew?step=15" style="margin-top: 10px;margin-left:80px">一般处罚</a>
                <a href="punish/localepunishes" style="margin-top: 5px;margin-left:80px">简易处罚</a>
                </div>
            </figcaption>
        </figure>
    </div>
<!-- Code End -->
</body>
</html>