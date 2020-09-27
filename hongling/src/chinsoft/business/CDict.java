package chinsoft.business;
import chinsoft.entity.Dict;
public class CDict{
	public static final int PAGE_SIZE = 15;
	public static final String DES_KEY="RCMTM001"; //数据加密密钥
	public static final String CUSTORMERTEXT =",421,2207,3676,4149,6396,5082,95042,98033,";//刺绣内容
	public static final String EMBROID="417,2318,3246,4147,5081,6395,95039,98029";//刺绣部位
	public static final String EMBROIDPOSITION = "1218,2507,3201,4550,6437,5130,95043,98030";//上衣、西裤、衬衣、马夹、大衣、配件刺绣位置parentid
	public static final String EMBROIDCOLOR = "422,2213,3631,4150,6404,5088,95040,98031";//上衣、西裤、衬衣刺绣颜色parentid
	public static final String EMBROIDFONT = "518,2523,3248,4155,6413,5089,95041,98032";//上衣、西裤、衬衣刺绣字体parentid
	public static final String EMBROIDSIZE = "3259";//衬衣刺绣大小parentid
	public static final String COLORS = "430,2214,3632,4477,6405,95044,98041";//上衣、西裤、衬衣、马夹、大衣刺绣颜色（默认）
	public static final String FONTS = "528,2586,3622,4158,6414,95109,98102";//上衣、西裤、衬衣、马夹、大衣刺绣字体（默认）
	public static final String SIZE = "3261";//衬衣绣字大小（默认）
	public static final String COLORFABRIC="307,2159,3199,4081,5080";//撞色面料
	public static final String FABRICLABEL="574,3271,2233";//面料标
	
	
	public static final int CLOTHINGSIZEID=10054;//成衣ID
	public static final int CUSTORMERSIZEID=10052;//量体ID

	public static final Integer LININGID=8051;//里料ID
	public static final String NORMALBODY="10085,10086,10087,10088,10090,10091,10092,10368";//正常特体ID
	public static final String CLASSICDICT="451,456,460,452";//经典设计驳头撞色
	public static final String CLOTHINGSTYLE = "32";//着装风格
	public static final String SHOULDER = "19,20,21,22";//溜肩(左)溜肩(右)耸肩(左)耸肩(右)
	public static final String PRICE ="1375,2619,3714,4640,6603";//上衣、西裤、衬衣、马夹、大衣的价格
	public static final String STYLENUM ="1374,2618,3713,4639,6602,90082,95031,98023";//上衣、西裤、衬衣、马夹、大衣的款式号
//	public static final String BXLB ="1969,1970,1964,1962,2988,2987";//西服版型类别
	public static final String BXLB ="33,34,358,2029,2030";//西服版型类别
	public static final String BCPSY ="1993,2998,6993,4998";//半成品试衣(上衣、西裤)
	public static final String FRONTBUTTON ="35";//前门扣
	public static final String LAPELS ="50";//驳头选择
//	public static final String NOLABELPARENTID="564,576,2512,2641,3270,3273";//上衣、西裤、衬衣 无商标设计、无面料标设计ID
//	public static final String LABELPARENTID="562,574,2232,2233,3268,3271";//商标设计、面料标设计ID
//	public static final String CUSTOMERLABELSITEID="563,575,2498,2505,3281,3287";//上衣、西裤、衬衣商标、面料标位置id
//	public static final String CUSTOMERLABELID="20111,20112,20113,20114,20115,20116";//上衣、西裤、衬衣商标、面料标自定义内容id
//	public static final String LABELIDS="1014,1185,2590,2642,3280,3272,20111,20112,20113,20114,20115,20116";//上衣、西裤、衬衣商标、面料标id
	public static final String NOLABELPARENTID="564,2512,3270";//上衣、西裤、衬衣 无商标设计、无面料标设计ID
	public static final String LABELPARENTID="562,2232,3268";//商标设计ID
	public static final String CUSTOMERLABELSITEID="563,2498,3281";//上衣、西裤、衬衣商标位置id
	public static final String CUSTOMERLABELID="20111,20112,20113";//上衣、西裤、衬衣商标自定义内容id
	public static final String LABELIDS="1014,2590,3280,20111,20112,20113";//上衣、西裤、衬衣商标id
	
