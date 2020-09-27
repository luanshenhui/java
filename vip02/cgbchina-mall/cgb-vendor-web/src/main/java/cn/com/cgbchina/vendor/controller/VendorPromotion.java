package cn.com.cgbchina.vendor.controller;

import java.text.ParseException;
import java.util.List;

import com.spirit.category.service.BackCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.dto.ItemPromDto;
import cn.com.cgbchina.item.dto.PromGoodsParamDto;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.dto.AdminPromotionAddDto;
import cn.com.cgbchina.item.dto.PromParamDto;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.item.service.VendorPromotionService;
import lombok.extern.slf4j.Slf4j;

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
	private BackCategoryService backCategoriesService;

	/**
	 * 新增活动信息
	 *
	 * @param promotionModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> create(AdminPromotionAddDto promotionModel) throws ParseException {
		// 获取用户信息
		User user = UserUtil.getUser();

		// 增加活动信息 createOperType : "1" 供应商
		Response<String> response = promotionService.addAdminPromotion("1", promotionModel, user);
		if (response.isSuccess()) {
			return response;
		}
		log.error("failed to query group goods {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 新增/修改活动产品信息（供应商活动） 、 报名（平台活动）
	 *
	 * @param promParamDto
	 * @return
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(PromParamDto promParamDto) {
		// 获取用户信息
		User user = UserUtil.getUser();
		// 报名
		Response<String> result = vendorPromotionService.vendorUpdatePromRange("", promParamDto.getId(),
				promParamDto.getStrPromotionRangeModel(), user);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update promotion ,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

//	/**
//	 * 取得详情
//	 *
//	 * @param id
//	 * @return
//	 */
//	@RequestMapping(value = "/vendorFindById", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public Response<PromotionResultDto> vendorFindById(Integer id) {
//		Response<PromotionResultDto> result = Response.newResponse();
//		try {
//			User user = UserUtil.getUser();
//			if (user != null) {
//				result = vendorPromotionService.findByIdForVendor(id, user);
//			}
//			return result;
//		} catch (Exception e) {
//			log.error("GoodsDetailService.getUserBirth.fail,cause:{}", Throwables.getStackTraceAsString(e));
//			result.setError("GoodsDetailService.getUserBirth.fail");
//			return result;
//		}
//	}

	/**
	 * 根据指定条件取得单品、商品列表
	 *
	 * @param promGoodsParamDto 参数bean
	 * @return
	 */
	@RequestMapping(value = "/findItemListForProm", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<ItemPromDto>> findItemListForProm(PromGoodsParamDto promGoodsParamDto) {

		Response<List<ItemPromDto>> response = new Response<List<ItemPromDto>>();
		try {
			User user = UserUtil.getUser();
			promGoodsParamDto.setVendorId(user.getVendorId());
			response = goodsService.findItemsListForProm(promGoodsParamDto, user);
			return response;
		} catch (Exception e) {
			log.error("VendorPromotion.findItemListForProm.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return response;
		}
	}


	@RequestMapping(value = "/findItemInActivity",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean findItemInActivity(String goodsCode) {
		Response<Boolean> result = promotionService.getStatusByItemCode(goodsCode);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to offAndDelete promotion by id= {},error code:{}", goodsCode, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
