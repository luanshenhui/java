package cn.rkylin.oms.system.enterprise.dao;

import java.util.List;

import cn.rkylin.oms.system.enterprise.domain.Enterprise;
import cn.rkylin.oms.system.enterprise.vo.EnterpriseVO;

public interface IEnterpriseDAO {

	List getEnterpriseName(Enterprise param) throws Exception;

	List getOneEnterpriseList(EnterpriseVO param) throws Exception;;

}
