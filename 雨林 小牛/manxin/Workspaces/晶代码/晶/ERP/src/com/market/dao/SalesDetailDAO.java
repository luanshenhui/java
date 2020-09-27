package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.SalesDetail;

public interface SalesDetailDAO {

	public void save(SalesDetail salesDetail);

	public void update(SalesDetail salesDetail);

	public void delete(SalesDetail salesDetail);

	public SalesDetail getSalesDetail(SalesDetail salesDetail);

	public SalesDetail getSalesDetail(Long id);

	/**
	 * 获得SalesDetail的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<SalesDetail> findPageInfoSalesDetail(SalesDetail salesDetail,
			PageBean pageBean);

	public Integer getCount(SalesDetail salesDetail);

	public List<SalesDetail> staticSales(SalesDetail salesDetail);

	public List<SalesDetail> staticSalesBrand(SalesDetail salesDetail);

	public List<SalesDetail> staticSalesDay(SalesDetail salesDetail);
}
