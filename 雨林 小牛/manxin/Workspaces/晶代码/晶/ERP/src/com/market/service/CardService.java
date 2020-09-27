package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Card;

public interface CardService {
	public void save(Card card);

	public void update(Card card);

	public void delete(Card card);

	public Card getCard(Card card);

	public Card getCard(Long id);

	public List<Card> findPageInfoCard(Card card, PageBean pageBean);

	public Integer getCount(Card card);
}
