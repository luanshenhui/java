/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.GoodsOperateDetailDao;
import cn.com.cgbchina.item.model.GoodsOperateDetailModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/20.
 */

@Component
@Transactional
public class GoodsOperateDetaiManager {

    @Resource
    private GoodsOperateDetailDao goodsOperateDetailDao;

    public void create(GoodsOperateDetailModel goodsOperateDetailModel){
        goodsOperateDetailDao.insert(goodsOperateDetailModel);
    }
}

