package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.EspPublishInfDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

public interface EspPublishInfService {

	/**
	 * 公告管理 分页数据
	 *
	 * @param pageNo
	 * @param size
	 * @param startTime
	 * @author Tanliang
	 * @time 2016-6-6
	 */
	public Response<Pager<EspPublishInfDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("publishTitle") String publishTitle, @Param("curStatus") String curStatus,
			@Param("startTime") String startTime);

	/**
	 * 0 公告发布 保存
	 *
	 * @param espPublishInfDto
	 * @return
	 */
	public Response<Boolean> createPublish(EspPublishInfDto espPublishInfDto);

	/**
	 * 根据id查询公告信息
	 *
	 * @param id
	 * @return
	 */
	public Response<EspPublishInfDto> findPublishById(@Param("id") Long id);
}