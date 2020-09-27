package cn.rkylin.oms.system.splitRule.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.splitRule.domain.SplitRule;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleVO;

@Repository(value = "splitRuleDAO")
public class SplitRuleDAOImpl implements ISplitRuleDAO{
	// 常量定义
		private static final String STMT_DELETE_SPLITRULE = "deleteByPrimaryKeySplitRule";
		private static final String STMT_UPDATE_SPLITRULE = "updateByPrimaryKeySplitRule";
		private static final String STMT_INSERT_SPLITRULE = "insertSplitRule";
		
		@Autowired
		protected IDataBaseFactory dao;
		
		/**
		 * 构造函数
		 */
		public SplitRuleDAOImpl(){

		}
		
		/**
		 * 查询分担规则
		 * 
		 * @param shopVO
		 */
		public List<SplitRuleVO> findByWhere(SplitRuleVO splitRuleVO){
			return null;
		}

		/**
		 * 创建分担规则
		 * 
		 * @param shop
		 */
		public int insert(SplitRule splitRule) throws Exception{
			return dao.insert(STMT_INSERT_SPLITRULE, splitRule);
		}

		/**
		 * 修改分担规则
		 * 
		 * @param shop
		 */
		public int update(SplitRule splitRule) throws Exception{
			return dao.update(STMT_UPDATE_SPLITRULE, splitRule);
		}

		/**
		 * 删除分担规则
		 * 
		 * @param shop
		 */
		public int delete(SplitRule splitRule) throws Exception{
			return dao.delete(STMT_DELETE_SPLITRULE, splitRule.getSplitRuleId());
		}
}
