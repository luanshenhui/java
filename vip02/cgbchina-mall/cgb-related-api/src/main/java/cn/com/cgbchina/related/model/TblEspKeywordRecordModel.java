package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Map;

public class TblEspKeywordRecordModel implements Serializable {

    private static final long serialVersionUID = -5050528742859507762L;
    @Getter
    @Setter
    private Long id;// 自增主键
    @Getter
    @Setter
    private String keyWords;// 关键字
    @Getter
    @Setter
    private String title;//标题 or 页面标识
    @Getter
    @Setter
    private String desc;  //该该搜索关键字描述信息
    @Getter
    @Setter
    private String path;        //类目url path
    @Getter
    @Setter
    private String friendLinks; //友情链接 json 存储

    @Getter
    @Setter
    private Map<String, String> friendLinkMap; //friendLinks 转成map后的对象，不在DB中存储

    @Getter
    @Setter
    private String ordertypeId;// 业务类型代码yg：广发jf：积分
    @Getter
    @Setter
    private String sourceId;// 搜索渠道代码
    @Getter
    @Setter
    private String createOper;// 创建人
    @Getter
    @Setter
    private java.util.Date createTime;// 创建时间
}