package cn.com.cgbchina.user.service;

import java.util.Collections;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.user.manager.VendorMessageManager;
import com.google.common.base.Throwables;
import org.joda.time.DateTime;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.user.dao.VendorMessageDao;
import cn.com.cgbchina.user.model.VendorMessageModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 111140821050151 on 2016/9/3.
 */

@Service
@Slf4j
public class VendorMessageServiceImpl implements VendorMessageService {

    @Resource
    private VendorMessageDao vendorMessageDao;

    @Resource
    private VendorMessageManager vendorMessageManager;

    @Override
    public Response<Pager<VendorMessageModel>> findVendorMessage (Integer pageNo,Integer size,User user, String type){
        Response<Pager<VendorMessageModel>> response = Response.newResponse();
        try {
                Map<String,Object> params = Maps.newHashMap();
                if(!Strings.isNullOrEmpty(type)){
                    params.put("type",type);
                }
                if(!Strings.isNullOrEmpty(user.getVendorId())){
                    params.put("vendorId",user.getVendorId());
                }
                DateTime pushTime = DateTime.now().minusMonths(3) ; //当前时间减去三个月
                params.put("pushTime",pushTime.toDate());
                PageInfo pageInfo = new PageInfo(pageNo, size);
                Pager<VendorMessageModel> pager =  vendorMessageDao.findByPage(params,pageInfo.getOffset(),pageInfo.getLimit());
                if (pager.getTotal() == 0) {
                    response.setResult(new Pager<VendorMessageModel>(0L, Collections.<VendorMessageModel> emptyList()));
                } else {
                    response.setResult(pager);
                }
            }catch (Exception e) {
                log.error("vendor.message.query.fail,cause:{}", Throwables.getStackTraceAsString(e));
                response.setError("vendor.message.query.fail");
            }
        return response;
    }


    public Response<Boolean> readAll(String typeId,User user){
        Response<Boolean> response = Response.newResponse();
        try {
            Map<String,Object> maps = Maps.newHashMap();
            maps.put("typeId",typeId);
            maps.put("vendorId",user.getVendorId());
            Integer result = vendorMessageManager.readAll(maps);
            response.setResult(Boolean.TRUE);
        }catch (Exception e){
            log.error("vendor.message.read.all.fail,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.message.read.all.fail");
        }
        return response;
    }




    public Response<Boolean> readMessage(String id){
        Response<Boolean> response = Response.newResponse();
        try {
            Map<String,Object> maps = Maps.newHashMap();
            Integer result = vendorMessageManager.readMessage(id);
            response.setResult(Boolean.TRUE);
        }catch (Exception e){
            log.error("vendor.message.read.all.fail,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.message.read.all.fail");
        }
        return response;
    }

}
