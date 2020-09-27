package cn.com.cgbchina.scheduler;

import org.springframework.stereotype.Service;

/**
 * Created by lvzd on 2016/9/9.
 */
@Service
public class TestServiceImpl implements TestService {


    @Override
    public String getstr() {
        System.out.println("getStr1");
        return "1";
    }

    @Override
    public String getstr2() {
        System.out.println("getStr2");
        return "2";
    }
}