package com.market.service;

import java.util.List;

import com.market.dao.SalesDetailDAO;
import com.market.util.PageBean;
import com.market.vo.SalesDetail;

public class SalesDetailServiceImpl implements SalesDetailService {
	private SalesDetailDAO salesDetailDAO;

	public void save(SalesDetail salesDetail) {
		salesDetailDAO.save(salesDetail);
	}

	public void update(SalesDetail salesDetail) {
		salesDetailDAO.update(salesDetail);
	}

	public SalesDetail getSalesDetail(SalesDetail salesDetail) {
		return salesDetailDAO.getSalesDetail(salesDetail);
	}

	public SalesDetail getSalesDetail(Long id) {
		return salesDetailDAO.getSalesDetail(id);
	}

	public void delete(SalesDetail salesDetail) {
		salesDetailDAO.delete(salesDetail);
	}

	public List<SalesDetail> findPageInfoSalesDetail(SalesDetail salesDetail,
			PageBean pageBean) {
		return salesDetailDAO.findPageInfoSalesDetail(salesDetail, pageBean);
	}

	public Integer getCount(SalesDetail salesDetail) {
		return salesDetailDAO.getCount(salesDetail);
	}

	public void setSalesDetailDAO(SalesDetailDAO salesDetailDAO) {
		this.salesDetailDAO = salesDetailDAO;
	}

	public List<SalesDetail> staticSales(SalesDetail salesDetail) {
		return salesDetailDAO.staticSales(salesDetail);
	}

	public List<SalesDetail> staticSalesBrand(SalesDetail salesDetail) {
		return salesDetailDAO.staticSalesBrand(salesDetail);
	}

	public List<SalesDetail> staticSalesDay(SalesDetail salesDetail) {
		return salesDetailDAO.staticSalesDay(salesDetail);
	}
}
