package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GiftPartionDto;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.dto.PresentRegionDto;
import cn.com.cgbchina.item.model.EspAreaInfModel;
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
                                                                @Param("areaId") String areaId, @Param("areaName") String areaName, @Param("User") User user);

    /**
     * 积分类型名称List
     *
     * @return
     */
    public Response<List<TblCfgIntegraltypeModel>> findPointsTypeName();

    /**
     * 新增礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    public Response<Boolean> createPartition(EspAreaInfModel espAreaInfModel);

    /**
     * 编辑礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    public Response<Boolean> updatePartition(EspAreaInfModel espAreaInfModel);

    /**
     * 删除礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    public Response<Boolean> delete(EspAreaInfModel espAreaInfModel);

    /**
     * 校验礼品分区
     *
     * @param areaId
     * @param areaName
     * @param id
     * @param areaSeq
     * @return
     */
    public Response<GiftPartitionCheckDto> checkGiftpartition(String areaId, String areaName, Long id, Integer areaSeq);

    /**
     * 校验此分区下是否有礼品
     *
     * @param areaId
     * @return
     */
    public Response<GiftPartitionCheckDto> checkUsedPartition(String areaId);

    /**
     * 获取礼品分区信息
     * @return
     */
    Response<List<PresentRegionDto>> findAll();

    /**
     * 根据id查询礼品分区信息
     *
     * @param id
     * @return
     */
    Response<EspAreaInfModel> findById(Long id);
}
