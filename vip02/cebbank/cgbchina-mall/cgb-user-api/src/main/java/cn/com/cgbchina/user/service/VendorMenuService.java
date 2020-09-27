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
	Response<VendorMenuNode> buildMenu();

	public Response<VendorMenuNode> menuWithPermisson(@Param("user") User user);

	Response<List<VendorMenuModel>> getAllResources();
}
