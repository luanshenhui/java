<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.title a:link, a:visited {
    color:white;
    text-decoration: none;
}
 #title_a{color:#ccc}
 #title_a:hover{
 	color:white;
 }
 
</style>

	<div class="freeze_div_list">
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
<!-- 					<a href="#" class="white"><span class="font-24px">中国出口食品生产企业备案 -->
<!-- 					</span></a> -->
				<span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" href="/ciqs/expFoodPOF/expFoodList">出口食品生产企业备案</a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
		<div class="flow-bg">
			<div class="flow-position margin-auto">
<ul class="white font-18px flow-height font-weight">
<li  style="width:129px;">企业申请</li>
<li style="width:129px;">备案受理</li>
<li style="width:135px;">评审组任务分配</li>
<li style="width:129px;">文件审核</li>
<li style="width:129px;">现场查验</li>
<li style="width:129px;">材料终审</li>
<li style="width:135px;">审批决定、归档</li>
<li style="width:129px;">发证</li>
<li></li>
<!-- <li style="width:129px;">发证</li> -->
</ul>
<ul class="flow-icon" id="flow_color">
  <li class="iconyellow" style="width:129px;" data-id="time_1"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof1.png" width="80" height="80" /></li>
  <li class="iconyellow" style="width:129px;" data-id="time_2"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof2.png" width="80" height="80" /></li>
  <li class="iconyellow" style="width:129px;" data-id="time_3"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof3.png" width="80" height="80" /></li> 
  <li class="iconyellow" style="width:129px;" data-id="time_4"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof4.png" width="80" height="80" /></li>
  <li class="iconyellow" style="width:129px;" data-id="time_5"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof5.png" width="80" height="80" /></li>
  <li class="iconyellow" style="width:129px;" data-id="time_6"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof6.png" width="80" height="80" /></li>
  <li class="iconyellow" style="width:129px;" data-id="time_7"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof7.png" width="80" height="80" /></li> 
  <li class="iconyellow" style="width:129px;" data-id="time_8"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/expFoodPOF/pof9.png" width="80" height="80" /></li>
  <li class="white font-17px font-weight" style="width:129px;white-space: nowrap; display:inline-block"> <br />
    历时：<span id="flow_time">0</span></li>
</ul>
<ul class="flow-info" >
	<li style="width:129px;"><span id="name_1"></span><br /><span id="time_1" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_2"></span><br /><span id="time_2" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_3"></span><br /><span id="time_3" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_4"></span><br /><span id="time_4" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_5"></span><br /><span id="time_5" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_6"></span><br /><span id="time_6" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_7"></span><br /><span id="time_7" class="font-10px" ></span></li>
	<li style="width:129px;"><span id="name_8"></span><br /><span id="time_8" class="font-10px" ></span></li>
</ul>
			</div>
		</div>
	</div>
	<script type="text/javascript">
$.fn.getHour=function(startDate,endDate,flg,b){
		if(!endDate || !startDate){
			return $(this).html("-");
		}
		var date1 = new Date(startDate.replace(/-/g,"/")); 
		var date2;
		if(b){
			date2=new Date();
		}else{
			date2 = new Date(endDate.replace(/-/g,"/"));
		}
		if(!flg){
			flg="";
		}
		
		var hour = null;
		if(typeof(b)!='undefined'){
// 			hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
			hour = daysBetween(date1,date2);
		}else{
			hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
		}
		hour = hour.toFixed(2);
		if(hour){
			$(this).html(flg+hour);
		}else{
			$(this).html("-");
		}
	};
	
	function daysBetween(DateOne,DateTwo){
		var time= (DateTwo.getTime() - DateOne.getTime())/(1000 * 60 * 60 );
        return time;
	}
	
	
</script> 