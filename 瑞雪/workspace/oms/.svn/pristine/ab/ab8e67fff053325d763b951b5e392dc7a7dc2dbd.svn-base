package cn.rkylin.oms.system.shop.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.oms.common.context.CurrentUser;
import cn.rkylin.oms.common.context.WebContextFactory;
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.oms.system.project.service.ProjectManagerService;
import cn.rkylin.oms.system.project.vo.ProjectVO;
import cn.rkylin.oms.system.shop.dao.ShopDAOImpl;
import cn.rkylin.oms.system.shop.service.IShopService;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺控制器
 *
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:15
 */
@Controller
@RequestMapping("/shop")
public class ShopController extends ApolloController {
    private static final Log logger = LogFactory.getLog(ShopController.class);
    // 常量定义
    private static final String PAGE_SELECT_STATEMENT = "pageSelectShop"; // 分页语句Statement名称
    private static final String GOTO_SHOP_LIST = "/system/shop/shopList"; // 跳转到店铺列表页

    /**
     * 店铺服务层
     */
    @Autowired
    private IShopService shopService;

    @Autowired
    public ProjectManagerService projectManagerService;

    /**
     * 构造函数
     */
    public ShopController() {

    }

    @Override
    public void afterPropertiesSet() throws Exception {
        setExportService((IExport) shopService);
    }

    /**
     * 跳转到店铺列表
     */
    @RequestMapping(value = "/gotoShopList")
    public String gotoShopList() {
        return GOTO_SHOP_LIST;
    }

    /**
     * 跳转到店铺列表
     *
     * @param quickSearch 快速查询条件
     * @return 返回值JSON格式字符串
     * @Param start 第几页
     * @Param length 每页多少行
     */
    @SuppressWarnings("rawtypes")
    @ResponseBody
    @RequestMapping(value = "/shopList", method = RequestMethod.GET)
    public Map<String, Object> getShopList(String quickSearch,String enable,String entId,String prjId,
                                           @RequestParam(required = false, defaultValue = "0") int start,
                                           @RequestParam(required = false, defaultValue = "10") int length)
            throws Exception {
        // 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            // 前台搜索条件，此处只有一个店铺名称
            quickSearch = URLDecoder.decode(quickSearch, "UTF-8");

            // 处理分页
            if (length == -1) {
                length = Integer.MAX_VALUE;
            }
            int page = start / length + 1;

            // 处理快速查询条件
            ShopVO param = new ShopVO();
            if (StringUtils.isNotEmpty(quickSearch)) {
                param.setSearchCondition(quickSearch);
            }
            if (StringUtils.isNotEmpty(prjId)) {
            	param.setPrjId(prjId);
            }else if(StringUtils.isNotEmpty(entId)) {
            	param.setEntId(entId);
            }else if (StringUtils.isNotEmpty(enable)) {
                CurrentUser currentUser = WebContextFactory.getWebContext().getCurrentUser();
                List list=currentUser.getUnitList();
                param.setEnable(enable);
                if(list.size()>0){
                    param.setUnitList(list);
                }else{
                    returnMap.put(JSON_RESULT, SUCCESS);
                    returnMap.put("recordsFiltered", 0);
                    returnMap.put("recordsTotal", 0);
                    returnMap.put(RETURN_DATA, new ArrayList<T>());
                    return returnMap;
                }
            }else{
            	 returnMap.put(JSON_RESULT, SUCCESS);
                 returnMap.put("recordsFiltered", 0);
                 returnMap.put("recordsTotal", 0);
                 returnMap.put(RETURN_DATA, new ArrayList<T>());
                 return returnMap;
            }

            // 处理转义的字段
            Map<String, String> replaceFieldsMap = new HashMap<String, String>();
            replaceFieldsMap.put("validateStatus", "validate");
            replaceFieldsMap.put("status", "enable");

            // 排序语句生成
            String orderStatement = getOrderString(ShopDAOImpl.class.getName(), PAGE_SELECT_STATEMENT,
                    replaceFieldsMap);
            if (StringUtils.isNotEmpty(orderStatement)) {
                param.setOrderBy(orderStatement);
            }

            // 获取分页数据
            PageInfo<ShopVO> shopVOList = shopService.findByWhere(page, length, param);

            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RECORDS_FILTERED, shopVOList.getTotal());
            returnMap.put(RECORDS_TOTAL, shopVOList.getTotal());
            returnMap.put(RETURN_DATA, shopVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }

