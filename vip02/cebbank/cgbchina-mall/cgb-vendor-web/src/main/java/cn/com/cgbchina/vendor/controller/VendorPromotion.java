package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.ItemPromDto;
import cn.com.cgbchina.item.dto.PromGoodsParamDto;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.CategoryNode;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.promotion.dto.AdminPromotionAddDto;
import cn.com.cgbchina.promotion.dto.PromParamDto;
import cn.com.cgbchina.promotion.dto.PromotionResultDto;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.service.PromotionService;
import cn.com.cgbchina.promotion.service.VendorPromotionService;
import com.google.common.base.Throwables;
import com.spirit.Annotation.Param;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import java.util.List;

/**
 * Created by Wangqi on 16-6-13.
 */
@Controller
@RequestMapping("/api/vendor/VendorPromotion")
@Slf4j
public class VendorPromotion {

	@Autowired
	private VendorPromotionService vendorPromotionService;
	@Autowired
	private PromotionService promotionService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private BackCategoriesService backCategoriesService;

	/**
	 * 新增活动信息
	 *
	 * @param promotionModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(AdminPromotionAddDto promotionModel) throws ParseException {

		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 增加活动信息 createOperType : "1"  供应商
			Response<Boolean> result = promotionService.addAdminPromotion("1", promotionModel, user);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}

	/**
	 * 新增/修改活动产品信息（供应商活动） 、 报名（平台活动）
	 *
	 * @param promParamDto
	 * @return
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(PromParamDto promParamDto) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			Response<Boolean> result = new Response<Boolean>();
			PromotionModel promotionModel = promParamDto.getPromotionModel();
			// 报名 TODO
			// result = vendorPromotionService.vendorUpdatePromRange("1", promParamDto, user);
			result = vendorPromotionService.vendorUpdatePromRange("", promParamDto.getId(),
					promParamDto.getStrPromotionRangeModel(), user);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}

	/**
	 * 取得详情
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/vendorFindById", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<PromotionResultDto> vendorFindById(Integer id) {
		Response<PromotionResultDto> result = new Response<PromotionResultDto>();
		try {
			result = vendorPromotionService.findByIdForVendor(id);
			return result;
		} catch (Exception e) {
			log.error("GoodsDetailService.getUserBirth.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("GoodsDetailService.getUserBirth.fail");
			return result;
		}
	}

	/**
	 * 修改供应商活动（供应商用） 测试 vendorPromotionService.vendorFindPromotionList()
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/vendorFindPromotionList", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Pager<PromotionResultDto>> vendorFindPromotionList(@Param("state") String state,
			@Param("createOperType") String createOperType, @Param("promType") String promType,
			@Param("shortName") String shortName, @Param("promCode") String promCode,
			@Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("goodsName") String goodsName, @Param("entryState") String entryState,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size) {
		Pager<PromotionResultDto> result = new Pager<PromotionResultDto>();
		Response<Pager<PromotionResultDto>> pagerResponse = new Response<Pager<PromotionResultDto>>();
		try {
			pagerResponse = vendorPromotionService.findPromotionListForVendor(state, createOperType, promType,
					shortName, promCode, beginDate, endDate, beginEntryDate, endEntryDate, goodsName, entryState,
					pageNo, size);
			return pagerResponse;
		} catch (Exception e) {
			log.error("GoodsDetailService.getUserBirth.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return pagerResponse;
		}
	}

	/**
	 * 根据指定条件取得单品、商品列表
	 *
	 * @param promGoodsParamDto 参数bean
	 * @return
	 */
	@RequestMapping(value = "/findItemListForProm", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<ItemPromDto>> findItemListForProm(PromGoodsParamDto promGoodsParamDto) {

		Response<List<ItemPromDto>> response = new Response<List<ItemPromDto>>();
		try {
			User user = UserUtil.getUser();
			response = goodsService.findItemsListForProm(promGoodsParamDto, user);
			return response;
		} catch (Exception e) {
			log.error("VendorPromotion.findItemListForProm.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return response;
		}
	}

}
