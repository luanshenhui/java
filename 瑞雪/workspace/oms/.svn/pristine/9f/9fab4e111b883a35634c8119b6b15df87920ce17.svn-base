package cn.rkylin.oms.system.splitRule.service;

import java.util.Map;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.splitRule.domain.SplitRule;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleVO;

public interface ISplitRuleService {
	/**
	 * 查询分担规则
	 * 
	 * @param shopVO
	 * @throws Exception 
	 */
	public PageInfo<SplitRuleVO> findByWhere(int page, int rows, SplitRuleVO splitRuleVO) throws Exception;

	/**
	 * 创建分担规则
	 * 
	 * @param shopVO
	 */
	public SplitRule insert(SplitRuleVO splitRuleVO) throws Exception;

	/**
	 * 修改分担规则
	 * 
	 * @param shopVO
	 */
	public Map<String , Object>  update(SplitRuleVO splitRuleVO) throws Exception;

	/**
	 * 删除分担规则
	 * 
	 * @param shopVO
	 */
	public Map<String , Object>  delete(SplitRuleVO splitRuleVO) throws Exception;

	/**
	 * 删除分担规则
	 * 
	 * @param shopVO
	 */
	public Map<String , Object>  validate(SplitRuleVO splitRuleVO) throws Exception;

	/**
	 * 启用分担规则
	 * 
	 * @param shopId
	 */
	public SplitRule setEnable(SplitRule splitRule) throws Exception;

	/**
	 * 禁用分担规则
	 * 
	 * @param shopId
	 */
	public SplitRule setDisable(SplitRule splitRule) throws Exception;
}
