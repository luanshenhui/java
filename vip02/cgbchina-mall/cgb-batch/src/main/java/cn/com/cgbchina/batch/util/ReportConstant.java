package cn.com.cgbchina.batch.util;

/**
 * 
 * 日期 : 2016年7月14日<br>
 * 作者 : Huangcy<br>
 * 项目 : cgb-batch<br>
 * 功能 : 报表常量<br>
 */
public class ReportConstant {
	// ################################### 报表类型 ##########################
	public static final String DAY_REPORT_TYPE = "日报表";
	public static final String WEEK_REPORT_TYPE = "周报表";
	public static final String MONTH_REPORT_TYPE = "月报表";

	// ################################### 会员报表代码 #######################
	/** 会员总数周报表 代码 */
	public final static String HY_TOTAL_01 = "HY01";
	/** 会员总数月报表 代码 */
	public final static String HY_TOTAL_02 = "HY02";
	/** 会员搜索记录周报表 代码 */
	public final static String HY_SEARCH_03 = "HY03";
	/** 会员搜索记录月报表 代码 */
	public final static String HY_SEARCH_04 = "HY04";
	/** 会员购物车周报表 代码 */
	public final static String HY_SHOPCAR_05 = "HY05";
	/** 会员购物车月报表 代码 */
	public final static String HY_SHOPCAR_06 = "HY06";
	/** 会员收藏夹周报表 代码 */
	public final static String HY_FAVORITE_07 = "HY07";
	/** 会员收藏夹月报表 代码 */
	public final static String HY_FAVORITE_08 = "HY08";
	/** 会员足迹周报表 代码 */
	public final static String HY_BROWSE_09 = "HY09";
	/** 会员足迹月报表 代码 */
	public final static String HY_BROWSE_10 = "HY10";

	// ################################## 广发商城报表代码 ########################
	/** 商户销售明细日报表代码 */
	public final static String YG_VENDOR_SALE_07 = "YG07";
	/** 商户销售明细周报表代码 */
	public final static String YG_VENDOR_SALE_11 = "YG11";
	/** 商户销售明细月报表代码 */
	public final static String YG_VENDOR_SALE_15 = "YG15";
	/** 商户销售统计日报表代码 */
	public final static String YG_VENDOR_STAT_06 = "YG06";
	/** 商户销售统计周报表代码 */
	public final static String YG_VENDOR_STAT_10 = "YG10";
	/** 商户销售统计月报表代码 */
	public final static String YG_VENDOR_STAT_14 = "YG14";
	/** 商品销售明细日报表代码 */
	public final static String YG_GOODS_SALE_09 = "YG09";
	/** 商品销售明细周报表代码 */
	public final static String YG_GOODS_SALE_13 = "YG13";
	/** 商品销售明细月报表代码 */
	public final static String YG_GOODS_SALE_17 = "YG17";
	/** 分期请款报表代码 */
	public final static String YG_STAGE_REQCASH_02 = "YG02";
	/** 分期退货日报表代码 */
	public final static String YG_STAGE_RETURN_18 = "YG18";
	/** 分期退货周报表代码 */
	public final static String YG_STAGE_RETURN_19 = "YG19";
	/** 分期退货月报表代码 */
	public final static String YG_STAGE_RETURN_60 = "YG60";

