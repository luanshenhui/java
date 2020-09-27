package com.cebbank.ccis.cebmall.user.manager;


import com.cebbank.ccis.cebmall.user.dao.EspAdvertiseDao;
import com.cebbank.ccis.cebmall.user.model.EspAdvertiseModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-30.
 */
@Component
@Transactional
public class EspAdvertiseManager {
	@Resource
	private EspAdvertiseDao espAdvertiseDao;

	public boolean update(EspAdvertiseModel espAdvertise) {
		return espAdvertiseDao.update(espAdvertise) == 1;
	}

	public boolean insert(EspAdvertiseModel espAdvertise) {
		return espAdvertiseDao.insert(espAdvertise)==1;
	}

	public boolean delete(EspAdvertiseModel espAdvertise) {
		return espAdvertiseDao.delete(espAdvertise)==1;
	}
	public boolean updateAdvetiseStatus(EspAdvertiseModel espAdvertise) {
		return espAdvertiseDao.updateAdvetiseStatus(espAdvertise)==1;
	}
	public boolean updateIsStop(EspAdvertiseModel espAdvertise) {
		return espAdvertiseDao.updateIsStop(espAdvertise)==1;
	}

}
