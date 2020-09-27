/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContent;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 工作流节点内容DAO接口
 * 
 * @author ThinkGem
 * @version 2016-11-17
 */
@MyBatisDao
public interface DcaWorkflowTaskContentDao extends CrudDao<DcaWorkflowTaskContent> {

	/**
	 * 保存节点内容
	 * 
	 * @param contentList
	 * @return
	 */
	public int insertContent(List<DcaWorkflowTaskContent> contentList);

	/**
	 * 更新节点内容
	 * 
	 * @param contentList
	 * @return
	 */
	public int updateContent(List<DcaWorkflowTaskContent> contentList);

}