/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.service.BrandService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/13.
 */
@Controller
@RequestMapping("/api/admin/authorize")
@Slf4j
public class BrandsAuthorize {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private BrandService brandService;
	@Resource
	private MessageSources messageSources;

	/**
	 * 修改品牌授权
	 * 
	 * @param brandAuthorizeDto
	 * @return
	 */
	@RequestMapping(value = "/examBrandAuthorize", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean examBrandAuthorize(BrandAuthorizeDto brandAuthorizeDto) {
		// 获取用户信息
		User user = UserUtil.getUser();
		// 修改
		Response<Boolean> response = brandService.update(brandAuthorizeDto, user, Contants.BUSINESS_TYPE_YG);
		if (response.isSuccess()){
			return response.getResult();
		}
		log.error("failed to updata brand authorize {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 更新品牌授权信息
	 * 
	 * @param brandAuthorizeDto
	 * @return
	 */
	@RequestMapping(value = "/updateBrandAuthorize", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateBrandAuthorize(BrandAuthorizeDto brandAuthorizeDto) {
		// 根据id查询表中原有信息
		Response<BrandAuthorizeModel> response = brandService.findBrandAuthorizeById(brandAuthorizeDto.getId());
		BrandAuthorizeDto newBrandAuthorize = new BrandAuthorizeDto();
		if (response.isSuccess()) {
			BrandAuthorizeModel oldBrandAuthorize = response.getResult();
			oldBrandAuthorize.setBrandAuthorizeImage(brandAuthorizeDto.getBrandAuthorizeImage());
			oldBrandAuthorize.setBrandImage(brandAuthorizeDto.getBrandImage());
			oldBrandAuthorize
					.setStartTime(DateHelper.string2Date(brandAuthorizeDto.getV_startTime(), DateHelper.YYYY_MM_DD));
			oldBrandAuthorize
					.setEndTime(DateHelper.string2Date(brandAuthorizeDto.getV_endTime(), DateHelper.YYYY_MM_DD));
			// 转为json
			String approveDiff = jsonMapper.toJson(oldBrandAuthorize);
			newBrandAuthorize.setId(brandAuthorizeDto.getId());
			newBrandAuthorize.setApproveDiff(approveDiff);
			newBrandAuthorize.setApproveState(Contants.BRAND_APPROVE_STATUS_00);
			// 每次编辑后更新申请时间
			newBrandAuthorize.setCreateTime(new Date());
			// 获取用户信息
			User user = UserUtil.getUser();
			// 修改
			Response<Boolean> result = brandService.update(newBrandAuthorize, user, Contants.BUSINESS_TYPE_YG);
			if (result.isSuccess()) {
				return result.getResult();
			}
		}
		log.error("failed to updata brand authorize {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

}
