package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL119 猜我喜欢广发商品查询
 * 
 * @author lizy 2016/4/28.
 */
public class MyLoveCGBGoodsQueryReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 4685641889155975412L;
	List<MyLoveCGBGoodsVO> myLoveCGBGoodsList = new ArrayList<MyLoveCGBGoodsVO>();

	public List<MyLoveCGBGoodsVO> getMyLoveCGBGoodsList() {
		return myLoveCGBGoodsList;
	}

	public void setMyLoveCGBGoodsList(List<MyLoveCGBGoodsVO> myLoveCGBGoodsList) {
		this.myLoveCGBGoodsList = myLoveCGBGoodsList;
	}
}
