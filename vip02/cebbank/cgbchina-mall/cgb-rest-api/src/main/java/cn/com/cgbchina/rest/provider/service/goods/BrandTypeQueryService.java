package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQuery;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQueryReturn;

/**
 * MAL336 类别品牌查询
 * 
 * @author lizy 2016/4/28.
 */
public interface BrandTypeQueryService {
	BrandTypeQueryReturn query(BrandTypeQuery brandTypeQuery);
}
