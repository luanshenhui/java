/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.item.service.GoodsService;
import com.spirit.search.Pair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.related.dao.CouponInfDao;
import cn.com.cgbchina.related.manager.CouponInfManager;
import cn.com.cgbchina.related.model.CouponInfModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-21.
 */
@Service
@Slf4j
public class CouPonInfServiceImpl implements CouPonInfService {

	@Resource
	private CouponInfDao couponInfDao;
	@Resource
	private CouponInfManager couponInfManager;
	@Autowired
	private GoodsService goodsService;



	/**
	 * 获取首次登录优惠卷信息
	 * 
	 * @return
	 */
	@Override
	public Response<CouponInfModel> findByFirstLogin() {
		try {
			Response<CouponInfModel> response = new Response<CouponInfModel>();
			// 获取首次登录设置的优惠券
			CouponInfModel couponInfModel = couponInfDao.findByFirstLogin();
			// 是否有设置
			if (couponInfModel == null) {
				response.setSuccess(false);
			} else {
				response.setResult(couponInfModel);
				response.setSuccess(true);
			}

			return response;
		} catch (Exception e) {
			log.error("find.fist.coupon.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "find.fist.coupon.error");
		}

	}

	/**
	 * 我的优惠券，详细
	 * 
	 * @param projectNO
	 * @return
	 */
	@Override
	public Response<List<String>> detailedCoupon(String projectNO) {
		try {
			Response<List<String>> response = new Response<List<String>>();

			List<String> range = new ArrayList<String>();
			// 我的优惠券，详细
			CouponInfModel couponInfModel = couponInfDao.findByCouponId(projectNO);

			if (couponInfModel != null) {
				if (StringUtils.isEmpty(couponInfModel.getBackCategoryId())
						&& StringUtils.isEmpty(couponInfModel.getVendorId())
						&& StringUtils.isEmpty(couponInfModel.getBrandId())
						&& StringUtils.isEmpty(couponInfModel.getGoodsId())) {
					range.add("全场");
				}
				if (StringUtils.isNotEmpty(couponInfModel.getBackCategoryId())) {
					range.add("类目：" + couponInfModel.getBackCategoryNm());

				}
				if (StringUtils.isNotEmpty(couponInfModel.getVendorNms())) {
					range.add("合作商：" + couponInfModel.getVendorNms());
				}
				if (StringUtils.isNotEmpty(couponInfModel.getBrandName())) {
					range.add("品牌：" + couponInfModel.getBrandName());
				}
				if (StringUtils.isNotEmpty(couponInfModel.getGoodsName())) {
					range.add("商品：" + couponInfModel.getGoodsName());
				}
			}

			response.setResult(range);

			return response;
		} catch (Exception e) {
			log.error("find.fist.coupon.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "find.fist.coupon.error");
		}
	}

	/**
	 * 分页取得列表
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<CouponInfModel>> findByPage(Integer pageNo, Integer size, String couponId, String couponNm) {
		Response<Pager<CouponInfModel>> result = new Response<Pager<CouponInfModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> param = Maps.newHashMap();
		try {
			param.put("delFlag", Contants.DEL_FLAG_0);
			if (StringUtils.isNotEmpty(couponId)) {
				param.put("couponId", couponId);
			}
			if (StringUtils.isNotEmpty(couponNm)) {
				param.put("couponNm", couponNm);
			}
			Pager<CouponInfModel> pager = couponInfDao.findByPage(param, pageInfo.getOffset(), pageInfo.getLimit());
			if (pager == null) {
				result.setResult(new Pager<CouponInfModel>(0L, Collections.<CouponInfModel> emptyList()));
				return result;
			}
			result.setResult(pager);
			result.setSuccess(true);
			return result;
		} catch (Exception e) {
			log.error("CouPonInfService.findByPage.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("CouPonInfService.findByPage.fail");
			return result;
		}
	}

	/**
	 * 根据ID查询
	 *
	 *
	 *
	 * @param id
	 * @return
	 */
	public Response<CouponInfModel> findById(String id) {
		Response<CouponInfModel> response = new Response<CouponInfModel>();
//		Map<String, Object> param = Maps.newHashMap();
		try {
			if ("".equals(id)) {
				response.setError("CouPonInfService.findById.fail");
				return response;
			}
			CouponInfModel couponInfModel = couponInfDao.findById(Integer.valueOf(id));
			response.setResult(couponInfModel);
			return response;
		} catch (Exception e) {
			log.error("CouPonInfService.findById.fail,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("CouPonInfService.findById.fail");
			return response;
		}
	}

	/**
	 * 根据ID查询
	 *
	 *
	 *
	 * @param couponId
	 * @return
	 */
	public Response<CouponInfModel> findByCouponId(String couponId) {
		Response<CouponInfModel> response = new Response<CouponInfModel>();
//		Map<String, Object> param = Maps.newHashMap();
		try {
			if ("".equals(couponId)) {
				response.setError("CouPonInfService.findById.fail");
				return response;
			}
			CouponInfModel couponInfModel = couponInfDao.findByCouponId(couponId);
			if (couponInfModel == null) {
				response.setSuccess(false);
				return response;
			}
			response.setResult(couponInfModel);
			return response;
		} catch (Exception e) {
			log.error("CouPonInfService.findByCouponId.fail,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("CouPonInfService.findByCouponId.fail");
			return response;
		}
	}

	/**
	 * 优惠券设置新增
	 * 
	 * @param couponInfModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(CouponInfModel couponInfModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			couponInfManager.update(couponInfModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), couponInfModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "couponInf.update.error");
		}
		return response;
	}

	/**
	 * 获取外部接口优惠券数据插入到本地数据库
	 * 
	 * @param couponInfModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(CouponInfModel couponInfModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean coupon = couponInfManager.create(couponInfModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), couponInfModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "couponInf.create.error");
		}
		return response;
	}

	/**
	 * 查询所有的优惠券
	 *
	 * @return
	 */
	@Override
	public Response<List<CouponInfModel>> findAll() {
		Response<List<CouponInfModel>> response = new Response<List<CouponInfModel>>();
		try {
			List<CouponInfModel> couponInfModels = couponInfDao.findAll();
			response.setResult(couponInfModels);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("couponInf time query error", Throwables.getStackTraceAsString(e));
			response.setError("couponInf.time.query.error");
		}
		return response;
	}

	/**
	 * 检索商品可以领取的优惠卷信息
	 * @param goodsModel 商品信息（DataTable Mapped Entity）
	 * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
	 */
	@Override
	public Response<List<CouponInfModel>> findByGoodsInfo(GoodsModel goodsModel) {
		Response<List<CouponInfModel>> response = new Response<List<CouponInfModel>>();
		try {
			Map<String, Object> param = Maps.newHashMap();
			Response<List<Pair>> pairListResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
			if(pairListResponse.isSuccess()){
				List<Pair> categoryList = pairListResponse.getResult();
				for (int i = 1; i < categoryList.size(); i++) {
					String categoryId = categoryList.get(i).getId().toString();
					switch (i) {
						case 1:
							param.put("backCategory1Id", categoryId);
							break;
						case 2:
							param.put("backCategory2Id", categoryId);
							break;
						case 3:
							param.put("backCategory3Id", categoryId);
							break;
//						case 4:
//							param.put("backCategory4Id", categoryId);
//							break;
						default:
							break;
					}
				}
			}
			param.put("vendorId", goodsModel.getVendorId());
			param.put("goodsBrandId", goodsModel.getGoodsBrandId());
			param.put("code", goodsModel.getCode());
			List<CouponInfModel> couponInfModels = couponInfDao.findByGoodsInfo(param);
			response.setResult(couponInfModels);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("couponInf.findByGoodsInfo.error", Throwables.getStackTraceAsString(e));
			response.setError("couponInf.findByGoodsInfo.error");
		}
		return response;
	}

	/**
	 * 根据ID_Coupons查询
	 * @param ids
	 * @return
	 */
	public Response<List<String>> findCouponsByCoupons(List<String> ids) {
		Response<List<String>> response = Response.newResponse();
		try {
			List<String> findIdsByIds = couponInfDao.findCouponsByCoupons(ids);
			response.setResult(findIdsByIds);
		} catch (Exception e) {
			log.error("couponInf.findIdsByIds.error{}",Throwables.getStackTraceAsString(e));
			response.setError("couponInf.findIdsByIds.error");
		}
		return response;
	}


	/**
	 * 检索商品可以使用的优惠卷信息
	 * @param goodsModel 商品信息（DataTable Mapped Entity）
	 * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
	 */
	@Override
	public Response<List<CouponInfModel>> findByGoodsSpendableInfo(GoodsModel goodsModel) {
		Response<List<CouponInfModel>> response = new Response<List<CouponInfModel>>();
		try {
			Map<String, Object> param = Maps.newHashMap();
			Response<List<Pair>> pairListResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
			if(pairListResponse.isSuccess()){
				List<Pair> categoryList = pairListResponse.getResult();
				for (int i = 1; i < categoryList.size(); i++) {
					String categoryId = categoryList.get(i).getId().toString();
					switch (i) {
						case 1:
							param.put("backCategory1Id", categoryId);
							break;
						case 2:
							param.put("backCategory2Id", categoryId);
							break;
						case 3:
							param.put("backCategory3Id", categoryId);
							break;
//						case 4:
//							param.put("backCategory4Id", categoryId);
//							break;
						default:
							break;
					}
				}
			}
			param.put("vendorId", goodsModel.getVendorId());
			param.put("goodsBrandId", goodsModel.getGoodsBrandId());
			param.put("code", goodsModel.getCode());
			List<CouponInfModel> couponInfModels = couponInfDao.findByGoodsSpendableInfo(param);
			response.setResult(couponInfModels);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("couponInf.findByGoodsSpendableInfo.error", Throwables.getStackTraceAsString(e));
			response.setError("couponInf.findByGoodsSpendableInfo.error");
		}
		return response;
	}

	/**
	 * 跟新优惠券信息
	 */
	public Response<Boolean> updateById(CouponInfModel couponInfModel){
		Response<Boolean> response = Response.newResponse();
		try {
			Boolean bool = couponInfManager.updateById(couponInfModel);
			response.setResult(bool);
		}catch (Exception e){
			log.error("couponInf.update.error",Throwables.getStackTraceAsString(e));
			response.setError("couponInf.update.error");
		}
		return response;
	}

	/**
	 * 获取优惠券
	 *
	 * @param couponInfModelList  接口获取的优惠券
	 * @param couponInfModels  数据库中原本已经存在的优惠券
	 * @return
	 */
	public Response<Boolean> synchronizeCoupon(List<CouponInfModel> couponInfModelList,List<String> couponInfModels){
		Response<Boolean> response = Response.newResponse();
		try {
			//事务控制删除、新增、更新优惠券
			Boolean result = couponInfManager.synchronizeCoupon(couponInfModelList, couponInfModels);
			response.setResult(result);
		}catch (DuplicateKeyException e){
			log.error("synchronizeCoupon.duplicate");
			response.setError("synchronizeCoupon.duplicate");
		} catch (Exception e) {
			log.error("synchronizeCoupon.find.error{}", Throwables.getStackTraceAsString(e));
			response.setError("synchronizeCoupon.error");
		}
		return response;
	}

	/**
	 * 获取在接口中存在且数据库中存在优惠券
	 *
	 * @param couponids
	 * @return
	 */
	@Override
	public Response<List<String>> findCouponsExist(List<String> couponids) {
		Response<List<String>> response = Response.newResponse();
		try {
			//根据id集合查询优惠券
			List<String> couponInfModelList = couponInfDao.findByCouponIds(couponids);
			response.setResult(couponInfModelList);
		} catch (Exception e) {
			log.error("couponInf.findByCouponIds.error{}",Throwables.getStackTraceAsString(e));
			response.setError("couponInf.findIdsByIds.error");
		}
		return response;
	}
}
