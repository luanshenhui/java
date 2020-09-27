package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dao.TblEspKeywordRecordDao;
import cn.com.cgbchina.related.manager.TblEspKeywordRecordManager;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11141021040453 on 2016/6/3.
 */
@Service
@Slf4j
public class KeywordSearchServiceImpl implements KeywordSearchService {

	@Resource
	TblEspKeywordRecordDao tblEspKeywordRecordDao;
	@Resource
	TblEspKeywordRecordManager tblEspKeywordRecordManager;

	// 判断非空
	private Boolean isNotBlank(String str) {
		if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
			return Boolean.TRUE;
		return Boolean.FALSE;
	}

	/**
	 * @param pageNo
	 * @param size
	 * @param keyWords
	 * @param ordertypeId
	 * @param sourceId
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@Override
	public Response<Pager<TblEspKeywordRecordModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("keyWords") String keyWords, @Param("ordertypeId") String ordertypeId,
			@Param("sourceId") String sourceId, @Param("startTime") String startTime,
			@Param("endTime") String endTime) {
		Response<Pager<TblEspKeywordRecordModel>> response = new Response<Pager<TblEspKeywordRecordModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 判断关键词是否为空
		if (isNotBlank(keyWords)) {
			paramMap.put("keyWords", keyWords.trim().replace(" ", ""));
		}
		// 判断业务类型是否为空
		if (isNotBlank(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		// 判断搜索渠道是否为空
		if (isNotBlank(sourceId)) {
			paramMap.put("sourceId", sourceId);
		}
		// 判断起始时间是否为空
		if (isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		// 判断终止时间是否为空
		if (isNotBlank(endTime)) {
			paramMap.put("endTime", endTime);
		}
		try {
			Pager<TblEspKeywordRecordModel> pager = tblEspKeywordRecordDao.findLikeByPage(paramMap,
					pageInfo.getOffset(), pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("KeywordSearchServiceImpl find qury error", Throwables.getStackTraceAsString(e));
			response.setError("KeywordSearchServiceImpl.find.qury.error");
			return response;
		}

	}

	@Override
	public Response<Map<String, Object>> create(Map<String, Object> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> resultMap = Maps.newHashMap();
		String keyWords = (String) paramMap.get("keyWords");
		String ordertypeId = (String) paramMap.get("ordertypeId");
		String sourceId = (String) paramMap.get("sourceId");
		String Id = (String) paramMap.get("id");
		try {
			checkArgument(StringUtils.isNotBlank(keyWords), "keyWords.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(ordertypeId), "ordertypeId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(sourceId), "sourceId.can.not.be.empty");
			TblEspKeywordRecordModel tblEspKeywordRecordModel = new TblEspKeywordRecordModel();
			tblEspKeywordRecordModel = tblEspKeywordRecordDao.findByKeyWords(keyWords);
			if (tblEspKeywordRecordModel != null) {
				resultMap.put("result", Boolean.FALSE);
				resultMap.put("resason", "the keyWords already exist");
				response.setResult(resultMap);
				return response;
			}
			tblEspKeywordRecordModel.setCreateOper(Id);
			tblEspKeywordRecordModel.setCreateTime(new Date());
			tblEspKeywordRecordModel.setKeyWords(keyWords);
			tblEspKeywordRecordModel.setOrdertypeId(ordertypeId);
			tblEspKeywordRecordModel.setSourceId(sourceId);
			tblEspKeywordRecordManager.insert(tblEspKeywordRecordModel);
			resultMap.put("result", Boolean.TRUE);
			response.setResult(resultMap);
			return response;

		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("KeywordSearchServiceImpl create.eroor", Throwables.getStackTraceAsString(e));
			response.setError("KeywordSearchServiceImpl.create.eroor");
			return response;
		}

	}
}
