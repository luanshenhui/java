package cn.com.cgbchina.item.model;

import java.io.Serializable;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

public class GoodsOperateDetailModel implements Serializable {

    private static final long serialVersionUID = -2350006261914131640L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String vendorId;//供应商id
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码YG：广发JF：积分
    @Getter
    @Setter
    private Integer operateType;//操作类型：1新增，2编辑信息，3改价，4改库存，5申请下架，6批量导入
    @Getter
    @Setter
    private String goodCode;//商品/单品编码
    @Getter
    @Setter
    private String goodName;//商品/单品名称
    @Getter
    @Setter
    private Long backCategory1Id;//一级后台类目
    @Getter
    @Setter
    private String backCategory1Nm;//一级后台类目名称
    @Getter
    @Setter
    private Long backCategory2Id;//二级后台类目
    @Getter
    @Setter
    private String backCategory2Nm;//二级后台类目名称
    @Getter
    @Setter
    private Long backCategory3Id;//三级后台类目
    @Getter
    @Setter
    private String backCategory3Nm;//三级后台类目名称
    @Getter
    @Setter
    private Long goodsBrandId;//品牌id
    @Getter
    @Setter
    private String goodsBrandName;//品牌名称
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        GoodsOperateDetailModel that = (GoodsOperateDetailModel) o;

        return Objects.equal(this.id, that.id) &&
                Objects.equal(this.vendorId, that.vendorId) &&
                Objects.equal(this.ordertypeId, that.ordertypeId) &&
                Objects.equal(this.operateType, that.operateType) &&
                Objects.equal(this.goodCode, that.goodCode) &&
                Objects.equal(this.goodName, that.goodName) &&
                Objects.equal(this.backCategory1Id, that.backCategory1Id) &&
                Objects.equal(this.backCategory1Nm, that.backCategory1Nm) &&
                Objects.equal(this.backCategory2Id, that.backCategory2Id) &&
                Objects.equal(this.backCategory2Nm, that.backCategory2Nm) &&
                Objects.equal(this.backCategory3Id, that.backCategory3Id) &&
                Objects.equal(this.backCategory3Nm, that.backCategory3Nm) &&
                Objects.equal(this.goodsBrandId, that.goodsBrandId) &&
                Objects.equal(this.goodsBrandName, that.goodsBrandName) &&
                Objects.equal(this.createOper, that.createOper) &&
                Objects.equal(this.createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id, vendorId, ordertypeId, operateType, goodCode, goodName,
                backCategory1Id, backCategory1Nm, backCategory2Id, backCategory2Nm, backCategory3Id,
                backCategory3Nm, goodsBrandId, goodsBrandName, createOper, createTime);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("id", id)
                .add("vendorId", vendorId)
                .add("ordertypeId", ordertypeId)
                .add("operateType", operateType)
                .add("goodCode", goodCode)
                .add("goodName", goodName)
                .add("backCategory1Id", backCategory1Id)
                .add("backCategory1Nm", backCategory1Nm)
                .add("backCategory2Id", backCategory2Id)
                .add("backCategory2Nm", backCategory2Nm)
                .add("backCategory3Id", backCategory3Id)
                .add("backCategory3Nm", backCategory3Nm)
                .add("goodsBrandId", goodsBrandId)
                .add("goodsBrandName", goodsBrandName)
                .add("createOper", createOper)
                .add("createTime", createTime)
                .toString();
    }
}