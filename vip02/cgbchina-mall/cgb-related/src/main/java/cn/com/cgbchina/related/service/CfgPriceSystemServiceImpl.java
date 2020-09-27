/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import java.util.Map;

import javax.annotation.Resource;

import com.spirit.user.User;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.CfgPriceSystemDao;
import cn.com.cgbchina.related.dao.TblConfigDao;
import cn.com.cgbchina.related.manager.PointsPriceStyleManager;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/8/5.
 */
@Service
@Slf4j
public class CfgPriceSystemServiceImpl implements CfgPriceSystemService {

	@Resource
	private CfgPriceSystemDao cfgPriceSystemDao;
	@Resource
	private PointsPriceStyleManager pointsPriceStyleManager;
	@Resource
	private TblConfigDao tblConfigDao;
	/**
     * 根据体系ID，获取价格体系数据
     * @param priceSystemId 体系ID
     * @return 价格体系数据
     */
    @Override
    public Response<List<CfgPriceSystemModel>> findByPriceSystemId(String priceSystemId) {
        Response<List<CfgPriceSystemModel>> response = Response.newResponse();
        // 校验参数
        if (StringUtils.isEmpty(priceSystemId)) {
            log.error("priceSystemId.is.null");
            response.setError("priceSystemId.is.null");
            return response;
        }
        try{
            // 查询数据
            List<CfgPriceSystemModel> model = cfgPriceSystemDao.findByPriceSystemId(priceSystemId);
            response.setResult(model);
            return response;
        }catch (Exception e){
            log.error("priceSystem.search.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("priceSystem.search.error");
            return response;
        }
    }

	/**
	 * 金普卡积分系数、折扣比例、现金比例分页查询 niufw
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @return
	 */
	@Override
	public Response<Pager<CfgPriceSystemModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("type") String type) {
		Response<Pager<CfgPriceSystemModel>> response = Response.newResponse();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (StringUtils.isNotEmpty(type)) {
			paramMap.put("type", type);
		}
		try {
			Pager<CfgPriceSystemModel> pager = cfgPriceSystemDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("priceSystem.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("priceSystem.time.query.error");
			return response;
		}
	}

	@Override
	public Response<CfgPriceSystemModel> findById(Integer id) {
		Response<CfgPriceSystemModel> response = Response.newResponse();
		try {
			CfgPriceSystemModel cfgPriceSystemModel = cfgPriceSystemDao.findById(id);
			response.setResult(cfgPriceSystemModel);
			return response;
		} catch (Exception e) {
			log.error("priceSystem.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("priceSystem.time.query.error");
			return response;
		}
	}

	/**
	 * 采购价上浮系数查询 niufw
	 *
	 * @return
	 */
	@Override
	public Response<TblConfigModel> findPurchase() {
		Response<TblConfigModel> response = Response.newResponse();

		try {
			String cfgType = "stock_param";
			TblConfigModel tblConfigModel = tblConfigDao.findByCfgType(cfgType);
			response.setResult(tblConfigModel);
			return response;
		} catch (Exception e) {
			log.error("Purchase.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("Purchase.time.query.error");
			return response;
		}
	}

	/**
	 * 价格体系维护-金普卡积分系数-新增 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(CfgPriceSystemModel cfgPriceSystemModel) {
		Response<Boolean> response = Response.newResponse();
		// 校验
		if (cfgPriceSystemModel == null) {
			response.setError("create.priceStyle.error");
			return response;
		}
		try {
			Boolean result = pointsPriceStyleManager.create(cfgPriceSystemModel);
			if (!result) {
				response.setError("create.priceStyle.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("create.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("create.priceStyle.error");
			return response;
		}
	}

	/**
	 * 价格体系维护-编辑 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(CfgPriceSystemModel cfgPriceSystemModel) {
		Response<Boolean> response = Response.newResponse();
		// 校验
		if (cfgPriceSystemModel == null) {
			response.setError("update.priceStyle.error");
			return response;
		}
		try {
			Boolean result = pointsPriceStyleManager.update(cfgPriceSystemModel);
			if (!result) {
				response.setError("update.priceStyle.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("update.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.priceStyle.error");
			return response;
		}
	}

	/**
	 * 价格体系维护--删除 niufw
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Integer id,User user) {
		Response<Boolean> response = Response.newResponse();
		// 校验
		if (id == null) {
			response.setError("delete.priceStyle.error");
			return response;
		}
		CfgPriceSystemModel cfgPriceSystemModel = new CfgPriceSystemModel();
		cfgPriceSystemModel.setId(id);
		cfgPriceSystemModel.setCurStatus(Contants.PRICE_SYSTEM_CUR_STATUS_0101);
		cfgPriceSystemModel.setModifyOper(user.getName());
		try {
			Boolean result = pointsPriceStyleManager.updateForDel(cfgPriceSystemModel);
			if (!result) {
				response.setError("delete.priceStyle.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("delete.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.priceStyle.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("delete.priceStyle.error");
			return response;
		}
	}

	/**
	 * 价格体系维护-采购价上浮系数-编辑 niufw
	 *
	 * @param tblConfigModel
	 * @return
	 */
	@Override
	public Response<Boolean> purchaseUpdate(TblConfigModel tblConfigModel) {
		Response<Boolean> response = Response.newResponse();
		// 校验
		if (tblConfigModel == null) {
			response.setError("update.purchase.error");
			return response;
		}
		try {
			Boolean result = pointsPriceStyleManager.purchaseUpdate(tblConfigModel);
			if (!result) {
				response.setError("update.purchase.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("update.purchase.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.purchase.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.purchase.error");
			return response;
		}
	}
}
