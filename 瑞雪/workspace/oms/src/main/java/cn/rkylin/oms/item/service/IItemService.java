package cn.rkylin.oms.item.service;

import java.util.List;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.item.vo.SkuVO;

/**
 * 平台商品服务层接口
 *
 * @author wangxing
 * @version 1.0
 * @created 16-2月-2017 9:00:00
 */
public interface IItemService {

    /**
     * 查询平台商品
     *
     * @param page
     * @param rows
     * @param itemVO
     * @return
     * @throws Exception
     */
    public PageInfo<ItemVO> findByWhere(int page, int rows, ItemVO itemVO) throws Exception;

    /**
     * 查询平台规格
     *
     * @param page
     * @param rows
     * @param skuVO
     * @return
     * @throws Exception
     */
    public PageInfo<SkuVO> findByWhere(int page, int rows, SkuVO skuVO) throws Exception;
    
    /**
     * 查询平台规格
     *
     * @param page
     * @param rows
     * @param skuVO
     * @return
     * @throws Exception
     */
    public List<SkuVO> findByWhere(SkuVO skuVO) throws Exception;

}