package cn.rkylin.oms.push.adapter;

import java.util.Map;

import cn.rkylin.oms.system.shop.domain.Shop;

/**
 * 向平台推送数据适配器
 * @author Administrator
 *
 */
public abstract class PushAdapter {

	private PushVisitor pushVisitor;
	/**
	 * 构造函数
	 */
	public PushAdapter() {
	}
	
	public void finalize() throws Throwable {

	}
	
	/**
	 * 下载平台商品
	 * 
	 * @param shopId
	 * @return 1成功，0失败
	 */
	public abstract Map<String, Object> pushData(Shop shop,Map<String,String> map);

	public PushVisitor getPushVisitor() {
		return pushVisitor;
	}

	public void setPushVisitor(PushVisitor pushVisitor) {
		this.pushVisitor = pushVisitor;
	}
	
	
}
