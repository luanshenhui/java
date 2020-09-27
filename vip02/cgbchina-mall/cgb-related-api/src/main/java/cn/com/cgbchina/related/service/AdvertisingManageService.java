/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.AdvertisingManageModel;
import com.spirit.user.User;

/**
 * @author niufw
 * @version 1.0
 * @since 16-6-20.
 */
public interface AdvertisingManageService {
	/**
	 * 广告管理分页查询 niufw
	 * 
	 * @param pageNo
	 * @param size
	 * @param checkStatus
	 * @param id
	 * @param createTime
	 * @param fullName
	 * @param ordertypeId
	 * @return
	 */
	public Response<Pager<AdvertisingManageModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("checkStatus") String checkStatus, @Param("id") String id, @Param("createTime") String createTime,
			@Param("fullName") String fullName, @Param("ordertypeId") String ordertypeId,@Param("user")User user);

	/**
	 * 广告管理审核 niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public Response<Boolean> advertisingCheck(AdvertisingManageModel advertisingManageModel);

	/**
	 * 广告管理拒绝 niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public Response<Boolean> advertisingRefuse(AdvertisingManageModel advertisingManageModel);

	/**
	 * 广告管理删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> delete(Long id);

	/**
	 * 广告管理添加(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */

	public Response<Boolean> create(AdvertisingManageModel advertisingManageModel,String userType);

	/**
	 * 广告管理编辑(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */

	public Response<Boolean> update(AdvertisingManageModel advertisingManageModel);

	/**
	 * 通过id取得
	 *
	 * @param id
	 * @return
	 */
	public Response<AdvertisingManageModel> findById(Integer id);

}
