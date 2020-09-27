package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.PinYinHelper;
import cn.com.cgbchina.item.dao.AuditLoggingDao;
import cn.com.cgbchina.item.dao.BrandAuthorizeDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.model.AuditLoggingModel;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.user.model.OrganiseModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * Created by liuhan on 16-4-14.
 */
@Component
@Transactional
public class BrandManager {
	@Autowired
	private GoodsBrandDao goodsBrandDao;// 品牌表
	@Autowired
	private BrandAuthorizeDao brandAuthorizeDao;// 品牌授权表
	@Autowired
	private AuditLoggingDao auditLoggingDao;// 审核记录

	/**
	 * 添加品牌授权信息
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	public Long create(BrandAuthorizeModel brandAuthorizeModel, User user) {

		Map<String, Object> map = Maps.newHashMap();
		map.put("brandName",brandAuthorizeModel.getBrandName());
		map.put("ordertypeId",brandAuthorizeModel.getOrdertypeId());
		GoodsBrandModel goodsBrand = goodsBrandDao.findBrandIdByName(map);

		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("brandNames", brandAuthorizeModel.getBrandName());
		paramMap.put("vendorId", user.getVendorId());
		Pager<BrandAuthorizeModel> pager = brandAuthorizeDao.findByPageQuery(paramMap, 1, 1);
		if (pager.getTotal() != 0) {
			return 99l;
		}
		if (goodsBrand == null || user.getVendorId() != null) {
			// 添加品牌授权信息
			brandAuthorizeModel.setGoodsBrandId(-1l);
			brandAuthorizeDao.insert(brandAuthorizeModel);
			return 0l;
		} else {
			return 99l;
		}
	}

	/**
	 * 新增品牌信息
	 *
	 * @param goodsBrandModel
	 */
	public void createBrandInfo(GoodsBrandModel goodsBrandModel) {
		GoodsBrandModel goodsBrand = goodsBrandDao.checkBrandName(goodsBrandModel);
		if(goodsBrand == null){
			goodsBrandDao.insert(goodsBrandModel);
		}
	}

	/**
	 * 更新品牌信息
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	public boolean updateBrandInfo(GoodsBrandModel goodsBrandModel) {
		goodsBrandDao.update(goodsBrandModel);
		GoodsBrandModel goodsBrand = goodsBrandDao.findById(goodsBrandModel.getId());
		BrandAuthorizeModel brandAuthorize = new BrandAuthorizeModel();
		brandAuthorize.setBrandName(goodsBrand.getBrandName());
		brandAuthorize.setBrandImage(goodsBrand.getBrandImage());
		brandAuthorize.setGoodsBrandId(goodsBrand.getId());
		brandAuthorize.setModifyOper(goodsBrand.getModifyOper());
		brandAuthorizeDao.updateAll(brandAuthorize);
		if (!goodsBrand.getBrandInforStatus().equals(Contants.BRAND_APPROVE_STATUS_00)) {
			AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
			auditLoggingModel.setOuterId(goodsBrand.getId().toString());
			auditLoggingModel.setAuditor(goodsBrand.getModifyOper());
			auditLoggingModel.setAuditorMemo(goodsBrand.getApproveMemo());
			auditLoggingModel.setBusinessType(Contants.PPSH);
			auditLoggingModel.setCreateOper(goodsBrand.getModifyOper());
			auditLoggingModel.setModifyOper(goodsBrand.getModifyOper());
			if (goodsBrand.getBrandInforStatus().equals(Contants.BRAND_APPROVE_STATUS_01)) {
				auditLoggingModel.setApproveType(Contants.PASS);
			} else {
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			auditLoggingDao.insert(auditLoggingModel);
		}
		return Boolean.TRUE;
	}

	/**
	 * 删除品牌
	 *
	 * @param id
	 */
	public void deleteBrandInfo(Long id) {
		if (brandAuthorizeDao.findIsAuthroizeById(id) == null){
			goodsBrandDao.delete(id);
		}
	}

