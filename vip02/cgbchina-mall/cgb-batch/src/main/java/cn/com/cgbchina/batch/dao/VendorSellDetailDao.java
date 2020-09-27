package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.VendorSellDetail;

/**
 * 供应商平台 商户销售明细
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class VendorSellDetailDao {

	public List<VendorSellDetail> getVendorSellDetailForDay() {
		List<VendorSellDetail> vendorSaleDetails = new ArrayList<VendorSellDetail>();
		return vendorSaleDetails;
	}

	public List<VendorSellDetail> getVendorSellDetailForWeek() {
		List<VendorSellDetail> vendorSaleDetails = new ArrayList<VendorSellDetail>();
		return vendorSaleDetails;
	}

	public List<VendorSellDetail> getVendorSellDetailForMonth() {
		List<VendorSellDetail> vendorSaleDetails = new ArrayList<VendorSellDetail>();
		return vendorSaleDetails;
	}

}
