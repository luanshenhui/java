package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Sales;

public class SalesDAOImpl extends HibernateGenericDao<Sales> implements
		SalesDAO {

	public void save(Sales sales) {
		super.save(sales);
	}

	public void update(Sales sales) {
		super.update(sales);
	}

	public void delete(Sales sales) {
		super.remove(sales);
	}

	public Sales getSales(Sales sales) {
		return get(sales.getId());
	}

	public Sales getSales(Long id) {
		return get(id);
	}

	public List<Sales> findPageInfoSales(Sales sales, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM sales WHERE 1=1 ");
		sql = getStringBuffer(sales, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Sales sales) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM sales WHERE 1=1 ");
		sql = getStringBuffer(sales, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param sales
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Sales sales, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(sales.getMemberNo())) {
			buf.append(" and member_no like ? ");
			args.add("%" + sales.getMemberNo().trim() + "%");
		}
		if (StringUtils.isNotBlank(sales.getMemberName())) {
			buf.append(" and member_name like ? ");
			args.add("%" + sales.getMemberName().trim() + "%");
		}
		if (StringUtils.isNotBlank(sales.getEmployee())) {
			buf.append(" and employee like ? ");
			args.add("%" + sales.getEmployee().trim() + "%");
		}
		return buf;
	}
}
