package cn.com.cgbchina.related.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import com.spirit.user.User;

import java.util.List;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/8/5.
 */

public interface CfgPriceSystemService {

    /**
     * 根据体系ID，获取价格体系数据
     * @param priceSystemId 体系ID
     * @return 价格体系数据
     */
    public Response<List<CfgPriceSystemModel>> findByPriceSystemId(String priceSystemId);

	/**
	 * 金普卡积分系数、折扣比例、现金比例分页查询 niufw
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @return
	 */
	public Response<Pager<CfgPriceSystemModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("type") String type);

	/**
	 * 根据id查询金普卡积分系数或折扣比例或现金比例
	 *
	 * @param id
	 * @return
	 */
	public Response<CfgPriceSystemModel> findById(Integer id);

	/**
	 * 采购价上浮系数查询 niufw
	 *
	 * @return
	 */
	public Response<TblConfigModel> findPurchase();

	/**
	 * 价格体系维护-金普卡积分系数-新增 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	public Response<Boolean> create(CfgPriceSystemModel cfgPriceSystemModel);

	/**
	 * 价格体系维护-金普卡积分系数-编辑 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	public Response<Boolean> update(CfgPriceSystemModel cfgPriceSystemModel);

	/**
	 * 价格体系维护--删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> delete(Integer id, User user);

	/**
	 * 价格体系维护-采购价上浮系数-编辑 niufw
	 *
	 * @param tblConfigModel
	 * @return
	 */
	public Response<Boolean> purchaseUpdate(TblConfigModel tblConfigModel);

}
