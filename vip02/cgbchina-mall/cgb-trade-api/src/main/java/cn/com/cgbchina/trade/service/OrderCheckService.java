package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.trade.dto.AppStageMallPayVerificationReturnSubVO;

import cn.com.cgbchina.trade.model.*;
import com.spirit.common.model.Response;

/**
 * Created by guixin1.ma on 16-8-3.
 */
public interface OrderCheckService {
	TblEspCustCartModel getTblEspCustCart(String cartId);
	TblOrderExtend1Model queryTblOrderExtend1(Long orderExtend1Id);
	boolean isPractiseRun(String cardNo);

	Integer updateOrder(OrderSubModel model);

	void insertOrderCancel(OrderCancelModel model);

	void insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel);

	List<OrderDoDetailModel> findByOrderId(String orderId);

	Object getTblOrderById(String orderId,String flag);

	void orderReturnwithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDodetail,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory);

	List<Map> getBigMachineParam();

	TblOrderExtend1Model findExtend1ByOrderId (String orderId);

	Integer insertOutSystem (String mainId,String id);

	List findJudgeQT(String ordertypeId, String sourceId);

	Response dealProcess(List<AppStageMallPayVerificationReturnSubVO> subVOs, Map<String, Integer> rollBackStockMap, Map<String, Long> pointMap);
	/**
	 * 电子支付验签
	 * */
	boolean verify_md(String inbuf, String sign);
}
