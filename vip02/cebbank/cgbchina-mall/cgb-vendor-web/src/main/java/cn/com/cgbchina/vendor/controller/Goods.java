/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ValidateUtil;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/5/30.
 */
@Controller
@RequestMapping("/api/vendor/goods")
@Slf4j
public class Goods {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private MessageSources messageSources;
	@Resource
	private GoodsService goodsService;
	@Resource
	private BackCategoriesService backCategoriesService;
	@Resource
	private BrandService brandService;
	@Resource
	private ProductService productService;
	@Resource
	private ItemService itemService;
	@Resource
	private AuditLoggingService auditLoggingService;
	@Resource
	private GoodsOperateDetailService goodsOperateDetailService;

	private static final String FIND_TYPE = "1";//调用查看方法传入参数
	private static final String SAVE_TYPE_SAVE = "save";//保存、编辑方法前台传入标识
	private static final String SAVE_TYPE_AUDIT = "audit";//保存、编辑方法前台传入标识

	/**
	 * 查询后台类目一级list和品牌list
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/findBackCategoryAndBrands", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public BackCategoryAndBrandsDto findBackCategoryAndBrands(Long id) {
		BackCategoryAndBrandsDto backCategoryAndBrandsDto = new BackCategoryAndBrandsDto();
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<List<BackCategory>> cateResult = backCategoriesService.withoutAttribute(id);
		if (cateResult.isSuccess()) {
			backCategoryAndBrandsDto.setBackCategoryList(cateResult.getResult());
		}
		Response<List<BrandAuthorizeModel>> brandResult = brandService.findBrandListForVendor(user.getVendorId(), "",Contants.BUSINESS_TYPE_YG);
		if (brandResult.isSuccess()) {
			backCategoryAndBrandsDto.setBrandsList(brandResult.getResult());
		}
		return backCategoryAndBrandsDto;
	}

	/**
	 * 后台类目 ：根据父级id查询子级
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/withoutAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BackCategory> withoutAttribute(Long id) {
		Response<List<BackCategory>> result = backCategoriesService.withoutAttribute(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 根据id查询下级list 用于搜索条件中后台类目层级显示
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/toAddGdCat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BackCategory> toAddGoodsCategoryById(Long id) {
		List<BackCategory> backCategoryList = Lists.newArrayList();
		Response<List<BackCategory>> response = backCategoriesService.withoutAttribute(id);
		if (response.isSuccess()) {
			backCategoryList = response.getResult();
			return backCategoryList;
		}
		log.error("failed to add backCategory {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 根据一二三级类目及品牌检索产品列表
	 *
	 * @param productModel
	 * @return
	 */
	@RequestMapping(value = "/findProductList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ProductModel> findProductList(ProductModel productModel) {
		productModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
		Response<List<ProductModel>> productDtoList = productService.findProductList(productModel);
		if (productDtoList.isSuccess()) {
			return productDtoList.getResult();
		}
		log.error("failed to find product {},error code:{}", productModel, productDtoList.getError());
		throw new ResponseException(500, messageSources.get(productDtoList.getError()));
	}

	/**
	 * 根据itemCode查询数据
	 *
	 * @param itemCode
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/{itemCode}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ItemModel findItemDetailByCode(@PathVariable String itemCode) {

		try {
			// 校验
			checkArgument(StringUtils.isNotBlank(itemCode), "code is null");
			ItemModel itemModel = itemService.findItemDetailByCode(itemCode);
			return itemModel;
		} catch (IllegalArgumentException e) {
			log.error("failed to find item:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("failed to find item:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}

	/**
	 * 根据产品编码和三级类目id查找商品属性
	 *
	 * @param productId
	 * @param backCategory3Id
	 * @return
	 */
	@RequestMapping(value = "/findGoodsAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ProductDto findGoodsAttribute(Long productId, Long backCategory3Id) {
		ProductDto productDto = new ProductDto();
		// 如果productId不为空，则根据productId查询产品的属性以及产品信息
		if (productId != null) {
			Response<ProductDto> response = productService.findProductById(productId);
			if (response.isSuccess()) {
				productDto = response.getResult();
			}
		} else {
			// 如果productId为空，则根据三级类目id查询
			ItemsAttributeDto itemsAttributeDto = findAttributeByCateId(backCategory3Id);
			productDto.setItemsAttributeDto(itemsAttributeDto);
		}
		return productDto;
	}


