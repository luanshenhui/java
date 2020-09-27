package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 *
 * MAL202	IVR排行列表查询 返回对象
 * @author lizy
 *         2016/4/28.
 */
public class IVRRankListReturn extends BaseEntity implements Serializable {

    private static final long serialVersionUID = 7302486925397030053L;
    private	String	channelSN	;
    private	String	successCode	;
    private	String	loopTag	;
    private	String	loopCount	;
    private List<IVRRankListGoodsInfo> ivrRankListGoodsInfos = new ArrayList<IVRRankListGoodsInfo>();

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

    public List<IVRRankListGoodsInfo> getIvrRankListGoodsInfos() {
        return ivrRankListGoodsInfos;
    }

    public void setIvrRankListGoodsInfos(List<IVRRankListGoodsInfo> ivrRankListGoodsInfos) {
        this.ivrRankListGoodsInfos = ivrRankListGoodsInfos;
    }
}
