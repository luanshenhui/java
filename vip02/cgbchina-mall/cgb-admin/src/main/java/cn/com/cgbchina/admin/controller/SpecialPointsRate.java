package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.SpecialPointsRateDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.SpecialPointsRateService;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.BackCategory;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 2016/05/31
 */
@RequestMapping("/api/admin/specialPointsRate")
@Controller
@Slf4j
public class SpecialPointsRate {
	@Resource
	private SpecialPointsRateService specialPointsRateService;
	@Resource
	private MessageSources messageSources;
	@Resource
	private VendorService vendorService;
	@Resource
	private BrandService brandService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private BackCategoryService backCategoryService;

	/**
	 * 特殊积分倍率删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable Long id) {
		Response<Boolean> result = Response.newResponse();
		try {
			SpecialPointScaleModel specialPointScaleModel = new SpecialPointScaleModel();
			specialPointScaleModel.setId(id);
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String modifyOper = user.getName();
			specialPointScaleModel.setModifyOper(modifyOper);
			// defaultSearchModel.setDelFlag("1");
			result = specialPointsRateService.delete(specialPointScaleModel);
		} catch (IllegalArgumentException e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 批量删除
	 *
	 * @param array
	 * @return
	 */
	@RequestMapping(value = "/deleteAllSpecialPoint", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deteleAllSpecialPoint(@RequestParam(value = "array[]") Long[] array) {
		Response<Integer> response = Response.newResponse();
		Boolean dateleFlag = false;
		List<Long> deteleAllSpecial = Lists.newArrayList();
		// 循环取出id
		for (Long id : array) {
			deteleAllSpecial.add(id);
		}
		// 调用批量删除方法
		response = specialPointsRateService.updateAllRejectGoods(deteleAllSpecial);
		if (response.isSuccess()) {
			dateleFlag = true;
			return dateleFlag;
		}
		log.error("failed to update all {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	@RequestMapping(value = "/add-findClassifications", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<SpecialPointsRateDto> findClassifications(String type, String searchKey) {
		Response<SpecialPointsRateDto> listResponse = new Response<SpecialPointsRateDto>();
		SpecialPointsRateDto specialPointsRateDto = new SpecialPointsRateDto();
		// 获取全部供应商
		if ("0".equals(type)) {
			Response<List<VendorInfoModel>> responseVendor = vendorService.findAllVendor(searchKey);
			if(!responseVendor.isSuccess()){
				log.error("Response.error,error code: {}", responseVendor.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(responseVendor.getError()));
			}
			List<VendorInfoModel> vendorInfoModelList = responseVendor.getResult();
			specialPointsRateDto.setVendorInfoModelList(vendorInfoModelList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取全部品牌
		if ("1".equals(type)) {
			Response<List<GoodsBrandModel>> responseBrand = brandService.findAllBrandsSpecial(searchKey);
			if(!responseBrand.isSuccess()){
				log.error("Response.error,error code: {}", responseBrand.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(responseBrand.getError()));
			}
			List<GoodsBrandModel> goodsBrandModelList = responseBrand.getResult();
			specialPointsRateDto.setGoodsBrandModelList(goodsBrandModelList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取类目
		if ("2".equals(type)) {
			Response<List<RichCategory>> responseBackCategory = backCategoryService.getTreeOf(0);
			if(!responseBackCategory.isSuccess()){
				log.error("Response.error,error code: {}", responseBackCategory.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(responseBackCategory.getError()));
			}
			List<RichCategory> categoryList = responseBackCategory.getResult();
			specialPointsRateDto.setBackCategoryList(categoryList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取全部商品
		if ("3".equals(type)) {
			Response<List<GoodsModel>> responseGoods = goodsService.findAllGoods(searchKey);
			if(!responseGoods.isSuccess()){
				log.error("Response.error,error code: {}", responseGoods.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(responseGoods.getError()));
			}
			List<GoodsModel> goodsModelList = responseGoods.getResult();
			specialPointsRateDto.setGoodsModelList(goodsModelList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		log.error("failed to update all {},errco code:{}");
		throw new ResponseException(500, messageSources.get(listResponse.getError()));
	}

	/**
	 * 特殊积分倍率新增
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> result = Response.newResponse();
		try {
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String creatOper = user.getName();
			specialPointScaleModel.setCreateOper(creatOper);
			result = specialPointsRateService.create(specialPointScaleModel);
		} catch (IllegalArgumentException e) {
			log.error("insert.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));

		} catch (Exception e) {
			log.error("insert.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		}
		return result;
	}

	/**
	 * 特殊积分倍率更新
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> result = Response.newResponse();
		try {
			// 从登录信息中获取用户id和用户名称并插入到model中
			User user = UserUtil.getUser();
			String modifyOper = user.getName();
			specialPointScaleModel.setModifyOper(modifyOper);
			result = specialPointsRateService.update(specialPointScaleModel);
		} catch (IllegalArgumentException e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		}
		return result;

	}

}
