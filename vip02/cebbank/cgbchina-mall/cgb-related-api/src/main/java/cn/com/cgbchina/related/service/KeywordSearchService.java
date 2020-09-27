package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.Map;

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

}
