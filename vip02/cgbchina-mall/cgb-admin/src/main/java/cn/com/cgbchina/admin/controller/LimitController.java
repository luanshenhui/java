package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.util.ConnectionLimitRedisLock;
import cn.com.cgbchina.rest.provider.model.LimitModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Comment:
 * Created by 11150321050126 on 2016/12/21.
 */
@Controller
@Slf4j
@RequestMapping("/restManage")
public class LimitController {
    @Autowired
    private ConnectionLimitRedisLock connectionLimitRedisLock;
    @RequestMapping("/getLimitNum")
    @ResponseBody
    public List<LimitModel> getLimitNum(){
        return getNum(new GetLimit() {
            @Override
            public Long getNum(String key) {
                return connectionLimitRedisLock.getCurrentLimit(key);
            }
        });
    }
    private List<LimitModel> getNum(GetLimit limitFunc){
        List<LimitModel> result=new ArrayList<>();
        Map<String,String> keys= Constant.keysMap;
        Set<Map.Entry<String, String>> set = keys.entrySet();
        for (Map.Entry<String, String> entry:set){
            String key=entry.getKey();
            String value=entry.getValue();
            Long num=limitFunc.getNum(key);
            LimitModel model=new LimitModel();
            model.setKey(key);
            model.setName(value);
            model.setNum(num);
            result.add(model);
        }
        return result;
    }
    @RequestMapping("/getTotalNum")
    @ResponseBody
    public List<LimitModel> getTotalNum(){
        return getNum(new GetLimit() {
            @Override
            public Long getNum(String key) {
                return connectionLimitRedisLock.getTotalLimit(key);
            }
        });
    }

    @RequestMapping("/setTotalNum")
    @ResponseBody
    public boolean setTotalNum(String key,String value){
        connectionLimitRedisLock.setTotalLimit(key,value);
        return true;
    }

    @RequestMapping("/restCurrentNum")
    @ResponseBody
    public boolean restCurrentNum(String key){
        connectionLimitRedisLock.setLimit(key,"0");
        return true;
    }
    interface GetLimit{
        Long getNum(String key);
    }
}
