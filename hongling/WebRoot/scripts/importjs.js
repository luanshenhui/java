var IS_NET = false;
var SERVICE_ROOT = "/hongling";
var PAGE_SIZE = 15;
var DICT_CATEGORY_MEMBER_GROUP = 5;
var DICT_CATEGORY_MEMBER_STATUS = 6;
var DICT_CATEGORY_INFORMATION_CATEGORY = 7;
var DICT_CATEGORY_FABRIC_CATEGORY = 8;
var DICT_CATEGORY_GENDER = 10;
var DICT_CATEGORY_BOOL = 12;
var DICT_CATEGORY_WEIGHTUNIT = 29;
var DICT_CATEGORY_HEIGHTUNIT = 30;
var DICT_CATEGORY_PAYTYPE = 31;
var DICT_CATEGORY_BACKEND_MENU =33;
var DICT_CATEGORY_ORDEN_AUTO = 36;
var DICT_CATEGORY_FABRIC_SUPPLY_CATEGORY = 34;
var DICT_CATEGORY_CLIENT_PIECE_VALID = 37;
var DICT_CATEGORY_APPLY_DELIVERY_TYPE = 38;
var DICT_CATEGORY_APPLY_DELIVERY_DAYS = 39;
var DICT_CATEGORY_MONEYSIGN = 40;
var DICT_CATEGORY_STYLE = 41;
var DICT_CATEGORY_HOMEPAGE = 44;
var DICT_CATEGORY_IOFLAG = 45;
var DICT_CATEGORY_BODYTYPE = 32;
var DICT_BODY_TYPE=10284;//着装风格默认值
var DICT_CLONTHING_SIZE=10368;//成衣尺寸默认值
var DICT_CATEGORY_SHIPPING_PAY_TYPE=48; // 快递付款方式
var DICT_CATEGORY_BUSINESS_UNIT=49; //经营单位
var DICT_CATEGORY_PRICE_TYPE=50; // 定价方式
var DICT_CUSTOMER_SPECIFIED= 10008; // 客户指定

var DICT_CATEGORY_ORDEN_STATUS = 9;

var VERSION_CN = 1;
var VERSION_EN = 2;
var VERSION_DE = 3;
var VERSION_FR = 4;
var VERSION_JA = 5;
var DICT_YES = 10050;
var DICT_NO = 10051;
var DICT_VIEW_FRONT = 10004;
var DICT_VIEW_BACK = 10005;
var DICT_DESIGN_STYLE='24,2021,3016,4016,6007';//设计款式

var DICT_SIZE_CATEGORY_NAKED= 10052;//净体
var DICT_SIZE_CATEGORY_CLOTH= 10053;//成衣
var DICT_SIZE_CATEGORY_STANDARD= 10054;//标准号加减

var DICT_GROUP_STATUS_COMMON_USER = 10250;
var DICT_GROUP_STATUS_MANAGER_USER = 10251;
var DICT_BACKEND_MENU_ORDEN_MANAGER = 10300;
var DICT_BACKEND_MENU_FABRIC_MANAGER = 10301;
var DICT_BACKEND_MENU_INFORMATION_MANAGER = 10302;
var DICT_BACKEND_MENU_MEMBER_MANAGER = 10303;
var DICT_BACKEND_MENU_AUTHORITY_MANAGER = 10304;
var DICT_BACKEND_MENU_CASH_MANAGER = 10305;
var DICT_BACKEND_MENU_DELIVERY_MANAGER = 10309;
var DICT_BACKEND_MENU_MY_MESSAGE = 10308;
// 快递公司
var DICT_BACKEND_MENU_EXPRESSCOM_MANAGE = 10310;
// 查看订单
var DICT_BACKEND_MENU_VIEWORDEN_MANAGE = 10312;
var DICT_BACKEND_MENU_REALMNAME_MANAGE = 10313;

var DICT_MEMBER_PAYTYPE_ONLINE = 10270;

var DICT_FABRIC_SUPPLY_CATEGORY_REDCOLLAR = 10320;
var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_LARGE = 10321;
var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_PIECE = 10322;
var DICT_APPLY_DELIVERY_TYPE_AUTO = 10336;

