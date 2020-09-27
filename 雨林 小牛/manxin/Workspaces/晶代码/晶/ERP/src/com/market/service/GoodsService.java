package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Goods;

public interface GoodsService {
	public void save(Goods goods);

	public void update(Goods goods);

	public void delete(Goods goods);

	public Goods getGoods(Goods goods);

	public Goods getGoods(Long id);

	public List<Goods> findPageInfoGoods(Goods goods, PageBean pageBean);

	public Integer getCount(Goods goods);
}
