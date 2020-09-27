package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.TblCfgProCodeModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

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
	/**
	 * 查询预设关键字
	 * @param ordertypeId
	 * @param proType
	 * @param proCode
	 * @return
	 */
	Response<String> findProcode(String ordertypeId, String proType, String proCode);

	/**
	 * 根据参数查询
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	public Response<List<TblCfgProCodeModel>> findProCodeByParams(Map<String,Object> paramMap);
}
