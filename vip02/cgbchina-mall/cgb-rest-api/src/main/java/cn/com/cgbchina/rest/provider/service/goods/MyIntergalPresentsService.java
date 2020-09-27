package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsReturn;

/**
 * MAL118 适合我的积分礼品查询
 * 
 * @author lizy 2016/4/28.
 */
public interface MyIntergalPresentsService {
	MyIntergalPresentsReturn query(MyIntergalPresentsQuery myIntergalPresentsQueryObj);
}
