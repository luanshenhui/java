package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL119 猜我喜欢广发商品查询
 * 
 * @author lizy 2016/4/28.
 */
public class MyLoveCGBGoodsQueryReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 4685641889155975412L;
	List<MyLoveCGBGoods> myLoveCGBGoodsList = new ArrayList<MyLoveCGBGoods>();

	public List<MyLoveCGBGoods> getMyLoveCGBGoodsList() {
		return myLoveCGBGoodsList;
	}

	public void setMyLoveCGBGoodsList(List<MyLoveCGBGoods> myLoveCGBGoodsList) {
		this.myLoveCGBGoodsList = myLoveCGBGoodsList;
	}
}
