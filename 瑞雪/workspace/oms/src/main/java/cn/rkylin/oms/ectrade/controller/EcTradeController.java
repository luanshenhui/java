package cn.rkylin.oms.ectrade.controller;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.oms.ectrade.dao.EcTradeDAOImpl;
import cn.rkylin.oms.ectrade.service.IEcOrderService;
import cn.rkylin.oms.ectrade.service.IEcTradeService;
import cn.rkylin.oms.ectrade.vo.EcOrderVO;
import cn.rkylin.oms.ectrade.vo.EcTradeVO;
import cn.rkylin.oms.ectrade.vo.SearchConditionVO;

/**
 * Created by ZH on 2017-2-7.
 */
@Controller
@RequestMapping("/ecTradeManager")
public class EcTradeController extends ApolloController {
	private static final Log logger = LogFactory.getLog(EcTradeController.class);
	// 常量定义
	private static final String PAGE_SELECT_STATEMENT = "pageSelectEcTrade"; // 分页语句Statement名称
	@Autowired
	public ApolloService commonService;

	@Autowired
	public IEcTradeService ecTradeService;
	
	@Autowired
	public IEcOrderService ecOrderService;

	 @Override
    public void afterPropertiesSet() throws Exception {
        setExportService((IExport) ecTradeService);
    }
	 
	 /**
     * 构造函数
     */
    public EcTradeController() {

    }
    
