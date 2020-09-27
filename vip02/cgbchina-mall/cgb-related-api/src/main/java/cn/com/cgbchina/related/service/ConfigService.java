/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.TblConfigModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.AdvertisingManageModel;

/**
 *
 */
public interface ConfigService {

	public Response<TblConfigModel> findByCfgType(String cfgType);

}
