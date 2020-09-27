package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150221040129 on 16-4-8.
 */
@Service
@Slf4j
public class EspAreaInfServiceImpl implements EspAreaInfService {
	@Resource
	private EspAreaInfDao espAreaInfDao;
	/**
	 * 查询分区信息
	 * @param paramaMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160728
	 */
	@Override
	public Response<List<EspAreaInfModel>> findAreaInfoByParams(Map<String, Object> paramaMap) {
		Response<List<EspAreaInfModel>> response = new Response<>();
		try {
			List<EspAreaInfModel> areaList = espAreaInfDao.findAreaInfoByParams(paramaMap);
			response.setResult(areaList);
		} catch (Exception e) {
			log.error("EspAreaInfServiceImpl.findAreaInfoByParams.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("spAreaInfServiceImpl.findAreaInfoByParams.error");
		}
		return response;
	}

	/**
	 * 查询分区信息
	 * @param paramaMap
	 * @return
	 */
	@Override
	public Response<EspAreaInfModel> findByAreaId(Map<String, Object> paramaMap) {
		Response<EspAreaInfModel> response = new Response<>();
		try {
			List<EspAreaInfModel> areaList = espAreaInfDao.findByAreaId(paramaMap);
			if(areaList != null && areaList.size() > 0){
				response.setResult(areaList.get(0));
			}
		} catch (Exception e) {
			log.error("EspAreaInfServiceImpl.findAll.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("spAreaInfServiceImpl.findAll.error");
		}
		return response;
	}
}
