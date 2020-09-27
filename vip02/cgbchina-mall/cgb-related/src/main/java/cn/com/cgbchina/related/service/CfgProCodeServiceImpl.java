package cn.com.cgbchina.related.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.related.dao.TblCfgProCodeDao;
import cn.com.cgbchina.related.model.TblCfgProCodeModel;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

/**
 * @author
 * @version 1.0
 * @Since 2016/7/4.
 */
@Service
@Slf4j
public class CfgProCodeServiceImpl implements CfgProCodeService {

	@Resource
	private TblCfgProCodeDao tblCfgProCodeDao;

	/**
	 * 返回表头和参数信息
	 *
	 * @return
	 */
	@Override
	public Response<List<TblCfgProCodeModel>> findProCodeInfo() {
		Response<List<TblCfgProCodeModel>> response = new Response<List<TblCfgProCodeModel>>();
		try {
			List<TblCfgProCodeModel> cfgProCodeList = tblCfgProCodeDao.findProCodeInfo();
			response.setResult(cfgProCodeList);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

	@Override
	public Response<String> findProcode(String ordertypeId, String proType, String proCode) {
		Response<String> response = new Response<String>();
		try {
			Map<String, String> params = new HashMap<String, String>();
			params.put("ordertypeId", ordertypeId);
			params.put("proType", proType);
			params.put("proCode", proCode);
			TblCfgProCodeModel tblCfgProCodeModel = tblCfgProCodeDao.findProcode(params);
			response.setResult(tblCfgProCodeModel == null ? "" : tblCfgProCodeModel.getProDesc());
		} catch (Exception e) {
			log.error("【CfgProcodeServiceImpl.findProcode.error】MAL335 特殊商品列表查询  预设关键字查询失败", e);
			response.setError("CfgProcodeServiceImpl.findProcode.error");
		}
		return response;
	}

	/**
	 * 根据参数查询
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	public Response<List<TblCfgProCodeModel>> findProCodeByParams(Map<String,Object> paramMap){
		Response<List<TblCfgProCodeModel>> response = Response.newResponse();
		try {
			List<TblCfgProCodeModel> dataList = tblCfgProCodeDao.findProCodeByParams(paramMap);
			response.setResult(dataList);
		} catch (Exception e) {
			log.error("CfgProCodeServiceImpl.findProCodeByParams.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("CfgProCodeServiceImpl.findProCodeByParams.error");
		}
		return response;
	}
}
