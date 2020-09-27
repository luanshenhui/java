package com.market.service;

import java.util.List;

import com.market.dao.CardDAO;
import com.market.util.PageBean;
import com.market.vo.Card;

public class CardServiceImpl implements CardService {
	private CardDAO cardDAO;

	public void save(Card card) {
		cardDAO.save(card);
	}

	public void update(Card card) {
		cardDAO.update(card);
	}

	public Card getCard(Card card) {
		return cardDAO.getCard(card);
	}

	public Card getCard(Long id) {
		return cardDAO.getCard(id);
	}

	public void delete(Card card) {
		cardDAO.delete(card);
	}

	public List<Card> findPageInfoCard(Card card, PageBean pageBean) {
		return cardDAO.findPageInfoCard(card, pageBean);
	}

	public Integer getCount(Card card) {
		return cardDAO.getCount(card);
	}

	public void setCardDAO(CardDAO cardDAO) {
		this.cardDAO = cardDAO;
	}
}
