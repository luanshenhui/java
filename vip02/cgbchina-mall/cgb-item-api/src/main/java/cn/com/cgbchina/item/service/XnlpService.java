package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.XnlpBZBXModel;
import cn.com.cgbchina.item.model.XnlpCZBXModel;
import cn.com.cgbchina.item.model.XnlpCZDLModel;
import cn.com.cgbchina.item.model.XnlpLXSYModel;
import cn.com.cgbchina.item.model.XnlpZQBXModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by shangqinbin on 2016/8/15.
 */
public interface XnlpService {

    /**
     * 真情类保险
     * @param params
     * @return
     */
    public Response<List<XnlpZQBXModel>> selectXnlpZQBX(Map<String, Object> params);

    /**
     * 标准类保险
     * @param params
     * @return
     */
    public Response<List<XnlpBZBXModel>> selectXnlpBZBX(Map<String, Object> params);

    /**
     * 车主卡类保险
     * @param params
     * @return
     */
    public Response<List<XnlpCZBXModel>> selectXnlpCZBX(Map<String, Object> params);

    /**
     * 道路救援类保险
     * @param params
     * @return
     */
    public Response<List<XnlpCZDLModel>> selectXnlpCZDL(Map<String, Object> params);

    /**
     * 留学生旅行意外险
     * @param params
     * @return
     */
    public Response<List<XnlpLXSYModel>> selectXnlpLXSY(Map<String, Object> params);
}
