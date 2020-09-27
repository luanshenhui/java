/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.service.CouponScaleService;
import cn.com.cgbchina.item.service.PointsPoolService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/04/15
 */
@Controller
@RequestMapping("/api/admin/item")
@Slf4j
public class PointsDepositRate {

	@Autowired
	CouponScaleService couponScaleService;

	@Autowired
	MessageSources messageSources;

	/**
	 * 积分池新增
	 *
	 * @param couponScaleDto
	 * @return
	 */
	@RequestMapping(value = "/pointsDepositRateUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(CouponScaleDto couponScaleDto) {
		try {
			// 校验
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String modifyOper = user.getName();
			couponScaleDto.setModifyOper(modifyOper);
			Response<Boolean> result = couponScaleService.update(couponScaleDto);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}
}
