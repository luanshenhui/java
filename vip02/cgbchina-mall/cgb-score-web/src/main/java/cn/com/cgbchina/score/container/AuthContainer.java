/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.score.container;

import cn.com.cgbchina.user.model.MenuMagModel;

import java.util.List;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/29.
 */
public class AuthContainer {

    private static ThreadLocal<List<MenuMagModel>> currentResouce = new ThreadLocal<List<MenuMagModel>>();

    public static void put(List<MenuMagModel> menuNodeDtos) {
        currentResouce.set(menuNodeDtos);
    }

    public static List<MenuMagModel> getCurrentResouce() {
        return currentResouce.get();
    }

    public static List<MenuMagModel> remove() {
        return currentResouce.get();
    }
}
