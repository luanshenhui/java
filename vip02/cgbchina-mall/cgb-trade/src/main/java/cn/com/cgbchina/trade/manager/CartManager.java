package cn.com.cgbchina.trade.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.provider.model.user.CustCarUpdateInfo;
import cn.com.cgbchina.rest.provider.vo.user.CustCarUpdateInfoVO;
import cn.com.cgbchina.trade.dao.CartDao;
import cn.com.cgbchina.trade.dao.TblEspCustCartDao;
import cn.com.cgbchina.trade.model.TblEspCustCartModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.trade.dao.DeadlineModelDao;
import cn.com.cgbchina.trade.model.DeadlineModel;

import java.util.List;
import java.util.Map;

/**
 * Created by 11140721050130 on 2016/4/21.
 */
@Component
@Transactional
public class CartManager {

	@Resource
	private CartDao cartDao;
	@Resource
	private TblEspCustCartDao tblEspCustCartDao;

	/**
	 * 修改操作
	 * @param updateInfo
	 * @author Congzy
	 * @describe 支持批量修改
	 */
	@Transactional(rollbackFor = { Exception.class })
	public Boolean update(List<CustCarUpdateInfo> updateInfo){
		try{
			for(CustCarUpdateInfo custCarUpdateInfo : updateInfo){
				TblEspCustCartModel tblEspCustCartModel = new TblEspCustCartModel();
				tblEspCustCartModel.setId(Long.valueOf(custCarUpdateInfo.getId()));
				tblEspCustCartModel.setGoodsNum(custCarUpdateInfo.getGoodsNum());
				tblEspCustCartDao.update(tblEspCustCartModel);
			}
			return true;
		}catch (Exception e){
			return false;
		}
	}

	/**
	 * 删除操作
	 * @param ids
	 * @return
	 * @author Congzy
	 * @describe 支持批量修改
	 */
	public void delete(List<String> ids){
		tblEspCustCartDao.deleteByIds(ids);
	}

	/**
	 * 插入操作
	 * @param tblEspCustCart
	 * @return
	 */
	public Boolean insert(TblEspCustCartModel tblEspCustCart){
		return tblEspCustCartDao.insert(tblEspCustCart) == 1;
	}
}
