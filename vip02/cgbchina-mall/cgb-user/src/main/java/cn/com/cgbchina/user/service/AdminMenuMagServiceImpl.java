package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.user.dao.AdminRoleMenuDao;
import cn.com.cgbchina.user.dao.MenuMagDao;
import cn.com.cgbchina.user.dao.UserRoleDao;
import cn.com.cgbchina.user.dto.MenuNodeDto;
import cn.com.cgbchina.user.model.MenuMagModel;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.Collection;
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

    private List<MenuMagModel> allResources = Lists.newArrayList();
    @Resource
    private MenuMagDao menuMagDao;
    @Resource
    private UserRoleDao userRoleDao;
    @Resource
    private AdminRoleMenuDao adminRoleMenuDao;
    private List<Long> permisson;

    private final LoadingCache<String, List<Long>> userRoleCache;

    public AdminMenuMagServiceImpl() {

        // 根据用户Id,查询用户角色，缓存
        userRoleCache = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(new CacheLoader<String, List<Long>>() {
            @Override
            public List<Long> load(String userId) throws Exception {
                return userRoleDao.getRoleIdByUserId(userId);
            }
        });
    }

    @PostConstruct
    public void init() {
        // 加载所有的资源
        Response<List<MenuMagModel>> responseResult = this.findAll();
        if(responseResult.isSuccess()){
            allResources = responseResult.getResult();
        }

    }

    @Override
    public Response<MenuNodeDto> menuWithPermisson(@Param("user") User user) {
        Response<MenuNodeDto> response = new Response<>();
        MenuMagModel MenuMagModel = new MenuMagModel();
        MenuMagModel.setId(0L);
        MenuMagModel.setName("虚拟根节点");
        MenuNodeDto virtualNode = new MenuNodeDto(MenuMagModel);
        String userId = user.getId();
        try {
            // 获取角色下能访问的资源权限
            List<Long> menuIds = findMenuIds(userId);
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

    /**
     * 根据用户Id查询拥有的资源访问权限
     *
     * @param userId
     * @return
     */
    public List<Long> findMenuIds(String userId) {
        // 当前用户所有角色,读取缓存
        List<Long> roleIds = userRoleCache.getUnchecked(userId);
        // 有些角色可能已经被禁用 需要剔除
        // 获取角色下能访问的资源权限
        List<Long> menuIds = adminRoleMenuDao.getMenuByRoleId(roleIds);
        return menuIds;
    }

    @Override
    public Response<List<MenuMagModel>> findAllByUser(String userId) {
        Response<List<MenuMagModel>> response = new Response<List<MenuMagModel>>();
        if (StringUtils.isEmpty(userId)) {
            log.warn("user should not empty", userId);
            response.setResult(Collections.<MenuMagModel>emptyList());
            return response;
        }
        try {
            // 获取角色下能访问的资源权限
            List<Long> menuIds = findMenuIds(userId);
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

        final Long id = root.getMenu().getId();

        Collection<MenuMagModel> menus = Collections2.filter(allResources, new Predicate<MenuMagModel>() {
            @Override
            public boolean apply(@Nullable MenuMagModel input) {
                return input.getPid().longValue() == id.longValue();
            }
        });

        for (MenuMagModel menuMagModel : menus) {
            if (permisson.contains(menuMagModel.getId())) {
                MenuNodeDto subTree = new MenuNodeDto(menuMagModel);
                root.addChild(subTree);
                withPermisson(subTree);
            }
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
            if (all == null || all.size() == 0) {
                response.setResult(Collections.<MenuMagModel>emptyList());
                return response;
            }
            response.setResult(all);
        } catch (Exception e) {
            log.error("fail to load menu");
            response.setResult(Collections.<MenuMagModel>emptyList());
        }
        return response;
    }


    @Override
    public Response<List<Long>> getMenuByRoleId(Long id) {
        Response<List<Long>> response = new Response<>();
        try {
            List<Long> menuByRoleId = adminRoleMenuDao.getMenuByRoleId(Lists.newArrayList(id));
            response.setResult(menuByRoleId);
        } catch (Exception e) {
            log.error("fail to load menu");
            response.setError("find.menu.error");
        }
        return response;
    }

    @Override
    public Response<List<Long>> findMenuByUserId(String userId) {
        Response<List<Long>> response = Response.newResponse();
        response.setResult(findMenuIds(userId));
        return response;
    }

}
