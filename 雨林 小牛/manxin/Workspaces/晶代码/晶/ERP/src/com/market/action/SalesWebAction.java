package com.market.action;

import java.awt.Color;
import java.awt.Font;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.util.ServletContextAware;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.StackedBarRenderer3D;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

import com.market.service.EmployeeService;
import com.market.service.GoodsService;
import com.market.service.SalesDetailService;
import com.market.service.SalesService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Employee;
import com.market.vo.Goods;
import com.market.vo.Sales;
import com.market.vo.SalesDetail;
import com.opensymphony.xwork2.ActionSupport;

public class SalesWebAction extends ActionSupport implements
		ServletContextAware {

	/**
	 * Service层实例
	 */
	private SalesService salesService;

	private SalesDetailService salesDetailService;

	private GoodsService goodsService;
	private EmployeeService employeeService;

	private List<SalesDetail> salesDetail;

	private SalesDetail detail = new SalesDetail();
	private ServletContext context;

	private String picUrl;
	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Sales sales = new Sales();

	private Long id;

	@SuppressWarnings("unchecked")
	public String querySales() {
		log.debug("querySales" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = salesService.getCount(sales);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_SALES, resultSize,
				request);
		List list = salesService.findPageInfoSales(sales, pageBean);
		request.setAttribute(Constants.SALES_LIST, list);
		log.debug("querySales" + "结束");
		return Constants.LIST;
	}

	public String staticSales() {
		log.debug("staticSales" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();

		List<SalesDetail> list = salesDetailService.staticSales(detail);
		request.setAttribute("staticList", list);
		log.debug("staticSales" + "结束");
		return "staticSales";
	}

	public String staticSalesDay() {
		log.debug("staticSalesDay" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		if (detail.getSalesDate() == null) {
			detail.setSalesDate(new Date());
		}
		List<SalesDetail> list = salesDetailService.staticSalesDay(detail);
		request.setAttribute("staticList", list);
		log.debug("staticSalesDay" + "结束");
		return "staticSalesDay";
	}

	public String staticSalesBrand() {
		log.debug("staticSalesBrand" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();

		List<SalesDetail> list = salesDetailService.staticSalesBrand(detail);
		request.setAttribute("staticList", list);
		log.debug("staticSalesBrand" + "结束");
		return "staticSalesBrand";
	}

	public String staticSalesBrandPic() {
		log.debug("staticSalesBrandPic" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		String targetDirectory = context.getRealPath("/tempPic");
		String fileName = String.valueOf(new Date().getTime()) + ".jpg";
		File target = new File(targetDirectory, fileName);
		picUrl = "tempPic/" + fileName;
		List<SalesDetail> list = salesDetailService.staticSalesBrand(detail);
		request.setAttribute("staticList", list);

		JFreeChart chart;
		int width;
		int height;
		chart = getChart(createDataset(list));// bar
		width = 800;
		height = 600;

		try {
			ChartUtilities.saveChartAsJPEG(target, chart, width, height);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*
		 * //存为临时图片，然后输出 String image =
		 * ServletUtilities.saveChartAsPNG(chart,600, 400,
		 * request.getSession()); ServletUtilities.sendTempFile(image,
		 * response); System.out.println("Image:" + image);
		 * System.out.println(System.getProperty("java.io.tmpdir"));
		 */

		log.debug("staticSalesBrandPic" + "结束");
		return "staticSalesBrandPic";
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
	public String toAddSales() {
		log.debug("toAddSales" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddSales" + "结束");
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
	public String addSales() {
		log.debug("addSales" + "开始");
		try {
			HttpServletRequest request = ServletActionContext.getRequest();
			Double total = new Double(0);
			salesService.save(sales);
			if (salesDetail != null && salesDetail.size() > 0) {
				for (SalesDetail detail : salesDetail) {
					detail.setSalesId(sales.getId());
					total = total + (detail.getNum() * detail.getMoney());
					Goods tempGood = goodsService.getGoods(detail.getGoodsId());
					Long num = tempGood.getGoodNum() == null ? new Long(0)
							: tempGood.getGoodNum();
					tempGood.setGoodNum(num
							- (detail.getNum() == null ? new Long(0) : detail
									.getNum()));

					if (tempGood.getGoodNum() < 0) {
						salesService.delete(sales);
						request.setAttribute("messageInfo",
								tempGood.getGoodName() + "库存不足！");
						return toAddSales();
					}
					salesDetailService.save(detail);
					goodsService.update(tempGood);
				}
			}
			sales.setTotalMoney(total);
			salesService.update(sales);
			sales = new Sales();
		} catch (Exception e) {
			log.error("addSales failed" + sales.toString());
		}
		log.debug("addSales" + "结束");
		return querySales();
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
	public String delSales() {
		log.debug("delSales" + "开始");
		try {
			sales.setId(id);
			salesService.delete(sales);
		} catch (Exception e) {
			log.error("delSales failed" + sales.toString());
		}
		log.debug("delSales" + "结束");
		return querySales();
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
	public String toEditSales() {
		log.debug("toEditSales" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		sales = salesService.getSales(id);

		SalesDetail salesDetailQuery = new SalesDetail();
		salesDetailQuery.setSalesId(id);
		List<SalesDetail> listDetail = salesDetailService
				.findPageInfoSalesDetail(salesDetailQuery, null);
		if (listDetail == null) {
			listDetail = new ArrayList();
		}
		request.setAttribute("listDetail", listDetail);

		initSelect(request);
		log.debug("toEditSales" + "结束");
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
	public String viewSales() {
		log.debug("viewSales" + "开始");
		log.debug("toEditSales" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		sales = salesService.getSales(id);
		SalesDetail salesDetailQuery = new SalesDetail();
		salesDetailQuery.setSalesId(id);
		List<SalesDetail> listDetail = salesDetailService
				.findPageInfoSalesDetail(salesDetailQuery, null);
		if (listDetail == null) {
			listDetail = new ArrayList();
		}
		request.setAttribute("listDetail", listDetail);

		log.debug("viewSales" + "结束");
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
	public String editSales() {
		log.debug("editSales" + "开始");
		try {
			salesService.update(sales);
			sales = new Sales();
		} catch (Exception e) {
			log.error("editSales failed" + sales.toString());
		}
		log.debug("editSales" + "结束");
		return querySales();
	}

	/**
	 * @param SalesService
	 *            the SalesService to set
	 */
	public void setSalesService(SalesService salesService) {
		this.salesService = salesService;
	}

	public Sales getSales() {
		return sales;
	}

	public void setSales(Sales sales) {
		this.sales = sales;
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
		queryEmployee.setEmployType("销售员");
		List<Employee> employeeList = employeeService.findPageInfoEmployee(
				queryEmployee, null);
		if (employeeList == null) {
			employeeList = new ArrayList();
		}
		request.setAttribute("employeeList", employeeList);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

	public EmployeeService getEmployeeService() {
		return employeeService;
	}

	public void setEmployeeService(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}

	public List<SalesDetail> getSalesDetail() {
		return salesDetail;
	}

	public void setSalesDetail(List<SalesDetail> salesDetail) {
		this.salesDetail = salesDetail;
	}

	public SalesDetailService getSalesDetailService() {
		return salesDetailService;
	}

	public void setSalesDetailService(SalesDetailService salesDetailService) {
		this.salesDetailService = salesDetailService;
	}

	public GoodsService getGoodsService() {
		return goodsService;
	}

	public void setGoodsService(GoodsService goodsService) {
		this.goodsService = goodsService;
	}

	public SalesDetail getDetail() {
		return detail;
	}

	public void setDetail(SalesDetail detail) {
		this.detail = detail;
	}

	private static CategoryDataset createDataset(List<SalesDetail> list) {
		DefaultCategoryDataset dcd = new DefaultCategoryDataset();
		if (list != null && list.size() > 0) {
			for (SalesDetail salesDetail : list) {
				dcd.addValue(salesDetail.getNum(), "品牌名称",
						salesDetail.getBrand());
			}
		}

		return dcd;
	}

	/**
	 * default getChart() method using default dataset
	 * 
	 * @return
	 */
	public static JFreeChart getChart(List<SalesDetail> list) {
		return getChart(createDataset(list));
	}

	public static JFreeChart getChart(CategoryDataset cd) {
		JFreeChart chart = ChartFactory.createBarChart3D("", "品牌", "数量", cd,
				PlotOrientation.VERTICAL, true, true, false);

		/* 不设置字体，汉字会乱码 */
		Font font = new Font("宋体", Font.BOLD, 20);
		chart.setTitle(new TextTitle("品牌分析图", font));
		chart.getTitle().setFont(font);
		chart.getLegend().setItemFont(font);

		CategoryPlot plot = (CategoryPlot) chart.getPlot();
		CategoryAxis categoryAxis = plot.getDomainAxis();
		categoryAxis.setLabelFont(font);
		categoryAxis.setTickLabelFont(font);

		ValueAxis valueAxis = plot.getRangeAxis();
		valueAxis.setLabelFont(font);

		categoryAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);

		StackedBarRenderer3D renderer = new StackedBarRenderer3D();

		renderer.setSeriesPaint(0, new Color(153, 153, 255));
		renderer.setSeriesPaint(1, new Color(204, 255, 255));
		renderer.setSeriesPaint(2, Color.GREEN);

		renderer.setItemLabelGenerator(new StandardCategoryItemLabelGenerator());
		renderer.setItemLabelFont(new Font("黑体", Font.PLAIN, 12));
		renderer.setItemLabelsVisible(true);

		plot.setRenderer(renderer);

		return chart;
	}

	public ServletContext getContext() {
		return context;
	}

	public void setContext(ServletContext context) {
		this.context = context;
	}

	public void setServletContext(ServletContext context) {
		this.context = context;

	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

}
