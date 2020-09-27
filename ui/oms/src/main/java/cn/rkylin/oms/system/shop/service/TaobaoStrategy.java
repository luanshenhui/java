package cn.rkylin.oms.system.shop.service;

import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 淘宝验证策略
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:16
 */
public class TaobaoStrategy extends ShopValidatingStrategy {



	public void finalize() throws Throwable {
		super.finalize();
	}

	public TaobaoStrategy(){

	}

	/**
	 * 验证店铺
	 * @return 成功返回“success”，不成功返回具体的失败原因。
	 * 
	 * @param shop
	 */
	public String validate(ShopVO shop){
		return "";
	}

}