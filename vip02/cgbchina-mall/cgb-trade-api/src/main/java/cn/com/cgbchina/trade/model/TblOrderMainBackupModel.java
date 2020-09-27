package cn.com.cgbchina.trade.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 日期 : 2016年8月13日<br>
 * 作者 : 11150321050126<br>
 * 项目 : cgb-trade-api<br>
 * 功能 : <br>
 */
public class TblOrderMainBackupModel implements Serializable {

	private static final long serialVersionUID = 925635366295911649L;

	@Getter
	@Setter
	private String ordermainId;// '主订单号8位日期+2为渠道代码+6位流水号如：2012032801000001'
	@Getter
	@Setter
	private String ordertypeId;// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
	@Getter
	@Setter
	private String ordertypeNm;// 业务类型名称
	@Getter
	@Setter
	private String cardno;// 卡号
	@Getter
	@Setter
	private String sourceId;// 订单来源渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
	@Getter
	@Setter
	private String sourceNm;// 订单来源渠道名称
	@Getter
	@Setter
	private String source2Id;// 业务渠道代码00: 商城01: callcenter02: ivr渠道03: 手机商城
	@Getter
	@Setter
	private String source2Nm;// 业务渠道名称
	@Getter
	@Setter
	private Integer totalNum;// 商品总数量
	@Getter
	@Setter
	private java.math.BigDecimal totalPrice;// 商品总价格
	@Getter
	@Setter
	private Long totalBonus;// 商品总积分数量
	@Getter
	@Setter
	private java.math.BigDecimal promotDiscount;// 活动优惠总额
	@Getter
	@Setter
	private java.math.BigDecimal bonusDiscount;// 积分抵扣总额
	@Getter
	@Setter
	private java.math.BigDecimal voucherDiscount;// 优惠卷使用总额
	// @Getter
	// @Setter
	// private java.math.BigDecimal paymentAmount;//֧���ܽ��
	@Getter
	@Setter
	private String isInvoice;// 是否开发票0-否，1-是
	@Getter
	@Setter
	private String invoice;// 发票抬头ͷ
	@Getter
	@Setter
	private String invoiceContent;// 发票内容
	@Getter
	@Setter
	private String bpCustGrp;// 送货时间01: 工作日、双休日与假日均可送货02: 只有工作日送货（双休日、假日不用送）03: 只有双休日、假日送货（工作日不用送货）
	@Getter
	@Setter
	private String csgName;// 收货人姓名
	@Getter
	@Setter
	private String csgIdType;// 收货人证件类型
	@Getter
	@Setter
	private String csgIdcard;// 收货人证件号码
	@Getter
	@Setter
	private String csgPostcode;// 收货人邮政编码
	@Getter
	@Setter
	private String csgAddress;// �ջ�����ϸ��ַ
	@Getter
	@Setter
	private String csgPhone1;// �ջ��˵绰һ
	@Getter
	@Setter
	private String csgPhone2;// �ջ��˵绰��
	@Getter
	@Setter
	private String ordermainDesc;// ��������ע
	@Getter
	@Setter
	private java.math.BigDecimal permLimit;// ���ö�ȣ�Ĭ��0��
	@Getter
	@Setter
	private java.math.BigDecimal cashLimit;// ȡ�ֶ�ȣ�Ĭ��0��
	@Getter
	@Setter
	private java.math.BigDecimal stagesLimit;// ���ڶ�ȣ�Ĭ��0��
	@Getter
	@Setter
	private String cardUserid;// �ֿ��˴���
	@Getter
	@Setter
	private String contIdType;// ������֤������
	@Getter
	@Setter
	private String contIdcard;// ������֤������
	@Getter
	@Setter
	private String contNm;// ����������
	@Getter
	@Setter
	private String contNmPy;// ����������ƴ��
	@Getter
	@Setter
	private String contPostcode;// ��������������
	@Getter
	@Setter
	private String contAddress;// ��������ϸ��ַ
	@Getter
	@Setter
	private String contMobPhone;// �������ֻ�
	@Getter
	@Setter
	private String contHphone;// �����˼���绰
	@Getter
	@Setter
	private String expDate;// ��Ч��
	@Getter
	@Setter
	private String foreAccdate;// ���һ���˵���
	@Getter
	@Setter
	private String cardtypeId;// ����������c -�տ�g -��p -�׽�
	@Getter
	@Setter
	private String pdtNbr;// ����
	@Getter
	@Setter
	private String formatId;// ����
	@Getter
	@Setter
	private java.math.BigDecimal totalIncPrice;// ��Ʒ�������Ѽ۸����ã�
	@Getter
	@Setter
	private String stateCode;// ��ǰԭ����루�ϵ�����ϵ����-Ԥ������
	@Getter
	@Setter
	private String stateNm;// ��ǰԭ������
	@Getter
	@Setter
	private String lockedFlag;// ��������ǣ���ס�����������ɹ�����������������˻�����֧�������Ƿ��ظ��������̳ǵı�ʶδ0���-û���յ���֧���ؽ��1-�Ѿ��յ���֧�����ؽ��
	@Getter
	@Setter
	private String curStatusId;// ��ǰ״̬����0301--������0316--����״̬δ��0308--֧���ɹ�0307--֧��ʧ��0305--������0309--�ѷ���0306--����������0310--��ǩ��0312--�ѳ���0304--�ѷϵ�0334--�˻�����0327--�˻��ɹ�0335--�ܾ��˻�����0380--�ܾ�ǩ��0381--����ǩ��0382--��������ʧ��
	@Getter
	@Setter
	private String curStatusNm;// ��ǰ״̬����
	@Getter
	@Setter
	private String createOper;// ��������Աid
	@Getter
	@Setter
	private String modifyOper;// �޸Ĳ���Ա
	@Getter
	@Setter
	private String commDate;// ҵ������
	@Getter
	@Setter
	private String commTime;// ҵ��ʱ��
	@Getter
	@Setter
	private String reserved1;// �����ֶ�
	@Getter
	@Setter
	private String custFlag;// �ͻ���־��δ�ã�
	@Getter
	@Setter
	private String vipFlag;// vip��־��δ�ã�
	@Getter
	@Setter
	private String acctAddFlag;// �ջ���ַ�Ƿ����ʵ���ַ0-��1-��
	@Getter
	@Setter
	private String custSex;// �ͻ��Ա�
	@Getter
	@Setter
	private String psFlag;// �Ƿ��ѽ�����������������ϵͳ0��մ���δ����1������������������ϵͳ
	@Getter
	@Setter
	private String custEmail;// �ͻ�email
	@Getter
	@Setter
	private String custBirthday;// �ͻ�����
	@Getter
	@Setter
	private String expDate2;//
	@Getter
	@Setter
	private Integer versionNum;//
	@Getter
	@Setter
	private String orgCode;//
	@Getter
	@Setter
	private String orgNm;//
	@Getter
	@Setter
	private String orgLevel;//
	@Getter
	@Setter
	private String csgProvince;// ʡ
	@Getter
	@Setter
	private String csgCity;// ��
	@Getter
	@Setter
	private String csgBorough;// ��
	@Getter
	@Setter
	private String acceptedNo;// �����
	@Getter
	@Setter
	private String serialNo;// ��ˮ��
	@Getter
	@Setter
	private String eUpdateStatus;// ����״̬�Ƿ�����ҵ��������
	@Getter
	@Setter
	private String ismerge;//
	@Getter
	@Setter
	private String integraltypeId;// ��������id
	@Getter
	@Setter
	private String defraytype;//
	@Getter
	@Setter
	private String merId;// �̻���
	@Getter
	@Setter
	private String errorCode;// ������
	@Getter
	@Setter
	private String checkStatus;// ���˳ɹ���ʶ
	@Getter
	@Setter
	private String payResultTime;// ֧�����ʱ��
	@Getter
	@Setter
	private String desc1;//
	@Getter
	@Setter
	private String desc2;//
	@Getter
	@Setter
	private String desc3;//
	@Getter
	@Setter
	private String referenceNo;//
	@Getter
	@Setter
	private Integer delFlag;// �߼�ɾ����� 0��δɾ�� 1����ɾ��
	@Getter
	@Setter
	private java.util.Date createTime;// ����ʱ��
	@Getter
	@Setter
	private java.util.Date modifyTime;// ����ʱ��
}