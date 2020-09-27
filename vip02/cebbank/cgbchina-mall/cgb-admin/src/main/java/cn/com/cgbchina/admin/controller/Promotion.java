package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.dto.ItemPromDto;
import cn.com.cgbchina.item.dto.PromGoodsParamDto;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.promotion.dto.AdminPromotionAddDto;
import cn.com.cgbchina.promotion.dto.AdminPromotionDetailDto;
import cn.com.cgbchina.promotion.dto.AdminPromotionUpdateDto;
import cn.com.cgbchina.promotion.dto.PromItemDto;
import cn.com.cgbchina.promotion.service.PromotionService;
import cn.com.cgbchina.promotion.service.VendorPromotionService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.user.dto.VendorInfoIdDto;
import cn.com.cgbchina.user.service.VendorService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 活动管理
 */

@Controller
@RequestMapping("/api/admin/promotion")
@Slf4j
public class Promotion {

	@Resource
	private PromotionService promotionService;
	@Resource
	private MessageSources messageSources;
	@Resource
	private VendorPromotionService vendorPromotionService;
	@Autowired
	private GoodsService goodsService;
	@Resource
	private VendorService vendorService;

	/**
	 * 创建活动（内管、供应商共用）
	 *
	 * @param createOperType 创建人类型(0 内管，1 供应商）
	 * @param adminPromotionAddDto 活动信息
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> create(@Valid AdminPromotionAddDto adminPromotionAddDto, String createOperType,
			BindingResult bindingResult) {
		Response<String> response = new Response<>();
		// 判断校验是否成功
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<Boolean> result = promotionService.addAdminPromotion(createOperType, adminPromotionAddDto,
				UserUtil.getUser());
		if (result.isSuccess()) {
			response.setResult(result.getResult().toString());
			return response;
		}
		log.error("failed to create {},error code:{}", adminPromotionAddDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/findDetailById", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public AdminPromotionDetailDto findDetailById(Integer promotionId) {
		Response<AdminPromotionDetailDto> result = promotionService.findDetailById(promotionId);
		if (result.isSuccess()) {

			return result.getResult();
		}
		log.error("failed to find promotion by id= {},error code:{}", promotionId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/checkStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkStatus(Integer id, String auditLog, Integer checkStatus) {
		Response<Boolean> result = promotionService.updateCheckStatus(id, UserUtil.getUser(), auditLog, checkStatus);
		if (result.isSuccess()) {

			return result.getResult();
		}
		log.error("failed to check promotion by id= {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/doubleCheckItem", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean doubleCheckStatus(Integer id, Integer promotionId, String auditLog, Integer checkStatus) {
		Response<Boolean> result = promotionService.doubleCheckRange(id, promotionId, auditLog, checkStatus,
				UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to check promotion by id= {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/doubleCheckPromotion", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean doubleCheckPromotion(Integer promotionId, String auditLog, Integer checkStatus) {
		Response<Boolean> result = promotionService.doubleCheckPromotion(promotionId, auditLog, checkStatus,
				UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to check promotion by id= {},error code:{}", promotionId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/findRanges", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<PromItemDto> findRanges(Integer promotionId, Integer checkStatus, String vendorName, String itemName,
			Integer pageNo, Integer size) {
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Response<Pager<PromItemDto>> result = promotionService.findRanges(promotionId, checkStatus, vendorName,
				itemName, pageInfo);
		if (result.isSuccess()) {
			return result.getResult();
		}

		log.error("failed to find range ,error code:{}", promotionId, checkStatus, vendorName, itemName,
				result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据指定条件取得单品、商品列表
	 *
	 * @param promGoodsParamDto 参数bean
	 * @return
	 */
	@RequestMapping(value = "/findItemListForProm", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<ItemPromDto>> findItemListForProm(@Valid PromGoodsParamDto promGoodsParamDto) {

		Response<List<ItemPromDto>> response = new Response<List<ItemPromDto>>();
		try {
			User user = UserUtil.getUser();
			response = goodsService.findItemsListForProm(promGoodsParamDto, user);
			return response;
		} catch (Exception e) {
			log.error("GoodsDetailService.getUserBirth.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return response;
		}
	}

	/**
	 * 根据名称模糊查询供应商，并且去除指定ID的供应商
	 * @param simpleName
	 * @return
	 */
	@RequestMapping(value = "/findVenDtoByName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VendorInfoIdDto> findVenDtoByName(String simpleName,String vendorIds) {
		List<String> vendorIdsList = new ArrayList<String>();
		if (StringUtils.isNotEmpty(vendorIds)) {
			vendorIdsList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(vendorIds);
		}
		Response<List<VendorInfoIdDto>> result = vendorService.findVenDtoByVendorIds(vendorIdsList);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find vendor by name= {},error code:{}", simpleName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/offAndDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean offAndDelete(Integer promotionId, Integer checkStatus) {
		Response<Boolean> result = promotionService.offAndDelete(promotionId, checkStatus);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to offAndDelete promotion by id= {},error code:{}", promotionId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(AdminPromotionUpdateDto adminPromotionUpdateDto) {
		Response<Boolean> result = promotionService.updateAdminPromotion(adminPromotionUpdateDto, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update promotion by {},error code:{}", adminPromotionUpdateDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
