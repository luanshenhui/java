package com.market.action;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.StockDetailService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.StockDetail;
import com.opensymphony.xwork2.ActionSupport;

public class StockDetailWebAction extends ActionSupport
{
       
       /**
	 * Service层实例
	 */
	private StockDetailService stockDetailService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

        private StockDetail stockDetail = new StockDetail();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryStockDetail(){
	        log.debug("queryStockDetail" + "开始");
	        HttpServletRequest request = ServletActionContext.getRequest();
                initSelect(request);
		
		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = stockDetailService.getCount(stockDetail);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_STOCKDETAIL, resultSize, request);
                List list = stockDetailService.findPageInfoStockDetail(stockDetail, pageBean);
                request.setAttribute(Constants.STOCKDETAIL_LIST, list);
		log.debug("queryStockDetail" + "结束");
		return Constants.LIST;
	}
        
	/**
	 * 
	 * 进入增加界面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toAddStockDetail(){
		log.debug("toAddStockDetail" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddStockDetail" + "结束");
		return Constants.ADD;
	}
        
	/**
	 * 
	 * 增加
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String addStockDetail(){
		log.debug("addStockDetail" + "开始");
		try{
			stockDetailService.save(stockDetail);
			stockDetail = new StockDetail();
		}catch(Exception e){
			 log.error("addStockDetail failed" + stockDetail.toString());
		}
		log.debug("addStockDetail" + "结束");
		return queryStockDetail();
	}
        
	/**
	 * 
	 * 删除
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String delStockDetail(){
	        log.debug("delStockDetail" + "开始");
		try{
			stockDetail.setId(id);
			stockDetailService.delete(stockDetail);
		}catch(Exception e){
			log.error("delStockDetail failed" + stockDetail.toString());
		}
		log.debug("delStockDetail" + "结束");
		return queryStockDetail();
	}
        
	/**
	 * 
	 * 进入编辑界面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toEditStockDetail(){
		log.debug("toEditStockDetail" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
	        stockDetail = stockDetailService.getStockDetail(id);
		initSelect(request);
		log.debug("toEditStockDetail" + "结束");
		return Constants.EDIT;
	}
        
	/**
	 * 
	 * 查看信息
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String viewStockDetail() {
		log.debug("viewStockDetail" + "开始");
		stockDetail = stockDetailService.getStockDetail(id);
		log.debug("viewStockDetail" + "结束");
		return Constants.VIEW;
	}

	/**
	 * 
	 * 编辑
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String editStockDetail(){
		log.debug("editStockDetail" + "开始");
		try{
			stockDetailService.update(stockDetail);
			stockDetail = new StockDetail();
		}catch(Exception e){
			log.error("editStockDetail failed" + stockDetail.toString());
		}
		log.debug("editStockDetail" + "结束");
		return queryStockDetail();
	}


	/**
	 * @param StockDetailService
	 *  the StockDetailService to set
	 */
	public void setStockDetailService(StockDetailService stockDetailService) {
		this.stockDetailService = stockDetailService;
	}



        public StockDetail getStockDetail() {
		return stockDetail;
	}

	public void setStockDetail(StockDetail stockDetail) {
		this.stockDetail = stockDetail;
	}




	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request){
		request.setAttribute("qyzt",DataSource.YHLX);
//		request.setAttribute("ywfw",DataSource.YWFW);
//		request.setAttribute("jydy",DataSource.JYDY);
//		request.setAttribute("gszt",DataSource.GSZT);
	}


}
