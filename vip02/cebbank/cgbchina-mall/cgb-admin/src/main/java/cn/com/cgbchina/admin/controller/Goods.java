package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.common.utils.ValidateUtil;
import org.antlr.v4.runtime.misc.NotNull;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.util.IOUtils;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 陈乐 on 2016/5/19.
 */
@Controller
@RequestMapping("/api/admin/goods")
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
	private MailStatesService mailStatesService;
	@Resource
	private GoodsImportService goodsImportService;
	@Resource
	private VendorService vendorService;

	@Value("#{app.fileUploadPath}")
	private String rootFilePath;
	private static final String CHANNEL_MALL = "channelMall";//前台传入广发商城渠道标识
	private static final String CHANNEL_CC = "channelCc";//前台传CC渠道标识
	private static final String CHANNEL_MALL_WX = "channelMallWx";//前台传入广发商城微信渠道标识
	private static final String CHANNEL_PHONE = "channelPhone";//前台传入手机商城渠道标识
	private static final String CHANNEL_CREDIT_WX = "channelCreditWx";//前台传入信用卡中心微信渠道标识
	private static final String CHANNEL_APP = "channelApp";//前台传入APP渠道标识
	private static final String CHANNEL_SMS = "channelSms";//前台传入短信渠道标识
	private static final String FIND_TYPE = "1";//调用查看方法传入参数
	private static final String SAVE_TYPE_SAVE = "save";//保存、编辑方法前台传入标识
	private static final String SAVE_TYPE_AUDIT = "audit";//保存、编辑方法前台传入标识

	/**
	 * 修改商品各渠道上下架信息
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/updateGdShelf", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String updateGdShelf(String channel, String code, String state) {
		Response<Integer> response = new Response<Integer>();
		GoodsModel goodsModel = new GoodsModel();
		goodsModel.setCode(code);
		// 根据前台传入的channel字段判断是哪个渠道
		//广发商城渠道
		if (CHANNEL_MALL.equals(channel)) {
			goodsModel.setChannelMall(state);
			//上架状态更新上架时间
			if (Contants.CHANNEL_MALL_02.equals(state)) {
				goodsModel.setOnShelfMallDate(new Date());
			} else {
				//下架状态更新下架时间
				goodsModel.setOffShelfMallDate(new Date());
			}
		} else if (CHANNEL_CC.equals(channel)) {
			//CC渠道
			goodsModel.setChannelCc(state);
			if (Contants.CHANNEL_CC_02.equals(state)) {
				goodsModel.setOnShelfCcDate(new Date());
			} else {
				goodsModel.setOffShelfCcDate(new Date());
			}
		} else if (CHANNEL_MALL_WX.equals(channel)) {
			//广发商城微信渠道
			goodsModel.setChannelMallWx(state);
			if (Contants.CHANNEL_MALL_WX_02.equals(state)) {
				goodsModel.setOnShelfCcDate(new Date());
			} else {
				goodsModel.setOffShelfMallWxDate(new Date());
			}
		} else if (CHANNEL_PHONE.equals(channel)) {
			//手机商城渠道
			goodsModel.setChannelPhone(state);
			if (Contants.CHANNEL_PHONE_02.equals(state)) {
				goodsModel.setOnShelfPhoneDate(new Date());
			} else {
				goodsModel.setOffShelfPhoneDate(new Date());
			}
		} else if (CHANNEL_CREDIT_WX.equals(channel)) {
			//卡中心微信渠道
			goodsModel.setChannelCreditWx(state);
			if (Contants.CHANNEL_CREDIT_WX_02.equals(state)) {
				goodsModel.setOnShelfCreditWxDate(new Date());
			} else {
				goodsModel.setOffShelfCreditWxDate(new Date());
			}
		} else if (CHANNEL_APP.equals(channel)) {
			//app渠道
			goodsModel.setChannelApp(state);
			if (Contants.CHANNEL_APP_02.equals(state)) {
				goodsModel.setOnShelfAppDate(new Date());
			} else {
				goodsModel.setOffShelfAppDate(new Date());
			}
		} else if (CHANNEL_SMS.equals(channel)) {
			//短信渠道
			goodsModel.setChannelSms(state);
			if (Contants.CHANNEL_SMS_02.equals(state)) {
				goodsModel.setOnShelfSmsDate(new Date());
			} else {
				goodsModel.setOffShelfSmsDate(new Date());
			}
		}
		response = goodsService.updateGoodsShelf(goodsModel);
		if (response.isSuccess()) {
			return "ok";
		}
		log.error("failed to find item {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
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
		//调用查找商品信息方法
		Response<GoodsDetailDto> result = goodsService.findDetailByType(FIND_TYPE, goodsCode);
		if (result.isSuccess()) {
			goodsDetailDto = result.getResult();
			if (!Strings.isNullOrEmpty(goodsDetailDto.getAttribute())) {
				//将attribute字段转为相应dto
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
		List<ItemModel> itemModelList = goodsDetailDto.getItemList();
		for (ItemModel itemModel : itemModelList) {
			response = goodsService.updateItemDetail(itemModel);
		}
		if (response.isSuccess()) {
			return "ok";
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
				return "ok";
			}
		}
		log.error("failed to update item {},error code:{}", json, result.getError());
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
	 * 查询后台类目一级list和品牌list
	 *
	 * @param categoryId
	 * @param vendorId
	 * @return
	 */
	@RequestMapping(value = "/findBackCategoryAndBrands", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public BackCategoryAndBrandsDto findBackCategoryAndBrands(Long categoryId, String vendorId) {
		BackCategoryAndBrandsDto backCategoryAndBrandsDto = new BackCategoryAndBrandsDto();
		Response<List<BackCategory>> cateResult = backCategoriesService.withoutAttribute(categoryId);
		if (cateResult.isSuccess()) {
			backCategoryAndBrandsDto.setBackCategoryList(cateResult.getResult());
		}
		Response<List<BrandAuthorizeModel>> brandResult = brandService.findBrandListForVendor(vendorId, "",
				Contants.BUSINESS_TYPE_YG);
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
	 * 
	 * @param backCategoryId
	 * @return
	 */
	private ItemsAttributeDto findAttributeByCateId(Long backCategoryId) {
		ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
		Response<AttributeDto> response = backCategoriesService.getAttributeById(backCategoryId);
		if (response.isSuccess()) {
			// 判断结果是否为空，如果结果为空，则直接返回空dto
			if (response.getResult() == null) {
				itemsAttributeDto.setAttributes(null);
				itemsAttributeDto.setSkus(null);
				return itemsAttributeDto;
			} else {
				// 如果结果不为空，则进行处理返回结果
				AttributeDto attributeDto = response.getResult();
				List<ItemAttributeDto> attributes = Lists.newArrayList();
				List<ItemsAttributeSkuDto> skus = Lists.newArrayList();
				if (attributeDto.getAttribute() != null) {
					ItemAttributeDto itemAttributeDto = null;
					// 循环基本属性，将相应的key和那么放入skus中
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
	 * 保存商品（新增）
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/addGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String addGoods(@RequestParam("goods") String json, String type) {
		// 校验
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		// 创建类型(平台创建)
		goodsDetailDto.setCreateType(Contants.CERATE_TYPE_ADMIN_0);
		// 审核状态
		if ("save".equals(type)) {
			// 编辑中
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_00);
		} else if ("audit".equals(type)) {
			// 待初审
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
		}
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsService.createGoods(goodsDetailDto, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to save goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
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
	 * 编辑商品
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/editGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editGoods(@RequestParam("goods") @NotNull String json, String type) {
		// 校验
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
		// 审核状态
		if (SAVE_TYPE_SAVE.equals(type)) {
			// 编辑中
			goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_00);
		} else if (SAVE_TYPE_AUDIT.equals(type)) {
			if (Contants.GOODS_APPROVE_STATUS_00.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为编辑中时，设定为待初审
				goodsDetailDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
			}
		}
		// 商品编码设定
		goodsDetailDto.setCode(goodsDetailDto.getGoodsCode());
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsService.updataGoodsDetail(goodsDetailDto, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to edit goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 审核商品
	 * 
	 * @param goodsCode
	 * @param approveType
	 * @param approveResult
	 * @param approveMemo
	 * @return
	 */
	@RequestMapping(value = "/examGoods", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String examGoods(String goodsCode, String approveType, String approveResult, String approveMemo) {
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsService.examGoods(goodsCode, approveType, approveResult, approveMemo, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to edit goods {},errco code:{}");
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
	 * 批量更新状态
	 *
	 * @param goodsBatchDtoList
	 * @return
	 */
	@RequestMapping(value = "/updateAllGoodsStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> updateAllGoodsStatus(@RequestBody GoodsBatchDto[] goodsBatchDtoList) {
		User user = UserUtil.getUser();
		for (GoodsBatchDto goodsBatchDto : goodsBatchDtoList) {
			goodsBatchDto.setUser(user);
		}
		Response<Integer> updateStatus = goodsService.updateAllGoodsStatus(Arrays.asList(goodsBatchDtoList));

		if (updateStatus.isSuccess()) {
			return updateStatus;
		}
		log.error("failed to find product {},error code:{}", goodsBatchDtoList, updateStatus.getError());
		throw new ResponseException(500, messageSources.get(updateStatus.getError()));
	}

	/**
	 * 根据品牌名称模糊查询品牌list
	 *
	 * @param brandName
	 * @return
	 */
	@RequestMapping(value = "/findBrandList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BrandAuthorizeModel> findBrandList(String vendorId, String brandName) {
		// 获取供应商id
		Response<List<BrandAuthorizeModel>> result = brandService.findBrandListForVendor(vendorId, brandName,
				Contants.BUSINESS_TYPE_YG);
		List<BrandAuthorizeModel> brandList = Lists.newArrayList();
		if (result.isSuccess()) {
			brandList = result.getResult();
			return brandList;
		}
		log.error("failed to find {},error code:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
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

	/**
	 * 根据供应商id查询邮购分期类别码
	 *
	 * @param vendorId
	 * @return
	 */
	@RequestMapping(value = "/findMailStagesAndPeriod", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public MailStagesAndInstallmentDto findMailStagesAndPeriod(String vendorId) {
		MailStagesAndInstallmentDto mailStagesAndInstallmentDto = new MailStagesAndInstallmentDto();
		Response<List<MailStagesModel>> mailResult = mailStatesService.findMailStagesListByVendorId(vendorId);
		if (mailResult.isSuccess()) {
			mailStagesAndInstallmentDto.setMailStagesModelList(mailResult.getResult());
		}
		Response<List<TblVendorRatioModel>> periodResult = vendorService.findRaditListByVendorId(vendorId);
		if (periodResult.isSuccess()) {
			List<TblVendorRatioModel> list = periodResult.getResult();
			List<Integer> periodList = Lists.newArrayList();
			for (TblVendorRatioModel tblVendorRatioModel : list) {
				periodList.add(tblVendorRatioModel.getPeriod());
			}
			mailStagesAndInstallmentDto.setPeriodList(periodList);
		}
		return mailStagesAndInstallmentDto;
	}

	/**
	 * 商品导入
	 * 
	 * @param files
	 * @param httpServletResponse
	 */
	@RequestMapping(value = "/importGoodsData", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void importGoodsData(MultipartFile files, HttpServletResponse httpServletResponse) {
		FileInputStream fileInputStream = null;
		User user = UserUtil.getUser();
		try {
			String fileName = "商品导入结果.xlsx";// 输出给前台显示的文件名
			Map<String, Object> dataBeans = new HashMap<String, Object>();
			List<GoodsImportDto> details = new ArrayList<GoodsImportDto>();
			dataBeans.put("items", details);
			fileInputStream = new FileInputStream(rootFilePath + "/config/goods.xml");
			ExcelUtil.importExcelToData(dataBeans, files.getInputStream(), fileInputStream);
			List<GoodsImportDto>goodsImportList = Lists.newArrayList();
			for(GoodsImportDto goodsImportDto:details){
				goodsImportDto.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
				goodsImportList.add(goodsImportDto);
			}
			Response<List<GoodsImportDto>> response = goodsImportService.importGoodsData(goodsImportList, user);
			Map<String, Object> map = Maps.newHashMap();
			map.put("goods", response.getResult());
			ExportUtils.exportTemplate(httpServletResponse, fileName, rootFilePath + "/template/goodsImport.xlsx", map);
		} catch (Exception e) {
			log.error("import.goods.data.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("import.goods.data.error"));
		} finally {
			if (fileInputStream != null) {
				try {
					fileInputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	/**
	 * 下载导入模板
	 * 
	 * @param response
	 */
	@RequestMapping(value = "/exportTemplateExcel")
	public void exportTemplateExcel(HttpServletResponse response) {
		String fileName = "商品导入模板.xlsx";// 输出给前台显示的文件名
		String filePath = rootFilePath + "/template/goodsImport.xlsx";// 文件的绝对路径
		Map<String, Object> context = Maps.newHashMap();
		context.put("goods", Collections.emptyList());
		try {
			ExportUtils.exportTemplate(response, fileName, filePath, context);
		} catch (Exception e) {
			// 此处不处理异常，这些方法不会抛异常，抛出的运行时异常框架会将页面跳走
			log.error("fail to export excel template");
			throw new ResponseException(500, messageSources.get("export.template.excel.error"));
		}

	}

	/**
	 * 导出商品数据
	 * 
	 * @param goodsDetailDto
	 * @return
	 */
	@RequestMapping(value = "/exportGoodsData")
	public Response<String> exportGoodsData(GoodsDetailDto goodsDetailDto, HttpServletResponse response) {
		Response<String> result = new Response<>();
		// 根据goodsmodel查找结果list
		String temp = "商品导出" + LocalDate.now().toString() + ".xlsx";

		try (FileInputStream fileInputStream = new FileInputStream(rootFilePath + "/template/goodsExport.xlsx");) {
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + new String(temp.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
			Response<List<GoodsExportDto>> listResponse = goodsImportService.exportGoodsData(goodsDetailDto);
			if (listResponse.isSuccess()) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("goods", listResponse.getResult());
				Workbook workbook = WorkbookFactory.create(fileInputStream);
				ExportUtils.exportTemplate(workbook, map);
				workbook.write(response.getOutputStream());
				response.getOutputStream().flush();
			} else {
				HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
				HSSFSheet sheet = hssfWorkbook.createSheet();
				HSSFRow row = sheet.createRow(0);
				HSSFCell cell = row.createCell(0);
				cell.setCellValue("导出服务异常");
				hssfWorkbook.write(response.getOutputStream());

			}
		} catch (Exception e) {
			log.error("fail to export goods data");
			HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
			HSSFSheet sheet = hssfWorkbook.createSheet();
			HSSFRow row = sheet.createRow(0);
			HSSFCell cell = row.createCell(0);
			cell.setCellValue("导出服务异常");
			try {
				hssfWorkbook.write(response.getOutputStream());
			} catch (IOException e1) {
				e1.printStackTrace();
			}

		} finally {
			try {
				if (response.getOutputStream() != null) {
					try {
						response.getOutputStream().close();
					} catch (IOException e) {
						log.error("fail to close fileOutStream exportGoodsData", e);
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	/**
	 * 下载临时文件
	 *
	 * @param relativePath
	 */
	@RequestMapping(value = "/downloadTemp")
	public void downLoad(HttpServletResponse response, String relativePath, Boolean isDownLoad) {
		OutputStream outputStream = null;
		if (!isDownLoad) {
			// 没点击下载 那么删除临时文件 认为此次导出用户不想看了
			return;
		}
		try (FileInputStream fileInputStream = new FileInputStream(rootFilePath + relativePath)) {
			String temp = "商品导出" + LocalDate.now().toString()+".xlsx";
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + new String(temp.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
			outputStream = response.getOutputStream();
			IOUtils.copy(fileInputStream, outputStream);
			outputStream.flush();

		} catch (Exception e) {
			log.error("fail to down load temp file goods", e);
			throw new ResponseException(500, messageSources.get("export.file.error"));
		} finally {
			if (outputStream != null) {
				try {
					outputStream.close();
				} catch (IOException e) {
					log.error("fail to close fileOutStream downloadTemp", e);
				}
			}

			File file = new File(rootFilePath + relativePath);
			boolean delete = file.delete();
			if (!delete) {
				log.error("fail to delete temp excel file on goods");
			}
		}

	}

}
