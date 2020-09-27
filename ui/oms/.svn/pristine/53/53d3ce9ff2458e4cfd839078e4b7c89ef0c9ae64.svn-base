package cn.rkylin.oms.push.adapter;

import java.util.Map;

import cn.rkylin.oms.system.shop.domain.Shop;

public abstract class PushVisitor {
	/**
	 * 构造函数
	 */
	public PushVisitor() {

	}

	/**
	 * 把数据推送到平台上
	 * 
	 * @param paramMap
	 * @return 
	 */
	public abstract Map<String,Object> pushData(Shop shop, Map<String, String> map);

	public void finalize() throws Throwable {

	}
}
