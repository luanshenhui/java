/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.PointPoolModel;
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
public class PointPool {

	@Autowired
	PointsPoolService pointsPoolService;

	@Autowired
	MessageSources messageSources;

	/**
	 * 积分池新增
	 *
	 * @param pointPoolModel
	 * @return
	 */
	@RequestMapping(value = "/pointPoolCreate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(PointPoolModel pointPoolModel) {
		try {
			// 校验
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String creatOper = user.getName();
			pointPoolModel.setCreateOper(creatOper);
			Response<Boolean> result = pointsPoolService.create(pointPoolModel);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}

	/**
	 * 积分池编辑
	 *
	 * @param pointPoolModel
	 * @return
	 */
	@RequestMapping(value = "/pointPoolUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(PointPoolModel pointPoolModel) {
		try {
			// 校验
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String modifyOper = user.getName();
			pointPoolModel.setModifyOper(modifyOper);
			Response<Boolean> result = pointsPoolService.update(pointPoolModel);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}

	/**
	 * 积分池删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/pointPoolDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(Long id) {
		try {
			// 校验
			Response<Boolean> result = pointsPoolService.delete(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}

	/**
	 * 月份唯一性校验
	 *
	 * @param curMonth
	 * @return
	 */
	@RequestMapping(value = "/curMonthCheck", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> curMonthCheck(String curMonth) {
		try {
			Response<Integer> result = pointsPoolService.curMonthCheck(curMonth);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("check.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("refuse.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
		}
	}

}
