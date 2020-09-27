package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.VendorRoleMenuDao;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 郝文佳 on 2016/5/23.
 */
@Component
@Transactional
public class VendorRoleMenuManager {
	@Resource
	private VendorRoleMenuDao vendorRoleMenuDao;

	public Integer insert(Map<String, Object> map) {
		return vendorRoleMenuDao.insert(map);
	}

	public Integer delete(Map<String, Object> map) {
		return vendorRoleMenuDao.delete(map);
	}

}
