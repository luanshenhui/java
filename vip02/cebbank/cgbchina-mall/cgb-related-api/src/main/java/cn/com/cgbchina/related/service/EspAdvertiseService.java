package cn.com.cgbchina.related.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.EspAdvertiseModel;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-30.
 */
public interface EspAdvertiseService {
	/**
	 * 添加手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> create(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 删除手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> delete(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 发布手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> updateAdvetiseStatus(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 更新启用状态
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> updateIsStop(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 更新手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> update(String id, EspAdvertiseModel espAdvertiseModel);

	/**
	 * 查询手机广告列表
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<EspAdvertiseModel>> findByPage(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("ordertypeId") String ordertypeId, @Param("advertisePos") String advertisePos,
			@Param("publishStatus") String publishStatus);

}
