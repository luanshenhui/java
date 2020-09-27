package cn.com.cgbchina.common.utils;

import cn.com.cgbchina.common.contants.Contants;

public class CodeToName {
	/**
	 * 转换商品类型
	 * @param code
	 * @return
	 */
	public static String goodsType(String code) {
		switch (code) {
		case Contants.GOODS_TYPE_ID_00:
			return Contants.GOODS_TYPE_NM_00;
		case Contants.GOODS_TYPE_ID_01:
			return Contants.GOODS_TYPE_NM_01;
		case Contants.GOODS_TYPE_ID_02:
			return Contants.GOODS_TYPE_NM_02;
		default:
			return null;
		}
	}
}
