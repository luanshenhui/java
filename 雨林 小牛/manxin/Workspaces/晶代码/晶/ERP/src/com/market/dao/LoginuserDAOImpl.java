package com.market.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.market.util.HibernateGenericDao;
import com.market.util.PageBean;
import com.market.vo.Loginuser;

public class LoginuserDAOImpl extends HibernateGenericDao<Loginuser> implements
		LoginuserDAO {

	public void save(Loginuser loginuser) {
		super.save(loginuser);
	}

	public void update(Loginuser loginuser) {
		super.update(loginuser);
	}

	public void delete(Loginuser loginuser) {
		super.remove(loginuser);
	}

	public Loginuser getLoginuser(Loginuser loginuser) {
		return get(loginuser.getId());
	}

	public Loginuser getLoginuser(Long id) {
		return get(id);
	}

	public List<Loginuser> findPageInfoLoginuser(Loginuser loginuser,
			PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM loginuser WHERE 1=1 ");
		sql = getStringBuffer(loginuser, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public List<Loginuser> findPageInfoLoginuser1(Loginuser loginuser,
			PageBean pageBean) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT * FROM loginuser WHERE  NAME<>'admin' ");
		sql = getStringBuffer(loginuser, sql, args);
		return getPageInfo(pageBean, sql.toString(), args);
	}

	public Integer getCount1(Loginuser loginuser) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM loginuser WHERE NAME<>'admin'  ");
		sql = getStringBuffer(loginuser, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	public Integer getCount(Loginuser loginuser) {
		List args = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT COUNT(0) FROM loginuser WHERE 1=1 ");
		sql = getStringBuffer(loginuser, sql, args);
		return super.getCount(sql.toString(), args.toArray());
	}

	/**
	 * 构造查询条件
	 * 
	 * @param loginuser
	 * @param buf3
	 * @param args
	 * @return
	 * @author Alex 10/28/2011 create
	 */
	private StringBuffer getStringBuffer(Loginuser loginuser, StringBuffer buf,
			List args) {
		/*
		 * 需要加入查询条件时封装
		 */

		if (StringUtils.isNotBlank(loginuser.getName())) {
			buf.append(" and name = ? ");
			args.add(loginuser.getName().trim());
		}
		if (StringUtils.isNotBlank(loginuser.getPassword())) {
			buf.append(" and password = ? ");
			args.add(loginuser.getPassword().trim());
		}
		if (StringUtils.isNotBlank(loginuser.getUserType())) {
			buf.append(" and user_type like ? ");
			args.add("%" + loginuser.getUserType().trim() + "%");
		}
		return buf;
	}
}
