package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.TblCfgProCodeModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface CfgProCodeService {

	/**
	 * 返回表头和参数信息
	 *
	 * @return
	 */
	public Response<List<TblCfgProCodeModel>> findProCodeInfo();
}