	/**
	 * 修改品牌/审核通过，拒绝
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	public boolean update(BrandAuthorizeModel brandAuthorizeModel, String orderType) {
		Integer i = brandAuthorizeDao.update(brandAuthorizeModel);
		if (i != 1) {
			return Boolean.FALSE;
		} else {
			// 查询数据刚刚通过或拒绝的一条数据
			BrandAuthorizeModel BrandAuthorize = brandAuthorizeDao.findById(brandAuthorizeModel.getId());

			// 查询品牌名存在不存在
			Map<String, Object> map = Maps.newHashMap();
			map.put("brandName", BrandAuthorize.getBrandName());
			map.put("ordertypeId",BrandAuthorize.getOrdertypeId());
			GoodsBrandModel goodsBrand = goodsBrandDao.findBrandIdByName(map);

			// 审核通过，添加品牌
			if (Contants.BRAND_APPROVE_STATUS_01.equals(BrandAuthorize.getApproveState())) {
				// 不存在的情况下
				if (goodsBrand == null) {
					// 增加品牌表信息
					GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
					goodsBrandModel.setOrdertypeId(BrandAuthorize.getOrdertypeId());// 增加品牌的类型和授权一致
					goodsBrandModel.setBrandName(BrandAuthorize.getBrandName());
					goodsBrandModel.setOrdertypeId(orderType);
					goodsBrandModel.setBrandSeq(0);
					goodsBrandModel.setBrandImage(BrandAuthorize.getBrandImage());
					goodsBrandModel.setPublishStatus("00");
					goodsBrandModel.setInitial(PinYinHelper.getAllFirstSpell(BrandAuthorize.getBrandName()));
					goodsBrandModel.setSpell(PinYinHelper.getPingYin(BrandAuthorize.getBrandName()));
					goodsBrandModel.setDelFlag(Contants.DEL_FLAG_0);
					goodsBrandModel.setCreateOper(BrandAuthorize.getModifyOper());
					goodsBrandModel.setModifyOper(BrandAuthorize.getModifyOper());
					goodsBrandModel.setBrandInforStatus(Contants.BRAND_APPROVE_STATUS_01);
					goodsBrandModel.setApproveMemo(BrandAuthorize.getApproveMemo());
					goodsBrandModel.setApproverId(BrandAuthorize.getModifyOper());
					// 增加品牌表信息
					Long id = goodsBrandDao.insertReturnId(goodsBrandModel);
					// 将刚插入的品牌id重新赋值回品牌授权表（修改全部）
					BrandAuthorizeModel brandAuthorize = new BrandAuthorizeModel();
					//brandAuthorize.setId(brandAuthorizeModel.getId());
					brandAuthorize.setBrandName(goodsBrandModel.getBrandName());
					brandAuthorize.setBrandImage(goodsBrandModel.getBrandImage());
					brandAuthorize.setGoodsBrandId(id);
					brandAuthorize.setModifyOper(BrandAuthorize.getModifyOper());
					//brandAuthorizeDao.update(brandAuthorize);
					brandAuthorizeDao.updateAll(brandAuthorize);
				}else{
					// 将刚插入的品牌id重新赋值回品牌授权表
					BrandAuthorizeModel brandAuthorize = new BrandAuthorizeModel();
					brandAuthorize.setBrandName(goodsBrand.getBrandName());
					brandAuthorize.setBrandImage(goodsBrand.getBrandImage());
					brandAuthorize.setGoodsBrandId(goodsBrand.getId());
					brandAuthorize.setModifyOper(BrandAuthorize.getModifyOper());
					brandAuthorizeDao.updateAll(brandAuthorize);
				}
				// 审核成功，向审核记录表插入数据
				AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
				auditLoggingModel.setOuterId(BrandAuthorize.getId().toString());
				auditLoggingModel.setPresenter(BrandAuthorize.getModifyOper());
				// auditLoggingModel.setPresenterMemo("审核通过");
				auditLoggingModel.setPresenterDatetime(BrandAuthorize.getCreateTime());
				auditLoggingModel.setAuditor(BrandAuthorize.getModifyOper());
				auditLoggingModel.setAuditorMemo(BrandAuthorize.getApproveMemo());
				auditLoggingModel.setAuditorDatetime(BrandAuthorize.getModifyTime());
				auditLoggingModel.setBusinessType(Contants.PPSH);
				auditLoggingModel.setApproveType(Contants.PASS);
				auditLoggingModel.setCreateOper(BrandAuthorize.getModifyOper());
				auditLoggingModel.setModifyOper(BrandAuthorize.getModifyOper());
				auditLoggingDao.insert(auditLoggingModel);

			} else if (Contants.BRAND_APPROVE_STATUS_02.equals(BrandAuthorize.getApproveState())) {
				// 审核拒绝，向审核记录表插入数据
				AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
				auditLoggingModel.setOuterId(BrandAuthorize.getId().toString());
				auditLoggingModel.setPresenter(BrandAuthorize.getModifyOper());
				auditLoggingModel.setPresenterDatetime(BrandAuthorize.getCreateTime());
				auditLoggingModel.setAuditor(BrandAuthorize.getModifyOper());
				auditLoggingModel.setAuditorMemo(BrandAuthorize.getApproveMemo());
				auditLoggingModel.setAuditorDatetime(BrandAuthorize.getModifyTime());
				auditLoggingModel.setBusinessType(Contants.PPSH);
				auditLoggingModel.setApproveType(Contants.REJECT);
				auditLoggingModel.setCreateOper(BrandAuthorize.getModifyOper());
				auditLoggingModel.setModifyOper(BrandAuthorize.getModifyOper());
				auditLoggingDao.insert(auditLoggingModel);
			}
			return Boolean.TRUE;
		}

	}
}
