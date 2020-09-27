package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Member;

public class MemberDAOImpl extends HibernateGenericDao<Member> implements
		MemberDAO {

	public void save(Member member) {
		super.save(member);
	}

	public void update(Member member) {
		super.update(member);
	}

	public void delete(Member member) {
		super.remove(member);
	}

	public Member getMember(Member member) {
		return get(member.getId());
	}

	public Member getMember(Long id) {
		return get(id);
	}

	public List<Member> findPageInfoMember(Member member, PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM member WHERE 1=1 ");
		sql = getStringBuffer(member, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount(Member member) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM member WHERE 1=1 ");
		sql = getStringBuffer(member, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param member
	 * @param buf
	 * @param args
	 * @return
	 * @author Alex 12/06/2011 create
	 */
	private StringBuffer getStringBuffer(Member member, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(member.getName())) {
			buf.append(" and name like ? ");
			args.add("%" + member.getName().trim() + "%");
		}
		if (StringUtils.isNotBlank(member.getIdno())) {
			buf.append(" and idno like ? ");
			args.add("%" + member.getIdno().trim() + "%");
		}
		if (StringUtils.isNotBlank(member.getCardNo())) {
			if ("-1".equals(member.getCardNo())) {
				buf.append(" and card_no is  null ");
			} else {
				buf.append(" and card_no = ? ");
				args.add(member.getCardNo().trim());
			}

		}
		return buf;
	}
}
