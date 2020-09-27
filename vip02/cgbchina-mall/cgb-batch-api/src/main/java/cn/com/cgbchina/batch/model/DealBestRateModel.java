package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by txy on 2016/7/18.
 */
@Getter
@Setter
@ToString
public class DealBestRateModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -8407536526322976845L;
    private String jobName;//作业名

    private String jobParam1;//作业参数1

    private String jobParam2;//作业参数2

    private String jobParam3;//作业参数3

    private String isSuccess;//是否成功

    private java.util.Date runTime;//运行时间

    private String exceptionMsg;//异常信息

    private Long maxPoint;//最大积分数

    private Long singlePoint;//单位积分

    private BigDecimal pointRate;//最高倍率

    private BigDecimal scale;//特殊积分兑换比例

    private String type;//类型  0：供应商 1：品牌 2：类目 3：商品

    private String typeId;//类型ID

    private String itemCode;//单品code

    private String code;//商品code

    private String vendorId;// 供应商id

    private Long goodsBrandId;//品牌ID

    private Long backCategory3Id;//第三级后台类目ID

    private Long spuId;//产品id

    private BigDecimal productPointRate;//单品积分

    private BigDecimal price;//单品实际价格

    private String paramJobName;//作业名(传入参数）

    private String paramJobParam1;//作业参数1(传入参数）

    private String paramIsSuccess;//是否成功（传入参数）
}
