package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * @author  lizy
 *MAL102 CC积分商城单个礼品的查询对象
 */
public class CCIntergalPresentDetailQueryVO extends BaseQueryEntityVO implements Serializable {
    private static final long serialVersionUID = -3143123673161464156L;
    @NotNull
    private String goodsId;
    @NotNull
    private String origin;
    

    public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}
    
}
