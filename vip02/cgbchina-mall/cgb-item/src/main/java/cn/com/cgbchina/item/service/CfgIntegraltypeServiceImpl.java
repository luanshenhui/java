package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 积分类型Service
 *
 * geshuo 20160823
 */
@Service
@Slf4j
public class CfgIntegraltypeServiceImpl implements CfgIntegraltypeService {
	@Resource
	private TblCfgIntegraltypeDao tblCfgIntegraltypeDao;

	/**
	 * 查询积分类型
	 * @param id 积分类型id
	 * @return 查询结果
	 *
	 * geshuo 20160823
	 */
	@Override
	public Response<TblCfgIntegraltypeModel> findById(String id) {
		Response<TblCfgIntegraltypeModel> response = new Response<>();
		try {
			TblCfgIntegraltypeModel model = tblCfgIntegraltypeDao.findById(id);
			response.setResult(model);
		} catch (Exception e) {
			log.error("CfgIntegraltypeServiceImpl.findById.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("CfgIntegraltypeServiceImpl.findById.error");
		}
		return response;
	}

	/**
	 * 查询积分类型列表
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160823
	 */
	public Response<List<TblCfgIntegraltypeModel>> findByParams(Map<String,Object> paramMap){
		Response<List<TblCfgIntegraltypeModel>> response = new Response<>();
		try {
			List<TblCfgIntegraltypeModel> dataList = tblCfgIntegraltypeDao.findByParams(paramMap);
			response.setResult(dataList);
		} catch (Exception e) {
			log.error("CfgIntegraltypeServiceImpl.findById.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("CfgIntegraltypeServiceImpl.findById.error");
		}
		return response;
	}
}
