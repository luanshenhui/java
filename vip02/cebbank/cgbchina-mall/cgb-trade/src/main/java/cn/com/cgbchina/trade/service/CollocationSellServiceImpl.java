package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.CollocationSell;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 张成 on 16-4-11.
 */
@Slf4j
@Service
public class CollocationSellServiceImpl implements CollocationSellService {

	@Resource
	private OrderSubDao orderSubDao;

	@Override
	public Response<Pager<CollocationSell>> findCollocationAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size) {

		Response<Pager<CollocationSell>> response = new Response<Pager<CollocationSell>>();

		PageInfo pageInfo = new PageInfo(pageNo, size);

		Map<String, Object> paramMap = Maps.newHashMap();

		// try {
		// //根据商品名称模糊查询，判断是否有这件商品，然后根据查出来的ID，在到consult表查询
		// List<String> codeList = null;
		// //List<GoodsConsultModel> goodsConsultModelList = new ArrayList<GoodsConsultModel>();
		//
		//// if (StringUtils.isNotEmpty(goodsName)) {
		//// codeList = goodsDao.findGoodsByGoodsName(goodsName);
		//// if (codeList.size() == 0) {
		//// response.setResult(new Pager<GoodsConsultModel>(0L, Collections.<GoodsConsultModel>emptyList()));
		//// return response;
		//// } else {
		//// //放到map里，当查询条件
		//// paramMap.put("goodsCode", codeList);
		//// }
		//// }
		//
		// Pager<OrderSubModel> collocationList = orderSubDao.findCollocationByPage(paramMap, pageInfo.getOffset(),
		// pageInfo.getLimit());
		//
		// //循环，把商品名称放到model里
		// for (OrderSubModel orderSubModel : collocationList.getData()) {
		// OrderSubModel osModel = new OrderSubModel();
		// GoodsModel goodsModel = goodsDao.findDetailById(goodsConsultModel.getGoodsCode());
		// Response<VendorInfoDto> vendorInfoModel = vendorService.findById(goodsConsultModel.getVendorId());
		// osModel.setId(goodsConsultModel.getId()); //ID
		// osModel.setGoodsCode(goodsModel.getName()); //名称
		// osModel.setVendorId(vendorInfoModel.getResult().getFullName());
		// osModel.setAdviceContent(goodsConsultModel.getAdviceContent()); // 咨询内容
		// osModel.setAdviceDatetime(goodsConsultModel.getAdviceDatetime());//咨询时间
		// osModel.setReplyContent(goodsConsultModel.getReplyContent());
		// osModel.setReplyDatetime(goodsConsultModel.getReplyDatetime());
		// osModel.setIsShow(goodsConsultModel.getIsShow()); //咨询状态
		// goodsConsultModelList.add(osModel);
		// }
		//
		// Pager<CollocationSell> pager = new Pager<CollocationSell>(goodsConsultList.getTotal(),
		// goodsConsultModelList);
		// response.setResult(pager);
		// return response;
		//
		// } catch (Exception e) {
		// log.error("goods.consult.query.error", Throwables.getStackTraceAsString(e));
		// response.setError("goods.consult.query.error");
		// return response;
		// }
		return null;
	}

	@Override
	public Response<Boolean> delete(CollocationSell collocationSell) {
		Response<Boolean> response = new Response<Boolean>();
		// for (int i = 0; i < collocationSells.size(); i++) {
		// if (collocationSells.get(i).getId().equals(collocationSell.getId())) {
		// collocationSells.remove(i);
		// break;
		// }
		// }
		// collocationSells.remove(collocationSell);
		// response.setSuccess(Boolean.TRUE);
		// response.setResult(Boolean.TRUE);
		return response;
	}
}
