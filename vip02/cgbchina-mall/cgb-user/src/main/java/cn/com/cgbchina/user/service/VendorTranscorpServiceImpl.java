package cn.com.cgbchina.user.service;

import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.user.dao.VendorTranscorpDao;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by guixin1.ma on 2016/7/28.
 */
@Service
@Slf4j
public class VendorTranscorpServiceImpl implements VendorTranscorpService {
    @Resource
    VendorTranscorpDao vendorTranscorpDao;


}
