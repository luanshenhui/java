package cn.rkylin.oms.item.service;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.item.dao.IItemDAO;
import cn.rkylin.oms.item.vo.ItemVO;
import cn.rkylin.oms.item.vo.SkuVO;
import com.github.pagehelper.PageInfo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 平台商品管理服务实现
 *
 * @author wangxing
 * @version 1.0
 * @created 16-2月-2017 9:00:00
 */

@Service("itemService")
public class ItemServiceImpl extends ApolloService implements IItemService {

    /**
     * 平台商品数据访问
     */
    @Autowired
    private IItemDAO itemDAO;

    public IItemDAO getItemDAO() {
        return itemDAO;
    }

    public void setItemDAO(IItemDAO itemDAO) {
        this.itemDAO = itemDAO;
    }

    /**
     * 构造函数
     */
    public ItemServiceImpl() {

    }

    /**
     * 查询平台商品
     *
     * @param page
     * @param rows
     * @param itemVO
     * @return
     * @throws Exception
     */
    public PageInfo<ItemVO> findByWhere(int page, int rows, ItemVO itemVO) throws Exception {
//        PageInfo<ItemVO> itemVOList = findPage(page, rows, "pageSelectItem", itemVO, skuVO);
        PageInfo<ItemVO> itemVOList = findPage(page, rows, "pageSelectItem", itemVO);
        return itemVOList;
    }

    /**
     * 查询平台规格
     *
     * @param page
     * @param rows
     * @param skuVO
     * @return
     * @throws Exception
     */
    public PageInfo<SkuVO> findByWhere(int page, int rows, SkuVO skuVO) throws Exception {
        PageInfo<SkuVO> skuVOList = findPage(page, rows, "pageSelectSku", skuVO);
        return skuVOList;
    }

	@Override
	public List<SkuVO> findByWhere(SkuVO skuVO) throws Exception {
		List<SkuVO> skuVOList = findPage("pageSelectSku", skuVO);
        return skuVOList;
	}

}