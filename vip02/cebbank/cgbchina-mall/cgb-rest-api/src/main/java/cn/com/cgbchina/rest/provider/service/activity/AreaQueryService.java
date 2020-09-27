package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.Area;
import cn.com.cgbchina.rest.provider.model.activity.AreaQueryReturn;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public interface AreaQueryService {
	AreaQueryReturn query(Area area);
}
