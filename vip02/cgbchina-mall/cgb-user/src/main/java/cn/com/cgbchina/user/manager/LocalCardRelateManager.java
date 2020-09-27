/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.LocalCardRelateDao;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;



/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Component
@Transactional
public class LocalCardRelateManager {
	@Resource
	private LocalCardRelateDao localCardRelateDao;

	public boolean create(LocalCardRelateModel localCardRelateModel) {
		return localCardRelateDao.insert(localCardRelateModel) == 1;
	}

	public boolean delete(LocalCardRelateModel localCardRelateModel) {
		return localCardRelateDao.delete(localCardRelateModel) == 1;
	}

}
