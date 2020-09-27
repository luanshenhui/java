package cn.rkylin.oms.system.splitRule.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.oms.item.service.IItemService;
import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.system.shop.service.IShopService;
import cn.rkylin.oms.system.shop.vo.ShopVO;
import cn.rkylin.oms.system.splitRule.dao.SplitRuleDAOImpl;
import cn.rkylin.oms.system.splitRule.dao.SplitRuleItemDAOImpl;
import cn.rkylin.oms.system.splitRule.domain.SplitRule;
import cn.rkylin.oms.system.splitRule.service.ISplitRuleItemService;
import cn.rkylin.oms.system.splitRule.service.ISplitRuleService;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleItemVO;
import cn.rkylin.oms.system.splitRule.vo.SplitRuleVO;

/**
 * 分担规则控制器
 *
 * @author jinshen
 * @version 1.0
 * @created 23-2月-2017 09:11:15
 */
@Controller
@RequestMapping("/split")
public class SplitRuleController extends ApolloController {
	private static final Log logger = LogFactory.getLog(SplitRuleController.class);
	// 常量定义
    private static final String PAGE_SELECT_STATEMENT = "pageSelectSplitRule"; // 分页语句Statement名称
    private static final String PAGE_SELECT_STATEMENT_ITEM = "pageSelectSplitRuleItem"; // 分页语句Statement名称
    private static final String RESULT_SUCCESS_FLG = "success";  
	private static final String RESULT_ERROR_MESSAGE = "errormessage";
	private static final String RESULT_ROW_COUNT = "rowcount";
	private static final String RESULT_SPLIT_RULE_ID = "splitruleid";
	
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
     * 平台商品服务层
     */
    @Autowired
    private IItemService itemService;
    
    /**
     * 分单详情规则服务层
     */
    @Autowired
    private ISplitRuleItemService splitRuleItemService;
    
    @Override
    public void afterPropertiesSet() throws Exception {
        setExportService((IExport) splitRuleService);
    }
   
