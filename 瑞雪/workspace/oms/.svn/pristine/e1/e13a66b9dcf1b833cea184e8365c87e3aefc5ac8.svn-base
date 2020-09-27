package cn.rkylin.oms.push.adapter;

import java.util.Map;

import org.springframework.stereotype.Service;

import cn.rkylin.oms.system.shop.domain.Shop;

@Service("taobaoPushAdapter")
public class TaobaoPushAdapter extends PushAdapter {

	@Override
	public Map<String, Object> pushData(Shop shop,Map<String,String> map) {
		return this.getPushVisitor().pushData(shop, map);
	}

}
