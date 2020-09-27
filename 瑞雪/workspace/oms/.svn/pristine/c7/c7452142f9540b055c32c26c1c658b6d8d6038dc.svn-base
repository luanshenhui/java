package cn.rkylin.oms.system.enterprise.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.enterprise.domain.Enterprise;
import cn.rkylin.oms.system.enterprise.vo.EnterpriseVO;

@Repository(value = "enterpriseDAO")
public class EnterpriseDAOImpl implements IEnterpriseDAO{
	@Autowired
	protected IDataBaseFactory dao;

	@Override
	public List getEnterpriseName(Enterprise param) throws Exception {
		return dao.findAllList("getEnterpriseName", param);
	}

	@Override
	public List getOneEnterpriseList(EnterpriseVO param) throws Exception {
		return dao.findAllList("getOneEnterpriseList", param);
	}

}
