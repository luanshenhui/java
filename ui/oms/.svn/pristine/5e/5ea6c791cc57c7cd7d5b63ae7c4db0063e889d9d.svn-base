package cn.rkylin.oms.system.splitRule.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.splitRule.domain.SplitRuleItem;

@Repository(value = "iSplitRuleItemDAO")
public class SplitRuleItemDAOImpl implements ISplitRuleItemDAO {
	// 常量定义
	private static final String STMT_DELETE_SPLITRULEITEM = "deleteByPrimaryKeySplitRuleItem";
	private static final String STMT_UPDATE_SPLITRULEITEM = "updateByPrimaryKeySplitRuleItem";
	private static final String STMT_INSERT_SPLITRULEITEM = "insertSplitRuleItem";
	
	@Autowired
	protected IDataBaseFactory dao;
	
	/**
	 * 构造函数
	 */
	public SplitRuleItemDAOImpl(){

	}
	
	/**
	 * 查询分担规则详情
	 * 
	 * @param shopVO
	 */
	public List<SplitRuleItem> findByWhere(SplitRuleItem splitRuleItem){
		return null;
	}

	/**
	 * 创建分担规则详情
	 * 
	 * @param shop
	 */
	public int insert(SplitRuleItem splitRuleItem) throws Exception{
		return dao.insert(STMT_INSERT_SPLITRULEITEM, splitRuleItem);
	}

	/**
	 * 修改分担规则详情
	 * 
	 * @param shop
	 */
	public int update(SplitRuleItem splitRuleItem) throws Exception{
		return dao.update(STMT_UPDATE_SPLITRULEITEM, splitRuleItem);
	}

	/**
	 * 删除分担规则详情
	 * 
	 * @param shop
	 */
	public int delete(SplitRuleItem splitRuleItem) throws Exception{
		return dao.delete(STMT_DELETE_SPLITRULEITEM, splitRuleItem.getSplitRuleItemId());
	}
}
