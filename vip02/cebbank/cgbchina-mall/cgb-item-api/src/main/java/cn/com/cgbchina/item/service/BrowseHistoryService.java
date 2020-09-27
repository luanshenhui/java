package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDto;

/**
 * Created by 张成 on 16-4-25.
 */
public interface BrowseHistoryService {

	/**
	 * 分页查询，用户浏览列表
	 *
	 * @return 结果对象
	 */
	public Response<Pager<BrowseHistoryInfoDateDto>> browseHistoryByPager(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size);

}