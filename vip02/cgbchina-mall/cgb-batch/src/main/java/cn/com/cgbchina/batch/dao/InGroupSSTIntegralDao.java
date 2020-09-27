package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralSST;

/**
 * 录入组瞬时通积分兑换
 * 
 * @author huangcy on 2016年5月10日
 */
@Repository
public class InGroupSSTIntegralDao {
	public List<IntegralSST> getInGroupSSTIntegral() {
		List<IntegralSST> sstIntegrals = new ArrayList<IntegralSST>();

		for (int i = 1; i < 100; i++) {
			// SSTIntegral sstIntegral = new SSTIntegral();
			// sstIntegral.setId(i);
			// sstIntegral.setGoodsName("goods" + i);
			// sstIntegral.setAcceptDate(new Date().toString());
			// sstIntegral.setAcceptNo("00" + i);
			// sstIntegral.setContIdCard("00000" + i);
			// sstIntegral.setCardNo("1111111" + i);
			// sstIntegral.setGoodsXid("asda" + i);
			// sstIntegral.setMobilePhone("asdfas");
			// sstIntegral.setNum(i);
			// sstIntegral.setRemark("");
			// sstIntegrals.add(sstIntegral);
		}

		return sstIntegrals;
	}
}
