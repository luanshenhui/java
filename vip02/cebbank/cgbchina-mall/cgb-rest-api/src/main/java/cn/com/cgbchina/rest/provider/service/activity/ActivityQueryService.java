package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.ActivityQuery;
import cn.com.cgbchina.rest.provider.model.activity.ActivityQueryReturn;

/**
 * MAL330 场次列表查询
 * 
 * @author lizy 2016/4/28.
 */
public interface ActivityQueryService {
	ActivityQueryReturn query(ActivityQuery activeQuery);
}
