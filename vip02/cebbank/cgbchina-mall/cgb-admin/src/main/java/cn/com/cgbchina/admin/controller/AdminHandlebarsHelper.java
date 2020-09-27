package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.user.model.MenuMagModel;
import cn.com.cgbchina.user.service.AdminMenuMagService;
import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import com.spirit.core.handlebars.HandlebarsEngine;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import jodd.util.ObjectUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;

@Component
public class AdminHandlebarsHelper {
    @Autowired
    private HandlebarsEngine handlebarEngine;

    @Autowired
    private AdminMenuMagService adminMenuMagService;

    @PostConstruct
    private void init() {
        handlebarEngine.registerHelper("authorial", new Helper<Object>() {
            @Override
            public CharSequence apply(Object param, Options options) throws IOException {

                return new Handlebars.SafeString(options.fn());
//                if (param != null) {
//                    String strButtonName = param.toString();
//
//                    User user = UserUtil.getUser();
//                    System.out.println(user.getId());
//
//                    // 获取角色下能访问的权限列表ID
//                    List<MenuMagModel> menuMagModels = adminMenuMagService.findAllByUser(user).getResult();
//                    StringBuilder strPattern = new StringBuilder("");
//                    Pattern pattern;
//                    for(MenuMagModel menuMagModel : menuMagModels) {
//                        if (StringUtils.isEmpty(menuMagModel.getAlias())) {
//                            continue;
//                        }
//                        strPattern.delete(0, StringUtils.length(strPattern));
//                        strPattern.append("^.*:");
//                        strPattern.append(strButtonName);
//                        strPattern.append(":.*$");
//                        pattern = Pattern.compile(strPattern.toString());
//                        if (pattern.matcher(menuMagModel.getAlias()).matches()) {
//                            return new Handlebars.SafeString(options.fn());
//                        }
//                    }
//                }
//                return options.inverse();
            }
        });

    }

}
