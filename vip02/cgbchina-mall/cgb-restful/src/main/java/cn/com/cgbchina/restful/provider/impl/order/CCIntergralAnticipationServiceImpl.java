package cn.com.cgbchina.restful.provider.impl.order;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipation;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipationReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralAnticipationService;
import cn.com.cgbchina.trade.service.PriorJudgeService;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

/**
 * MAL201 CC积分商城预判接口
 * 
 * @author huangchaoyong
 * 
 */
@Service
@Slf4j
public class CCIntergralAnticipationServiceImpl implements CCIntergralAnticipationService {
	@Resource
	private PriorJudgeService priorJudgeService;
	@Resource
	private ItemService itemService;

	@Override
	public CCIntergralAnticipationReturn intergralAnticipation(CCIntergralAnticipation ccIntergralAnticipation) {
		CCIntergralAnticipationReturn ccIntergralAnticipationReturn = new CCIntergralAnticipationReturn();
		String certNo = ccIntergralAnticipation.getCertNo();
		String cardNo = ccIntergralAnticipation.getCardNo();
		String goodsXId = ccIntergralAnticipation.getGoodsId();
		String formatId = ccIntergralAnticipation.getFormatId();
		try {
			Response<ItemModel> itemRepsonse =  itemService.findItemByXid(goodsXId);
			if (!itemRepsonse.isSuccess() || itemRepsonse.getResult() == null) {
				// 查找商品
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.NotFound_Gift_Code);
				ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.NotFound_Gift_Msg);
				return ccIntergralAnticipationReturn;
			}
			ItemModel itemModel = itemRepsonse.getResult();
			String res = priorJudgeService.preJudge(certNo, cardNo, formatId, itemModel.getCode(), "0");
			if ("-1".equals(res)) {
				// 查找商品
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.NotFound_Gift_Code);
				ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.NotFound_Gift_Msg);
				return ccIntergralAnticipationReturn;
			} else if ("1".equals(res)) {
				// 判断卡板是否符合
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.NotMatch_Format_Code);
				ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.NotMatch_Format_Msg);
				return ccIntergralAnticipationReturn;
			} else if ("2".equals(res)) {
				// 在限定时间内是否已购买
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.Bought_Goods_Code);
				ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.Bought_Goods_Msg);
				return ccIntergralAnticipationReturn;
			}else if ("5".equals(res)) {
				// 在限定时间内是否已购买
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.Bought_Goods_Code);
				ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.Bought_Goods_Msg);
			} else if ("0".equals(res)) {
				// 正常,可以购买
				ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				ccIntergralAnticipationReturn.setReturnDes("该卡号可以购买该虚拟礼品");
			}
		} catch (Exception e) {
			log.error("CC积分商城预判接口Exception:{}", Throwables.getStackTraceAsString(e));
			ccIntergralAnticipationReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			ccIntergralAnticipationReturn.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
			return ccIntergralAnticipationReturn;
		}

		return ccIntergralAnticipationReturn;
	}
}
