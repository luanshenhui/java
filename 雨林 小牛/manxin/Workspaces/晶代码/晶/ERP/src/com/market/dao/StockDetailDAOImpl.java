package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.StockDetail;

public class StockDetailDAOImpl extends HibernateGenericDao<StockDetail>
		implements StockDetailDAO {

	public void save(StockDetail stockDetail) {
		super.save(stockDetail);
	}

	public void update(StockDetail stockDetail) {
		super.update(stockDetail);
	}

	public void delete(StockDetail stockDetail) {
		super.remove(stockDetail);
	}

	public StockDetail getStockDetail(StockDetail stockDetail) {
		return get(stockDetail.getId());
	}

	public StockDetail getStockDetail(Long id) {
		return get(id);
	}

	public List<StockDetail> findPageInfoStockDetail(StockDetail stockDetail,
			PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM stock_detail WHERE 1=1 ");
		sql = getStringBuffer(stockDetail, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public List<StockDetail> staticSales(StockDetail stockDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" select a.*,b.stock_no,b.stock_date ,b.member member_name,c.good_no,c.good_name,c.good_type,c.brand,c.in_come,c.good_num ");
		sql.append(" from stock_detail a left join stock b on a.stock_id= b.id  LEFT join goods c on a.goods_id=c.id where 1=1");
		if (stockDetail.getStartDate() != null) {
			sql.append(" and  b.stock_date >=? ");
			args.add(stockDetail.getStartDate());
		}
		if (stockDetail.getEndDate() != null) {
			sql.append(" and  b.stock_date <=? ");
			args.add(stockDetail.getEndDate());
		}
		if (StringUtils.isNotBlank(stockDetail.getGoodsName())) {
			sql.append(" and  a.goods_name like ? ");
			args.add("%" + stockDetail.getGoodsName() + "%");
		}
		return getPageInfo(null, sql.toString(), args);
	}

	public Integer getCount(StockDetail stockDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM stock_detail WHERE 1=1 ");
		sql = getStringBuffer(stockDetail, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param stockDetail
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(StockDetail stockDetail,
			StringBuffer buf, List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (stockDetail.getStockId() != null) {
			buf.append(" and stock_id = ? ");
			args.add(stockDetail.getStockId());
		}

		//
		//
		//
		// if(!CommonUtils.isNull(stockDetail.getGoodsId())){
		// buf.append(" and goods_id = ? ");
		// args.add(stockDetail.getGoodsId());
		// }
		//
		//
		//
		//
		// if(!CommonUtils.isNull(stockDetail.getNum())){
		// buf.append(" and num = ? ");
		// args.add(stockDetail.getNum());
		// }
		//

		return buf;
	}
}
