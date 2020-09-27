package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class LoadAccountAction {
	private int id;
	private Account a;
	private String recomenderIdNO;

	public String getRecomenderIdNO() {
		return recomenderIdNO;
	}

	public void setRecomenderIdNO(String recomenderIdNO) {
		this.recomenderIdNO = recomenderIdNO;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Account getA() {
		return a;
	}

	public void setA(Account a) {
		this.a = a;
	}

	public String execute() {
		IAccountDAO dao = (IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			a = dao.findById(id);
			if (a.getRecommenderId() != null&&a.getRecommenderId()!=0) {

				recomenderIdNO = dao.findById(a.getRecommenderId())
						.getIdcardNo();
			}

		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
