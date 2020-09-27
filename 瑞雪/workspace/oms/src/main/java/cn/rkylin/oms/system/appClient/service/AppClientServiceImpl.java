package cn.rkylin.oms.system.appClient.service;

import java.util.UUID;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.appClient.dao.IAppClientDAO;
import cn.rkylin.oms.system.appClient.domain.AppClient;
import cn.rkylin.oms.system.appClient.vo.AppClientVo;

@Service("appService")
public class AppClientServiceImpl extends ApolloService implements IAppClientService {
	@Autowired
	private IAppClientDAO appDAO;

	/**
	 * 列表查询
	 * 
	 * @param page
	 *            分页
	 * @param length
	 *            一页数
	 * @param param
	 *            传入对象参数
	 * @return
	 * @throws Exception
	 */
	@Override
	public PageInfo<AppClientVo> findByWhere(int page, int rows, AppClientVo AppVo) throws Exception {
		PageInfo<AppClientVo> list = findPage(page, rows, "selectAppClientListPage", AppVo);
		return list;
	}

	/**
	 * 保存和修改
	 * 
	 * @param app
	 * @throws Exception
	 */
	@Override
	public void saveAppClient(AppClient app) throws Exception {
		try {
			if (null != app && StringUtils.isNotEmpty(app.getAppId())) {
				appDAO.updateAppClient(app);
			} else if (null != app && StringUtils.isEmpty(app.getAppId())) {
				app.setAppId(UUID.randomUUID().toString().replaceAll("-", ""));
				appDAO.saveAppClient(app);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception();
		}

	}

	/**
	 * 删除
	 * 
	 * @param app
	 * @throws Exception
	 */
	@Override
	public void deleteAppClient(AppClient app) throws Exception {
		try {
			appDAO.deleteAppClient(app);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception();
		}

	}

	/**
	 * 详情
	 * 
	 * @param app
	 * @return
	 * @throws Exception
	 */
	@Override
	public AppClientVo getAppClientDetail(AppClient app) throws Exception {
		try {
			AppClientVo v = appDAO.getAppClientDetail(app);
			return v;
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception();
		}
	}

}
