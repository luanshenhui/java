package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.LogsDto;
import cn.com.cgbchina.user.model.LogsModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

public interface LogsService {

	/**
	 * 系统日志查询
	 *
	 * @param pageNo
	 * @param size
	 * @param shopType
	 * @param action
	 * @param user
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public Response<Pager<LogsDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("shopType") String shopType, @Param("action") String action, @Param("user") String user,
			@Param("startTime") String startTime, @Param("endTime") String endTime);
}