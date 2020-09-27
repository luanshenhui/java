package cn.rkylin.oms.item.dao;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.item.vo.SkuVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 平台商品数据访问层
 *
 * @author wangxing
 * @version 1.0
 * @created 16-2月-2017 9:00:00
 */
@Repository(value = "itemDAO")
public class ItemDAOImpl implements IItemDAO {

    @Autowired
    protected IDataBaseFactory dao;

    /**
     * 构造函数
     */
    public ItemDAOImpl() {

    }

    /**
     * 查询平台商品
     *
     * @param itemVO
     */
    public List<ItemVO> findByWhere(ItemVO itemVO) {
        return null;
    }

    /**
     * 查询平台规格
     *
     * @param skuVO
     */
    public List<SkuVO> findByWhere(SkuVO skuVO) {
        return null;
    }

}