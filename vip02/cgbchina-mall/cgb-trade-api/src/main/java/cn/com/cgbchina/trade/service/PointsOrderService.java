package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 11141021040453 on 16-4-15.
 */
public interface PointsOrderService {

    /**
     * 查找
     *
     * @return
     */
    public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                              @Param("orderId") String orderId, @Param("goodsType") String goodsType, @Param("curStatusId") String curStatusId,
                                              @Param("sourceId") String sourceId, @Param("goodsId") String goodsId, @Param("memberName") String memberName, @Param("vendorSnm") String vendorSnm,
                                              @Param("startTime") String startTime, @Param("endTime") String endTime, @Param("cardno") String cardno,
                                              @Param("custType") String custType, @Param("limitFlag") String limitFlag, @Param("") User user, @Param("searchType")String searchType);

    /**
     * 查看订单详情
     *
     * @param id
     * @param user
     * @return
     */
    public Response<OrderDetailDto> findOrderInfo(@Param("id") String id,  @Param("") User user);

    /**
     * 通过订单id查询退货信息或撤单信息
     *
     * @param orderId
     * @return
     */
    public Response<OrderReturnDetailDto> findOrderReturnDetail(String orderId);
}
