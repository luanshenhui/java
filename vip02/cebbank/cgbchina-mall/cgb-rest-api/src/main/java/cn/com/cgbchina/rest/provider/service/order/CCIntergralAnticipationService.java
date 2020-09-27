package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipation;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipationReturn;

/**
 * MAL201 CC积分商城预判接口
 * 
 * @author lizy 2016/4/28.
 */
public interface CCIntergralAnticipationService {
	CCIntergralAnticipationReturn intergralAnticipation(CCIntergralAnticipation CCIntergralAnticipationobj);
}
