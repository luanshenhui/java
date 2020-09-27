package cn.rkylin.oms.system.appClient.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.appClient.domain.AppClient;
import cn.rkylin.oms.system.appClient.vo.AppClientVo;

@Repository(value = "appDAO")
public class AppClientDAOImpl implements IAppClientDAO {
	@Autowired
	protected IDataBaseFactory dao;

	/**
	 * 保存
	 * 
	 * @param app
	 * @throws Exception
	 */
	@Override
	public void saveAppClient(AppClient app) throws Exception {
		dao.insert("saveAppClient_insert", app);

	}

	/**
	 * 删除
	 * 
	 * @param app
	 * @throws Exception
	 */
	@Override
	public void deleteAppClient(AppClient app) throws Exception {
		dao.update("saveAppClient_delete", app);
	}

	/**
	 * 获取详情
	 * 
	 * @param app
	 * @return AppClientVo
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public AppClientVo getAppClientDetail(AppClient app) throws Exception {
		List list = dao.findAllList("getAppClientDetail", app);
		return (AppClientVo) (list.size() > 0 ? list.get(0) : null);
	}

	/**
	 * 修改
	 * 
	 * @param app
	 * @throws Exception
	 */
	@Override
	public void updateAppClient(AppClient app) throws Exception {
		dao.update("saveAppClient_update", app);
	}

}
