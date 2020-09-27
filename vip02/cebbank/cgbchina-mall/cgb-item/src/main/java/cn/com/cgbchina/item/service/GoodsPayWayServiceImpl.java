package cn.com.cgbchina.item.service;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import javax.annotation.Resource;
import java.util.Map;

/**
 * @author
 * @version 1.0
 * @Since 2016/7/4.
 */
@Service
@Slf4j
public class GoodsPayWayServiceImpl implements GoodsPayWayService {

	@Resource
	private TblGoodsPaywayDao tblGoodsPayWayDao;


	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfo(String goodsPaywayId) {
		Response<TblGoodsPaywayModel> response = new Response<TblGoodsPaywayModel>();
		try {
			TblGoodsPaywayModel goodsPaywayModel = tblGoodsPayWayDao.findById(goodsPaywayId);
			response.setResult(goodsPaywayModel);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

	/**
	 * 通过单品ＩＤ和分期数查询返回支付方式信息
	 *
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findByItemCodeAndStagesCode(Map<String, Object> params) {
		Response<TblGoodsPaywayModel> response = new Response<TblGoodsPaywayModel>();
		try {
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPayWayDao.findByItemCodeAndStagesCode(params);
			response.setResult(tblGoodsPaywayModel);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

}
