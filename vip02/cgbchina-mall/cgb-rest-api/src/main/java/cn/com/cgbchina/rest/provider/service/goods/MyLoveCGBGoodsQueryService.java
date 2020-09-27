package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQueryReturn;

/**
 * MAL119 猜我喜欢广发商品查询
 * 
 * @author lizy 2016/4/28.
 */
public interface MyLoveCGBGoodsQueryService {
	MyLoveCGBGoodsQueryReturn query(MyLoveCGBGoodsQuery myLoveCGBGoodsQueryObj);
}
