package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class GoodsCommendModel implements Serializable {

    @Getter
    @Setter
    private Long id;//��������
    @Getter
    @Setter
    private String ordertypeId;//ҵ�����ʹ���YG:�㷢�̳�(һ��)JF:�����̳�FQ:�㷢�̳�(����)
    @Getter
    @Setter
    private String commendType;//�Ƽ�����:(�ֹ� 11���������,12����Ʒ����,13���ؼ��Ƽ�,14��������������,90�������Ʒ�Ƽ�);(���� 51����������,52�������Ƽ�)
    @Getter
    @Setter
    private String typeId;//���ʹ��� �ֹ���Ƶ��ID;���֣�����ID
    @Getter
    @Setter
    private String goodsId;//��Ʒ����
    @Getter
    @Setter
    private String goodsPaywayId;//��Ʒ֧������
    @Getter
    @Setter
    private String fixedFlag;//�̶���־ 0�����̶�,1���̶�
    @Getter
    @Setter
    private Integer commendSeq;//��ʾ˳��
    @Getter
    @Setter
    private String commendDesc;//��ע
    @Getter
    @Setter
    private String publishStatus;//����״̬ 00���ѷ���,01���ȴ����,21���ȴ�����
    @Getter
    @Setter
    private Integer delFlag;//�߼�ɾ����� 0��δɾ�� 1����ɾ��
    @Getter
    @Setter
    private String createOper;//������
    @Getter
    @Setter
    private java.util.Date createTime;//����ʱ��
    @Getter
    @Setter
    private String modifyOper;//�޸���
    @Getter
    @Setter
    private java.util.Date modifyTime;//�޸�ʱ��
}