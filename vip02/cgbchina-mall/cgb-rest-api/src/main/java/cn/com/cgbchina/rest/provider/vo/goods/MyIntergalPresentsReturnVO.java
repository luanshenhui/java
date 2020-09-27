package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL118 适合我的积分礼品查询 返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class MyIntergalPresentsReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 2327448718887774084L;
	private List<MyIntergalPresentsVO> myIntergalPresentses = new ArrayList<MyIntergalPresentsVO>();

	public List<MyIntergalPresentsVO> getMyIntergalPresentses() {
		return myIntergalPresentses;
	}

	public void setMyIntergalPresentses(List<MyIntergalPresentsVO> myIntergalPresentses) {
		this.myIntergalPresentses = myIntergalPresentses;
	}
}
