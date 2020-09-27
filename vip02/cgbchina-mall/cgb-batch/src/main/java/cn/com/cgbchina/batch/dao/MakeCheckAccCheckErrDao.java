package cn.com.cgbchina.batch.dao;

import org.springframework.stereotype.Repository;

@Repository
public class MakeCheckAccCheckErrDao extends BaseDao {
	/**
	 * 获取是否手动处理对账文件异常标示 0:手动 1:自动
	 *
	 * @return
	 */
	public String getIsShouDong() {
		return getSqlSession().selectOne("MakeCheckAccCheckErr.findByIsShouDong");
	}

	public Long getMakeAccErrSum(String prevDate) {
		return getSqlSession().selectOne("MakeCheckAccCheckErr.findByMakeAccErrSum", prevDate);
	}
	public Long getUncheckNum(String prevDate) {
		return  getSqlSession().selectOne("MakeCheckAccCheckErr.findByUncheckNum", prevDate);
	}
	public Integer getCheckUncheckNum(String prevDate) {
		return getSqlSession().selectOne("MakeCheckAccCheckErr.findByCheckUncheckNum",prevDate);
	}
}