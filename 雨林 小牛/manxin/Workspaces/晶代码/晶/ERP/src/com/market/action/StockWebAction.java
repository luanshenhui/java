package com.market.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.EmployeeService;
import com.market.service.GoodsService;
import com.market.service.StockDetailService;
import com.market.service.StockService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Employee;
import com.market.vo.Goods;
import com.market.vo.Stock;
import com.market.vo.StockDetail;
import com.opensymphony.xwork2.ActionSupport;

public class StockWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private StockService stockService;

	private EmployeeService employeeService;

	private List<StockDetail> stockDeatil;

	private StockDetailService stockDetailService;

	private GoodsService goodsService;

	private StockDetail detail = new StockDetail();
	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Stock stock = new Stock();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryStock() {
		log.debug("queryStock" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = stockService.getCount(stock);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_STOCK, resultSize,
				request);
		List list = stockService.findPageInfoStock(stock, pageBean);
		request.setAttribute(Constants.STOCK_LIST, list);
		log.debug("queryStock" + "结束");
		return Constants.LIST;
	}

	public String staticStock() {
		log.debug("staticStock" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();

		List<StockDetail> list = stockDetailService.staticSales(detail);
		request.setAttribute("staticList", list);
		log.debug("staticStock" + "结束");
		return "staticStock";
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
	public String toAddStock() {
		log.debug("toAddStock" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddStock" + "结束");
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
	public String addStock() {
		log.debug("addStock" + "开始");
		try {
			Double total = new Double(0);
			stockService.save(stock);
			if (stockDeatil != null && stockDeatil.size() > 0) {
				for (StockDetail detail : stockDeatil) {
					detail.setStockId(stock.getId());
					total = total + (detail.getNum() * detail.getPrice());
					stockDetailService.save(detail);
					Goods tempGood = goodsService.getGoods(detail.getGoodsId());
					Long num = tempGood.getGoodNum() == null ? new Long(0)
							: tempGood.getGoodNum();
					tempGood.setGoodNum(num
							+ (detail.getNum() == null ? new Long(0) : detail
									.getNum()));
					goodsService.update(tempGood);
				}
			}
			stock.setTotalMoney(total);
			stockService.update(stock);
			stock = new Stock();
		} catch (Exception e) {
			log.error("addStock failed" + stock.toString());
		}
		log.debug("addStock" + "结束");
		return queryStock();
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
	public String delStock() {
		log.debug("delStock" + "开始");
		try {
			stock.setId(id);
			stockService.delete(stock);
		} catch (Exception e) {
			log.error("delStock failed" + stock.toString());
		}
		log.debug("delStock" + "结束");
		return queryStock();
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
	public String toEditStock() {
		log.debug("toEditStock" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		stock = stockService.getStock(id);
		StockDetail stockDetailQuery = new StockDetail();
		stockDetailQuery.setStockId(id);
		List<StockDetail> listDetail = stockDetailService
				.findPageInfoStockDetail(stockDetailQuery, null);
		if (listDetail == null) {
			listDetail = new ArrayList();
		}
		request.setAttribute("listDetail", listDetail);
		initSelect(request);
		log.debug("toEditStock" + "结束");
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
	public String viewStock() {
		log.debug("viewStock" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		stock = stockService.getStock(id);
		StockDetail stockDetailQuery = new StockDetail();
		stockDetailQuery.setStockId(id);
		List<StockDetail> listDetail = stockDetailService
				.findPageInfoStockDetail(stockDetailQuery, null);
		if (listDetail == null) {
			listDetail = new ArrayList();
		}
		request.setAttribute("listDetail", listDetail);
		log.debug("viewStock" + "结束");
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
	public String editStock() {
		log.debug("editStock" + "开始");
		try {
			stockService.update(stock);
			stock = new Stock();
		} catch (Exception e) {
			log.error("editStock failed" + stock.toString());
		}
		log.debug("editStock" + "结束");
		return queryStock();
	}

	/**
	 * @param StockService
	 *            the StockService to set
	 */
	public void setStockService(StockService stockService) {
		this.stockService = stockService;
	}

	public Stock getStock() {
		return stock;
	}

	public void setStock(Stock stock) {
		this.stock = stock;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("qyzt", DataSource.YHLX);
		Employee queryEmployee = new Employee();
		queryEmployee.setEmployType("采购员");
		List<Employee> employeeList = employeeService.findPageInfoEmployee(
				queryEmployee, null);
		if (employeeList == null) {
			employeeList = new ArrayList();
		}
		request.setAttribute("employeeList", employeeList);

	}

	public EmployeeService getEmployeeService() {
		return employeeService;
	}

	public void setEmployeeService(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}

	public List<StockDetail> getStockDeatil() {
		return stockDeatil;
	}

	public void setStockDeatil(List<StockDetail> stockDeatil) {
		this.stockDeatil = stockDeatil;
	}

	public StockDetailService getStockDetailService() {
		return stockDetailService;
	}

	public void setStockDetailService(StockDetailService stockDetailService) {
		this.stockDetailService = stockDetailService;
	}

	public GoodsService getGoodsService() {
		return goodsService;
	}

	public void setGoodsService(GoodsService goodsService) {
		this.goodsService = goodsService;
	}

	public StockDetail getDetail() {
		return detail;
	}

	public void setDetail(StockDetail detail) {
		this.detail = detail;
	}

}
