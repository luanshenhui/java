package com.yulin.dangdang.dao;

import com.yulin.dangdang.bean.User;

public interface UserDao {
	/** 添加一个用户 */
	public User insert(User u);
	
	/** 通过email查询一个用户是否存在 */
	public boolean isExistByEmail(String email);
	
	/** 通过用户名和密码获得用户 */
	public User findByLogin(String email, String pwd);
	
	/** 更改用户信息 */
	public boolean updateUser(User u);
	
	/** 删除用户信息 */
	public boolean deleUser(int id);
	
	/** 更新邮箱验证状态 */
	public boolean updateCode(String email);
}
