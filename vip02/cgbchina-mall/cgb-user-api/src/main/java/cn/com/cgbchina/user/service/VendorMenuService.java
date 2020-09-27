package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.VendorMenuNode;
import cn.com.cgbchina.user.model.VendorMenuModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
public interface VendorMenuService {
	/**
	 * find all the menus
	 *
	 * @return
	 */
	Response<List<VendorMenuModel>> findAll();
	Response<VendorMenuNode> buildMenu(@Param("user") User user);

	public Response<VendorMenuNode> menuWithPermisson(@Param("user") User user);
	//不展示对应的平台类型
	Response<List<VendorMenuModel>> getResourcesByNotOrderType(String shopType);
	/**
	 * 新建角色权限树
	 */
	public Response<List<VendorMenuModel>> findVendorRoleMenu (User user);
	/**
	 * 根据用户Id查询可访问的MenuId
	 *
	 * @param userId
	 * @return
	 */
	Response<List<Long>> findMenuByUserId(String userId);

	//不展示对应的平台类型
	public Response<List<Long>> getLongResourcesByNotOrderType(String shopType);
}
