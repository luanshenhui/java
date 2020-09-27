package cn.com.cgbchina.related.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.TblBankModel;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/8/1
 */

public interface BankService {

	/**
	 * 查询所有分行信息
	 * 
	 * @return
	 */
	public Response<Pager<TblBankModel>> findAllBank(@Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 * 更新分行信息/删除单条分行信息
	 * 
	 * @param tblBankModel
	 * @return
	 */
	public Response<Boolean> update(TblBankModel tblBankModel);

	/**
	 * 批量删除分行信息
	 * 
	 * @param list
	 * @return
	 */
	public Response<Integer> deleteBanks(List<Long> list,String userId);

    /**
     * 创建分行信息
     * @param tblBankModel
     * @return
     */
    public Response<Boolean> create(TblBankModel tblBankModel);

	/**
	 * 根据分行ID查询分行信息
	 * @param id
	 * @return
     */
	public Response<TblBankModel> findBankById(Long id);

}
