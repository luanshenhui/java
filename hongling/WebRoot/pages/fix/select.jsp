<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="templatemo_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.js"></script>
<!-- <script src="js/jquery-1.2.1.pack.js" type="text/javascript"></script> -->
<script src="js/jquery-easing.1.2.pack.js" type="text/javascript"></script>
<script src="js/jquery-easing-compatibility.1.2.pack.js" type="text/javascript"></script> 
<script src="js/coda-slider.1.1.1.pack.js" type="text/javascript"></script>
<!-- <script type="text/javascript" src="../../scripts/importjs.js"></script> -->
<script type="text/javascript" src="../../scripts/jsps.js"></script>
<script type="text/javascript" src="selectjsp.js"></script>

<script type="text/javascript">
    jQuery(window).bind("load", function() {
    	jQuery("div#slider1").codaSlider();
    });
</script>

</head>

<body>
<div align=center>
	<div id="bookflip" style="background: url('spongebob/book.png');"></div>
	<div id="templatemo_site_title_bar_wrapper">
		<div style="float: right;margin-right: 15px;">
				<a style="color: #FFAB00;" id="professional_edition" href="../common/orden.jsp"><s:text name="professional_edition"></s:text></a> | <a id="myorden" style="color: #FFAB00;"><s:text name="myorden"></s:text></a> | <a id="myfabric" style="color: #FFAB00;"><s:text name="myfabric"></s:text></a> | <a id="blDelivery" style="color: #FFAB00;"><s:text name="blDelivery"></s:text></a> | <a id="blCash" style="color: #FFAB00;"><s:text name="blCash"></s:text></a> | <a id="myuser" style="color: #FFAB00;"><s:text name="myuser"></s:text></a> |  <a id="mymessage" style="color: #FFAB00;"><s:text name="mymessage"></s:text></a> | <a id="myinformation" style="color: #FFAB00;"><s:text name="myinformation"></s:text></a> | <a id="coder" style="color: #FFAB00;"><s:text name="coder"></s:text></a> | <a id="signOut" style="color: #FFAB00;"><s:text name="signOut"></s:text></a>    <select id="versions"></select>
		</div>
	</div>
