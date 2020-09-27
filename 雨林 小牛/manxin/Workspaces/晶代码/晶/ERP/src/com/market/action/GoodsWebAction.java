package com.market.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.BrandService;
import com.market.service.EmployeeService;
import com.market.service.GoodsService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Brand;
import com.market.vo.Employee;
import com.market.vo.Goods;
import com.market.vo.Stock;
import com.market.vo.StockDetail;
import com.opensymphony.xwork2.ActionSupport;

public class GoodsWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private GoodsService goodsService;

	private BrandService brandService;
	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Stock stock = new Stock();

	private Goods goods = new Goods();

	private Long id;

	private Integer index;

	private List<StockDetail> stockDeatil;

	private EmployeeService employeeService;

	@SuppressWarnings("unchecked")
	public String queryGoods() {
		log.debug("queryGoods" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = goodsService.getCount(goods);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_GOODS, resultSize,
				request);
		List list = goodsService.findPageInfoGoods(goods, pageBean);
		request.setAttribute(Constants.GOODS_LIST, list);
		log.debug("queryGoods" + "结束");
		return Constants.LIST;
	}

	public String selectGoods() {
		log.debug("selectGoods" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = goodsService.getCount(goods);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_GOODS, resultSize,
				request);
		List list = goodsService.findPageInfoGoods(goods, pageBean);
		request.setAttribute(Constants.GOODS_LIST, list);
		log.debug("selectGoods" + "结束");
		return "select_good";
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
	public String toAddGoods() {
		log.debug("toAddGoods" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		request.getSession().setAttribute("stock", stock);
		request.getSession().setAttribute("stockDetail", stockDeatil);
		log.debug("toAddGoods" + "结束");
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
	public String addGoods() {
		log.debug("addGoods" + "开始");
		try {
			HttpServletRequest request = ServletActionContext.getRequest();
			stock = (Stock) request.getSession().getAttribute("stock");
			goodsService.save(goods);
			request.setAttribute("qyzt", DataSource.YHLX);
			Employee queryEmployee = new Employee();
			queryEmployee.setEmployType("采购员");
			List<Employee> employeeList = employeeService.findPageInfoEmployee(
					queryEmployee, null);
			if (employeeList == null) {
				employeeList = new ArrayList();
			}
			request.setAttribute("employeeList", employeeList);
			goods = new Goods();
		} catch (Exception e) {
			log.error("addGoods failed" + goods.toString());
		}
		log.debug("addGoods" + "结束");
		return "stock";
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
	public String delGoods() {
		log.debug("delGoods" + "开始");
		try {
			goods.setId(id);
			goodsService.delete(goods);
		} catch (Exception e) {
			log.error("delGoods failed" + goods.toString());
		}
		log.debug("delGoods" + "结束");
		return queryGoods();
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
	public String toEditGoods() {
		log.debug("toEditGoods" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		goods = goodsService.getGoods(id);
		initSelect(request);
		log.debug("toEditGoods" + "结束");
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
	public String viewGoods() {
		log.debug("viewGoods" + "开始");
		goods = goodsService.getGoods(id);
		log.debug("viewGoods" + "结束");
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
	public String editGoods() {
		log.debug("editGoods" + "开始");
		try {
			goodsService.update(goods);
			goods = new Goods();
		} catch (Exception e) {
			log.error("editGoods failed" + goods.toString());
		}
		log.debug("editGoods" + "结束");
		return queryGoods();
	}

	/**
	 * @param GoodsService
	 *            the GoodsService to set
	 */
	public void setGoodsService(GoodsService goodsService) {
		this.goodsService = goodsService;
	}

	public Goods getGoods() {
		return goods;
	}

	public void setGoods(Goods goods) {
		this.goods = goods;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("splx", DataSource.GOOD_TYPE);
		request.setAttribute("unit", DataSource.GOOD_UNIT);
		Brand queryBrand = new Brand();
		List<Brand> listBrand = brandService
				.findPageInfoBrand(queryBrand, null);
		if (listBrand == null) {
			listBrand = new ArrayList();
		}
		request.setAttribute("pp", listBrand);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

	public BrandService getBrandService() {
		return brandService;
	}

	public void setBrandService(BrandService brandService) {
		this.brandService = brandService;
	}

	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}

	public Stock getStock() {
		return stock;
	}

	public void setStock(Stock stock) {
		this.stock = stock;
	}

	public List<StockDetail> getStockDeatil() {
		return stockDeatil;
	}

	public void setStockDeatil(List<StockDetail> stockDeatil) {
		this.stockDeatil = stockDeatil;
	}

	public EmployeeService getEmployeeService() {
		return employeeService;
	}

	public void setEmployeeService(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}
}
