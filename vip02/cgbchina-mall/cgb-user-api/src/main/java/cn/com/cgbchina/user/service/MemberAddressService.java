package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.MemberAddressDto;
import cn.com.cgbchina.user.model.MemberAddressModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by niufw on 16-2-26.
 */

public interface MemberAddressService {

	/**
	 * 查询某用户所有的收货地址
	 *
	 * @param user
	 * @return
	 */
	// public Response<List<MemberAddressDto>> findAll(@Param("user") User user);

	/**
	 * 查询某用户所有的收货地址
	 *
	 * @param pageNo
	 * @param size
	 * @param user
	 * @return
	 */
	public Response<Pager<MemberAddressModel>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("user") User user);

	/**
	 * 根据收货地址id新增
	 *
	 * @param memberAddressDto
	 * @return
	 */
	public Response<Boolean> create(MemberAddressDto memberAddressDto);

	/**
	 * 根据收货地址id更新
	 *
	 * @param memberAddressDto
	 * @return
	 */
	public Response<Boolean> update(MemberAddressDto memberAddressDto);

	/**
	 * 根据收获地址id删除
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> delete(Long id);

	/**
	 * 根据收获地址id设置默认
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> setDefault(Long id, String custId);

	/**
	 * 根据ＩＤ取得地址情报
	 *
	 * @param id
	 * @return
	 */
	public Response<MemberAddressModel> findById(Long id);

	/**
	 * 如果存在默认地址不更新，不存在的话根据收获地址id设置默认
	 *
	 * @param id
	 * @param custId
	 * @return
	 */
	public Response<Boolean> setDefaultNotExists(Long id, String custId);

	/**
	 * 根据用户id取得地址情报
	 *
	 * @param paramMap
	 * @return
	 */
	public Response<List<MemberAddressModel>> findByParams(Map<String, Object> paramMap);

	/**
	 * 更新收货地址（外部接口调用）
	 * @param memberAddressModel 更新参数
	 * @return 更新结果
	 *
	 * geshuo 20160809
	 */
	public Response<Boolean> updateMemberAddress(MemberAddressModel memberAddressModel);
}
