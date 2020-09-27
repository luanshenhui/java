package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Stock;

public class StockDAOImpl extends HibernateGenericDao<Stock> implements
		StockDAO {

	public void save(Stock stock) {
		super.save(stock);
	}

	public void update(Stock stock) {
		super.update(stock);
	}

	public void delete(Stock stock) {
		super.remove(stock);
	}

	public Stock getStock(Stock stock) {
		return get(stock.getId());
	}

	public Stock getStock(Long id) {
		return get(id);
	}

	public List<Stock> findPageInfoStock(Stock stock, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM stock WHERE 1=1 ");
		sql = getStringBuffer(stock, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Stock stock) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM stock WHERE 1=1 ");
		sql = getStringBuffer(stock, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param stock
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Stock stock, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(stock.getStockNo())) {
			buf.append(" and stock_no like ? ");
			args.add("%" + stock.getStockNo().trim() + "%");
		}

		if (stock.getStockDate() != null) {
			buf.append(" and stock_date >= ? ");
			args.add(stock.getStockDate());
		}
		if (stock.getStockDate() != null) {
			buf.append(" and stock_date <= ? ");
			args.add(stock.getStockDate());
		}

		if (StringUtils.isNotBlank(stock.getMember())) {
			buf.append(" and member like ? ");
			args.add("%" + stock.getMember().trim() + "%");
		}
		return buf;
	}
}
