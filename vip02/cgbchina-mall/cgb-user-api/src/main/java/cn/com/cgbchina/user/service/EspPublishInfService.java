package cn.com.cgbchina.user.service;

import java.util.List;
import java.util.Map;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.user.dto.EspPublishInfDto;
import cn.com.cgbchina.user.model.EspPublishInfModel;

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
	public Response<Boolean> createPublish(EspPublishInfDto espPublishInfDto,User user);

	/**
	 * 根据id查询公告信息
	 *
	 * @param id
	 * @return
	 */
	public Response<EspPublishInfDto> findPublishById(@Param("id") Long id);

	/**
	 * 入口页公告栏装修展示
	 *
	 * @param ids
	 * @return
	 */
	public Response<Map<String, Object>> findPublishByIds(@Param("ids") List<String> ids);

	/**
	 * 更新公告启用停用状态
	 *
	 * @return
	 */
	public Response<Boolean> updatePublishStatus(String state,String code,User user);

	public Response<Integer> update(EspPublishInfModel espPublishInfModel);

	/**
	 * 查找入口页公告栏位显示的公告
	 * @return
     */
	public Response<List<EspPublishInfModel>> findPublishIsNow();
}