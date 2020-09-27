package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.admin.container.AuthContainer;
import cn.com.cgbchina.user.model.MenuMagModel;
import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import com.google.common.base.Splitter;
import com.spirit.core.handlebars.HandlebarsEngine;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.Collection;
import java.util.List;

@Component
public class AdminHandlebarsHelper {

    @Autowired
    private HandlebarsEngine handlebarEngine;
    private final Splitter splitter = Splitter.on(',').trimResults();


    @PostConstruct
    private void init() {
        handlebarEngine.registerHelper("authorial", new Helper<Object>() {
            @Override
            public CharSequence apply(Object param, Options options) throws IOException {
                User user = UserUtil.getUser();
                if (param != null && user != null) {
                    List<String> strButtonNameS = splitter.splitToList(param.toString());
                    // 获取角色下能访问的权限列表ID
                    Collection<MenuMagModel> menuMagModels = AuthContainer.getCurrentResouce();
                    for(MenuMagModel menuMagModel : menuMagModels) {
                        String strAlias = menuMagModel.getAlias();
                        for(String strButtonName : strButtonNameS) {
                            if (StringUtils.equals(strButtonName, strAlias)) {
                                return new Handlebars.SafeString(options.fn());
                            }
                        }
                    }
                }
                return options.inverse();
            }
        });

    }

}