	/**
	 * 未付款列表
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeNoPayList")
	public Map<String, Object> ecTradeNoPayList(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	//状态 
    	param.setEcTradeStatus("EB_WAIT_BUYER_PAY");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	
	/**
	 * 待处理
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeNoDealList")
	public Map<String, Object> ecTradeNoDealList(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	param.setSplitStatus("n");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	/**
	 * 等待发货
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeWaiteSend")
	public Map<String, Object> ecTradeWaiteSend(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	//状态 
    	param.setEcTradeStatus("EB_WAIT_SELLER_SEND");
    	param.setSplitStatus("y");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	/**
	 * 全部发货
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeSend")
	public Map<String, Object> ecTradeSend(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	//状态 
    	param.setEcTradeStatus("EB_TRADE_ALL_SEND");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	/**
	 * 已经完成
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeOver")
	public Map<String, Object> ecTradeOver(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	//状态 
    	param.setEcTradeStatus("EB_TRADE_FINISHED");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	/**
	 * 已经废弃
	 * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @Param start        第几页
     * @Param length       每页多少行
	 * @return 返回值JSON格式字符串
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeCanceled")
	public Map<String, Object> ecTradeCanceled(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		//查询条件
    	EcTradeVO param = new EcTradeVO();
    	//状态 
    	param.setEcTradeStatus("EB_TRADE_CANCELED");
		return getEcTradeList(quickSearch,start,length,formJson,param);
	}
	
	/**
	 * 根据不同的需求返回列表数据
	 * @param quickSearch
	 * @param start
	 * @param length
	 * @param formJson
	 * @param type
	 * @return
	 */
	private Map<String, Object> getEcTradeList(String quickSearch, int start, int length, String formJson , EcTradeVO param){
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	
			// 处理分页
			if (length == -1) {
				length = Integer.MAX_VALUE;
			}
			int page = start / length + 1;
			
			//快速查询
			quickSearch = URLDecoder.decode(quickSearch, "UTF-8");
			if (StringUtils.isNotBlank(quickSearch)) {
				param.setSearchCondition(quickSearch);
			}
			
			// 高级查询检索条件
            formJson = URLDecoder.decode(formJson, "UTF-8");
            //json转换成为ＶＯ
            SearchConditionVO searchConditionVO = JSONObject.parseObject(formJson, SearchConditionVO.class);
            if (searchConditionVO!=null){
            	//项目   
            	if (StringUtils.isNotBlank(searchConditionVO.getPrjId())){
            		param.setPrjId(searchConditionVO.getPrjId());
            	}
            	//店铺 
            	if (StringUtils.isNotBlank(searchConditionVO.getShopId())){
            		param.setShopId(searchConditionVO.getShopId());
            	}
            	//平台     
            	if (StringUtils.isNotBlank(searchConditionVO.getShopType())){
            		param.setShopType(searchConditionVO.getShopType());
            	}
            	//平台交易码  
            	if (StringUtils.isNotBlank(searchConditionVO.getEcTradeCode())){
            		param.setEcTradeCode(searchConditionVO.getEcTradeCode());
            	}
            	//顾客编码     
            	if (StringUtils.isNotBlank(searchConditionVO.getEcCustCode())){
            		param.setEcCustCode(searchConditionVO.getEcCustCode());
            	}
            	//平台订单ID   
            	if (StringUtils.isNotBlank(searchConditionVO.getEcTradeId())){
            		param.setEcTradeId(searchConditionVO.getEcTradeId());
            	}
            	//子平台订单ID 
            	if (StringUtils.isNotBlank(searchConditionVO.getChildEcTradeId())){
            		param.setChildEcTradeId(searchConditionVO.getChildEcTradeId());
            	}
            }

            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("status", "ecTrade.ecTradeStatus");
            replaceFieldsMap.put("shopName", "ecTrade.shop_name");
            
            // 排序语句生成
            String orderStatement = getOrderString(EcTradeDAOImpl.class.getName(), PAGE_SELECT_STATEMENT, replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }
            
            // 获取分页数据
            PageInfo<EcTradeVO> ecTradeVOList = ecTradeService.findByWhere(page, length, param);
        	
            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, ecTradeVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, ecTradeVOList.getTotal());
            returnMap.put(RETURN_DATA, ecTradeVOList.getList());
            
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
	}
	/**
	 * 取得订单商品列表
	 * @param ecTradeId
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ecTradeOrderList")
	public Map<String, Object> getEcTradeOrderList(String ecTradeId) throws Exception {
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	//查询条件
        	EcOrderVO param = new EcOrderVO();
        	
        	if (StringUtils.isBlank(ecTradeId)){
        		returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "订单ID为空");
        	} 
        	
        	param.setEcTradeId(ecTradeId);
        	
            PageInfo<EcOrderVO> ecOrderVOList = ecOrderService.findByWhere(1, Integer.MAX_VALUE, param);
        	
            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, ecOrderVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, ecOrderVOList.getTotal());
            returnMap.put(RETURN_DATA, ecOrderVOList.getList());
            
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
	}
	
	@ResponseBody
	@RequestMapping(value = "/canceledEcItem")
	public Map<String, Object> canceledEcItem(String orderId,String updateTime) throws Exception {
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            EcOrderVO paramVO = new EcOrderVO();
            paramVO.setEcOrderId(orderId);
            PageInfo<EcOrderVO> list = ecOrderService.findByWhere(1, 1, paramVO);
            if (list!=null && list.getSize() > 0) {
            	EcOrderVO vo = list.getList().get(0);
            	if (!updateTime.equals(vo.getUpdateTime().toString())){
            		returnMap.put(JSON_RESULT, FAILED);
                    returnMap.put(JSON_MSG, "平台商品已经被修改过。");
            	}
                vo.setDeleteReason("已废弃");
                ecOrderService.update(vo);
                returnMap.put(JSON_RESULT, SUCCESS);
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "平台商品不存在，请刷新后重试。");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
	}
	
	/**
	 * 取得tab页面头上的记录数
	 * @param quickSearch
	 * @param start
	 * @param length
	 * @param formJson
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/getTabCounts")
	public Map<String, Object> getTabCounts(String quickSearch,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length, String formJson) throws Exception {
		// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	//查询条件
        	EcTradeVO param = new EcTradeVO();
        	//快速查询
			quickSearch = URLDecoder.decode(quickSearch, "UTF-8");
			if (StringUtils.isNotBlank(quickSearch)) {
				param.setSearchCondition(quickSearch);
			}
			
			// 高级查询检索条件
            formJson = URLDecoder.decode(formJson, "UTF-8");
            //json转换成为ＶＯ
            SearchConditionVO searchConditionVO = JSONObject.parseObject(formJson, SearchConditionVO.class);
            if (searchConditionVO!=null){
            	//项目   
            	if (StringUtils.isNotBlank(searchConditionVO.getPrjId())){
            		param.setPrjId(searchConditionVO.getPrjId());
            	}
            	//店铺 
            	if (StringUtils.isNotBlank(searchConditionVO.getShopId())){
            		param.setShopId(searchConditionVO.getShopId());
            	}
            	//平台     
            	if (StringUtils.isNotBlank(searchConditionVO.getShopType())){
            		param.setShopType(searchConditionVO.getShopType());
            	}
            	//平台交易码  
            	if (StringUtils.isNotBlank(searchConditionVO.getEcTradeCode())){
            		param.setEcTradeCode(searchConditionVO.getEcTradeCode());
            	}
            	//顾客编码     
            	if (StringUtils.isNotBlank(searchConditionVO.getEcCustCode())){
            		param.setEcCustCode(searchConditionVO.getEcCustCode());
            	}
            	//平台订单ID   
            	if (StringUtils.isNotBlank(searchConditionVO.getEcTradeId())){
            		param.setEcTradeId(searchConditionVO.getEcTradeId());
            	}
            	//子平台订单ID 
            	if (StringUtils.isNotBlank(searchConditionVO.getChildEcTradeId())){
            		param.setChildEcTradeId(searchConditionVO.getChildEcTradeId());
            	}
            	//状态         
            	if (StringUtils.isNotBlank(searchConditionVO.getEcTradeStatus())){
            		param.setEcTradeStatus(searchConditionVO.getEcTradeStatus());
            	}
            }
            List<EcTradeVO> list = ecTradeService.findCounts(param);
        	
            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            int countNoPay = 0;
            int countWait = 0;
            int countWaitSend = 0;
            int countSend = 0;
            int countOver = 0;
            int countCancel = 0;
            
            if(list != null && list.size() > 0){
            	countNoPay = list.get(0).getCountNoPay()!=null?list.get(0).getCountNoPay().intValue():0;
            	countWait = list.get(0).getCountWait()!=null?list.get(0).getCountWait().intValue():0;
            	countWaitSend = list.get(0).getCountWaitSend()!=null?list.get(0).getCountWaitSend().intValue():0;
            	countSend = list.get(0).getCountSend()!=null?list.get(0).getCountSend().intValue():0;
            	countOver = list.get(0).getCountOver()!=null?list.get(0).getCountOver().intValue():0;
            	countCancel = list.get(0).getCountCancel()!=null?list.get(0).getCountCancel().intValue():0;
            } 
            returnMap.put("countNoPay", countNoPay);
            returnMap.put("countWait", countWait);
            returnMap.put("countWaitSend", countWaitSend);
            returnMap.put("countSend", countSend);
            returnMap.put("countOver", countOver);
            returnMap.put("countCancel", countCancel);
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
	}
	
}
