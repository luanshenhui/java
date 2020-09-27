package com.market.service;

import java.util.List;

import com.market.dao.StockDAO;
import com.market.util.PageBean;
import com.market.vo.Stock;

public class StockServiceImpl implements StockService {
	private StockDAO stockDAO;

	public void save(Stock stock) {
		stockDAO.save(stock);
	}

	public void update(Stock stock) {
		stockDAO.update(stock);
	}

	public Stock getStock(Stock stock) {
		return stockDAO.getStock(stock);
	}

	public Stock getStock(Long id) {
		return stockDAO.getStock(id);
	}

	public void delete(Stock stock) {
		stockDAO.delete(stock);
	}

	public List<Stock> findPageInfoStock(Stock stock, PageBean pageBean) {
		return stockDAO.findPageInfoStock(stock, pageBean);
	}

	public Integer getCount(Stock stock) {
		return stockDAO.getCount(stock);
	}

	public void setStockDAO(StockDAO stockDAO) {
		this.stockDAO = stockDAO;
	}

}
