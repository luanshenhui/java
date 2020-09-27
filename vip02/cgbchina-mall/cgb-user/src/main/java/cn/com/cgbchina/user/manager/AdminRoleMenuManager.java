package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.AdminRoleMenuDao;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 郝文佳 on 2016/5/23.
 */
@Component
@Transactional
public class AdminRoleMenuManager {
	@Resource
	private AdminRoleMenuDao adminRoleMenuDao;

	public Integer insert(Map<String, Object> map) {
		return adminRoleMenuDao.insert(map);
	}

	public Integer delete(Map<String, Object> map) {
		return adminRoleMenuDao.delete(map);
	}

}
