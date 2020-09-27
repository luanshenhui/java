package cn.rkylin.oms.system.splitRule.service;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.splitRule.domain.SplitRuleItem;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleItemVO;

public interface ISplitRuleItemService {
	
	/**
	 * 查询分担详情规则
	 * 
	 * @param shopVO
	 * @throws Exception 
	 */
	public PageInfo<SplitRuleItemVO> findByWhere(int page, int rows, SplitRuleItemVO splitRuleItemVO) throws Exception;
	
	/**
	 * 查询分担详情规则
	 * 
	 * @param shopVO
	 * @throws Exception 
	 */
	public PageInfo<SplitRuleItemVO> getSplitRultItemList(int page, int rows, SplitRuleItemVO splitRuleItemVO) throws Exception;

	/**
	 * 创建分担规则
	 * 
	 * @param shopVO
	 */
	public List<SplitRuleItem> insert(List<SplitRuleItemVO> list, String splitruleid) throws Exception;

	/**
	 * 修改分担分担详情规则
	 * 
	 * @param shopVO
	 */
	public Map<String , Object>  update(SplitRuleItemVO splitRuleItemVO) throws Exception;
}
