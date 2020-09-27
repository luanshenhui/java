package cn.com.cgbchina.item.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.stereotype.Service;

import com.google.common.base.Optional;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PinYinHelper;
import cn.com.cgbchina.item.dao.BrandAuthorizeDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.dto.UploadBrandsDto;
import cn.com.cgbchina.item.manager.BrandManager;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by Liuhan on 16-4-13.
 */
@Slf4j
@Service
public class BrandServiceImpl implements BrandService {

	@Resource
	private GoodsBrandDao goodsBrandDao;// 品牌表
	@Resource
	private BrandAuthorizeDao brandAuthorizeDao;// 品牌授权表
	@Resource
	private BrandManager brandManager;// 业务处理
	@Resource
	private VendorService vendorService; // 供应商

	// 本地缓存--------------------------ADD by TanLiang----------------Start-----------
	// 定义本地缓存（根据品牌品牌名称取得品牌信息）
	private final LoadingCache<String, Optional<GoodsBrandModel>> goodsBrandCache;
	// 定义本地缓存（根据品牌id称取得品牌信息）
	private final LoadingCache<Long, GoodsBrandModel> brandInfoCache;
	// 定义本地缓存（查询品牌授权信息）
	private final LoadingCache<Map<String, Object>, Pager<BrandAuthorizeModel>> brandAuthorizeCache;
	private final static String SUCCESS_FLAG_Y = "成功";
	private final static String SUCCESS_FLAG_N = "失败";

