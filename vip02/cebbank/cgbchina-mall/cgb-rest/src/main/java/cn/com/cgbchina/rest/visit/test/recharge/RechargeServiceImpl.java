package cn.com.cgbchina.rest.visit.test.recharge;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.recharge.MobileRechargeInfo;
import cn.com.cgbchina.rest.visit.service.recharge.RechargeService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class RechargeServiceImpl implements RechargeService {
	@Override
	public BaseResult rechargeCMCC(MobileRechargeInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}
}
