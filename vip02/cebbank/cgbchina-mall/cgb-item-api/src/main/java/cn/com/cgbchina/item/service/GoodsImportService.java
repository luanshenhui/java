package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsExportDto;
import cn.com.cgbchina.item.dto.GoodsImportDto;
import cn.com.cgbchina.item.model.GoodsModel;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/24.
 */

public interface GoodsImportService {

	public Response<List<GoodsImportDto>> importGoodsData(List<GoodsImportDto> details, User user);

	public Response<List<GoodsExportDto>> exportGoodsData(GoodsDetailDto goodsDetailDto);
}
