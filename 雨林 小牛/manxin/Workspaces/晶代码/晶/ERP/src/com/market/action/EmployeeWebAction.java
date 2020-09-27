package com.market.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.EmployeeService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Employee;
import com.opensymphony.xwork2.ActionSupport;

public class EmployeeWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private EmployeeService employeeService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Employee employee = new Employee();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryEmployee() {
		log.debug("queryEmployee" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = employeeService.getCount(employee);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_EMPLOYEE,
				resultSize, request);
		List list = employeeService.findPageInfoEmployee(employee, pageBean);
		request.setAttribute(Constants.EMPLOYEE_LIST, list);
		log.debug("queryEmployee" + "结束");
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
	public String toAddEmployee() {
		log.debug("toAddEmployee" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddEmployee" + "结束");
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
	public String addEmployee() {
		log.debug("addEmployee" + "开始");
		try {
			employeeService.save(employee);
			employee = new Employee();
		} catch (Exception e) {
			log.error("addEmployee failed" + employee.toString());
		}
		log.debug("addEmployee" + "结束");
		return queryEmployee();
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
	public String delEmployee() {
		log.debug("delEmployee" + "开始");
		try {
			employee.setId(id);
			employeeService.delete(employee);
		} catch (Exception e) {
			log.error("delEmployee failed" + employee.toString());
		}
		log.debug("delEmployee" + "结束");
		return queryEmployee();
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
	public String toEditEmployee() {
		log.debug("toEditEmployee" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		employee = employeeService.getEmployee(id);
		initSelect(request);
		log.debug("toEditEmployee" + "结束");
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
	public String viewEmployee() {
		log.debug("viewEmployee" + "开始");
		employee = employeeService.getEmployee(id);
		log.debug("viewEmployee" + "结束");
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
	public String editEmployee() {
		log.debug("editEmployee" + "开始");
		try {
			employeeService.update(employee);
			employee = new Employee();
		} catch (Exception e) {
			log.error("editEmployee failed" + employee.toString());
		}
		log.debug("editEmployee" + "结束");
		return queryEmployee();
	}

	/**
	 * @param EmployeeService
	 *            the EmployeeService to set
	 */
	public void setEmployeeService(EmployeeService employeeService) {
		this.employeeService = employeeService;
	}

	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("yglx", DataSource.YGLX);
		request.setAttribute("sex", DataSource.SEX);

	}

}
