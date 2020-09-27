package cn.rkylin.oms.system.splitRule.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.item.service.IItemService;
import cn.rkylin.oms.system.shop.service.IShopService;
import cn.rkylin.oms.system.splitRule.dao.ISplitRuleItemDAO;
import cn.rkylin.oms.system.splitRule.domain.SplitRuleItem;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleItemVO;

@Service("splitRuleItemService")
public class SplitRuleItemServiceImpl extends ApolloService implements ISplitRuleItemService {
	@Resource(name = "redisTemplate")
	private RedisTemplate<Serializable, Serializable> redisTemplate;
	/**
     * 平台商品服务层
     */
    @Autowired
    private IItemService itemService;
    
	/**
     * 分单规则服务层
     */
    @Autowired
    private ISplitRuleService splitRuleService;
    
	/**
     * 店铺服务层
     */
    @Autowired
    private IShopService shopService;
    
	/**
	 * 分单规则数据访问
	 */
	@Autowired
	private ISplitRuleItemDAO splitRuleItemDAO;

	/**
	 * 构造函数
	 */
	public SplitRuleItemServiceImpl(){

	}
	
	/**
	 * 查询分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public PageInfo<SplitRuleItemVO> findByWhere(int page, int rows, SplitRuleItemVO splitRuleItemVO) throws Exception {
		PageInfo<SplitRuleItemVO> SplitRuleItemVOList = findPage(page, rows, "pageSelectSplitRuleItem", splitRuleItemVO);
		return SplitRuleItemVOList;
	}

	/**
	 * 查询分单规则
	 * 
	 * @param SplitRuleVO
	 */
	public PageInfo<SplitRuleItemVO> getSplitRultItemList(int page, int rows, SplitRuleItemVO splitRuleItemVO) throws Exception {
		PageInfo<SplitRuleItemVO> SplitRuleItemVOList = findPage(page, rows, "pageSelectSplitRuleItemList", splitRuleItemVO);
		return SplitRuleItemVOList;
	}
	/**
	 * 新规分单规则详情
	 */
	@Override
	@Transactional
	@CachePut(value="splitRuleItem", key="T(String).valueOf('splitRule:').concat(#splitruleid)")
	public List<SplitRuleItem> insert(List<SplitRuleItemVO> list, String splitruleid) throws Exception {
		List<SplitRuleItem> listSplitRuleItem = new ArrayList<SplitRuleItem>();
		for (int i = 0 ; i < list.size() ; i++){
			SplitRuleItem splitRuleItem = new SplitRuleItem();
			BeanUtils.copyProperties(list.get(i), splitRuleItem);
			splitRuleItemDAO.insert(splitRuleItem);
			listSplitRuleItem.add(splitRuleItem);
		}
		List<SplitRuleItem> listSplitItem = (List<SplitRuleItem>) redisTemplate.opsForValue().get("splitRule:"+splitruleid);
		if (listSplitItem!=null && listSplitItem.size()>0){
			listSplitRuleItem.addAll(listSplitItem);
		}
		return listSplitRuleItem;
	}

	@Override
	public Map<String, Object> update(SplitRuleItemVO splitRuleItemVO) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}