	public static final String POCKET_KX =",0231,02M1,02M2,02M3,02M4,0232,0234,02B6,02B9,02G6,02G7,02G8,02C6,02C7,02C8,02C9,02E6,02N1,02N2,02N3,02N4,02N5,02D1,02D3,02D6,";//下口袋样式-下口袋开线
	public static final String POCKET_MT =",02J1,02K3,02K4,02U1,02U2,02U3,02T1,02T2,02T3,02T4,02T5,02T6,02M8,02K8,02M9,02M5,02M6,02M7,";//下口袋样式-下口袋明贴
	public static final String CONTRAST_POCKET_KX = "0665";//撞色下口袋开线
	public static final String CONTRAST_POCKET_MT = "03A0";//撞色下口袋明贴
	public static final String CONTRAST_POCKET_DG = "0319";//撞色下口袋袋盖
	public static final String TICKETPOCKET_KX = ",027A,0271,";//票袋开线上衣
	public static final String CONTRAST_TICKETPOCKET_KX = "0669";//撞色票袋开线
	public static final String CONTRAST_TICKETPOCKET_DG = "03B2";//撞色票袋袋盖
	public static final String CHEST_POCKET_KX = ",4111,4112,4142,4143,";//胸口袋马夹
	public static final String CONTRAST_CHEST_POCKET_KX = "41U4";//撞色胸口袋开线
	public static final String CONTRAST_CHEST_POCKET_DG = "41U2";//撞色胸口袋袋盖
	public static final String POCKET_FLAP_KX = ",4300,4301,4169,4170,";//下口袋马夹
	public static final String CONTRAST_POCKET_FLAP_KX = "41U3";//撞色下口袋开线
	public static final String CONTRAST_POCKET_FLAP_DG = "41U1";//撞色下口袋袋盖
	public static final String CUFF = "5001,545Y,545W,543A";//袖头形式
	public static final String CAMEO_1T = "2113,2119,2529,2093,2098,2635,2124,2689,2155,2590,433,132,178,1379,1014,1185;2354,2356,2353,2990,2639,2355,2986,1889,1381,1382,1378,1380,1965,1963";//came套装默认工艺
	public static final String CAMEO_XF = "433,132,178,1379,1014,1185;1889,1381,1382,1378,1380,1965,1963";//came上衣默认工艺
	public static final String CAMEO_XK = "2113,2119,2529,2093,2098,2635,2124,2689,2155,2590;2354,2356,2353,2990,2639,2355,2986";//came西裤默认工艺
	public static final String CLX_1T = "2147,2033,2124,2689,2155,2093,2098,2334,2635,1379,52,432,36,97,1768,215,178,220,1779,565,1926,20111;2856,1473,1474,2681,2680,2682,2683,2356,2353,2679,1378,1381,1385,1950,20112;20112:MINGTH,20111:MINGTH,2679:KYFTC-CQXMYL,1473:MINGTH";//clx套装默认工艺
	public static final String CLX_XF = "52,432,36,97,1768,215,178,220,1779,565,1926,1379,20111;1474,1378,1381,1385,1473,1950;20111:MINGTH,1473:MINGTH";//clx上衣默认工艺
	public static final String CLX_XK = "2147,2033,2093,2124,2689,2155,2098,2334,2635;2856,2356,2353,2679,2680,2681,2682,2683,20112;20112:MINGTH,2679:KYFTC-CQXMYL";//clx西裤默认工艺
	public static final String CLX_CY = "3055,3066,3086,7012,3803,3119,3284,20113;7072;20113:MINGTH(白底)";//clx衬衣默认工艺
	public static final String CONTRASTALL="299,2158,3185,4076,6277";//上衣、西裤、马夹、大衣、衬衣撞色ID
	public static final String DEFAULTFABRIC="MVYZ003";//上衣、西裤、马夹撞色默认面料
	public static final String CYDEFAULTFABRIC="SAK547A";//衬衣撞色默认面料
	public static final String DYDEFAULTFABRIC="DBL512A";//大衣撞色默认面料
	public static final String STYLES ="1374,2618,4639,3713,6602,90082";//款式号
	public static final String CHEN3 ="1199,436,437,432,433,434,30134,30135,30136,30137,30138,30139,1008";//上衣衬类型
	public static final String CHEN_ALL="000A,000B,00C1,00C2,00D1,00AA,0AAA,0AAB,0BAA";//衬类型
	public static final String BUTTON_TWO="0015,0016,002F,0017,0018,0019,0020";//双排扣
	
