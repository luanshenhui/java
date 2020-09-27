/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/24.
 */

@Service
@Slf4j
public class GoodsImportServiceImpl implements GoodsImportService {

	// 定义常量
	private final static String GOODS_FLAG_Y = "Y";// 商品标志，用于区分是否是一个新的商品
	private final static String GOODS_FLAG_N = "N";// 商品标志，用于区分是否是一个新的商品
	private final static String GOODS_TYPE_O2O = "O2O商品";// 商品类型为O2O商品
	private final static String GOODS_TYPE_TRUE = "实物商品";// 商品类型为实物商品
	private final static String IS_INNER_Y = "是";// 是否内宣商品--是
	private final static String IS_INNER_N = "否";// 是否内宣商品--否
	private final static String SUCCESS_FLAG_Y = "成功";
	private final static String SUCCESS_FLAG_N = "失败";
	private final Pattern numPattern = Pattern.compile("[0-9]*");
	private final Pattern intPattern = Pattern.compile("^[1-9]\\d*$");
	private final Pattern cardsPattern = Pattern.compile("^WWWW|^(\\d{4}\\,)*?\\d{4}$");
	private final Pattern pricePattern = Pattern.compile("^(([1-9][0-9]*)|(([0]\\.\\d{1,2}|[1-9][0-9]*\\.\\d{1,2})))$");
	private static JsonMapper jsonMapper = JsonMapper.JSON_ALWAYS_MAPPER;
	@Resource
	private GoodsService goodsService;
	@Resource
	private ProductService productService;
	@Resource
	private BrandService brandService;
	@Resource
	private BackCategoriesService backCategoriesService;
	@Resource
	private AttributeValueService attributeValueService;
	@Resource
	private VendorService vendorService;
	@Resource
	private GoodsBrandDao goodsBrandDao;
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private ItemService itemService;

