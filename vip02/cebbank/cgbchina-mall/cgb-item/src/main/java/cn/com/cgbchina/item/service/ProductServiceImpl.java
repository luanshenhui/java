package cn.com.cgbchina.item.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Optional;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.util.KeyUtil;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.BackCategoriesDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.ProductDao;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.manager.ProductManager;
import cn.com.cgbchina.item.model.AttributeValue;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.ProductModel;
import lombok.extern.slf4j.Slf4j;

/**
 * product
 *
 * @author Tanliang
 * @since 2016-4-11
 */
@Service
@Slf4j
public class ProductServiceImpl implements ProductService {

	@Resource
	private ProductDao productDao;
	@Resource
	ProductManager productManager;
	@Resource
	private BackCategoriesDao backCategoriesDao;
	@Resource
	private GoodsBrandDao goodsBrandDao;
	@Resource
	private BackCategoriesService backCategoriesService;
	@Resource
	private AttributeValueService attributeValueService;
	@Resource
	private BrandService brandService;

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	// 定义本地缓存(根据产品id取得产品信息）
	private final LoadingCache<Long, Optional<ProductModel>> productInfoCache;

	// 声明缓存
	public ProductServiceImpl() {
		productInfoCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Long, Optional<ProductModel>>() {
					@Override
					public Optional<ProductModel> load(Long id) throws Exception {
						return Optional.fromNullable(productDao.findById(id));
					}
				});
	}

	// 产品信息共通用（通过id查询产品信息）
	private ProductModel findProductInfoByCache(Long id) {
		Optional<ProductModel> productModel = productInfoCache.getUnchecked(id);
		if (productModel.isPresent()) {
			return productModel.get();
		} else {
			return null;
		}
	}

	/**
	 * 产品页面分页以及查询功能
	 *
	 * @param pageNo
	 * @param size
	 * @param name
	 * @param orderTypeId 业务类型代码 YG：广发 JF：积分
	 * @return
	 */
	@Override
	public Response<Pager<ProductDto>> findAll(Integer pageNo, Integer size, String name, String brandName,
			String startTime, String endTime, String back_category1_id, String back_category2_id,
			String back_category3_id, String orderTypeId) {
		Response<Pager<ProductDto>> response = new Response<Pager<ProductDto>>();
		Map<String, Object> paramMap = Maps.newHashMap();

		PageInfo pageInfo = new PageInfo(pageNo, size);
		paramMap.put("offset", pageInfo.getOffset());
		paramMap.put("limit", pageInfo.getLimit());
		if (StringUtils.isNotEmpty(name)) {
			paramMap.put("name", name.trim());
		}
		// 非空判断
		if (StringUtils.isNotEmpty(brandName)) {
			// 这里通过brandName取得brandId
			GoodsBrandModel goodsBrandModel = brandService.findBrandByName(brandName.trim(), orderTypeId).getResult();
			Long brandId = goodsBrandModel.getId();
			paramMap.put("goodsBrandId", brandId);
		}
		// 开始时间
		if (StringUtils.isNotEmpty(startTime)) {
			paramMap.put("startTime", startTime);
		}
		// 结束时间
		if (StringUtils.isNotEmpty(endTime)) {
			paramMap.put("endTime", endTime);
		}
		// 后台类目123
		if (StringUtils.isNotEmpty(back_category1_id)) {
			paramMap.put("backCategory1Id", back_category1_id);
		}
		if (StringUtils.isNotEmpty(back_category2_id)) {
			paramMap.put("backCategory2Id", back_category2_id);
		}
		if (StringUtils.isNotEmpty(back_category3_id)) {
			paramMap.put("backCategory3Id", back_category3_id);
		}
		// 业务类型
		if (StringUtils.isNotEmpty(orderTypeId)) {
			paramMap.put("ordertypeId", orderTypeId);
		}
		// 取得分页数据对象
		Pager<ProductModel> pager = productDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
		// 创建List DTo实例对象
		List<ProductDto> productDtos = new ArrayList<ProductDto>();
		// 创建取得后台类目名称所需的实例对象
		Response<List<BackCategory>> backCategoryRespone = new Response<List<BackCategory>>();
		List<BackCategory> backCategoryList = Lists.newArrayList();
		if (pager.getTotal() > 0) {
			List<ProductModel> productList = pager.getData();
			// 循环取值set
			for (ProductModel p : productList) {
				ProductDto productDto = new ProductDto();
				List<Long> backCategoryIdList = Lists.newArrayList();
				BeanMapper.copy(p, productDto);
				// 取得品牌id
				Long brandId = p.getGoodsBrandId();
				// 取得品牌id取得名称(缓存）
				GoodsBrandModel goodsBrandModel = brandService.findBrandInfoById(brandId).getResult();
				String proBrandName = goodsBrandModel.getBrandName();
				productDto.setBrandName(proBrandName);
				// 后台类目id赋值到backCategoryIdList
				backCategoryIdList.add(p.getBackCategory1Id());
				backCategoryIdList.add(p.getBackCategory2Id());
				backCategoryIdList.add(p.getBackCategory3Id());
				// 根据后台类目id（backCategoryIdList）取得后台类目名称
				backCategoryRespone = backCategoriesService.findByIds(backCategoryIdList);
				if (backCategoryRespone.isSuccess()) {
					// 非空判断，如果不为null 就set 后台类目名称到productDto
					backCategoryList = backCategoryRespone.getResult();
					if (!backCategoryList.isEmpty()) {// modify by zhangshiqiang
						// 因为只有三级后台类目，所以不用循环，只取0 1 2即可
						productDto.setBackCategory1Name(backCategoryList.get(0).getName());
						productDto.setBackCategory2Name(backCategoryList.get(1).getName());
						productDto.setBackCategory3Name(backCategoryList.get(2).getName());
					}
				}
				// 把productDto赋值给productDtos
				productDtos.add(productDto);
			}
		}
		Pager<ProductDto> pagerProduct = new Pager<ProductDto>(pager.getTotal(), productDtos);
		response.setResult(pagerProduct);
		return response;
	}

	/**
	 * 根据id查看产品
	 *
	 * @param id
	 * @return productResponse
	 */
	@Override
	public Response<ProductDto> findProductById(Long id) {

		Response<ProductDto> productResponse = new Response<ProductDto>();

		ProductDto productDto = new ProductDto();
		// 根据产品id取得产品信息
		ProductModel productModel = findProductInfoByCache(id);
//		ProductModel productModel = productDao.findById(id);

		if (productModel == null) {
			return null;
		}
		// 根据品牌id取得品牌名称(缓存）
		Long brandId = productModel.getGoodsBrandId();

		Response<GoodsBrandModel> res = brandService.findBrandInfoById(brandId);
		GoodsBrandModel goodsBrandModel = res == null? null :res.getResult();
		String brandName;

		if (null == goodsBrandModel || null == goodsBrandModel.getBrandName()) {
			return null;
		}else{
			brandName = goodsBrandModel.getBrandName();
		}

		// 创建取得后台类目名称所需的实例对象
		Response<List<BackCategory>> backCategoryRespone;
		List<Long> backCategoryIdList = Lists.newArrayList();
		List<BackCategory> backCategoryList;
		// 后台类目id赋值到backCategoryIdList
		backCategoryIdList.add(productModel.getBackCategory1Id());
		backCategoryIdList.add(productModel.getBackCategory2Id());
		backCategoryIdList.add(productModel.getBackCategory3Id());
		// 根据后台类目id（backCategoryIdList）取得后台类目名称
		backCategoryRespone = backCategoriesService.findByIds(backCategoryIdList);
		if (backCategoryRespone.isSuccess()) {
			backCategoryList = backCategoryRespone.getResult();
			// 非空判断，如果不为null 就set 后台类目名称到productDto
			// 因为只有三级后台类目，所以不用循环，只取0 1 2即可
			if (backCategoryList.get(0).getName() != null) {
				productDto.setBackCategory1Name(backCategoryList.get(0).getName());
				productDto.setBackCategory1Id(backCategoryList.get(0).getId());
			}
			if (backCategoryList.get(1).getName() != null) {
				productDto.setBackCategory2Name(backCategoryList.get(1).getName());
				productDto.setBackCategory2Id(backCategoryList.get(1).getId());
			}
			if (backCategoryList.get(2).getName() != null) {
				productDto.setBackCategory3Name(backCategoryList.get(2).getName());
				productDto.setBackCategory3Id(backCategoryList.get(2).getId());
			}
		}
		// 判断产品属性，为空时才从三级类目获取
		String attribute = productModel.getAttribute();
		if (StringUtils.isNotEmpty(attribute)) {
			// 产品属性
			ItemsAttributeDto itemsAttributeDto = jsonMapper.fromJson(attribute, ItemsAttributeDto.class);
			productDto.setItemsAttributeDto(itemsAttributeDto);
		}

		// 赋值给response返回
		productDto.setBrandName(brandName);
		productDto.setManufacturer(productModel.getManufacturer()); // 生产企业
		productDto.setName(productModel.getName()); // 产品名
		productDto.setAttribute(productModel.getAttribute()); // 产品属性
		productResponse.setResult(productDto);
		return productResponse;
	}

	/**
	 * 根据id删除产品
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> deleteProductById(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {

			ProductModel model = productDao.findById(id);
			Boolean delFlag = productManager.deleteProduct(id);

			if (delFlag) {
				// 删除成功
				backCategoriesService.changeCount(model.getBackCategory3Id(), -1L);// 类目记数用
				productInfoCache.invalidate(id);//缓存失效
			}
			response.setResult(delFlag);
		} catch (Exception e) {
			log.error("delete.product.error,cause:{}", id, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
		}
		return response;
	}

	/**
	 * 保存以及编辑产品功能
	 *
	 * @param productDto
	 * @return
	 */
	@Override
	public Response<Boolean> saveOrEditProduct(ProductDto productDto, User user) {
		Response<Boolean> response = new Response<Boolean>();

		// 异常处理
		try {
			if (productDto == null) {
				response.setResult(Boolean.FALSE);
				return response;
			}

			if (null == productDto.getId()) {
				addProduct(response, productDto, user);// 新增
			} else {
				updateProduct(response, productDto, user);// 更新
			}
			return response;
		} catch (IllegalArgumentException e) {
			// 不合法的参数异常
			response.setError(e.getMessage());
			response.setResult(Boolean.FALSE);
			return response;
		} catch (Exception e) {
			// 更新失败
			log.error("updateProduct，error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("updateProduct.error");
			response.setResult(Boolean.FALSE);
			return response;
		}
	}

	/**
	 * 新增
	 * 
	 * @param response
	 * @param productDto
	 * @param user
	 * @author zhoupeng
	 */
	private void addProduct(Response<Boolean> response, ProductDto productDto, User user) {

		// 创建产品model实例
		ProductModel productModel = new ProductModel();
		// 将productDto的值copy给productModel
		BeanMapper.copy(productDto, productModel);

		// 品牌
		Long brandId;
		// 根据品牌名字取得品牌ID
		String brandName = productDto.getBrandName();
		String ordertypeId = productDto.getOrdertypeId();

		Response<GoodsBrandModel> resp = brandService.findBrandByName(brandName, ordertypeId);
		GoodsBrandModel goodsBrandModel = resp == null? null :resp.getResult();
		if (null != goodsBrandModel && null != goodsBrandModel.getId()) {
			brandId = goodsBrandModel.getId();
		} else {
			response.setError("无效的品牌");
			response.setResult(Boolean.FALSE);
			return;
		}

		// 对Json进行格式化校验
		String attribute = productModel.getAttribute();
		String json = formatAttribute(attribute, response);

		// 属性格式化
		if (null == json) {
			response.setError("属性格式化失败");
			response.setResult(Boolean.FALSE);
			return;
		}

		// 初始化 产品信息
		productModel.setGoodsBrandId(brandId);
		if (null == productModel.getOrdertypeId()) {
			productModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG); // 业务类型代码YG：广发JF：积分
		}
		productModel.setStatus(Contants.USEING_COMMON_STATUS_0); // 产品状态0启用1禁用
		productModel.setCreateType(Contants.CERATE_TYPE_ADMIN_0); // 创建类型0平台创建1自动创建
		productModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标识0未删除1已删除
		productModel.setCreateOper(user.getName());
		productModel.setAttribute(json);
		// 创建产品insert方法
		Boolean result = productManager.createProduct(productModel);
		if (!result) {
			response.setError("updateProduct.error");
		} else {
			// 添加成功
			backCategoriesService.changeCount(productModel.getBackCategory3Id(), 1L);
		}
		response.setResult(result);
	}

	/**
	 * 更新
	 *
	 * @param response
	 * @param productDto
	 * @param user
	 * @author zhoupeng
	 */
	private void updateProduct(Response<Boolean> response, ProductDto productDto, User user) {
		// 查询
		ProductModel productModel = productDao.findById(productDto.getId());

		if (null == productModel || "1".equals(productModel.getDelFlag())) {
			response.setError("无法更新一个无效的产品");
			response.setResult(Boolean.FALSE);
			return;
		}

		String attribute = productDto.getAttribute();
		String json = formatAttribute(attribute, response);

		// 更新产品名称
		productModel.setName(productDto.getName());
		// 更新企业名称
		productModel.setManufacturer(productDto.getManufacturer());
		// 更新属性
		productModel.setAttribute(json);
		// 更新产品添加更新人
		productModel.setModifyOper(user.getName());
		// 更新产品update方法
		Boolean result = productManager.editProduct(productModel);
		productInfoCache.invalidate(productModel.getId());
		if (!result) {
			response.setError("updateProduct.error");
		}
		response.setResult(result);
	}

	/**
	 * 产品 属性处理
	 *
	 * @param attribute
	 * @param response
	 * @return
	 * @author zhoupeng
	 */
	private String formatAttribute(String attribute, Response<Boolean> response) {
		ItemsAttributeDto itemsAttributeDto = jsonMapper.fromJson(attribute, ItemsAttributeDto.class);
		// 如果恶意更改json会返回null 直接抛异常
		if (itemsAttributeDto == null) {
			response.setError("fromJson ERROR");
			response.setResult(Boolean.FALSE);
			return null;
		}
		// 循环取出dto-skus-value下的lIST
		List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
		for (ItemsAttributeSkuDto sku : skus) {
			List<ItemAttributeDto> values = sku.getValues();
			if (values != null) {
				for (ItemAttributeDto value : values) {
					// 新增属性缺少key 取得名字不为空并且key为空的value
					if (value.getAttributeValueKey() == null && value.getAttributeValueName() != null) {
						// 得到该vaule的name
						String attributeName = value.getAttributeValueName();
						// 创建AttributeValue实例
						AttributeValue attributeValue = new AttributeValue();
						// 把name给实例
						attributeValue.setValue(attributeName);
						// 调用sevice返回该值得id
						Response<AttributeValue> attributeValueResponse = attributeValueService.create(attributeValue);
						// 得到attribute的Id并且返回给value
						Long attributeValueKey = attributeValueResponse.getResult().getId();
						value.setAttributeValueKey(attributeValueKey);
					}
				}
			}
		}
		// 格式化json
		return jsonMapper.toJson(itemsAttributeDto);
	}

	/**
	 * 产品名称重复校验
	 *
	 * @param name
	 * @return
	 */
	@Override
	public Response<Boolean> findByName(String name, Long id, Long backCategory3Id) {
		Response<Boolean> response = new Response<Boolean>();
		// id不为空为编辑操作
		if (id != null) {
			// 首先根据id取得当前产品的信息 获取产品名称
			ProductModel model = productDao.findById(id);
			String names = name.trim();
			// 对两个名字进行比较，若果相同就代表没有更改名字 不比校验，否则校验
			if (!names.equals(model.getName())) {
				// 创建model 参数set到model中
				ProductModel productModel = new ProductModel();
				productModel.setBackCategory3Id(backCategory3Id);
				productModel.setName(names);
				// 取得产品名称相同的条数 大于0代表有重复
				Long total = productDao.findByName(productModel);
				if (total != 0) {
					response.setResult(Boolean.FALSE);
				} else {
					response.setResult(Boolean.TRUE);
				}
			}
			// 新增操作
		} else {
			// 创建model 参数set到model中
			ProductModel productModel = new ProductModel();
			productModel.setBackCategory3Id(backCategory3Id);
			productModel.setName(name);
			// 取得产品名称相同的条数 大于0代表有重复
			Long total = productDao.findByName(productModel);
			if (total != 0) {
				response.setResult(Boolean.FALSE);
			} else {
				response.setResult(Boolean.TRUE);
			}
		}
		return response;
	}

	/**
	 * 检索产品列表
	 *
	 * @param productModel
	 * @return
	 */

	@Override
	public Response<List<ProductModel>> findProductList(ProductModel productModel) {
		Response<List<ProductModel>> productResponse = new Response<List<ProductModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		// 产品名称
		if (StringUtils.isNotEmpty(productModel.getName())) {
			paramMap.put("name", productModel.getName());
		}
		// 品牌ID
		if (productModel.getGoodsBrandId() != null) {
			paramMap.put("goodsBrandId", productModel.getGoodsBrandId());
		}
		// 后台类目123
		if (productModel.getBackCategory1Id() != null) {
			paramMap.put("backCategory1Id", productModel.getBackCategory1Id());
		}
		if (productModel.getBackCategory2Id() != null) {
			paramMap.put("backCategory2Id", productModel.getBackCategory2Id());
		}
		if (productModel.getBackCategory3Id() != null) {
			paramMap.put("backCategory3Id", productModel.getBackCategory3Id());
		}
		if (!Strings.isNullOrEmpty(productModel.getOrdertypeId())) {
			paramMap.put("ordertypeId", productModel.getOrdertypeId());
		}
		List<ProductModel> productList = productDao.findProductList(paramMap);
		productResponse.setResult(productList);
		return productResponse;
	}

	/**
	 * 通过产品ID列表检索产品列表
	 *
	 * @param ids
	 * @return
	 */
	@Override
	public Response<List<ProductModel>> findByIds(List<Long> ids) {
		Response<List<ProductModel>> response = new Response<List<ProductModel>>();
		try {
			List<ProductModel> productModelList = productDao.findByIds(ids);
			response.setResult(productModelList);
		} catch (Exception e) {
			log.error("product.findByIds,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("product.findByIds.error");
		}
		return response;
	}

	public Response<ProductModel> findProductByName(String name) {
		Response<ProductModel> response = new Response<>();
		try {
			ProductModel productModel = productDao.findProductByName(name);
			response.setResult(productModel);
			return response;
		} catch (Exception e) {
			log.error("find.product.by.name,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("find.product.by.name.error");
			return response;
		}
	}

	/**
	 * 产品导入
	 *
	 * @return
	 * @throws Exception
	 */
	@Override
	public Response<List<UploadProductDto>> uploadProduct(List<UploadProductDto> details, String ordertypeId, User user)
			throws Exception {

		Response<List<UploadProductDto>> response = new Response<List<UploadProductDto>>();
		try {
			for (UploadProductDto product : details) {
				// 判断一级类目id是否存在
				Boolean exists = backCategoriesDao.exists(
						KeyUtil.entityId(BackCategory.class, Long.valueOf(product.getBackCategory1Id()).longValue()));
				if (exists) {
					// 判断是否为一级后台类目
					BackCategory backCategoryOne = backCategoriesDao
							.findById(Long.valueOf(product.getBackCategory1Id()));
					if (backCategoryOne.getParentId() == 0) {
						// 获取二级类目
						BackCategory current = backCategoriesDao.findById(Long.valueOf(product.getBackCategory2Id()));
						if (current != null) {
							// 判断二级类目父节点与一级类目节点是否相同，若相同，继续判断三级父节点和二级节点是否相同
							if (product.getBackCategory1Id().equals(current.getParentId())) {
								BackCategory backCategory = backCategoriesDao
										.findById(Long.valueOf(product.getBackCategory3Id()));
								if (backCategory != null) {
									if (product.getBackCategory2Id().equals(backCategory.getParentId())) {
										// 三级类目存在则校验品牌是否存在
										Map<String, Object> map = Maps.newHashMap();
										map.put("brandName", product.getBrandName());
										map.put("ordertypeId", ordertypeId);
										GoodsBrandModel goodsBrandModel = goodsBrandDao.findBrandIdByName(map);
										if (goodsBrandModel != null) {
											if (product.getBrandName().equals(goodsBrandModel.getBrandName())) {
												// 产品名称是正常字符
												if (isNormalChar(product.getName())) {
													ProductModel productModel = new ProductModel();
													productModel.setBackCategory1Id(
															Long.valueOf(product.getBackCategory1Id()));// 一级类目ID
													productModel.setBackCategory2Id(
															Long.valueOf(product.getBackCategory2Id()));// 二级类目ID
													productModel.setBackCategory3Id(
															Long.valueOf(product.getBackCategory3Id()));// 三级类目ID
													productModel.setGoodsBrandId(goodsBrandModel.getId());// 品牌id
													productModel.setOrdertypeId(ordertypeId); // 业务类型代码YG：广发JF：积分
													productModel.setName(product.getName());// 产品名称
													productModel.setStatus(Contants.USEING_COMMON_STATUS_0); // 产品状态0启用1禁用
													productModel.setCreateType(Contants.CERATE_TYPE_ADMIN_0); // 创建类型0平台创建1自动创建
													productModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标识0未删除1已删除
													productModel.setCreateOper(user.getName());
													// 判断产品名称是否重复
													Long total = productDao.findByName(productModel);
													if (total != 0) {
														product.setUploadFlag("失败");
														product.setUploadFailedReason("产品名称已存在");
													} else {
														// 创建产品insert方法
														Boolean result = productManager.createProduct(productModel);
														if (result) {
															product.setUploadFlag("成功");
														}
													}
												} else {
													product.setUploadFlag("失败");
													product.setUploadFailedReason("产品名称包含特殊字符");
												}
											} else {
												product.setUploadFlag("失败");
												product.setUploadFailedReason("品牌名称输入不正确");
											}
										} else {
											product.setUploadFlag("失败");
											product.setUploadFailedReason("品牌名称输入不正确");
										}
									} else {
										product.setUploadFlag("失败");
										product.setUploadFailedReason("三级类目id输入不正确");
									}
								} else {
									product.setUploadFlag("失败");
									product.setUploadFailedReason("三级类目id输入不正确");
								}
							} else {
								product.setUploadFlag("失败");
								product.setUploadFailedReason("二级类目id输入不正确");
							}
						} else {
							product.setUploadFlag("失败");
							product.setUploadFailedReason("二级后台类目输入不正确");
						}
					} else {
						product.setUploadFlag("失败");
						product.setUploadFailedReason("输入的ID不是一级后台类目");
					}
				} else {
					product.setUploadFlag("失败");
					product.setUploadFailedReason("一级类目id输入不正确");
				}
			}
		} catch (Exception e) {
			log.error("import.product.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("import.product.error");
			response.setResult(null);
			return response;
		}
		response.setResult(details);
		return response;
	}

	/**
	 * 判断产品名称是否包含特殊字符
	 *
	 * @param str
	 * @return
	 */
	private boolean isNormalChar(String str) {
		Pattern pattern = Pattern.compile("^([\\u4e00-\\u9fa5]+|[\\u4e00-\\u9fa5a-zA-Z_0-9]+)$");
		Matcher isNormalChar = pattern.matcher(str);
		if (!isNormalChar.matches()) {
			return false;
		}
		return true;
	}
}
