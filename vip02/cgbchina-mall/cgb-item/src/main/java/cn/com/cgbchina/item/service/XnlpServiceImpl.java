package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.XnlpBZBXDao;
import cn.com.cgbchina.item.dao.XnlpCZBXDao;
import cn.com.cgbchina.item.dao.XnlpCZDLDao;
import cn.com.cgbchina.item.dao.XnlpLXSYDao;
import cn.com.cgbchina.item.dao.XnlpZQBXDao;
import cn.com.cgbchina.item.model.XnlpBZBXModel;
import cn.com.cgbchina.item.model.XnlpCZBXModel;
import cn.com.cgbchina.item.model.XnlpCZDLModel;
import cn.com.cgbchina.item.model.XnlpLXSYModel;
import cn.com.cgbchina.item.model.XnlpZQBXModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by shangqinbin on 2016/8/15.
 */
@Service
@Slf4j
public class XnlpServiceImpl implements XnlpService {
    @Resource
    private XnlpZQBXDao xnlpZQBXDao;
    @Resource
    private XnlpBZBXDao xnlpBZBXDao;
    @Resource
    private XnlpCZBXDao xnlpCZBXDao;
    @Resource
    private XnlpCZDLDao xnlpCZDLDao;
    @Resource
    private XnlpLXSYDao xnlpLXSYDao;

    /**
     * 真情类保险
     * @param params
     * @return
     */
    @Override
    public Response<List<XnlpZQBXModel>> selectXnlpZQBX(Map<String, Object> params) {
        Response<List<XnlpZQBXModel>> response = new Response<List<XnlpZQBXModel>>();
        try {
            response.setResult(xnlpZQBXDao.findByNo(params));
        } catch (Exception e) {
            log.error("select XnlpZQBX error{}", Throwables.getStackTraceAsString(e));
            response.setError("select.XnlpZQBX.error");
        }
        return response;
    }

    /**
     * 标准类保险
     *
     * @param params
     * @return
     */
    @Override
    public Response<List<XnlpBZBXModel>> selectXnlpBZBX(Map<String, Object> params) {
        Response<List<XnlpBZBXModel>> response = new Response<List<XnlpBZBXModel>>();
        try {
            response.setResult(xnlpBZBXDao.findByNo(params));
        } catch (Exception e) {
            log.error("select xnlpBZBX error{}", Throwables.getStackTraceAsString(e));
            response.setError("select.xnlpBZBX.error");
        }
        return response;
    }

    /**
     * 车主卡类保险
     *
     * @param params
     * @return
     */
    @Override
    public Response<List<XnlpCZBXModel>> selectXnlpCZBX(Map<String, Object> params) {
        Response<List<XnlpCZBXModel>> response = new Response<List<XnlpCZBXModel>>();
        try {
            response.setResult(xnlpCZBXDao.findByNo(params));
        } catch (Exception e) {
            log.error("select xnlpBZBX error{}", Throwables.getStackTraceAsString(e));
            response.setError("select.xnlpBZBX.error");
        }
        return response;
    }

    /**
     * 道路救援类保险
     *
     * @param params
     * @return
     */
    @Override
    public Response<List<XnlpCZDLModel>> selectXnlpCZDL(Map<String, Object> params) {
        Response<List<XnlpCZDLModel>> response = new Response<List<XnlpCZDLModel>>();
        try {
            response.setResult(xnlpCZDLDao.findByNo(params));
        } catch (Exception e) {
            log.error("select xnlpCZDL error{}", Throwables.getStackTraceAsString(e));
            response.setError("select.xnlpCZDL.error");
        }
        return response;
    }

    /**
     * 留学生旅行意外险
     *
     * @param params
     * @return
     */
    @Override
    public Response<List<XnlpLXSYModel>> selectXnlpLXSY(Map<String, Object> params) {
        Response<List<XnlpLXSYModel>> response = new Response<List<XnlpLXSYModel>>();
        try {
            response.setResult(xnlpLXSYDao.findByNo(params));
        } catch (Exception e) {
            log.error("select xnlpLXSY error{}", Throwables.getStackTraceAsString(e));
            response.setError("select.xnlpLXSY.error");
        }
        return response;
    }
}
