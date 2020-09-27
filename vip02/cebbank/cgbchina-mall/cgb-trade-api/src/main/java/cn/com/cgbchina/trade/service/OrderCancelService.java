package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-6-27.
 */
public interface OrderCancelService {
    public Response<Integer> getCountOverOrder(Map<String, Object> paramMap);
    public Response<List<OrderSubModel>> getOverOrders(String date, String orderId, Integer fetchNo);
    public void updateOrderStatus(String orderId, String statusId, String statusNm, String modifyOper);
    public void insertOrderDoDetail(String orderMainId, String statusId,String statusNm, String modifyOper);
    public Response<OrderSubModel> getTblOrder(String orderId);
    public Response<List<OrderCheckModel>> getOrderCheckListByOrderId(String orderId);
    public void saveTblOrderCheck(OrderCheckModel orderCheckModel);
    public void updateOrderMainStatus(String orderMainId, String statusId,
                                      String statusNm, String modifyOper);
    public Response<Integer> getTblEspCustNew(String custId);

    public void updateTblEspCustNew(String custId, int num);
    public void updateTblEspCustNew0(String custId);
    public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                              @Param("ordermainId") String ordermainId,
                                              @Param("orderId") String orderId,
                                              @Param("fromTime") String fromTime,
                                              @Param("toTime") String toTime,
                                              @Param("ordertypeId") String ordertypeId,
                                              @Param("sourceId") String sourceId,
                                              @Param("") User user);
    public void saveOrderCheck(OrderCheckModel orderCheckModel);

}
