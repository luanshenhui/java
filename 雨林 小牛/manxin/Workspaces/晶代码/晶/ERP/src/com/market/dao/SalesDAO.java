package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Sales;

public interface SalesDAO {

	public void save(Sales sales);

	public void update(Sales sales);

	public void delete(Sales sales);

	public Sales getSales(Sales sales);

	public Sales getSales(Long id);

	/**
	 * 获得Sales的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Sales> findPageInfoSales(Sales sales, PageBean pageBean);

	public Integer getCount(Sales sales);
}
