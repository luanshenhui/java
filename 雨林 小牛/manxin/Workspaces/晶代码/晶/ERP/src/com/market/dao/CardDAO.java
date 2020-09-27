package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Card;

public interface CardDAO {

	public void save(Card card);

	public void update(Card card);

	public void delete(Card card);

	public Card getCard(Card card);

	public Card getCard(Long id);

	/**
	 * 获得Card的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Card> findPageInfoCard(Card card, PageBean pageBean);

	public Integer getCount(Card card);
}
