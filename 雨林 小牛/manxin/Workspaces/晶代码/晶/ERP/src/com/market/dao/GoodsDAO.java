package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Goods;

public interface GoodsDAO {

	public void save(Goods goods);

	public void update(Goods goods);

	public void delete(Goods goods);

	public Goods getGoods(Goods goods);

	public Goods getGoods(Long id);

	/**
	 * 获得Goods的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Goods> findPageInfoGoods(Goods goods, PageBean pageBean);

	public Integer getCount(Goods goods);
}
