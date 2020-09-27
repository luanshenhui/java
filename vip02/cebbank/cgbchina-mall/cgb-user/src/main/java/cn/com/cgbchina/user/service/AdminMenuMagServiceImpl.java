package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.AdminRoleMenuDao;
import cn.com.cgbchina.user.dao.MenuMagDao;
import cn.com.cgbchina.user.dao.UserRoleDao;
import cn.com.cgbchina.user.dto.MenuNodeDto;
import cn.com.cgbchina.user.model.MenuMagModel;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;


/**
 * Created by 郝文佳 on 2016/5/19.
 */
@Service
@Slf4j
public class AdminMenuMagServiceImpl implements AdminMenuMagService {

    private final LoadingCache<Long, List<MenuMagModel>> cache;

    @Resource
    private MenuMagDao menuMagDao;

    @Resource
    private UserRoleDao userRoleDao;
    @Resource
    private AdminRoleMenuDao adminRoleMenuDao;
    private List<Long> permisson;

    @PostConstruct
    public void initResources() {


    }

    public AdminMenuMagServiceImpl() {
        cache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<Long, List<MenuMagModel>>() {
                    @Override
                    public List<MenuMagModel> load(Long code) throws Exception {
                        // 允许为空
                        return menuMagDao.findChildById(code);
                    }
                });
    }


    @Override
    public Response<MenuNodeDto> buildMenu() {
        Response<MenuNodeDto> response = new Response<>();
        MenuMagModel MenuMagModel = new MenuMagModel();
        MenuMagModel.setId(0L);
        MenuMagModel.setName("虚拟根节点");
        MenuNodeDto virtualNode = new MenuNodeDto(MenuMagModel);
        recursiveBuildMenuTree(virtualNode);
        response.setResult(virtualNode);
        return response;
    }

    @Override
    public Response<MenuNodeDto> menuWithPermisson(@Param("user") User user) {
        Response<MenuNodeDto> response = new Response<>();
        MenuMagModel MenuMagModel = new MenuMagModel();
        MenuMagModel.setId(0L);
        MenuMagModel.setName("虚拟根节点");
        MenuNodeDto virtualNode = new MenuNodeDto(MenuMagModel);
        String id = user.getId();
        try {
            // 当前用户所有角色
            List<Long> roleIds = userRoleDao.getRoleIdByUserId(id);
            // 有些角色可能已经被禁用 需要剔除
            // 获取角色下能访问的资源权限
            List<Long> menuIds = adminRoleMenuDao.getMenuByRoleId(roleIds);
            // 某些资源可能已经被禁用 需要剔除
            List<Long> allEnabledMenu = menuMagDao.findAllEnabledMenu();
            Iterator<Long> menuIterator = menuIds.iterator();
            while (menuIterator.hasNext()) {
                if (!allEnabledMenu.contains(menuIterator.next())) {
                    menuIterator.remove();
                }
            }
            this.permisson = menuIds;
            withPermisson(virtualNode);
            response.setResult(virtualNode);
        } catch (Exception e) {
            log.error("failed to get menu", e);
            response.setError("menu.query.error");
        }

        return response;

    }

    @Override
    public Response<List<MenuMagModel>> findAllByUser(User user) {
        Response<List<MenuMagModel>> response = new Response<List<MenuMagModel>>();
        if (user == null) {
            log.warn("user should not empty", user);
            response.setResult(Collections.<MenuMagModel>emptyList());
            return response;
        }
        try {
            // 当前用户所有角色
            List<Long> roleIds = userRoleDao.getRoleIdByUserId(user.getId());
            // 有些角色可能已经被禁用 需要剔除
            // 获取角色下能访问的资源权限
            List<Long> menuIds = adminRoleMenuDao.getMenuByRoleId(roleIds);
            List<MenuMagModel> allEnabledMenu = menuMagDao.findByIds(menuIds);
            response.setResult(allEnabledMenu);
            return response;
        } catch (Exception e) {
            log.error("failed find user source,cause:{}", Throwables.getStackTraceAsString(e));
            response.setResult(Collections.<MenuMagModel>emptyList());
            return response;
        }
    }

    private void withPermisson(MenuNodeDto root) {

        Long id = root.getMenu().getId();
        List<MenuMagModel> menus = this.cache.getUnchecked(id);
        for (MenuMagModel menuMagModel : menus) {
            if (permisson.contains(menuMagModel.getId())) {
                MenuNodeDto subTree = new MenuNodeDto(menuMagModel);
                root.addChild(subTree);
                withPermisson(subTree);
            }
        }

    }

    private void recursiveBuildMenuTree(MenuNodeDto root) {
        Long id = root.getMenu().getId();

        List<MenuMagModel> menus = this.cache.getUnchecked(id);
        for (MenuMagModel MenuMagModel : menus) {
            MenuNodeDto subTree = new MenuNodeDto(MenuMagModel);
            root.addChild(subTree);
            recursiveBuildMenuTree(subTree);
        }
    }

    /**
     * @param
     * @return
     */
    @Override
    public Response<List<MenuMagModel>> findAll() {
        Response<List<MenuMagModel>> response = new Response<>();
        try {
            List<MenuMagModel> all = menuMagDao.findAll();
            response.setResult(all);
        } catch (Exception e) {
            log.error("fail to load menu");
            response.setError("find.menu.error");
        }
        return response;
    }

}
