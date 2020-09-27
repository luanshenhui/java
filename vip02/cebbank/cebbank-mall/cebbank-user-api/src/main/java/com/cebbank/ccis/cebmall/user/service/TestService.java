package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.model.TestModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
/**
 * Created by 11140721050130 on 2016/12/21.
 */
public interface TestService {

    /**
     * 列表
     *
     * @return
     */
    Response<TestModel> list();

    /**
     * 带参数的分页
     *
     * @param id
     * @return
     */
    Response<Pager<TestModel>> pager(@Param("id") String id, @Param("size") Integer size, @Param("pageNo") Integer pageNo);

    /**
     * 根据用户登录信息查询
     *
     * @param user
     * @return
     */
    Response<String> findByUser(@Param("user") User user);

}
