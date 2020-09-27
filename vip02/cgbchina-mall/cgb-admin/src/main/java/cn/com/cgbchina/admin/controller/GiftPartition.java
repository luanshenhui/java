package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.service.GiftPartitionService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by tongxueying on 16-6-25.
 */
@Controller
@RequestMapping("/api/admin/giftPartition")
@Slf4j
public class GiftPartition {
    @Resource
    private MessageSources messageSources;
    @Resource
    private GiftPartitionService giftPartitionService;

    /**
     * 积分类型名称查询
     *
     * @return
     */
    @RequestMapping(value = "/findPointsTypeName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<TblCfgIntegraltypeModel> findPointsTypeName() {
        Response<List<TblCfgIntegraltypeModel>> pointsTypeNameList = giftPartitionService.findPointsTypeName();
        if (pointsTypeNameList.isSuccess()) {
            return pointsTypeNameList.getResult();
        }
        log.error("failed to find pointsTypeName {},error code:{}",pointsTypeNameList, pointsTypeNameList.getError());
        throw new ResponseException(500, messageSources.get(pointsTypeNameList.getError()));
    }

    /**
     * 新增礼品分区信息
     *
     * @param espAreaInfModel
     * @return
     */
    @RequestMapping(value = "/create", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean create(EspAreaInfModel espAreaInfModel) {
        User user = UserUtil.getUser();
        espAreaInfModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 删除标识0
        espAreaInfModel.setAreaId(espAreaInfModel.getAreaId());//礼品分区代码
        espAreaInfModel.setAreaName(espAreaInfModel.getAreaName());//礼品分区名称
        espAreaInfModel.setAreaType("03");//分区类型
        espAreaInfModel.setOrdertypeId("JF");//业务类型代码YG：广发JF：积分
        espAreaInfModel.setIntegralType(espAreaInfModel.getIntegralType());//积分类型id
        espAreaInfModel.setFormatId(espAreaInfModel.getFormatId());// 第三级卡产品编码
        espAreaInfModel.setCurStatus(Contants.PARTITION_STATUS_TY);// 分区当前状态，默认未启用:1
        espAreaInfModel.setPublishStatus(Contants.PARTITION_PUBLISH_STATUS_1);//发布状态默认为：等待审核:01
        espAreaInfModel.setGoodsType("");
        espAreaInfModel.setAreaDesc(espAreaInfModel.getAreaDesc());// 备注
        espAreaInfModel.setCreateOper(user.getName());// 创建人
        espAreaInfModel.setModifyOper(user.getName());// 修改人
        Response<Boolean> result = giftPartitionService.createPartition(espAreaInfModel);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("insert.error，error:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 编辑礼品分区信息
     *
     * @param espAreaInfModel
     * @return
     */
    @RequestMapping(value = "/updatePartition", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean update(EspAreaInfModel espAreaInfModel) {
        //对应305770 删除和启用同时操作导致启用的数据被删除 niufw
        Response<EspAreaInfModel> response = giftPartitionService.findById(espAreaInfModel.getId());
        EspAreaInfModel espAreaInf = response.getResult();
        //如果已经被删除，则不执行更新操作
        if(espAreaInf == null){
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("this.giftPartition.delete"));
        }
        // 获取用户信息
        User user = UserUtil.getUser();
        espAreaInfModel.setModifyOper(user.getName());//修改人信息
        espAreaInfModel.setIntegralType(espAreaInfModel.getIntegralType());//积分类型信息
        if (!StringUtils.isEmpty(espAreaInfModel.getAreaType())) {
            espAreaInfModel.setAreaType(espAreaInfModel.getAreaType());//分区类别
        }
        espAreaInfModel.setFormatId(espAreaInfModel.getFormatId());//第三级卡产品编码
        espAreaInfModel.setAreaSeq(espAreaInfModel.getAreaSeq());//显示顺序
        espAreaInfModel.setAreaDesc(espAreaInfModel.getAreaDesc());//分区备注
        Response<Boolean> result = giftPartitionService.updatePartition(espAreaInfModel);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("update.error，error:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));

    }

    /**
     * 删除礼品分区
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> delete(@PathVariable Integer id) {
        //对应305770 删除和启用同时操作导致启用的数据被删除 niufw
        Response<EspAreaInfModel> response = giftPartitionService.findById(Long.valueOf(id));
        EspAreaInfModel espAreaInf = response.getResult();
        //如果已经被更新为启用，则不执行删除操作
        if(Contants.PARTITION_STATUS_QY.equals(espAreaInf.getCurStatus())){
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("this.giftPartition.QY"));
        }
        // 获取用户信息
        User user = UserUtil.getUser();
        EspAreaInfModel espAreaInfModel = new EspAreaInfModel();
        espAreaInfModel.setModifyOper(user.getName());//修改人信息
        espAreaInfModel.setId(Long.valueOf(id));
        Response<Boolean> result = giftPartitionService.delete(espAreaInfModel);
        if (result.isSuccess()) {
            return result;
        }
        log.error("delete.error，error:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 礼品分区重复校验
     *
     * @return
     */
    @RequestMapping(value = "/checkGiftPartition", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftPartitionCheckDto checkGiftPartition(String areaId, String areaName, Long id, Integer areaSeq) {
        Response<GiftPartitionCheckDto> result = giftPartitionService.checkGiftpartition(areaId,areaName, id, areaSeq);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("check.error，error:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 判断分区下是否有礼品
     * @param areaId
     * @return
     */
    @RequestMapping(value = "/checkUsedPartition", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftPartitionCheckDto checkUsedPartition(@RequestParam(value = "areaId", required = true) String areaId){
        Response<GiftPartitionCheckDto> result = giftPartitionService.checkUsedPartition(areaId);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("check.error，error:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }
}
