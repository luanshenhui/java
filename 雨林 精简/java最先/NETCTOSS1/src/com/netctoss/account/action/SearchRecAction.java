package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class SearchRecAction {
	private String idcardNo;
	private Account account;
	public String getIdcardNo() {
		return idcardNo;
	}
	public void setIdcardNo(String idcardNo) {
		this.idcardNo = idcardNo;
	}
	public Account getAccount() {
		return account;
	}
	public void setAccount(Account account) {
		this.account = account;
	}
	public String execute(){
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			account=dao.findByIdcardNo(idcardNo);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
