package cn.rkylin.oms.push.adapter;

import java.util.Map;

import cn.rkylin.apollo.common.util.BeanUtils;
import cn.rkylin.oms.system.shop.domain.Shop;

public class PushAdapterFactory {
	
	/**
	 * 构造函数
	 */
	private PushAdapterFactory() {

	}
	
	public void finalize() throws Throwable {

	}
	
	public static PushAdapter getPushAdapter(Map<String,String> map,Shop shop) throws Exception {
		
		if (shop!=null && "淘宝".equals(shop.getShopType())) {
			TaobaoPushAdapter taobaoPushAdapter = BeanUtils.getBean("taobaoPushAdapter");
			taobaoPushAdapter.setPushVisitor((TaobaoPushVisitor)BeanUtils.getBean("taobaoPushVisitor"));
			return taobaoPushAdapter;
		}
		return null;
	}
}
