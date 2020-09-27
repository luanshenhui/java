/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.LocalProcodeDao;
import cn.com.cgbchina.user.model.LocalProcodeModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;


/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-12.
 */
@Component
@Transactional
public class LocalProcodeManage {
	@Resource
	private LocalProcodeDao localProcodeDao;

	public boolean create(LocalProcodeModel localProcodeModel) {
		return localProcodeDao.insert(localProcodeModel) == 1;
	}

	public boolean update(LocalProcodeModel localProcodeModel) {
		return localProcodeDao.update(localProcodeModel) == 1;
	}

	public boolean delete(LocalProcodeModel localProcodeModel) {
		return localProcodeDao.delete(localProcodeModel) == 1;
	}
}
