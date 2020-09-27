/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.related.dao.CouponInfDao;
import cn.com.cgbchina.related.model.CouponInfModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;


/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-14.
 */
@Component
@Transactional
public class CouponInfManager {
	@Resource
	private CouponInfDao couponInfDao;


	public boolean update(CouponInfModel couponInfModel) {
		return couponInfDao.update(couponInfModel) == 1;
	}
    public boolean create(CouponInfModel couponInfModel) {
        return couponInfDao.insert(couponInfModel) == 1;
    }
}