	// 声明缓存
	public BrandServiceImpl() {
		// 生成本地缓存信息（品牌信息表）
		goodsBrandCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<GoodsBrandModel>>() {
					@Override
					public Optional<GoodsBrandModel> load(String brandName) throws Exception {
						Map<String, Object> map = Maps.newHashMap();
						map.put("brandName", brandName);
						return Optional.fromNullable(goodsBrandDao.findBrandIdByName(map));
					}
				});
		// 生成本地缓存信息（品牌信息表）
		brandInfoCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Long, GoodsBrandModel>() {
					@Override
					public GoodsBrandModel load(Long id) throws Exception {
						return goodsBrandDao.findBrandInfoById(id);
					}
				});
		// 生成本地缓存信息 查询品牌授权信息
		brandAuthorizeCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Map<String, Object>, Pager<BrandAuthorizeModel>>() {
					@Override
					public Pager<BrandAuthorizeModel> load(Map<String, Object> map) throws Exception {
						return brandAuthorizeDao.findByPageQuery((Map) map.get("paramMap"), (Integer) map.get("offset"),
								(Integer) map.get("limit"));
					}
				});
	}

	// 品牌信息表缓存信息共通方法(通过名字查询)
	private GoodsBrandModel findBrandInfoByCache(String brandName) {
		// 取得品牌的缓存信息
		Optional<GoodsBrandModel> goodsBrandModelCache = goodsBrandCache.getUnchecked(brandName);
		// 如果缓存存在赋值给model
		if (goodsBrandModelCache.isPresent()) {
			return goodsBrandModelCache.get();
		}
		return null;
	}

	// 品牌信息表缓存信息共通方法(通过id查询)
	private GoodsBrandModel findBranByIdCache(Long id) {
		// 取得品牌的缓存信息
		GoodsBrandModel goodsBrandModel = brandInfoCache.getUnchecked(id);
		// 如果缓存存在赋值给model
		if (goodsBrandModel != null) {
			return goodsBrandModel;
		}
		return null;
	}
	// 本地缓存--------------------------ADD by TanLiang----------------end-----------

	/**
	 * 添加品牌授权
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	@Override
	public Response<Long> create(BrandAuthorizeDto brandAuthorizeModel, User user) {
		Response<Long> response = new Response<Long>();
		try {

			// 添加品牌授权表信息
			BrandAuthorizeModel newBrandAuthorizeModel = new BrandAuthorizeModel();
			// GoodsBrandId为-1时，表示品牌不存在
			newBrandAuthorizeModel.setGoodsBrandId(brandAuthorizeModel.getGoodsBrandId());
			newBrandAuthorizeModel.setBrandName(brandAuthorizeModel.getBrandName());
			newBrandAuthorizeModel.setBrandImage(brandAuthorizeModel.getBrandImage());
			newBrandAuthorizeModel.setBrandStatus(Contants.USEING_COMMON_STATUS_0);
			newBrandAuthorizeModel.setApproveState(Contants.BRAND_APPROVE_STATUS_00);
			if (brandAuthorizeModel.getV_startTime() != null) {
				newBrandAuthorizeModel.setStartTime(
						DateHelper.string2Date(brandAuthorizeModel.getV_startTime(), DateHelper.YYYY_MM_DD));
			}
			if (brandAuthorizeModel.getV_endTime() != null) {
				newBrandAuthorizeModel
						.setEndTime(DateHelper.string2Date(brandAuthorizeModel.getV_endTime(), DateHelper.YYYY_MM_DD));
			}
			newBrandAuthorizeModel.setBrandAuthorizeImage(brandAuthorizeModel.getBrandAuthorizeImage());
			if (user.getVendorId() != null) {
				newBrandAuthorizeModel.setVendorId(user.getVendorId());
			}
			newBrandAuthorizeModel.setDelFlag(Contants.DEL_FLAG_0);
			newBrandAuthorizeModel.setCreateOper(user.getName());
			newBrandAuthorizeModel.setModifyOper(user.getName());
			newBrandAuthorizeModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
			// 添加品牌授权
			Long result = brandManager.create(newBrandAuthorizeModel, user);
			if (result == 0l) {
				// 使缓存失效
				goodsBrandCache.invalidateAll();
				brandInfoCache.invalidateAll();
				brandAuthorizeCache.invalidateAll();
			}
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("insert.brandAuthorizeModel.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.brandAuthorizeModel.error");
			return response;
		}
	}

	/**
	 * 修改品牌/审核通过，拒绝
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(BrandAuthorizeDto brandAuthorizeModel, User user, String orderType) {
		// 实例化返回Response
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 品牌授权表
			brandAuthorizeModel.setBrandStatus(Contants.USEING_COMMON_STATUS_0);
			if (brandAuthorizeModel.getV_startTime() != null) {
				brandAuthorizeModel.setStartTime(
						DateHelper.string2Date(brandAuthorizeModel.getV_startTime(), DateHelper.YYYY_MM_DD));
			}
			if (brandAuthorizeModel.getV_endTime() != null) {
				brandAuthorizeModel
						.setEndTime(DateHelper.string2Date(brandAuthorizeModel.getV_endTime(), DateHelper.YYYY_MM_DD));
			}
			brandAuthorizeModel.setDelFlag(Contants.DEL_FLAG_0);
			brandAuthorizeModel.setModifyOper(user.getName());
			// 修改品牌/审核通过，拒绝
			Boolean result = brandManager.update(brandAuthorizeModel, orderType);
			if (result) {
				// 使缓存失效
				goodsBrandCache.invalidateAll();
				brandInfoCache.invalidateAll();
				brandAuthorizeCache.invalidateAll();
				response.setResult(Boolean.TRUE);
				response.setSuccess(Boolean.TRUE);
				return response;
			} else {
				response.setError("update.brandAuthorizeModel.error");
				return response;
			}
		} catch (IllegalArgumentException e) {
			log.error("update.brandAuthorizeModel.error", Throwables.getStackTraceAsString(e));
			response.setError("update.brandAuthorizeModel.error");
			return response;
		} catch (Exception e) {
			log.error("update.brandAuthorizeModel.error", Throwables.getStackTraceAsString(e));
			response.setError("update.brandAuthorizeModel.error");
			return response;
		}
	}

	/**
	 * 查找所有品牌授权信息
	 *
	 * @param pageNo
	 * @param size
	 * @param status
	 * @param createTime
	 * @param brandName
	 * @param brandImage
	 * @param vendorName
	 * @param approveState
	 * @param endTime
	 * @return
	 */
	@Override
	public Response<Pager<BrandAuthorizeDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
												   @Param("type") String status, @Param("createTime") String createTime, @Param("brandName") String brandName,
												   @Param("brandImage") String brandImage, @Param("vendorName") String vendorName,
												   @Param("approveState") String approveState, @Param("endTime") String endTime,
												   @Param("v_startTime") String v_startTime, @Param("v_endTime") String v_endTime,
												   @Param("v_startModifyTime") String v_startModifyTime, @Param("v_endModifyTime") String v_endModifyTime,
												   @Param("orderType") String orderType, @Param("user") User user) {

		// 实例化返回Response
		Response<Pager<BrandAuthorizeDto>> response = new Response<Pager<BrandAuthorizeDto>>();
		List<BrandAuthorizeDto> brandAuthorizeDtoList = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			String vendorId = user.getVendorId();
			// 查询条件
			paramMap.put("offset", pageInfo.getOffset());
			paramMap.put("limit", pageInfo.getLimit());
			if (StringUtils.isNotEmpty(vendorId)) {
				paramMap.put("vendorId", vendorId);
			}
			// 根据前台传值，判断sql查询条件
			if (StringUtils.isNotEmpty(status)) {
				paramMap.put("status", status);
			}
			if (StringUtils.isNotEmpty(orderType)) {
				paramMap.put("orderType", orderType);
			}
			if (StringUtils.isNotEmpty(createTime)) {
				paramMap.put("createTime", createTime);
			}
			if (StringUtils.isNotEmpty(brandName)) {
				paramMap.put("brandName", brandName);
			}
			if (StringUtils.isNotEmpty(brandImage)) {
				paramMap.put("brandImage", brandImage);
			}
			if (StringUtils.isNotEmpty(vendorName)) {
				// 实例化list
				List<String> vendorIds = Lists.newArrayList();
				// 根据供应商名称，查询供应商ID。
				Response<List<String>> vendorResponse = vendorService.findIdByName(vendorName);
				// 判断vendorResponse是否存在
				if (vendorResponse.isSuccess()) {
					vendorIds = vendorResponse.getResult();
					paramMap.put("vendorIds", vendorIds);
				}
			}
			if (StringUtils.isNotEmpty(approveState)) {
				paramMap.put("approveState", approveState);
			}
			if (StringUtils.isNotEmpty(endTime)) {
				paramMap.put("endTime", endTime);
			}
			if (StringUtils.isNotEmpty(v_startTime)) {
				paramMap.put("v_startTime", v_startTime);
			}
			if (StringUtils.isNotEmpty(v_endTime)) {
				paramMap.put("v_endTime", v_endTime);
			}
			if (StringUtils.isNotEmpty(v_startModifyTime)) {
				paramMap.put("v_startModifyTime", v_startModifyTime);
			}
			if (StringUtils.isNotEmpty(v_endModifyTime)) {
				paramMap.put("v_endModifyTime", v_endModifyTime);
			}
			Map<String, Object> queryMap = Maps.newHashMap();
			queryMap.put("paramMap", paramMap);
			queryMap.put("offset", pageInfo.getOffset());
			queryMap.put("limit", pageInfo.getLimit());
			queryMap.putAll(paramMap);
			// 查找所有品牌信息
			// Pager<BrandAuthorizeModel> pager = brandAuthorizeCache.getUnchecked(queryMap);
			Pager<BrandAuthorizeModel> pager = brandAuthorizeDao.findByPageQuery(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());

			// 查找所有品牌信息
			// Pager<BrandAuthorizeModel> pager = brandAuthorizeDao.findByPageQuery(paramMap, pageInfo.getOffset(),
			// pageInfo.getLimit());
			// 查询信息存在的情况下
			if (pager.getTotal() > 0) {
				// 获取pager的每一行信息
				List<BrandAuthorizeModel> brandAuthorizeList = pager.getData();
				List<String> vendorIdList = new ArrayList<String>();
				for (BrandAuthorizeModel brandAuthorizeModel : brandAuthorizeList) {
					// 如果供应商id不为空
					if (brandAuthorizeModel.getVendorId() != null) {
						vendorIdList.add(brandAuthorizeModel.getVendorId());
					}
				}
				Response<List<VendorInfoDto>> vendorResponse = vendorService
						.findByListId(vendorIdList);
				for (BrandAuthorizeModel brandAuthorizeModel : brandAuthorizeList) {
					BrandAuthorizeDto brandAuthorizeDto = new BrandAuthorizeDto();
					BeanMapper.copy(brandAuthorizeModel, brandAuthorizeDto);
					for (VendorInfoDto vendorInfoDto : vendorResponse.getResult()) {
						if(brandAuthorizeModel.getVendorId()!=null&&brandAuthorizeModel.getVendorId().equals(vendorInfoDto.getVendorId())){
							brandAuthorizeDto.setSimpleName(vendorInfoDto.getSimpleName());
							break;
						}
					}
					brandAuthorizeDtoList.add(brandAuthorizeDto);
				}
			}
			response.setResult(new Pager<BrandAuthorizeDto>(pager.getTotal(), brandAuthorizeDtoList));
			return response;
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			response.setError("brand.query.error");
			return response;
		}
	}

	/**
	 * 查找所有品牌信息
	 *
	 * @param pageNo
	 * @param size
	 * @param status
	 * @param brandName
	 * @return
	 */
	@Override
	public Response<Pager<GoodsBrandModel>> findBrandAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
														 @Param("type") String status, @Param("brandName") String brandName,
														 @Param("brandInforStatus") String brandInforStatus, @Param("user") User user,
														 @Param("orderType") String orderType) {

		// 实例化返回Response
		Response<Pager<GoodsBrandModel>> response = new Response<Pager<GoodsBrandModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		List<GoodsBrandModel> goodsBrandModelList = Lists.newArrayList();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			// 查询条件
			paramMap.put("offset", pageInfo.getOffset());
			paramMap.put("limit", pageInfo.getLimit());
			// 根据前台传值，判断sql查询条件
			if (!Strings.isNullOrEmpty(status)) {
				paramMap.put("status", status);
			}
			// 区分广发和积分
			if (!Strings.isNullOrEmpty(orderType)) {
				paramMap.put("ordertypeId", orderType);
			}
			if (!Strings.isNullOrEmpty(brandName)) {
				paramMap.put("brandName", brandName);
			}
			if (!Strings.isNullOrEmpty(brandInforStatus)) {
				paramMap.put("brandInforStatus", brandInforStatus);
			}
			// 查找所有品牌信息
			Pager<GoodsBrandModel> pager = goodsBrandDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			// 查询信息存在的情况下
			if (pager.getTotal() > 0) {
				List<GoodsBrandModel> goodsBrandList = pager.getData();
				for (GoodsBrandModel goodsBrand : goodsBrandList) {
					// 实例化BrandAuthorizeDto
					GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
					// copy给dto
					BeanMapper.copy(goodsBrand, goodsBrandModel);
					// 放到list里
					goodsBrandModelList.add(goodsBrandModel);
				}
			}
			response.setResult(new Pager<GoodsBrandModel>(pager.getTotal(), goodsBrandModelList));
			return response;
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			response.setError("brand.query.error");
			return response;
		}
	}

	/**
	 * 通过品牌名称查询品牌
	 *
	 * @param brandName
	 * @param ordertypeId 业务id YG 广发，JF 积分
	 * @return
	 */
	@Override
	public Response<GoodsBrandModel> findBrandByName(String brandName,String ordertypeId) {
		Response<GoodsBrandModel> result = new Response<>();
		Map<String, Object> map = Maps.newHashMap();

		// 实例化品牌
		GoodsBrandModel goodsBrand = new GoodsBrandModel();
		// 通过品牌名称查询品牌
		try {
			map.put("brandName", brandName);
			map.put("ordertypeId", ordertypeId);

			goodsBrand = goodsBrandDao.findBrandIdByName(map);
			result.setResult(goodsBrand);
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			result.setError("brand.query.error");
		}
		return result;
	}

	/**
	 * 校验品牌名称
	 *
	 * @param brandName,businessType
	 * @return
	 */
	@Override
	public Response<GoodsBrandModel> checkBrandName(String brandName, String businessType) {
		Response<GoodsBrandModel> result = new Response<>();
		try {
			GoodsBrandModel goodsBrands = new GoodsBrandModel();
			goodsBrands.setBrandName(brandName);
			goodsBrands.setOrdertypeId(businessType);
			GoodsBrandModel goodsBrand = goodsBrandDao.checkBrandName(goodsBrands);
			result.setResult(goodsBrand);
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			result.setError("brand.query.error");
		}
		return result;
	}

	/**
	 * 取得所有品牌的名字
	 *
	 * @return
	 * @Add by tanliang
	 */
	@Override
	public Response<List<String>> findBrandNameAll() {
		// 创建实例对象
		Response<List<String>> response = new Response<List<String>>();
		// 取得品牌表的数据
		List<GoodsBrandModel> goodsBrandModelList = goodsBrandDao.findAll();
		List<String> list = new ArrayList<String>();
		// 循环取出品牌名，依次add
		if (goodsBrandModelList.size() > 0) {
			for (GoodsBrandModel goodsBrandModelModel : goodsBrandModelList) {
				list.add(goodsBrandModelModel.getBrandName());
			}
		}
		response.setResult(list);
		return response;
	}

	/**
	 * find查找需要审核的品牌的个数 add by zhangcheng
	 *
	 * @return
	 */
	@Override
	public Response<Long> findBrandCount(Map<String, Object> paramMap) {
		Response<Long> result = new Response<Long>();
		// 实例化需要审核的品牌数，默认0
		Long brandCount = 0l;
		try {
			// BRAND_APPROVE_STATUS_00 待审核状态
			// 从数据库中查询
//			brandCount = brandAuthorizeDao.findBrandCount();
			brandCount = goodsBrandDao.findBrandCountByParam(paramMap);
			result.setResult(brandCount);
		} catch (Exception e) {
			log.error("find.brand.count.error", Throwables.getStackTraceAsString(e));
			result.setError("find.brand.count.error");
		}
		return result;
	}

	/**
	 * 查询所有品牌的名字和品牌模糊查询（产品用）
	 *
	 * @param ordertypeId 业务区分字段 YG 广发，JF 积分
	 * @return
	 * @Add by tanliang
	 */
	@Override
	public Response<Pager<GoodsBrandModel>> findBrandByParam(String brandName, String ordertypeId, Integer pageNo,
															 Integer size) {
		// 创建实例对象
		Response<Pager<GoodsBrandModel>> response = new Response<Pager<GoodsBrandModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		if (StringUtils.isNotEmpty(brandName)) {
			paramMap.put("brandName", brandName);
		}
		if (StringUtils.isNotEmpty(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		PageInfo pageInfo = new PageInfo(pageNo, size);
		paramMap.put("offset", pageInfo.getOffset());
		paramMap.put("limit", pageInfo.getLimit());
		// 只检索品牌表已经通过通过审的数据 01审核通过
		paramMap.put("brandInforStatus", Contants.BRAND_APPROVE_STATUS_01);
		try {
			// 取得品牌表的数据
			Pager<GoodsBrandModel> pager = goodsBrandDao.findByPages(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			if (pager.getTotal() == 0) {
				response.setResult(new Pager<>(0L, Collections.<GoodsBrandModel> emptyList()));
				return response;
			}
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("select.brandName.error", Throwables.getStackTraceAsString(e));
			response.setError("select.brandName.error");
			return response;
		}
	}

	/**
	 * 通过品牌id查询品牌信息
	 *
	 * @param id
	 * @return
	 * @add by tanliang
	 * @time 2016-5-19
	 */
	@Override
	public Response<GoodsBrandModel> findBrandInfoById(Long id) {
		Response<GoodsBrandModel> response = new Response<GoodsBrandModel>();
		GoodsBrandModel goodsBrand = new GoodsBrandModel();
		// 通过品牌id查询品牌
		try {
			// 从缓存中取得品牌信息
			goodsBrand = findBranByIdCache(id);
			response.setResult(goodsBrand);
			return response;
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			response.setError("select.brandName.error");
			return response;
		}
	}

	@Override
	public Response<List<GoodsBrandModel>> findByIds(List<Long> ids) {
		Response<List<GoodsBrandModel>> result = new Response<List<GoodsBrandModel>>();
		if (ids == null || ids.size() == 0) {
			result.setResult(Collections.<GoodsBrandModel> emptyList());
			return result;
		}
		try {
			List<GoodsBrandModel> brandModelList = goodsBrandDao.findByIds(ids);
			if (brandModelList != null && brandModelList.size() > 0) {
				result.setResult(brandModelList);
				return result;
			}
			result.setResult(Collections.<GoodsBrandModel> emptyList());
			return result;
		} catch (Exception e) {
			log.error("find.brankList.error", Throwables.getStackTraceAsString(e));
			result.setResult(Collections.<GoodsBrandModel> emptyList());
			return result;
		}
	}

	@Override
	public Response<List<GoodsBrandModel>> findBrandList() {
		// TODO 假的先写着
		Response<List<GoodsBrandModel>> response = new Response<List<GoodsBrandModel>>();
		List<GoodsBrandModel> goodsBrandModelList = new ArrayList<GoodsBrandModel>();
		Map<String, Object> paramMap = Maps.newHashMap();
		try {
			// 查找所有品牌信息
			Pager<GoodsBrandModel> pager = goodsBrandDao.findByPage(paramMap, 0, 15);
			// 查询信息存在的情况下
			if (pager.getTotal() > 0) {
				goodsBrandModelList = pager.getData();
				response.setResult(goodsBrandModelList);
			}
			return response;
		} catch (Exception e) {
			log.error("brand.query.error", Throwables.getStackTraceAsString(e));
			response.setError("brand.query.error");
			return response;
		}
	}

	/**
	 * 查找所有可用品牌信息
	 *
	 * @return
	 */
	@Override
	public Response<List<GoodsBrandModel>> findAllBrands() {
		Response<List<GoodsBrandModel>> result = new Response<>();
		try {
			List<GoodsBrandModel> brandList = goodsBrandDao.findAll();
			result.setResult(brandList);
		} catch (Exception e) {
			log.error("find.all.brands.error", Throwables.getStackTraceAsString(e));
			result.setError("find.all.brands.error");
		}
		return result;
	}

	/**
	 * 查询所有品牌信息（供应商新增商品时用）
	 *
	 * @return
	 * @Add by chenle
	 */
	public Response<List<BrandAuthorizeModel>> findBrandListForVendor(String vendorId, String brandName,String ordertypeId) {
		// 根据供应商id查询该供应商可用的品牌信息
		Response<List<BrandAuthorizeModel>> result = new Response<>();
		Map<String, Object> params = Maps.newHashMap();
		params.put("vendorId", vendorId);
		if (!Strings.isNullOrEmpty(brandName)) {
			params.put("brandName", brandName);
		}
		if(!Strings.isNullOrEmpty(ordertypeId)){
			params.put("ordertypeId",ordertypeId);
		}
		try {
			List<BrandAuthorizeModel> brandsList = brandAuthorizeDao.findBrandListForVendor(params);
			result.setResult(brandsList);
		} catch (Exception e) {
			log.error("find.all.brands.error", Throwables.getStackTraceAsString(e));
			result.setError("find.all.brands.error");
		}
		return result;
	}

	/**
	 * 根据品牌名称模糊查询品牌list
	 *
	 * @param brandName
	 * @return
	 * @Add by chenle
	 */
	public Response<List<GoodsBrandModel>> findBrandListByName(String brandName) {
		Response<List<GoodsBrandModel>> result = new Response<>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("brandName", brandName);
		try {
			List<GoodsBrandModel> brandList = goodsBrandDao.findBrandListByName(paramMap);
			result.setResult(brandList);
		} catch (Exception e) {
			log.error("find.all.brands.error", Throwables.getStackTraceAsString(e));
			result.setError("find.all.brands.error");
		}
		return result;
	}

	/**
	 * 查找所有可用品牌信息 供特殊积分倍率使用
	 *
	 * @return
	 */
	@Override
	public Response<List<GoodsBrandModel>> findAllBrandsSpecial(String brandName) {
		Response<List<GoodsBrandModel>> result = new Response<>();
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!StringUtils.isEmpty(brandName)) {
			paramMap.put("brandName", brandName);
		}
		try {
			List<GoodsBrandModel> brandList = goodsBrandDao.findAllBrandsSpecial(paramMap);
			result.setResult(brandList);
		} catch (Exception e) {
			log.error("find.all.brands.error", Throwables.getStackTraceAsString(e));
			result.setError("find.all.brands.error");
		}
		return result;
	}

	@Override
	public Response<Boolean> createBrandInfo(GoodsBrandModel goodsBrandModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			// 校验参数
			checkArgument(notNull(goodsBrandModel.getBrandName()), "brand.name.not.empty");
			brandManager.createBrandInfo(goodsBrandModel);
			goodsBrandCache.invalidateAll();
			brandInfoCache.invalidateAll();
			brandAuthorizeCache.invalidateAll();
			result.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("brand create error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("brand.create.error");
		}
		return result;
	}

	@Override
	public Response<Boolean> updateBrandInfo(GoodsBrandModel goodsBrandModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			boolean updateStatus = brandManager.updateBrandInfo(goodsBrandModel);
			goodsBrandCache.invalidateAll();
			brandInfoCache.invalidateAll();
			brandAuthorizeCache.invalidateAll();
			result.setResult(updateStatus);
		} catch (Exception e) {
			log.error("brand update error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("brand.update.error");
		}
		return result;
	}

	@Override
	public Response<Boolean> findIsAuthroizeByName(String brandName, String orderType) {
		Response<Boolean> result = new Response<>();
		try {
			BrandAuthorizeModel brandModel = brandAuthorizeDao.findIsAuthroizeByName(brandName, orderType);
			if (brandModel == null) {
				result.setResult(Boolean.TRUE);
			} else {
				result.setResult(Boolean.FALSE);
			}
		} catch (Exception e) {
			log.error("brand find error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("brand.find.error");
		}
		return result;
	}

	@Override
	public Response<Boolean> deleteBrandInfo(Long id) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			brandManager.deleteBrandInfo(id);
			goodsBrandCache.invalidateAll();
			brandInfoCache.invalidateAll();
			brandAuthorizeCache.invalidateAll();
			result.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("brand delete error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("brand.delete.error");
		}
		return result;
	}

	@Override
	public Response<BrandAuthorizeModel> findBrandAuthorizeById(Long id) {
		Response<BrandAuthorizeModel> response = new Response<>();
		try {
			BrandAuthorizeModel brandAuthorizeModel = brandAuthorizeDao.findById(id);
			response.setResult(brandAuthorizeModel);
		} catch (Exception e) {
			log.error("brand authorize find error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("brand.authorize.find.error");
		}
		return response;
	}

	/**
	 * 品牌导入
	 *
	 * @param models
	 * @return
	 */
	public Response<List<UploadBrandsDto>> uploadBrands(List<UploadBrandsDto> models, User user, String ordertypeId) {
		Response<List<UploadBrandsDto>> result = new Response<List<UploadBrandsDto>>();
		List<UploadBrandsDto> resultList = Lists.newArrayList();
		for (UploadBrandsDto dto : models) {
			GoodsBrandModel temp = new GoodsBrandModel();
			temp.setBrandName(dto.getBrandName());
			temp.setOrdertypeId(ordertypeId);
			GoodsBrandModel goodsBrand = null;
			try{
				goodsBrand = goodsBrandDao.checkBrandName(temp);
			}catch (Exception e){
				dto.setUploadFlag("失败");
				dto.setUploadFailedReason("数据访问异常");
				resultList.add(dto);
				continue;
			}
			if (goodsBrand == null) {
				GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
				goodsBrandModel.setOrdertypeId(dto.getOrdertypeId());
				goodsBrandModel.setBrandName(dto.getBrandName());
				goodsBrandModel.setDelFlag(Contants.DEL_FLAG_0);
				goodsBrandModel.setCreateOper(user.getName());
				goodsBrandModel.setModifyOper(user.getName());
				goodsBrandModel.setPublishStatus(Contants.BRAND_PUBLIST_STATUS_00);
				goodsBrandModel.setBrandInforStatus(Contants.BRAND_APPROVE_STATUS_00);
				goodsBrandModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
				goodsBrandModel.setInitial(PinYinHelper.getAllFirstSpell(dto.getBrandName()));
				goodsBrandModel.setSpell(PinYinHelper.getPingYin(dto.getBrandName()));
				Response<Boolean> results = createBrandInfo(goodsBrandModel);
				if(results.isSuccess()){
					dto.setUploadFlag("成功");
					resultList.add(dto);
				}else{
					dto.setUploadFlag("失败");
					dto.setUploadFailedReason("品牌插入失败");
					resultList.add(dto);
				}
			} else {
				if ("00".equals(goodsBrand.getBrandInforStatus())) {
					dto.setUploadFlag("失败");
					dto.setUploadFailedReason("审核状态存在");
					resultList.add(dto);
				}
				if ("01".equals(goodsBrand.getBrandInforStatus())) {
					dto.setUploadFlag("失败");
					dto.setUploadFailedReason("品牌存在");
					resultList.add(dto);
				}
			}
		}
		result.setResult(resultList);
		return result;
	}


	/**
	 * 判断文件是否存在.
	 *
	 * @param fileDir 文件路径
	 * @return
	 */
	private boolean fileExist(String fileDir) {
		boolean flag = false;
		File file = new File(fileDir);
		flag = file.exists();
		return flag;
	}

	/**
	 * 删除文件.
	 *
	 * @param fileDir 文件路径
	 * @return
	 */
	private boolean deleteExcel(String fileDir) {
		boolean flag = false;
		File file = new File(fileDir);
		// 判断目录或文件是否存在
		if (!file.exists()) { // 不存在返回 false
			return flag;
		} else {
			// 判断是否为文件
			if (file.isFile()) { // 为文件时调用删除文件方法
				file.delete();
				flag = true;
			}
		}
		return flag;
	}

	public Response<Boolean> findBrandAuthorizeByVendorId(String brandName, String vendorId) {
		Response<Boolean> response = new Response<>();
		try {
			BrandAuthorizeModel brandAuthorizeModel = brandAuthorizeDao.findBrandAuthorizeByVendorId(brandName,
					vendorId);
			if (brandAuthorizeModel != null) {
				response.setResult(Boolean.TRUE);
			} else {
				response.setResult(Boolean.FALSE);
			}
		} catch (Exception e) {
			log.error("find.brand.authorize.by.vendorId.fail", Throwables.getStackTraceAsString(e));
			response.setError("find.brand.authorize.by.vendorId.fail");
		}
		return response;
	}
}
