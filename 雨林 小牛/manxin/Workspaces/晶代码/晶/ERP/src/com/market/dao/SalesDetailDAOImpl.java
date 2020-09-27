package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.SalesDetail;

public class SalesDetailDAOImpl extends HibernateGenericDao<SalesDetail>
		implements SalesDetailDAO {

	public void save(SalesDetail salesDetail) {
		super.save(salesDetail);
	}

	public void update(SalesDetail salesDetail) {
		super.update(salesDetail);
	}

	public void delete(SalesDetail salesDetail) {
		super.remove(salesDetail);
	}

	public SalesDetail getSalesDetail(SalesDetail salesDetail) {
		return get(salesDetail.getId());
	}

	public SalesDetail getSalesDetail(Long id) {
		return get(id);
	}

	public List<SalesDetail> findPageInfoSalesDetail(SalesDetail salesDetail,
			PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM sales_detail WHERE 1=1 ");
		sql = getStringBuffer(salesDetail, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public List<SalesDetail> staticSales(SalesDetail salesDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" select a.*,b.sales_date,b.member_name,c.good_no,c.good_type,c.brand,c.in_come,c.out_come,c.good_num ");
		sql.append(" from sales_detail a left join sales b on a.sales_id= b.id LEFT join goods c on a.goods_id=c.id where 1=1");
		if (salesDetail.getStartDate() != null) {
			sql.append(" and  b.sales_date >=? ");
			args.add(salesDetail.getStartDate());
		}
		if (salesDetail.getEndDate() != null) {
			sql.append(" and  b.sales_date <=? ");
			args.add(salesDetail.getEndDate());
		}
		if (StringUtils.isNotBlank(salesDetail.getGoodsName())) {
			sql.append(" and  a.goods_name like ? ");
			args.add("%" + salesDetail.getGoodsName() + "%");
		}
		return getPageInfo(null, sql.toString(), args);
	}

	public List<SalesDetail> staticSalesDay(SalesDetail salesDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" select sum(num) num,goods_name,sales_date,sum(money) money, sum(price) price,sum(in_come) in_come ");
		sql.append(" from sales_detail a left join sales b on a.sales_id= b.id LEFT join goods c on a.goods_id=c.id where 1=1");
		if (salesDetail.getSalesDate() != null) {
			sql.append(" and  b.sales_date =? ");
			args.add(salesDetail.getSalesDate());
		}

		if (StringUtils.isNotBlank(salesDetail.getGoodsName())) {
			sql.append(" and  a.goods_name like ? ");
			args.add("%" + salesDetail.getGoodsName() + "%");
		}
		sql.append(" GROUP by goods_id,sales_date");
		return getPageInfo(null, sql.toString(), args);
	}

	public List<SalesDetail> staticSalesBrand(SalesDetail salesDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT c.brand,sum(num) num,sum(money) money,sum(c.in_come) in_come from sales_detail a left join ");
		sql.append(" sales b on a.sales_id = b.id left join goods c on c.id = a.goods_id  where  1=1");
		if (salesDetail.getStartDate() != null) {
			sql.append(" and  b.sales_date >=? ");
			args.add(salesDetail.getStartDate());
		}
		if (salesDetail.getEndDate() != null) {
			sql.append(" and  b.sales_date <=? ");
			args.add(salesDetail.getEndDate());
		}
		if (StringUtils.isNotBlank(salesDetail.getGoodsName())) {
			sql.append(" and  a.goods_name like ? ");
			args.add("%" + salesDetail.getGoodsName() + "%");
		}
		sql.append(" group by c.brand   order by sum(num) desc");
		return getPageInfo(null, sql.toString(), args);
	}

	public Integer getCount(SalesDetail salesDetail) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM sales_detail WHERE 1=1 ");
		sql = getStringBuffer(salesDetail, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param salesDetail
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(SalesDetail salesDetail,
			StringBuffer buf, List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (salesDetail.getSalesId() != null) {
			buf.append(" and sales_id = ? ");
			args.add(salesDetail.getSalesId());
		}

		// if(!CommonUtils.isNull(salesDetail.getGoodsId())){
		// buf.append(" and goods_id = ? ");
		// args.add(salesDetail.getGoodsId());
		// }
		//
		//
		//
		//
		// if(!CommonUtils.isNull(salesDetail.getNum())){
		// buf.append(" and num = ? ");
		// args.add(salesDetail.getNum());
		// }
		//

		return buf;
	}
}
