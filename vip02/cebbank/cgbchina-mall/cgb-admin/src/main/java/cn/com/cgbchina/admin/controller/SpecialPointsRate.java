package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.SpecialPointsRateDto;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.SpecialPointsRateService;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import static com.google.common.base.Preconditions.checkArgument;

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
	private BackCategoriesService backCategoriesService;

	/**
	 * 特殊积分倍率删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable Long id) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			SpecialPointScaleModel specialPointScaleModel = new SpecialPointScaleModel();
			specialPointScaleModel.setId(Long.valueOf(id));
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
	@RequestMapping(value = "/deteleAllSpecialPoint", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deteleAllSpecialPoint(@RequestParam(value = "array[]") Long[] array) {
		Response<Integer> response = new Response<Integer>();
		Boolean dateleFlag = false;
		/*
		 * //从登录信息中获取用户id和用户名称并插入到model中 User user = UserUtil.getUser(); String modifyOper = user.getName();
		 * specialPointScaleModel.setModifyOper(modifyOper);
		 */
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

	@RequestMapping(value = "/findClassifications", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<SpecialPointsRateDto> findClassifications(String type, String searchKey) {
		Response<SpecialPointsRateDto> listResponse = new Response<SpecialPointsRateDto>();
		SpecialPointsRateDto specialPointsRateDto = new SpecialPointsRateDto();
		// User user = UserUtil.getUser();//取ID备用
		// 获取全部供应商
		if ("0".equals(type)) {
			Response<List<VendorInfoModel>> responseVendor = vendorService.findAllVendor(searchKey);
			List<VendorInfoModel> vendorInfoModelList = responseVendor.getResult();
			specialPointsRateDto.setVendorInfoModelList(vendorInfoModelList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取全部品牌
		if ("1".equals(type)) {
			Response<List<GoodsBrandModel>> responseBrand = brandService.findAllBrandsSpecial(searchKey);
			List<GoodsBrandModel> goodsBrandModelList = responseBrand.getResult();
			specialPointsRateDto.setGoodsBrandModelList(goodsBrandModelList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取类目
		if ("2".equals(type)) {
			Response<List<BackCategory>> responseBackCategory = backCategoriesService.allSimpleData();
			List<BackCategory> backCategoryList = responseBackCategory.getResult();
			specialPointsRateDto.setBackCategoryList(backCategoryList);
			listResponse.setResult(specialPointsRateDto);
			return listResponse;
		}
		// 获取全部商品
		if ("3".equals(type)) {
			Response<List<GoodsModel>> responseGoods = goodsService.findAllGoods(searchKey);
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
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> result = null;
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
	@RequestMapping(value = "/specialPointsRateUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			// 更新
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
