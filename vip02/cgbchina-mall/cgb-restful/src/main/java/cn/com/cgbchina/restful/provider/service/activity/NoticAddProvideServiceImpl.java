package cn.com.cgbchina.restful.provider.service.activity;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.promotion.model.EspActRemindModel;
import cn.com.cgbchina.promotion.service.EspActRemindService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddVO;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * MAL331 添加提醒 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL331")
@Slf4j
public class NoticAddProvideServiceImpl implements  SoapProvideService <NoticAddVO,NoticAddReturnVO>{

	@Resource
	EspActRemindService espActRemindService;

	@Resource
	MallPromotionService mallPromotionService;

	/**
	 * 添加提醒
	 * @param model
	 * @param content 添加参数
	 * @return 添加结果
	 *
	 * geshuo 20160721
	 */
	@Override
	public NoticAddReturnVO process(SoapModel<NoticAddVO> model, NoticAddVO content) {
		NoticAddReturnVO noticAddReturnVO = new NoticAddReturnVO();
		try {
			String origin = content.getOrigin();// 发起方
			String mallType = StringUtil.dealNull(content.getMallType());// 商城类型
			String custId = StringUtil.dealNull(content.getCustId());// 客户号
			String mobile = StringUtil.dealNull(content.getMoblie());// 手机号码
			String actId = StringUtil.dealNull(content.getActId());//场次id
			String goodsId = StringUtil.dealNull(content.getGoodsId());//商品编码
			String endDate = StringUtil.dealNull(content.getEndDate());//截止日期
			String endTime = StringUtil.dealNull(content.getEndTime());//截止时间
//			String doDate = noticeAdd.getDoDate();//操作日期
//			String doTime = noticeAdd.getDoTime();//操作时间

			origin = changeOrigin(origin);
			if(StringUtils.isEmpty(actId)){
				noticAddReturnVO.setReturnCode("000008");
				noticAddReturnVO.setReturnDes("报文参数错误:活动编号必须填写");
				return noticAddReturnVO;
			}

			//检查活动是否存在
			Response<Boolean> checkResponse = mallPromotionService.findPromotionExists(actId,origin,goodsId);
			if(!checkResponse.isSuccess()){
				log.error("NoticAddProvideServiceImpl.add --> mallPromotionService.findPromByItemCodes.error");
				noticAddReturnVO.setReturnCode("000027");
				noticAddReturnVO.setReturnDes("添加提醒异常");
				return noticAddReturnVO;
			}
			if(checkResponse.getResult() == null || !checkResponse.getResult()){
				noticAddReturnVO.setReturnCode("000104");
				noticAddReturnVO.setReturnDes("活动不存在");
				return noticAddReturnVO;
			}

			EspActRemindModel espActRemindModel = new EspActRemindModel();
			if(StringUtils.isNotEmpty(actId)){
				espActRemindModel.setActId(Long.parseLong(actId));//场次id
			}
			espActRemindModel.setGoodsId(goodsId);//商品编码
			espActRemindModel.setCustId(custId);// 客户号
			String mesDate = endDate + endTime;
			espActRemindModel.setMesDatetime(DateHelper.string2Date(mesDate, "yyyyMMddHHmmss"));
			espActRemindModel.setCustMobile(mobile);

			if("01".equals(mallType)){
				espActRemindModel.setOrdertypeId("YG");//ORDERTYPE_ID --YG：广发 JF：积分
			}else{
				espActRemindModel.setOrdertypeId("JF");//ORDERTYPE_ID --YG：广发 JF：积分
			}
			espActRemindModel.setSendFlag("0"); //SEND_FLAG  --0：未发送 1：已发送 2：发送中

			//添加提醒
			Response insertResponse = espActRemindService.insert(espActRemindModel);
			if(!insertResponse.isSuccess()){
				log.error("NoticAddProvideServiceImpl.add --> espActRemindService.insert.error ");
				noticAddReturnVO.setReturnCode("000027");
				noticAddReturnVO.setReturnDes("添加提醒异常");
				return noticAddReturnVO;
			}

			noticAddReturnVO.setReturnCode("000000");
			noticAddReturnVO.setReturnDes("添加提醒成功");
		} catch (Exception e) {
			log.error("NoticAddProvideServiceImpl.add.error Exception:{}", Throwables.getStackTraceAsString(e));
			noticAddReturnVO.setReturnCode("000027");
			noticAddReturnVO.setReturnDes("添加提醒异常");
		}
		return noticAddReturnVO;
	}


	/**
	 * 转换微信渠道的”发起方“
	 * 发起方     微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS
	 * 对应数据库  微信广发银行：05；微信信用卡中心：06；易信广发银行：07；易信信用卡中心：08
	 */
	private String changeOrigin(String origin){
		if(Contants.CHANNEL_SN_WX.equals(origin)){
			return Contants.SOURCE_ID_WECHAT;
		}
		if(Contants.CHANNEL_SN_WS.equals(origin)){
			return Contants.SOURCE_ID_WECHAT_A;
		}
		if(Contants.CHANNEL_SN_YX.equals(origin)){
			return Contants.SOURCE_ID_YIXIN;
		}
		if(Contants.CHANNEL_SN_YS.equals(origin)){
			return Contants.SOURCE_ID_YIXIN_A;
		}
		return origin;
	}
}
