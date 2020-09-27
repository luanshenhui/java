package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Card;

public class CardDAOImpl extends HibernateGenericDao<Card> implements CardDAO {

	public void save(Card card) {
		super.save(card);
	}

	public void update(Card card) {
		super.update(card);
	}

	public void delete(Card card) {
		super.remove(card);
	}

	public Card getCard(Card card) {
		return get(card.getId());
	}

	public Card getCard(Long id) {
		return get(id);
	}

	public List<Card> findPageInfoCard(Card card, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT a.*,b.name MEMBER_NAME FROM card a left join member b on a.member_id = b.id WHERE 1=1 ");
		sql = getStringBuffer(card, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Card card) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM card WHERE 1=1 ");
		sql = getStringBuffer(card, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param card
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Card card, StringBuffer buf, List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(card.getCardNo())) {
			buf.append(" and a.card_no like ? ");
			args.add("%" + card.getCardNo().trim() + "%");
		}
		if (card.getId() != null) {
			buf.append(" and a.id = ? ");
			args.add(card.getId());
		}
		return buf;
	}
}
