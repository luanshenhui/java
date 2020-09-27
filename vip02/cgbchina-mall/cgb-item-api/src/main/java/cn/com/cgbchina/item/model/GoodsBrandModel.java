package cn.com.cgbchina.item.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class GoodsBrandModel implements Serializable {

	private static final long serialVersionUID = 7539625558764497304L;
	@Getter
	@Setter
	private Long id;// 自动增长
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	private String goodsBrand;// 品牌代码
	@Getter
	@Setter
	private String brandName;// 品牌名称
	@Getter
	@Setter
	private Integer brandSeq;// 品牌顺序
	@Getter
	@Setter
	private Integer brandState;// 是否首页显示 0否 1是
	@Getter
	@Setter
	private String brandImage;// 品牌图片goods_brand+上传图片的扩展名
	@Getter
	@Setter
	private String brandDesc;// 品牌描述
	@Getter
	@Setter
	private String publishStatus;// 发布状态00已发布01等待审核21等待发布
	@Getter
	@Setter
	private String initial;// 品牌首字母
	@Getter
	@Setter
	private String spell;// 拼音
	@Getter
	@Setter
	private String brandHead;// 品牌头部
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标识0未删除1已删除
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String brandInforStatus;// 审核状态
	@Getter
	@Setter
	private String approverId;// 审核人id
	@Getter
	@Setter
	private String approveMemo;// 审核意见
	@Getter
	@Setter
	private String approveDiff;// 审核数据
	@Getter
	@Setter
	private String brandCategoryId;// 品牌分类类别ID
	@Getter
	@Setter
	private String brandCategoryName;// 品牌分类类别名称


	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		GoodsBrandModel that = (GoodsBrandModel) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.ordertypeId, that.ordertypeId)
				&& Objects.equal(this.goodsBrand, that.goodsBrand) && Objects.equal(this.brandName, that.brandName)
				&& Objects.equal(this.brandSeq, that.brandSeq) && Objects.equal(this.brandState, that.brandState)
				&& Objects.equal(this.brandImage, that.brandImage) && Objects.equal(this.brandDesc, that.brandDesc)
				&& Objects.equal(this.publishStatus, that.publishStatus) && Objects.equal(this.initial, that.initial)
				&& Objects.equal(this.spell, that.spell) && Objects.equal(this.brandHead, that.brandHead)
				&& Objects.equal(this.delFlag, that.delFlag) && Objects.equal(this.createOper, that.createOper)
				&& Objects.equal(this.createTime, that.createTime) && Objects.equal(this.modifyOper, that.modifyOper)
				&& Objects.equal(this.modifyTime, that.modifyTime)
				&& Objects.equal(this.brandInforStatus, that.brandInforStatus)
				&& Objects.equal(this.approverId, that.approverId) && Objects.equal(this.approveMemo, that.approveMemo)
				&& Objects.equal(this.approveDiff, that.approveDiff)
				&& Objects.equal(this.brandCategoryId, that.brandCategoryId)
				&& Objects.equal(this.brandCategoryName, that.brandCategoryName);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, ordertypeId, goodsBrand, brandName, brandSeq, brandState, brandImage, brandDesc,
				publishStatus, initial, spell, brandHead, delFlag, createOper, createTime, modifyOper, modifyTime,
				brandInforStatus, approverId, approveMemo, approveDiff, brandCategoryId, brandCategoryName);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("ordertypeId", ordertypeId).add("goodsBrand", goodsBrand)
				.add("brandName", brandName).add("brandSeq", brandSeq).add("brandState", brandState)
				.add("brandImage", brandImage).add("brandDesc", brandDesc).add("publishStatus", publishStatus)
				.add("initial", initial).add("spell", spell).add("brandHead", brandHead).add("delFlag", delFlag)
				.add("createOper", createOper).add("createTime", createTime).add("modifyOper", modifyOper)
				.add("modifyTime", modifyTime).add("brandInforStatus", brandInforStatus).add("approverId", approverId)
				.add("approveMemo", approveMemo).add("approveDiff", approveDiff)
				.add("brandCategoryId", brandCategoryId).add("brandCategoryName", brandCategoryName).toString();
	}
}