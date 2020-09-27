package com.market.service;

import java.util.List;

import com.market.dao.LoginuserDAO;
import com.market.util.PageBean;
import com.market.vo.Loginuser;

public class LoginuserServiceImpl implements LoginuserService {
	private LoginuserDAO loginuserDAO;

	public void save(Loginuser loginuser) {
		loginuserDAO.save(loginuser);
	}

	public void update(Loginuser loginuser) {
		loginuserDAO.update(loginuser);
	}

	public Loginuser getLoginuser(Loginuser loginuser) {
		return loginuserDAO.getLoginuser(loginuser);
	}

	public Loginuser getLoginuser(Long id) {
		return loginuserDAO.getLoginuser(id);
	}

	public void delete(Loginuser loginuser) {
		loginuserDAO.delete(loginuser);
	}

	public List<Loginuser> findPageInfoLoginuser(Loginuser loginuser,
			PageBean pageBean) {
		return loginuserDAO.findPageInfoLoginuser(loginuser, pageBean);
	}

	public Integer getCount(Loginuser loginuser) {
		return loginuserDAO.getCount(loginuser);
	}

	public void setLoginuserDAO(LoginuserDAO loginuserDAO) {
		this.loginuserDAO = loginuserDAO;
	}

	public List<Loginuser> findPageInfoLoginuser1(Loginuser loginuser,
			PageBean pageBean) {

		return loginuserDAO.findPageInfoLoginuser1(loginuser, pageBean);
	}

	public Integer getCount1(Loginuser loginuser) {

		return loginuserDAO.getCount1(loginuser);
	}
}
