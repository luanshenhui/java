/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.related.dao.CouponInfDao;
import cn.com.cgbchina.related.model.CouponInfModel;
import com.google.common.collect.Lists;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


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
		if(couponInfModel.getIsManual() == 0 && couponInfModel.getIsFirstlogin() == 1){
			// 之前设置的首次登录设置无效
			couponInfDao.updateOtherFirstLogin();
		}
		return couponInfDao.updateAll(couponInfModel) == 1;
	}
    public boolean create(CouponInfModel couponInfModel) {
        return couponInfDao.insert(couponInfModel) == 1;
    }

	public boolean updateById(CouponInfModel couponInfModel) {
		return couponInfDao.updateById(couponInfModel) == 1;
	}

	/**
	 * 获取优惠券
	 *
	 * @param couponInfModelList 同步的优惠券数据
	 * @param couponInfModels	数据库存在的优惠券id
	 * @return
	 */
	public Boolean synchronizeCoupon(List<CouponInfModel> couponInfModelList,List<String> couponInfModels){
		//设置所有优惠券失效
		couponInfDao.deleteAll();
		if(couponInfModelList == null || couponInfModelList.isEmpty()){
			return true;
		}
		//新增数据库中不存在的优惠券
		List<CouponInfModel> couponInfModelsnew = Lists.newArrayList();
		if (couponInfModels == null || couponInfModels.isEmpty()){
			couponInfModelsnew = couponInfModelList;
		}else {
			for(CouponInfModel couponInfModel:couponInfModelList){
				if(!couponInfModels.contains(couponInfModel.getCouponId())){
					couponInfModelsnew.add(couponInfModel);
				}
			}
		}
		if(couponInfModelsnew != null && !couponInfModelsnew.isEmpty()){
			//新增接口查询出的优惠券
			couponInfDao.deleteCreat(couponInfModelsnew);
			couponInfDao.createForList(couponInfModelsnew);
		}

		//更新数据库中原本存在的优惠券的相关信息
		couponInfDao.updateForList(couponInfModelList);
		return true;
	}


}