	/**
	 * 根据三级类目id查找属性相关信息
	 * @param backCategoryId
	 * @return
	 */
	private ItemsAttributeDto findAttributeByCateId(Long backCategoryId){
		ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
		Response<AttributeDto> response = backCategoriesService.getAttributeById(backCategoryId);
		if(response.isSuccess()){
			//判断结果是否为空，如果结果为空，则直接返回空dto
			if (response.getResult() == null) {
				itemsAttributeDto.setAttributes(null);
				itemsAttributeDto.setSkus(null);
				return itemsAttributeDto;
			}else {
				//如果结果不为空，则进行处理返回结果
				AttributeDto attributeDto = response.getResult();
				List<ItemAttributeDto> attributes = Lists.newArrayList();
				List<ItemsAttributeSkuDto> skus = Lists.newArrayList();
				if (attributeDto.getAttribute()!=null){
					ItemAttributeDto itemAttributeDto = null;
					//循环基本属性，将相应的key和那么放入skus中
					for (AttributeKey attr : attributeDto.getAttribute()) {
						itemAttributeDto = new ItemAttributeDto();
						itemAttributeDto.setAttributeKey(attr.getId());
						itemAttributeDto.setAttributeName(attr.getName());
						attributes.add(itemAttributeDto);
					}
				}
				if (attributeDto.getSku() != null) {
					ItemsAttributeSkuDto itemsAttributeSkuDto = null;
					// 循环销售属性,将相应的key和name放入skus中
					for (AttributeKey sku : attributeDto.getSku()) {
						itemsAttributeSkuDto = new ItemsAttributeSkuDto();
						itemsAttributeSkuDto.setAttributeValueKey(sku.getId());
						itemsAttributeSkuDto.setAttributeValueName(sku.getName());
						skus.add(itemsAttributeSkuDto);
					}
				}
				itemsAttributeDto.setAttributes(attributes);
				itemsAttributeDto.setSkus(skus);
			}
		}
		return itemsAttributeDto;
	}
	/**
	 * 推荐单品列表取得
	 *
	 * @param searchKey
	 * @return
	 */
	@RequestMapping(value = "/findRecommendationItemList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ItemDto> findRecommendationItemList(String searchKey) {
		Response<List<ItemDto>> itemDtoList = itemService.findItemListByCodeOrName(searchKey);
		if (itemDtoList.isSuccess()) {
			return itemDtoList.getResult();
		}
		log.error("failed to find itemList {},error code:{}", searchKey, itemDtoList.getError());
		throw new ResponseException(500, messageSources.get(itemDtoList.getError()));
	}

