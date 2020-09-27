package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Stock;

public interface StockService {
	public void save(Stock stock);

	public void update(Stock stock);

	public void delete(Stock stock);

	public Stock getStock(Stock stock);

	public Stock getStock(Long id);

	public List<Stock> findPageInfoStock(Stock stock, PageBean pageBean);

	public Integer getCount(Stock stock);

	;
}
