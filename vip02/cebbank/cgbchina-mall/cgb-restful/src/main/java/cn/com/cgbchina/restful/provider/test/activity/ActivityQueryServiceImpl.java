package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.activity.ActivityQueryService;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQuery;


@Service
public class ActivityQueryServiceImpl implements ActivityQueryService {
	@Override
	public ActivityQueryReturn query(ActivityQuery activityQuery) {
		ActivityQueryReturn activityQueryReturn = BeanUtils.randomClass(ActivityQueryReturn.class);
		return activityQueryReturn;
	}

}

