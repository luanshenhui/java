package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.dto.GiftPartionDto;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.dto.PresentRegionDto;
import cn.com.cgbchina.item.manager.GiftPartitionManager;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class GiftPartitionServiceImpl implements GiftPartitionService {
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private TblCfgIntegraltypeDao tblCfgIntegraltypeDao;
    @Resource
    private GiftPartitionManager giftPartitionManager;
    @Resource
    private EspAreaInfDao espAreaInfDao;


    /**
     * 礼品分区信息
     *
     * @param pageNo
     * @param size
     * @param areaId
     * @param areaName
     * @param user
     * @return
     */
    @Override
    public Response<Pager<GiftPartionDto>> findGiftPartitionAll(@Param("pageNo") Integer pageNo,
                                                                @Param("size") Integer size, @Param("areaId") String areaId, @Param("areaName") String areaName,
                                                                @Param("User") User user) {
        Response<Pager<GiftPartionDto>> result = new Response<Pager<GiftPartionDto>>();
        // 将查询条件封装成一个map
        Map<String, Object> params = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 分区代码
        if (!Strings.isNullOrEmpty(areaId)) {
            params.put("areaId", areaId);
        }
        // 分区名称
        if (!Strings.isNullOrEmpty(areaName)) {
            params.put("areaName", areaName);
        }
        try {
            Pager<EspAreaInfModel> pager = espAreaInfDao.findByPage(params, pageInfo.getOffset(), pageInfo.getLimit());
            GiftPartionDto giftPartionDto = null;
            List<GiftPartionDto> giftPartitionList = new ArrayList<GiftPartionDto>();
            if (pager.getTotal() > 0) {
                List<EspAreaInfModel> espAreaInfModels = pager.getData();
                // 将数据循环并加入积分类型名称，整合为giftPartitionList
                for (EspAreaInfModel espAreaInfModel : espAreaInfModels) {
                    giftPartionDto = new GiftPartionDto();
                    // 根据积分类型ID到积分类型表中查询积分类型名称，放入giftPartionDto
                    TblCfgIntegraltypeModel tblCfgIntegraltypeModel = tblCfgIntegraltypeDao.findById(espAreaInfModel.getIntegralType());
                    if (tblCfgIntegraltypeModel != null) {
                        giftPartionDto.setIntegraltypeNm(tblCfgIntegraltypeModel.getIntegraltypeNm());
                    }
                    giftPartionDto.setEspAreaInfModel(espAreaInfModel);
                    giftPartitionList.add(giftPartionDto);
                }
                result.setResult(new Pager<GiftPartionDto>(pager.getTotal(), giftPartitionList));
            } else {
                result.setResult(new Pager<GiftPartionDto>(0L, Collections.<GiftPartionDto>emptyList()));
            }

        } catch (Exception e) {
            log.error("find.giftPartition.list.error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("find.giftPartition.list.error");
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
            log.error("failed.to.find.pointsNameList  cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("find.pointsNameList.error");
        }
        return result;
    }

    /**
     * 新增礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    @Override
    public Response<Boolean> createPartition(EspAreaInfModel espAreaInfModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = giftPartitionManager.createPartition(espAreaInfModel);
            if (!result) {
                response.setError("giftPartition.insert.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("partition.create.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("giftPartition.insert.error");
            return response;
        }
    }

    /**
     * 编辑礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    @Override
    public Response<Boolean> updatePartition(EspAreaInfModel espAreaInfModel) {
        Response<Boolean> response = new Response<Boolean>();
        // 获取ID
        try {
            espAreaInfModel.setId((espAreaInfModel.getId()));
            Boolean result = giftPartitionManager.update(espAreaInfModel);
            if (!result) {
                response.setError("update.error");
                return response;
            }
            response.setResult(result);
        } catch (Exception e) {
            log.error("partition.update.error.cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
            return response;
        }

        return response;
    }

    /**
     * 删除礼品分区
     *
     * @param espAreaInfModel
     * @return
     */
    @Override
    public Response<Boolean> delete(EspAreaInfModel espAreaInfModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = giftPartitionManager.delete(espAreaInfModel);
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
            log.error("delete.giftPartition.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("delete.error");
            return response;
        }
    }

    /**
     * 校验礼品分区
     *
     * @param areaId
     * @param areaName
     * @param id
     * @param areaSeq
     * @return
     */
    @Override
    public Response<GiftPartitionCheckDto> checkGiftpartition(String areaId, String areaName, Long id, Integer areaSeq) {
        Response<GiftPartitionCheckDto> response = new Response<GiftPartitionCheckDto>();
        GiftPartitionCheckDto giftPartitionCheckDto = new GiftPartitionCheckDto();
        // 新增和编辑对分区名称的校验区分 当id为null时是新增操作 不为null时是编辑操作
        try {
            if (id != null) {
                // 当为编辑操作时 先通过id查出该条数据的name
                EspAreaInfModel espAreaInfModel = espAreaInfDao.findById(id);
                // 顺序校验
                if (!areaSeq.equals(espAreaInfModel.getAreaSeq())) {
                    Long sortTotal = espAreaInfDao.checkpartitionSort(areaSeq);
                    if (sortTotal != 0) {
                        giftPartitionCheckDto.setSortCheck(false);
                        response.setResult(giftPartitionCheckDto);
                    } else {
                        giftPartitionCheckDto.setSortCheck(true);
                        response.setResult(giftPartitionCheckDto);
                    }
                } else {
                    giftPartitionCheckDto.setSortCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
            } else {
                // 新增时,校验名字是否重复
                Long total = espAreaInfDao.checkGiftpartition(areaName);
                if (total != 0) {
                    giftPartitionCheckDto.setNameCheck(false);
                    response.setResult(giftPartitionCheckDto);
                } else {
                    giftPartitionCheckDto.setNameCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
                // 新增时，校验分区代码是否重复
                Long codeTotal = espAreaInfDao.checkpartitionCode(areaId);
                if (codeTotal != 0) {
                    giftPartitionCheckDto.setCodeCheck(false);
                    response.setResult(giftPartitionCheckDto);
                } else {
                    giftPartitionCheckDto.setCodeCheck(true);
                    response.setResult(giftPartitionCheckDto);
                }
                // 新增时，校验分区排序是否重复
                Long sortTotal = espAreaInfDao.checkpartitionSort(areaSeq);
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
            log.error("select.giftPartition.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("check.partition.error");
        }
        return response;
    }

    /**
     * 判断分区下是否有礼品
     *
     * @param areaId
     * @return
     */
    @Override
    public Response<GiftPartitionCheckDto> checkUsedPartition(String areaId) {
        Response<GiftPartitionCheckDto> response = new Response<GiftPartitionCheckDto>();
        GiftPartitionCheckDto giftPartitionCheckDto = new GiftPartitionCheckDto();
        try {
            Long total = goodsDao.checkUsedPartition(areaId);
            if (total != 0) {
                giftPartitionCheckDto.setRegionTypeCheck(false);
                response.setResult(giftPartitionCheckDto);
            } else {
                giftPartitionCheckDto.setRegionTypeCheck(true);
                response.setResult(giftPartitionCheckDto);
            }
        } catch (Exception e) {
            log.error("select.giftPartition.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("check.gift.of.partition.error");
        }
        return response;
    }

    /**
     * 分区查询
     *
     * @return
     */
    @Override
    public Response<List<PresentRegionDto>> findAll() {
        Response<List<PresentRegionDto>> response = Response.newResponse();
        try {
            List<PresentRegionDto> presentRegionDtoList = null; //返回 数据

            // 剔除 无效的礼品分区 add by zhoupeng
            Map<String, Object> params = Maps.newHashMapWithExpectedSize(1);
            params.put("curStatus", Contants.PARTITION_STATUS_QY);
            List<EspAreaInfModel> espAreaInfModels = espAreaInfDao.findAreaInfoByParams(params);

            Map<String, TblCfgIntegraltypeModel> intTypeMap;
            if (null != espAreaInfModels && !espAreaInfModels.isEmpty()) {
                List<TblCfgIntegraltypeModel> intTypeModels = tblCfgIntegraltypeDao.findByIds(espAreaInfModels);
                if (null != intTypeModels && !intTypeModels.isEmpty()) {
                    intTypeMap = Maps.newHashMapWithExpectedSize(intTypeModels.size());
                    // 组装 数据
                    intTypeMap.putAll(Maps.uniqueIndex(intTypeModels, new Function<TblCfgIntegraltypeModel, String>() {
                        @NotNull
                        @Override
                        public String apply(@NotNull TblCfgIntegraltypeModel input) {
                            return input.getIntegraltypeId();
                        }
                    }));
                    presentRegionDtoList = Lists.newArrayListWithExpectedSize(espAreaInfModels.size());
                    for (EspAreaInfModel espAreaInfModel : espAreaInfModels) {
                        PresentRegionDto presentRegionDto = new PresentRegionDto();
                        if (!Strings.isNullOrEmpty(espAreaInfModel.getIntegralType())) {
                            TblCfgIntegraltypeModel intTypeModel = intTypeMap.get(espAreaInfModel.getIntegralType());
                            if (intTypeModel != null) {
                                presentRegionDto.setId(espAreaInfModel.getId());
                                presentRegionDto.setName(espAreaInfModel.getAreaName());
                                presentRegionDto.setLimitCards(espAreaInfModel.getFormatId());
                                presentRegionDto.setIntegraltypeId(intTypeModel.getIntegraltypeId());
                                presentRegionDto.setIntegraltypeNm(intTypeModel.getIntegraltypeNm());
                                presentRegionDto.setAreaId(espAreaInfModel.getAreaId());
                                presentRegionDtoList.add(presentRegionDto);
                            }
                        }
                    }
                }
            }
            if (null == presentRegionDtoList || presentRegionDtoList.isEmpty()) {
                response.setResult(Collections.<PresentRegionDto> emptyList());
                return response;
            }
            response.setResult(presentRegionDtoList);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("find  area info  error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("select.giftPartition.error");
            return response;
        }
    }

    /**
     * 根据id查询礼品分区信息
     *
     * @param id
     * @return
     */
    @Override
    public Response<EspAreaInfModel> findById(Long id) {
        Response<EspAreaInfModel> response = Response.newResponse();
        try {
            EspAreaInfModel espAreaInfModel = espAreaInfDao.findById(id);
            response.setResult(espAreaInfModel);
        } catch (Exception e) {
            log.error("find.giftPartition.list.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("find.giftPartition.list.error");
        }
        return response;
    }
}
