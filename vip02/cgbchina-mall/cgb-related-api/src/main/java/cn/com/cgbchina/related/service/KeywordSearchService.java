package cn.com.cgbchina.related.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.related.dto.MemberSearchKeyWordDto;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * Created by yanjie.cao on 2016/6/3.
 */
public interface KeywordSearchService {

	/**
	 * 关键词搜索
	 * 
	 * @param pageNo
	 * @param size
	 * @param keyWords
	 * @param ordertypeId
	 * @param sourceId
	 * @param startTime
	 * @param endTime
	 * @return
	 */

	public Response<Pager<TblEspKeywordRecordModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("keyWords") String keyWords, @Param("ordertypeId") String ordertypeId,
			@Param("sourceId") String sourceId, @Param("startTime") String startTime, @Param("endTime") String endTime);

	/**
	 * 创建关键词
	 * 
	 * @param paramMap
	 * @return
	 */

	public Response<Map<String, Object>> create(Map<String, Object> paramMap);

	/**
	 * Description : 统计会员搜索关键字 用于报表：会员搜索记录报表
	 * 
	 * @param paramMap
	 * @return
	 */
	public Response<List<MemberSearchKeyWordDto>> countMemberSearchKeyWords(Map<String, Object> paramMap);

}
