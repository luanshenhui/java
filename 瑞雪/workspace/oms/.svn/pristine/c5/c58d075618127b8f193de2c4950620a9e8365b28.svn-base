package cn.rkylin.oms.item.controller;

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
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.oms.item.dao.ItemDAOImpl;
import cn.rkylin.oms.item.service.IItemService;
import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.item.vo.SkuVO;

/**
 * 平台商品控制器
 *
 * @author wangxing
 * @version 1.0
 * @created 16-2月-2017 9:00:00
 */
@Controller
@RequestMapping("/item")
public class ItemController extends ApolloController {
    private static final Log logger = LogFactory.getLog(ItemController.class);
    // 常量定义
    private static final String PAGE_SELECT_STATEMENT = "pageSelectItem"; // 分页语句Statement名称
    private static final String PAGE_SELECT_STATEMENT_SKU = "pageSelectSku"; // 分页语句Statement名称
    private static final String GOTO_ITEM_LIST = "/item/itemList"; // 跳转到店铺列表页

    /**
     * 平台商品服务层
     */
    @Autowired
    private IItemService itemService;

    /**
     * 构造函数
     */
    public ItemController() {

    }

    @Override
    public void afterPropertiesSet() throws Exception {
        setExportService((IExport) itemService);
    }

    /**
     * 跳转到平台商品列表
     */
    @RequestMapping(value = "/gotoItemList")
    public String gotoItemList() {
        return GOTO_ITEM_LIST;
    }

    /**
     * 跳转到平台商品列表
     *
     * @param quickSearch 快速查询条件
     * @param formJson    高级检索条件
     * @return 返回值JSON格式字符串
     * @Param start        第几页
     * @Param length       每页多少行
     */
    @ResponseBody
    @RequestMapping(value = "/itemList")
    public Map<String, Object> getItemList(String quickSearch,
                                           @RequestParam(required = false, defaultValue = "0") int start,
                                           @RequestParam(required = false, defaultValue = "10") int length,
                                           String formJson) throws Exception {

        // 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            // 处理查询条件
            ItemVO param = new ItemVO();

            // 前台快速搜索条件
            if (quickSearch != null) {
                quickSearch = URLDecoder.decode(quickSearch, "UTF-8");
                if (StringUtils.isNotEmpty(quickSearch)) {
                    param.setSearchCondition(quickSearch);
                }
            } else {
                // 高级查询检索条件
                formJson = URLDecoder.decode(formJson, "UTF-8");
                ItemVO itemVO = JSONObject.parseObject(formJson, ItemVO.class);
                if (itemVO != null) {
                    if (StringUtils.isNotEmpty(itemVO.getPrjId())) {
                        param.setPrjId(itemVO.getPrjId());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getShopId())) {
                        param.setShopId(itemVO.getShopId());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getShopType())) {
                        param.setShopType(itemVO.getShopType());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getApproveStatus())) {
                        param.setApproveStatus(itemVO.getApproveStatus());
                    }

                    if (StringUtils.isNotEmpty(itemVO.getEcItemCode())) {
                        param.setEcItemCode(itemVO.getEcItemCode());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getEcItemName())) {
                        param.setEcItemName(itemVO.getEcItemName());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getEcSkuCode())) {
                        param.setEcSkuCode(itemVO.getEcSkuCode());
                    }
                    if (StringUtils.isNotEmpty(itemVO.getEcSkuName())) {
                        param.setEcSkuName(itemVO.getEcSkuName());
                    }

                } else {
                    param.setPrjId("00000000000000000000000000000000");
                }
            }


            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("status", "approveStatus");

            // 排序语句生成
            String orderStatement = getOrderString(ItemDAOImpl.class.getName(), PAGE_SELECT_STATEMENT, replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            // 处理分页
            if (length == -1) {
                length = Integer.MAX_VALUE;
            }
            int page = start / length + 1;

            // 获取分页数据
            PageInfo<ItemVO> itemVOList = itemService.findByWhere(page, length, param);

            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, itemVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, itemVOList.getTotal());
            returnMap.put(RETURN_DATA, itemVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }

    /**
     * 获取平台规格列表
     *
     * @param ecItemId 平台商品ID
     * @return SkuVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/skuList")
    public Map<String, Object> getSkuList(String ecItemId) throws Exception {
        Map<String, Object> returnJSON = new HashMap<String, Object>();
        try {

            SkuVO param = new SkuVO();
            if (StringUtils.isNotEmpty(ecItemId)) {
                param.setEcItemId(ecItemId);
            }

            // 排序语句生成
            String orderStatement = getOrderString(ItemDAOImpl.class.getName(), PAGE_SELECT_STATEMENT_SKU, null, "BaseSkuResultMap");
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            List<SkuVO> skuVOList = itemService.findByWhere(param);
            if (!skuVOList.isEmpty()) {
                returnJSON.put(JSON_RESULT, SUCCESS);
                returnJSON.put(RECORDS_FILTERED, skuVOList.size());
                returnJSON.put(RECORDS_TOTAL, skuVOList.size());
                returnJSON.put(RETURN_DATA, skuVOList);
            } else {
                returnJSON.put(JSON_RESULT, SUCCESS);
                returnJSON.put(RECORDS_FILTERED, 0);
                returnJSON.put(RECORDS_TOTAL, 0);
                returnJSON.put(RETURN_DATA, skuVOList);
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnJSON.put(JSON_RESULT, FAILED);
            returnJSON.put(JSON_MSG, ex.getMessage());
        }
        return returnJSON;
    }

}