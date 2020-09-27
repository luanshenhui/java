package com.service.dao;

import java.util.List;

import com.cost.account.entity.Account;
import com.service.entity.Service;
import com.service.entity.VO;

public interface ServiceDao {
	//查询
	List<VO> findByCondition(String os_username,String unix_host, String idcard_no,
			String status, int page, int pageSize) throws Exception;
	//查询总页数
	int findTotalPage(String os_username,String unix_host, String idcard_no,
			String status, int pageSize) throws Exception;
	//开通
	void start(int id) throws Exception;
	//暂停
	void pause(int id) throws Exception;
	//删除
	void delService(int id) throws Exception;
	//添加
	void saveService(Service service) throws Exception;
	//根据id查询
	VO findById(int id) throws Exception;
	//修改
	void upService(Service service) throws Exception;
	//根据业务账号查询账务账号
	Account findAccountByServiceId(int serviceId) throws Exception;
}
