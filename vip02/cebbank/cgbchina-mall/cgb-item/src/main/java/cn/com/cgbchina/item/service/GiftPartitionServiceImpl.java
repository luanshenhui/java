package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.GoodsRegionDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.dto.GiftPartionDto;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.manager.GiftPartitionManager;
import cn.com.cgbchina.item.model.GoodsRegionModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;


@Service
@Slf4j
public class GiftPartitionServiceImpl implements GiftPartitionService {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Resource
    private GoodsRegionDao goodsRegionDao;
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private TblCfgIntegraltypeDao tblCfgIntegraltypeDao;
    @Resource
    private GiftPartitionManager giftPartitionManager;

    /**
     * 礼品分区信息
     *
     * @param pageNo
     * @param size
     * @param code
     * @param name
     * @param user
     * @return
     */
    @Override
    public Response<Pager<GiftPartionDto>> findGiftPartitionAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                                @Param("code") String code, @Param("name") String name, @Param("User") User user) {
        Response<Pager<GiftPartionDto>> result = new Response<Pager<GiftPartionDto>>();
        // 将查询条件封装成一个map
        Map<String, Object> params = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 分区代码
        if (!Strings.isNullOrEmpty(code)) {
            params.put("code", code);
        }
        // 分区名称
        if (!Strings.isNullOrEmpty(name)) {
            params.put("name", name);
        }
        try {
            Pager<GoodsRegionModel> pager = goodsRegionDao.findByPage(params, pageInfo.getOffset(), pageInfo.getLimit());
            GiftPartionDto giftPartionDto = null;
            TblCfgIntegraltypeModel tblCfgIntegraltypeModel = new TblCfgIntegraltypeModel();
            List<GiftPartionDto> giftPartitionList = new ArrayList<GiftPartionDto>();
            if (pager.getTotal() > 0) {
                List<GoodsRegionModel> regionList = pager.getData();
                // 将数据循环并加入积分类型名称，整合为giftPartitionList
                for (GoodsRegionModel goodsRegionModel : regionList) {
                    giftPartionDto = new GiftPartionDto();
                    // 根据积分类型ID到积分类型表中查询积分类型名称，放入giftPartionDto
                    tblCfgIntegraltypeModel = tblCfgIntegraltypeDao.findById(goodsRegionModel.getPointsType());
                    if (tblCfgIntegraltypeModel != null) {
                        giftPartionDto.setIntegraltypeNm(tblCfgIntegraltypeModel.getIntegraltypeNm());
                    }
                    giftPartionDto.setGoodsRegionModel(goodsRegionModel);
                    giftPartitionList.add(giftPartionDto);
                }
                result.setResult(new Pager<GiftPartionDto>(pager.getTotal(), giftPartitionList));
            } else {
                result.setResult(new Pager<GiftPartionDto>(0L, Collections.<GiftPartionDto>emptyList()));
            }

        } catch (Exception e) {
            log.error("find.gift_partition.list.error", Throwables.getStackTraceAsString(e));
            result.setError("find.gift_partition.list.error");
        }
        return result;
    }

    /**
     * 积分类型名称List
     *
     * @return
     */
    @Override
    public Response<List<TblCfgIntegraltypeModel>> findPointsTypeName() {
        Response<List<TblCfgIntegraltypeModel>> result = new Response<List<TblCfgIntegraltypeModel>>();
        try {
            List<TblCfgIntegraltypeModel> pointsNameList = tblCfgIntegraltypeDao.findAll();
            result.setResult(pointsNameList);
        } catch (Exception e) {
            log.error("failed.to.find.pointsNameList", e);
            result.setError("find.pointsNameList.error");
        }
        return result;
    }

    /**
     * 新增礼品分区
     *
     * @param goodsRegionModel
     * @return
     */
    @Override
    public Response<Boolean> createPartition(GoodsRegionModel goodsRegionModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = giftPartitionManager.createPartition(goodsRegionModel);
            if (!result) {
                response.setError("insert.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("partition.create.error", Throwables.getStackTraceAsString(e));
            response.setError("insert.error");
            return response;
        }
    }

    /**
     * 编辑礼品分区
     *
     * @param goodsRegionModel
     * @return
     */
    @Override
    public Response<Boolean> updatePartition(GoodsRegionModel goodsRegionModel) {
        Response<Boolean> response = new Response<Boolean>();
        // 获取ID
        try {
            goodsRegionModel.setId((goodsRegionModel.getId()));
            Boolean result = giftPartitionManager.update(goodsRegionModel);
            if (!result) {
                response.setError("update.error");
                return response;
            }
            response.setResult(result);
        } catch (Exception e) {
            log.error("partition.update.error", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
            return response;
        }

        return response;
    }

    /**
     * 删除礼品分区
     *
     * @param goodsRegionModel
     * @return
     */
    @Override
    public Response<Boolean> delete(GoodsRegionModel goodsRegionModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = giftPartitionManager.delete(goodsRegionModel);
            if (!result) {
                response.setError("delete.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("delete.giftPartition.error", Throwables.getStackTraceAsString(e));
            response.setError("delete.error");
            return response;
        }
    }

    /**
     * 校验礼品分区
     *
     * @param name
     * @param code
     * @param id
     * @param sort
     * @return
     */
    @Override
    public Response<GiftPartitionCheckDto> checkGiftpartition(String code, String name, Long id, Integer sort) {
        Response<GiftPartitionCheckDto> response = new Response<GiftPartitionCheckDto>();
        GiftPartitionCheckDto giftPartitionCheckDto = new GiftPartitionCheckDto();
        // 新增和编辑对分区名称的校验区分 当id为null时是新增操作 不为null时是编辑操作
        try {
            if (id != null) {
                // 当为编辑操作时 先通过id查出该条数据的name
                GoodsRegionModel goodsRegionModel = goodsRegionDao.findById(id);
                // 顺序校验
                if (!sort.equals(goodsRegionModel.getSort())) {
                    Long sortTotal = goodsRegionDao.checkpartitionSort(sort);
                    if (sortTotal != 0) {
                        giftPartitionCheckDto.setSortCheck(false);
                        response.setResult(giftPartitionCheckDto);
                    } else {
                        giftPartitionCheckDto.setSortCheck(true);
                        response.setResult(giftPartitionCheckDto);
                    }
                }else{
                    giftPartitionCheckDto.setSortCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
            } else {
                // 新增时,校验名字是否重复
                Long total = goodsRegionDao.checkGiftpartition(name);
                if (total != 0) {
                    giftPartitionCheckDto.setNameCheck(false);
                    response.setResult(giftPartitionCheckDto);
                } else {
                    giftPartitionCheckDto.setNameCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
                // 新增时，校验分区代码是否重复
                Long codeTotal = goodsRegionDao.checkpartitionCode(code);
                if (codeTotal != 0) {
                    giftPartitionCheckDto.setCodeCheck(false);
                    response.setResult(giftPartitionCheckDto);
                } else {
                    giftPartitionCheckDto.setCodeCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
                // 新增时，校验分区排序是否重复
                Long sortTotal = goodsRegionDao.checkpartitionSort(sort);
                if (sortTotal != 0) {
                    giftPartitionCheckDto.setSortCheck(false);
                    response.setResult(giftPartitionCheckDto);
                } else {
                    giftPartitionCheckDto.setSortCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
            }
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("select.giftPartition.error", Throwables.getStackTraceAsString(e));
            response.setError("check.partition.error");
        }
        return response;
    }

    /**
     * 判断分区下是否有礼品
     * @param code
     * @return
     */
    @Override
    public Response<GiftPartitionCheckDto> checkUsedPartition(String code) {
        Response<GiftPartitionCheckDto> response = new Response<GiftPartitionCheckDto>();
        GiftPartitionCheckDto giftPartitionCheckDto = new GiftPartitionCheckDto();
        try{
            Long total = goodsDao.checkUsedPartition(code);
            if (total != 0) {
                giftPartitionCheckDto.setRegionTypeCheck(false);
                response.setResult(giftPartitionCheckDto);
            } else {
                giftPartitionCheckDto.setRegionTypeCheck(true);
                response.setResult(giftPartitionCheckDto);
            }
        }catch (Exception e){
            log.error("select.giftPartition.error", Throwables.getStackTraceAsString(e));
            response.setError("check.gift.of.partition.error");
        }
        return response;
    }


}
