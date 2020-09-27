package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GiftPartionDto;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.model.GoodsRegionModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by tongxueying on 16-6-23.
 */
public interface GiftPartitionService {

    public Response<Pager<GiftPartionDto>> findGiftPartitionAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                                @Param("code") String code, @Param("name") String name, @Param("User") User user);

    /**
     * 积分类型名称List
     *
     * @return
     */
    public Response<List<TblCfgIntegraltypeModel>> findPointsTypeName();

    /**
     * 新增礼品分区
     *
     * @param goodsRegionModel
     * @return
     */
    public Response<Boolean> createPartition(GoodsRegionModel goodsRegionModel);

    /**
     * 编辑礼品分区
     *
     * @param goodsRegionModel
     * @return
     */
    public Response<Boolean> updatePartition(GoodsRegionModel goodsRegionModel);

    /**
     * 删除礼品分区
     * @param goodsRegionModel
     * @return
     */
    public Response<Boolean> delete(GoodsRegionModel goodsRegionModel);

    /**
     * 校验礼品分区
     * @param name
     * @param code
     * @param id
     * @param sort
     * @return
     */
    public Response<GiftPartitionCheckDto> checkGiftpartition(String code,String name, Long id, Integer sort);

    /**
     *
     * @param code
     * @return
     */
    public Response<GiftPartitionCheckDto> checkUsedPartition(String code);

}