	//语言分类
	public static final String EN = "2";
	public static final String DE = "3";
	public static final String FR = "4";
	public static final String JA = "5";
	
	//ERP平台兼容用户名前缀
	public static final String ERP_USER_PRE = "ORDER_SYS_";

	/**
	 * 星期类ID
	 */
	public static final Integer DICT_CATEGORY_APPLY_DELIVERY_DAYS = 39;
	
	//session常量
	public static final String SessionKey_CustomerInfo = "SessionCustomerInfo";
	public static final String SessionKey_ClothingID="Clothing_ID";
	public static final String SessionKey_FabricCode="FabricCode";
	public static final String SessionKey_ComponentIDs="ComponentIDs";
	public static final String SessionKey_CurrentComponentID="CurrentComponentID";
	public static final String SessionKey_ComponentTexts="ComponentTexts";
	public static final String SessionKey_Ordens="Ordens";
	public static final String SessionKey_CurrentDiscountsOfMember = "SessionCurrentDiscountsOfMember";
    //字典常量
	public static final Dict YES= DictManager.getDictByID(10050); //是
    public static final Dict NO = DictManager.getDictByID(10051); //否
    public static final Dict FabricFlagSeries = DictManager.getDictByID(10009); //面料系列标志
    public static final Dict FabricFlagColor = DictManager.getDictByID(10010); //面料色系标志
    public static final Dict FabricFlagFlower = DictManager.getDictByID(10011); //面料花型标志
    public static final Dict FabricFlagComposition = DictManager.getDictByID(10012); //面料成分标志
    public static final Dict Component = DictManager.getDictByID(10001); //部件
    public static final Dict Linked = DictManager.getDictByID(10003); //关联
    public static final Dict Parameter = DictManager.getDictByID(10002); //参数
    public static final Dict ComponentText = DictManager.getDictByID(10008); //文本部件
    
    

    public static final Dict ViewFront = DictManager.getDictByID(10004);  //前面
    public static final Dict ViewBack = DictManager.getDictByID(10005);  //背面
    public static final Dict ViewSelf = DictManager.getDictByID(10006);  //内部  

    public static final Dict ClothingSuit2PCS = DictManager.getDictByID(1);//2件套
    public static final Dict ClothingSuit3PCS = DictManager.getDictByID(2);//3件套
    public static final Dict ClothingPants= DictManager.getDictByID(2000);//西裤
    public static final Dict ClothingShangYi= DictManager.getDictByID(3);//单上衣
    public static final Dict ClothingDaYi= DictManager.getDictByID(6000);//大衣
    public static final Dict ClothingChenYi= DictManager.getDictByID(3000);//衬衣
    public static final Dict ClothingMaJia= DictManager.getDictByID(4000);//马夹
    public static final Dict ClothingPeiJian = DictManager.getDictByID(5000); // 配件
    public static final Dict ClothingSuit2PCS_MJXK = DictManager.getDictByID(4);//2件套_马夹+西裤
    public static final Dict ClothingSuit2PCS_LFXK = DictManager.getDictByID(5);//礼服套装（礼服+西裤）
    public static final Dict ClothingSuit2PCS_XFMJ = DictManager.getDictByID(6);//2件套_西服+马夹
    public static final Dict ClothingSuit2PCS_W2PCS = DictManager.getDictByID(7);//女套装
    public static final Dict ClothingLF = DictManager.getDictByID(90000);//礼服
    public static final Dict ClothingNXF = DictManager.getDictByID(95000);//女西服
    public static final Dict ClothingNXK = DictManager.getDictByID(98000);//女西裤

    public static final Dict GroupStatusCommonUser = DictManager.getDictByID(10250);//前台用户
    public static final Dict GroupStatusManagerUser = DictManager.getDictByID(10251);//后台用户

