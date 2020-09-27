package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.ServicePromiseDao;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11150421040212 on 16-4-23.
 */
@Component
@Transactional
public class ServicePromiseManager {
	@Resource
	private ServicePromiseDao servicePromiseDao;

	public boolean create(ServicePromiseModel servicePromiseModel) {
		return servicePromiseDao.insert(servicePromiseModel) == 1;
	}

	public boolean update(ServicePromiseModel servicePromiseModel) {
		return servicePromiseDao.update(servicePromiseModel) == 1;
	}

	public boolean delete(ServicePromiseModel servicePromiseModel) {
		return servicePromiseDao.delete(servicePromiseModel) == 1;
	}
}
