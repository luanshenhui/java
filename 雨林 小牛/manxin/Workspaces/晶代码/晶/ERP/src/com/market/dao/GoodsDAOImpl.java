package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Goods;

public class GoodsDAOImpl extends HibernateGenericDao<Goods> implements
		GoodsDAO {

	public void save(Goods goods) {
		super.save(goods);
	}

	public void update(Goods goods) {
		super.update(goods);
	}

	public void delete(Goods goods) {
		super.remove(goods);
	}

	public Goods getGoods(Goods goods) {
		return get(goods.getId());
	}

	public Goods getGoods(Long id) {
		return get(id);
	}

	public List<Goods> findPageInfoGoods(Goods goods, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM goods WHERE 1=1 ");
		sql = getStringBuffer(goods, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Goods goods) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM goods WHERE 1=1 ");
		sql = getStringBuffer(goods, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param goods
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Goods goods, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(goods.getGoodNo())) {
			buf.append(" and good_no like ? ");
			args.add("%" + goods.getGoodNo().trim() + "%");
		}
		if (StringUtils.isNotBlank(goods.getGoodName())) {
			buf.append(" and good_name like ? ");
			args.add("%" + goods.getGoodName().trim() + "%");
		}
		return buf;
	}
}
