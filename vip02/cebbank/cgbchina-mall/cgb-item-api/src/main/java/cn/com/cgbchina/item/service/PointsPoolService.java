package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.PointsPoolDto;
import cn.com.cgbchina.item.model.PointPoolModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.Map;

/**
 * Created by niufw on 16-4-7.
 */
public interface PointsPoolService {
	/**
	 * 积分池分页查询
	 *
	 * @param pageNo
	 * @param size
	 * @param curMonth
	 * @return
	 */
	public Response<Pager<PointsPoolDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("curMonth") String curMonth);

	/**
	 * 积分池新增
	 *
	 * @param pointPoolModel
	 * @return
	 */
	public Response<Boolean> create(PointPoolModel pointPoolModel);

	/**
	 * 积分池编辑
	 *
	 * @param pointPoolModel
	 * @return
	 */
	public Response<Boolean> update(PointPoolModel pointPoolModel);

	/**
	 * 积分池编辑
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> delete(Long id);

	/**
	 * 月份唯一性校验
	 *
	 * @param curMonth
	 * @return
	 */
	public Response<Integer> curMonthCheck(String curMonth);

	/**
	 * 获取最新积分池信息
	 * @return
	 */
	public Response<PointPoolModel> getLastInfo();

	/**
	 * 回滚积分池
	 *
	 * @param paramMap
	 * @return
	 */
	public Response<Boolean> dealPointPool(Map<String, Object> paramMap);

}
