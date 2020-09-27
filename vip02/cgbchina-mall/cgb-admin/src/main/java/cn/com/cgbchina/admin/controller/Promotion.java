package cn.com.cgbchina.admin.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import cn.com.cgbchina.item.model.GroupClassify;
import cn.com.cgbchina.item.service.GroupClassifyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.dto.ItemPromDto;
import cn.com.cgbchina.item.dto.PromGoodsParamDto;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.dto.AdminPromotionAddDto;
import cn.com.cgbchina.item.dto.AdminPromotionUpdateDto;
import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.dto.PromItemDtoStr;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.user.dto.VendorInfoIdDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

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
	@Autowired
	private GoodsService goodsService;
	@Resource
	private VendorService vendorService;
	@Resource
	private PromotionPayWayService promotionPayWayService;
	private final JsonMapper jsonMapper = JsonMapper.JSON_ALWAYS_MAPPER;
	private JavaType listPromotionRange = JsonMapper.JSON_ALWAYS_MAPPER.createCollectionType(List.class,
			PromotionPayWayModel.class);

	@Resource
	private GroupClassifyService groupClassifyService;

	/**
	 * 创建活动（内管、供应商共用）
	 *
	 * @param createOperType 创建人类型(0 内管，1 供应商）
	 * @param adminPromotionAddDto 活动信息
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String create(@Valid AdminPromotionAddDto adminPromotionAddDto, String createOperType,
			BindingResult bindingResult) {
		// 判断校验是否成功
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		Response<String> result = promotionService.addAdminPromotion(createOperType, adminPromotionAddDto,
				UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", adminPromotionAddDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
// TODO：未发现使用者
//	@RequestMapping(value = "/findDetailById", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public AdminPromotionDetailDto findDetailById(Integer promotionId) {
//		Response<AdminPromotionDetailDto> result = promotionService.findDetailById(promotionId);
//		if (result.isSuccess()) {
//
//			return result.getResult();
//		}
//		log.error("failed to find promotion by id= {},error code:{}", promotionId, result.getError());
//		throw new ResponseException(500, messageSources.get(result.getError()));
//	}

	/**
	 * 初审用审核  复审不进
	 * @param id
	 * @param auditLog
	 * @param checkStatus
     * @return
     */
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

	/**
	 * 复审单品
	 * @param id
	 * @param promotionId
	 * @param auditLog
	 * @param checkStatus
	 * @param itemId
     * @return
     */
	@RequestMapping(value = "/audit-doubleCheckItem", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean doubleCheckStatus(Integer id, Integer promotionId, String auditLog, Integer checkStatus,
			String itemId) {
		Response<Boolean> result = promotionService.doubleCheckRange(id, promotionId, auditLog, checkStatus,
				UserUtil.getUser(), itemId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to check promotion by id= {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 复审活动 初审不进
	 * @param promotionId
	 * @param auditLog
	 * @param checkStatus
	 * @param reviewRange
     * @param rate
     * @return
     */
	@RequestMapping(value = "/audit-doubleCheckPromotion", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean doubleCheckPromotion(Integer promotionId, String auditLog, Integer checkStatus, String reviewRange,
			String rate) {
		// 拒绝不进
		if (Integer.valueOf(7).equals(checkStatus)) {
			List<PromotionPayWayModel> rangeModelList = jsonMapper.fromJson(reviewRange, listPromotionRange);
			if (rangeModelList.get(0).getPromType() != 20 && rangeModelList.get(0).getPromType() != 50) {
				for (PromotionPayWayModel payWayModel : rangeModelList) {
					// 活动类型为折扣 要乘以折扣比例
					if (payWayModel.getPromType() == 10) {
						payWayModel.setGoodsPrice(payWayModel.getGoodsPrice().multiply(new BigDecimal(rate)));
					}
				}

				User user = UserUtil.getUser();
				if (user == null) {
					return false;
				}
				promotionPayWayService.createPromotionPayWay(rangeModelList, user);
			}
		}

		Response<Boolean> result = promotionService.doubleCheckPromotion(promotionId, auditLog, checkStatus,
				UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to check promotion by id= {},error code:{}", promotionId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 搜索活动单品范围
	 * @param promotionId
	 * @param checkStatus
	 * @param vendorName
	 * @param itemName
     * @return
     */
	@RequestMapping(value = "/findRanges", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<PromItemDtoStr> findRanges(Integer promotionId, Integer checkStatus, String vendorName,
			String itemName) {
		Response<Pager<PromItemDto>> result = promotionService.findRanges(promotionId, checkStatus, vendorName,
				itemName);
		if (result.isSuccess()) {
			Pager<PromItemDtoStr> pager = new Pager<>();
			pager.setTotal(result.getResult().getTotal());
			// 处理返回数据
			List list = BeanMapper.mapList(result.getResult().getData(), PromItemDtoStr.class);
			pager.setData(list);
			return pager;

		}

		log.error("failed to find range,promotionId={},checkStatus={},vendorName={},itemName={},error code:{}",
				promotionId, checkStatus, vendorName, itemName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据指定条件取得单品、商品列表
	 *
	 * @param promGoodsParamDto 参数bean
	 * @returnGoodsModel
	 */
	@RequestMapping(value = "/look-findItemListForProm", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
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
	 *
	 * @param simpleName
	 * @return
	 */
	@RequestMapping(value = "/add-findVenDtoByName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VendorInfoIdDto> findVenDtoByName(String simpleName, String vendorIds) {
		List<String> vendorIdsList = new ArrayList<>();
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

	@RequestMapping(value = "update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(AdminPromotionUpdateDto adminPromotionUpdateDto) {
		Response<String> result = promotionService.updateAdminPromotion(adminPromotionUpdateDto, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update promotion by {},error code:{}", adminPromotionUpdateDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/offLine", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean offLine(Integer promotionId, Integer checkStatus) {
		Response<Boolean> result = promotionService.updateOffLine(promotionId, checkStatus, UserUtil.getUser());
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to offAndDelete promotion by id= {},error code:{}", promotionId, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
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


	@RequestMapping(value = "/groupClassifyAdd", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean groupClassifyAdd(String name) {
		Response<Boolean> result = groupClassifyService.groupClassifyAdd(name);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to add  group classify by name= {},error code:{}", name, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
	@RequestMapping(value = "/groupClassifyDel", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean groupClassifyDel(Long id) {
		Response<Boolean> result = groupClassifyService.groupClassifDel(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete  group classify by id= {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
	@RequestMapping(value = "/groupClassifyAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<GroupClassify> groupClassifyAll() {
		Response<List<GroupClassify>> result = groupClassifyService.allGroupClassify();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete  group classify ,error code:{}",result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}







}
