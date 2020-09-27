package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dao.*;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.manager.GoodsManager;
import cn.com.cgbchina.item.manager.PointPoolManager;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;

@Service
@Slf4j
public class GoodsServiceImpl implements GoodsService {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private GoodsBrandDao goodsBrandDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private ServicePromiseDao servicePromiseDao;
	@Resource
	private GoodsManager goodsManager;
	@Autowired
	private BackCategoriesService backCategoriesService;
	@Resource
	private VendorService vendorService;
	@Resource
	private AuditLoggingDao auditLoggingDao;
	@Autowired
	private MailStatesService mailStatesService;
	@Autowired
	private ItemService itemService;

	@Resource
	private PointPoolManager pointPoolManager;

	private static final String STICK_ITEM_00 = "00";
	private static final String STICK_ITEM_01 = "01";
	private static final String STICK_ITEM_02 = "02";
	private static final String APPROVE_TYPE_2 = "2";//审核类型标识:初审
	private static final String APPROVE_TYPE_3 = "3";//审核类型标识:复审
	private static final String APPROVE_TYPE_4 = "4";//审核类型标识:商品信息变更审核
	private static final String APPROVE_TYPE_5 = "5";//审核类型标识:价格变更审核
	private static final String APPROVE_TYPE_6 = "6";//审核类型标识:下架申请审核审核

	/**
	 * 广发商城商品管理分页查询商品列表
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @param goodsCode
	 * @param vendorName
	 * @param goodsName
	 * @param brandName
	 * @param backCategory1
	 * @param backCategory2
	 * @param backCategory3
	 * @param approveStatus
	 * @param channelMall
	 * @param channelCc
	 * @param channelMallWx
	 * @param channelCreditWx
	 * @param channelPhone
	 * @param channelApp
	 * @param channelSms
	 * @param installmentNumber
	 * @return
	 */
	@Override
	public Response<Pager<GoodsInfoDto>> findGoodsListByPage(Integer pageNo, Integer size, String type,
			String goodsCode, String vendorName, String goodsName, String brandName, String backCategory1,
			String backCategory2, String backCategory3, String approveStatus, String channelMall, String channelCc,
			String channelMallWx, String channelCreditWx, String channelPhone, String channelApp, String channelSms,
			Integer installmentNumber, User user) {
		Response<Pager<GoodsInfoDto>> result = new Response<Pager<GoodsInfoDto>>();
		// 将搜索条件封装成一个map传入dao层---start
		Map<String, Object> params = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		params.put("type", type);
		params.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
		// 商品编码
		if (!Strings.isNullOrEmpty(goodsCode)) {
			params.put("code", goodsCode);
		}
		// 供应商名称
		if (!Strings.isNullOrEmpty(vendorName)) {
			Response<List<String>> vendorResponse = vendorService.findIdByName(vendorName);
			if (vendorResponse.isSuccess()) {
				List<String> vendorIds = vendorResponse.getResult();
				params.put("vendorIds", vendorIds);
			}
		}
		// 商品名称
		if (!Strings.isNullOrEmpty(goodsName)) {
			params.put("name", goodsName);
		}
		// 品牌
		if (!Strings.isNullOrEmpty(brandName)) {
			List<Long> brandIds = goodsBrandDao.findBrandIdListByName(brandName);
			params.put("brandIds", brandIds);
		}
		// 123级后台类目
		if (!Strings.isNullOrEmpty(backCategory1)) {
			params.put("backCategoryId1", backCategory1);
		}
		if (!Strings.isNullOrEmpty(backCategory2)) {
			params.put("backCategoryId2", backCategory2);
		}
		if (!Strings.isNullOrEmpty(backCategory3)) {
			params.put("backCategoryId3", backCategory3);
		}
		// 审核状态
		if (!Strings.isNullOrEmpty(approveStatus)) {
			params.put("approveStatus", approveStatus);
		}
		// 广发商城状态
		if (!Strings.isNullOrEmpty(channelMall)) {
			params.put("channelMall", channelMall);
		}
		// CC状态
		if (!Strings.isNullOrEmpty(channelCc)) {
			params.put("channelCc", channelCc);
		}
		// 卡中心微信状态
		if (!Strings.isNullOrEmpty(channelCreditWx)) {
			params.put("channelCreditWx", channelCreditWx);
		}
		// 手机商城状态
		if (!Strings.isNullOrEmpty(channelPhone)) {
			params.put("channelPhone", channelPhone);
		}
		// APP状态
		if (!Strings.isNullOrEmpty(channelApp)) {
			params.put("channelApp", channelApp);
		}
		// 最高期数
		if (installmentNumber != null) {
			params.put("installmentNumber", installmentNumber);
		}
		// 广发微信状态
		if (!Strings.isNullOrEmpty(channelMallWx)) {
			params.put("channelMallWx", channelMallWx);
		}
		// 短信状态
		if (!Strings.isNullOrEmpty(channelSms)) {
			params.put("channelSms", channelSms);
		}
		// 供应商id（供应商平台查询条件）
		String vendorId = user.getVendorId();
		if (!Strings.isNullOrEmpty(vendorId)) {
			params.put("vendorId", vendorId);
		}
		// 将搜索条件封装成一个map传入dao层---end
		try {
			Pager<GoodsModel> pager = goodsDao.findByPage(params, pageInfo.getOffset(), pageInfo.getLimit());
			GoodsInfoDto goodsInfoDto = null;
			List<Long> backCategoryIdList = null;
			Response<List<BackCategory>> backCateResponse = null;
			List<BackCategory> backCategoryList = Lists.newArrayList();
			GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
			List<GoodsInfoDto> goodsInfoList = new ArrayList<GoodsInfoDto>();
			VendorInfoModel vendorInfoModel = new VendorInfoModel();
			Response<VendorInfoDto> vendorResponse = null;
			if (pager.getTotal() > 0) {
				List<GoodsModel> goodsList = pager.getData();
				// 将数据循环并加入品牌名称及后台类目信息，整合为goodsInfoList
				for (GoodsModel goodsModel : goodsList) {
					goodsInfoDto = new GoodsInfoDto();
					// 获取后台类目名称
					backCategoryIdList = Lists.newArrayList();
					backCategoryIdList.add(goodsModel.getBackCategory1Id());
					backCategoryIdList.add(goodsModel.getBackCategory2Id());
					backCategoryIdList.add(goodsModel.getBackCategory3Id());
					// 获取后台类目id所对应的信息list
					backCateResponse = backCategoriesService.findByIds(backCategoryIdList);
					if (backCateResponse.isSuccess()) {
						backCategoryList = backCateResponse.getResult();
						if (!Strings.isNullOrEmpty(backCategoryList.get(0).getName())) {
							goodsInfoDto.setBackCategory1Name(backCategoryList.get(0).getName());
						}
						if (!Strings.isNullOrEmpty(backCategoryList.get(1).getName())) {
							goodsInfoDto.setBackCategory2Name(backCategoryList.get(1).getName());
						}
						if (!Strings.isNullOrEmpty(backCategoryList.get(2).getName())) {
							goodsInfoDto.setBackCategory3Name(backCategoryList.get(2).getName());
						}
					}
					// 根据品牌id到品牌表中查询品牌信息，放入goodsInfoDto中
					goodsBrandModel = goodsBrandDao.findById(goodsModel.getGoodsBrandId());
					if (goodsBrandModel != null) {
						goodsInfoDto.setBrandName(goodsBrandModel.getBrandName());
					}
					// 根据vendorId查询vendor信息，放入goodsInfoDto中
					vendorResponse = vendorService.findById(goodsModel.getVendorId());
					if (vendorResponse.isSuccess()) {
						goodsInfoDto.setVendorName(vendorResponse.getResult().getSimpleName());
					}
					goodsInfoDto.setGoods(goodsModel);
					goodsInfoList.add(goodsInfoDto);
				}
				result.setResult(new Pager<GoodsInfoDto>(pager.getTotal(), goodsInfoList));
			} else {
				result.setResult(new Pager<GoodsInfoDto>(0L, Collections.<GoodsInfoDto> emptyList()));
			}
		} catch (Exception e) {
			log.error("find goods list error{}", Throwables.getStackTraceAsString(e));
			result.setError("find.goods.list.error");
		}
		return result;
	}

