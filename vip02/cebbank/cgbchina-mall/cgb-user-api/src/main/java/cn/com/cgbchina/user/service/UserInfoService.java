package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.UserInfoDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorPayNoModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import java.util.List;

/**
 * 用户管理，运营管理平台用 Created by 11140721050130 on 2016/4/30.
 */
public interface UserInfoService {

	/**
	 * 分页获取所有管理账户信息
	 *
	 * @param user
	 * @return
	 */
	public Response<Pager<UserInfoDto>> findByPage(@Param("pageNo") Integer pageNo,
                                                    @Param("size") Integer size,
			                                        @Param("user") User user,
                                                    @Param("id") String id,
                                                    @Param("name") String name,
                                                    @Param("orgSimpleName") String orgSimpleName,
                                                    @Param("roleName") String roleName,
                                                    @Param("checkStatus") String checkStatus,
                                                    @Param("status") String status
                                                    );

	/**
	 * 根据用户Id查询用户信息
	 *
	 * @param userId 用户Id
	 * @return 用户信息
	 */
	public Response<UserInfoDto> findUserById(String userId);

	/**
	 * 根据用户Id查询用户账户信息
	 *
	 * @param userId 用户Id
	 * @return 用户信息
	 */
	public Response<UserInfoModel> findUserInfoById(String userId);

	/**
	 * 后台管理用户登录
	 *
	 * @param userName 用户名
	 * @param password 密码
	 * @return 登录用户信息
	 */
	public Response<UserInfoModel> userLogin(String userName, String password);

	/**
	 * 新建用户(后台管理用)
	 *
	 * @param userInfoDto 用户信息
	 * @return 用户Id
	 */
	Response<String> create(UserInfoDto userInfoDto);

	/**
	 * 更新用户信息
	 *
	 * @param userInfoDto 用户信息
	 * @return 更新结果
	 */
	Response<Boolean> update(UserInfoDto userInfoDto);

    Response<Boolean> assign(UserInfoModel userInfoDto);

    /**
     * 修改密码
     *
     * @param userInfoDto 用户信息
     * @return
     * add by liuhan
     */
    Response<Boolean> updatePassWord(UserInfoDto userInfoDto);

	/**
	 * 商城用户信息获取
	 *
	 * @return 登录用户信息
	 */
	public Response<UserInfoModel> findUser(@Param("_USER_") User user);

	/**
	 * 首次登录成功后更新密码
	 * 
	 * @param userInfoModel
	 * @return
	 */
	public Response updateFirstPwdByCode(UserInfoModel userInfoModel);

	/**
	 * 过期后更新页面密码
	 *
	 * @param userInfoModel
	 * @param passwordOld
	 * @return
	 */
	public Response updatePwdByCode(UserInfoModel userInfoModel, String passwordOld);

	public Response<List<TblVendorRatioModel>> findVendorRatioInfo(String vendorId, String period);

	public Response<List<VendorPayNoModel>> findVendorPayNoInfo(String vendorId, String period);

	public Response<VendorInfoModel> findVendorInfoByVendorId(String vendorId);

	public Response<List<VendorInfoModel>> findVendorInfoByVendorIds(List<String> vendorIdsList);

	/**
	 * 根据用户机构code查询
	 *
	 * @param orgCode
	 * @return
	 * add by liuhan
	 */
	public Response<List<UserInfoModel>> findUserInfoByOrgCode(String orgCode);
}
