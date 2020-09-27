package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.WXIntergral;
import cn.com.cgbchina.rest.provider.model.order.WXIntergralRefundReturn;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralVO;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL502 微信退积分接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL502")
@Slf4j
public class WXIntergralRefundProvideServiceImpl
		implements SoapProvideService<WXIntergralVO, WXIntergralRefundReturnVO> {
	@Resource
	TblOrderMainService tblOrderMainService;
	@Resource
	OrderService orderService;
	@Resource
	GoodsService goodsService;

	@Override
	public WXIntergralRefundReturnVO process(SoapModel<WXIntergralVO> model, WXIntergralVO content) {
		//操作表：tbl_order_main、 tbl_order、 tbl_item 、 tbl_order_cancel 、 tbl_order_extend2
		//传入参数：orderMainId  backMoney  backPoint
		//返回参数：returnCode  returnDes  errormsg  successCode

		//解析content
		WXIntergral wXIntergral = BeanUtils.copy(content, WXIntergral.class);
		//取出传入参数
		String orderMainId = wXIntergral.getOrderMainId();
		String backMoney = wXIntergral.getBackMoney();
		String backPoint = wXIntergral.getBackPoint();
		// 校验
		WXIntergralRefundReturnVO wxIntergralRefundReturnVO = check(orderMainId, backMoney, backPoint);
		if (wxIntergralRefundReturnVO != null) {
			return wxIntergralRefundReturnVO;
		}
		try {
			// 查询主订单
			Response<OrderMainModel> orderMainResponse = tblOrderMainService.findByOrderMainId(orderMainId);
			if (!orderMainResponse.isSuccess()) {
				log.error("orderMain.time.query.error，error:{}", orderMainResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "orderMain.time.query.error");
			}
			OrderMainModel orderMainModel = orderMainResponse.getResult();
			// 查询子订单
			Response<List<OrderSubModel>> orderSubResponse = orderService.findByorderMainId(orderMainId);
			if (!orderSubResponse.isSuccess()) {
				log.error("OrderServiceImpl.find.query.error，error:{}", orderMainResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "OrderServiceImpl.find.query.error");
			}
			List<OrderSubModel> orderSubModelList = orderSubResponse.getResult();

			if (null == orderMainModel || null == orderSubModelList || 0 == orderSubModelList.size()
					|| null == orderSubModelList.get(0)) {
				return commonErrorMsg("000013", "找不到订单");
			}

			OrderSubModel orderSubModel = orderSubModelList.get(0);
			// 获取单品编码
			String goodsId = orderSubModel.getGoodsId();
			// 根据单品编码（goodsId）查询单品信息
			Response<ItemModel> itemModelResponse = goodsService.findInfoById(goodsId);
			if (!orderSubResponse.isSuccess()) {
				log.error("findItemInfoById.goods.error，error:{}", orderMainResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "findItemInfoById.goods.error");
			}
			ItemModel itemModel = itemModelResponse.getResult();
			if (null == itemModel) {
				return commonErrorMsg("000031", "找不到商品");
			}
			// 获取主订单状态
			String curStatusIdMain = orderMainModel.getCurStatusId();
			// 获取子订单状态
			String curStatusId = orderSubModel.getCurStatusId();
			// 待付款0301 or 支付失败0307，不退积分，返回成功给微信
			if ((Contants.SUB_ORDER_STATUS_0301.equals(curStatusIdMain)
					&& Contants.SUB_ORDER_STATUS_0301.equals(curStatusId))
					|| (Contants.SUB_ORDER_STATUS_0307.equals(curStatusIdMain)
							&& Contants.SUB_ORDER_STATUS_0307.equals(curStatusId))) {
				return commonErrorMsg("000000", "正常");
			}
			// 状态未明 0316, 现有订单状态不能退积分 订单状态未明 0316
			else if (Contants.SUB_ORDER_STATUS_0316.equals(curStatusIdMain)
					&& Contants.SUB_ORDER_STATUS_0316.equals(curStatusId)) {
				return commonErrorMsg("000053", "现有订单状态不能退积分");
			}
			// 支付成功0308
			else if (Contants.SUB_ORDER_STATUS_0308.equals(curStatusIdMain)
					&& Contants.SUB_ORDER_STATUS_0308.equals(curStatusId)) {
				// 继续下面处理
			}
			// 其他状态 订单状态异常
			else {
				return commonErrorMsg("000000", "正常");
			}
			// 获取业务类型id JF-积分商城
			String orderTypeId = orderMainModel.getOrdertypeId();
			// 获取订单来源渠道 05-微信广发银行 06-微信广发信用卡
			String sourceId = orderMainModel.getSourceId();
			if ("JF".equals(orderTypeId) && (Contants.PROMOTION_SOURCE_ID_05.equals(sourceId)
					|| Contants.PROMOTION_SOURCE_ID_06.equals(sourceId))) {
				long totalBonus = orderMainModel.getTotalBonus();// 商品总积分数量
				BigDecimal totalPrice = orderMainModel.getTotalPrice();// 商品总价格
				Integer totalNum = orderMainModel.getTotalNum();// 商品总数量 (虚拟商品 大订单只有一条小订单)

				long backPointNum = Long.parseLong(backPoint);
				BigDecimal backMoneyNum = new BigDecimal(backMoney);
				// 总积分小于退积分 订单积分不匹配
				if (totalBonus < backPointNum) {
					return commonErrorMsg("000021", "订单积分不匹配");
				}
				// 0积分 订单积分不匹配
				if (0 == backPointNum) {
					return commonErrorMsg("000021", "订单积分不匹配");
				}
				// 总金额小于退金额 订单金额不匹配 ps:BigDecimal比较大小：a.compareTo(b) -1是a<b；0是a=b；1是a>b
				if (totalPrice.compareTo(backMoneyNum) == -1) {
					return commonErrorMsg("000020", "订单金额不匹配");
				}

				String partlyRefund = Contants.IS_PARTLY_REFUND_1;// 是否部分退款 1是 2否
				if (totalBonus == backPointNum) {
					partlyRefund = Contants.IS_PARTLY_REFUND_0;
				}
				long perBonus = totalBonus / totalNum; // 每个商品积分
				int backNum = (int) (backPointNum / perBonus);// 退货数量
				// 保存订单，扣减库存
				Long backlog = itemModel.getStock();
				// 是否需要扣减库存标志
				boolean subFlag = true;
				if (backlog >= 9999) {
					subFlag = false;
				}
				try {
					// 支付成功的订单退款
					orderService.updateVirtualOrderRefundWithTX(orderMainId, orderSubModel,
							Contants.SUB_ORDER_STATUS_0327, Contants.SUB_ORDER_RETURN_SUCCEED,
							Contants.ORDER_STATUS_CODE_HAS_ORDERS, backPointNum, backNum, partlyRefund, "微信退款",
							subFlag);
				} catch (Exception e) {
					log.error("系统繁忙，请稍后再试 退款ex:" + e.getMessage(), e);
					return commonErrorMsg("000009", "系统繁忙，请稍后再试");
				}
				return commonErrorMsg("000000", "正常");
			} else {
				return commonErrorMsg("000008", "报文参数错误:暂不支持非微信渠道退款");
			}
		} catch (Exception e) {
			log.error("WX return point：" + e.getMessage(), e);
			return commonErrorMsg("000009", "系统繁忙，请稍后再试");
		}
	}

	/**
	 * 校验
	 * 
	 * @param orderMainId
	 * @param backMoney
	 * @param backPoint
	 * @return
	 */
	private WXIntergralRefundReturnVO check(String orderMainId, String backMoney, String backPoint) {
		// 必要字段校验
		if (StringUtils.isEmpty(orderMainId)) {
			return commonErrorMsg("000008", "报文参数错误：大订单号为空");
		}
		if (StringUtils.isEmpty(backMoney)) {
			return commonErrorMsg("000008", "报文参数错误：退金额为空");
		}
		if (StringUtils.isEmpty(backPoint)) {
			return commonErrorMsg("000008", "报文参数错误：退积分为空");
		}
		return null;
	}

	/**
	 * 错误信息返回共通方法
	 * 
	 * @param returnCode
	 * @param returnDesc
	 * @return
	 */
	private WXIntergralRefundReturnVO commonErrorMsg(String returnCode, String returnDesc) {
		WXIntergralRefundReturn wxIntergralRefundReturn = new WXIntergralRefundReturn();
		wxIntergralRefundReturn.setReturnCode(returnCode);
		wxIntergralRefundReturn.setReturnDes(returnDesc);
		WXIntergralRefundReturnVO wXIntergralRefundReturnVO = BeanUtils.copy(wxIntergralRefundReturn,
				WXIntergralRefundReturnVO.class);
		return wXIntergralRefundReturnVO;
	}
}
