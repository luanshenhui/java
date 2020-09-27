package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 *
 * MAL202	IVR排行列表查询 返回对象
 * @author lizy
 *         2016/4/28.
 */
public class IVRRankListReturnVO extends BaseEntityVO implements Serializable {

    private static final long serialVersionUID = 7302486925397030053L;
    @NotNull
    private	String	channelSN	;
    @NotNull
    private	String	successCode	;
 
    @NotNull
    private	String	loopTag	;
    @NotNull
    private	String	loopCount	;
    private List<IVRRankListGoodsInfoVO> ivrRankListGoodsInfos = new ArrayList<IVRRankListGoodsInfoVO>();

    public String getChannelSN() {
        return channelSN;
    }

    public void setChannelSN(String channelSN) {
        this.channelSN = channelSN;
    }

    public String getSuccessCode() {
        return successCode;
    }

    public void setSuccessCode(String successCode) {
        this.successCode = successCode;
    }
 

    public String getLoopTag() {
        return loopTag;
    }

    public void setLoopTag(String loopTag) {
        this.loopTag = loopTag;
    }

    public String getLoopCount() {
        return loopCount;
    }

    public void setLoopCount(String loopCount) {
        this.loopCount = loopCount;
    }

    public List<IVRRankListGoodsInfoVO> getIvrRankListGoodsInfos() {
        return ivrRankListGoodsInfos;
    }

    public void setIvrRankListGoodsInfos(List<IVRRankListGoodsInfoVO> ivrRankListGoodsInfos) {
        this.ivrRankListGoodsInfos = ivrRankListGoodsInfos;
    }
}
