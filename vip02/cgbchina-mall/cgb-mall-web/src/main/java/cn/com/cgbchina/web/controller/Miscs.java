/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.controller;

import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/15.
 */
@Controller
@Slf4j
@RequestMapping("/api")
public class Miscs {

    /**
     * 供前台异步获取吊顶信息
     *
     * @return 登陆用户信息
     */
    @RequestMapping(value = "/nav", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public User userInfo() {
        User loginUser = UserUtil.getUser();
        if (loginUser != null) {
            User user = new User();
            user.setId(loginUser.getId());
            user.setName(loginUser.getName());
            return user;
        }
        return null;
    }
}