	/**
	 * 分担规则详情的表格数据
	 * @param quickSearch
	 * @param start
	 * @param length
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
    @RequestMapping(value = "/splitRuleItemList", method = RequestMethod.GET)
    public Map<String, Object> getSplitRuleItemList(String quickSearch, String shopId,
    									   @RequestParam(required = false, defaultValue = "") String splitRuleId,
                                           @RequestParam(required = false, defaultValue = "0") int start,
                                           @RequestParam(required = false, defaultValue = "10") int length)
            throws Exception {
        // 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            // 前台搜索条件，此处只有一个名称，暂时无分词
            quickSearch = URLDecoder.decode(quickSearch, "UTF-8");

            // 处理分页
            if (length == -1) {
                length = Integer.MAX_VALUE;
            }
            int page = start / length + 1;

            // 处理快速查询条件
            SplitRuleItemVO param = new SplitRuleItemVO();
            if (StringUtils.isNotEmpty(quickSearch)) {
                param.setSearchItemCondition(URLDecoder.decode(quickSearch, "UTF-8"));
            }
            if (StringUtils.isNotBlank(shopId)) {
                param.setShopId(URLDecoder.decode(shopId, "UTF-8"));
            }
            if (StringUtils.isNotBlank(splitRuleId)) {
                param.setSplitRuleId(URLDecoder.decode(splitRuleId, "UTF-8"));
            }
            //TODO 使用人的角色权限
            
            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("status", "enable");

            // 排序语句生成
            String orderStatement = getOrderString(SplitRuleItemDAOImpl.class.getName(), PAGE_SELECT_STATEMENT_ITEM,
                    replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            // 获取分页数据
            PageInfo<SplitRuleItemVO> splitRuleItemVOList = splitRuleItemService.findByWhere(page, length, param);

            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, splitRuleItemVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, splitRuleItemVOList.getTotal());
            returnMap.put(RETURN_DATA, splitRuleItemVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }
	
	/**
	 * 生成分担规则
	 * @param shopId
	 * @param shopName
	 * @param splitType
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
    @RequestMapping(value = "/createSplitRuleItem")
    public Map<String, Object> createSplitRuleItem(String splitruleid , String ecitemid , String splitShopId)
            throws Exception {
		// 用于返回值的json对象
        //check
  		Map<String , Object> resultMap = new HashMap<String , Object>();
  		
  		//分单Id空的场合
  		if (StringUtils.isBlank(splitruleid)){
  			resultMap.put(RESULT_SUCCESS_FLG,"N");
          	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的分单id是空");
          	resultMap.put(RESULT_ROW_COUNT,"0");
          	return resultMap;
  		}
  		
  		//分单规则id在数据库不存场合	
  		SplitRuleVO splitRuleVO = new SplitRuleVO();
  		splitRuleVO.setSplitRuleId(splitruleid);
  		PageInfo<SplitRuleVO> splitRuleVOList = splitRuleService.findByWhere(1, 1, splitRuleVO);
  		if (splitRuleVOList.getList()==null || splitRuleVOList.getList().size() <=0){
          	resultMap.put(RESULT_SUCCESS_FLG,"N");
          	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的分单规则已经不存在");
          	resultMap.put(RESULT_ROW_COUNT,"0");
          	return resultMap;
          }
  		
  		//分单店铺id空场合
  		if (StringUtils.isBlank(splitShopId)){
  			resultMap.put(RESULT_SUCCESS_FLG,"N");
          	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的店铺id是空");
          	resultMap.put(RESULT_ROW_COUNT,"0");
          	return resultMap;
  		}
  		
  		//分单店铺id在数据库不存场合		
  		ShopVO paramVO = new ShopVO();
	      paramVO.setShopId(splitShopId);
	      PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, paramVO);
	      if (shopList.getList()==null || shopList.getList().size() <=0){
	      	resultMap.put(RESULT_SUCCESS_FLG,"N");
	      	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的店铺已经不存在");
	      	resultMap.put(RESULT_ROW_COUNT,"0");
	      	return resultMap;
	      }
	      
		//商品id是空的场合
		if (StringUtils.isBlank(ecitemid)){
			resultMap.put(RESULT_SUCCESS_FLG,"N");
		  	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的商品id是空");
		  	resultMap.put(RESULT_ROW_COUNT,"0");
		  	return resultMap;
		}
      	
		String[] itemTemp = ecitemid.split(",");
		int count = 0;
		String splitRuleItemId = "";
		List<SplitRuleItemVO> list = new ArrayList<SplitRuleItemVO>();
		for (int i = 0 ; i < itemTemp.length ; i++){
			
			if (StringUtils.isBlank(itemTemp[i])){
				resultMap.put(RESULT_SUCCESS_FLG,"N");
	        	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的商品id是空");
	        	resultMap.put(RESULT_ROW_COUNT,"0");
	        	return resultMap;
			}
			
			
			//商品id在数据库不存场合
			ItemVO itemVO = new ItemVO();
			itemVO.setEcItemId(itemTemp[i]);
			PageInfo<ItemVO> itemVOList = itemService.findByWhere(1, 1, itemVO);
			if (itemVOList.getList()==null || itemVOList.getList().size() <=0){
	        	resultMap.put(RESULT_SUCCESS_FLG,"N");
	        	resultMap.put(RESULT_ERROR_MESSAGE,"所选择的的商品已经不存在");
	        	resultMap.put(RESULT_ROW_COUNT,"0");
	        	return resultMap;
	        }
			
			//同一个分担规则，同一个商品在分担规则详情页面只能有一条数据
			SplitRuleItemVO checkVO = new SplitRuleItemVO();
			checkVO.setEcItemId(itemTemp[i]);
			checkVO.setSplitRuleId(splitruleid);
			PageInfo<SplitRuleItemVO> checkVOList = splitRuleItemService.findByWhere(1, 1, checkVO);
			if (checkVOList.getList()==null || checkVOList.getList().size() >0){
				resultMap.put(RESULT_SUCCESS_FLG,"N");
				resultMap.put(RESULT_ERROR_MESSAGE,"当前分担规则下的商品已经存在！");
				resultMap.put(RESULT_ROW_COUNT,"0");
				return resultMap;
			}
		      
	  		SplitRuleItemVO splitRuleItemVO = new SplitRuleItemVO();
	  		splitRuleItemVO.setSplitRuleId(splitruleid);
	        splitRuleItemVO.setSplitShopId(splitShopId);
	        splitRuleItemVO.setCreateTime(new Date());
	        splitRuleItemVO.setUpdateTime(new Date());
	        splitRuleItemVO.setDeleted("n");
	    	splitRuleItemVO.setSplitShopName(shopList.getList().get(0).getShopName());
	    	splitRuleItemVO.setEcItemId(itemTemp[i]);
			splitRuleItemVO.setEcItemCode(itemVOList.getList().get(0).getEcItemCode());
			splitRuleItemVO.setSplitRuleItemId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
			
			list.add(splitRuleItemVO);
//	  		splitRuleItemService.insert(splitRuleItemVO);
			
			if (i==0){
				splitRuleItemId = splitRuleItemVO.getSplitRuleItemId();
			} else {
				splitRuleItemId = splitRuleItemId + "," + splitRuleItemVO.getSplitRuleItemId();
			}
		}
		
		if (list!=null && list.size()>0){
			splitRuleItemService.insert(list,splitruleid);
		}
		
		resultMap.put(RESULT_ROW_COUNT,count);
		resultMap.put(RESULT_SUCCESS_FLG,"Y");
		resultMap.put(RESULT_SPLIT_RULE_ID, splitRuleItemId);
		resultMap.put(RESULT_ERROR_MESSAGE,"");
        
        // 生成返回结果json串，null内容也需要返回
        return resultMap;
	}
	
	
	/**
	 * 生成分担规则
	 * @param shopId
	 * @param shopName
	 * @param splitType
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
    @RequestMapping(value = "/createSplitRulet")
    public Map<String, Object> createSplitRulet(String shopId , String shopName , String splitType)
            throws Exception {
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        SplitRuleVO splitRuleVO = new SplitRuleVO();
        
        //接受参数
        splitRuleVO.setSplitRuleId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
        splitRuleVO.setShopId(URLDecoder.decode(shopId, "UTF-8"));
        splitRuleVO.setShopName(URLDecoder.decode(shopName, "UTF-8"));
        splitRuleVO.setSplitType(URLDecoder.decode(splitType, "UTF-8"));
        splitRuleVO.setCreateTime(new Date());
        splitRuleVO.setUpdateTime(new Date());
        splitRuleVO.setEnable("n");
        splitRuleVO.setDeleted("n");
        //check
		
		if (StringUtils.isBlank(splitRuleVO.getShopId())){
			returnMap.put(RESULT_SUCCESS_FLG,"N");
			returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的店铺已经不存在");
			returnMap.put(RESULT_ROW_COUNT,"0");
        	return returnMap;
		}
		
		ShopVO paramVO = new ShopVO();
        paramVO.setShopId(splitRuleVO.getShopId());
        PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, paramVO);
        if (shopList.getList()==null || shopList.getList().size() <=0){
        	returnMap.put(RESULT_SUCCESS_FLG,"N");
        	returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的店铺已经不存在");
        	returnMap.put(RESULT_ROW_COUNT,"0");
        	return returnMap;
        }
        
        String shopNm = shopList.getList().get(0).getShopName();
        String shopType = shopList.getList().get(0).getShopType();
        if (!shopNm.equals(splitRuleVO.getShopName())){
        	returnMap.put(RESULT_SUCCESS_FLG,"N");
        	returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的店铺的名字有问题");
        	returnMap.put(RESULT_ROW_COUNT,"0");
        	return returnMap;
        }
        splitRuleVO.setShopType(shopType);
		//唯一check
		SplitRuleVO splitParamVO = new SplitRuleVO();
		splitParamVO.setShopId(splitRuleVO.getShopId());
		PageInfo<SplitRuleVO> SplitRuleVOList = splitRuleService.findByWhere(1, 1, splitParamVO);
		if (SplitRuleVOList.getList()!=null && SplitRuleVOList.getList().size() > 0){
			returnMap.put(RESULT_SUCCESS_FLG,"N");
			returnMap.put(RESULT_ERROR_MESSAGE,"要创建的店铺分单规则已经存在");
			returnMap.put(RESULT_ROW_COUNT,"0");
			return returnMap;
		}
		
        //分担规则生成
		SplitRule splitRule =  splitRuleService.insert(splitRuleVO);
		returnMap.put(RESULT_ROW_COUNT,1);
		returnMap.put(RESULT_SUCCESS_FLG,"Y");
		returnMap.put(RESULT_SPLIT_RULE_ID, splitRule.getSplitRuleId());
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
	}
	
	@ResponseBody
    @RequestMapping(value = "/enableSplitRule")
    public Map<String, Object> enableSplitRule(String splitruleid,String flg,String updateTime)
            throws Exception {
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        
        //分单Id空的场合
		if (StringUtils.isBlank(splitruleid)){
			returnMap.put(RESULT_SUCCESS_FLG,"N");
			returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的分单id是空");
			returnMap.put(RESULT_ROW_COUNT,"0");
	    	return returnMap;
		}
		
		//分单规则id在数据库不存场合	
		SplitRuleVO splitRuleVO = new SplitRuleVO();
		splitRuleVO.setSplitRuleId(splitruleid);
		PageInfo<SplitRuleVO> splitRuleVOList = splitRuleService.findByWhere(1, 1, splitRuleVO);
		if (splitRuleVOList.getList()==null || splitRuleVOList.getList().size() <=0){
			returnMap.put(RESULT_SUCCESS_FLG,"N");
			returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的分单规则已经不存在");
			returnMap.put(RESULT_ROW_COUNT,"0");
	    	return returnMap;
	    }
		
		if (!updateTime.equals(splitRuleVOList.getList().get(0).getUpdateTime().toString())){
			returnMap.put(RESULT_SUCCESS_FLG,"N");
			returnMap.put(RESULT_ERROR_MESSAGE,"所选择的的分单规则信息已经不是最新");
			returnMap.put(RESULT_ROW_COUNT,"0");
	    	return returnMap;
		}
		
        //分担规则生成
        if ("n".equals(flg)){
    		
    		SplitRule splitRule = new SplitRule();
    		BeanUtils.copyProperties(splitRuleVOList.getList().get(0), splitRule);
    		splitRule.setEnable("y");
    		splitRule.setUpdateTime(new Date());
    		
    		splitRule = splitRuleService.setEnable(splitRule);
    		returnMap.put(RESULT_ROW_COUNT,1);
    		returnMap.put(RESULT_SUCCESS_FLG,"Y");
    		returnMap.put(RESULT_SPLIT_RULE_ID, splitruleid);
        } else {
        	
        	SplitRule splitRule = new SplitRule();
    		BeanUtils.copyProperties(splitRuleVOList.getList().get(0), splitRule);
    		splitRule.setEnable("n");
    		splitRule.setUpdateTime(new Date());
    		
    		splitRule = splitRuleService.setEnable(splitRule);
    		returnMap.put(RESULT_ROW_COUNT,1);
    		returnMap.put(RESULT_SUCCESS_FLG,"Y");
    		returnMap.put(RESULT_SPLIT_RULE_ID, splitruleid);
        }
        
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
	}
	
	/**
	 * 分担规则的表格数据
	 * @param quickSearch
	 * @param start
	 * @param length
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
    @RequestMapping(value = "/splitRuleList", method = RequestMethod.GET)
    public Map<String, Object> getSplitRuleList(String quickSearch,
                                           @RequestParam(required = false, defaultValue = "0") int start,
                                           @RequestParam(required = false, defaultValue = "10") int length)
            throws Exception {
        // 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            // 前台搜索条件，此处只有一个名称，暂时无分词
            quickSearch = URLDecoder.decode(quickSearch, "UTF-8");

            // 处理分页
            if (length == -1) {
                length = Integer.MAX_VALUE;
            }
            int page = start / length + 1;

            // 处理快速查询条件
            SplitRuleVO param = new SplitRuleVO();
            if (StringUtils.isNotEmpty(quickSearch)) {
                param.setSearchCondition(quickSearch);
            }

            //TODO 使用人的角色权限
            
            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("status", "enable");

            // 排序语句生成
            String orderStatement = getOrderString(SplitRuleDAOImpl.class.getName(), PAGE_SELECT_STATEMENT,
                    replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            // 获取分页数据
            PageInfo<SplitRuleVO> splitRuleVOList = splitRuleService.findByWhere(page, length, param);

            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, splitRuleVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, splitRuleVOList.getTotal());
            returnMap.put(RETURN_DATA, splitRuleVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }
}
