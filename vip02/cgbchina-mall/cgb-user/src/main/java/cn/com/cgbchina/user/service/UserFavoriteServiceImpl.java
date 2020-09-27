package cn.com.cgbchina.user.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.user.dao.MemberGoodsFavoriteDao;
import cn.com.cgbchina.user.dto.MemberBatchDto;
import cn.com.cgbchina.user.manager.FavoriteManager;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;

import com.google.common.base.Optional;
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

/**
 * Created by 张成 on 16-4-25.
 */

@Service
@Slf4j
public class UserFavoriteServiceImpl implements UserFavoriteService {

	@Resource
	private MemberGoodsFavoriteDao memberGoodsFavoriteDao;

	@Resource
	private FavoriteManager favoriteManager;

	// 本地缓存
	private final LoadingCache<String, Optional<MemberGoodsFavoriteModel>> cache;

	// 构造函数
	public UserFavoriteServiceImpl() {
		cache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<MemberGoodsFavoriteModel>>() {
					public Optional<MemberGoodsFavoriteModel> load(String id) throws Exception {
						// 允许为空
						return Optional.fromNullable(memberGoodsFavoriteDao.findById(Long.valueOf(id)));
					}
				});
	}

	/**
	 * 搜出收藏最多的，有效的前十条记录。
	 *
	 * @return
	 */
	@Override
	public List<MemberGoodsFavoriteModel> findTop(Map<String, Object> paramMap) {
		// 实例化返回收藏商品TOP10的list
		List<MemberGoodsFavoriteModel> goodsFavoriteList = new ArrayList<MemberGoodsFavoriteModel>();
		try {
			paramMap.put("delFlag", 0);// 过滤条件 有效的收藏
			// 从数据库获取top10收藏
			goodsFavoriteList = memberGoodsFavoriteDao.findTop(paramMap);
			// 返回list
			return goodsFavoriteList;
		} catch (Exception e) {
			log.error("get.favorite.top.error", Throwables.getStackTraceAsString(e));
			return goodsFavoriteList;
		}
	}

	/**
	 * 分页取得收藏信息列表（不含单品、商品信息）
	 *
	 * @param pageInfo
	 * @return
	 */
	public Response<Pager<MemberGoodsFavoriteModel>> findByPager(PageInfo pageInfo, User user) {
		Response<Pager<MemberGoodsFavoriteModel>> result = new Response<Pager<MemberGoodsFavoriteModel>>();
		Map<String, Object> param = Maps.newHashMap();
		try {
			// TODO 商城用户ID待解决
			param.put("custId", user.getId()); // 会员编号
			param.put("delFlag", 0); // 逻辑删除标记 0：未删除 1：已删除
			Pager<MemberGoodsFavoriteModel> pager = memberGoodsFavoriteDao.findByPage(param, pageInfo.getOffset(),
					pageInfo.getLimit());

			if (pager.getTotal() == 0) {
				result.setResult(new Pager<MemberGoodsFavoriteModel>(0L, Collections
						.<MemberGoodsFavoriteModel> emptyList()));
				return result;
			} else {
				result.setResult(pager);
				return result;
			}
		} catch (Exception e) {
			log.error("UserFavoriteService.findByPager.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.qurery.fail");
			return result;
		}
	}

	/**
	 * 取消收藏
	 *
	 * @return 更新结果
	 */
	public Response<Map<String, Boolean>> cancelFavorite(String id, User user) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			Map<String, Object> param = Maps.newHashMap();
			if (user == null) {
				responseMap.put("result", false);
				response.setResult(responseMap);
				response.setSuccess(false);
				return response;
			}
			param.put("custId", user.getId());
			param.put("itemCode", id);
			// 唯一性校验
			List<MemberGoodsFavoriteModel> list = memberGoodsFavoriteDao.findByCustIdAndItemCode(param);
			if (list == null||list.isEmpty()) {
				response.setError("Favorite.be.cancled");
				return response;
			}
			MemberGoodsFavoriteModel model = new MemberGoodsFavoriteModel();
			if (list.size() > 0) {
				model = list.get(0);
			}
			// 逻辑删除标记( 0：未删除 1：已删除)
			model.setDelFlag(1);
			// 更新时间
			model.setModifyTime(new Date());
			// 更新者
			model.setModifyOper(user.getId());
			Boolean result = favoriteManager.update(model);
			responseMap.put("result", result);
			response.setResult(responseMap);
			return response;
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl cancelFavorite error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.cancelFavorite.error");
			return response;
		}
	}

	/*
	 * 根据ID取得收藏信息
	 * 
	 * @return 收藏信息
	 */
	private MemberGoodsFavoriteModel findById(String id) {
		Optional<MemberGoodsFavoriteModel> organiseModelOptional = this.cache.getUnchecked(id);
		if (organiseModelOptional.isPresent()) {
			return organiseModelOptional.get();
		}
		return null;
	}

	/**
	 * Description : 根据客户ID获取收藏信息
	 * 
	 * @param custId
	 * @return
	 */
	public Response<List<MemberGoodsFavoriteModel>> findByCustId(String custId) {
		Response<List<MemberGoodsFavoriteModel>> response = new Response<List<MemberGoodsFavoriteModel>>();
		try {
			Map<String, Object> params = Maps.newHashMap();
			params.put("custId", custId);
			List<MemberGoodsFavoriteModel> favoriteModels = memberGoodsFavoriteDao.findByCustId(params);
			if (favoriteModels != null && !favoriteModels.isEmpty()) {
				response.setSuccess(true);
			} else {
				response.setSuccess(false);
			}
			response.setResult(favoriteModels);
			return response;
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl findByCustId error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.findByCustId.error");
			response.setSuccess(false);
			return response;
		}

	}

	/**
	 * 加入收藏夹
	 *
	 * @return 更新结果
	 */
	public Response<Map<String, Boolean>> addFavorite(List<MemberGoodsFavoriteModel> modelList) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			Map<String, Object> param = Maps.newHashMap();
			if (modelList == null) {
				response.setError("UserFavoriteServiceImpl.addFavorite.eroor.MemberGoodsFavoriteModel.can.not.be.null");
				return response;
			}
			// 加入收藏夹
			for (MemberGoodsFavoriteModel model : modelList) {
				Response<String> checkResult = this.checkFavorite(model.getItemCode(), model.getCustId());
				if (checkResult.isSuccess() && "0".equals(checkResult.getResult())) {
					favoriteManager.insert(model);
				}
			}
			responseMap.put("result", true);
			response.setResult(responseMap);
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl cancelFavorite error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.cancelFavorite.error");
			return response;
		}
	}

	/**
	 * 是否已经收藏
	 *
	 * @param itemCode
	 * @param custId
	 * @return 是否已经收藏（1:收藏 0:未收藏）
	 */
	public Response<String> checkFavoriteUser(String itemCode, String custId) {
		return checkFavorite(itemCode, custId);
	}

	/**
	 * 是否已经收藏
	 *
	 * @param itemCode
	 * @param CustId
	 * @return 是否已经收藏（1:收藏 0:未收藏）
	 */
	public Response<String> checkFavorite(String itemCode, String CustId) {
		Response<String> response = new Response<String>();
//		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			Map<String, Object> param = Maps.newHashMap();
			param.put("custId", CustId);
			param.put("itemCode", itemCode);
			// 唯一性校验
			List<MemberGoodsFavoriteModel> list = memberGoodsFavoriteDao.findByCustIdAndItemCode(param);
			if (list != null && list.size() > 0) {
				// 已收藏
				response.setResult("1");
				return response;
			}
			// 未收藏
			response.setSuccess(true);
			response.setResult("0");
			return response;
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl cancelFavorite error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.cancelFavorite.error");
			response.setSuccess(false);
			return response;
		}
	}

	/**
	 * 删除用户收藏的商品(外部接口MAL303)
	 *
	 * @param custId
	 * @param ids
	 * @return
	 */
	public Response<Boolean> delectPhoneFavorite(String custId, List<String> ids) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			favoriteManager.deletePhoneFavorite(custId, ids);
			response.setResult(true);
		} catch (Exception e) {
			log.error("删除收藏发生异常");
			response.setSuccess(false);
			return response;
		}
		return response;
	}

	/**
	 * 加入用户收藏的商品(外部接口MAL301)
	 *
	 * @param memberGoodsFavoriteModel
	 * @return
	 */
	public Response<Boolean> insertPhoneFavorite(MemberGoodsFavoriteModel memberGoodsFavoriteModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			favoriteManager.insertPhoneFavorite(memberGoodsFavoriteModel);
			response.setResult(true);
			response.setSuccess(true);
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl insertPhoneFavorite error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.insertPhoneFavorite.error");
			response.setSuccess(false);
			return response;
		}
		return response;
	}

	/**
	 * Description : 按日期段分页查询收藏统计列表
	 * 
	 * @author Huangcy
	 * @param
	 * @return
	 */
	@Override
	public Response<List<MemberBatchDto>> findGoodsFavoriteByPager(int pageNo, int pageSize, Map<String, Object> params) {
		Response<List<MemberBatchDto>> response = new Response<List<MemberBatchDto>>();
		try {
			PageInfo pageInfo = new PageInfo(pageNo, pageSize);
			List<MemberGoodsFavoriteModel> memberGoodsFavoriteModels = memberGoodsFavoriteDao.findGoodsFavoriteByPager(
					pageInfo.getOffset(), pageInfo.getLimit(), params);
			List<MemberBatchDto> memberBatchDtos = Lists.newArrayList();
			MemberBatchDto memberBatchDto = null;
			for (MemberGoodsFavoriteModel memberGoodsFavoriteModel : memberGoodsFavoriteModels) {
				memberBatchDto = new MemberBatchDto();
				memberBatchDto.setGoodsCode(memberGoodsFavoriteModel.getGoodsCode());
				memberBatchDto.setItemCode(memberGoodsFavoriteModel.getItemCode());
				memberBatchDto.setCount(memberGoodsFavoriteModel.getCount());
				memberBatchDtos.add(memberBatchDto);
			}
			response.setResult(memberBatchDtos);
			return response;
		} catch (Exception e) {
			log.error("UserFavoriteServiceImpl.findGoodsFavoriteByPager.fail,cause:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("UserFavoriteServiceImpl.findGoodsFavoriteByPager.fail");
			return response;
		}
	}

	@Override
	public Response<Long> findMyFavoriteCount(User user){
		Response<Long> result = Response.newResponse();
		try {
			Long count = memberGoodsFavoriteDao.findMyFavoriteCount(user.getCustId());
			result.setResult(count);
			return result;
		}catch (Exception e){
			log.error("find.my.favorite.count.fail,casuse:{}",Throwables.getStackTraceAsString(e));
			result.setError("find.my.favorite.count.fail");
			return result;
		}
	}
}
