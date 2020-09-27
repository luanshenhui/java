package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.promotion.service.EspActRemindService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancel;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancelReturn;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelVO;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;
import java.util.Map;

/**
 * MAL332 取消提醒 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL332")
@Slf4j
public class NoticCancelProvideServiceImpl implements  SoapProvideService <NoticCancelVO,NoticCancelReturnVO>{

	@Resource
	EspActRemindService espActRemindService;
	/**
	 * 取消提醒
	 * @param model
	 * @param content 删除参数
	 * @return 删除结果
	 *
	 * geshuo 20160728
	 */
	@Override
	public NoticCancelReturnVO process(SoapModel<NoticCancelVO> model, NoticCancelVO content) {
		NoticCancelReturnVO noticCancelReturnVO = new NoticCancelReturnVO();

		try {
//			String origin = noticCancel.getOrigin();// 发起方
			String custId = StringUtil.dealNull(content.getCustId());// 客户号
			String actId = StringUtil.dealNull(content.getActId());//场次id
			String goodsId = StringUtil.dealNull(content.getGoodsId());//商品编码
			String endDate = StringUtil.dealNull(content.getEndDate());//截止日期
			String endTime = StringUtil.dealNull(content.getEndTime());//截止时间

			Map<String,Object> paramMap = Maps.newHashMap();
			paramMap.put("actId",actId);
			paramMap.put("goodsId",goodsId);
			paramMap.put("custId",custId);
			Date mesDatetime = DateHelper.string2Date(endDate + endTime, "yyyyMMddHHmmss");
			paramMap.put("mesDatetime",mesDatetime);
			//删除提醒记录
			Response<Integer> deleteResponse = espActRemindService.deleteRemindByParams(paramMap);

			if(!deleteResponse.isSuccess()){
				log.error("NoticCancelProvideServiceImpl.cancel--> espActRemindService.deleteRemindByParams.error paramMap:{}",paramMap);
				noticCancelReturnVO.setReturnCode("000027");
				noticCancelReturnVO.setReturnDes("取消提醒异常");
				return noticCancelReturnVO;
			}

			Integer count = deleteResponse.getResult();
			if(count<1){
				//更新数量为0
				noticCancelReturnVO.setReturnCode("000106");
				noticCancelReturnVO.setReturnDes("无提醒记录");
				return noticCancelReturnVO;
			}

			noticCancelReturnVO.setReturnCode("000000");
			noticCancelReturnVO.setReturnDes("取消提醒成功");
		} catch (Exception e) {
			log.error("NoticCancelProvideServiceImpl.cancel.error Exception:{}", Throwables.getStackTraceAsString(e));
			noticCancelReturnVO.setReturnCode("000027");
			noticCancelReturnVO.setReturnDes("取消提醒异常");
		}

		return noticCancelReturnVO;
	}

}
