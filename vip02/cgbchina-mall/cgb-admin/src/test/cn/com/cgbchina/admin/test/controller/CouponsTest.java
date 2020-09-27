/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.test.controller;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.visit.model.coupon.CouponProject;
import org.junit.Assert;
import org.junit.Test;

import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.admin.controller.Coupons;
import cn.com.cgbchina.admin.test.BaseTestCase;
import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.util.List;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/8/3
 */
public class CouponsTest  extends BaseTestCase{
    private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    private Coupons coupons;

    @Test
    public void findAllCouponTest() {

        List<CouponProject> result = coupons.findAllCoupon();
        System.out.println("输出结果：" + jsonMapper.toJson(result));
        Assert.assertNotNull(coupons.getClass().getName() + "对比失败", result);

    }
}

