package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.StockDetail;

public interface StockDetailService {
	public void save(StockDetail stockDetail);

	public void update(StockDetail stockDetail);

	public void delete(StockDetail stockDetail);

	public StockDetail getStockDetail(StockDetail stockDetail);

	public StockDetail getStockDetail(Long id);

	public List<StockDetail> findPageInfoStockDetail(StockDetail stockDetail,
			PageBean pageBean);

	public Integer getCount(StockDetail stockDetail);

	public List<StockDetail> staticSales(StockDetail stockDetail);
}
