package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GoodsExportDto;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by zhangLin on 2016/12/12.
 */
public interface GoodsExportService {

    public Response<List<GoodsExportDto>> findGoodsItemsData(Map<String ,String> param, User user,String channel);
}
