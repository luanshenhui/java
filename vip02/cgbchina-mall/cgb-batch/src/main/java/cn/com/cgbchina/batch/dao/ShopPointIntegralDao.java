package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralShopPoint;

/**
 * 购物积点积分兑换
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class ShopPointIntegralDao {

	public List<IntegralShopPoint> getShopPointTntegral() {
		List<IntegralShopPoint> shopPointIntegrals = new ArrayList<IntegralShopPoint>();
		return shopPointIntegrals;
	}

}
