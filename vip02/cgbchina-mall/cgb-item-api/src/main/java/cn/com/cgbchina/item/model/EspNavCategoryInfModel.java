package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class EspNavCategoryInfModel implements Serializable {

    private static final long serialVersionUID = -3960724992725742206L;
    @Getter
    @Setter
    private Long id;//��������
    @Getter
    @Setter
    private String categoryId;//���ID
    @Getter
    @Setter
    private String parentId;//�������
    @Getter
    @Setter
    private String level;//��𼶱�
    @Getter
    @Setter
    private String categoryName;//�������
    @Getter
    @Setter
    private Integer categorySeq;//��ʾ˳��
    @Getter
    @Setter
    private String forwardType;//��ת����
    @Getter
    @Setter
    private String channelId;//Ƶ������
    @Getter
    @Setter
    private String goodTypeId;//��Ʒ������
    @Getter
    @Setter
    private String linkHref;//���ӵ�ַ
    @Getter
    @Setter
    private String categoryDesc;//��ע
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