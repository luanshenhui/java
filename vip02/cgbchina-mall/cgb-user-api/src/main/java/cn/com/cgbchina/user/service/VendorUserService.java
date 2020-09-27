package cn.com.cgbchina.user.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.user.dto.VendorsDto;
import cn.com.cgbchina.user.model.VendorModel;

import java.util.List;

/**
 * Created by 陈乐 on 2016/4/25.
 */
public interface VendorUserService {

	/**
	 * 供应商用户登录
	 *
	 * @param userName 用户名
	 * @param password 密码
	 * @return 供应商用户信息
	 */
	public Response<VendorModel> vendorLogin(String userName, String password);

	/**
	 * 根据供应商用户Id查询供应商信息
	 *
	 * @param vendorUserId 供应商用户Id
	 * @return 供应商用户信息
	 */
	public Response<VendorModel> findVendorById(Long vendorUserId);

	/**
	 * 首次登录成功后更新页面状态
	 * 
	 * @param vendorModel
	 * @return
	 */
	public Response updatePwdByCode(VendorModel vendorModel);

    /**
     * 新建供应商子帐号
     *
     * @param vendorModel
     * @return
     */
    Response<String> create(VendorModel vendorModel);

    /**
     * 分页获取所有供应商信息
     *
     * @param user
     * @return
     */
    public Response<Pager<VendorsDto>> findByPage(@Param("pageNo") Integer pageNo,
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
     * 修改
     *
     * @param vendorModel 用户信息
     * @return
     * add by liuhan
     */
     public Response<Boolean> updateAll(VendorModel vendorModel);

	/**
	 * 根据供应商登录名查询信息
	 *
	 * @param code
	 * @return
	 */
	public Response<VendorModel> findByVendorCode(String code);

    /**
     * 查询所登录用户的角色
     *
     * @param id
     * @return
     */
    public Response<List<Long>> queryRole(String id);

}
