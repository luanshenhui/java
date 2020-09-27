package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.ServicePromiseDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.dto.GoodsExportDto;
import cn.com.cgbchina.item.dto.GoodsInfoDto;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Created by zhangLin on 2016/12/10.
 */
@Slf4j
@Service
public class GoodsExportServiceImpl implements GoodsExportService{
    @Resource
    private ItemDao itemDao;
    @Resource
    private GoodsService goodsService;
    @Resource
    private ServicePromiseDao servicePromiseDao;
    @Resource
    private TblCfgIntegraltypeDao cfgIntegraltypeDao;
    @Resource
    private EspAreaInfDao espAreaInfDao;


    public Response<List<GoodsExportDto>> findGoodsItemsData(Map<String ,String> param, User user,String channel){
        Response<List<GoodsExportDto>> response = Response.newResponse();
        String eitemCode="";
        try {
            // 取出服务承诺表中的数据
            List<ServicePromiseModel> spList = servicePromiseDao.findAllAbled();
            Map<String, ServicePromiseModel> spListMap = Maps.uniqueIndex(spList, new Function<ServicePromiseModel, String>() {
                @Override
                public String apply(ServicePromiseModel input) {
                    return input.getCode().toString();
                }
            });
            //积分类型
            List<TblCfgIntegraltypeModel> pointsTypeList = cfgIntegraltypeDao.findByParams(Collections.<String,Object>emptyMap());
            Map<String,TblCfgIntegraltypeModel> pointsTypeListMap = Maps.uniqueIndex(pointsTypeList, new Function<TblCfgIntegraltypeModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable TblCfgIntegraltypeModel input) {
                    return input.getIntegraltypeId();
                }
            });
            //分区
            List<EspAreaInfModel> regionList = espAreaInfDao.findAreaInfoByParams(Collections.<String,Object>emptyMap());
            Map<String,EspAreaInfModel> regionListMap = Maps.uniqueIndex(regionList, new Function<EspAreaInfModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable EspAreaInfModel input) {
                    return input.getAreaId();
                }
            });

            //防止等待时间过长限制查询1000条
            Response<Map<String, Object>> goodListMapResponse = goodsService.findGoodList(1,1000,channel,user,param);
            List<GoodsInfoDto> goodsModelList = Lists.newArrayList();
            if (goodListMapResponse.isSuccess()){
                Map<String, Object> goodListMap = goodListMapResponse.getResult();
                Pager<GoodsInfoDto> pager = (Pager<GoodsInfoDto>) goodListMap.get("pager");
                goodsModelList = pager.getData();
                if(goodsModelList==null || goodsModelList.size()==0){
                    response.setResult(Collections.<GoodsExportDto>emptyList());
                    return response;
                }
            }else {
                response.setError(goodListMapResponse.getError());
                return response;
            }
            final List<String> goodsCode = Lists.transform(goodsModelList, new Function<GoodsInfoDto, String>() {
                @Override
                public String apply(@NotNull GoodsInfoDto input) {
                    return input.getGoods().getCode();
                }
            });
            List<ItemModel> itemModelList = itemDao.findItemListByGoodsCodeList(goodsCode);
            final Map<String, GoodsInfoDto> goodsMaps = Maps.uniqueIndex(goodsModelList, new Function<GoodsInfoDto, String>() {
                @Override
                public String apply(@NotNull GoodsInfoDto from) {
                    return from.getGoods().getCode();
                }
            });
            List<GoodsExportDto> goodsExportDtoList = Lists.newArrayList();
            for (ItemModel itemModel : itemModelList){
                eitemCode = itemModel.getCode();
                GoodsExportDto goodsExportDto = new GoodsExportDto();
                goodsExportDto.copyItemModel(itemModel);
                GoodsModel goodsModel = goodsMaps.get(itemModel.getGoodsCode()).getGoods();
                goodsExportDto.copyGoodsModel(goodsModel);
                //服务承诺
                String commaString = "";
                if (!Strings.isNullOrEmpty(goodsModel.getServiceType())){
                    String[] serviceType = goodsModel.getServiceType().split(",");
                    for(int i = 0;i<serviceType.length;i++){
                        ServicePromiseModel promiseModel = spListMap.get(serviceType[i]);
                        String promiseName = "";
                        promiseName = promiseModel==null?"":promiseModel.getName();
                        if (i == serviceType.length - 1){
                            commaString = commaString + promiseName;
                        }else {
                            commaString = commaString + promiseName + ",";
                        }
                    }
                }
                goodsExportDto.setServiceType(commaString);
                //积分类型
                if(Contants.BUSINESS_TYPE_JF.equals(channel) && !Strings.isNullOrEmpty(goodsModel.getPointsType())){
                    TblCfgIntegraltypeModel integraltypeModel = pointsTypeListMap.get(goodsModel.getPointsType());
                    goodsExportDto.setPointsType(integraltypeModel==null?"":integraltypeModel.getIntegraltypeNm());
                }
                //分区
                if(Contants.BUSINESS_TYPE_JF.equals(channel) && !Strings.isNullOrEmpty(goodsModel.getRegionType())){
                    EspAreaInfModel areaInfModel = regionListMap.get(goodsModel.getRegionType());
                    goodsExportDto.setRegionType(areaInfModel==null?"":areaInfModel.getAreaName());
                }
                goodsExportDtoList.add(goodsExportDto);
            }
            response.setResult(goodsExportDtoList);
        }catch (Exception e){
            log.error("fail to export goods data,service, cause by{},itemCode={}", Throwables.getStackTraceAsString(e),eitemCode);
            response.setError("goodsExportServicel.error");
        }
        return response;
    }
}
