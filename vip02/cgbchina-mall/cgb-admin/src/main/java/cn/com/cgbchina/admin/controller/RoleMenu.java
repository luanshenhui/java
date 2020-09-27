package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.user.model.MenuMagModel;
import cn.com.cgbchina.user.service.AdminMenuMagService;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
@Controller
@Slf4j
@RequestMapping("/api/admin/roleMenu")
public class RoleMenu {
    @Resource
    private AdminMenuMagService adminMenuMagService;
    @Resource
    private MessageSources messageSources;

    @RequestMapping(value = "/getAllResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<MenuMagModel> getAllResource() {
        Response<MenuMagModel> response = new Response<>();
        Response<List<MenuMagModel>> result = adminMenuMagService.findAll();
        User user = UserUtil.getUser();
        String userId = user.getId();
        if (result.isSuccess()) {
            List<Long> menuIds = adminMenuMagService.findMenuIds(userId);
            List<MenuMagModel> menuMagModelList = result.getResult();
            List<MenuMagModel> menuList = Lists.newArrayList();
            // 某些资源可能已经被禁用 需要剔除
            for (MenuMagModel menuIterator : menuMagModelList ){
                if (menuIds.contains(menuIterator.getId())) {
                    menuList.add(menuIterator);
                }
            }
            return menuList;
        }else{
            log.error("failed to find all resource,error code:{}", result.getError());
            response.setError(messageSources.get(result.getError()));
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/getRoleResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Long> getCurrentResource(Long roleId) {
        Response<Long> response = new Response<>();
        Response<List<Long>> result = adminMenuMagService.getMenuByRoleId(roleId);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to find resource,error code:{}", result.getError());
        response.setError(messageSources.get(result.getError()));
        throw new ResponseException(500, messageSources.get(result.getError()));
    }
}