<!-- end of templatemo_site_title_bar_wrapper -->
<div id="templatemo_content_wrapper">
  <div id="templatemo_content">
    <!-- start of slider -->
    <div class="slider-wrap">
      <div id="slider1" class="csw">
        <div class="panelContainer">
          <div class="panel" title=<s:text name="SSB_JBPZ"></s:text>>
            <div class="wrapper">
               <div>
            		<div  class="clothing_type"></div>
        			<div id="TZ" style="float: left;"></div>
               </div>
               <div id="jbpz3">
	               <h2><s:text name="SSB_BLQ"></s:text></h2>
	               <div id="jbks_image" class="image_wrapper fl_image"> <img src="images/51_37.png" alt="image"/> </div>
	               <div style="margin-top: 65px; width: 650px; height:50px;">
		       			<div id="bt0" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;" 
		       			onmouseout="$.csSelect.gyOut('0')" onmouseover="$.csSelect.gyOver('0')" onclick="$.csSelect.changebt('0','51')"><div class="jbpz_text"><s:text name="SSB_BT1"></s:text></div>
		       			<i id="gyimg0" class="gyimg" style="display: block;"></i></div>
		       			<div id="bt1" class="gy" 
		       			onmouseout="$.csSelect.gyOut('1')" onmouseover="$.csSelect.gyOver('1')" onclick="$.csSelect.changebt('1','52')"><div class="jbpz_text"><s:text name="SSB_BT2"></s:text></div>
		       			<i id="gyimg1" class="gyimg"></i></div>
		       			<div id="bt2" class="gy" 
		       			onmouseout="$.csSelect.gyOut('2')" onmouseover="$.csSelect.gyOver('2')" onclick="$.csSelect.changebt('2','53')"><div class="jbpz_text"><s:text name="SSB_BT3"></s:text></div>
		       			<i id="gyimg2" class="gyimg"></i></div>
		       			<div id="bt3" class="gy" 
		       			onmouseout="$.csSelect.gyOut('3')" onmouseover="$.csSelect.gyOver('3')" onclick="$.csSelect.changebt('3','54')"><div class="jbpz_text"><s:text name="SSB_BT4"></s:text></div>
		       			<i id="gyimg3" class="gyimg"></i></div>
		       			<div id="bt4" class="gy" 
		       			onmouseout="$.csSelect.gyOut('4')" onmouseover="$.csSelect.gyOver('4')" onclick="$.csSelect.changebt('4','55')"><div class="jbpz_text"><s:text name="SSB_BT5"></s:text></div>
		       			<i id="gyimg4" class="gyimg"></i></div>
	              </div>
              
	              <div id="qmk">
	              		<div style='margin-top: 15px; width: 650px; height:50px;'>
		              	    <div id="kz0" class="gy"
				       			onmouseout="$.csSelect.kzOut('0')" onmouseover="$.csSelect.kzOver('0')" onclick="$.csSelect.changekz('0','5','36')"><div class="jbpz_text"><s:text name="SSB_QMK1"></s:text></div>
				       			<i id="kzimg0" class="gyimg"></i>
			       			</div>
			       			<div id="kz1" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;"
				       			onmouseout="$.csSelect.kzOut('1')" onmouseover="$.csSelect.kzOver('1')" onclick="$.csSelect.changekz('1','5','37')"><div class="jbpz_text"><s:text name="SSB_QMK2"></s:text></div>
				       			<i id="kzimg1" class="gyimg" style="display: block;"></i>
			       			</div>
			       			<div id="kz3" class="gy"
				       			onmouseout="$.csSelect.kzOut('3')" onmouseover="$.csSelect.kzOver('3')" onclick="$.csSelect.changekz('3','5','38')"><div class="jbpz_text"><s:text name="SSB_QMK3"></s:text></div>
				       			<i id="kzimg3" class="gyimg"></i>
			       			</div>
			       			<div id="kz2" class="gy" title='<s:text name="SSB_QMK3_1_1"></s:text>' 
				       			onmouseout="$.csSelect.kzOut('2')" onmouseover="$.csSelect.kzOver('2')" onclick="$.csSelect.changekz('2','5','875')"><div class="jbpz_text"><s:text name="SSB_QMK3_1"></s:text></div>
				       			<i id="kzimg2" class="gyimg"></i>
			       			</div>
			       			<div id="kz4" class="gy" title='<s:text name="SSB_QMK3_2_2"></s:text>' 
				       			onmouseout="$.csSelect.kzOut('4')" onmouseover="$.csSelect.kzOver('4')" onclick="$.csSelect.changekz('4','5','876')"><div class="jbpz_text"><s:text name="SSB_QMK3_2"></s:text></div>
				       			<i id="kzimg4" class="gyimg"></i>
			       			</div>
		       			</div>
	              </div>
	       	  </div>
	       	  
	       	  <div id="jbpz2000" style="display: none;">
	       	  		 <h2><s:text name="SSB_KQ"></s:text></h2>
	                 <div id="jbks_XKimage" class="image_wrapper fl_image"> <img src="images/2034_2049.png" alt="image"/> </div>
	                 <div style="margin-top: 65px; width: 650px; height:50px;">
			       			<div id="kzxs0" class="gy"  
			       			onmouseout="$.csSelect.kzxsOut('0')" onmouseover="$.csSelect.kzxsOver('0')" onclick="$.csSelect.changeKzxs('0','2033')"><div class="jbpz_text"><s:text name="SSB_KZ1"></s:text></div>
			       			<i id="kzxsimg0" class="gyimg"></i></div>
			       			<div id="kzxs1" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;"
			       			onmouseout="$.csSelect.kzxsOut('1')" onmouseover="$.csSelect.kzxsOver('1')" onclick="$.csSelect.changeKzxs('1','2034')"><div class="jbpz_text"><s:text name="SSB_KZ2"></s:text></div>
			       			<i id="kzxsimg1" class="gyimg" style="display: block;"></i></div>
			       			<div id="kzxs2" class="gy" 
			       			onmouseout="$.csSelect.kzxsOut('2')" onmouseover="$.csSelect.kzxsOver('2')" onclick="$.csSelect.changeKzxs('2','2035')"><div class="jbpz_text"><s:text name="SSB_KZ3"></s:text></div>
			       			<i id="kzxsimg2" class="gyimg"></i></div>
			       			<div id="kzxs3" class="gy" 
			       			onmouseout="$.csSelect.kzxsOut('3')" onmouseover="$.csSelect.kzxsOver('3')" onclick="$.csSelect.changeKzxs('3','2036')"><div class="jbpz_text"><s:text name="SSB_KZ4"></s:text></div>
			       			<i id="kzxsimg3" class="gyimg"></i></div>
			       			<div id="kzxs4" class="gy" 
			       			onmouseout="$.csSelect.kzxsOut('4')" onmouseover="$.csSelect.kzxsOver('4')" onclick="$.csSelect.changeKzxs('4','2037')"><div class="jbpz_text"><s:text name="SSB_KZ5"></s:text></div>
			       			<i id="kzxsimg4" class="gyimg"></i></div>
		       		 </div>
		             <div id="kdxs">
		             	<div  style='margin-top: 15px;margin-bottom: 15px;width: 650px; height:50px;'>
					    	<div id='qdxs0' class='gy' onmouseout="$.csSelect.qdxsOut('0')" onmouseover="$.csSelect.qdxsOver('0')"  onclick="$.csSelect.changeQdxs('0','10','2048')">
					    	<div class="jbpz_text"><s:text name="SSB_2XD"></s:text></div><i id='qdxsimg0' class="gyimg"></i></div>
					    	<div id='qdxs1' class='gy' onmouseout="$.csSelect.qdxsOut('1')" onmouseover="$.csSelect.qdxsOver('1')"  onclick="$.csSelect.changeQdxs('1','10','2050')">
					    	<div class="jbpz_text"><s:text name="SSB_32XD"></s:text></div><i id='qdxsimg1' class="gyimg"></i></div>
					    	<div id='qdxs2' class='gy' onmouseout="$.csSelect.qdxsOut('2')" onmouseover="$.csSelect.qdxsOver('2')"  onclick="$.csSelect.changeQdxs('2','10','2051')">
					    	<div class="jbpz_text"><s:text name="SSB_51XD"></s:text></div><i id='qdxsimg2' class="gyimg"></i></div>
					    	<div id='qdxs3' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout="$.csSelect.qdxsOut('3')" onmouseover="$.csSelect.qdxsOver('3')"  onclick="$.csSelect.changeQdxs('3','10','2049')">
					    	<div class="jbpz_text"><s:text name="SSB_25XD"></s:text></div><i id='qdxsimg3' class='gyimg' style="display: block;"></i></div>
					    	<div id='qdxs4' class='gy' onmouseout="$.csSelect.qdxsOut('4')" onmouseover="$.csSelect.qdxsOver('4')"  onclick="$.csSelect.changeQdxs('4','10','2333')">
					    	<div class="jbpz_text"><s:text name="SSB_2XT"></s:text></div><i id='qdxsimg4' class="gyimg"></i></div>
					    	</div>
					    	<div style='margin-bottom: 15px;width: 650px; height:50px;'>
					    	<div id='qdxs5' class='gy' onmouseout="$.csSelect.qdxsOut('5')" onmouseover="$.csSelect.qdxsOver('5')"  onclick="$.csSelect.changeQdxs('5','10','2334')">
					    	<div class="jbpz_text"><s:text name="SSB_32XT"></s:text></div><i id='qdxsimg5' class="gyimg"></i></div>
					    	<div id='qdxs6' class='gy' onmouseout="$.csSelect.qdxsOut('6')" onmouseover="$.csSelect.qdxsOver('6')"  onclick="$.csSelect.changeQdxs('6','10','2335')">
					    	<div class="jbpz_text"><s:text name="SSB_51XT"></s:text></div><i id='qdxsimg6' class="gyimg"></i></div>
					    	<div id='qdxs7' class='gy' onmouseout="$.csSelect.qdxsOut('7')" onmouseover="$.csSelect.qdxsOver('7')"  onclick="$.csSelect.changeQdxs('7','10','2336')">
					    	<div class="jbpz_text"><s:text name="SSB_25XT"></s:text></div><i id='qdxsimg7' class="gyimg"></i></div>
					    	<div id='qdxs8' class='gy' onmouseout="$.csSelect.qdxsOut('8')" onmouseover="$.csSelect.qdxsOver('8')"  onclick="$.csSelect.changeQdxs('8','10','2054')">
					    	<div class="jbpz_text"><s:text name="SSB_QSKX"></s:text></div><i id='qdxsimg8' class="gyimg"></i></div>
					    	<div id='qdxs9' class='gy' onmouseout="$.csSelect.qdxsOut('9')" onmouseover="$.csSelect.qdxsOver('9')"  onclick="$.csSelect.changeQdxs('9','10','2053')">
					    	<div class="jbpz_text"><s:text name="SSB_QDKX"></s:text></div><i id='qdxsimg9' class="gyimg"></i></div>
					    </div>
		             </div>
              </div>
              <div id="jbpz3000" style="display: none;">
              		<h2><s:text name="SSB_LM"></s:text></h2>
	                 <div id="jbks_CYimage" class="image_wrapper fl_image"> <img src="images/3063_3045.png" alt="image"/> </div>
	                 <div style="margin-top: 35px; width: 650px; height:50px;">
			       			<div id="lx0" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;" 
			       			onmouseout="$.csSelect.lxOut('0')" onmouseover="$.csSelect.lxOver('0')" onclick="$.csSelect.changeLx('0','3063')"><div class="jbpz_text"><s:text name="SSB_DJL34"></s:text></div>
			       			<i id="lximg0" class="gyimg" style="display: block;"></i></div>
			       			<div id="lx1" class="gy" 
			       			onmouseout="$.csSelect.lxOut('1')" onmouseover="$.csSelect.lxOver('1')" onclick="$.csSelect.changeLx('1','3064')"><div class="jbpz_text"><s:text name="SSB_XJL55"></s:text></div>
			       			<i id="lximg1" class="gyimg"></i></div>
			       			<div id="lx2" class="gy" 
			       			onmouseout="$.csSelect.lxOut('2')" onmouseover="$.csSelect.lxOver('2')" onclick="$.csSelect.changeLx('2','3065')"><div class="jbpz_text"><s:text name="SSB_ZJL38"></s:text></div>
			       			<i id="lximg2" class="gyimg"></i></div>
			       			<div id="lx3" class="gy" 
			       			onmouseout="$.csSelect.lxOut('3')" onmouseover="$.csSelect.lxOver('3')" onclick="$.csSelect.changeLx('3','3066')"><div class="jbpz_text"><s:text name="SSB_ZFL01"></s:text></div>
			       			<i id="lximg3" class="gyimg"></i></div>
			       			<div id="lx4" class="gy" 
			       			onmouseout="$.csSelect.lxOut('4')" onmouseover="$.csSelect.lxOver('4')" onclick="$.csSelect.changeLx('4','3067')"><div class="jbpz_text"><s:text name="SSB_DFL39"></s:text></div>
			       			<i id="lximg4" class="gyimg"></i></div>
		       		 </div>
					 <div style=" width: 650px; height:50px;">
			       			<div id="lx5" class="gy"  
			       			onmouseout="$.csSelect.lxOut('5')" onmouseover="$.csSelect.lxOver('5')" onclick="$.csSelect.changeLx('5','3068')"><div class="jbpz_text"><s:text name="SSB_ZBZL"></s:text></div> 
			       			<i id="lximg5" class="gyimg"></i></div>
			       			<div id="lx6" class="gy" 
			       			onmouseout="$.csSelect.lxOut('6')" onmouseover="$.csSelect.lxOver('6')" onclick="$.csSelect.changeLx('6','3069')"><div class="jbpz_text"><s:text name="SSB_DBZL"></s:text></div>
			       			<i id="lximg6" class="gyimg"></i></div>
			       			<div id="lx7" class="gy" 
			       			onmouseout="$.csSelect.lxOut('7')" onmouseover="$.csSelect.lxOver('7')" onclick="$.csSelect.changeLx('7','3070')"><div class="jbpz_text"><s:text name="SSB_ZHXL42"></s:text></div>
			       			<i id="lximg7" class="gyimg"></i></div>
			       			<div id="lx8" class="gy" 
			       			onmouseout="$.csSelect.lxOut('8')" onmouseover="$.csSelect.lxOver('8')" onclick="$.csSelect.changeLx('8','3071')"><div class="jbpz_text"><s:text name="SSB_DHXL43"></s:text></div>
			       			<i id="lximg8" class="gyimg"></i></div>
			       			<div id="lx9" class="gy" 
			       			onmouseout="$.csSelect.lxOut('9')" onmouseover="$.csSelect.lxOver('9')" onclick="$.csSelect.changeLx('9','3072')"><div class="jbpz_text"><s:text name="SSB_XYL40"></s:text></div>
			       			<i id="lximg9" class="gyimg"></i></div>
		       		 </div>
				 	 <div style="width: 650px; height:50px;">
			       			<div id="lx10" class="gy"  
			       			onmouseout="$.csSelect.lxOut('10')" onmouseover="$.csSelect.lxOver('10')" onclick="$.csSelect.changeLx('10','3073')"><div class="jbpz_text"><s:text name="SSB_DYL41"></s:text></div>
			       			<i id="lximg10" class="gyimg"></i></div>
			       			<div id="lx11" class="gy" 
			       			onmouseout="$.csSelect.lxOut('11')" onmouseover="$.csSelect.lxOver('11')" onclick="$.csSelect.changeLx('11','7001')"><div class="jbpz_text"><s:text name="SSB_ZYL44"></s:text></div>
			       			<i id="lximg11" class="gyimg"></i></div>
			       			<div id="lx12" class="gy" 
			       			onmouseout="$.csSelect.lxOut('12')" onmouseover="$.csSelect.lxOver('12')" onclick="$.csSelect.changeLx('12','3074')"><div class="jbpz_text"><s:text name="SSB_LL56"></s:text></div>
			       			<i id="lximg12" class="gyimg"></i></div>
			       			<div id="lx13" class="gy" 
			       			onmouseout="$.csSelect.lxOut('13')" onmouseover="$.csSelect.lxOver('13')" onclick="$.csSelect.changeLx('13','3952')"><div class="jbpz_text"><s:text name="SSB_LFL95"></s:text></div>
			       			<i id="lximg13" class="gyimg"></i></div>
			       			<div id="lx14" class="gy" 
			       			onmouseout="$.csSelect.lxOut('14')" onmouseover="$.csSelect.lxOver('14')" onclick="$.csSelect.changeLx('14','3996')"><div class="jbpz_text"><s:text name="SSB_RPLZ3"></s:text></div>
			       			<i id="lximg14" class="gyimg"></i></div>
		       		 </div>
		       		 
		       		 <div id="mjxs" style="margin-top: 15px; width: 650px; height:50px;">
	              	    <div id="mjxs0" class="gy"   style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;"
			       			onmouseout="$.csSelect.MjxsOut('0')" onmouseover="$.csSelect.MjxsOver('0')" onclick="$.csSelect.changeMjxs('0','5','3040')"><div class="jbpz_text"><s:text name="SSB_GBMJ"></s:text></div>
			       			<i id="mjxsimg0" class="gyimg"  style="display: block;"></i>
		       			</div>
		       			<div id="mjxs1" class="gy" 
			       			onmouseout="$.csSelect.MjxsOut('1')" onmouseover="$.csSelect.MjxsOver('1')" onclick="$.csSelect.changeMjxs('1','5','3041')"><div class="jbpz_text"><s:text name="SSB_LSZMJ"></s:text></div>
			       			<i id="mjxsimg1" class="gyimg"></i>
		       			</div>
		       			<div id="mjxs3" class="gy" 
			       			onmouseout="$.csSelect.MjxsOut('3')" onmouseover="$.csSelect.MjxsOver('3')" onclick="$.csSelect.changeMjxs('3','5','3042')"><div class="jbpz_text"><s:text name="SSB_AMJ"></s:text></div>
			       			<i id="mjxsimg3" class="gyimg"></i>
		       			</div>
		       			<div id="mjxs2" class="gy"
			       			onmouseout="$.csSelect.MjxsOut('2')" onmouseover="$.csSelect.MjxsOver('2')" onclick="$.csSelect.changeMjxs('2','5','3045')"><div class="jbpz_text"><s:text name="SSB_ZYGB"></s:text></div>
			       			<i id="mjxsimg2" class="gyimg"></i>
		       			</div>
		       			<div id="mjxs4" class="gy" 
			       			onmouseout="$.csSelect.MjxsOut('4')" onmouseover="$.csSelect.MjxsOver('4')" onclick="$.csSelect.changeMjxs('4','5','3043')"><div class="jbpz_text"><s:text name="SSB_ZYLSZ"></s:text></div>
			       			<i id="mjxsimg4" class="gyimg"></i>
		       			</div>
	               </div>
              </div>
              <div id="jbpz4000" style="display: none;">
              		<h2><s:text name="SSB_BLQ"></s:text></h2>
	                 <div id="jbks_MJimage" class="image_wrapper fl_image"> <img src="images/4023_4038.png" alt="image"/> </div>
	                 <div style="margin-top: 35px; width: 650px; height:50px;">
			       			<div id="mjbt0" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;" 
			       			onmouseout="$.csSelect.mjbtOut('0')" onmouseover="$.csSelect.mjbtOver('0')" onclick="$.csSelect.changeMjbt('0','4023')">
							<div class="jbpz_text"><s:text name="SSB_4000"></s:text></div>
			       			<i id="mjbtimg0" class="gyimg" style="display: block;"></i></div>
			       			<div id="mjbt1" class="gy" 
			       			onmouseout="$.csSelect.mjbtOut('1')" onmouseover="$.csSelect.mjbtOver('1')" onclick="$.csSelect.changeMjbt('1','4024')">
							<div class="jbpz_text"><s:text name="SSB_4001"></s:text></div>
			       			<i id="mjbtimg1" class="gyimg"></i></div>
			       			<div id="mjbt2" class="gy" 
			       			onmouseout="$.csSelect.mjbtOut('2')" onmouseover="$.csSelect.mjbtOver('2')" onclick="$.csSelect.changeMjbt('2','4025')">
							<div class="jbpz_text"><s:text name="SSB_4003"></s:text></div>
			       			<i id="mjbtimg2" class="gyimg"></i></div>
			       			<div id="mjbt3" class="gy" 
			       			onmouseout="$.csSelect.mjbtOut('3')" onmouseover="$.csSelect.mjbtOver('3')" onclick="$.csSelect.changeMjbt('3','4026')">
							<div class="jbpz_text"><s:text name="SSB_4002"></s:text></div>
			       			<i id="mjbtimg3" class="gyimg"></i></div>
			       			<div id="mjbt4" class="gy" 
			       			onmouseout="$.csSelect.mjbtOut('4')" onmouseover="$.csSelect.mjbtOver('4')" onclick="$.csSelect.changeMjbt('4','4027')">
							<div class="jbpz_text"><s:text name="SSB_4004"></s:text></div>
			       			<i id="mjbtimg4" class="gyimg"></i></div>
		       		 </div>
					 <div style=" width: 650px; height:50px;">
			       			<div id="mjbt5" class="gy"  
			       			onmouseout="$.csSelect.mjbtOut('5')" onmouseover="$.csSelect.mjbtOver('5')" onclick="$.csSelect.changeMjbt('5','4028')">
							<div class="jbpz_text"><s:text name="SSB_4005"></s:text></div> 
			       			<i id="mjbtimg5" class="gyimg"></i></div>
							<div id="mjbt6" class="gy"  
			       			onmouseout="$.csSelect.mjbtOut('6')" onmouseover="$.csSelect.mjbtOver('6')" onclick="$.csSelect.changeMjbt('6','4029')">
							<div class="jbpz_text"><s:text name="SSB_4006"></s:text></div> 
			       			<i id="mjbtimg6" class="gyimg"></i></div>
							<div id="mjbt7" class="gy"  
			       			onmouseout="$.csSelect.mjbtOut('7')" onmouseover="$.csSelect.mjbtOver('7')" onclick="$.csSelect.changeMjbt('7','4030')">
							<div class="jbpz_text"><s:text name="SSB_4007"></s:text></div> 
			       			<i id="mjbtimg7" class="gyimg"></i></div>
		       		 </div>
		       		 <div id="mjqmk" style="margin-top: 15px; width: 650px; height:50px;">
	              	    <div id="mjqmk0" class="gy"
			       			onmouseout="$.csSelect.mjqmkOut('0')" onmouseover="$.csSelect.mjqmkOver('0')" onclick="$.csSelect.changeMjqmk('0','5','4036')">
							<div class="jbpz_text"><s:text name="SSB_QMK3"></s:text></div>
			       			<i id="mjqmkimg0" class="gyimg"></i>
		       			</div>
		       			<div id="mjqmk1" class="gy" 
			       			onmouseout="$.csSelect.mjqmkOut('1')" onmouseover="$.csSelect.mjqmkOver('1')" onclick="$.csSelect.changeMjqmk('1','5','4037')">
							<div class="jbpz_text"><s:text name="SSB_401D"></s:text></div>
			       			<i id="mjqmkimg1" class="gyimg"></i>
		       			</div>
		       			<div id="mjqmk2" class="gy"   style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;"
			       			onmouseout="$.csSelect.mjqmkOut('2')" onmouseover="$.csSelect.mjqmkOver('2')" onclick="$.csSelect.changeMjqmk('2','5','4038')">
							<div class="jbpz_text"><s:text name="SSB_6023"></s:text></div>
			       			<i id="mjqmkimg2" class="gyimg"  style="display: block;"></i>
		       			</div>
						<div id="mjqmk3" class="gy" 
			       			onmouseout="$.csSelect.mjqmkOut('3')" onmouseover="$.csSelect.mjqmkOver('3')" onclick="$.csSelect.changeMjqmk('3','5','4260')">
							<div class="jbpz_text"><s:text name="SSB_401M"></s:text></div>
			       			<i id="mjqmkimg3" class="gyimg"></i>
		       			</div>
		       			<div id="mjqmk4" class="gy" 
			       			onmouseout="$.csSelect.mjqmkOut('4')" onmouseover="$.csSelect.mjqmkOver('4')" onclick="$.csSelect.changeMjqmk('4','5','4264')">
							<div class="jbpz_text"><s:text name="SSB_6019"></s:text></div>
			       			<i id="mjqmkimg4" class="gyimg"></i>
		       			</div>
	               </div>
              </div>
              <div id="jbpz6000" style="display: none;">
              		<h2><s:text name="SSB_BLQ"></s:text></h2>
	                 <div id="jbks_DYimage" class="image_wrapper fl_image"> <img src="images/6030_6016.png" alt="image"/> </div>
	                 <div style="margin-top: 35px; width: 650px; height:50px;">
			       			<div id="dybt0" class="gy" style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;" 
			       			onmouseout="$.csSelect.dybtOut('0')" onmouseover="$.csSelect.dybtOver('0')" onclick="$.csSelect.changeDybt('0','6029')">
							<div class="jbpz_text"><s:text name="SSB_BT1"></s:text></div>
			       			<i id="dybtimg0" class="gyimg" style="display: block;"></i></div>
			       			<div id="dybt1" class="gy" 
			       			onmouseout="$.csSelect.dybtOut('1')" onmouseover="$.csSelect.dybtOver('1')" onclick="$.csSelect.changeDybt('1','6030')">
							<div class="jbpz_text"><s:text name="SSB_BT2"></s:text></div>
			       			<i id="dybtimg1" class="gyimg"></i></div>
			       			<div id="dybt2" class="gy" 
			       			onmouseout="$.csSelect.dybtOut('2')" onmouseover="$.csSelect.dybtOver('2')" onclick="$.csSelect.changeDybt('2','6477')">
							<div class="jbpz_text"><s:text name="SSB_6007"></s:text></div>
			       			<i id="dybtimg2" class="gyimg"></i></div>
			       			<div id="dybt3" class="gy" 
			       			onmouseout="$.csSelect.dybtOut('3')" onmouseover="$.csSelect.dybtOver('3')" onclick="$.csSelect.changeDybt('3','6475')">
							<div class="jbpz_text"><s:text name="SSB_601A"></s:text></div>
			       			<i id="dybtimg3" class="gyimg"></i></div>
			       			<div id="dybt4" class="gy" 
			       			onmouseout="$.csSelect.dybtOut('4')" onmouseover="$.csSelect.dybtOver('4')" onclick="$.csSelect.changeDybt('4','6031')">
							<div class="jbpz_text"><s:text name="SSB_BT3"></s:text></div>
			       			<i id="dybtimg4" class="gyimg"></i></div>
		       		 </div>
					 <div style=" width: 650px; height:50px;">
			       			<div id="dybt5" class="gy"  
			       			onmouseout="$.csSelect.dybtOut('5')" onmouseover="$.csSelect.dybtOver('5')" onclick="$.csSelect.changeDybt('5','6032')">
							<div class="jbpz_text"><s:text name="SSB_BT4"></s:text></div> 
			       			<i id="dybtimg5" class="gyimg"></i></div>
		       		 </div>
		       		 <div id="dyqmk" style="margin-top: 15px; width: 650px; height:50px;">
	              	    <div id="dyqmk0" class="gy"   style="border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;"
			       			onmouseout="$.csSelect.dyqmkOut('0')" onmouseover="$.csSelect.dyqmkOver('0')" onclick="$.csSelect.changeDyqmk('0','5','6137')">
							<div class="jbpz_text"><s:text name="SSB_QMK2"></s:text></div>
			       			<i id="dyqmkimg0" class="gyimg"  style="display: block;"></i>
		       			</div>
		       			<div id="dyqmk1" class="gy" 
			       			onmouseout="$.csSelect.dyqmkOut('1')" onmouseover="$.csSelect.dyqmkOver('1')" onclick="$.csSelect.changeDyqmk('1','5','6016')">
							<div class="jbpz_text"><s:text name="SSB_QMK3"></s:text></div>
			       			<i id="dyqmkimg1" class="gyimg"></i>
		       			</div>
		       			<div id="dyqmk2" class="gy"
			       			onmouseout="$.csSelect.dyqmkOut('2')" onmouseover="$.csSelect.dyqmkOver('2')" onclick="$.csSelect.changeDyqmk('2','5','60506')">
							<div class="jbpz_text"><s:text name="SSB_602D"></s:text></div>
			       			<i id="dyqmkimg2" class="gyimg"></i>
		       			</div>
						<div id="dyqmk3" class="gy" 
			       			onmouseout="$.csSelect.dyqmkOut('3')" onmouseover="$.csSelect.dyqmkOver('3')" onclick="$.csSelect.changeDyqmk('3','5','6020')">
							<div class="jbpz_text"><s:text name="SSB_QMK3"></s:text></div>
			       			<i id="dyqmkimg3" class="gyimg"></i>
		       			</div>
		       			<div id="dyqmk4" class="gy" 
			       			onmouseout="$.csSelect.dyqmkOut('4')" onmouseover="$.csSelect.dyqmkOver('4')" onclick="$.csSelect.changeDyqmk('4','5','6024')">
							<div class="jbpz_text"><s:text name="SSB_6019"></s:text></div>
			       			<i id="dyqmkimg4" class="gyimg"></i>
		       			</div>
	               </div>
              </div>
              <p><a href="#2" class="cross-link" title="Go to Page 2"> <s:text name="SSB_XYY"></s:text>&#187;</a></p>
            </div>
          </div>
          <div class="panel" title=<s:text name="SSB_GYLX"></s:text>>
            <div class="wrapper">
              <h2><s:text name="SSB_MCGYLX"></s:text></h2>
              <div id="mrgy_1" class="scrollCss" style="width:747px; height:290px;">
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('000B','433')" src="images/000B.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BMCJS"></s:text> </p>
	                   <input type="radio" name="mc" value="000B" checked="checked" class="hand" onclick="$.csSelect.changeMC('000B','433')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('000A','432')" src="images/000A.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QMCJS"></s:text></p>
	                   <input type="radio" name="mc" value="000A" class="hand" onclick="$.csSelect.changeMC('000A','432')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00AA','437,432')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGQMCJS"></s:text></p>
	                  <input type="radio" name="mc" value="00AA" class="hand" onclick="$.csSelect.changeMC('00AA','437,432')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box">
	                <h3><s:text name="SSB_QSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAA','432,436')" src="images/0AAA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGQMCJS"></s:text></p>
	                  <input type="radio" name="mc" value="0AAA" class="hand" onclick="$.csSelect.changeMC('0AAA','432,436')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0BAA','437,433')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGBMCJS"></s:text></p>
	                   <input type="radio" name="mc" value="0BAA" class="hand" onclick="$.csSelect.changeMC('0BAA','437,433')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAB','436,433')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGBMCJS"></s:text></p>
	                   <input type="radio" name="mc" value="0AAB" class="hand" onclick="$.csSelect.changeMC('0AAB','436,433')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_NHC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00C1','434')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_NHCJS"></s:text></p>
	                  <input type="radio" name="mc" value="00C1" class="hand" onclick="$.csSelect.changeMC('00C1','434')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_0AAD"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAD','968')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_0AADJS"></s:text></p>
	                  <input type="radio" name="mc" value="0AAD" class="hand" onclick="$.csSelect.changeMC('0AAD','968')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_00AD"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00AD','969')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_00ADJS"></s:text></p>
	                  <input type="radio" name="mc" value="00AD" class="hand" onclick="$.csSelect.changeMC('00AD','969')"/></div>
	                  <div class="cleaner"></div>
	              </div>
              </div>
              <div id="mrgy_2000" class="scrollCss" style="width:747px; height:290px;display: none;">
            	  <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('000B','433')" src="images/000B.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BMCJS"></s:text> </p>
	                   <input type="radio" name="xk_mc" value="000B" checked="checked" class="hand" onclick="$.csSelect.changeMC('000B','433')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00AA','40128')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="xk_mc" value="00AA" class="hand" onclick="$.csSelect.changeMC('00AA','40128')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAA','40127')" src="images/0AAA.png" /></div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="xk_mc" value="0AAA" class="hand" onclick="$.csSelect.changeMC('0AAA','40127')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box">
	                <h3><s:text name="SSB_BSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0BAA','40130')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="xk_mc" value="0BAA" class="hand" onclick="$.csSelect.changeMC('0BAA','40130')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAB','40129')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="xk_mc" value="0AAB" class="hand" onclick="$.csSelect.changeMC('0AAB','40129')"/></div>
	                  <div class="cleaner"></div>
	              </div>
              </div>
              <div id="mrgy_3000" style="display: none;'"><s:text name="SSB_CYWCLX"></s:text></div>
              <div id="mrgy_4000" class="scrollCss" style="width:747px; height:290px;display: none;">
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00AA','4018')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="mj_mc" value="00AA" class="hand" onclick="$.csSelect.changeMC('00AA','4018')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAA','4017')" src="images/0AAA.png" /></div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="mj_mc" value="0AAA" class="hand" onclick="$.csSelect.changeMC('0AAA','4017')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0BAA','4020')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="mj_mc" value="0BAA" class="hand" onclick="$.csSelect.changeMC('0BAA','4020')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box">
	                <h3><s:text name="SSB_QSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAB','4019')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="mj_mc" value="0AAB" class="hand" onclick="$.csSelect.changeMC('0AAB','4019')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SBB_GDNHC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00C1','4994')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_NHCJS_DY"></s:text></p>
	                  <input type="radio" name="mj_mc" value="00C1" class="hand" checked="checked" onclick="$.csSelect.changeMC('00C1','4994')"/></div>
	                  <div class="cleaner"></div>
	              </div>
              </div>
              <div id="mrgy_6000" class="scrollCss" style="width:747px; height:290px;display: none;">
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('000B','6411')" src="images/000B.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BMCJS_DY"></s:text> </p>
	                   <input type="radio" name="dy_mc" value="000B" checked="checked" class="hand" onclick="$.csSelect.changeMC('000B','6411')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('000A','6410')" src="images/000A.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QMCJS_DY"></s:text></p>
	                   <input type="radio" name="dy_mc" value="000A" class="hand" onclick="$.csSelect.changeMC('000A','6410')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00AA','6881')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="dy_mc" value="00AA" class="hand" onclick="$.csSelect.changeMC('00AA','6881')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box">
	                <h3><s:text name="SSB_QSGQMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAA','6882')" src="images/0AAA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGQMCJS_DY"></s:text></p>
	                  <input type="radio" name="dy_mc" value="0AAA" class="hand" onclick="$.csSelect.changeMC('0AAA','6882')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_BSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0BAA','6884')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_BSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="dy_mc" value="0BAA" class="hand" onclick="$.csSelect.changeMC('0BAA','6884')"/> </div>
	                <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SSB_QSGBMC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('0AAB','6883')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_QSGBMCJS_DY"></s:text></p>
	                   <input type="radio" name="dy_mc" value="0AAB" class="hand" onclick="$.csSelect.changeMC('0AAB','6883')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SBB_GDNHC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00C1','6412')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SSB_NHCJS_DY"></s:text></p>
	                  <input type="radio" name="dy_mc" value="00C1" class="hand" onclick="$.csSelect.changeMC('00C1','6412')"/></div>
	                  <div class="cleaner"></div>
	              </div>
	              <div class="portfolio_box margin_r50">
	                <h3><s:text name="SBB_WZHXC"></s:text></h3>
	                <div class="port_img"> <img class="hand" onclick="$.csSelect.changeMC('00D1','6987')" src="images/00AA.png" /> </div>
	                <div class="port_content">
	                  <p><s:text name="SBB_WZHXC"></s:text></p>
	                  <input type="radio" name="dy_mc" value="00D1" class="hand" onclick="$.csSelect.changeMC('00D1','6987')"/></div>
	                  <div class="cleaner"></div>
	              </div>
              </div>
              <div class="cleaner_h10"></div>
              <p><a href="#1" class="cross-link" title="Go to Page 1">&#171;<s:text name="SSB_SYY"></s:text></a> | <a href="#3" class="cross-link" title="Go to Page 3"><s:text name="SSB_XYY"></s:text> &#187;</a></p>
            </div>
          </div>
          <div class="panel" title=<s:text name="SSB_JBGY"></s:text>>
			<div class="wrapper">
              <h2><s:text name="SSB_JBGY"></s:text></h2>
              <div id="jbgy_img" class="image_wrapper fl_image"> <img src="images/51_37.png" alt="image"/> </div>
              <div id="all_jbgy" style="margin-top: 40px; margin-right: 70px;">
	                
              </div>
              <div class="cleaner_h20"></div>
              <p><a href="#2" class="cross-link" title="Go to Page 2">&#171;<s:text name="SSB_SYY"></s:text></a> | <a href="#4" class="cross-link" title="Go to Page 4"><s:text name="SSB_XYY"></s:text> &#187;</a></p>
            </div>
          </div>
          <div class="panel" title=<s:text name="SSB_GYXZ"></s:text>>
            <div class="wrapper">
              <h2><s:text name="SSB_GYXZ"></s:text></h2>
              <div id="selectGY" class="scrollCss" style="width:747px; height:300px;">
					<table id="kx_gyxz3">
						<tr>
							<td align="left" width="165px" valign="top">
						            <h3><s:text name="SSB_KZL"></s:text></h3>
						            <table>
							           	<tr><td align="left"><label class="hand"><input type="checkbox" name="kzl" onclick="$.csSelect.changeKhzd(this)" value="1925"/><s:text name="SSB_GKK"></s:text></label></td></tr>
							           	<tr><td align="left"><label class="hand"><input type="checkbox" name="kzl" onclick="$.csSelect.changeKhzd(this)" value="1379"  /><s:text name="SSB_NJK"></s:text></label></td></tr>
							           	<tr><td align="left"><label class="hand"><input type="checkbox" name="kzl" onclick="$.csSelect.changeKhzd(this)" value="1924"/><s:text name="SSB_BKK"></s:text></label></td></tr>
							           	<tr><td align="left"><label class="hand"><input type="checkbox" name="kzl" onclick="$.csSelect.changeKhzd(this)" value="1923"/><s:text name="SSB_MLBK"></s:text></label></td></tr>
							           	<!-- <tr><td align="left"><label class="hand"><input type="radio" name="kzl" onclick="$.csSelect.changeKhzd('kzl','"/>面料包扣用客户指定料</label></td></tr>
							           	<tr><td id="kzl_"></td></tr> -->
							           	<tr><td align="left"><label class="hand"><input type="checkbox" name="kzl" onclick="$.csSelect.changeKhzd(this)" value="375"/><s:text name="SSB_KHZDK"></s:text></label></td></tr>
						            	<tr><td id="kzl_375"></td></tr>
						            </table>
							</td>
							<td align="left" width="165px" valign="top">
					                <h3><s:text name="SSB_XDXS"></s:text></h3>
					                <table>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xdxs" onclick="$.csSelect.changeKxgy(this)" value="130" /> <s:text name="SSB_ZCXD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xdxs" onclick="$.csSelect.changeKxgy(this)" value="131" /><s:text name="SSB_HXXD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xdxs" onclick="$.csSelect.changeKxgy(this)" value="132" /><s:text name="SSB_CXXD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xdxs" onclick="$.csSelect.changeKxgy(this)" value="133" /><s:text name="SSB_SKXXD"></s:text></label></td></tr>
					             	</table>
							</td>
							<td align="left" width="165px" valign="top">
					                <h3><s:text name="SSB_HBKXXS"></s:text></h3>
					                <table>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="215" /><s:text name="SSB_HBSKC"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="213" /><s:text name="SSB_HBWKC"></s:text></label> </td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="214" /><s:text name="SSB_HBDKC"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="216" /><s:text name="SSB_SKCDZ"></s:text></label></td></tr>
					              	</table>
							</td>
							<td align="left" width="165px" valign="top">
					                <h3><s:text name="SSB_HKCTZ"></s:text></h3>
					                <table>
						             	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkctz" onclick="$.csSelect.changeKxgy(this)" value="1922" /><s:text name="SSB_HKCJ8"></s:text></label></td></tr>
						             	<tr><td align="left"><label class="hand"><input type="checkbox" name="hbkctz" onclick="$.csSelect.changeKxgy(this)" value="1921" /><s:text name="SSB_HKCJ14"></s:text></label></td></tr>
					            	</table>
							</td>
						</tr>
						<tr>
							<td align="left" width="165px" valign="top">
					               <h3><s:text name="SSB_XCXS"></s:text></h3>
					               <table>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xcxs" onclick="$.csSelect.changeKxgy(this)" value="179" /><s:text name="SSB_ZXCZSY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xcxs" onclick="$.csSelect.changeKxgy(this)" value="515" /><s:text name="SSB_ZXCXSY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xcxs" onclick="$.csSelect.changeKxgy(this)" value="516" /><s:text name="SSB_ZKXCXKY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xcxs" onclick="$.csSelect.changeKxgy(this)" value="178" /><s:text name="SSB_ZKXCZKY"></s:text></label></td></tr>
					               </table>
							</td>
							<td align="left" width="165px" valign="top">
					               <h3><s:text name="SSB_XKSL"></s:text></h3>
					               <table>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="194" /><s:text name="SSB_4LPK"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="199" /><s:text name="SSB_4LDK"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="193" /><s:text name="SSB_3LPK"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="198" /><s:text name="SSB_3LDK"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="195" /><s:text name="SSB_5LPK"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="xksl" onclick="$.csSelect.changeKxgy(this)" value="481" /><s:text name="SSB_5LDK"></s:text></label></td></tr>
					               </table>
							</td>
							<td align="left" width="165px" valign="top">
					                <h3><s:text name="SSB_BTYXS"></s:text></h3>
					               	<table>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="btyxs" onclick="$.csSelect.changeKxgy(this)" value="76" /><s:text name="SSB_ZZBTY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="btyxs" onclick="$.csSelect.changeKxgy(this)" value="78" /><s:text name="SSB_BTZKKY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="btyxs" onclick="$.csSelect.changeKxgy(this)" value="77" /><s:text name="SSB_ZYBTY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="btyxs" onclick="$.csSelect.changeKxgy(this)" value="79" /><s:text name="SSB_BTYZKKY"></s:text></label> </td></tr>
					               	</table>
							</td>
							<td align="left" width="165px" valign="top">
					                <h3><s:text name="SSB_BTK"></s:text></h3>
					                <table id="btk_radio">
					            	</table>
							</td>
						</tr>
						<tr>
							<td align="left" width="175px" valign="top">
							      <h3><s:text name="SSB_XKDXS"></s:text></h3>
					              <table>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="145_160" /><s:text name="SSB_ZCXKD"></s:text></label> </td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="145_160_166" /><s:text name="SSB_ZCJPD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="148_160" /><s:text name="SSB_SKXXKD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="148_160_168" /><s:text name="SSB_SKXJPD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="145_161" /><s:text name="SSB_XXKD"></s:text></label></td></tr>
						              	<tr><td align="left"><label class="hand"><input type="checkbox" name="xkdxs" onclick="$.csSelect.changeKxgy(this)" value="145_161_166" /><s:text name="SSB_XJPD"></s:text></label></td></tr>
					              </table>
							</td>
							<td align="left" width="165px" valign="top">
					              <h3><s:text name="SSB_GMXS"></s:text></h3>
					              <table>
						             	<tr><td align="left"><label class="hand"><input type="checkbox" name="gmxs" onclick="$.csSelect.changeKxgy(this)" value="219" /><s:text name="SSB_ZGM"></s:text></label></td></tr>
						             	<tr><td align="left"><label class="hand"><input type="checkbox" name="gmxs" onclick="$.csSelect.changeKxgy(this)" value="220" /><s:text name="SSB_WGM"></s:text></label></td></tr>
						             	<tr><td align="left" title=<s:text name="SSB_DGMBX"></s:text>><label class="hand"><input type="checkbox" name="gmxs" onclick="$.csSelect.changeKxgy(this)" value="224" /><s:text name="SSB_DGM"></s:text></label></td></tr>
					              </table>
							</td>
							<td align="left" width="165px" valign="top"  colspan="2">
					              <h3><s:text name="SSB_LZZX"></s:text></h3>
					              <table>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_226" /><s:text name="SSB_QYXB"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="1995_226" /><s:text name="SSB_QZXB"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_615" /><s:text name="SSB_2BZBY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_227" /><s:text name="SSB_2YYTY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_617" /><s:text name="SSB_3BZBY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_228" /><s:text name="SSB_3BYTY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_229" /><s:text name="SSB_4BZBY"></s:text></label></td></tr>
						               	<tr><td align="left"><label class="hand"><input type="checkbox" name="lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="201_619" /><s:text name="SSB_4BYTY"></s:text></label></td></tr>
						          </table> 
							</td>
						</tr>
					</table>
					<table id="kx_gyxz2000" style="display: none; ">
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_KZL"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kzl" onclick="$.csSelect.changeKhzd(this)" value="2967" /><s:text name="SSB_GKK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kzl" onclick="$.csSelect.changeKhzd(this)" value="2635" /><s:text name="SSB_NJK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kzl" onclick="$.csSelect.changeKhzd(this)" value="2964" /><s:text name="SSB_BKK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kzl" onclick="$.csSelect.changeKhzd(this)" value="2965" /><s:text name="SSB_MLBK"></s:text> </label></td></tr>
									<!-- <tr><td align="left"><label class="hand"><input type="radio" name="xk_kzl" onclick="$.csSelect.changeKhzd('xk_kzl','" />面料包扣客户指定料 </label></td></tr>
									<tr><td id="xk_kzl_"></td></tr> -->
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kzl" onclick="$.csSelect.changeKhzd(this)" value="2192" /><s:text name="SSB_KHZDK"></s:text></label></td></tr>
									<tr><td id="xk_kzl_2192"></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_KYTJXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kytjxs" onclick="$.csSelect.changeKhzd(this)" value="2108" /><s:text name="SSB_CYTJK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kytjxs" onclick="$.csSelect.changeKhzd(this)" value="2109" /><s:text name="SSB_CYTJB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_kytjxs" onclick="$.csSelect.changeKhzd(this)" value="2973" /><s:text name="SSB_SJTJY"></s:text> </label></td></tr>
									<!-- <tr><td align="left"><label class="hand"><input type="radio" name="xk_kytjxs" onclick="$.csSelect.changeKhzd('xk_kytjxs','" />腰间加调节钎子 </label></td></tr>
									<tr><td id="xk_kytjxs_"></td></tr>
									<tr><td align="left"><label class="hand"><input type="radio" name="xk_kytjxs" onclick="$.csSelect.changeKhzd('xk_kytjxs','" />后中缝加调节钎子 </label></td></tr>
									<tr><td id="xk_kytjxs_"></td></tr> -->
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_DJXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_djxs" onclick="$.csSelect.changeKxgy(this)" value="2957" /><s:text name="SSB_YZDJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_djxs" onclick="$.csSelect.changeKxgy(this)" value="2956" /><s:text name="SSB_ZDJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_djxs" onclick="$.csSelect.changeKxgy(this)" value="2955" /><s:text name="SSB_YZHDJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_djxs" onclick="$.csSelect.changeKxgy(this)" value="2954" /><s:text name="SSB_FSDJ"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_JKXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2146" /><s:text name="SSB_NZ5"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2150" /><s:text name="SSB_32WF"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2151" /><s:text name="SSB_38WF"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2976" /><s:text name="SSB_38QWF"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2975" /><s:text name="SSB_51QWF"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_jkxs" onclick="$.csSelect.changeKxgy(this)" value="2147" /><s:text name="SSB_NZ64"></s:text> </label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_BJTXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2094_2098" /><s:text name="SSB_JG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2093_2098" /><s:text name="SSB_YG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2092_2098" /><s:text name="SSB_FG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2092_2099" /><s:text name="SSB_FSG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2093_2504" /><s:text name="SSB_YJX"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2094_2504" /><s:text name="SSB_JJX"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtxs" onclick="$.csSelect.changeKxgy(this)" value="2092_2504" /><s:text name="SSB_FJX"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_BDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2972_2064" /><s:text name="SSB_ZZBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2062_2064" /><s:text name="SSB_LZBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2971_2064" /><s:text name="SSB_FZBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2971_2065" /><s:text name="SSB_FYBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2972_2065" /><s:text name="SSB_ZYBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2777" /><s:text name="SSB_SJYBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2062_2065" /><s:text name="SSB_LYBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2970_2065" /><s:text name="SSB_FDYBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bdxs" onclick="$.csSelect.changeKxgy(this)" value="2969_2065" /><s:text name="SSB_LDYBD"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_BJTCD"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2104" /><s:text name="SSB_BJT75"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2101" /><s:text name="SSB_BJT55"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2102" /><s:text name="SSB_BJT6"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2103" /><s:text name="SSB_BJT65"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2092_2974" /><s:text name="SSB_FBJT45"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2094_2518" /><s:text name="SSB_JBJT51"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2092_2101" /><s:text name="SSB_FBJT51"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2093_2518" /><s:text name="SSB_YBJT51"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2094_2103" /><s:text name="SSB_JBJT64"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2092_2103" /><s:text name="SSB_FBJD64"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2093_2519" /><s:text name="SSB_YBJT64"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2092_2104" /><s:text name="SSB_FBJT75"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_bjtcd" onclick="$.csSelect.changeKxgy(this)" value="2093_2104" /><s:text name="SSB_YBJT75"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_HDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2070_2088" /><s:text name="SSB_SKX"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2345_2088"/><s:text name="SSB_SKXDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2079_2088" /><s:text name="SSB_SKXBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2081_2088"  /><s:text name="SSB_SKXJKB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2082_2088" /><s:text name="SSB_SKXFKB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2083_2088" /><s:text name="SSB_SKXYKB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2524_2088" /><s:text name="SSB_BZ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2074_2088" /><s:text name="SSB_BZDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2643_2088" /><s:text name="SSB_DXG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2644_2088" /><s:text name="SSB_DXDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2525_2088" /><s:text name="SSB_LXG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2075_2088" /><s:text name="SSB_LXDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="3241_2088" /><s:text name="SSB_BJJG"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2645_2088" /><s:text name="SSB_BJJDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2526_2088" /><s:text name="SSB_BJJDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2076_2088" /><s:text name="SSB_JJGDK"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2069_2088" /><s:text name="SSB_DKXHD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="xk_hdxs" onclick="$.csSelect.changeKxgy(this)" value="2078_2088" /><s:text name="SSB_DKXDK"></s:text> </label></td></tr>
								</table>
							</td>
						</tr>
					</table>
					<table id="kx_gyxz3000" style="display: none; ">
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_GJXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_gjxs" onclick="$.csSelect.changeKxgy(this)" value="3053" /><s:text name="SSB_GJMSJX"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_gjxs" onclick="$.csSelect.changeKxgy(this)" value="3051" /><s:text name="SSB_ZCGJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_gjxs" onclick="$.csSelect.changeKxgy(this)" value="3052" /><s:text name="SSB_PJBZ"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="160px">
								<h3><s:text name="SSB_XBXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xbxs" onclick="$.csSelect.changeKxgy(this)" value="3175" /><s:text name="SSB_PTYB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xbxs" onclick="$.csSelect.changeKxgy(this)" value="3177" /><s:text name="SSB_PTZB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xbxs" onclick="$.csSelect.changeKxgy(this)" value="3178" /><s:text name="SSB_ZBCKX9"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xbxs" onclick="$.csSelect.changeKxgy(this)" value="3176" /> <s:text name="SSB_BYYB"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="135px">
								<h3><s:text name="SSB_MJKD"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjkd" onclick="$.csSelect.changeKxgy(this)" value="3998" /><s:text name="SSB_MJK25"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjkd" onclick="$.csSelect.changeKxgy(this)" value="3997" /><s:text name="SSB_MJK3"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjkd" onclick="$.csSelect.changeKxgy(this)" value="3867" /><s:text name="SSB_MJK32"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjkd" onclick="$.csSelect.changeKxgy(this)" value="3866" /><s:text name="SSB_MJK35"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjkd" onclick="$.csSelect.changeKxgy(this)" value="3872" /><s:text name="SSB_MJK38"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="225px">
								<h3><s:text name="SSB_QPXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_qpxs" onclick="$.csSelect.changeKxgy(this)" value="3335" /><s:text name="SSB_LFTB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_qpxs" onclick="$.csSelect.changeKxgy(this)" value="3341" /> <s:text name="SSB_LFMJTB"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_qpxs" onclick="$.csSelect.changeKxgy(this)" value="7002" /> <s:text name="SSB_MJLF"></s:text></label></td></tr>
									<!-- <tr><td align="left"><label class="hand"><input type="radio" name="cy_qpxs" onclick="$.csSelect.changeKxgy('cy_qpxs','7004" />前片左右肩处加沿条外露0.3cm </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="radio" name="cy_qpxs" onclick="$.csSelect.changeKxgy('cy_qpxs','7005" />前片左右肩处加沿条外露0.6cm </label></td></tr> -->
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_qpxs" onclick="$.csSelect.changeKxgy(this)" value="7003" /><s:text name="SSB_QPDBF"></s:text> </label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_HBXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3055" /><s:text name="SSB_HBWZ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3355" /><s:text name="SSB_HBSZ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3060" /><s:text name="SSB_HBFGZZ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3059" /><s:text name="SSB_HBGZZ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3056" /><s:text name="SSB_HBSS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3057" /><s:text name="SSB_HBGZDD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3058" /><s:text name="SSB_HBGZSS"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="7006" /><s:text name="SSB_HBWZ3YT"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_hbxs" onclick="$.csSelect.changeKxgy(this)" value="3358" /><s:text name="SSB_HBSZSS"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="160px">
								<h3><s:text name="SSB_XT"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3107" /><s:text name="SSB_ZYY"></s:text>   </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3108" /><s:text name="SSB_ZYE"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3109" /><s:text name="SSB_ZEE"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3110" /><s:text name="SSB_ZSS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3095" /><s:text name="SSB_YYY"></s:text>  </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3096" /><s:text name="SSB_YYE"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3097" /><s:text name="SSB_YEE"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3098" /><s:text name="SSB_YSS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3833" /><s:text name="SSB_LYY"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3988" /><s:text name="SSB_LYE"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3445" /><s:text name="SSB_LEE"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3447" /><s:text name="SSB_LSS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3119" /><s:text name="SSB_FYS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3454" /><s:text name="SSB_FLS"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xt" onclick="$.csSelect.changeKxgy(this)" value="3127" /><s:text name="SSB_FZS"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="145px">
								<h3><s:text name="SSB_XTGD"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7009" /><s:text name="SSB_XTG6"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="3947"/><s:text name="SSB_XTG65"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="3960" /><s:text name="SSB_XTG7"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="3986" /><s:text name="SSB_XTG75"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="3782" /><s:text name="SSB_XTG8"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7010" /><s:text name="SSB_XTG85"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7011" /><s:text name="SSB_XTG9"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7012" /><s:text name="SSB_XTG6575"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7013" /><s:text name="SSB_XTG6676"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7014" /><s:text name="SSB_XTG67"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="3987" /><s:text name="SSB_XTG78"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7015" /><s:text name="SSB_XTG7989"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xtgd" onclick="$.csSelect.changeKxgy(this)" value="7016" /><s:text name="SSB_XTG89"></s:text> </label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="195px">
								<h3><s:text name="SSB_KD"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3164" /><s:text name="SSB_SJZZB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3166" /><s:text name="SSB_SJSJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3155" /><s:text name="SSB_FZZB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3156" /><s:text name="SSB_FJFB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3159" /><s:text name="SSB_FCBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3160" /><s:text name="SSB_FYJD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3170" /><s:text name="SSB_LJSJ"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3171" /><s:text name="SSB_LJFB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3172" /><s:text name="SSB_LZZB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3161" /><s:text name="SSB_DFA"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3162" /><s:text name="SSB_SFA"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3146" /> <s:text name="SSB_YZZB"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3147" /><s:text name="SSB_YJFB"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="3148" /> <s:text name="SSB_YSJ"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="7007" /><s:text name="SSB_LBD"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_kd" onclick="$.csSelect.changeKxgy(this)" value="7008" /><s:text name="SSB_LYJD"></s:text> </label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="135px">
								<h3><s:text name="SSB_LX"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lx" value="3990" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_YF2"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lx" value="3991" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_YF5"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lx" value="3948" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_RPLZ1"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lx" value="3930" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_XBH16"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="135px">
								<h3><s:text name="SSB_QT"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lzmx" value="3842" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_LMX15"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjmx" value="3843" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_MJMX15"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_lzxxg" value="3840" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_LZXXG"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xkdz" value="3944" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_BTXKDZ"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_mjhy" value="3945" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_MJHY"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_ltxy" value="3827" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_LTXY"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top">
								<h3><s:text name="SSB_XZ"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xz" value="3028" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_CX"></s:text> </label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="cy_xz" value="3029" onclick="$.csSelect.changeKxgy(this)" /><s:text name="SSB_DX"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" colspan="2">
								<h3><s:text name="SSB_KHZDK"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><s:text name="SSB_MJDK"></s:text><input type="text" class="input_text" id="cy_3092"/></label></td></tr>
									<tr><td align="left"><label class="hand"><s:text name="SSB_LTDK"></s:text><input type="text" class="input_text" id="cy_3030"/></label></td></tr>
									<tr><td align="left"><label class="hand"><s:text name="SSB_LDK"></s:text><input type="text" class="input_text" id="cy_3091"/></label></td></tr>
									<tr><td align="left"><label class="hand"><s:text name="SSB_XTDK"></s:text><input type="text" class="input_text" id="cy_7045"/></label></td></tr>
									<tr><td align="left"><label class="hand"><s:text name="SSB_DXHDK"></s:text><input type="text" class="input_text" id="cy_3090"/></label></td></tr>
								</table>
							</td>
						</tr>
					</table>
					<table id="kx_gyxz4000" style="display: none; ">
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_BTYXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_btyxs" onclick="$.csSelect.changeKxgy(this)" value="70035" /><s:text name="SSB_4541"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_btyxs" onclick="$.csSelect.changeKxgy(this)" value="70036" /><s:text name="SSB_4542"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_btyxs" onclick="$.csSelect.changeKxgy(this)" value="70037" /><s:text name="SSB_4543"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_btyxs" onclick="$.csSelect.changeKxgy(this)" value="70038" /><s:text name="SSB_4544"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_btyxs" onclick="$.csSelect.changeKxgy(this)" value="70039" /><s:text name="SSB_4545"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xdxs" onclick="$.csSelect.changeKxgy(this)" value="70053" /><s:text name="SSB_4179"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xdxs" onclick="$.csSelect.changeKxgy(this)" value="4042" /><s:text name="SSB_4110"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xdxs" onclick="$.csSelect.changeKxgy(this)" value="4043" /><s:text name="SSB_4111"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xdxs" onclick="$.csSelect.changeKxgy(this)" value="4044" /><s:text name="SSB_4112"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xdxs" onclick="$.csSelect.changeKxgy(this)" value="4045" /><s:text name="SSB_4113"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XKDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="4050" /><s:text name="SSB_4300"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="70033" /><s:text name="SSB_430B"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="4051" /><s:text name="SSB_4301"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="4052" /><s:text name="SSB_4302"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="4227" /><s:text name="SSB_41A0"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_HBXS_MJ"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_hbxs" onclick="$.csSelect.changeKxgy(this)" value="4070" /><s:text name="SSB_420L"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_hbxs" onclick="$.csSelect.changeKxgy(this)" value="4071" /><s:text name="SSB_420A"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_hbxs" onclick="$.csSelect.changeKxgy(this)" value="4072" /><s:text name="SSB_420B"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_hbxs" onclick="$.csSelect.changeKxgy(this)" value="4073" /><s:text name="SSB_421C"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_hbxs" onclick="$.csSelect.changeKxgy(this)" value="4138" /><s:text name="SSB_4202"></s:text></label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_KZL"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_kzl" onclick="$.csSelect.changeKxgy(this)" value="70141" /><s:text name="SSB_GKK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_kzl" onclick="$.csSelect.changeKxgy(this)" value="4886" /><s:text name="SSB_NJK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_kzl" onclick="$.csSelect.changeKxgy(this)" value="70142" /><s:text name="SSB_BKK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_kzl" onclick="$.csSelect.changeKxgy(this)" value="4982" /><s:text name="SSB_MLBK"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XKXS_MJ"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkxs" onclick="$.csSelect.changeKxgy(this)" value="4066" /><s:text name="SSB_401J"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkxs" onclick="$.csSelect.changeKxgy(this)" value="4067" /><s:text name="SSB_401Z"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="mj_xkxs" onclick="$.csSelect.changeKxgy(this)" value="4068" /><s:text name="SSB_401Y"></s:text></label></td></tr>
								</table>
							</td>
						</tr>
					</table>
					<table id="kx_gyxz6000" style="display: none; ">
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_BTYXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_btyxs" onclick="$.csSelect.changeKxgy(this)" value="6044" /><s:text name="SSB_4541"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_btyxs" onclick="$.csSelect.changeKxgy(this)" value="6045" /><s:text name="SSB_4542"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_btyxs" onclick="$.csSelect.changeKxgy(this)" value="6046" /><s:text name="SSB_4543"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_btyxs" onclick="$.csSelect.changeKxgy(this)" value="6043" /><s:text name="SSB_4544"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_btyxs" onclick="$.csSelect.changeKxgy(this)" value="6048" /><s:text name="SSB_4545"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_KZL"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_kzl" onclick="$.csSelect.changeKxgy(this)" value="60620" /><s:text name="SSB_GKK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_kzl" onclick="$.csSelect.changeKxgy(this)" value="6104" /><s:text name="SSB_NJK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_kzl" onclick="$.csSelect.changeKxgy(this)" value="60621" /><s:text name="SSB_BKK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_kzl" onclick="$.csSelect.changeKxgy(this)" value="6103" /><s:text name="SSB_MLBK"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xdxs" onclick="$.csSelect.changeKxgy(this)" value="6107" /><s:text name="SSB_6100"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xdxs" onclick="$.csSelect.changeKxgy(this)" value="6108" /><s:text name="SSB_ZCXD"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xdxs" onclick="$.csSelect.changeKxgy(this)" value="6109" /><s:text name="SSB_HXXD"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xdxs" onclick="$.csSelect.changeKxgy(this)" value="6110" /><s:text name="SSB_CXXD"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_HBKXXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="6191" /><s:text name="SSB_64N0"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="6739" /><s:text name="SSB_64N7"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="6192" /><s:text name="SSB_64N1"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_hbkcxs" onclick="$.csSelect.changeKxgy(this)" value="6736" /><s:text name="SSB_64N8"></s:text></label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XKDXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6123" /><s:text name="SSB_62S1"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6124" /><s:text name="SSB_6201"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6125" /><s:text name="SSB_6202"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6589" /><s:text name="SSB_6204"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6128" /><s:text name="SSB_6231"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6126" /><s:text name="SSB_62A1"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xkdxs" onclick="$.csSelect.changeKxgy(this)" value="6127" /><s:text name="SSB_62A2"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_GMXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6197" /><s:text name="SSB_ZGM"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6198" /><s:text name="SSB_WGM"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6115" /><s:text name="SSB_6130"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6116" /><s:text name="SSB_6131"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6723" /><s:text name="SSB_6139"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_gmxs" onclick="$.csSelect.changeKxgy(this)" value="6724" /><s:text name="SSB_6140"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XKSL"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6174" /><s:text name="SSB_4LPK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6429" /><s:text name="SSB_4LDK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6866" /><s:text name="SSB_6623"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6132" /><s:text name="SSB_3LPK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6740" /><s:text name="SSB_3LDK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6430" /><s:text name="SSB_5LPK"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xksl" onclick="$.csSelect.changeKxgy(this)" value="6431" /><s:text name="SSB_5LDK"></s:text></label></td></tr>
								</table>
							</td>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_XCXS"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6156" /><s:text name="SSB_ZXCZSY"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6158" /><s:text name="SSB_ZXCXSY"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6157" /><s:text name="SSB_ZKXCZKY"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6159" /><s:text name="SSB_ZKXCXKY"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6009" /><s:text name="SSB_661H"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6010" /><s:text name="SSB_661J"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6649" /><s:text name="SSB_665A"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="60541" /><s:text name="SSB_661K"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6868" /><s:text name="SSB_661L"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_xcxs" onclick="$.csSelect.changeKxgy(this)" value="6012" /><s:text name="SSB_661M"></s:text></label></td></tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" width="170px">
								<h3><s:text name="SSB_LZZX"></s:text></h3>
								<table>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="60435" /><s:text name="SSB_QYXB"></s:text></label></td></tr>
									<tr><td align="left"><label class="hand"><input type="checkbox" name="dy_lzzxyxk" onclick="$.csSelect.changeKxgy(this)" value="60436" /><s:text name="SSB_QZXB"></s:text></label></td></tr>
								</table>
							</td>
						</tr>
					</table>
              </div>
              <p id="2pcs_2000fabric"><a href="#3" class="cross-link" title="Go to Page 3">&#171;<s:text name="SSB_SYY"></s:text></a> | <a href="#5" class="cross-link" title="Go to Page 5"><s:text name="SSB_XYY"></s:text> &#187;</a></p>
              <p id="2pcs_3fabric" style="display: none;"><a href="#3" class="cross-link" title="Go to Page 3">&#171;<s:text name="SSB_SYY"></s:text></a> | <a href="#1" onclick="$.csSelect.setClothingXk(2000);"  class="cross-link" title="Go to Page 1"><s:text name="SSB_XYY"></s:text> &#187;</a></p>
              <p id="3pcs_2000fabric" style="display: none;"><a href="#3" class="cross-link" title="Go to Page 3">&#171;<s:text name="SSB_SYY"></s:text></a> | <a href="#1" onclick="$.csSelect.setClothingXk(4000);"  class="cross-link" title="Go to Page 1"><s:text name="SSB_XYY"></s:text> &#187;</a></p>
            </div>
          </div>
          <div class="panel" title=<s:text name="SSB_KXML"></s:text>>
            <div class="wrapper">
              <h2><s:text name="SSB_KXML"></s:text></h2>
			  <div id="fabrics">
			  </div>
              <div class="cleaner_h20"></div>
              <p><a href="#4" class="cross-link" title="Go to Page 4">&#171;<s:text name="SSB_SYY"></s:text></a></p>
               <form id="form">
					<table id="submit_button" style="float:right;">
		              	<tr>
		              		<td><div style="text-align:center;margin-right:15px; width:114px; height: 31px;background:url('images/btn.png'); cursor: pointer;color: #FFFC5A;" onclick="$.csSelect.size()"><s:text name="SSB_WCSJ"></s:text></div></td>
		              		<td><div style="text-align:center; width:114px; height: 31px;background:url('images/btn.png'); cursor: pointer;" onclick="$.csSelect.save()"><a style='TEXT-DECORATION:none;' href="../common/orden.jsp"><s:text name="SSB_SRSJ"></s:text></a></div></td>
		              	</tr>
	                </table>
	                <table id="submit_vals" style="display:none ;"></table>
               </form>
            </div>
          </div>
        </div>
        <!-- .panelContainer -->
      </div>
      <!-- #slider1 -->
      <!-- Change Logo -->
      <s:if test="#session.company.logo==10051">
	  </s:if>
	  <s:else>
	    <div id="change_logo" style="position:absolute; left:30px; top:-72px;"></div>
	  </s:else> 
    </div>
    <!-- .slider-wrap -->
    <p id="cross-links" style="width:0px; height: 0px; font-size:0; overflow: hidden;"> Same-page cross-link controls:<br />
      <a href="#1" class="cross-link">Page 1</a> | <a href="#2" class="cross-link">Page 2</a> | <a href="#3" class="cross-link">Page 3</a> | <a href="#4" class="cross-link">Page 4</a> | <a href="#5" class="cross-link">Page 5</a> </p>
    <!-- end of slider -->
  </div>
  <!-- end of templatemo_content -->
