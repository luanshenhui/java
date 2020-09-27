/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.service;

import cn.com.cgbchina.rest.visit.model.user.EEA1Info;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-24.
 */
@Component
public class EPinService {

	@Autowired
	private UserService userService;

	/**
	 * 链接密码机获取密文
	 * 
	 * @param request
	 * @param password
	 * @return
	 */
	public EEA1InfoResult EEA1(HttpServletRequest request, String password) {
		// 存在去重的情况下
		EEA1InfoResult eEA1InfoResult = new EEA1InfoResult();
		try {
			Object objPwd = request.getSession().getAttribute("randomPwd");
			EEA1Info eEA1Info = new EEA1Info();
			if (objPwd != null) {
				eEA1Info.setRandom(objPwd.toString());
			}
			eEA1Info.setPinBlock(password);
			eEA1InfoResult = userService.getEncipherTextByEEA1(eEA1Info);
			return eEA1InfoResult;
		}catch (Exception e){
			eEA1InfoResult.setRetCode("");
			return eEA1InfoResult;
		}
	}
}
