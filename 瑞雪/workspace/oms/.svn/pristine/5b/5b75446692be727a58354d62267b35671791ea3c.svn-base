package cn.rkylin.oms.system.splitRule.service;

import java.util.Map;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.shop.service.IShopService;
import cn.rkylin.oms.system.splitRule.dao.ISplitRuleDAO;
import cn.rkylin.oms.system.splitRule.domain.SplitRule;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleVO;

@Service("splitRuleService")
public class SplitRuleServiceImpl extends ApolloService implements ISplitRuleService {
	
	private Map<String , Object> result;
	/**
     * 店铺服务层
     */
    @Autowired
    private IShopService shopService;
    
	/**
	 * 分单规则数据访问
	 */
	@Autowired
	private ISplitRuleDAO splitRuleDAO;

	/**
	 * 构造函数
	 */
	public SplitRuleServiceImpl(){

	}
	
	public ISplitRuleDAO getSplitRuleDAO() {
		return splitRuleDAO;
	}

	public void setSplitRuleDAO(ISplitRuleDAO splitRuleDAO) {
		this.splitRuleDAO = splitRuleDAO;
	}
	
	
	public Map<String, Object> getResult() {
		return result;
	}

	public void setResult(Map<String, Object> result) {
		this.result = result;
	}

	/**
	 * 查询分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public PageInfo<SplitRuleVO> findByWhere(int page, int rows, SplitRuleVO splitRuleVO) throws Exception {
		PageInfo<SplitRuleVO> SplitRuleVOList = findPage(page, rows, "pageSelectSplitRule", splitRuleVO);
		return SplitRuleVOList;
	}

	/**
	 * 创建分单规则
	 * 
	 * @param SplitRuleVO
	 */
	@Transactional
	@CachePut(value="splitRule", key="T(String).valueOf('splitRuleShop:').concat(#splitRuleVO.shopId)")
	public SplitRule insert(SplitRuleVO splitRuleVO) throws Exception{
		SplitRule splitRule = new SplitRule();
		BeanUtils.copyProperties(splitRuleVO, splitRule);
		return splitRule;
	}

	/**
	 * 修改分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public Map<String , Object>  update(SplitRuleVO splitRuleVO) throws Exception{
//		SplitRule splitRule = new SplitRule();
//		BeanUtils.copyProperties(splitRuleVO, splitRule);
//		return splitRuleDAO.update(splitRule);
		return null;
	}

	/**
	 * 删除分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public Map<String , Object>  delete(SplitRuleVO splitRuleVO) throws Exception{
//		SplitRule splitRule = new SplitRule();
//		BeanUtils.copyProperties(splitRuleVO, splitRule);
//		return splitRuleDAO.delete(splitRule);
		return null;
	}

	/**
	 * 删除分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public Map<String , Object>  validate(SplitRuleVO splitRuleVO) throws Exception{
//		return 0;
		return null;
	}

	/**
	 * 启用分单规则
	 * 
	 * @param shopId
	 */
	@Transactional
	@CachePut(value="splitRule", key="T(String).valueOf('splitRuleShop:').concat(#splitRule.shopId)")
	public SplitRule setEnable(SplitRule splitRule) throws Exception{
		splitRuleDAO.update(splitRule);
		return splitRule;
	}

	/**
	 * 禁用分单规则
	 * 
	 * @param shopId
	 */
	@Transactional
	@CachePut(value="splitRule", key="T(String).valueOf('splitRuleShop:').concat(#splitRule.shopId)")
	public SplitRule setDisable(SplitRule splitRule) throws Exception{
		splitRuleDAO.update(splitRule);
		return splitRule;
	}
	
}