    public static final Dict OrdenStatusDesigning = DictManager.getDictByID(10037);//订单状态：设计中
    public static final Dict OrdenStatusSaving = DictManager.getDictByID(10035);//订单状态：保存中
    public static final Dict OrdenStatusFabricNotArrive = DictManager.getDictByID(10036);//订单状态：未到料
    public static final Dict OrdenStatusNotSubmit = DictManager.getDictByID(10028);//订单状态：待审核
    public static final Dict OrdenStatusStorage = DictManager.getDictByID(10032);//入库
    public static final Dict OrdenStatusPlateMaking = DictManager.getDictByID(10030);//订单初始状态：制版
    public static final Dict OrdenStatusStop = DictManager.getDictByID(10369);//订单状态：停滞
    public static final Dict OrdenStatusProduce = DictManager.getDictByID(10031); // 订单状态：生产
    public static final Dict OrdenStatusPaid = DictManager.getDictByID(10038);//订单初始状态：已支付待提交（在线支付）
    public static final Dict OrdenStatusStayPayments = DictManager.getDictByID(10039);//待支付

    public static final Dict OrdenAutoNot = DictManager.getDictByID(10326);//不托管
    public static final Dict OrdenAutoAnd = DictManager.getDictByID(10325);//托管

    public static final Dict UnitInch = DictManager.getDictByID(10265);//英寸
    public static final Dict FabricSupplyCategoryRedCollar = DictManager.getDictByID(10320);//红领料
    public static final Dict FabricSupplyCategoryClientPiece = DictManager.getDictByID(10322);//客供单块料
    public static final Dict FabricSupplyCategoryClientBatch = DictManager.getDictByID(10321);//客供成批料

    //public static final Dict ArtCategory1 = DictManager.getDictByID(4156);//工艺类别
    public static final Dict ArtCategory2 = DictManager.getDictByID(431);//上衣工艺类别
    public static final Dict ArtCategory3 = DictManager.getDictByID(1230);//上衣工艺类别
    public static final Dict ArtCategory4 = DictManager.getDictByID(6409);//大衣工艺类别
    public static final Dict ArtCategory5 = DictManager.getDictByID(2224);//西裤工艺类别
    public static final Dict ArtCategory6 = DictManager.getDictByID(4992);//马夹工艺类别
    public static final Dict ArtCategory7 = DictManager.getDictByID(90061);//礼服工艺类别
    public static final Dict ArtCategory8 = DictManager.getDictByID(95001);//女西服工艺类别
    public static final Dict ArtCategory9 = DictManager.getDictByID(98019);//女西裤工艺类别

    public static final Dict GenderMan = DictManager.getDictByID(10040);
    public static final Dict GenderFemale = DictManager.getDictByID(10041);
    public static final Dict STATUS_NORMAL = DictManager.getDictByID(10042);

    public static final Dict SizeCategoryNaked = DictManager.getDictByID(10052);//净体量体
    public static final Dict SizeCategoryStandard = DictManager.getDictByID(10054);//标准号大小
    
    public static final Dict MoneySignDollar = DictManager.getDictByID(10360);//美元
    public static final Dict MoneySignRmb = DictManager.getDictByID(10361);//人民币
    public static final int Unit_CM = 10266;  //厘米
    public static final Dict BodyStyle = DictManager.getDictByID(32);//着装风格
    public static final String Normal = "3";//正常款ecode
    public static final String BodyStyleNormal = "2";//着装风格--正常
    public static final String InterliningType = "000B";//半毛衬
    public static final String InterliningType_MJ = "00C1";//高档粘合衬
    public static final Dict NormalStyle = DictManager.getDictByID(20100);//正常款
    public static final Dict BackNormalStyle = DictManager.getDictByID(10086);//后仰体-正常体
    public static final int GROUPID_C = 10018;//C级用户id
    public static final int GROUPID_CAIWU = 10257;//财务账户id
    public static final int GROUPID_ZONGGUANLI = 10258;//总管理账户id
    public static final int ClothingSuit_CATEGORYID = 8001;
    public static final int ClothingChenYi_CATEGORYID = 8030;
    public static final int ClothingDaYi_CATEGORYID = 8050;
    
    public static final int IOFLAG_I = 20119;//收入
    public static final int IOFLAG_O = 20120;//支出

