package cn.rkylin.oms.item.dao;

import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.item.vo.SkuVO;

import java.util.List;

/**
 * 平台商品数据访问层接口
 *
 * @author wangxing
 * @version 1.0
 * @created 16-2月-2017 9:00:00
 */
public interface IItemDAO {

    /**
     * 查询平台商品
     *
     * @param itemVO
     */
    public List<ItemVO> findByWhere(ItemVO itemVO) throws Exception;

    /**
     * 查询平台规格
     *
     * @param skuVO
     */
    public List<SkuVO> findByWhere(SkuVO skuVO) throws Exception;

}