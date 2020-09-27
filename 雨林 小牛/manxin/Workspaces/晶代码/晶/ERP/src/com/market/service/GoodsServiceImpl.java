package com.market.service;

import java.util.List;

import com.market.dao.GoodsDAO;
import com.market.util.PageBean;
import com.market.vo.Goods;

public class GoodsServiceImpl implements GoodsService {
	private GoodsDAO goodsDAO;

	public void save(Goods goods) {
		goodsDAO.save(goods);
	}

	public void update(Goods goods) {
		goodsDAO.update(goods);
	}

	public Goods getGoods(Goods goods) {
		return goodsDAO.getGoods(goods);
	}

	public Goods getGoods(Long id) {
		return goodsDAO.getGoods(id);
	}

	public void delete(Goods goods) {
		goodsDAO.delete(goods);
	}

	public List<Goods> findPageInfoGoods(Goods goods, PageBean pageBean) {
		return goodsDAO.findPageInfoGoods(goods, pageBean);
	}

	public Integer getCount(Goods goods) {
		return goodsDAO.getCount(goods);
	}

	public void setGoodsDAO(GoodsDAO goodsDAO) {
		this.goodsDAO = goodsDAO;
	}
}