    public static final Dict Monday = DictManager.getDictByID(10341); // 星期一
    public static final Dict Tuesday = DictManager.getDictByID(10342); // 星期二
    public static final Dict Wednesday = DictManager.getDictByID(10343); // 星期三
    public static final Dict Thursday = DictManager.getDictByID(10344); // 星期四
    public static final Dict Friday = DictManager.getDictByID(10345); // 星期五
    public static final Dict Saturday = DictManager.getDictByID(10346); // 星期六
    public static final Dict Sunday = DictManager.getDictByID(10347); // 星期天
   
    public static final Dict ManualDeliveryType = DictManager.getDictByID(10335); // 手动发货
    public static final Dict AutoDeliveryType = DictManager.getDictByID(10336); // 自动发货
    
    public static final Dict DeliveryStateApply = DictManager.getDictByID(20130); // 发货状态：已申请
    public static final Dict DeliveryStateLade = DictManager.getDictByID(20131); // 发货状态：已提货
    public static final Dict DeliveryStateCancle = DictManager.getDictByID(20132); //发货状态：已撤销
    public static final Dict STATUS_DELIVERED = DictManager.getDictByID(10033);//已发货
    
    public static final Dict MTM_MANAGEMENTACCOUNT = DictManager.getDictByID(10253);//MTM管理用户
    public static final Dict RP_MANAGEMENTACCOUNT = DictManager.getDictByID(10255); // 瑞璞管理用户
    public static final Dict KM_MANAGEMENTACCOUNT = DictManager.getDictByID(10256); //凯妙管理用户
    public static final Dict CW_MANAGEMENTACCOUNT = DictManager.getDictByID(10257); // 财务管理用户
    public static final Dict ADMIN_MANAGERMENTACCOUNT = DictManager.getDictByID(10258); // 总管理用户
    public static final Dict ZMD_MANAGEMENTACCOUNT = DictManager.getDictByID(10254);//专卖店管理用户
    public static final Dict AA_CUSTOMERACCOUNT = DictManager.getDictByID(10015);   //AA级客户
    public static final Dict A_CUSTOMERACCOUNT = DictManager.getDictByID(10016);    //A级客户
    public static final Dict B_CUSTOMERACCOUNT = DictManager.getDictByID(10017);    //B级客户
    public static final Dict C_CUSTOMERACCOUNT = DictManager.getDictByID(10018);    //C级客户
    
    public static final Dict SHIPPINGPAYMENTTYPE_S = DictManager.getDictByID(20135);    //红领预付
    public static final Dict SHIPPINGPAYMENTTYPE_R = DictManager.getDictByID(20136);    //到付
    
    public static final Dict PAYTYPE_ONLINE = DictManager.getDictByID(10270); // 在线支付
    public static final Dict PAYTYPE_IMITATION = DictManager.getDictByID(10271); // 虚拟支付
    public static final Dict PAYTYPE_T_T = DictManager.getDictByID(10272); // 平台外支付
    
    public static final Dict DIRECT_SALES_STORE = DictManager.getDictByID(20141); // 直营店
    public static final Dict DOMESTIC_FRANCHISESS = DictManager.getDictByID(20142); //国内加盟商
    public static final Dict FOREIGN_FRANCHISESS = DictManager.getDictByID(20143); // 国外加盟商

    public static final Dict BRAND_HONGLING = DictManager.getDictByID(20137); // 红领制衣
    public static final Dict BRAND_RUIPU_JIAMENG = DictManager.getDictByID(20149); // 红领制衣
    public static final Dict BRAND_KAIMIAO = DictManager.getDictByID(20138); // 凯妙
    public static final Dict BRAND_RUIPU = DictManager.getDictByID(20140); // 瑞璞
    public static final Dict BRAND_KAIMIAONEW = DictManager.getDictByID(20144); // 凯妙新
    public static final Dict BRAND_DIANSHANG = DictManager.getDictByID(20148); // 电商
    
    public static final String FABRIC_HEAD="DD,DA,DB,DX,SA,SB,SS,MB,MA,SD,CA,CB,DS,DC,";//"DD,DA,DB,DX,SA,SB,SS,MB,DS,TGES,"; //面料前缀
    public static final String CUSTOMER_FABRIC_HEAD="CG,"; //面料前缀
}