	@Override
	public Response<List<GoodsImportDto>> importGoodsData(List<GoodsImportDto> details, User user) {
		Response<List<GoodsImportDto>> result = new Response<>();
		try {
			// 1.1定义返回结果集
			List<GoodsImportDto> resultList = Lists.newArrayList();
			GoodsImportDto resultDto = null;
			// 1.2定义商品编码
			String goodsCode = "";
			// 2.循环Excel表中数据
			GoodsImportDto goodsImportDto = new GoodsImportDto();
			GoodsItemDto goodsItemDto = null;// 新增时传入goodsItemDto
			ItemsAttributeDto goodsAttr = null;// 商品属性--商品表中attribute字段
			ItemsAttributeDto itemsAttr = null;// 单品属性--单品表中attribute字段
			GoodsImportDto oldGoodsImportDto = new GoodsImportDto();
			for (int i = 0; i < details.size(); i++) {
				goodsAttr = new ItemsAttributeDto();
				goodsImportDto = details.get(i);
				resultDto = new GoodsImportDto();
				goodsItemDto = new GoodsItemDto();
				List<ItemAttributeDto> goodsAttributes = Lists.newArrayList();// 商品属性--基本属性
				List<ItemsAttributeSkuDto> goodsSkus = Lists.newArrayList();// 商品属性--销售属性
				BeanMapper.copy(goodsImportDto, resultDto);
				// 校验商品标志
				if (Strings.isNullOrEmpty(goodsImportDto.getGoodsFlag())) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("商品标志不能为空");
					resultList.add(resultDto);
					continue;
				}
				if (!GOODS_FLAG_Y.equals(goodsImportDto.getGoodsFlag())
						&& !GOODS_FLAG_N.equals(goodsImportDto.getGoodsFlag())) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("商品标志填写不正确");
					resultList.add(resultDto);
					continue;
				}
				// 2.3校验单品数据
				// 2.3.1校验必入力项
				if (Strings.isNullOrEmpty(goodsImportDto.getPrice()) || Strings.isNullOrEmpty(goodsImportDto.getStock())
						|| (GOODS_TYPE_O2O.equals(goodsImportDto.getGoodsType()))&& Strings.isNullOrEmpty(goodsImportDto.getO2oCode())
						|| (GOODS_TYPE_O2O.equals(goodsImportDto.getGoodsType())&& Strings.isNullOrEmpty(goodsImportDto.getO2oVoucherCode()))
						|| (Strings.isNullOrEmpty(goodsImportDto.getAttribute1Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute1ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute1Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute1ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute2Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute2ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute3Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute3ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute4Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute4ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute5Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute5ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute6Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute6ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute7Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute7ValueName()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getAttribute8Name())&& Strings.isNullOrEmpty(goodsImportDto.getAttribute8ValueName()))) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("存在必填信息未填写");
					resultList.add(resultDto);
					continue;
				}
				// 2.3.2校验数据格式
				if (!isPrice(goodsImportDto.getPrice())|| !isInteger(goodsImportDto.getStock())
						|| (!Strings.isNullOrEmpty(goodsImportDto.getMarketPrice()))&& !isPrice(goodsImportDto.getMarketPrice())
						|| (!Strings.isNullOrEmpty(goodsImportDto.getStockWarning())&& !isInteger(goodsImportDto.getStockWarning()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getStockWarning())&& Integer.parseInt(goodsImportDto.getStockWarning()) > Integer.parseInt(goodsImportDto.getStock()))
						|| (!Strings.isNullOrEmpty(goodsImportDto.getFixPoint())&& !isInteger(goodsImportDto.getFixPoint()))) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("存在格式不正确的数据");
					resultList.add(resultDto);
					continue;
				}
				// 2.3.3校验销售属性与前一条是否相同
				// 2.3.4校验销售属性是否相同
				if (GOODS_FLAG_N.equals(goodsImportDto.getGoodsFlag()) && !Strings.isNullOrEmpty(goodsCode)) {
					if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute1Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute1Name())) {
						if (!goodsImportDto.getAttribute1Name().equals(oldGoodsImportDto.getAttribute1Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute1ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute1ValueName())) {
							if (goodsImportDto.getAttribute1ValueName()
									.equals(oldGoodsImportDto.getAttribute1ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute2Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute2Name())) {
						if (!goodsImportDto.getAttribute2Name().equals(oldGoodsImportDto.getAttribute2Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute2ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute2ValueName())) {
							if (goodsImportDto.getAttribute2ValueName()
									.equals(oldGoodsImportDto.getAttribute2ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute3Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute3Name())) {
						if (!goodsImportDto.getAttribute3Name().equals(oldGoodsImportDto.getAttribute3Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute3ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute3ValueName())) {
							if (goodsImportDto.getAttribute3ValueName()
									.equals(oldGoodsImportDto.getAttribute3ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute4Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute4Name())) {
						if (!goodsImportDto.getAttribute4Name().equals(oldGoodsImportDto.getAttribute4Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute4ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute4ValueName())) {
							if (goodsImportDto.getAttribute4ValueName()
									.equals(oldGoodsImportDto.getAttribute4ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute5Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute5Name())) {
						if (!goodsImportDto.getAttribute5Name().equals(oldGoodsImportDto.getAttribute5Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute5ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute5ValueName())) {
							if (goodsImportDto.getAttribute5ValueName()
									.equals(oldGoodsImportDto.getAttribute5ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute6Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute6Name())) {
						if (!goodsImportDto.getAttribute6Name().equals(oldGoodsImportDto.getAttribute6Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute6ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute6ValueName())) {
							if (goodsImportDto.getAttribute6ValueName()
									.equals(oldGoodsImportDto.getAttribute6ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute7Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute7Name())) {
						if (!goodsImportDto.getAttribute7Name().equals(oldGoodsImportDto.getAttribute7Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute7ValueName())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute7ValueName())) {
							if (goodsImportDto.getAttribute7ValueName()
									.equals(oldGoodsImportDto.getAttribute7ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute8Name())
							&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute8Name())) {
						if (!goodsImportDto.getAttribute8Name().equals(oldGoodsImportDto.getAttribute8Name())) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("属性处存在错误数据");
							resultList.add(resultDto);
							continue;
						} else if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute8Name())
								&& !Strings.isNullOrEmpty(oldGoodsImportDto.getAttribute8Name())) {
							if (goodsImportDto.getAttribute8ValueName()
									.equals(oldGoodsImportDto.getAttribute8ValueName())) {
								resultDto.setSuccessFlag(SUCCESS_FLAG_N);
								resultDto.setFailReason("属性处存在错误数据");
								resultList.add(resultDto);
								continue;
							}
						}
					}
				}
				// TODO 2.3.5校验同一条单品的销售属性是否存在相同
				// 2.3.6整合单品数据
				ItemModel itemModel = new ItemModel();
				itemModel.setPrice(new BigDecimal(goodsImportDto.getPrice()));// 价格
				if (!Strings.isNullOrEmpty(goodsImportDto.getMarketPrice())) {
					itemModel.setMarketPrice(new BigDecimal(goodsImportDto.getMarketPrice()));// 市场价
				}
				itemModel.setStock(Long.parseLong(goodsImportDto.getStock()));// 库存
				if (!Strings.isNullOrEmpty(goodsImportDto.getStockWarning())) {
					itemModel.setStockWarning(Long.parseLong(goodsImportDto.getStockWarning()));// 库存预警值
				}
				if (GOODS_TYPE_O2O.equals(goodsImportDto.getGoodsType())&& !Strings.isNullOrEmpty(goodsImportDto.getO2oCode())&& !Strings.isNullOrEmpty(goodsImportDto.getO2oVoucherCode())) {
					itemModel.setO2oCode(goodsImportDto.getO2oCode());// O2O编码
					itemModel.setO2oVoucherCode(goodsImportDto.getO2oVoucherCode());// O2O兑换券编码
				}
				if (!Strings.isNullOrEmpty(goodsImportDto.getFixPoint())) {
					itemModel.setFixPoint(Long.parseLong(goodsImportDto.getFixPoint()));// 固定积分
				}
				// 整合属性字段
				List<ItemAttributeDto> itemAttributes = null;// 单品属性--基本属性
				ItemsAttributeSkuDto itemsAttributeSku = null;// 单品属性--销售属性--单项
				List<ItemsAttributeSkuDto> itemSkus = organizeSkus(goodsImportDto);// 单品属性--销售属性
				itemsAttr = new ItemsAttributeDto();
				itemsAttr.setAttributes(new ArrayList());
				itemsAttr.setSkus(itemSkus);
				String itemAttrs = jsonMapper.toJson(itemsAttr);
				itemModel.setAttribute(itemAttrs);
				if (!Strings.isNullOrEmpty(goodsCode) && GOODS_FLAG_N.equals(goodsImportDto.getGoodsFlag())) {
					itemModel.setGoodsCode(goodsCode);
					// 更新商品表的attribute字段
					GoodsModel goodsModel = new GoodsModel();
					ItemsAttributeDto oldGoodsAttribute = new ItemsAttributeDto();
					Response<GoodsModel> goodsModelResponse = goodsService.findById(goodsCode);
					if (goodsModelResponse.isSuccess()) {
						oldGoodsAttribute = jsonMapper.fromJson(goodsModelResponse.getResult().getAttribute(),ItemsAttributeDto.class);
						List<ItemsAttributeSkuDto> oldGoodsSkus = oldGoodsAttribute.getSkus();
						ItemsAttributeSkuDto newGoodsSku = null;
						List<ItemsAttributeSkuDto> newGoodsSkus = Lists.newArrayList();
						ItemAttributeDto newValue = null;
						for (ItemsAttributeSkuDto itemsAttributeSkuDto : oldGoodsSkus) {
							newGoodsSku = new ItemsAttributeSkuDto();
							newValue = new ItemAttributeDto();
							List<ItemAttributeDto> newValues = itemsAttributeSkuDto.getValues();
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute1Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute1ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute1ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute2Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute2ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute2ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute3Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute3ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute3ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute4Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute4ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute4ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute5Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute5ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute5ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute6Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute6ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute6ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute7Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute7ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute7ValueName());
								newValues.add(newValue);
							}
							if (itemsAttributeSkuDto.getAttributeValueName().equals(goodsImportDto.getAttribute8Name())) {
								newValue.setAttributeValueKey(findAttributeValueKey(goodsImportDto.getAttribute8ValueName()));
								newValue.setAttributeValueName(goodsImportDto.getAttribute8ValueName());
								newValues.add(newValue);
							}
							newGoodsSku.setAttributeValueKey(itemsAttributeSkuDto.getAttributeValueKey());
							newGoodsSku.setAttributeValueName(itemsAttributeSkuDto.getAttributeValueName());
							newGoodsSku.setValues(newValues);
							newGoodsSkus.add(newGoodsSku);
						}
						ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
						List<ItemAttributeDto> oldAttributes = oldGoodsAttribute.getAttributes();
						if(oldAttributes ==null || oldAttributes.size()==0){
							itemsAttributeDto.setAttributes(new ArrayList());
						}else{
							itemsAttributeDto.setAttributes(oldAttributes);
						}
						itemsAttributeDto.setSkus(newGoodsSkus);
						goodsItemDto.setGoodAttr(itemsAttributeDto);
					}
				}
				goodsItemDto.setItemModel(itemModel);
				// 2.1根据goods_flag判断是否是一条新商品,如果是一条新商品，则会插入到商品表中，否则是插入单品数据
				if (GOODS_FLAG_Y.equals(goodsImportDto.getGoodsFlag())) {
					BeanMapper.copy(goodsImportDto, oldGoodsImportDto);
					// 2.2校验商品数据
					// 2.2.1校验必入力项
					// 商品名称
					if (Strings.isNullOrEmpty(goodsImportDto.getGoodsName())|| Strings.isNullOrEmpty(goodsImportDto.getBrandName())
							|| Strings.isNullOrEmpty(goodsImportDto.getVendorId())|| Strings.isNullOrEmpty(goodsImportDto.getBackCategory1Id())
							|| Strings.isNullOrEmpty(goodsImportDto.getBackCategory2Id())|| Strings.isNullOrEmpty(goodsImportDto.getBackCategory3Id())
							|| Strings.isNullOrEmpty(goodsImportDto.getGoodsType())|| Strings.isNullOrEmpty(goodsImportDto.getIsInner())
							|| Strings.isNullOrEmpty(goodsImportDto.getMailOrderCode())
							|| Strings.isNullOrEmpty(goodsImportDto.getServiceType())|| Strings.isNullOrEmpty(goodsImportDto.getCards())) {
						resultDto.setSuccessFlag(SUCCESS_FLAG_N);
						resultDto.setFailReason("存在必填信息未填写");
						resultList.add(resultDto);
						continue;
					}
					// 2.2.2校验数据格式、
					// 一级后台类目--数字
					if (!isNumeric(goodsImportDto.getBackCategory1Id())|| !isNumeric(goodsImportDto.getBackCategory2Id())
							|| !isNumeric(goodsImportDto.getBackCategory3Id())
							|| !matchCards(goodsImportDto.getCards())) {
						resultDto.setSuccessFlag(SUCCESS_FLAG_N);
						resultDto.setFailReason("存在格式不正确的数据");
						resultList.add(resultDto);
						continue;
					}
					// 2.2.3校验填写数据是否存在
					// 供应商编码
					Response<VendorInfoDto> vendorResponse = vendorService.findById(goodsImportDto.getVendorId());
					if (vendorResponse.isSuccess()) {
						if (vendorResponse.getResult() == null) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("供应商编码不存在");
							resultList.add(resultDto);
							continue;
						}
					}
					// 品牌
					Response<GoodsBrandModel> brandResponse = brandService.findBrandByName(goodsImportDto.getBrandName(), goodsImportDto.getOrdertypeId());
					if (brandResponse.isSuccess()) {
						if (brandResponse.getResult() == null) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("品牌信息不存在");
							resultList.add(resultDto);
							continue;
						}
					}
					// 该品牌是否被该供应商授权
					Response<Boolean> authorizeResponse = brandService.findBrandAuthorizeByVendorId(goodsImportDto.getBrandName(), goodsImportDto.getVendorId());
					if (authorizeResponse.isSuccess()) {
						if (!authorizeResponse.getResult()) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("品牌信息未被该供应商授权");
							resultList.add(resultDto);
							continue;
						}
					}
					// 2.2.4整合商品数据
					GoodsModel goodsModel = new GoodsModel();
					BeanMapper.copy(goodsImportDto, goodsModel);
					// 根据三级类目id查找商品基本属性
					Response<AttributeDto> backResponse = backCategoriesService.getAttributeById(Long.parseLong(goodsImportDto.getBackCategory3Id()));
					if (backResponse.isSuccess()) {
						if (backResponse.getResult().getAttribute() != null) {
							List<AttributeKey> attributeKeyList = backResponse.getResult().getAttribute();
							ItemAttributeDto goodsAttribute = null;
							for (AttributeKey attr : attributeKeyList) {
								goodsAttribute = new ItemAttributeDto();
								goodsAttribute.setAttributeKey(attr.getId());
								goodsAttribute.setAttributeName(attr.getName());
								goodsAttributes.add(goodsAttribute);
							}
							goodsAttr.setAttributes(goodsAttributes);
						} else {
							goodsAttr.setAttributes(new ArrayList());
						}
					}
					// 产品id
					if (!Strings.isNullOrEmpty(goodsImportDto.getProductName())) {
						Response<ProductModel> productResponse = productService.findProductByName(goodsImportDto.getProductName());
						if (productResponse.isSuccess()) {
							if (productResponse.getResult() != null) {
								goodsModel.setProductId(productResponse.getResult().getId());
								ItemsAttributeDto productAttr = jsonMapper
										.fromJson(productResponse.getResult().getAttribute(), ItemsAttributeDto.class);
								if (productAttr.getAttributes() != null) {
									goodsAttr.setAttributes(productAttr.getAttributes());
								}
							}
						}
					}
					// 品牌id
					Response<GoodsBrandModel> brandModelResponse = brandService.findBrandByName(goodsImportDto.getBrandName(), goodsImportDto.getOrdertypeId());
					if (brandModelResponse.isSuccess()) {
						goodsModel.setGoodsBrandId(brandModelResponse.getResult().getId());
					}
					// 一二三级类目id
					goodsModel.setBackCategory3Id(Long.parseLong(goodsImportDto.getBackCategory1Id()));
					goodsModel.setBackCategory2Id(Long.parseLong(goodsImportDto.getBackCategory2Id()));
					goodsModel.setBackCategory3Id(Long.parseLong(goodsImportDto.getBackCategory3Id()));
					goodsModel.setName(goodsImportDto.getGoodsName());
					// 商品类型
					if (GOODS_TYPE_TRUE.equals(goodsImportDto.getGoodsType())) {
						goodsModel.setGoodsType(Contants.SUB_ORDER_TYPE_00);
					} else if (GOODS_TYPE_O2O.equals(goodsImportDto.getGoodsType())) {
						goodsModel.setGoodsType(Contants.SUB_ORDER_TYPE_02);
					} else {
						resultDto.setSuccessFlag(SUCCESS_FLAG_N);
						resultDto.setFailReason("商品类型填写错误");
						resultList.add(resultDto);
						continue;
					}
					// 内宣商品
					if (IS_INNER_Y.equals(goodsImportDto.getIsInner())) {
						goodsModel.setIsInner(Contants.IS_INNER_0);
					} else if (IS_INNER_N.equals(goodsImportDto.getIsInner())) {
						goodsModel.setIsInner(Contants.IS_INNER_1);
					} else {
						resultDto.setSuccessFlag(SUCCESS_FLAG_N);
						resultDto.setFailReason("是否内宣商品填写错误");
						resultList.add(resultDto);
						continue;
					}
					// 商品属性
					goodsSkus = organizeSkus(goodsImportDto);
					goodsAttr.setSkus(goodsSkus);
					String goodsAttrs = jsonMapper.toJson(goodsAttr);
					goodsModel.setAttribute(goodsAttrs);
					goodsItemDto.setGoodsModel(goodsModel);
				}
				if (Strings.isNullOrEmpty(goodsCode) && GOODS_FLAG_N.equals(goodsImportDto.getGoodsFlag())) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("该条商品插入失败");
					resultList.add(resultDto);
				}
				// 2.4通过所有校验后插入数据,返回商品编码和单品编码
				Response<GoodsAndItemCodeDto> response = goodsService.importGoodsData(goodsItemDto, user);
				if (response.isSuccess()) {
					goodsCode = response.getResult().getGoodsCode();
					resultDto.setGoodsCode(goodsCode);
					resultDto.setItemCode(response.getResult().getItemCode());
					resultDto.setSuccessFlag(SUCCESS_FLAG_Y);
					resultList.add(resultDto);
				} else {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("该条商品插入失败");
					resultList.add(resultDto);
				}
			}
			result.setResult(resultList);
		} catch (Exception e) {
			log.error("import goods list error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("import.goods.list.error");
		}
		return result;
	}

	/**
	 * 整理商品销售属性字段
	 * @param goodsImportDto
	 * @return
	 */
	private List<ItemsAttributeSkuDto> organizeSkus(GoodsImportDto goodsImportDto) {
		List<ItemsAttributeSkuDto> goodsSkus = Lists.newArrayList();
		ItemsAttributeSkuDto goodsAttributeSku = null;
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute1Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute1ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute1Name(),
					goodsImportDto.getAttribute1ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute2Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute2ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute2Name(),
					goodsImportDto.getAttribute2ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute3Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute3ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute3Name(),
					goodsImportDto.getAttribute3ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute4Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute4ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute4Name(),
					goodsImportDto.getAttribute4ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute5Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute5ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute5Name(),
					goodsImportDto.getAttribute5ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute6Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute6ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute6Name(),
					goodsImportDto.getAttribute6ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute7Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute7ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute7Name(),
					goodsImportDto.getAttribute7ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		if (!Strings.isNullOrEmpty(goodsImportDto.getAttribute8Name())
				&& !Strings.isNullOrEmpty(goodsImportDto.getAttribute8ValueName())) {
			goodsAttributeSku = new ItemsAttributeSkuDto();
			goodsAttributeSku = findAttributeKey(goodsImportDto.getAttribute8Name(),
					goodsImportDto.getAttribute8ValueName());
			goodsSkus.add(goodsAttributeSku);
		}
		return goodsSkus;

	}

	/**
	 * 创建销售属性值对应key
	 *
	 * @param attributeValueName
	 * @return
	 */
	private Long findAttributeValueKey(String attributeValueName) {
		Long id = null;
		AttributeValue attributeValue = new AttributeValue();
		attributeValue.setValue(attributeValueName);
		Response<AttributeValue> attributeValueResponse = attributeValueService.create(attributeValue);
		if (attributeValueResponse.isSuccess()) {
			id = attributeValueResponse.getResult().getId();
		}
		return id;
	}

	/**
	 * 创建销售属性对应key
	 *
	 * @param attributeName
	 * @return
	 */
	private ItemsAttributeSkuDto findAttributeKey(String attributeName, String attributeValueName) {
		AttributeValue attributeValue = new AttributeValue();
		ItemsAttributeSkuDto itemsAttributeSku = new ItemsAttributeSkuDto();
		attributeValue.setValue(attributeName);
		Response<AttributeValue> response = attributeValueService.create(attributeValue);
		if (response.isSuccess()) {
			itemsAttributeSku.setAttributeValueKey(response.getResult().getId());
			itemsAttributeSku.setAttributeValueName(attributeName);
		}
		attributeValue.setValue(attributeValueName);
		List<ItemAttributeDto> values = Lists.newArrayList();
		Response<AttributeValue> attributeValueResponse = attributeValueService.create(attributeValue);
		if (attributeValueResponse.isSuccess()) {
			ItemAttributeDto itemAttributeDto = new ItemAttributeDto();
			itemAttributeDto.setAttributeValueKey(attributeValueResponse.getResult().getId());
			itemAttributeDto.setAttributeValueName(attributeValueResponse.getResult().getValue());
			values.add(itemAttributeDto);
			itemsAttributeSku.setValues(values);
		}
		return itemsAttributeSku;
	}

	/**
	 * 判断字符串是否为数字
	 *
	 * @param str 字符串
	 * @return
	 */
	private boolean isNumeric(String str) {
		Matcher isNum = numPattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 第三级卡产品编码校验
	 *
	 * @param str
	 * @return
	 */
	private boolean matchCards(String str) {
		Matcher cardMatcher = cardsPattern.matcher(str);
		if (!cardMatcher.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 校验字符串是否为正整数
	 *
	 * @param str
	 * @return
	 */
	private boolean isInteger(String str) {
		Matcher isInt = intPattern.matcher(str);
		if (!isInt.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 校验字符串是否为正整数，小数位两位
	 *
	 * @param str
	 * @return
	 */
	private boolean isPrice(String str) {
		Matcher isPrice = pricePattern.matcher(str);
		if (!isPrice.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 商品导出
	 *
	 * @param goodsDetailDto
	 * @return
	 */
	public Response<List<GoodsExportDto>> exportGoodsData(GoodsDetailDto goodsDetailDto) {
		Response<List<GoodsExportDto>> result = new Response<>();
		List<GoodsExportDto> resultList = Lists.newArrayList();
		try {
			// 根据goodsModel在goods表中查询符合条件的商品信息
			Map<String, Object> params = Maps.newHashMap();
			if (!Strings.isNullOrEmpty(goodsDetailDto.getGoodsCode())) {
				params.put("code", goodsDetailDto.getGoodsCode());
			}
			if (!Strings.isNullOrEmpty(goodsDetailDto.getName())) {
				params.put("name", goodsDetailDto.getName());
			}
			// 供应商名称
			if (!Strings.isNullOrEmpty(goodsDetailDto.getVendorName())) {
				Response<List<String>> vendorResponse = vendorService.findIdByName(goodsDetailDto.getVendorName());
				if (vendorResponse.isSuccess()) {
					List<String> vendorIds = vendorResponse.getResult();
					params.put("vendorIds", vendorIds);
				}
			}
			// 品牌
			if (!Strings.isNullOrEmpty(goodsDetailDto.getBrandName())) {
				List<Long> brandIds = goodsBrandDao.findBrandIdListByName(goodsDetailDto.getBrandName());
				params.put("brandIds", brandIds);
			}
			if (goodsDetailDto.getBackCategory1Id() != null) {
				params.put("backCategoryId1", goodsDetailDto.getBackCategory1Id());
			}
			if (goodsDetailDto.getBackCategory2Id() != null) {
				params.put("backCategoryId2", goodsDetailDto.getBackCategory2Id());
			}
			if (goodsDetailDto.getBackCategory3Id() != null) {
				params.put("backCategoryId3", goodsDetailDto.getBackCategory3Id());
			}
			if (!Strings.isNullOrEmpty(goodsDetailDto.getApproveStatus())) {
				params.put("approveStatus", goodsDetailDto.getApproveStatus());
			}
			// 广发商城状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelMall())) {
				params.put("channelMall", goodsDetailDto.getChannelMall());
			}
			// CC状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelCc())) {
				params.put("channelCc", goodsDetailDto.getChannelCc());
			}
			// 卡中心微信状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelCreditWx())) {
				params.put("channelCreditWx", goodsDetailDto.getChannelCreditWx());
			}
			// 手机商城状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelPhone())) {
				params.put("channelPhone", goodsDetailDto.getChannelPhone());
			}
			// APP状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelApp())) {
				params.put("channelApp", goodsDetailDto.getChannelApp());
			}
			// 广发微信状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelMallWx())) {
				params.put("channelMallWx", goodsDetailDto.getChannelMallWx());
			}
			// 短信状态
			if (!Strings.isNullOrEmpty(goodsDetailDto.getChannelSms())) {
				params.put("channelSms", goodsDetailDto.getChannelSms());
			}
			List<GoodsModel> goodsModelList = goodsDao.findGoodsListByConditions(params);
			List<String> goodsCodes = Lists.newArrayList();
			for (GoodsModel goodsModel : goodsModelList) {
				goodsCodes.add(goodsModel.getCode());
			}
			Response<List<ItemModel>> itemResponse = itemService.findItemListByGoodsCodeList(goodsCodes);
			List<ItemModel> itemModelList = Lists.newArrayList();
			if (itemResponse.isSuccess()) {
				itemModelList = itemResponse.getResult();
			}
			GoodsExportDto goodsExportDto = null;
			for (ItemModel itemModel : itemModelList) {
				goodsExportDto = new GoodsExportDto();
				// 单品数据
				BeanMapper.copy(itemModel, goodsExportDto);
				goodsExportDto.setItemCode(itemModel.getCode());
				// 单品销售属性
				ItemsAttributeDto itemAttributes = jsonMapper.fromJson(itemModel.getAttribute(),
						ItemsAttributeDto.class);
				List<ItemsAttributeSkuDto> itemSkus = itemAttributes.getSkus();
				for (int i = 0; i < itemSkus.size(); i++) {
					ItemsAttributeSkuDto itemSku = itemSkus.get(i);
					if (i == 0) {
						goodsExportDto.setAttribute1Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute1ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 1) {
						goodsExportDto.setAttribute2Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute2ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 2) {
						goodsExportDto.setAttribute3Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute3ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 3) {
						goodsExportDto.setAttribute4Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute4ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 4) {
						goodsExportDto.setAttribute5Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute5ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 5) {
						goodsExportDto.setAttribute6Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute6ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 6) {
						goodsExportDto.setAttribute7Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute7ValueName(itemSku.getValues().get(0).getAttributeValueName());
					} else if (i == 7) {
						goodsExportDto.setAttribute8Name(itemSku.getAttributeValueName());
						goodsExportDto.setAttribute8ValueName(itemSku.getValues().get(0).getAttributeValueName());
					}
				}
				// 商品数据
				GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
				BeanMapper.copy(goodsModel, goodsExportDto);
				goodsExportDto.setGoodsCode(goodsModel.getCode());// 商品编码
				goodsExportDto.setOrdertypeId(goodsModel.getOrdertypeId());// 业务类型
				goodsExportDto.setGoodsName(goodsModel.getName());// 商品名称
				if (goodsModel.getProductId() != null) {
					Response<ProductDto> productDtoResponse = productService.findProductById(goodsModel.getProductId());
					if (productDtoResponse.isSuccess()) {
						goodsExportDto.setProductName(productDtoResponse.getResult().getName());// 产品名称
					}
				}
				goodsExportDto.setManufacturer(goodsModel.getManufacturer());// 生产厂家
				Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId());
				if (vendorInfoDtoResponse.isSuccess()) {
					goodsExportDto.setVendorName(vendorInfoDtoResponse.getResult().getSimpleName());// 供应商名称
				}
				Response<GoodsBrandModel> goodsBrandModelResponse = brandService
						.findBrandInfoById(goodsModel.getGoodsBrandId());
				if (goodsBrandModelResponse.isSuccess()) {
					goodsExportDto.setBrandName(goodsBrandModelResponse.getResult().getBrandName());// 品牌信息
				}
				// 获取后台类目名称
				List<Long> backCategoryIdList = Lists.newArrayList();
				backCategoryIdList.add(goodsModel.getBackCategory1Id());
				backCategoryIdList.add(goodsModel.getBackCategory2Id());
				backCategoryIdList.add(goodsModel.getBackCategory3Id());
				// 获取后台类目id所对应的信息list
				Response<List<BackCategory>> backCateResponse = backCategoriesService.findByIds(backCategoryIdList);
				List<BackCategory> backCategoryList = Lists.newArrayList();
				if (backCateResponse.isSuccess()) {
					backCategoryList = backCateResponse.getResult();
					if (!Strings.isNullOrEmpty(backCategoryList.get(0).getName())) {
						goodsExportDto.setBackCategory1Name(backCategoryList.get(0).getName());
					}
					if (!Strings.isNullOrEmpty(backCategoryList.get(1).getName())) {
						goodsExportDto.setBackCategory2Name(backCategoryList.get(1).getName());
					}
					if (!Strings.isNullOrEmpty(backCategoryList.get(2).getName())) {
						goodsExportDto.setBackCategory3Name(backCategoryList.get(2).getName());
					}
				}
				// 商品类型
				if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
					goodsExportDto.setGoodsType(Contants.GOODS_TYPE_NM_00);
				} else if (Contants.SUB_ORDER_TYPE_01.equals(goodsModel.getGoodsType())) {
					goodsExportDto.setGoodsType(Contants.GOODS_TYPE_NM_01);
				} else {
					goodsExportDto.setGoodsType(Contants.GOODS_TYPE_NM_02);
				}
				// 是否内宣商品0是1否
				if (Contants.IS_INNER_0.equals(goodsModel.getIsInner())) {
					goodsExportDto.setIsInner("是");
				} else {
					goodsExportDto.setIsInner("否");
				}
				resultList.add(goodsExportDto);
			}
			result.setResult(resultList);
			return result;
		} catch (Exception e) {
			log.error("export.goods.list.error", Throwables.getStackTraceAsString(e));
			result.setError("export.goods.list.error");
			return result;
		}
	}
}
