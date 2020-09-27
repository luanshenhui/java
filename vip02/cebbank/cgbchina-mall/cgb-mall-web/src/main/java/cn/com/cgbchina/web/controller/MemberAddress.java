/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dto.MemberAddressDto;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/05/22
 */
@Controller
@RequestMapping("/api/mall/memberAddress")
@Slf4j
public class MemberAddress {
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private MemberAddressService memberAddressService;

	/**
	 * 查找收获地址
	 * 
	 * @return list MemberAddressModel create by zhangc
	 */
	@RequestMapping(value = "/addressFind", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<MemberAddressModel> find() {
		try {
			// 实例化Response
			Response<Pager<MemberAddressModel>> response = new Response<Pager<MemberAddressModel>>();
			// 获取用户信息
			User user = UserUtil.getUser();
			// 查找我的收获地址
			response = memberAddressService.findAll(null, null, user);
			// 返回json
			return response.getResult().getData();
		} catch (IllegalArgumentException e) {
			log.error("find.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("find.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("find.address.error"));
		}
	}

	/**
	 * 收货地址添加
	 *
	 * @param memberAddressDto
	 * @return
	 */
	@RequestMapping(value = "/addressCreate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(MemberAddressDto memberAddressDto) {
		try {
			// 校验
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String custId = user.getCustId();
			String creatOper = user.getName();
			memberAddressDto.setCustId(custId);
			memberAddressDto.setCreatOper(creatOper);
			// 如果前台未选择默认，由于form没有传过来值，故直接赋值为非默认
			String isDefault = memberAddressDto.getIsDefault();
			if (StringUtils.isEmpty(isDefault)) {
				memberAddressDto.setIsDefault(Contants.MALL_ADDRESS_STATUS_1);
			}
			// 新增
			Response<Boolean> result = memberAddressService.create(memberAddressDto);
			if (!result.isSuccess()) {
				log.error("create.address.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.address.error，error"));
		}
	}

	/**
	 * 收货地址编辑
	 *
	 * @param memberAddressDto
	 * @return
	 */
	@RequestMapping(value = "/addressUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(MemberAddressDto memberAddressDto) {
		try {
			// 校验
			// 获取登录用户的信息
			User user = UserUtil.getUser();
			memberAddressDto.setCustId(user.getCustId());

			// 如果前台未选择默认，由于form没有传过来值，故直接赋值为非默认
			String isDefault = memberAddressDto.getIsDefault();
			if (StringUtils.isEmpty(isDefault)) {
				memberAddressDto.setIsDefault(Contants.MALL_ADDRESS_STATUS_1);
			}
			// 更新
			Response<Boolean> result = memberAddressService.update(memberAddressDto);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.address.error，error"));
		}
	}

	/**
	 * 收货地址删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{componentId}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable("componentId") Long id) {
		try {
			// 校验
			// 删除
			Response<Boolean> result = memberAddressService.delete(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.address.error，error"));
		}
	}

	/**
	 * 设置默认地址
	 *
	 * @param id
	 * @param custId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/addressDefault", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public Response<Boolean> setDefault(Long id, String custId) {
		try {
			// 校验

			// 删除
			Response<Boolean> result = memberAddressService.setDefault(id, custId);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("default.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("default.address.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("default.address.error，error"));
		}
	}

}
