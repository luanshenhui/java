package com.market.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.SalesDetailService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.SalesDetail;
import com.opensymphony.xwork2.ActionSupport;

public class SalesDetailWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private SalesDetailService salesDetailService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private SalesDetail salesDetail = new SalesDetail();

	private Long id;

	@SuppressWarnings("unchecked")
	public String querySalesDetail() {
		log.debug("querySalesDetail" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = salesDetailService.getCount(salesDetail);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_SALESDETAIL,
				resultSize, request);
		List list = salesDetailService.findPageInfoSalesDetail(salesDetail,
				pageBean);
		request.setAttribute(Constants.SALESDETAIL_LIST, list);
		log.debug("querySalesDetail" + "结束");
		return Constants.LIST;
	}

	/**
	 * 
	 * 进入增加界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toAddSalesDetail() {
		log.debug("toAddSalesDetail" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddSalesDetail" + "结束");
		return Constants.ADD;
	}

	/**
	 * 
	 * 增加
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String addSalesDetail() {
		log.debug("addSalesDetail" + "开始");
		try {
			salesDetailService.save(salesDetail);
			salesDetail = new SalesDetail();
		} catch (Exception e) {
			log.error("addSalesDetail failed" + salesDetail.toString());
		}
		log.debug("addSalesDetail" + "结束");
		return querySalesDetail();
	}

	/**
	 * 
	 * 删除
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String delSalesDetail() {
		log.debug("delSalesDetail" + "开始");
		try {
			salesDetail.setId(id);
			salesDetailService.delete(salesDetail);
		} catch (Exception e) {
			log.error("delSalesDetail failed" + salesDetail.toString());
		}
		log.debug("delSalesDetail" + "结束");
		return querySalesDetail();
	}

	/**
	 * 
	 * 进入编辑界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toEditSalesDetail() {
		log.debug("toEditSalesDetail" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		salesDetail = salesDetailService.getSalesDetail(id);
		initSelect(request);
		log.debug("toEditSalesDetail" + "结束");
		return Constants.EDIT;
	}

	/**
	 * 
	 * 查看信息
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String viewSalesDetail() {
		log.debug("viewSalesDetail" + "开始");
		salesDetail = salesDetailService.getSalesDetail(id);
		log.debug("viewSalesDetail" + "结束");
		return Constants.VIEW;
	}

	/**
	 * 
	 * 编辑
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String editSalesDetail() {
		log.debug("editSalesDetail" + "开始");
		try {
			salesDetailService.update(salesDetail);
			salesDetail = new SalesDetail();
		} catch (Exception e) {
			log.error("editSalesDetail failed" + salesDetail.toString());
		}
		log.debug("editSalesDetail" + "结束");
		return querySalesDetail();
	}

	/**
	 * @param SalesDetailService
	 *            the SalesDetailService to set
	 */
	public void setSalesDetailService(SalesDetailService salesDetailService) {
		this.salesDetailService = salesDetailService;
	}

	public SalesDetail getSalesDetail() {
		return salesDetail;
	}

	public void setSalesDetail(SalesDetail salesDetail) {
		this.salesDetail = salesDetail;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("qyzt", DataSource.YHLX);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

}
