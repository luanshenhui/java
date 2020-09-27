package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsCommendDto;
import cn.com.cgbchina.item.model.GoodsCommendModel;
import cn.com.cgbchina.item.service.GoodsCommendService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by liuchang on 2016/8/1.
 */

@Controller
@RequestMapping("/api/admin/goodscommend")
@Slf4j
public class GoodsCommend {
    @Autowired
    private MessageSources messageSources;
    @Autowired
    private GoodsCommendService goodsCommendService;

    /**
     * 新增推荐商品信息
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> createGoodsCommend(GoodsCommendModel model) {
        Response<Boolean> result = Response.newResponse();
        try{
            // 业务类型代码YG:广发商城
            model.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
            // 参照旧系统设置为15
            model.setCommendType("15");
            // 固定标志 0：不固定,1：固定
            model.setFixedFlag("1");
            // 发布状态 00：已发布,01：等待审核,21：等待发布
            model.setPublishStatus("01");
            model.setCreateTime(new Date());
            User user = UserUtil.getUser();
            model.setCreateOper(user.getName());
            result = goodsCommendService.createGoodsCommend(model);
            if (result.isSuccess()) {
                return result;
            }else{
                throw new ResponseException(500, messageSources.get(result.getError()));
            }
        }catch (Exception e){
            log.error("failed to create goods commend {},error code:{}", model, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }

    }

    /**
     * 获取推荐商品信息
     */
    @RequestMapping(value = "/find", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<List<GoodsCommendDto>> findGoodsCommendList(String brandId) {
        Response<List<GoodsCommendDto>> result = goodsCommendService.findGoodsCommends(brandId);
        if(result.isSuccess()){
            return result;
        }else{
            log.error("failed to find {},error code:{}", brandId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    /**
     * 删除推荐商品信息
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> deleteGoodsCommend(String id) {
        Response<Boolean> result = Response.newResponse();
        if(StringUtils.isNotEmpty(id)){
            result = goodsCommendService.deleteGoodsCommend(Long.parseLong(id));
        }
        if (result.isSuccess()) {
            return result;
        }else{
            log.error("failed to deleted goods commend {},error code:{}", id, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

}
