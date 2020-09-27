/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.metadata.dao.DcaTopicPhysicsDao;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysics;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysicsFields;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;

/**
 * DcaTopicPhysicsService
 * 
 * @author hn
 * @version 2016-11-08
 */
@Service
@Transactional(readOnly = true)
public class DcaTopicPhysicsService extends CrudService<DcaTopicPhysicsDao, DcaTopicPhysics> {

	public DcaTopicPhysics get(String tableName) {

		return super.get(tableName);
	}

	public List<DcaTopicPhysics> findList(DcaTopicPhysics dcaTopicPhysics) {

		return super.findList(dcaTopicPhysics);
	}

	public Page<DcaTopicPhysics> findPage(Page<DcaTopicPhysics> page, DcaTopicPhysics dcaTopicPhysics) {

		return super.findPage(page, dcaTopicPhysics);
	}

	@Transactional(readOnly = false)
	public boolean save(List<DcaTopicPhysics> list) {

		boolean result = true;

		// DB类型，暂定oracle
		String dbType = "ORACLE";
		String tableName = "";
		String tableComment = "";
		List<DcaTopicPhysics> columnList = new ArrayList<DcaTopicPhysics>();

		// 判断数据库类型
		if ("ORACLE".equals(dbType)) {

			// 更新对象属性取得
			if (CollectionUtils.isNotEmpty(list)) {

				tableName = list.get(0).getTableName();
				tableComment = list.get(0).getTableComment();
			} else {

				return false;
			}

			// 判断更新对象属性不能为空（物理表英文名、物理表字段list、物理表中文名）
			if (StringUtils.isEmpty(tableName) || CollectionUtils.isEmpty(columnList)
					|| StringUtils.isEmpty(tableComment)) {

				return false;
			}

			// 判断物理表是否存在
			DcaTopicPhysics dcaTopicPhysics = new DcaTopicPhysics();
			dcaTopicPhysics.setTableName(tableName);
			List<DcaTopicPhysics> detailList = dao.getDetail(dcaTopicPhysics);

			// 物理表如果存在，首先数据须清空，然后修改结构
			if (CollectionUtils.isNotEmpty(detailList)) {

				// 编辑物理表
				editTableForOracle(tableName, tableComment, columnList);

			} else {

				// 新建物理表
				createTableForOracle(tableName, tableComment, columnList);
			}

		} else {

			// 其他db类型的操作，暂时无

		}

		return result;
	}

	/**
	 * 物理表字段详情 通过Dao的getDetail方法获取字段内容并返回页面
	 * 
	 * @param page
	 * @return
	 */
	public Page<DcaTopicPhysics> getDetail(Page<DcaTopicPhysics> page, DcaTopicPhysics dcaTopicPhysics) {

		dcaTopicPhysics.setPage(page);
		List<DcaTopicPhysics> detailList = dao.getDetail(dcaTopicPhysics);
		page.setList(detailList);

		return page;
	}

	/**
	 * 物理表编辑获取当前表字段信息
	 * 
	 * @param page
	 * @return
	 */
	public List<DcaTopicPhysicsFields> getTableData(DcaTopicPhysics dcaTopicPhysics) {

		List<DcaTopicPhysicsFields> detailList = dao.getCloumn(dcaTopicPhysics);

		return detailList;
	}

	/**
	 * oracle数据库的新建表处理
	 * 
	 * @param tableName
	 * @param tableComment
	 * @param columnList
	 * @return
	 */
	private void createTableForOracle(String tableName, String tableComment, List<DcaTopicPhysics> columnList) {

		// TODO liunan代码

	}

	/**
	 * oracle数据库的编辑表处理
	 * 
	 * @param tableName
	 * @param tableComment
	 * @param columnList
	 * @return
	 */
	private void editTableForOracle(String tableName, String tableComment, List<DcaTopicPhysics> columnList) {

		// TODO liunan代码
		// 数据清空
		// 表编辑

	}

	public List<DcaTopicPhysics> getTypeCheck(String dbType) {

		List<DcaTopicPhysics> list = dao.getTypeForOracle(dbType);

		return list;
	}

	/**
	 * 基础数据管理，分页查询
	 * @param page
	 * @param dcaTopicPhysics
	 * @return
	 */
	public Page<DcaTopicPhysics> findBasicDataByPage(Page<DcaTopicPhysics> page, DcaTopicPhysics dcaTopicPhysics) {
		dcaTopicPhysics.setPage(page);
		page.setList(dao.findBasicDataByPage(dcaTopicPhysics));
		return page;
	}


	/**
	 * 查询物理表所有列
	 * @param tableName
	 * @return
	 */
	public List<String> findBasicDataColumns(String tableName){
		return dao.findBasicDataColumns(tableName);
	}

	/**
	 * 分页查询物理表数据
	 * @return
	 */
	public Page<Object> findBasicDataDetailByPage(Page<Object> page, Map<String,Object> paramMap){
		Long count = dao.findBasicDataCount(paramMap);
		page.setCount(count);
		page.setList(dao.findBasicDataDetailByPage(paramMap));
		return page;
	}

	/**
	 * 查询物理表信息
	 * @param tableName
	 * @return
	 */
	public DcaTopicPhysics findDcaTopicPhysics(String tableName){
		return dao.findDcaTopicPhysics(tableName);
	}
}