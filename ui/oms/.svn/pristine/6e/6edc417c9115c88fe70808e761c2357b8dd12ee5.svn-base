<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>集成管控平台</title>
<link rel="shortcut icon" href="img/naxin.ico" />
<link rel="stylesheet" type="text/css" href="/css/build_left_tree.css" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/themes/icon.css" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/demo/demo.css" />
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/jquery.min.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/jquery.easyui.min.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/SimpleTree.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/sys_left_menus.js"></script>
<script type="text/javascript">
/*初始化加载左侧菜单树*/
 var _menus = ${menusJson};
</script>

</head>
<body class="easyui-layout">
	<div data-options="region:'north'" style="height: 40px; background: #4C6C9B; padding: 10px; font-size: 14px;">
		<font style="color: #FFFFFF">欢迎您使用集成管控平台</font> <span class="head" style="float: right; padding-right: 20px;">
			<font style="color: #FFFFFF">欢迎您！ &nbsp;${userName } &nbsp;</font> <a id="loginOut" href="javascript:void(0)"><font
				style="color: #FFFFFF">安全退出</font></a>
		</span>

	</div>
	<div data-options="region:'west',split:true,title:'菜单信息'" style="width: 200px; background: #FFFFFF; padding: 10px;">
		<div class="st_tree" style="padding: 0px; margin: 0px;"></div>
	</div>
	<div data-options="region:'east',split:true,title:'其他'" style="width: 190px; background: #FFFFFF; padding: 2px;">
		<div id="cc" class="easyui-calendar" style="margin-top: -1px; margin-left: -1px;"></div>
	</div>
	<div data-options="region:'center'">

		<div id="tabs" class="easyui-tabs" fit="true" border="false">
			<div title="欢迎使用" style="padding: 20px; overflow: hidden;" id="home">
				<h1 style="text-align: center;">欢迎使用集成管控平台</h1>
			</div>
		</div>
	</div>

	<div data-options="region:'south',split:true" style="height: 50px; background: #E0ECFF; padding: 10px;">
		<div style="text-align: center;">版权所有</div>
	</div>
</body>
<script type="text/javascript">
	 //点击树形节点触发
	/*  $(function(){
	   $('#tt').tree({
	   	onClick: function(node){
	   		alert(node.url);
	   	}
	   });
	}); 
	 */
	$(document).ready(function () {
        $('.st_tree li a').click(function () {
            var tabTitle = $(this).text();
            var url = $(this).attr("href");
            addTab(tabTitle, url);
        
        }).hover(function () {
            $(this).parent().addClass("hover");
        }, function () {
            $(this).parent().removeClass("hover");
        });
        
      //创建一个tab
        function addTab(subtitle, url) {
            if (!$('#tabs').tabs('exists', subtitle)) {
                $('#tabs').tabs('add', {
                    title: subtitle,
                    content: createFrame(url),
                    closable: true,
                    width: $('#mainPanle').width() - 10,
                    height: $('#mainPanle').height() - 20
                });
            } else {
                $('#tabs').tabs('select', subtitle);
           }
            tabClose();
        }
      
     // tab 中显示的内容 url 页面路径
        function createFrame(url) {
            var s = '<iframe name="mainFrame" scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;margin-left: -15px;margin-right:-15px;padding-right:-10px;"></iframe>';
            return s;
        }
     
     
        function tabClose() {
            /*双击关闭TAB选项卡*/
            $(".tabs-inner").dblclick(function () {
                var subtitle = $(this).children("span").text();
                $('#tabs').tabs('close', subtitle);
            })

            $(".tabs-inner").bind('contextmenu', function (e) {
                $('#mm').menu('show', {
                    left: e.pageX,
                    top: e.pageY,
                });
                var subtitle = $(this).children("span").text();
                $('#mm').data("currtab", subtitle);
                return false;
            });
        }

        //绑定右键菜单事件
   function tabCloseEven() {
            //关闭当前
     $('#mm-tabclose').click(function () {
                var currtab_title = $('#mm').data("currtab");
                $('#tabs').tabs('close', currtab_title);
            })
            //全部关闭
     $('#mm-tabcloseall').click(function () {
                $('.tabs-inner span').each(function (i, n) {
                    var t = $(n).text();
                   $('#tabs').tabs('close', t);
                });
            });

            //关闭除当前之外的TAB
            $('#mm-tabcloseother').click(function () {
                var currtab_title = $('#mm').data("currtab");
                $('.tabs-inner span').each(function (i, n) {
                    var t = $(n).text();
                    if (t != currtab_title)
                        $('#tabs').tabs('close', t);
                });
            });
            //关闭当前右侧的TAB
            $('#mm-tabcloseright').click(function () {
                var nextall = $('.tabs-selected').nextAll();
                if (nextall.length == 0) {
                    alert('没有选项卡');
                    return false;
                }
                nextall.each(function (i, n) {
                    var t = $('a:eq(0) span', $(n)).text();
                    $('#tabs').tabs('close', t);
                });
                return false;
           });
            //关闭当前左侧的TAB
            $('#mm-tabcloseleft').click(function () {
                var prevall = $('.tabs-selected').prevAll();
                if (prevall.length == 0) {
                    alert('没有选项卡');
                    return false;
                }
                prevall.each(function (i, n) {
                    var t = $('a:eq(0) span', $(n)).text();
                    $('#tabs').tabs('close', t);
                });
                return false;
            });

          
        }
  //点击左侧菜单  
 $(".st_tree").SimpleTree({
       click:function(a){
           if(!$(a).attr("hasChild"))
               alert($(a).attr("ref"));
       }
   });
   
   //退出系统
   $("#loginOut").click(function(){
	  window.location.href="/sysUser/loginOut.action";
   })
      
	});
	 
</script>
</html>