    /**
     * 获取店铺明细信息
     *
     * @param shopId 店铺id
     * @return ShopVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/shopDetail", method = RequestMethod.GET)
    public Map<String, Object> shopDetail(String shopId) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
//            PageInfo<ShopVO> shopVOList = shopService.findByWhere(1, 1, param);
            ShopVO detailShop = shopService.getShopById(shopId);
            if (detailShop != null) {
                returnMap.put(JSON_RESULT, SUCCESS);
                returnMap.put(RETURN_DATA, detailShop);
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "该店铺不存在");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 获取子店铺列表
     *
     * @return ShopVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/childShopList", method = RequestMethod.GET)
    public Map<String, Object> childShopList(String shopId) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	ShopVO param = new ShopVO();
        	param.setParentShop(shopId);
            PageInfo<ShopVO> parentShopList = shopService.findByWhere(1, Integer.MAX_VALUE, param);
            if (!parentShopList.getList().isEmpty()) {
                returnMap.put(JSON_RESULT, SUCCESS);
                returnMap.put(RETURN_DATA, parentShopList.getList());
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "没有子店铺");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }
    
    /**
     * 获取父店铺列表
     *
     * @return ShopVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/parentShopList", method = RequestMethod.GET)
    public Map<String, Object> parentShopList() throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
        	ShopVO param = new ShopVO();
        	param.setNeedSplitOrder(VALUE_YES);
            PageInfo<ShopVO> parentShopList = shopService.findByWhere(1, Integer.MAX_VALUE, param);
            if (!parentShopList.getList().isEmpty()) {
                returnMap.put(JSON_RESULT, SUCCESS);
                returnMap.put(RETURN_DATA, parentShopList.getList());
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "没有父店铺");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }
    
    /**
     * 获取指定项目店铺信息
     *
     * @param prjId 项目ID
     * @return ShopVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getShopListByPrjId", method = RequestMethod.GET)
    public Map<String, Object> getShopListByPrjId(String prjId) throws Exception {
    	prjId = URLDecoder.decode(prjId, "UTF-8");
        /// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ShopVO param = new ShopVO();
            if (StringUtils.isNotEmpty(prjId)) {
                param.setPrjId(prjId);
            } else {
                param.setPrjId("00000000000000000000000000000000");
            }

            PageInfo<ShopVO> shopVOList = shopService.findByWhere(1, Integer.MAX_VALUE, param);
            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
//            returnMap.put(RECORDS_FILTERED, shopVOList.getTotal());
//            returnMap.put(RECORDS_TOTAL, shopVOList.getTotal());
            returnMap.put(RETURN_DATA, shopVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }
    
    /**
     * 获取指定项目需要分单的店铺信息
     *
     * @param prjId 项目ID
     * @return ShopVO的json串
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getSplitShopList", method = RequestMethod.GET)
    public Map<String, Object> getSplitShopList(String prjId) throws Exception {
    	prjId = URLDecoder.decode(prjId, "UTF-8");
        /// 用于返回值的json对象
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ShopVO param = new ShopVO();
            if (StringUtils.isNotEmpty(prjId)) {
                param.setPrjId(prjId);
            } else {
                param.setPrjId("00000000000000000000000000000000");
            }

            PageInfo<ShopVO> shopVOList = shopService.findSplitShop(1, Integer.MAX_VALUE, param);
            // 设置返回结果内容
            returnMap.put(JSON_RESULT, SUCCESS);
            returnMap.put(RETURN_DATA, shopVOList.getList());
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        // 生成返回结果json串，null内容也需要返回
        return returnMap;
    }

    /**
     * 创建店铺
     *
     * @param shopVO 前台值映射到ShopVO
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/addShop")
    public Map<String, Object> addShop(@RequestBody ShopVO shopVO) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            if (isShopUnique(shopVO.getShopName(), shopVO.getShopType(),shopVO.getPrjId())) {
                shopVO.setShopId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
                shopVO.setValidate(VALUE_YES);
                shopVO.setDeleted(VALUE_NO);
                shopVO.setCreateTime(new Date());
                shopVO.setModifyTime(new Date());
//                shopVO.setExpireTime(shopVO.getExpireTime());
//                shopVO.setStartTime(new Date());
                shopService.insert(shopVO);
                returnMap.put(JSON_RESULT, SUCCESS);
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "该店铺名称与店铺类型已经存在");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 判断店铺唯一性(店铺名称 + 店铺类型)
     *
     * @param shopName 店铺名称
     * @param shopType 店铺类型
     * @return true唯一，false不唯一
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/isShopUnique")
    public boolean isShopUnique(String shopName, String shopType , String prjId) throws Exception {
        shopName = URLDecoder.decode(shopName, "UTF-8");
        shopType = URLDecoder.decode(shopType, "UTF-8");
        prjId = URLDecoder.decode(prjId, "UTF-8");
        boolean result = false;
        ShopVO paramVO = new ShopVO();
        paramVO.setShopName(shopName);
        paramVO.setShopType(shopType);
        paramVO.setPrjId(prjId);
        paramVO.setDeleted("yn");
        PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, paramVO);
        if (shopList.getSize() > 0) {
            result = false;
        } else {
            result = true;
        }
        return result;
    }

    /**
     * 修改店铺
     *
     * @param shopVO 前台值映射到ShopVO
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/updateShop")
    public Map<String, Object> updateShop(@RequestBody ShopVO shopVO) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            shopService.update(shopVO);
            returnMap.put(JSON_RESULT, SUCCESS);
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 删除店铺
     *
     * @param shopId 店铺ID
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/deleteShop", method = RequestMethod.POST)
    public Map<String, Object> deleteShop(String shopId) throws Exception {
        Map<String, Object> returnMap = new JSONObject();
        try {
            ShopVO paramVO = new ShopVO();
            paramVO.setShopId(shopId);
            PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, paramVO);
            if (shopList.getSize() > 0) {
                ShopVO updateShop = shopList.getList().get(0);
                updateShop.setDeleted(VALUE_YES);
                shopService.update(updateShop);
                returnMap.put(JSON_RESULT, SUCCESS);
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "店铺不存在，请刷新后重试。");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 启用店铺
     * 店铺过期时间必须大于现在，且店铺对应项目不能是停止状态
     *
     * @param shopId 店铺ID
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/setEnable", method = RequestMethod.POST)
    public Map<String, Object> setEnable(String shopId) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ShopVO shopVO = new ShopVO();
            shopVO.setShopId(shopId);
            PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, shopVO);
            if (shopList.getSize() > 0) {
                ShopVO updateShop = shopList.getList().get(0);

            	// 如果项目已经停用了，则店铺不能启用。
            	ProjectVO prjVO = new ProjectVO();
            	prjVO.setPrjId(updateShop.getPrjId());
            	PageInfo<ProjectVO> projectVOList = projectManagerService.findByWhere(1, 1, prjVO);
            	
            	if (projectVOList.getSize() > 0) { // 店铺对应的项目存在
            		if (projectVOList.getList().get(0).getEnable().equalsIgnoreCase("y")) {
                        // 启用店铺，必须设置过期时间，且过期时间要大于当前时间
                        Long now = (new Date()).getTime();
                        if (updateShop.getExpireTime() != null && updateShop.getExpireTime().getTime() >= now) {
                            updateShop.setEnable(VALUE_YES);
                            shopService.update(updateShop);
                            returnMap.put(JSON_RESULT, SUCCESS);
                        } else {
                            returnMap.put(JSON_RESULT, FAILED);
                            returnMap.put(JSON_MSG, "必须设置过期时间，且过期时间要大于当前时间。");
                        }
            		} else { // 店铺对应的项目已经停用
                        returnMap.put(JSON_RESULT, FAILED);
                        returnMap.put(JSON_MSG, "不能启用店铺，因项目处于“停用”状态。");
            		}
            	} else { // 店铺对应的项目不存在
                    returnMap.put(JSON_RESULT, FAILED);
                    returnMap.put(JSON_MSG, "店铺对应的项目不存在。");
            	}
                
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "店铺不存在，请刷新后重试。");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 禁用店铺
     *
     * @param shopId 店铺ID
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/setDisable", method = RequestMethod.POST)
    public Map<String, Object> setDisable(String shopId) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ShopVO shopVO = new ShopVO();
            shopVO.setShopId(shopId);
            PageInfo<ShopVO> shopList = shopService.findByWhere(1, 1, shopVO);
            if (shopList.getSize() > 0) {
                ShopVO updateShop = shopList.getList().get(0);
                updateShop.setEnable(VALUE_NO);
                shopService.update(updateShop);
                returnMap.put(JSON_RESULT, SUCCESS);
            } else {
                returnMap.put(JSON_RESULT, FAILED);
                returnMap.put(JSON_MSG, "店铺不存在，请刷新后重试。");
            }
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

    /**
     * 验证店铺
     *
     * @param shopId 店铺ID
     * @return 返回值JSON格式字符串
     */
    @ResponseBody
    @RequestMapping(value = "/validate")
    public Map<String, Object> validate(String shopId) throws Exception {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try {
            ShopVO shopVO = new ShopVO();
            shopVO.setShopId(shopId);
            shopService.validate(shopVO);
            returnMap.put(JSON_RESULT, SUCCESS);
        } catch (Exception ex) {
            logger.error(ex);
            returnMap.put(JSON_RESULT, FAILED);
            returnMap.put(JSON_MSG, ex.getMessage());
        }
        return returnMap;
    }

}