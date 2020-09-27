package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentQuery;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentReturn;

/**
 * MAL101 CC积分商城礼品列表查询
 * 
 * @author lizy
 *
 */
public interface CCIntergralPresentsQueryService {
	CCIntergalPresentReturn query(CCIntergalPresentQuery ccIntergalPresentQueryObj);
}