</div>
<!-- end of templatemo_content_wrapper -->
<div id="templatemo_footer_wrapper">
  <!-- <div id="templatemo_footer"> Copyright © 2011 <a href="http://www.rcmtm.com">红领集团版权所有</a>
    <div class="cleaner_h10"></div>
   <a>鲁ICP备05012826号</a> </div> -->
  <!-- end of templatemo_footer -->
</div>
</div>
<form>
	<table id="cameo_process" style="display: none;">
		<tr><td>驳头<input id="bt_val" value="51"  type="text"/></td></tr>
		<tr><td>前门扣<input id="kz_val" value="37"  type="text"/></td></tr>
		<tr><td>裤褶形式<input id="xk_kzxs_val" value="2034"  type="text"/></td></tr>
		<tr><td>前袋形式<input id="xk_qdxs_val" value="2049"  type="text"/></td></tr>
		<tr><td>领形<input id="cy_lx0_val" value="3063"  type="text"/></td></tr>
		<tr><td>门襟形式<input id="cy_mjxs_val" value="3040"  type="text"/></td></tr>
		<tr><td>扣种类<input id="kzl_val"  type="text"/></td></tr>
		<tr><td>扣种类<input id="xk_kzl_val"  type="text"/></td></tr>
		<tr><td>裤腰调节形式<input id="xk_kytjxs_val"  type="text"/></td></tr>
		<tr><td>大衣驳头<input id="dybt_val" value="6029"  type="text"/></td></tr>
		<tr><td>大衣前门扣<input id="dykz_val" value="6137"  type="text"/></td></tr>
		<tr><td>马夹驳头<input id="mjbt_val" value="4023"  type="text"/></td></tr>
		<tr><td>马夹前门扣<input id="mjkz_val" value="4038"  type="text"/></td></tr>
	</table>
</form>
</body> 
</html>
