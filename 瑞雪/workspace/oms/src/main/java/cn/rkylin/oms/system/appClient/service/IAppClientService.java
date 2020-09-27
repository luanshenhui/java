package cn.rkylin.oms.system.appClient.service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.appClient.domain.AppClient;
import cn.rkylin.oms.system.appClient.vo.AppClientVo;

public interface IAppClientService {
	/**
	 * 列表查询
	 * @param page 分页
	 * @param length 一页数
	 * @param param 传入对象参数
	 * @return
	 * @throws Exception
	 */
	PageInfo<AppClientVo> findByWhere(int page, int length, AppClientVo param) throws Exception;

	/**
	 * 保存和修改
	 * @param app
	 * @throws Exception
	 */
	void saveAppClient(AppClient app) throws Exception;

	/**
	 * 删除
	 * @param app
	 * @throws Exception
	 */
	void deleteAppClient(AppClient app) throws Exception;

	/**
	 * 详情
	 * @param app
	 * @return
	 * @throws Exception
	 */
	AppClientVo getAppClientDetail(AppClient app) throws Exception;

}