	// ################################## 积分商城报表代码 ########################
	/** 普通礼品销售日报表 代码 */
	public final static String JF_COMMONGIFT_SALE_01 = "JF01";
	/** 普通礼品销售周报表代码 */
	public final static String JF_COMMONGIFT_SALE_04 = "JF04";
	/** 普通礼品销售月报表 代码 */
	public final static String JF_COMMONGIFT_SALE_06 = "JF06";
	/** 退货日报表 代码 */
	public final static String JF_RETURN_02 = "JF02";
	/** 退货周报表 代码 */
	public final static String JF_RETURN_05 = "JF05";
	/** 退货月报表 代码 */
	public final static String JF_RETURN_07 = "JF07";
	/** 结算日报表代码 */
	public final static String JF_CLEARING_03 = "JF03";
	/** 兑换统计月报表 代码 */
	public final static String JF_EXCHANGE_STAT_08 = "JF08";
	/** 积分兑换周报表（南航里程） 代码 */
	public final static String JF_SOUTH_MILEAGE_13 = "JF13";
	/** 积分兑换月报表（南航里程）代码 */
	public final static String JF_SOUTH_MILEAGE_49 = "JF49";
	/** 积分兑换周报表（ALL常旅客会员消费）代码 */
	public final static String JF_ALL_CONSUME_14 = "JF14";
	/** 积分兑换月报表（ALL常旅客会员消费）代码 */
	public final static String JF_ALL_CONSUME_50 = "JF50";
	/** 积分兑换周报表（车主卡道路救援） 代码 */
	public final static String JF_ROAD_RESUCE_15 = "JF15";
	/** 积分兑换周报表（白金卡换年费） 代码 */
	public final static String JF_PLATINUM_ANNUALFEE_17 = "JF17";
	/** 积分兑换月报表（白金卡换年费） 代码 */
	public final static String JF_PLATINUM_ANNUALFEE_51 = "JF51";
	/** 积分兑换周报表（录入组瞬时通） 代码 */
	public final static String JF_INTOGROUP_SST_19 = "JF19";
	/** 积分兑换周报表（录入组赠品代码） 代码 */
	public final static String JF_INTOGROUP_GIFTCODE_20 = "JF20";
	/** 积分兑换周报表（中国人寿保险标准卡旅行意外） 代码 */
	public final static String JF_INSURANCE_SC_TRAVEL_21 = "JF21";
	/** 积分兑换月报表（中国人寿保险标准卡旅行意外） 代码 */
	public final static String JF_INSURANCE_SC_TRAVEL_52 = "JF52";
	/** 积分兑换周报表（中国人寿保险标准卡重大疾病） 代码 */
	public final static String JF_INSURANCE_SC_DISEASE_22 = "JF22";
	/** 积分兑换月报表（中国人寿保险标准卡重大疾病） 代码 */
	public final static String JF_INSURANCE_SC_DISEASE_53 = "JF53";
	/** 积分兑换周报表（中国人寿保险真情卡女性疾病） 代码 */
	public final static String JF_INSURANCE_TC_WOMEN_23 = "JF23";
	/** 积分兑换月报表（中国人寿保险真情卡女性疾病） 代码 */
	public final static String JF_INSURANCE_TC_WOMEN_54 = "JF54";
	/** 积分兑换周报表（中国人寿保险真情卡旅行意外） 代码 */
	public final static String JF_INSURANCE_TC_TRAVEL_24 = "JF24";
	/** 积分兑换月报表（中国人寿保险真情卡旅行意外） 代码 */
	public final static String JF_INSURANCE_TC_TRAVEL_55 = "JF55";
	/** 积分兑换周报表（中国人寿保险真情卡重大疾病） 代码 */
	public final static String JF_INSURANCE_TC_DISEASE_25 = "JF25";
	/** 积分兑换月报表（中国人寿保险真情卡重大疾病） 代码 */
	public final static String JF_INSURANCE_TC_DISEASE_56 = "JF56";
	/** 积分兑换周报表（中国人寿保险真情卡购物保障） 代码 */
	public final static String JF_INSURANCE_TC_SHOP_26 = "JF26";
	/** 积分兑换月报表（中国人寿保险真情卡购物保障） 代码 */
	public final static String JF_INSURANCE_TC_SHOP_57 = "JF57";
	/** 积分兑换周报表（中国人寿保险车主卡驾驶员意外） 代码 */
	public final static String JF_INSURANCE_CC_DRIVER_27 = "JF27";
	/** 积分兑换月报表（中国人寿保险车主卡驾驶员意外） 代码 */
	public final static String JF_INSURANCE_CC_DRIVER_58 = "JF58";
	/** 积分兑换周报表（中国人民财产保险车主卡旅行交通意外） 代码 */
	public final static String JF_INSURANCE_CC_TRAFFIC_28 = "JF28";
	/** 积分兑换月报表（中国人民财产保险车主卡旅行交通意外） 代码 */
	public final static String JF_INSURANCE_CC_TRAFFIC_59 = "JF59";
	/** 积分兑换周报表（爱•宠普卡宠物饲养责任保险） 代码 */
	public final static String JF_INSURANCE_PC_FEED_60 = "JF60";
	/** 积分兑换月报表（爱•宠普卡宠物饲养责任保险） 代码 */
	public final static String JF_INSURANCE_PC_FEED_61 = "JF61";
	/** 积分兑换周报表（联通卡） 代码 */
	public final static String JF_LINK_CARD_30 = "JF30";
	/** 积分兑换月报表（联通卡） 代码 */
	public final static String JF_LINK_CARD_62 = "JF62";
	/** 积分兑换日报表（人保粤通卡积分兑换） 代码 */
	public final static String JF_PERSON_YT_33 = "JF33";
	/** 积分兑换日报表（DIY卡免还款签账额） 代码 */
	public final static String JF_DIY_VISA_34 = "JF34";
	/** 普通积分兑换周报表（南航里程）代码 */
	public final static String JF_COMMON_SOUTHAIR_35 = "JF35";
	/** 普通积分兑换月报表（南航里程） 代码 */
	public final static String JF_COMMON_SOUTHAIR_63 = "JF63";
	/** 积分兑换日报表（新旧聪明卡兑换签帐额） 代码 */
	public final static String JF_SMART_CARD_16 = "JF16";
	/** 商户兑换统计月报表 代码 */
	public final static String JF_VENDOR_STAT_64 = "JF64";

