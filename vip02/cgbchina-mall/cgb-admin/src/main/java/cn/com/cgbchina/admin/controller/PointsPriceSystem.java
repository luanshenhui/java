/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/06/22
 */
@Controller
@RequestMapping("/api/admin/priceSystem")
@Slf4j
public class PointsPriceSystem {

	@Autowired
	CfgPriceSystemService cfgPriceSystemService;

	@Autowired
	MessageSources messageSources;

	/**
	 * 价格体系维护-金普卡积分系数-新增 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(CfgPriceSystemModel cfgPriceSystemModel) {
		// 从登录信息中获取用户信息并插入到model中
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String createOper = user.getName();
		String modifyOper = user.getName();
		cfgPriceSystemModel.setCreateOper(createOper);
		cfgPriceSystemModel.setModifyOper(modifyOper);
		try {
			// 新增
			Response<Boolean> result = cfgPriceSystemService.create(cfgPriceSystemModel);
			if (!result.isSuccess()) {
				log.error("create.priceStyle.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}

			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.priceStyle.error"));
		}
	}

	/**
	 * 价格体系维护-编辑 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(CfgPriceSystemModel cfgPriceSystemModel) {
		// 从登录信息中获取用户信息并插入到model中
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String modifyOper = user.getName();
		cfgPriceSystemModel.setModifyOper(modifyOper);
		try {
			// 更新
			Response<Boolean> result = cfgPriceSystemService.update(cfgPriceSystemModel);
			if (!result.isSuccess()) {
				log.error("update.priceStyle.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.priceStyle.error"));
		}
	}

	/**
	 * 价格体系维护--删除 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(Integer id) {
		Response<Boolean> result = Response.newResponse();
		// 从登录信息中获取用户信息并插入到model中
		User user = UserUtil.getUser();
		//调用查找最大基础上限值公共方法
		Integer upLimitMax = findMaxUpLimit();
		//查找要删除数据的基础上限
		Response<CfgPriceSystemModel> response = cfgPriceSystemService.findById(id);
		if(!response.isSuccess()){
			log.error("Response.error,error code: {}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}
		CfgPriceSystemModel cfgPriceSystemModel = response.getResult();
		Integer upLimit = cfgPriceSystemModel.getUpLimit();
		//如果要删除的数据的基础上限不是最大值，不允许删除
		if(!upLimit.equals(upLimitMax)){
			log.error("delete.maxUpLimit.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.maxUpLimit.error"));
		}

		try {
			// 删除
			result = cfgPriceSystemService.delete(id, user);
			if (!result.isSuccess()) {
				log.error("delete.priceStyle.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.priceStyle.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.priceStyle.error"));
		}
	}

	/**
	 * 价格体系维护-采购价上浮系数-编辑 niufw
	 *
	 * @param tblConfigModel
	 * @return
	 */
	@RequestMapping(value = "/purchaseUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> purchaseUpdate(TblConfigModel tblConfigModel) {
		// 从登录信息中获取用户信息并插入到model中
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String modifyOper = user.getName();
		tblConfigModel.setModifyOper(modifyOper);
		try {
			// 更新
			Response<Boolean> result = cfgPriceSystemService.purchaseUpdate(tblConfigModel);
			if (!result.isSuccess()) {
				log.error("update.purchase.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.purchase.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.purchase.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.purchase.error"));
		}
	}

	/**
	 * 查找最大基础上限值 niufw
	 * 
	 * @return
	 */
	@RequestMapping(value = "/findUpLimitMax", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String findUpLimitMax() {
		//调用 查找最大基础上限值公共方法
		Integer upLimitMax = findMaxUpLimit();
		return upLimitMax.toString();
	}

	/**
	 * 查找最大基础上限值公共方法 niufw
	 * 
	 * @return
	 */
	private Integer findMaxUpLimit() {
		// 查询所有金普卡积分系数
		Response<Pager<CfgPriceSystemModel>> pagerResponse = cfgPriceSystemService.find(null, null, "1");
		if (!pagerResponse.isSuccess()) {
			log.error("priceSystem.time.query.error，error:{}", pagerResponse.getError());
			throw new ResponseException(500, messageSources.get(pagerResponse.getError()));
		}
		Pager<CfgPriceSystemModel> pager = pagerResponse.getResult();
		// 如果查询结果不为空，则返回最大基础上限值;否则，返回0
		if (pager.getTotal() > 0) {
			List<CfgPriceSystemModel> cfgPriceSystemModelList = pager.getData();
			// 基础下限值集合
			List<Integer> upLimitList = new ArrayList<>();
			for (CfgPriceSystemModel cfgPriceSystemModel : cfgPriceSystemModelList) {
				Integer upLimit = cfgPriceSystemModel.getUpLimit();
				upLimitList.add(upLimit);
			}
			// 查找最大的基础下限值
			Integer upLimitMax = 0;
			for (Integer upLimit : upLimitList) {
				if (upLimit > upLimitMax) {
					upLimitMax = upLimit;
				}
			}
			return upLimitMax;
		} else {
			return 0;
		}
	}
}
