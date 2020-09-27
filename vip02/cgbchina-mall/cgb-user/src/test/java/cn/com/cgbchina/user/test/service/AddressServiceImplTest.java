package cn.com.cgbchina.user.test.service;

import cn.com.cgbchina.rest.provider.model.MAL101Model;
import cn.com.cgbchina.user.model.Address;
import cn.com.cgbchina.user.service.AddressService;
import cn.com.cgbchina.user.test.BaseTestCase;
import com.spirit.common.model.Response;
import org.junit.Assert;
import org.junit.Test;

import javax.annotation.Resource;
import javax.validation.constraints.AssertTrue;
import java.util.List;

/**
 * Created by 11140721050130 on 2016/8/3.
 */
public class AddressServiceImplTest extends BaseTestCase {

    @Resource
    private AddressService addressService;

    @Test
    public void test (){
        Response<List<Address>> addressList =  addressService.getTreeOf(1);
        Assert.assertTrue(addressList.isSuccess());
    }
}
