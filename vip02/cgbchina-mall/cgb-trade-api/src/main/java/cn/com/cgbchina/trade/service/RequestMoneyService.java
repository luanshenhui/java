package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.HashMap;
import java.util.Map;

/**
 * Cre11150721040343 on 16-4-12.
 */
public interface RequestMoneyService {

    /**
     * 根据orderIdList更新订单子表（供应商请款申请）
     *
     * @param dataMap
     * @return
     */
	Response<Integer> updateById(Map<String,Object> dataMap);

    /**
     * 运营商拒绝请款，更新订单子表
     *
     * @param map
     * @return
     */
	Response<Integer> updateRefuseById(HashMap<String, Object> map);

    /**
     * 运营商同意请款，更新订单子表
     *
     * @param map
     * @return
     */
	Response<Integer> updatePassById(HashMap<String, Object> map);


    /**
     * 供应商查找请款订单
     * @param pageNo
     * @param size
     * @param orderId
     * @param goodssendFlag
     * @param sinStatusId
     * @param goodsNm
     * @param startTime
     * @param endTime
     * @return
     */
	Response<Pager<RequestOrderDto>> findOrderQuest(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
													@Param("orderId") String orderId, @Param("goodssendFlag") String goodssendFlag,
													@Param("sinStatusId") String sinStatusId, @Param("goodsNm") String goodsNm,@Param("tblFlag") String tblFlag,
													@Param("startTime") String startTime,@Param("orderType") String orderType, @Param("endTime") String endTime,  @Param("")User user);

    /**
     * 运营商查找请款订单
     * @param pageNo
     * @param size
     * @param vendorSnm
     * @param orderId
     * @param cardno
     * @param startTime
     * @param endTime
     * @param sinStatusId
     * @param tblFlag
     * @param orderType
     * @param tabNumber
     * @return
     */
	Response<Pager<RequestOrderDto>> findOrderQuestAdmin(@Param("pageNo") Integer pageNo,@Param("size") Integer size,
														 @Param("ordermainId") String ordermainId,@Param("orderId") String orderId,
														 @Param("cardno") String cardno,@Param("startTime") String startTime,
														 @Param("endTime") String endTime,@Param("sinStatusId") String sinStatusId,
														 @Param("tblFlag") String tblFlag,@Param("orderType") String orderType,
														 @Param("vendorSnm") String vendorSnm,@Param("tabNumber") String tabNumber);

	/**
	 * 供应商请款导出报表
	 * @param user
	 * @return
	 */
	Response<Boolean> exportRequest(OrderQueryConditionDto conditionDto, String systemType, User user, String roleFlag);


	public String getApplayPayExport(String userId,String systemType,String orderType);
}
