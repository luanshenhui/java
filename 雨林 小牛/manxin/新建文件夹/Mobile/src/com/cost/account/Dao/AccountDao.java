package com.cost.account.Dao;

import java.util.List;

import com.cost.account.entity.Account;

public interface AccountDao {

	//查询总页数
	int findTotalPage(String idcardNo, String realName,
			String loginName, String status, int pageSize) throws Exception;
	//搜索查询
	/**
	 * 根据条件查询账务账号
	 * @param realName 姓名
	 * @param loginName 登录名
	 * @param status 状态
	 * @return
	 * @throws Exception
	 */
	List<Account> findByCondition(String idcardNo, String realName, String loginName, 
			String status, int page, int pageSize)throws Exception;
	
	//开通
	void start(int id) throws Exception;
	
	//暂停
	void pause(int id) throws Exception;
	
	//添加
	void saveAccount(Account account) throws Exception;
	
	//根据身份证号查询
	Account findByIdcardNo(String idcard_no) throws Exception;
	
	//根据id查询
	Account findById(int id) throws Exception;
	
	//删除
	void delAccount(int id) throws Exception;
	
	//id和密码查询
	Account findByIdPwd(int id, String password) throws Exception;
	
	//修改
	void upAccount(Account account) throws Exception;
	
	//查询推荐人的身份证号
}
