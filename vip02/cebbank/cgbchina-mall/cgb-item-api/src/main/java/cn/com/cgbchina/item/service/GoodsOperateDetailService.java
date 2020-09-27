package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.GoodsOperateDetailModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/20.
 */
public interface GoodsOperateDetailService {

    /**
     * 查找商品操作历史列表
     * @param pageNo
     * @param size
     * @param goodsCode
     * @return
     */
    public Response<Pager<GoodsOperateDetailModel>> findGoodsOperate(@Param("pageNo") Integer pageNo,
                                                                     @Param("size") Integer size,
                                                                     @Param("goodsCode") String goodsCode,
                                                                     @Param("goodsName")String goodsName,
                                                                     @Param("startTime")String startTime,
                                                                     @Param("endTime")String endTime,
                                                                     @Param("User")User user);

    /**
     * 新增商品操作记录
     * @param goodsOperateDetailModel
     * @return
     */
    public Response<Boolean> createGoodsOperate(GoodsOperateDetailModel goodsOperateDetailModel);
}
