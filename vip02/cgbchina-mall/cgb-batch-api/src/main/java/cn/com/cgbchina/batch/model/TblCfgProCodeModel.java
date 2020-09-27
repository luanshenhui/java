package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblCfgProCodeModel implements Serializable {

    private static final long serialVersionUID = 5829605979406591664L;
    @Getter
    @Setter
    private Integer id;//��������
    @Getter
    @Setter
    private String ordertypeId;//ҵ������
    @Getter
    @Setter
    private String proType;//��������
    @Getter
    @Setter
    private String proCode;//��������
    @Getter
    @Setter
    private Integer proPri;//˳��
    @Getter
    @Setter
    private String proNm;//����/��ͷ��
    @Getter
    @Setter
    private String proDesc;//����
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