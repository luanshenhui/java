/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.SpecialPointScaleDao;
import cn.com.cgbchina.item.dto.SpecialPointsRateDto;
import cn.com.cgbchina.item.manager.SpecialPointsRateManager;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 2016/05/31
 */

@Service
@Slf4j
public class SpecialPointsRateServiceImpl implements SpecialPointsRateService {
	@Resource
	private SpecialPointScaleDao specialPointScaleDao;
	@Resource
	private SpecialPointsRateManager specialPointsRateManager;
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	/**
	 * 特殊积分倍率查询
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@Override
	public Response<Pager<SpecialPointScaleModel>> findAll(Integer pageNo, Integer size) {
		Response<Pager<SpecialPointScaleModel>> response = new Response<Pager<SpecialPointScaleModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		try {
			Pager<SpecialPointScaleModel> pager = specialPointScaleDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("reject goods query error ", Throwables.getStackTraceAsString(e));
			response.setError("reject.goods.query.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率删除
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = specialPointsRateManager.delete(specialPointScaleModel);
			if (!result) {
				response.setError("delete.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.defaultserach.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

	/**
	 * 批量删除
	 *
	 * @param deteleAllSpecial
	 * @return
	 */
	public Response<Integer> updateAllRejectGoods(List<Long> deteleAllSpecial) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(deteleAllSpecial, "deteleAllSpecial is Null");
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", deteleAllSpecial);
			// 删除操作 批量删除
			Integer count = specialPointsRateManager.updateAllRejectGoods(paramMap);
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("detele.all.special.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("detele all special error", Throwables.getStackTraceAsString(e));
			response.setError("detele.all.special.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率新增
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// json解串
			SpecialPointsRateDto specialPointScaleModelJson = jsonMapper.fromJson(specialPointScaleModel.getTypeVal(),
					SpecialPointsRateDto.class);
			// 循环取出Json 向数据库插入
			Boolean result = false;
			for (SpecialPointScaleModel model : specialPointScaleModelJson.getSpecialPointScaleModelList()) {
				model.setScale(specialPointScaleModel.getScale());// 倍率
				model.setCreateOper(specialPointScaleModel.getCreateOper());// 创建人
				model.setType(specialPointScaleModel.getType());// 类型
				// 根据所选类型值是否存在确定是更新还是新增，存在--更新 不存在--新增
				if (typeValCheck(model.getType(), model.getTypeId()).getResult() == true) {
					result = specialPointsRateManager.create(model);
				} else {
					result = specialPointsRateManager.updateByTypeId(model);
				}
				if (!result) {
					response.setError("insert.error");
					return response;
				}
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率更新
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 获取ID
			Boolean result = specialPointsRateManager.update(specialPointScaleModel);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}

	}

	/**
	 * 类型值唯一性校验
	 *
	 * @param type
	 * @param typeId
	 * @return
	 */
	private Response<Boolean> typeValCheck(String type, String typeId) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			if (StringUtils.isNotEmpty(type) && StringUtils.isNotEmpty(typeId)) {
				SpecialPointScaleModel specialPointScaleModel = new SpecialPointScaleModel();
				specialPointScaleModel.setType(type);
				specialPointScaleModel.setTypeId(typeId);
				List<SpecialPointScaleModel> result = specialPointScaleDao.typeValCheck(specialPointScaleModel);
				// 如果已经存在，查询结果大于0,进行更新；否则进行新增
				if (result.size() > 0) {
					response.setResult(false);
				} else {
					response.setResult(true);
				}
			}
			return response;
		} catch (Exception e) {
			log.error("check error", Throwables.getStackTraceAsString(e));
			response.setError("pointPool.check.error");
			return response;
		}
	}
}
