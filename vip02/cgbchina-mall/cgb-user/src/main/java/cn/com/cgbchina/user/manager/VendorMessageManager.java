package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.VendorMessageDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 111140821050151 on 2016/9/8.
 */

@Transactional
@Component
@Slf4j
public class VendorMessageManager {


    @Resource
    private VendorMessageDao vendorMessageDao;

    public Integer readAll(Map<String,Object> maps){
        return vendorMessageDao.readAllMessage(maps);

    }
    public Integer readMessage(String id){
        return vendorMessageDao.readMessage(id);

    }

}