	// ################################## 供应商报表代码 ########################
	/** 商户销售明细日报表代码 */
	public final static String YG_VENDOR_SELL_30 = "YG30";
	/** 商户销售明细周报表代码 */
	public final static String YG_VENDOR_SELL_40 = "YG40";
	/** 商户销售明细月报表代码 */
	public final static String YG_VENDOR_SELL_50 = "YG50";
	/** 商户退货明细日报表代码 */
	public final static String YG_VENDOR_RETURN_08 = "YG08";
	/** 商户退货明细周报表代码 */
	public final static String YG_VENDOR_RETURN_12 = "YG12";
	/** 商户退货明细月报表代码 */
	public final static String YG_VENDOR_RETURN_16 = "YG16";
	/** 信用卡请款对账明细日报表代码 */
	public final static String YG_CREDIT_REQCASH_22 = "YG22";
	/** 信用卡请款对账明细周报表代码 */
	public final static String YG_CREDIT_REQCASH_61 = "YG61";
	/** 信用卡请款对账明细月报表代码 */
	public final static String YG_CREDIT_REQCASH_62 = "YG62";

	/** 航空类型 */
	public static class AviationType {
		/** 东航 */
		public final static String AIR_EAST_CODE = "01";
		public final static String AIR_EAST_NAME = "东航";
		/** 南航 */
		public final static String AIR_SOUTH_CODE = "02";
		public final static String AIR_SOUTH_NAME = "南航";
		/** 国航 */
		public final static String AIR_CHINA_CODE = "03";
		public final static String AIR_CHINA_NAME = "国航";
		/** 亚洲万里通 */
		public final static String AIR_ASIA_CODE = "04";
		public final static String AIR_ASIA_NAME = "亚洲万里通";
	}

	/** 积分兑换礼品清单 */
	public static class GoodsXids {
		/** 积分兑换报表（南航里程）礼品清单 */
		public final static String SOUTH_AIR_MILEAGE = "10038|10039|10040";
		/** 积分兑换报表（ALL常旅客会员消费）礼品清单 */
		public final static String ALL_MEMBER_CONSUME = "10052|10053|10054";
		/** 积分兑换报表（车主卡道路救援）礼品清单 */
		public final static String CRECORDER_ROAD_RESECUE = "10055";
		/** 积分兑换报表（白金卡换年费）礼品清单 */
		public final static String PLATINUM_ANNUAL_FEE = "10043|10044|10045|10046|10047|10048|10049|10050";
		/** 积分兑换报表（录入组瞬时通）礼品清单 */
		public final static String INTO_SST = "10041|10042";
		/** 积分兑换报表（录入组赠品代码）礼品清单 */
		public final static String INTO_GIFTCODE = "10022|10023|10024|10025|10026|10027|10028|10029|10030|10031|10032|10033|10034|10035|10036|10037";
		/** 积分兑换报表（中国人寿保险标准卡旅行意外）礼品清单 */
		public final static String INSURANCE_SC_TRAVEL = "10031|10033|12012|12013";
		/** 积分兑换报表（中国人寿保险标准卡重大疾病）礼品清单 */
		public final static String INSURANCE_SC_DISEASE = "10030|10032";
		/** 积分兑换报表（中国人寿保险真情卡女性疾病）礼品清单 */
		public final static String INSURANCE_TC_WOMEN = "10022|10026|10034";
		/** 积分兑换报表（中国人寿保险真情卡旅行意外）礼品清单 */
		public final static String INSURANCE_TC_TRAVEL = "10024|10028|10037";
		/** 积分兑换报表（中国人寿保险真情卡重大疾病）礼品清单 */
		public final static String INSURANCE_TC_DISEASE = "10025|10029|10035";
		/** 积分兑换报表（中国人寿保险真情卡购物保障）礼品清单 */
		public final static String INSURANCE_TC_SHOP = "10023|10027|10036";
		/** 积分兑换报表（中国人寿保险车主卡驾驶员意外）礼品清单 */
		public final static String INSURANCE_CC_DRIVER = "10056|10058";
		/** 积分兑换报表（中国人民财产保险车主卡旅行交通意外）礼品清单 */
		public final static String INSURANCE_CC_TRAFFIC = "10057|10059";
		/** 积分兑换报表（爱•宠普卡宠物饲养责任保险）礼品清单 */
		public final static String INSURANCE_PC_FEED = "12922|12923";
		/** 积分兑换报表（联通卡）礼品清单 */
		public final static String LINK_CARD = "10007|10008|10009|10010|10011|10012|10013|10014|10015|10016|10017";
		/** 积分兑换报表（人保粤通卡积分兑换）礼品清单 */
		public final static String PERSON_YT = "12036|12037";
		/** 积分兑换报表（DIY卡免还款签账额）礼品清单 */
		public final static String DIY_VISA_FREE = "12783|13625|13626";
		/** 普通积分兑换报表（南航里程）礼品清单 */
		public final static String COMMON_SOUTH_AIR = "13133";
		/** 积分兑换报表（新旧聪明卡兑换签帐额）礼品清单 */
		public final static String SMART_CARD = "10064|10063|10485";
	}

	//日报标识
	public static final String JOBKEY_DAY = "DayReport";
	//周报标识
	public static final String JOBKEY_WEEK = "WeekReport";
	//月报标识
	public static final String JOBKEY_MONTH = "MonthReport";

}
