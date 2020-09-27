package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GiftPartitionCheckDto;
import cn.com.cgbchina.item.model.GiftPartitionModel;
import cn.com.cgbchina.item.model.GoodsRegionModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.service.GiftPartitionService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Created by tongxueying on 16-6-25.
 */
@Controller
@RequestMapping("/api/admin/giftPartition")
@Slf4j
public class GiftPartition {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
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
        List<TblCfgIntegraltypeModel> tblCfgIntegraltypeModeol = Lists.newArrayList();
        Response<List<TblCfgIntegraltypeModel>> pointsTypeNameList = giftPartitionService.findPointsTypeName();
        if (pointsTypeNameList.isSuccess()) {
            return pointsTypeNameList.getResult();
        }
        log.error("failed to find pointsTypeName {},error code:{}");
        throw new ResponseException(500, messageSources.get(pointsTypeNameList.getError()));
    }

    /**
     * 新增礼品分区信息
     *
     * @param goodsRegionModel
     * @return
     */
    @RequestMapping(value = "/create", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean createBrand(GoodsRegionModel goodsRegionModel) {
        User user = UserUtil.getUser();
        goodsRegionModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 删除标识0
        goodsRegionModel.setCode(goodsRegionModel.getCode());//礼品分区代码
        goodsRegionModel.setName(goodsRegionModel.getName());//礼品分区名称
        goodsRegionModel.setPointsType(goodsRegionModel.getPointsType());//积分类型id
        goodsRegionModel.setLimitCards(goodsRegionModel.getLimitCards());// 第三级卡产品编码
        goodsRegionModel.setStatus(Contants.PARTITION_STATUS_TY);// 分区当前状态，默认未启用:1
        goodsRegionModel.setPublishStatus(Contants.PARTITION_PUBLISH_STATUS_0);//发布状态默认未发布:0
        goodsRegionModel.setMemo(goodsRegionModel.getMemo());// 备注
        goodsRegionModel.setCreateOper(user.getName());// 创建人
        goodsRegionModel.setModifyOper(user.getName());// 修改人
        Response<Boolean> result = giftPartitionService.createPartition(goodsRegionModel);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("insert.error，erro:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 编辑礼品分区信息
     *
     * @param goodsRegionModel
     * @return
     */
    @RequestMapping(value = "/updatePartition", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean update(GoodsRegionModel goodsRegionModel) {

        // 获取用户信息
        User user = UserUtil.getUser();
        goodsRegionModel.setModifyOper(user.getName());//修改人信息
        goodsRegionModel.setPointsType(goodsRegionModel.getPointsType());//积分类型信息
        if (!StringUtils.isEmpty(goodsRegionModel.getStatus())) {
            goodsRegionModel.setStatus(goodsRegionModel.getStatus());//启用状态
        }
        goodsRegionModel.setLimitCards(goodsRegionModel.getLimitCards());//第三级卡产品编码
        goodsRegionModel.setSort(goodsRegionModel.getSort());//显示顺序
        goodsRegionModel.setMemo(goodsRegionModel.getMemo());//分区备注
        Response<Boolean> result = giftPartitionService.updatePartition(goodsRegionModel);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("update.error，erro:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));

    }

    /**
     * 删除礼品分区
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> delete(@PathVariable Integer id) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            // 获取用户信息
            User user = UserUtil.getUser();
            GoodsRegionModel goodsRegionModel = new GoodsRegionModel();
            goodsRegionModel.setModifyOper(user.getName());//修改人信息
            goodsRegionModel.setId(Long.valueOf(id));
            result = giftPartitionService.delete(goodsRegionModel);
        } catch (IllegalArgumentException e) {
            log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
        return result;
    }

    /**
     * 礼品分区重复校验
     *
     * @param name
     * @return
     */
    @RequestMapping(value = "/checkGiftPartition", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftPartitionCheckDto checkGiftPartition(String name, String code, Long id, Integer sort) {
        Response<GiftPartitionCheckDto> result = giftPartitionService.checkGiftpartition(code, name, id, sort);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("check.error，erro:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 判断分区下是否有礼品
     * @param code
     * @return
     */
    @RequestMapping(value = "/checkUsedPartition", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftPartitionCheckDto checkUsedPartition(@RequestParam(value = "code", required = true) String code){
        Response<GiftPartitionCheckDto> result = giftPartitionService.checkUsedPartition(code);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("check.error，erro:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }
}
