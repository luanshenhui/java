package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-25.
 */
public interface BrowseHistoryService {

	/**
	 * 分页查询，用户浏览列表
	 *
	 * @return 结果对象
	 */
	public Response<Pager<BrowseHistoryInfoDateDto>> browseHistoryByPager(@Param("User") User user,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 * 
	 * Description : 指定时间段前五十浏览商品
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<MemberCountBatchDto>> findTopBrowseHistory(Map<String, Object> params);

}