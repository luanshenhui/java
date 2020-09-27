package com.service.action;

import java.util.List;

import com.cost.Factory.Factory;
import com.service.dao.ServiceDao;
import com.service.entity.VO;

public class ServiceAction {
	//输入
	private String os_username;
	private String unix_host;
	private String idcard_no;
	private String status;
	
	//输出
	private List<VO> list;
	int totalPage;
	int page = 1;
	int pageSize;
	
	public String getOs_username() {
		return os_username;
	}

	public void setOs_username(String osUsername) {
		os_username = osUsername;
	}

	public String getUnix_host() {
		return unix_host;
	}

	public void setUnix_host(String unixHost) {
		unix_host = unixHost;
	}

	public String getIdcard_no() {
		return idcard_no;
	}

	public void setIdcard_no(String idcardNo) {
		idcard_no = idcardNo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public List<VO> getList() {
		return list;
	}

	public void setList(List<VO> list) {
		this.list = list;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public String execute(){
		try {
			ServiceDao dao = (ServiceDao) Factory.getInstance("ServiceDao");
			list = dao.findByCondition(os_username, unix_host, idcard_no, status, page, pageSize);
			totalPage = dao.findTotalPage(os_username, unix_host, idcard_no, status, pageSize);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