	/**
	 * 该方法绑定组件，其中用type区分是审核还是查看
	 *
	 * @param type
	 * @param goodsCode
	 * @return
	 */
	@Override
	public Response<GoodsDetailDto> findDetailByType(String type, String goodsCode) {
		Response<GoodsDetailDto> result = new Response<>();
		// type 用于区分是审核还是查看
		// 其中 type为 时是点击审核相关按钮进入，type为1是点击查看进入
		try {
			if ("1".equals(type)) {
				GoodsDetailDto goodsDetailDto = findGoodsDetail(goodsCode);
				result.setResult(goodsDetailDto);
			}else {
				GoodsDetailDto goodsDetailDto = examGoodsByCode(goodsCode);
				result.setResult(goodsDetailDto);
			}
		}catch (Exception e) {
			log.error("find goods detail view error{}", Throwables.getStackTraceAsString(e));
			result.setError("find.goods.detail.fail");
		}
		return result;
	}


	/**
	 * 点击审核时进入的查看方法
	 *
	 * @param goodsCode
	 * @return
	 */
	private GoodsDetailDto examGoodsByCode(String goodsCode) {
		GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
		// 取得商品信息
		GoodsModel goodsModel = goodsDao.findById(goodsCode);
		if (StringUtils.isNotEmpty(goodsModel.getApproveDifferent())) {
			GoodsDetailDto approveGoods = jsonMapper.fromJson(goodsModel.getApproveDifferent(), GoodsDetailDto.class);
			BeanMapper.copy(approveGoods, goodsDetailDto);
			String goodsAttr = approveGoods.getAttribute();
			ItemsAttributeDto goodsAttrs = jsonMapper.fromJson(goodsAttr, ItemsAttributeDto.class);
			goodsDetailDto.setGoodsAttr(goodsAttrs);
			// 供应商信息
			Response<VendorInfoDto> vendorResponse = vendorService.findById(goodsModel.getVendorId());
			if (vendorResponse.isSuccess()) {
				VendorInfoDto vendorInfoDto = new VendorInfoDto();
				vendorInfoDto = vendorResponse.getResult();
				goodsDetailDto.setVendorName(vendorInfoDto.getSimpleName());
			}
			// 后台类目
			List<Long> backCategoryIdList = Lists.newArrayList();
			backCategoryIdList.add(goodsModel.getBackCategory1Id());
			backCategoryIdList.add(goodsModel.getBackCategory2Id());
			backCategoryIdList.add(goodsModel.getBackCategory3Id());
			Response<List<BackCategory>> backCategoryRespone = backCategoriesService.findByIds(backCategoryIdList);
			if (backCategoryRespone.isSuccess()) {
				List<BackCategory> backCategoryList = backCategoryRespone.getResult();
				if (StringUtils.isNotEmpty(backCategoryList.get(0).getName())) {
					goodsDetailDto.setBackCategory1Name(backCategoryList.get(0).getName());
				}
				if (StringUtils.isNotEmpty(backCategoryList.get(1).getName())) {
					goodsDetailDto.setBackCategory2Name(backCategoryList.get(1).getName());
				}
				if (StringUtils.isNotEmpty(backCategoryList.get(2).getName())) {
					goodsDetailDto.setBackCategory3Name(backCategoryList.get(2).getName());
				}
			}
			// 品牌
			GoodsBrandModel brand = goodsBrandDao.findBrandInfoById(goodsModel.getGoodsBrandId());
			goodsDetailDto.setBrandName(brand.getBrandName());
			// 商品名称
			goodsDetailDto.setName(approveGoods.getName());
			// 生产厂家
			goodsDetailDto.setManufacturer(approveGoods.getManufacturer());

			List<ItemModel> itemModelList = approveGoods.getItemList();
			List<ItemDto> itemDtoList = Lists.newArrayList();
			ItemDto itemDto = null;
			String attribute = "";
			ItemsAttributeDto itemsAttributeDto = null;
			for (ItemModel itemModel : itemModelList) {
				// 处理单品相关的基本信息
				itemDto = new ItemDto();
				itemDto.setItemModel(itemModel);
				// 处理单品相关的销售属性信息
				attribute = itemModel.getAttribute();
				if (StringUtils.isNotEmpty(attribute)) {
					itemsAttributeDto = new ItemsAttributeDto();
					itemsAttributeDto = jsonMapper.fromJson(attribute, ItemsAttributeDto.class);
					itemDto.setItemsAttributeDto(itemsAttributeDto);
					goodsDetailDto.setItemsAttributeDto(itemsAttributeDto);
				}
				itemDtoList.add(itemDto);
			}
			goodsDetailDto.setItemDtoList(itemDtoList);
			// 服务承诺
			// 到service_promise表中查询现在系统中所有的服务承诺信息
			List<ServicePromiseModel> servicePromiseModelList = servicePromiseDao.findAll();
			List<String> goodsServicePromise = Lists.newArrayList();
			ServicePromiseIsSelectDto selectDto = null;
			List<ServicePromiseIsSelectDto> selectList = Lists.newArrayList();
			// 将goods表中该商品的服务承诺数据与所有信息比较，返回selectList
			if (goodsModel.getServiceType() != null) {
				goodsServicePromise = Splitter.on(',').trimResults().splitToList(goodsModel.getServiceType());
				for (ServicePromiseModel servicePromiseModel : servicePromiseModelList) {
					selectDto = new ServicePromiseIsSelectDto();
					for (int i = 0; i < goodsServicePromise.size(); i++) {
						if (goodsServicePromise.get(i).equals(servicePromiseModel.getCode().toString())) {
							selectDto.setIsSelected(Boolean.TRUE);
						}
					}
					selectDto.setCode(servicePromiseModel.getCode());
					selectDto.setName(servicePromiseModel.getName());
					selectList.add(selectDto);
				}
			}
			goodsDetailDto.setServicePromiseIsSelectList(selectList);

			// 推荐关联单品
			List<RecommendGoodsDto> recommendGoodsList = Lists.newArrayList();
			if (StringUtils.isNotEmpty(goodsDetailDto.getRecommendGoods1Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsDetailDto.getRecommendGoods1Code()).getResult());
			}
			if (StringUtils.isNotEmpty(goodsDetailDto.getRecommendGoods2Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsDetailDto.getRecommendGoods2Code()).getResult());
			}
			if (StringUtils.isNotEmpty(goodsDetailDto.getRecommendGoods3Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsDetailDto.getRecommendGoods3Code()).getResult());
			}
			goodsDetailDto.setRecommendGoodsList(recommendGoodsList);

			// 操作履历,审核
			List<AuditLoggingModel> auditLoggingModelList = auditLoggingDao.findByOuterId(goodsCode);
			goodsDetailDto.setAuditLoggingModelList(auditLoggingModelList);

		} else {
			goodsDetailDto = findGoodsDetail(goodsCode);
		}
		// 商品编码
		goodsDetailDto.setCode(goodsCode);
		return goodsDetailDto;
	}

	/**
	 * 查找新增商品时所需的基本信息
	 *
	 * @return
	 */
	@Override
	public Response<GoodsDetailDto> findCreateGoods(User user) {
		Response<GoodsDetailDto> response = new Response<>();
		GoodsDetailDto goodsDetailDto = new GoodsDetailDto();

		try {
			// 供应商list
			List<VendorInfoModel> vendorInfoModelList = Lists.newArrayList();
			VendorInfoModel vendorInfoModel = new VendorInfoModel();
			vendorInfoModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);
			Response<List<VendorInfoModel>> vendorResponse = vendorService.findAll(vendorInfoModel);
			if (vendorResponse.isSuccess()) {
				vendorInfoModelList = vendorResponse.getResult();
			}
			// 品牌list
			List<GoodsBrandModel> brandList = goodsBrandDao.findAll();
			// 邮购分期类别码list
			String vendorId = user.getVendorId();
			if (!Strings.isNullOrEmpty(vendorId)) {
				Response<List<MailStagesModel>> listResponse = mailStatesService.findMailStagesListByVendorId(vendorId);
				if (listResponse.isSuccess()) {
					goodsDetailDto.setMailStagesList(listResponse.getResult());
				}
			}
			// 服务承诺
			List<ServicePromiseModel> servicePromiseModelList = servicePromiseDao.findAll();
			goodsDetailDto.setVendorInfoList(vendorInfoModelList);
			goodsDetailDto.setBrandList(brandList);
			goodsDetailDto.setServicePromiseModelList(servicePromiseModelList);
			response.setResult(goodsDetailDto);
		} catch (Exception e) {
			log.error("find goods create detail error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.good.detail.error");
		}
		return response;
	}

	/**
	 * 查看商品详细信息
	 *
	 * @param goodsCode
	 * @return
	 */
	private GoodsDetailDto findGoodsDetail(String goodsCode) {
		GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
		Response<List<BackCategory>> backCategoryRespone = null;
		List<BackCategory> backCategoryList = Lists.newArrayList();
		GoodsModel goodsModel = goodsDao.findById(goodsCode);
		if (goodsModel != null) {
			// 供应商信息
			Response<VendorInfoDto> vendorResponse = vendorService.findById(goodsModel.getVendorId());
			if (vendorResponse.isSuccess()) {
				VendorInfoDto vendorInfoDto = new VendorInfoDto();
				vendorInfoDto = vendorResponse.getResult();
				goodsDetailDto.setVendorName(vendorInfoDto.getSimpleName());
			}
			// 后台类目
			List<Long> backCategoryIdList = Lists.newArrayList();
			backCategoryIdList.add(goodsModel.getBackCategory1Id());
			backCategoryIdList.add(goodsModel.getBackCategory2Id());
			backCategoryIdList.add(goodsModel.getBackCategory3Id());
			backCategoryRespone = backCategoriesService.findByIds(backCategoryIdList);
			if (backCategoryRespone.isSuccess()) {
				backCategoryList = backCategoryRespone.getResult();
				if (StringUtils.isNotEmpty(backCategoryList.get(0).getName())) {
					goodsDetailDto.setBackCategory1Name(backCategoryList.get(0).getName());
				}
				if (StringUtils.isNotEmpty(backCategoryList.get(1).getName())) {
					goodsDetailDto.setBackCategory2Name(backCategoryList.get(1).getName());
				}
				if (StringUtils.isNotEmpty(backCategoryList.get(2).getName())) {
					goodsDetailDto.setBackCategory3Name(backCategoryList.get(2).getName());
				}
			}
			// 品牌
			GoodsBrandModel brand = goodsBrandDao.findBrandInfoById(goodsModel.getGoodsBrandId());
			// 生产厂家
			goodsDetailDto.setManufacturer(goodsModel.getManufacturer());
			// 商品其他属性,根据goods表中的attribute字段读取出
			if (StringUtils.isNotEmpty(goodsModel.getAttribute())) {
				ItemsAttributeDto goodsAttr = new ItemsAttributeDto();
				goodsAttr = jsonMapper.fromJson(goodsModel.getAttribute(), ItemsAttributeDto.class);
				goodsDetailDto.setGoodsAttr(goodsAttr);
			}
			// 邮购分期类别码
			Response<List<MailStagesModel>> listResponse = mailStatesService
					.findMailStagesListByVendorId(goodsModel.getVendorId());
			if (listResponse.isSuccess()) {
				goodsDetailDto.setMailStagesList(listResponse.getResult());
			}
			// 单品表格 最后返回的为itemDtoList
			// 单品信息、单品销售属性信息
			// 根据商品编码查出对应的itemModelList
			List<ItemModel> itemModelList = itemDao.findItemDetailByGoodCode(goodsCode);
			ItemsAttributeDto itemsAttributeDto = null;// 用于存放与单品属性相关的DTO
			List<ItemDto> itemDtoList = Lists.newArrayList();// 用于存放最后返回页面的数据
			ItemDto itemDto = null;
			String attribute = null;
			// 对查出的itemModelList进行循环
			for (ItemModel itemModel : itemModelList) {
				// 处理单品相关的基本信息
				itemDto = new ItemDto();
				itemDto.setItemModel(itemModel);
				// 处理单品相关的销售属性信息
				attribute = itemModel.getAttribute();
				if (StringUtils.isNotEmpty(attribute)) {
					itemsAttributeDto = new ItemsAttributeDto();
					itemsAttributeDto = jsonMapper.fromJson(attribute, ItemsAttributeDto.class);
					itemDto.setItemsAttributeDto(itemsAttributeDto);
					goodsDetailDto.setItemsAttributeDto(itemsAttributeDto);
				}
				itemDtoList.add(itemDto);
			}
			goodsDetailDto.setItemDtoList(itemDtoList);
			// 服务承诺
			// 到service_promise表中查询现在系统中所有的服务承诺信息
			List<ServicePromiseModel> servicePromiseModelList = servicePromiseDao.findAll();
			List<String> goodsServicePromise = Lists.newArrayList();
			ServicePromiseIsSelectDto selectDto = null;
			List<ServicePromiseIsSelectDto> selectList = Lists.newArrayList();
			// 将goods表中该商品的服务承诺数据与所有信息比较，返回selectList
			if (goodsModel.getServiceType() != null) {
				goodsServicePromise = Splitter.on(',').trimResults().splitToList(goodsModel.getServiceType());
				for (ServicePromiseModel servicePromiseModel : servicePromiseModelList) {
					selectDto = new ServicePromiseIsSelectDto();
					for (int i = 0; i < goodsServicePromise.size(); i++) {
						if (goodsServicePromise.get(i).equals(servicePromiseModel.getCode().toString())) {
							selectDto.setIsSelected(Boolean.TRUE);
						}
					}
					selectDto.setCode(servicePromiseModel.getCode());
					selectDto.setName(servicePromiseModel.getName());
					selectList.add(selectDto);
				}
			}
			goodsDetailDto.setServicePromiseIsSelectList(selectList);
			// 对关联商品处进行处理
			List<RecommendGoodsDto> recommendGoodsList = Lists.newArrayList();
			if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods1Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods1Code()).getResult());
			}
			if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods2Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods2Code()).getResult());
			}
			if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods3Code())) {
				recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods3Code()).getResult());
			}
			goodsDetailDto.setRecommendGoodsList(recommendGoodsList);

			// 操作履历,审核
			List<AuditLoggingModel> auditLoggingModelList = auditLoggingDao.findByOuterId(goodsCode);
			goodsDetailDto.setAuditLoggingModelList(auditLoggingModelList);
			// 组合拼装数据进行页面显示
			goodsDetailDto.setBrandName(brand.getBrandName());
			BeanMapper.copy(goodsModel, goodsDetailDto);
		}
		return goodsDetailDto;

	}

	/**
	 * 新增商品
	 *
	 * @param goodsDetailDto
	 * @return
	 */
	@Override
	public Response<Boolean> createGoods(GoodsDetailDto goodsDetailDto, User user) {
		Response<Boolean> response = new Response<>();
		try {
			goodsManager.createGoods(goodsDetailDto, user);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("insert goods error{}", Throwables.getStackTraceAsString(e));
			response.setError("insert.goods.fail");
		}
		return response;
	}

	/**
	 * 更新单品信息
	 *
	 * @param itemModel
	 * @return
	 */
	@Override
	public Response<Integer> updateItemDetail(ItemModel itemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(itemModel, "itemModel is null");
			Integer count = goodsManager.updateItemDetail(itemModel);
			response.setResult(count);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update item detail error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}

	/**
	 * 更新商品上下架信息
	 *
	 * @param goodsModel
	 * @return
	 */
	@Override
	public Response<Integer> updateGoodsShelf(GoodsModel goodsModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(goodsModel, "goodsModel is null");
			Integer count = goodsManager.updateGoodsShelf(goodsModel);
			response.setResult(count);
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update goods shelf error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.goods.shelf.error");
		}
		return response;
	}

	/**
	 * 更新商品状态
	 *
	 * @param goodsModel
	 * @return
	 */
	@Override
	public Response<Integer> updataGdInfo(GoodsModel goodsModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(goodsModel, "goodsModel is Null");
			Integer count = goodsManager.updateGoodsInfo(goodsModel);
			response.setResult(count);
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update goods info error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.goods.error");
		}
		return response;
	}

	/**
	 * 根据供应商ID下架该供应商下所有渠道的所有商品
	 *
	 * @param vendorId
	 * @return
	 */
	@Override
	public Response<Boolean> updateChannelByVendorId(String vendorId) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			checkNotNull(vendorId, "vendorId is Null");
			Integer count = goodsManager.updateChannelByVendorId(vendorId);
			if (count < 0) {
				response.setResult(false);
				return response;
			} else {
				response.setResult(true);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update goods channel by vendro error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.goods.error");
		}
		return response;
	}

	/**
	 * 更新商品和单品信息
	 *
	 * @param goodsDetailDto
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> updataGoodsDetail(GoodsDetailDto goodsDetailDto, User user) {
		// 校验
		Response<Boolean> response = new Response<Boolean>();
		try {
			goodsManager.updataGoods(goodsDetailDto, user);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("update goods and item detail error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.goods.error");
		}
		return response;
	}

	/**
	 * 根据商品编码List查询商品list
	 *
	 * @param goodsCodes
	 * @return
	 */
	@Override
	public Response<List<GoodsModel>> findByCodes(List<String> goodsCodes) {
		Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
		try {
			List<GoodsModel> goodsModelList = goodsDao.findByCodes(goodsCodes);
			response.setResult(goodsModelList);
		} catch (Exception e) {
			log.error("find goods list by code list error{}", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.goods.error");
		}
		return response;
	}

	@Override
	public Response<Boolean> examGoods(String goodsCode, String approveType, String approveResult, String approveMemo,
			User user) {
		Response<Boolean> result = new Response<>();
		try {
			goodsManager.examGoods(goodsCode, approveType, approveResult, approveMemo, user);
			result.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("exam goods error{}", Throwables.getStackTraceAsString(e));
			result.setError("exam.goods.error");
		}
		return result;
	}

	/**
	 * 批量更新商品状态
	 *
	 * @param goodsBatchDtoList
	 * @return
	 */
	@Override
	public Response<Integer> updateAllGoodsStatus(List<GoodsBatchDto> goodsBatchDtoList) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(goodsBatchDtoList, "goodsModelList is Null");
			for (GoodsBatchDto goodsBatchDto : goodsBatchDtoList) {
				if (Contants.GOODS_APPROVE_STATUS_01.equals(goodsBatchDto.getApproveStatus())) {
					goodsBatchDto.setApproveStatus(APPROVE_TYPE_2);
				} else if (Contants.GOODS_APPROVE_STATUS_02.equals(goodsBatchDto.getApproveStatus())) {
					goodsBatchDto.setApproveStatus(APPROVE_TYPE_3);
				} else if (Contants.GOODS_APPROVE_STATUS_03.equals(goodsBatchDto.getApproveStatus())) {
					goodsBatchDto.setApproveStatus(APPROVE_TYPE_4);
				} else if (Contants.GOODS_APPROVE_STATUS_04.equals(goodsBatchDto.getApproveStatus())) {
					goodsBatchDto.setApproveStatus(APPROVE_TYPE_5);
				} else if (Contants.GOODS_APPROVE_STATUS_05.equals(goodsBatchDto.getApproveStatus())) {
					goodsBatchDto.setApproveStatus(APPROVE_TYPE_6);
				}
				goodsManager.examGoods(goodsBatchDto.getCode(), goodsBatchDto.getApproveStatus(),
						goodsBatchDto.getOperate(), goodsBatchDto.getMemo(), goodsBatchDto.getUser());
			}
			response.setResult(1);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.all.goods.status.error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.all.goods.status.error");
		}
		return response;
	}

	/**
	 * 申请下架
	 *
	 * @param goodsmodel
	 * @return
	 */
	@Override
	public Response<Boolean> shelvesApply(GoodsModel goodsmodel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 调用接口
			Integer result = goodsManager.updateGoodsInfo(goodsmodel);
			if (result <= 0) {
				response.setError("update.error");
				return response;
			}

			response.setResult(true);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("approve.to.put.down.shelf.error{}", Throwables.getStackTraceAsString(e));
			response.setError("approve.to.put.down.shelf.error");
			return response;
		}
	}

	/**
	 * 查询全部商品 供特殊积分倍率使用
	 *
	 * @return
	 */
	public Response<List<GoodsModel>> findAllGoods(String searchKey) {
		Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!StringUtils.isEmpty(searchKey)) {
			paramMap.put("searchKey", searchKey);
		}
		try {
			response.setResult(goodsDao.findAll(paramMap));
			return response;
		} catch (Exception e) {
			log.error("find goods list error", Throwables.getStackTraceAsString(e));
			response.setError("find.goods.list.error");
			return response;
		}
	}

	/**
	 * 根据商品编码查询商品情报
	 *
	 * @param goodsCode
	 * @return
	 */
	@Override
	public Response<GoodsModel> findById(String goodsCode) {
		Response<GoodsModel> response = new Response<GoodsModel>();
		try {
			response.setResult(goodsDao.findById(goodsCode));
			return response;
		} catch (Exception e) {
			log.error("find.goods.by.goods.code.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.goods.error");
			return response;
		}

	}

	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param itemCode
	 * @return
	 */
	@Override
	public Response<RecommendGoodsDto> findItemInfoByItemCode(String itemCode) {
		Response<RecommendGoodsDto> response = new Response<RecommendGoodsDto>();
		RecommendGoodsDto recommendItem = new RecommendGoodsDto();
		ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
		try {
			// 根据单品编码取得单品信息
			ItemModel itemModel = itemDao.findItemDetailByCode(itemCode);
			if (itemModel != null) {
				itemsAttributeDto = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
				if (itemsAttributeDto != null) {
					List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
					// 根据商品编码取得商品信息
					GoodsModel recommendGoods = goodsDao.findById(itemModel.getGoodsCode());
					// 单品描述
					StringBuffer sb = new StringBuffer();
					sb.append(recommendGoods.getName());
					for (ItemsAttributeSkuDto sku : skus) {
						sb.append(sku.getValues().get(0).getAttributeValueName());
					}
					// 单品信息设定
					recommendItem.setGoodsName(sb.toString());
					recommendItem.setMaxPrice(itemModel.getPrice());
					recommendItem.setImg(itemModel.getImage1());
					recommendItem.setItemCode(itemModel.getCode());
				}
			}
			response.setResult(recommendItem);
			return response;
		} catch (Exception e) {
			log.error("find recommend item error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.recommedn.item.error");
			return response;
		}
	}

	/**
	 * 根据类目，商品名称查询产品信息
	 *
	 * @param goodsmodel
	 * @return
	 */
	@Override
	public Response<List<ItemDto>> findbyGoodsNameLike(GoodsModel goodsmodel) {
		Response<List<ItemDto>> response = new Response<List<ItemDto>>();
		List<ItemModel> itemList = new ArrayList<ItemModel>();
		List<ItemDto> model = new ArrayList<ItemDto>();
		List<String> code = new ArrayList<String>();
		try {
			List<String> codeList = goodsDao.findGoodsByGoodsNameLike(goodsmodel);
			// 按取得的商品CODE列表取得单品列表
			if (codeList != null && codeList.size() != 0) {
				itemList = itemDao.findItemListByGoodsCodeList(codeList);
				ItemsAttributeDto itemsAttributeDto = null;// 用于存放与单品属性相关的DTO
				ItemDto itemDto = null;
				// 对查出的itemModelList进行循环
				for (ItemModel itemModel : itemList) {
					String itemDescription = null;
					String a = null;
					// 处理单品相关的销售属性信息
					if (StringUtils.isNotEmpty(itemModel.getAttribute())) {
						itemsAttributeDto = new ItemsAttributeDto();
						itemDto = new ItemDto();
						itemsAttributeDto = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
						itemDto.setItemsAttributeDto(itemsAttributeDto);
						itemDto.setItemModel(itemModel);
						GoodsModel goodsName = goodsDao.findById(itemModel.getGoodsCode());
						if (goodsName != null) {
							itemDescription = goodsName.getName() + " ";
						}
						for (int i = 0; i < itemsAttributeDto.getSkus().size(); i++) {
							a = itemsAttributeDto.getSkus().get(i).getValues().get(0).getAttributeValueName();
							itemDescription += a + " ";
						}
						itemDto.setItemDescription(itemDescription);
					}
					model.add(itemDto);
				}
			}
			response.setResult(model);
		} catch (Exception e) {
			log.error("find goods list error", Throwables.getStackTraceAsString(e));
			response.setError("find.goods.list.error");
			return response;
		}
		return response;
	}

	/**
	 * 判断单品是否可以置顶
	 *
	 * @param goodCode
	 * @return add by liuhan
	 */
	@Override
	public Response<String> findGoodsByItemCode(String goodCode) {
		Response<String> response = new Response<String>();
		try {
			// 调用接口
			GoodsModel goodsModel = goodsDao.findById(goodCode);
			if (!Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())
					&& !Contants.CHANNEL_CC_02.equals(goodsModel.getChannelCc())
					&& !Contants.CHANNEL_MALL_WX_02.equals(goodsModel.getChannelMallWx())
					&& !Contants.CHANNEL_PHONE_02.equals(goodsModel.getChannelPhone())
					&& !Contants.CHANNEL_APP_02.equals(goodsModel.getChannelApp())
					&& !Contants.CHANNEL_SMS_02.equals(goodsModel.getChannelSms())) {
				response.setResult(STICK_ITEM_01);
			} else if (Contants.IS_INNER_0.equals(goodsModel.getIsInner())) {
				response.setResult(STICK_ITEM_02);
			} else {
				response.setResult(STICK_ITEM_00);
			}
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("select.error", Throwables.getStackTraceAsString(e));
			response.setError("select.error");
			return response;
		}

	}

	/**
	 * 根据产品id查询商品（产品用）
	 *
	 * @param productId
	 * @return
	 * @author :tanliang
	 * @time:2016-6-20
	 */
	@Override
	public Response<List<GoodsModel>> findGoodsByProductId(Long productId) {
		Response<List<GoodsModel>> result = new Response<List<GoodsModel>>();
		try {
			result.setResult(goodsDao.findGoodsByProductId(productId));
		} catch (Exception e) {
			log.error("find.goods.byproduct.error", Throwables.getStackTraceAsString(e));
			result.setError("find.goods.byproduct.error");
		}
		return result;
	}

	/**
	 * 根据指定条件查询单品、商品列表（活动用）
	 *
	 * @param promGoodsParamDto 参数
	 * @return
	 */
	@Override
	public Response<List<ItemPromDto>> findItemsListForProm(PromGoodsParamDto promGoodsParamDto, User user) {
		if (promGoodsParamDto == null) {
			promGoodsParamDto = new PromGoodsParamDto();
		}
		Response<List<ItemPromDto>> result = new Response<List<ItemPromDto>>();
		List<String> ruledOutList = new ArrayList<String>();
		if (StringUtils.isNotEmpty(promGoodsParamDto.getRuledOut())) {
			ruledOutList = Splitter.on(',').omitEmptyStrings().trimResults()
					.splitToList(promGoodsParamDto.getRuledOut());
		}

		// 将搜索条件封装成一个map传入dao层---start
		Map<String, Object> params = Maps.newHashMap();
		// 指定供应商
		if (StringUtils.isNotEmpty(promGoodsParamDto.getVendorId())) {
			params.put("vendorIds", promGoodsParamDto.getVendorId());
		} else { // 内管平台操作，不指定供应商
			// 供应商名称
			if (!Strings.isNullOrEmpty(promGoodsParamDto.getVendorName())) {
				Response<List<String>> vendorResponse = vendorService.findIdByName(promGoodsParamDto.getVendorName());
				if (vendorResponse.isSuccess()) {
					List<String> vendorIds = vendorResponse.getResult();
					String strVendorId = "";
					for (String id : vendorIds) {
						if (StringUtils.isNotEmpty(strVendorId)) {
							strVendorId = strVendorId + ",";
						}
						strVendorId = strVendorId + id.trim();
					}
					params.put("vendorIds", strVendorId.trim());
				}
			}
		}
		// 商品名称
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getGoodsName())) {
			params.put("name", promGoodsParamDto.getGoodsName());
		}
		// 品牌
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getBrandName())) {
			List<Long> brandIds = goodsBrandDao.findBrandIdListByName(promGoodsParamDto.getBrandName());
			String strBrandIds = "";
			for (Long id : brandIds) {
				if (StringUtils.isNotEmpty(strBrandIds)) {
					strBrandIds = strBrandIds + ",";
				}
				strBrandIds = strBrandIds + id.toString().trim();
			}
			params.put("brandIds", strBrandIds.trim());
		}
		// 123级后台类目
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getBackCategory1())) {
			params.put("backCategory1Id", promGoodsParamDto.getBackCategory1());
		}
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getBackCategory2())) {
			params.put("backCategory2Id", promGoodsParamDto.getBackCategory2());
		}
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getBackCategory3())) {
			params.put("backCategory3Id", promGoodsParamDto.getBackCategory3());
		}
		if (!Strings.isNullOrEmpty(promGoodsParamDto.getCount())) {
			params.put("count", Integer.valueOf(promGoodsParamDto.getCount().trim()));
		}
		// 将搜索条件封装成一个map传入dao层---end
		try {
			List<GoodsModel> goodsList = goodsDao.findGoodsListByGoodsNameLikeForProm(params);

			ItemPromDto itemPromDto = null;
			List<ItemDto> itemList = new ArrayList<ItemDto>();
			List<Long> backCategoryIdList = null;
			Response<List<BackCategory>> backCateResponse = null;
			List<BackCategory> backCategoryList = Lists.newArrayList();
			GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
			List<ItemPromDto> itemPromInfoList = new ArrayList<ItemPromDto>();
			Response<VendorInfoDto> vendorResponse = null;
			if (goodsList != null && goodsList.size() > 0) {
				// 将数据循环并加入品牌名称及后台类目信息，整合为goodsInfoList
				for (GoodsModel goodsModel : goodsList) {

					List<String> goodsCodeList = new ArrayList<String>();
					goodsCodeList.add(goodsModel.getCode());
					Response<List<ItemDto>> itemResponse = itemService.findItemListByCodeOrName(goodsModel.getCode());
					if (itemResponse.isSuccess()) {
						itemList = itemResponse.getResult();
					}
					for (ItemDto itemDto : itemList) {

						if (StringUtils.isNotEmpty(promGoodsParamDto.getCount())
								&& itemPromInfoList.size() >= Integer.valueOf(promGoodsParamDto.getCount().trim())) {
							break;
						}
						// 除去已选择单品
						if (itemDto.getItemModel() != null && ruledOutList.contains(itemDto.getItemModel().getCode())) {
							break;
						}
						itemPromDto = new ItemPromDto();
						if (itemDto.getItemModel() != null) {
							// 单品CODE
							itemPromDto.setItemCode(itemDto.getItemModel().getCode());
							itemPromDto.setPrice(itemDto.getItemModel().getPrice());
							itemPromDto.setStock(itemDto.getItemModel().getStock());
						}
						// 商品名+单品属性 （单品描述）
						itemPromDto.setGoodsName(itemDto.getItemDescription());
						// 获取后台类目名称
						backCategoryIdList = Lists.newArrayList();
						backCategoryIdList.add(goodsModel.getBackCategory1Id());
						backCategoryIdList.add(goodsModel.getBackCategory2Id());
						backCategoryIdList.add(goodsModel.getBackCategory3Id());
						// 获取后台类目id所对应的信息list
						backCateResponse = backCategoriesService.findByIds(backCategoryIdList);
						if (backCateResponse.isSuccess()) {
							backCategoryList = backCateResponse.getResult();
							if (!Strings.isNullOrEmpty(backCategoryList.get(0).getName())) {
								itemPromDto.setBackCategory1Name(backCategoryList.get(0).getName());
							}
							if (!Strings.isNullOrEmpty(backCategoryList.get(1).getName())) {
								itemPromDto.setBackCategory2Name(backCategoryList.get(1).getName());
							}
							if (!Strings.isNullOrEmpty(backCategoryList.get(2).getName())) {
								itemPromDto.setBackCategory3Name(backCategoryList.get(2).getName());
							}
						}
						// 根据品牌id到品牌表中查询品牌信息，放入goodsInfoDto中
						goodsBrandModel = goodsBrandDao.findById(goodsModel.getGoodsBrandId());
						if (goodsBrandModel != null) {
							itemPromDto.setGoodsBrandName(goodsBrandModel.getBrandName());
						}
						// 根据vendorId查询vendor信息，放入goodsInfoDto中
						vendorResponse = vendorService.findById(goodsModel.getVendorId());
						if (vendorResponse.isSuccess()) {
							itemPromDto.setVendorName(vendorResponse.getResult().getSimpleName());
						}
						itemPromInfoList.add(itemPromDto);
					}
				}
				result.setResult(itemPromInfoList);
			} else {
				result.setResult(new ArrayList<ItemPromDto>());
			}
		} catch (Exception e) {
			log.error("find.goods.list.error", Throwables.getStackTraceAsString(e));
			result.setError("find.goods.list.error");
		}
		return result;
	}

	public void updateGoodsJF(String goodsId, Long num) {
		ItemModel goodsModel = new ItemModel();
		goodsModel.setCode(goodsId);
		goodsModel.setStock(num);
		itemDao.updateGoodsJF(goodsModel);
	}

	public void updateGoodsYG(String goodsId, Long num) {
		ItemModel goodsModel = new ItemModel();
		goodsModel.setCode(goodsId);
		goodsModel.setStock(num);
		itemDao.updateGoodsYG(goodsModel);
	}

	/**
	 * 回滚积分池
	 * 
	 * @param usedPoint
	 * @param createDate
	 */
	public void dealPointPoolForDate(Long usedPoint, Date createDate) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("used_point", usedPoint);
		paramMap.put("create_time", DateHelper.getyyyyMM(createDate));
		pointPoolManager.dealPointPoolForDate(paramMap);
	}

	/**
	 * 导入商品数据的insert
	 * 
	 * @param goodsItemDto
	 * @return
	 */
	@Override
	public Response<GoodsAndItemCodeDto> importGoodsData(GoodsItemDto goodsItemDto, User user) {
		Response<GoodsAndItemCodeDto> result = new Response<>();
		try {
			GoodsAndItemCodeDto goodsAndItemCodeDto = goodsManager.importGoodsData(goodsItemDto, user);
			result.setResult(goodsAndItemCodeDto);
			return result;
		} catch (Exception e) {
			log.error("import.goods.list.error", Throwables.getStackTraceAsString(e));
			result.setError("import.goods.list.error");
		}
		return result;
	}

	/**
	 * 返回单品信息
	 * 
	 * @param goodsId
	 * @return
	 */
	@Override
	public ItemModel findItemInfoById(String goodsId) {
		ItemModel itemModel = itemDao.findById(goodsId);
		return itemModel;
	}

	/**
	 * 返回商品信息
	 * 
	 * @param goodsCode
	 * @return
	 */
	@Override
	public GoodsModel findGoodsInfoById(String goodsCode) {
		GoodsModel goodsModel = goodsDao.findById(goodsCode);
		return goodsModel;
	}

	/**
	 * 更新实际库存
	 *
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<Integer> updateStock(String goodsId) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = itemDao.updateStock(goodsId);
			if (count > 0) {
				response.setResult(count);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.item.error", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}

	/**
	 *
	 * @return
	 */
	public Response<Boolean> submitGoodsToApprove(GoodsDetailDto goodsDetailDto, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			goodsManager.submitGoodsToApprove(goodsDetailDto, user);
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("submit.goods.to.approve.error{}", Throwables.getStackTraceAsString(e));
			response.setError("submit.goods.to.approve.error");
			return response;
		}
	}

}