	/**
	 * 保存商品（新增）
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/addGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String addGoods(@RequestParam("goods") @NotNull String json, String type) {
		if(Strings.isNullOrEmpty(type)){
			return "error";
		}
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		if(goodsDetailDto!=null && Strings.isNullOrEmpty(goodsDetailDto.getName())){
			return "error";
		}
		String s = ValidateUtil.validateModel(goodsDetailDto);
		if(!Strings.isNullOrEmpty(s)){
			return "error";
		}
		// 创建类型(供应商)
		goodsDetailDto.setCreateType(Contants.CREATE_TYPE_1);
		// 审核状态
		if (SAVE_TYPE_SAVE.equals(type)) {
			// 编辑中
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_00);
		} else if (SAVE_TYPE_AUDIT.equals(type)) {
			// 待初审
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
		}
		// 获取用户信息
		User user = UserUtil.getUser();
		goodsDetailDto.setVendorId(user.getVendorId());
		Response<Boolean> result = goodsService.createGoods(goodsDetailDto, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to save goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 编辑商品
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/editGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editGoods(@RequestParam("goods") String json, String type) {
		// 校验
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		// 商品编码设定
		goodsDetailDto.setCode(goodsDetailDto.getGoodsCode());
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsService.updataGoodsDetail(goodsDetailDto, user);
		if (result.isSuccess()) {
			GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
			GoodsModel goodsModel = goodsService.findById(goodsDetailDto.getGoodsCode()).getResult();
			BeanMapper.copy(goodsModel,goodsOperateDetailModel);
			goodsOperateDetailModel.setGoodCode(goodsModel.getCode());
			goodsOperateDetailModel.setGoodName(goodsModel.getName());
			goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_2);
			goodsOperateDetailModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
			goodsOperateDetailModel.setCreateOper(user.getName());
			Response<Boolean> operateResult = goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
			if(operateResult.isSuccess()){
				return "ok";
			}
		}
		log.error("failed to edit goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据商品编码查找商品信息
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/findGoodsByGoodsCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsDetailDto findGoodsByGoodsCode(String goodsCode) {
		GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
		Response<GoodsDetailDto> result = goodsService.findDetailByType(FIND_TYPE, goodsCode);
		if (result.isSuccess()) {
			goodsDetailDto = result.getResult();
			if (!Strings.isNullOrEmpty(goodsDetailDto.getAttribute())) {
				ItemsAttributeDto goodsAttributeDto = jsonMapper.fromJson(goodsDetailDto.getAttribute(),
						ItemsAttributeDto.class);
				goodsDetailDto.setGoodsAttr(goodsAttributeDto);
			}
			return goodsDetailDto;
		}
		log.error("failed to find item {},error code:{}", goodsDetailDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 修改库存
	 *
	 * @param json
	 * @return
	 */
	@RequestMapping(value = "/editItemStock", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editItemStock(@RequestParam("goods") @NotNull String json) {
		Response<Integer> response = new Response<Integer>();
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		Boolean updateFlag = false;
		User user = UserUtil.getUser();
		List<ItemModel> itemModelList = goodsDetailDto.getItemList();
		for (ItemModel itemModel : itemModelList) {
			response = goodsService.updateItemDetail(itemModel);
		}
		if (response.isSuccess()) {
			GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
			GoodsModel goodsModel = goodsService.findById(goodsDetailDto.getGoodsCode()).getResult();
			BeanMapper.copy(goodsModel,goodsOperateDetailModel);
			goodsOperateDetailModel.setGoodCode(goodsModel.getCode());
			goodsOperateDetailModel.setGoodName(goodsModel.getName());
			goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_4);
			goodsOperateDetailModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
			goodsOperateDetailModel.setCreateOper(user.getName());
			Response<Boolean> operateResult = goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
			if(operateResult.isSuccess()){
				return "ok";
			}
		}
		log.error("failed to find item {},error code:{}", goodsDetailDto, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 修改商品价格
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/editItemPrice", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editItemPrice(@RequestParam("goods") @NotNull String json) {
		Response<Boolean> result = new Response<>();
		GoodsDetailDto newDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		List<ItemModel> newItemList = newDto.getItemList();
		List<ItemModel> resultList = Lists.newArrayList();
		User user = UserUtil.getUser();
		// 修改价格需要审核
		// 根据code查询商品信息
		Response<GoodsDetailDto> response = goodsService.findDetailByType(FIND_TYPE, newDto.getGoodsCode());
		if (response.isSuccess()) {
			GoodsDetailDto oldDto = response.getResult();
			List<ItemDto> oldItemList = oldDto.getItemDtoList();
			for (ItemModel newItemModel : newItemList) {
				for (ItemDto oldItemdto : oldItemList) {
					if (newItemModel.getCode().equals(oldItemdto.getItemModel().getCode())) {
						oldItemdto.getItemModel().setMarketPrice(newItemModel.getMarketPrice());
						oldItemdto.getItemModel().setPrice(newItemModel.getPrice());
						oldItemdto.getItemModel().setFixPoint(newItemModel.getFixPoint());
						oldItemdto.getItemModel().setCash(newItemModel.getCash());
						resultList.add(oldItemdto.getItemModel());
					}
				}
			}
			oldDto.setItemList(resultList);
			oldDto.setGoodsCode(newDto.getGoodsCode());
			oldDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_04);
			result = goodsService.updataGoodsDetail(oldDto, user);
			if (result.isSuccess()) {
				GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
				BeanMapper.copy(oldDto,goodsOperateDetailModel);
				goodsOperateDetailModel.setGoodName(oldDto.getName());
				goodsOperateDetailModel.setGoodCode(oldDto.getCode());
				goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_3);
				goodsOperateDetailModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
				goodsOperateDetailModel.setCreateOper(user.getName());
				Response<Boolean> operateResult = goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
				if(operateResult.isSuccess()){
					return "ok";
				}
			}
		}
		log.error("failed to update item {},error code:{}", json, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}


