package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Joiner;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by zhangLin on 2016/12/21.
 */
public class GiftsImportDto implements Serializable {
    private static final long serialVersionUID = 5059549036749435369L;
    @Getter
    @Setter
    private Boolean successFlag;//成功标志
    @Getter
    @Setter
    private GoodsModel goodsModel;//商品信息
    @Getter
    @Setter
    private List<GiftItemDto> itemModel;//单品信息

    public static class GiftItemDto extends ItemModel {
        @Getter
        @Setter
        private int itemRow;//excel中的行数
        @Getter
        @Setter
        private String failReason;//错误信息
    }

    public static class failReason {
        @Getter
        @Setter
        private Boolean successFlag;//成功标志

        private String failReason;//错误信息

        public String getFailReason() {
            return failReason;
        }

        public void setFailReason(String failReason) {
            this.successFlag = false;
            Joiner joiner = Joiner.on(",").skipNulls();
            this.failReason = joiner.join(this.failReason,failReason);
        }
    }
}
