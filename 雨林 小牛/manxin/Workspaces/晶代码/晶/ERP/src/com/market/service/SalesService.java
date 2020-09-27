package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Sales;

public interface SalesService {
	public void save(Sales sales);

	public void update(Sales sales);

	public void delete(Sales sales);

	public Sales getSales(Sales sales);

	public Sales getSales(Long id);

	public List<Sales> findPageInfoSales(Sales sales, PageBean pageBean);

	public Integer getCount(Sales sales);
}
