package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.GoodsConsultDao;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11140721050130 on 2016/4/13.
 */

@Component
@Transactional
public class ConsultationManger {

	@Resource
	private GoodsConsultDao goodsConsultDao;

	/**
	 * (批量)更新，商品资讯管理，显示或隐藏
	 *
	 * @param params
	 * @return
	 */
	public boolean updateIsShowByIds(Map<String, Object> params) {
		// 调用接口
		Integer flag = goodsConsultDao.updateIsShowByIds(params);
		if (flag > 0) {
			return true;
		}
		return false;
	}

	/**
	 * 回复功能
	 *
	 * @param params
	 * @return
	 */
	public boolean updateReplyContent(Map<String, Object> params) {
		// 调用接口
		Integer flag = goodsConsultDao.updateReplyContent(params);
		if (flag <= 1) {
			return true;
		}
		return false;
	}

	/**
	 * 添加咨询
	 *
	 * @param goodsConsultModel
	 * @return
	 */
	public boolean insertGoodsConsult(GoodsConsultModel goodsConsultModel) {
		// 调用接口
		Integer flag = goodsConsultDao.insertGoodsConsult(goodsConsultModel);
		if (flag > 0) {
			return true;
		}
		return false;
	}
}
