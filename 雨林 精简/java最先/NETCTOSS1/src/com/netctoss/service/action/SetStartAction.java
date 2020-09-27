package com.netctoss.service.action;

import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.util.DAOFactory;

public class SetStartAction {
	private int id;
	private String message;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String execute() {
		Account account = null;
		IServiceDAO dao = (IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			account = dao.findAccountByServiceId(id);
		} catch (DAOException e) {
			e.printStackTrace();
			message = "发生系统错误，开通失败";
			return "success";
		}

		if (account != null) {
			String accountStatus = account.getStatus();
			if (accountStatus == null || accountStatus.equals("1")
					|| accountStatus.equals("2")) {
				message="对应的帐务帐号不是开通状态，你不能进行此操作";
				return "success";
			}
		}
		
		try {
			dao.SetStart(id);
		} catch (DAOException e) {
			e.printStackTrace();
			message = "发生系统错误，开通失败";
			return "success";
		}
		return "success";
	}
}
