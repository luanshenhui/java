package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.MenuNodeDto;
import cn.com.cgbchina.user.model.MenuMagModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/19.
 */
public interface AdminMenuMagService {
	/**
	 * find all the menus
	 * @return
     */
	Response<List<MenuMagModel>> findAll();

	/**
	 *
	 * @return
     */
	Response<MenuNodeDto> buildMenu();

	/**
	 * find permissoned menu by user
	 * @param user user信息
	 * @return
     */
	Response<MenuNodeDto> menuWithPermisson(@Param("user") User user);

	/**
	 * 查询用户所拥有的资源访问权限
	 * @param user
	 * @return
     */
	Response<List<MenuMagModel>> findAllByUser(User user);
}
