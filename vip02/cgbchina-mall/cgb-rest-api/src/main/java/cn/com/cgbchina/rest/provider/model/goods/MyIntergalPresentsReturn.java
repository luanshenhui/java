package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL118 适合我的积分礼品查询 返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class MyIntergalPresentsReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 2327448718887774084L;
	private List<MyIntergalPresents> myIntergalPresentses = new ArrayList<MyIntergalPresents>();

	public List<MyIntergalPresents> getMyIntergalPresentses() {
		return myIntergalPresentses;
	}

	public void setMyIntergalPresentses(List<MyIntergalPresents> myIntergalPresentses) {
		this.myIntergalPresentses = myIntergalPresentses;
	}
}