	/**
	 * 申请下架
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/shelvesApply", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> shelvesApply(GoodsModel goodsmodel) {
		// 获取用户
		User user = UserUtil.getUser();
		Response<Boolean> result = new Response<>();
		// 调用接口
		AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
		auditLoggingModel.setOuterId(goodsmodel.getCode());
		auditLoggingModel.setPresenter(user.getName());
		auditLoggingModel.setAuditor(user.getName());
		auditLoggingModel.setAuditorMemo(goodsmodel.getIntroduction());
		auditLoggingModel.setBusinessType(Contants.SQXJ);
		auditLoggingModel.setCreateOper(user.getName());
		auditLoggingModel.setModifyOper(user.getName());

		Response<Integer> flag = auditLoggingService.create(auditLoggingModel);

		if (flag.isSuccess()) {
			goodsmodel.setModifyOper(user.getName());
			goodsmodel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_05);
			goodsmodel.setIntroduction(null);
			result = goodsService.shelvesApply(goodsmodel);
			if (result.isSuccess()) {
				GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
				GoodsModel goodsModel = goodsService.findById(goodsmodel.getCode()).getResult();
				BeanMapper.copy(goodsModel,goodsOperateDetailModel);
				goodsOperateDetailModel.setGoodCode(goodsModel.getCode());
				goodsOperateDetailModel.setGoodName(goodsModel.getName());
				goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_5);
				goodsOperateDetailModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
				goodsOperateDetailModel.setCreateOper(user.getName());
				Response<Boolean> operateResult = goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
				if(operateResult.isSuccess()){
					return result;
				}
			}
		}
		log.error("update.error, {},error code:{}", goodsmodel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据品牌名称模糊查询品牌list
	 * 
	 * @param brandName
	 * @return
	 */
	@RequestMapping(value = "/findBrandList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BrandAuthorizeModel> findBrandList(String brandName) {
		// 校验
		// 获取供应商id
		User user = UserUtil.getUser();
		Response<List<BrandAuthorizeModel>> result = brandService.findBrandListForVendor(user.getVendorId(), brandName,Contants.BUSINESS_TYPE_YG);
		List<BrandAuthorizeModel> brandList = Lists.newArrayList();
		if (result.isSuccess()) {
			brandList = result.getResult();
			return brandList;
		}
		log.error("failed to find {},error code:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 商品管理列表页提交审核按钮事件
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/submitGoodsToApprove", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String submitGoodsToApprove(String goodsCode) {
		User user = UserUtil.getUser();
		GoodsModel goodsModel = new GoodsModel();
		Response<GoodsDetailDto> response = goodsService.findDetailByType("1", goodsCode);
		if (response.isSuccess()) {
			GoodsDetailDto goodsDetailDto = response.getResult();
			List<ItemDto> itemDtoList = goodsDetailDto.getItemDtoList();
			List<ItemModel> resultList = Lists.newArrayList();
			for (ItemDto itemDto : itemDtoList) {
				resultList.add(itemDto.getItemModel());
			}
			goodsDetailDto.setItemList(resultList);
			String goodsDetail = jsonMapper.toJson(goodsDetailDto);
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
			goodsDetailDto.setCode(goodsCode);
			goodsDetailDto.setApproveDifferent(goodsDetail);
			Response<Boolean> result = goodsService.submitGoodsToApprove(goodsDetailDto, user);
			if (result.isSuccess()) {
				return "ok";
			}
		}
		log.error("failed to update goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 校验商品名称 如果产品id为空的情况下，需要先校验商品名称是否与产品表中的name有相同
	 * 
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/checkGoodsName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkGoodsName(String name, Long backCategory3Id) {
		Response<Boolean> result = productService.findByName(name, null, backCategory3Id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", name, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
