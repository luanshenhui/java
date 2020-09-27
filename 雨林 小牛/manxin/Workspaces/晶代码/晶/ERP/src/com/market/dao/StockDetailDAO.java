package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.StockDetail;

public interface StockDetailDAO {

	public void save(StockDetail stockDetail);

	public void update(StockDetail stockDetail);

	public void delete(StockDetail stockDetail);

	public StockDetail getStockDetail(StockDetail stockDetail);

	public StockDetail getStockDetail(Long id);

	/**
	 * 获得StockDetail的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<StockDetail> findPageInfoStockDetail(StockDetail stockDetail,
			PageBean pageBean);

	public Integer getCount(StockDetail stockDetail);

	public List<StockDetail> staticSales(StockDetail stockDetail);
}
