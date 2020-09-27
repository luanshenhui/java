package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.model.TestModel;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 11140721050130 on 2016/12/21.
 */
@Service
@Slf4j
public class TestServiceImpl implements TestService {

    @Override
    public Response<TestModel> list() {
        Response<TestModel> result = Response.newResponse();
        TestModel testModel = new TestModel();
        testModel.setId("123");
        testModel.setName("测试数据");
        testModel.setCode("测试code");
        result.setResult(testModel);
        return result;
    }

    @Override
    public Response<Pager<TestModel>> pager(@Param("id") String id, @Param("size") Integer size, @Param("pageNo") Integer pageNo) {
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Response<Pager<TestModel>> result = Response.newResponse();
        List<TestModel> testList = Lists.newArrayList();
        for (int i = 0; i < pageInfo.getLimit(); i++) {
            TestModel testModel = new TestModel();
            testModel.setId("100" + i);
            testModel.setName("测试数据" + i);
            testModel.setCode("测试code" + i);
            testList.add(testModel);
        }
        result.setResult(new Pager<TestModel>(100L, testList));
        return result;
    }

    @Override
    public Response<String> findByUser(@Param("user") User user) {
        Response<String> result = Response.newResponse();
        String userId = user.getId();
        result.setResult(userId);
        return result;
    }
}
