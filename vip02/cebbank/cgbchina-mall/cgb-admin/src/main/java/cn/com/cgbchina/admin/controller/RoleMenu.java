package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.admin.interceptor.AuthInterceptor;
import cn.com.cgbchina.user.model.MenuMagModel;
import cn.com.cgbchina.user.service.AdminMenuMagService;
import cn.com.cgbchina.user.service.AdminRoleMenuService;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.bouncycastle.math.ec.ScaleYPointMap;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.yaml.snakeyaml.Yaml;

import javax.annotation.Resource;
import java.util.List;

import static java.awt.SystemColor.menu;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
@Controller
@Slf4j
@RequestMapping("/api/admin/roleMenu")
public class RoleMenu {
    @Resource
    private AdminRoleMenuService adminRoleMenuService;
    @Resource
    private AdminMenuMagService adminMenuMagService;
    @Resource
    private MessageSources messageSources;


    private final String test;

    public RoleMenu() throws Exception {
        Yaml yaml = new Yaml();
        MenuResources menuResources = yaml.loadAs(Resources.toString(Resources.getResource("resources.yaml"), Charsets.UTF_8), MenuResources.class);
        test = menuResources.resources.get(0).name;
    }

    @RequestMapping(value = "/getAllResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<MenuMagModel> getAllResource() {
        Response<MenuMagModel> response = new Response<>();
        Response<List<MenuMagModel>> result = adminMenuMagService.findAll();
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to find all resource,error code:{}", result.getError());
        response.setError(messageSources.get(result.getError()));
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    @RequestMapping(value = "/getRoleResource", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Long> getCurrentResource(Long roleId) {
        Response<Long> response = new Response<>();
        Response<List<Long>> result = adminRoleMenuService.getMenuByRoleId(roleId);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to find resource,error code:{}", result.getError());
        response.setError(messageSources.get(result.getError()));
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    @ToString
    private static class MenuResource {
        public String url;
        public String name;
        public String icon;
        public List<MenuItem> menus;
    }

    @ToString
    private static class MenuResources {
        public List<MenuResource> resources;
    }

    private static class MenuItem {
        public String id;
        public String url;
        public String name;
        public String icon;
        public String type;
        public List<MenuItem> menus;
    }
}
