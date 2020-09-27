/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.dao;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManageLog;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 风险管理履历DAO接口
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@MyBatisDao
public interface DcaRiskManageLogDao extends CrudDao<DcaRiskManageLog> {

}