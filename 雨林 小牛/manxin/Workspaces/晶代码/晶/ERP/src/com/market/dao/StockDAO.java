package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Stock;

public interface StockDAO {

	public void save(Stock stock);

	public void update(Stock stock);

	public void delete(Stock stock);

	public Stock getStock(Stock stock);

	public Stock getStock(Long id);

	/**
	 * 获得Stock的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Stock> findPageInfoStock(Stock stock, PageBean pageBean);

	public Integer getCount(Stock stock);
}
