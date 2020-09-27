package cn.rkylin.oms.system.enterprise.service;

import java.util.List;

import cn.rkylin.oms.system.enterprise.domain.Enterprise;
import cn.rkylin.oms.system.enterprise.vo.EnterpriseVO;

public interface IEnterpriseService {

	List getEnterpriseName(Enterprise param);

	List getOneEnterpriseList(EnterpriseVO param) throws Exception;


}
