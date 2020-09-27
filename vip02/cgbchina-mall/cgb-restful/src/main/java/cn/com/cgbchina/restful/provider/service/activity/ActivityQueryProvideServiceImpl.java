package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.PromotionPeriodDetailDto;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryInfoVO;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryVO;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * MAL330 场次列表查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL330")
@Slf4j
public class ActivityQueryProvideServiceImpl implements  SoapProvideService <ActivityQueryVO,ActivityQueryReturnVO>{
	@Resource
	MallPromotionService mallPromotionService;
	/**
	 * 场次列表查询
	 * @param model
	 * @param content 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160728
	 */
	@Override
	public ActivityQueryReturnVO process(SoapModel<ActivityQueryVO> model, ActivityQueryVO content) {
		ActivityQueryReturnVO result = new ActivityQueryReturnVO();

		String origin = content.getOrigin();//发起方
		String rowsPage = content.getRowsPage();//每页行数
		String currentPage = content.getCurrentPage();//当前页数
		String actId = content.getActId();//场次Id
		origin = changeOrigin(origin);

		try{
			int rowsPageInt = 1;
			int currentPageInt = 1;
			if(StringUtils.isNotEmpty(rowsPage)){
				rowsPageInt=Integer.parseInt(rowsPage);
			}
			if(StringUtils.isNotEmpty(currentPage)){
				currentPageInt=Integer.parseInt(currentPage);
			}

			PageInfo info = new PageInfo(currentPageInt,rowsPageInt);
			
			Response<Pager<PromotionPeriodDetailDto>> periodResponse = mallPromotionService.findMiaoShaoPromotionPeroidList(origin, actId, info);
			if(!periodResponse.isSuccess()){
				log.error("ActivityQueryProvideServiceImpl.query --> mallPromotionService.findPromotionPeriodList.error {}" ,periodResponse.getError());
				result.setReturnCode("000009");
				result.setReturnDes("场次查询异常");
				return result;
			}

			Pager<PromotionPeriodDetailDto> pagerObj = periodResponse.getResult();
			Long totalCount = pagerObj.getTotal();

			BigDecimal totalCountDecimal = new BigDecimal(totalCount);
			BigDecimal pageSizeDecimal = new BigDecimal(rowsPageInt);
			Long totalPage = totalCountDecimal.divide(pageSizeDecimal,0,BigDecimal.ROUND_CEILING).longValue();//计算总页数

			result.setTotalCount(String.valueOf(totalCount));//总数
			result.setTotalPages(String.valueOf(totalPage));//设置返回总页数

			List<PromotionPeriodDetailDto> periodDtoList = pagerObj.getData();

			List<ActivityQueryInfoVO> infoList = Lists.newArrayList();
			if (periodDtoList != null && periodDtoList.size() > 0) {
				String mallDate = DateHelper.getyyyyMMdd();//商城日期
				String mallTime = DateHelper.getHHmmss();//商城时间
				result.setMallDate(mallDate);
				result.setMallTime(mallTime);

				for (PromotionPeriodDetailDto periodDto:periodDtoList) {//组装循环体
					ActivityQueryInfoVO infoItem = new ActivityQueryInfoVO();

					infoItem.setActId(String.valueOf(periodDto.getPromotionId()));//活动 id
					infoItem.setActNm(periodDto.getPromotionName());//活动名称
					infoItem.setActDesc(periodDto.getDescription());//活动描述
					infoItem.setActStatus("1");//默认都是返回审核通过的状态的场次。即“1-审核通过”

					Date beginDate = periodDto.getBeginDate();
					infoItem.setBeginDate(DateHelper.getyyyyMMdd(beginDate));
					infoItem.setBeginTime(DateHelper.getHHmmss(beginDate));

					Date endDate = periodDto.getEndDate();
					infoItem.setEndDate(DateHelper.getyyyyMMdd(endDate));
					infoItem.setEndTime(DateHelper.getHHmmss(endDate));

					infoList.add(infoItem);
				}
			}
			result.setInfos(infoList);
			result.setReturnCode("000000");
			result.setReturnDes("场次查询成功");

		}catch (Exception e){
			log.error("ActivityQueryProvideServiceImpl.query.error Exception:{}", Throwables.getStackTraceAsString(e));
			result.setReturnCode("000009");
			result.setReturnDes("场次查询异常");
			return result;
		}
		return result;
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
