package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.OrganiseDao;
import cn.com.cgbchina.user.model.OrganiseModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Component
@Transactional
public class OrganiseManager {

	@Resource
	private OrganiseDao organiseDao;

	public void create(OrganiseModel organiseModel) {
		organiseModel.setCheckStatus("0");
		organiseDao.insert(organiseModel);
	}

	public boolean update(OrganiseModel organiseModel) {
		return organiseDao.update(organiseModel);
	}

	public void delete(String code) {
		organiseDao.delete(code);
	}
}
