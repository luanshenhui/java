package com.market.service;

import java.util.List;

import com.market.dao.SalesDAO;
import com.market.util.PageBean;
import com.market.vo.Sales;

public class SalesServiceImpl implements SalesService {
	private SalesDAO salesDAO;

	public void save(Sales sales) {
		salesDAO.save(sales);
	}

	public void update(Sales sales) {
		salesDAO.update(sales);
	}

	public Sales getSales(Sales sales) {
		return salesDAO.getSales(sales);
	}

	public Sales getSales(Long id) {
		return salesDAO.getSales(id);
	}

	public void delete(Sales sales) {
		salesDAO.delete(sales);
	}

	public List<Sales> findPageInfoSales(Sales sales, PageBean pageBean) {
		return salesDAO.findPageInfoSales(sales, pageBean);
	}

	public Integer getCount(Sales sales) {
		return salesDAO.getCount(sales);
	}

	public void setSalesDAO(SalesDAO salesDAO) {
		this.salesDAO = salesDAO;
	}
}
