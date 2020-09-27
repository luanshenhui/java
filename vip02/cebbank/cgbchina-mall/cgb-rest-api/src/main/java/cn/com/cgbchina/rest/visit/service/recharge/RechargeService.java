package cn.com.cgbchina.rest.visit.service.recharge;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.recharge.MobileRechargeInfo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface RechargeService {
	BaseResult rechargeCMCC(MobileRechargeInfo info);
}
