package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.VendorSaleDetail;

/**
 * 广发商城 商户销售明细数据层
 * 
 * @author xiewl
 * @since 2016年5月12日 上午10:09:42
 */
@Repository
public class VendorSaleDetailDao extends SqlSessionDaoSupport {
	public List<VendorSaleDetail> queryVenderSaleDetailsForDay(Map<String, Object> params) {
		return getSqlSession().selectList("VendorSaleDetailDaoImpl.findVenderSaleDetailsOfDay", params);
	}

	public List<VendorSaleDetail> queryVenderSaleDetailsForMulti(Map<String, Object> params) {
		return getSqlSession().selectList("VendorSaleDetailDaoImpl.findVenderSaleDetailsOfMulti", params);
	}
}
