package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQuery;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQueryReturn;
import cn.com.cgbchina.rest.provider.service.activity.ActivityQueryService;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryVO;
import lombok.extern.slf4j.Slf4j;

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
	ActivityQueryService activityQueryService;

	@Override
	public ActivityQueryReturnVO process(SoapModel<ActivityQueryVO> model, ActivityQueryVO content) {
		ActivityQuery activityQuery = BeanUtils.copy(content, ActivityQuery.class);
		ActivityQueryReturn activityQueryReturn = activityQueryService.query(activityQuery);
		ActivityQueryReturnVO activityQueryReturnVO = BeanUtils.copy(activityQueryReturn,
				ActivityQueryReturnVO.class);
		return activityQueryReturnVO;
	}

}
