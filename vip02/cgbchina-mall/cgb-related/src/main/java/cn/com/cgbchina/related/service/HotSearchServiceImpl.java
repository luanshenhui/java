package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.common.utils.EscapeUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.HotSearchTermDao;
import cn.com.cgbchina.related.manager.HotSearchManager;
import cn.com.cgbchina.related.model.DefaultSearchModel;
import cn.com.cgbchina.related.model.HotSearchTermModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11150721040343 on 16-4-8.
 */
@Service
@Slf4j
public class HotSearchServiceImpl implements HotSearchService {
	@Resource
	private HotSearchManager hotSearchManager;
	@Resource
	private HotSearchTermDao hotSearchTermDao;
	@Resource
	private DefaultSearchTermService defaultSearchTermService;

	/**
	 * 新增热搜词
	 *
	 * @param hotSearchTermModel
	 * @return
	 */
	@Override
	public Response<Integer> create(HotSearchTermModel hotSearchTermModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 校验热搜词名称是否为空
			checkArgument(StringUtils.isNotBlank(hotSearchTermModel.getName()), "name is null");
			// 校验热搜词顺序是否为空
			checkArgument(!("".equals(hotSearchTermModel.getSort() + "")), "sort is null");
			response.setResult(hotSearchManager.insert(hotSearchTermModel));
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), hotSearchTermModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "term.create.error");
		}
		return response;
	}

	/**
	 * 删除热搜词
	 *
	 * @param hotSearchTermModel
	 * @return
	 */
	@Override
	public Response<Integer> delete(HotSearchTermModel hotSearchTermModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 校验热搜词名字是否为空
			checkArgument(StringUtils.isNotBlank(hotSearchTermModel.getName()), "name is null");
			response.setResult(hotSearchManager.delete(hotSearchTermModel));
		} catch (IllegalArgumentException e) {
			log.error("delete.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		} catch (Exception e) {
			log.error("delete.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "term.delete.error");
		}
		return response;
	}

	/**
	 * 编辑热搜词
	 *
	 * @param dataMap
	 * @return
	 */
	@Override
	public Response<Integer> update(Map<String, Object> dataMap) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 校验id值是否为空
			checkArgument(dataMap != null, "dataMap is null");
			response.setResult(hotSearchManager.update(dataMap));
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), dataMap, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "term.update.error");
		}
		return response;
	}

	/**
	 * 查询所有热搜词
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@Override
	public Response<Pager<HotSearchTermModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("termName") String termName) {
		Response<Pager<HotSearchTermModel>> response = new Response<Pager<HotSearchTermModel>>();
		List<HotSearchTermModel> hotSearchTermsListModel = Lists.newArrayList();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		// 查询条件
		Map<String, Object> queryMap = Maps.newHashMap();
		queryMap.put("offset", pageInfo.getOffset());
		queryMap.put("limit", pageInfo.getLimit());
		// 去掉输入中的前后空格
		String regex = "\\s+";
		if (termName != null && termName.matches(regex)) {
			termName = null;
		} else if (termName != null && !termName.matches(regex)) {
			termName = termName.trim();
		}
		queryMap.put("termName", EscapeUtil.allLikeStr(termName));
		try {
			hotSearchTermsListModel = hotSearchTermDao.findAll(queryMap);
			// 查询出总条数
			Integer all = hotSearchTermDao.count(queryMap);
			Pager<HotSearchTermModel> termPager = new Pager<HotSearchTermModel>(Long.valueOf(all), hotSearchTermsListModel);
			response.setResult(termPager);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

	/**
	 * 根据热搜词名称查找
	 *
	 * @param name
	 * @return
	 */
	@Override
	public Response<HotSearchTermModel> findByName(String name) {
		Response<HotSearchTermModel> response = new Response<HotSearchTermModel>();
		try {
			response.setResult(hotSearchTermDao.findByName(name));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

	@Override
	public Response<Map<String, Object>> findHeader() {
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		List<HotSearchTermModel> hotSearchTermsListModel = Lists.newArrayList();
//		DefaultSearchModel defaultSearchModel = new DefaultSearchModel();
		Map<String, Object> resultMap = Maps.newHashMap();
		try {
			// 查询条件
			Map<String, Object> queryMapHotSearch = Maps.newHashMap();
			queryMapHotSearch.put("limit", 3);
			hotSearchTermsListModel = hotSearchTermDao.findHotHeader(queryMapHotSearch);
			resultMap.put("hotSearch", hotSearchTermsListModel);
			// 查询条件
			Map<String, Object> queryMapDefaultSearch = Maps.newHashMap();
			queryMapDefaultSearch.put("limit", 1);
			DefaultSearchModel defaultSearchModel = defaultSearchTermService.findDefaultHeader();
			resultMap.put("defaultSearch", defaultSearchModel);
			response.setResult(resultMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

}
