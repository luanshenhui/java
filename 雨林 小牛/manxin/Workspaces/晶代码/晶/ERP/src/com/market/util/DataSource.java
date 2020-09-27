package com.market.util;

import java.util.LinkedHashMap;
import java.util.Map;

public class DataSource {

	// 用户类型
	public static Map<String, String> YHLX = new LinkedHashMap<String, String>();

	// 员工类型
	public static Map<String, String> YGLX = new LinkedHashMap<String, String>();

	// 性别
	public static Map<String, String> SEX = new LinkedHashMap<String, String>();

	// 卡类型
	public static Map<String, String> CARD_TYPE = new LinkedHashMap<String, String>();

	// 商品类型
	public static Map<String, String> GOOD_TYPE = new LinkedHashMap<String, String>();

	// 商品单位
	public static Map<String, String> GOOD_UNIT = new LinkedHashMap<String, String>();

	static {

		YHLX.put("管理员", "管理员");
		YHLX.put("采购员", "采购员");
		YHLX.put("业务员", "业务员");

		YGLX.put("采购员", "采购员");
		YGLX.put("销售员", "销售员");

		SEX.put("男", "男");
		SEX.put("女", "女");

		CARD_TYPE.put("普通卡", "普通卡");
		CARD_TYPE.put("金卡", "金卡");
		CARD_TYPE.put("银卡", "银卡");

		GOOD_TYPE.put("食品", "食品");
		GOOD_TYPE.put("水果", "水果");
		GOOD_TYPE.put("蔬菜", "蔬菜");
		GOOD_TYPE.put("香烟", "香烟");
		GOOD_TYPE.put("酒水", "酒水");
		GOOD_TYPE.put("电器", "电器");
		GOOD_TYPE.put("其他", "其他");

		GOOD_UNIT.put("斤", "斤");
		GOOD_UNIT.put("袋", "袋");
		GOOD_UNIT.put("箱", "箱");
		GOOD_UNIT.put("瓶", "瓶");
		GOOD_UNIT.put("台", "台");
	}
}
