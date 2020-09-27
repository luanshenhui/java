package cn.rkylin.oms.system.shop.service;

import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺验证
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:15
 */
public abstract class ShopValidatingStrategy {



	public void finalize() throws Throwable {

	}

	public ShopValidatingStrategy(){

	}

	/**
	 * 验证店铺
	 * @return 成功返回“success”，不成功返回具体的失败原因。
	 * 
	 * @param shop
	 */
	public abstract String validate(ShopVO shop);

}