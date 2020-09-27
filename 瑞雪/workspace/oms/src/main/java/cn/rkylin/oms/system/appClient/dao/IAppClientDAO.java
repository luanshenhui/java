package cn.rkylin.oms.system.appClient.dao;

import cn.rkylin.oms.system.appClient.domain.AppClient;
import cn.rkylin.oms.system.appClient.vo.AppClientVo;

public interface IAppClientDAO {

	void saveAppClient(AppClient app) throws Exception;

	void deleteAppClient(AppClient app) throws Exception;

	AppClientVo getAppClientDetail(AppClient app) throws Exception;

	void updateAppClient(AppClient app) throws Exception;

}
