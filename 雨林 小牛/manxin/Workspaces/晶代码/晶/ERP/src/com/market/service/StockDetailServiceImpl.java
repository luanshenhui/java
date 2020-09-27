package com.market.service;

import java.util.List;

import com.market.dao.StockDetailDAO;
import com.market.util.PageBean;
import com.market.vo.StockDetail;

public class StockDetailServiceImpl implements StockDetailService {
	private StockDetailDAO stockDetailDAO;

	public void save(StockDetail stockDetail) {
		stockDetailDAO.save(stockDetail);
	}

	public void update(StockDetail stockDetail) {
		stockDetailDAO.update(stockDetail);
	}

	public StockDetail getStockDetail(StockDetail stockDetail) {
		return stockDetailDAO.getStockDetail(stockDetail);
	}

	public StockDetail getStockDetail(Long id) {
		return stockDetailDAO.getStockDetail(id);
	}

	public void delete(StockDetail stockDetail) {
		stockDetailDAO.delete(stockDetail);
	}

	public List<StockDetail> findPageInfoStockDetail(StockDetail stockDetail,
			PageBean pageBean) {
		return stockDetailDAO.findPageInfoStockDetail(stockDetail, pageBean);
	}

	public Integer getCount(StockDetail stockDetail) {
		return stockDetailDAO.getCount(stockDetail);
	}

	public void setStockDetailDAO(StockDetailDAO stockDetailDAO) {
		this.stockDetailDAO = stockDetailDAO;
	}

	public List<StockDetail> staticSales(StockDetail stockDetail) {
		return stockDetailDAO.staticSales(stockDetail);
	}
}
