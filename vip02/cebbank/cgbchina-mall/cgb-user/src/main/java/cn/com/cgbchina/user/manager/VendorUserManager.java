/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.VendorDao;
import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-28.
 */

@Component
@Transactional
public class VendorUserManager {
    @Resource
    private VendorDao vendorDao;

    public Integer insert(VendorModel vendorModel) {
        return vendorDao.insert(vendorModel);
    }

    public Boolean updateAll(VendorModel vendorModel) {
        int i = vendorDao.updateAll(vendorModel);
        if(i!=0){
            return Boolean.TRUE;
        }else{
            return Boolean.FALSE;
        }
    }

}
