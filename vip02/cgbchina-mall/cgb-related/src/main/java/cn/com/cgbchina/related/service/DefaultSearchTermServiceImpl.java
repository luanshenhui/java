package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.DefaultSearchDao;
import cn.com.cgbchina.related.manager.DefaultSearchManager;
import cn.com.cgbchina.related.model.DefaultSearchModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 16-3-18.
 */
@Service
@Slf4j
public class DefaultSearchTermServiceImpl implements DefaultSearchTermService {
	@Resource
	private DefaultSearchDao defaultSearchDao;
	@Resource
	private DefaultSearchManager defaultSearchManager;

	/**
	 * 默认搜索词新增
	 *
	 * @param defaultSearchModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(DefaultSearchModel defaultSearchModel) {
		// 如果status为空时赋值1
		if (defaultSearchModel.getStatus() == null) {
			defaultSearchModel.setStatus(Contants.DEFAULT_SEAR_1);
		}
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验默认搜索词名称是否为空
			checkArgument(StringUtils.isNotBlank(defaultSearchModel.getName()), "name is null");
			defaultSearchManager.create(defaultSearchModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), defaultSearchModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "default.create.error");
		}
		return response;
	}

	/**
	 * 默认搜索词更新
	 *
	 * @param id
	 * @param defaultSearchModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(String id, DefaultSearchModel defaultSearchModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验默认搜索词名称是否为空
			checkArgument(StringUtils.isNotBlank(defaultSearchModel.getName()), "name is null");
			// 获取ID
			defaultSearchModel.setId(Long.valueOf(id));
			Boolean result = defaultSearchManager.update(defaultSearchModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), defaultSearchModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "default.update.error");
		}
		return response;
	}

	/**
	 * 默认搜索词删除
	 *
	 * @param defaultSearchModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(DefaultSearchModel defaultSearchModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = defaultSearchManager.delete(defaultSearchModel);
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
	 * 默认搜索词查询
	 *
	 * @param pageNo
	 * @param size
	 * @param name
	 * @return
	 */
	@Override
	public Response<Pager<DefaultSearchModel>> find(Integer pageNo, Integer size, String name) {
		Response<Pager<DefaultSearchModel>> response = new Response<Pager<DefaultSearchModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		// 根据条件查询 当有name的时候 根据name查询,去掉前后空格
		if (StringUtils.isNotEmpty(name)) {
			name = name.trim();
		}
		if (StringUtils.isNotEmpty(name)) {
			paramMap.put("name", name);
		}
		try {
			Pager<DefaultSearchModel> pager = defaultSearchDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("default term query error ", Throwables.getStackTraceAsString(e));
			response.setError("default.term.query.error");
			return response;
		}

	}

	/**
	 * 搜索词名称重复校验
	 *
	 * @param name
	 * @return
	 */
	@Override
	public Response<Boolean> findNameByName(Long id, String name) {
		Response<Boolean> response = new Response<Boolean>();
		// 新增和编辑对name的校验区分 当id为null时是新增操作 不为null时是编辑操作
		if (id != null) {
			// 当为编辑操作时 先通过id查出该条数据的name
			DefaultSearchModel defaultSearchModel = defaultSearchDao.findById(id);
			// 如果name不相同 代表编辑操作更改了name 这样就是查询全部的name来校验 如果name相同 即可以编辑
			if (!name.equals(defaultSearchModel.getName())) {
				// 取得搜索词名称相同的条数 大于0代表有重复
				Long total = defaultSearchDao.findNameByName(name);
				if (total != 0) {
					response.setResult(Boolean.FALSE);
				} else {
					response.setResult(Boolean.TRUE);
				}
			}
		} else {
			// 新增时走以下方法
			Long total = defaultSearchDao.findNameByName(name);
			if (total != 0) {
				response.setResult(Boolean.FALSE);
			} else {
				response.setResult(Boolean.TRUE);
			}
		}

		return response;
	}

	@Override
	public DefaultSearchModel findDefaultHeader() {
		// 实例化model参数
//		DefaultSearchModel defaultSearchModel = new DefaultSearchModel();
		// 查询条件
		Map<String, Object> queryMapDefaultSearch = Maps.newHashMap();
		queryMapDefaultSearch.put("limit", 1);
		DefaultSearchModel defaultSearchModel = defaultSearchDao.findDefaultHeader(queryMapDefaultSearch);
		return defaultSearchModel;
	}

}
