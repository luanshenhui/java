/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.related.dao.EspAdvertiseDao;
import cn.com.cgbchina.related.model.EspAdvertiseModel;

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
