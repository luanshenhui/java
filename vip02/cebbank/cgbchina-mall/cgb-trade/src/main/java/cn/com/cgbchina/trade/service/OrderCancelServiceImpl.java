package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.TblOrderCheckDao;
import cn.com.cgbchina.trade.dao.TblOrderDao;
import cn.com.cgbchina.trade.dao.TblOrderDao2;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-6-27.
 */
@Service
@Slf4j
public class OrderCancelServiceImpl implements OrderCancelService {

    @Resource
    private TblOrderDao2 tblOrderDao2;
    @Resource
    private TblOrderCheckDao tblOrderCheckDao;
    @Resource
    private TblOrderDao tblOrderDao;
    @Resource
    private OrderDoDetailDao orderDoDetailDao;


    @Override
    public Response<Integer> getCountOverOrder(Map<String, Object> paramMap) {
        Response<Integer> response = new Response<Integer>();
        Integer count = tblOrderDao2.getCountOverOrder(paramMap);
        response.setResult(count);
        return response;
    }
    public Response<List<OrderSubModel>> getOverOrders(String date, String orderId, Integer fetchNo){
        Response<List<OrderSubModel>> response = new Response<List<OrderSubModel>>();
        List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();

        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("create_time",date);
        paramMap.put("order_id",orderId);
        paramMap.put("fetch_no",fetchNo);
        orderSubModelList = tblOrderDao2.getOverOrders(paramMap);
        response.setResult(orderSubModelList);
        return response;
    }

    public void updateOrderStatus(String orderId, String statusId, String statusNm, String modifyOper){
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("order_id",orderId);
        paramMap.put("cur_status_id",statusId);
        paramMap.put("cur_status_nm",statusNm);
        paramMap.put("modify_oper",modifyOper);
        tblOrderDao2.updateOrderStatus(paramMap);
    }

    public void insertOrderDoDetail(String orderMainId, String statusId, String statusNm, String modifyOper){
        OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
        orderDoDetailModel.setOrderId(orderMainId);
        orderDoDetailModel.setStatusId(statusId);
        orderDoDetailModel.setStatusNm(statusNm);
        orderDoDetailModel.setModifyOper(modifyOper);
        orderDoDetailModel.setUserType("0");//0：系统用户[批量]
        orderDoDetailModel.setDoUserid(modifyOper);
        orderDoDetailModel.setCreateOper(modifyOper);
        orderDoDetailModel.setDelFlag(0);
        orderDoDetailDao.insert(orderDoDetailModel);
    }

    public Response<OrderSubModel> getTblOrder(String orderId){
        Response<OrderSubModel> response = new Response<OrderSubModel>();
        OrderSubModel orderSubModel = new OrderSubModel();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("orderId",orderId);
        orderSubModel = tblOrderDao.getTblOrder(paramMap);
        response.setResult(orderSubModel);
        return response;
    }
    public Response<List<OrderCheckModel>> getOrderCheckListByOrderId(String orderId){
        Response<List<OrderCheckModel>> response = new Response<List<OrderCheckModel>>();
        List<OrderCheckModel> orderCheckModelList = new ArrayList<OrderCheckModel>();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("orderId",orderId);
        orderCheckModelList = tblOrderCheckDao.orderCancelService(paramMap);
        response.setResult(orderCheckModelList);
        return response;
    }

    public void saveTblOrderCheck(OrderCheckModel orderCheckModel){
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("order_id",orderCheckModel.getOrderId());
        paramMap.put("cur_status_id",orderCheckModel.getCurStatusId());
        paramMap.put("cur_status_nm",orderCheckModel.getCurStatusNm());
        paramMap.put("do_time",orderCheckModel.getDoTime());
        paramMap.put("ispoint",orderCheckModel.getIspoint());
        tblOrderCheckDao.saveTblOrderCheck(paramMap);
    }

    public void saveOrderCheck(OrderCheckModel orderCheckModel){
        tblOrderCheckDao.saveTblOrderCheck(orderCheckModel);
    }

    public void updateOrderMainStatus(String orderMainId, String statusId, String statusNm, String modifyOper){
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("ordermain_id",orderMainId);
        paramMap.put("cur_status_id",statusId);
        paramMap.put("cur_status_nm",statusNm);
        paramMap.put("modify_oper",modifyOper);
        tblOrderDao2.updateOrderMainStatus(paramMap);
    }
    public Response<Integer> getTblEspCustNew(String custId){
        Response<Integer> response = new Response<Integer>();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("cust_id",custId);
        Integer count = tblOrderDao2.getTblEspCustNew(paramMap);
        response.setResult(count);
        return response;
    }
    public void updateTblEspCustNew(String custId, int num){
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("cust_id",custId);
        paramMap.put("birth_used_count",num);
        tblOrderDao2.updateTblEspCustNew(paramMap);
    }
    public void updateTblEspCustNew0(String custId){
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("cust_id",custId);
        tblOrderDao2.updateTblEspCustNew0(paramMap);
    }
    public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                              @Param("ordermainId") String ordermainId,
                                              @Param("orderId") String orderId,
                                              @Param("fromTime") String fromTime,
                                              @Param("toTime") String toTime,
                                              @Param("ordertypeId") String ordertypeId,
                                              @Param("sourceId") String sourceId,
                                              @Param("") User user){
        Response<Pager<OrderInfoDto>> response = new Response<Pager<OrderInfoDto>>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> paramMap = Maps.newHashMap();
        // 获取用户ID
        String id = user.getId();
        LocalDate endDate = LocalDate.now();
        LocalDate startDateMIn6 = endDate.minusMonths(6);
        String vendorid = user.getVendorId();
        // 判断订单账号是否为空
        if (isNotBlank(orderId)) {
            paramMap.put("orderId", orderId);
        }
        if (isNotBlank(vendorid)) {
            paramMap.put("vendor_id", vendorid);
        }
        if (isNotBlank(fromTime)) {
            paramMap.put("from_time", fromTime);
        }
        if (isNotBlank(toTime)) {
            paramMap.put("to_time", toTime);
        }
        if (isNotBlank(ordertypeId)) {
            paramMap.put("ordertype_id", ordertypeId);
        }
        if (isNotBlank(sourceId)) {
            paramMap.put("source_id", sourceId);
        }
        List<OrderInfoDto> orderInfoDtos = new ArrayList<OrderInfoDto>();

//        Pager<OrderSubModel> pager = tblOrderDao.findLikeByPage(paramMap, pageInfo.getOffset(),
//                pageInfo.getLimit());
//
//        response.setResult(new Pager<OrderInfoDto>(pager.getTotal(), orderInfoDtos));
        return response;
    }
    // 判断非空
    private Boolean isNotBlank(String str) {
        if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
            return Boolean.TRUE;
        return Boolean.FALSE;
    }
}
