package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentDetailQuery;
import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentReturn;

/**
 * IVR
 * 
 * @author lizy MAL103
 *
 */
public interface IVRIntergralPresentDetailService {
	IVRIntergralPresentReturn detail(IVRIntergralPresentDetailQuery ivrIntergralPresentDetailQueryObj);
}
