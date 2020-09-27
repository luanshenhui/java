package cn.rkylin.oms.system.log.service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.log.domain.LogDomain;
import cn.rkylin.oms.system.log.vo.LogDomainVo;

public interface ILogService {

	PageInfo<LogDomainVo> findByWhere(int page, int length, LogDomainVo param) throws Exception;

	/**
	 * 批量删除
	 * @param arr 字符串数字
	 */
	void deleteLog(String[] arr);

	/**
	 * 获取日志详情
	 * @param log 日志对象
	 * @return 日志对象
	 */
	LogDomain getLogDetail(LogDomain log);




}