var DICT_CLOTHING_SUIT2PCS =1;
var DICT_CLOTHING_SUIT3PCS =2;
var DICT_CLOTHING_ShangYi =3;
var DICT_CLOTHING_PANT=2000;
var DICT_CLOTHING_ChenYi=3000;
var DICT_CLOTHING_MaJia=4000;
var DICT_CLOTHING_PeiJian=5000;
var DICT_CLOTHING_DaYi=6000;

var DICT_FABRIC_SUPPLY_CATEGORY_CLIENT ='MTDsuit,MTDshirt';
var XKBODY = "10284,10282,10286,10287,10285";//西裤着装风格
var PRICE ="1375,2619,3714,4640,6603";//上衣、西裤、衬衣、马夹、大衣的价格

var DICT_CM=10266;//身高--厘米
var DICT_FABRIC ="8001,8030,8050";//面料选择id
var DICT_QT ="313,331,340,371,345,363,386,1225,2170,2192,2180,2186,2199,3215,3235,3233,4088,4093,4112,4102,4107,4123,6291,6309,6318,6322,6349,6438,6364";//线、扣、袖里、领地呢、里料id

var LAPEL = 1119;//驳头型
var FRONTBUTTON = 35;//前门扣
var GROUPID_CAIWU = 10257;//财务账户id

var DELIVERY_STATE_APPLY = 20130; // 发货状态：已申请
var DELIVERY_STATE_LADE = 20131; // 发货状态：已提货
var DELIVERY_STATE_CANCLE = 20132; // 发货状态：已撤销

document.writeln("<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />");
document.writeln("<meta http-equiv='pragma' content='no-cache' />");
document.writeln("<meta http-equiv='cache-control' content='no-store' />");
document.writeln("<meta http-equiv='expires' content='0' />");

document.writeln("<script type='text/javascript' src='../../scripts/jquery/json2.js'></script>");
//document.writeln("<script type='text/javascript' src='../../scripts/jquery/jquery.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/flowplayer/flowplayer-3.2.11.min.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/flowplayer/flowplayer.ipad-3.2.12.min.js'></script>");

document.writeln("<script type='text/javascript' src='../../scripts/jquery/bgiframe.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/maccordion.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/xheditor/xheditor.zh-cn.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/cookie.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/autocomplete.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/slides.js'></script>");
//document.writeln("<script type='text/javascript' src='../../scripts/jquery/hotkeys.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/jtemplate.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/pagination.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/menu.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/form.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/update.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/window.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/date.format.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/swfupload/handlers.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/swfupload/fileprogress.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/swfupload/swfupload.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/swfupload/swfupload.queue.js'></script>");
//document.writeln("<script type='text/javascript' src='../../scripts/jquery/ztree.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/chart/highcharts.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/chart/exporting.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/datepicker/WdatePicker.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/multiselect.js'></script>");
document.writeln("<script type='text/javascript' src='../../scripts/jquery/core.js'></script>");

document.writeln("<script type='text/javascript' src='../../scripts/base.js'></script>");

//document.writeln("<link href='../../scripts/jquery/swfupload/css/default.css' rel='stylesheet' type='text/css' />");
document.writeln("<link href='../../scripts/jquery/window/basic.css' type='text/css' rel='stylesheet' />");
document.writeln("<link href='../../scripts/jquery/pagination/style.css' type='text/css' rel='stylesheet' />");
document.writeln("<link href='../../scripts/jquery/autocomplete/style.css' type='text/css' rel='stylesheet' />");
//document.writeln("<link href='../../scripts/jquery/xheditor/style.css' type='text/css' rel='stylesheet' />");
//document.writeln("<link href='../../scripts/jquery/menu/menu.css' type='text/css' rel='stylesheet' />");
document.writeln("<link href='../../themes/default/style.css' type='text/css' rel='stylesheet' />");
//document.writeln("<link href='../../scripts/jquery/zTreeStyle/zTreeStyle.css' type='text/css' rel='stylesheet' />");
//document.writeln("<link href='../../scripts/jquery/maccordion/style.css' type='text/css' rel='stylesheet' />");