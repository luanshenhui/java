package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Brand;

public class BrandDAOImpl extends HibernateGenericDao<Brand> implements
		BrandDAO {

	public void save(Brand brand) {
		super.save(brand);
	}

	public void update(Brand brand) {
		super.update(brand);
	}

	public void delete(Brand brand) {
		super.remove(brand);
	}

	public Brand getBrand(Brand brand) {
		return get(brand.getId());
	}

	public Brand getBrand(Long id) {
		return get(id);
	}

	public List<Brand> findPageInfoBrand(Brand brand, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM brand WHERE 1=1 ");
		sql = getStringBuffer(brand, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Brand brand) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM brand WHERE 1=1 ");
		sql = getStringBuffer(brand, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param brand
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Brand brand, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(brand.getNum())) {
			buf.append(" and num like ? ");
			args.add("%" + brand.getNum().trim() + "%");
		}
		if (StringUtils.isNotBlank(brand.getName())) {
			buf.append(" and name like ? ");
			args.add("%" + brand.getName().trim() + "%");
		}
		return buf;
	}
}
