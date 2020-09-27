package cn.rkylin.oms.system.log.service;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.log.domain.LogDomain;
import cn.rkylin.oms.system.log.vo.LogDomainVo;
/**
 * 日志管理 业务层
 * @author LuanShenHui
 *
 */
@Service("logService")
public class LogServiceImpl extends ApolloService implements ILogService {
	
	/**
	 * 日志列表
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
	public PageInfo<LogDomainVo> findByWhere(int page, int length, LogDomainVo param) throws Exception {
		// TODO Auto-generated method stub
		PageInfo<LogDomainVo> list = findPage(page, length, "testListPage", param);
		return list;
	}

	/**
	 * 批量删除
	 * @param arr 字符串数字
	 */
	@Override
	public void deleteLog(String[] arr) {
		// TODO Auto-generated method stub
		
	}

	/**
	 * 获取日志详情
	 * @param log 日志对象
	 * @return 日志对象
	 */
	@Override
	public LogDomain getLogDetail(LogDomain log) {
		// TODO Auto-generated method stub
		log.setDetail("多");
		log.setLogType("第三方");
		log.setOperation("是");
		log.setOperTime("2017-2-02-02");
		log.setSourceType("1");
		log.setTag("撒旦");
		log.setUser("lsh");
		return log;
	}


}
