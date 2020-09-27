/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.container;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.model.VendorMenuModel;
import cn.com.cgbchina.user.service.AdminMenuMagService;
import cn.com.cgbchina.user.service.VendorMenuService;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import com.google.common.base.Predicate;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.Nullable;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/29.
 */
@Component
@Slf4j
public class AuthContainer {
    private static ThreadLocal<Collection<VendorMenuModel>> currentResouce = new ThreadLocal<>();
    private static List<VendorMenuModel> allResources = Lists.newArrayList();
    private static final Splitter splitter = Splitter.on(',').trimResults();
    public static ThreadLocal<Auths> userAuths = new ThreadLocal<Auths>() {
        protected Auths initialValue() {
            return new Auths(Collections.<AuthItem>emptyList());
        }
    };
    @Resource
    private VendorMenuService vendorMenuService;

    @PostConstruct
    public void init() {
        // 加载所有资源，缓存
        try {
            Response<List<VendorMenuModel>> allMenus = vendorMenuService.findAll();
            if(!allMenus.isSuccess()){
                log.error("request.error,error code: {}", allMenus.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, allMenus.getError());
            }
            // 加载所有的资源
            AuthContainer.allResources = allMenus.getResult();

        } catch (Exception e) {
            log.error("failed to load the menu resource,cause:{}", Throwables.getStackTraceAsString(e));
        }
    }

    public static void put(Collection<VendorMenuModel> menuNodeDtos) {
        currentResouce.set(menuNodeDtos);
    }

    public static Collection<VendorMenuModel> getCurrentResouce() {
        return currentResouce.get();
    }

    public static List<AuthItem> getAuth() {
        return userAuths.get().auths;
    }

    public static void putAuth(Auths auths) {
        userAuths.set(auths);
    }

    public static void remove() {
        currentResouce.remove();
        userAuths.remove();
    }

    public static void put(final List<Long> userAuthMenu) {
        // 返回当前用户可用的资源列表
        Collection<VendorMenuModel> enables = Collections2.filter(AuthContainer.allResources, new Predicate<VendorMenuModel>() {
            @Override
            public boolean apply(@Nullable VendorMenuModel input) {
                return userAuthMenu.contains(input.getId());
            }
        });
        currentResouce.set(enables);
        buildAuths();
    }

    private static void buildAuths() {
        List<AuthItem> authItems = Lists.newArrayListWithCapacity(400);
        for (VendorMenuModel VendorMenuModel : currentResouce.get()) {
            List<String> strLinks = splitter.splitToList(VendorMenuModel.getLink());
            for (String strLink : strLinks) {
                if (!Strings.isNullOrEmpty(strLink)) {
                    Pattern urlPattern = Pattern.compile("^" + strLink + ".*$");
                    AuthItem authItem = new AuthItem(strLink, urlPattern);
                    authItems.add(authItem);
                }
            }
        }
        Auths auths = new Auths(authItems);
        putAuth(auths);
    }

    @ToString
    public static class Auths {
        public List<AuthItem> auths;

        public Auths(List<AuthItem> list) {
            this.auths = list;
        }
    }

    public static class AuthItem {
        public final String link;
        public final Pattern pattern;

        public AuthItem(String link, Pattern pattern) {
            this.link = link;
            this.pattern = pattern;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            AuthItem that = (AuthItem) o;

            return Objects.equal(this.link, that.link) &&
                    Objects.equal(this.pattern, that.pattern);
        }

        @Override
        public int hashCode() {
            return Objects.hashCode(link, pattern);
        }

        @Override
        public String toString() {
            return MoreObjects.toStringHelper(this)
                    .add("link", link)
                    .add("pattern", pattern)
                    .toString();
        }
    }
}
