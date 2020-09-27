package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.related.dao.TblEspKeywordRecordDao;
import cn.com.cgbchina.related.dto.MemberSearchKeyWordDto;
import cn.com.cgbchina.related.manager.TblEspKeywordRecordManager;
import cn.com.cgbchina.related.model.MemberSearchKeyWordModel;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

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
			@Param("sourceId") String sourceId, @Param("startTime") String startTime, @Param("endTime") String endTime) {
		Response<Pager<TblEspKeywordRecordModel>> response = new Response<Pager<TblEspKeywordRecordModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		try {
			// 判断关键词是否为空
			if (isNotBlank(keyWords)) {
				paramMap.put("keyWords", keyWords.trim());
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
				paramMap.put("startTime", DateHelper.string2Date(startTime,DateHelper.YYYY_MM_DD));
			}
			// 判断终止时间是否为空
			if (isNotBlank(endTime)) {
				paramMap.put("endTime",DateHelper.string2Date(endTime,DateHelper.YYYY_MM_DD));
			}

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
//			TblEspKeywordRecordModel tblEspKeywordRecordModel = new TblEspKeywordRecordModel();
			TblEspKeywordRecordModel model = new TblEspKeywordRecordModel();
			model.setCreateOper(Id);
			model.setCreateTime(new Date());
			model.setKeyWords(keyWords);
			model.setOrdertypeId(ordertypeId);
			model.setSourceId(sourceId);
			tblEspKeywordRecordManager.insert(model);
			resultMap.put("result", Boolean.TRUE);
			response.setResult(resultMap);
			return response;

		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("KeywordSearchServiceImpl create.error", Throwables.getStackTraceAsString(e));
			response.setError("KeywordSearchServiceImpl.create.error");
			return response;
		}

	}

	/**
	 * Description : 统计会员搜索关键字 用于报表：会员搜索记录报表
	 * 
	 * @author xiewl
	 * @param paramMap
	 * @return
	 */
	@Override
	public Response<List<MemberSearchKeyWordDto>> countMemberSearchKeyWords(Map<String, Object> paramMap) {
		Response<List<MemberSearchKeyWordDto>> response = new Response<List<MemberSearchKeyWordDto>>();
		try {
			List<MemberSearchKeyWordModel> memberSearchKeyWordModels = tblEspKeywordRecordDao
					.findMemberSearchKeyWords(paramMap);
			List<MemberSearchKeyWordDto> memberSearchKeyWordDtos = Lists.newArrayList();
			memberSearchKeyWordDtos = BeanUtils.copyList(memberSearchKeyWordModels, MemberSearchKeyWordDto.class);
			response.setResult(memberSearchKeyWordDtos);
			return response;
		} catch (Exception e) {
			log.error("KeywordSearchServiceImpl countMemberSearchKeyWords.error", Throwables.getStackTraceAsString(e));
			response.setError("KeywordSearchServiceImpl.countMemberSearchKeyWords.error");
			return response;
		}
	}
}
