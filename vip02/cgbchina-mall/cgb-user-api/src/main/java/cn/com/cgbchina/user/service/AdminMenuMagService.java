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
     *
     * @return
     */
    Response<List<MenuMagModel>> findAll();

    /**
     * find permissoned menu by user
     *
     * @param user user信息
     * @return
     */
    Response<MenuNodeDto> menuWithPermisson(@Param("user") User user);

    /**
     * 根据用户Id查询拥有的资源访问权限
     *
     * @param userId
     * @return
     */
    public List<Long> findMenuIds(String userId);

    /**
     * 查询用户所拥有的资源访问权限
     *
     * @param userId
     * @return
     */
    Response<List<MenuMagModel>> findAllByUser(String userId);

    /**
     * 根据角色Id获取资源Id
     *
     * @param id
     * @return
     */
    public Response<List<Long>> getMenuByRoleId(Long id);

    /**
     * 根据用户Id查询可访问的MenuId
     *
     * @param userId
     * @return
     */
    Response<List<Long>> findMenuByUserId(String userId);
}
