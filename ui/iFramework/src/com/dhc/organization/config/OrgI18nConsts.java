package com.dhc.organization.config;

import com.dhc.base.common.util.PropertiesUtil;

public final class OrgI18nConsts {
	// common
	// common.exception.unknown=未知异常
	public static final String EXCEPTION_UNKNOWN = PropertiesUtil.getMessage("common.exception.unknown");
	// common.exception.dbaccess=数据库访问异常
	public static final String EXCEPTION_DBACCESS = PropertiesUtil.getMessage("common.exception.dbaccess");
	// common.exception.data_in_use_cant_delete=数据已被使用，无法删除
	public static final String EXCEPTION_DATA_IN_USE = PropertiesUtil
			.getMessage("common.exception.data_in_use_cant_delete");
	// 表格的序号列名称
	public static final String TABLE_COLUMN_SEQUENCE = PropertiesUtil.getMessage("common.table.title.seq");
	// common.title.message_box=消息框
	public static final String MESSAGE_BOX = PropertiesUtil.getMessage("common.title.message_box");
	// common.title.confirm_box=确认框
	public static final String CONFIRM_BOX = PropertiesUtil.getMessage("common.title.confirm_box");
	// role.title.role_detail=角色详细信息
	public static final String ROLE_DETAIL = PropertiesUtil.getMessage("role.title.role_detail");
	//// role.title.role_select= 角色选择
	public static final String ROLE_ROLE_SELECT = PropertiesUtil.getMessage("role.title.role_select");
	// role.title.biz_role_select=业务角色选择
	public static final String ROLE_BIZROLE_SELECT = PropertiesUtil.getMessage("role.title.biz_role_select");
	// role.title.admin_role_select=管理角色选择
	public static final String ROLE_ADMINROLE_SELECT = PropertiesUtil.getMessage("role.title.admin_role_select");
	// 角色名称
	public static final String ROLE_NAME = PropertiesUtil.getMessage("role.element.rolename");
	// 角色描述
	public static final String ROLE_DESC = PropertiesUtil.getMessage("role.element.roledesc");
	// 管理角色
	public static final String IS_ADMINROLE = PropertiesUtil.getMessage("role.element.mng_role");
	// 请先选择一个角色再修改role.prompt.select_role_to_edit
	public static final String SELECT_ROLE_TO_EDIT = PropertiesUtil.getMessage("role.prompt.select_role_to_edit");
	// adminRole不能删除，请重新选择,role.prompt.adminrole_cant_delete
	public static final String ADMINROLE_CANT_DELETE = PropertiesUtil.getMessage("role.prompt.adminrole_cant_delete");
	// 请选择要删除的角色，role.prompt.select_role_to_delete
	public static final String SELECT_ROLE_TO_DELETE = PropertiesUtil.getMessage("role.prompt.select_role_to_delete");
	// 删除成功，role.prompt.delete_ok
	public static final String DELETE_OK = PropertiesUtil.getMessage("role.prompt.delete_ok");
	// 保存成功，role.prompt.save_ok
	public static final String SAVE_OK = PropertiesUtil.getMessage("role.prompt.save_ok");
	// role.prompt.role_not_exist=角色不存在
	public static final String ROLE_NOT_EXIST = PropertiesUtil.getMessage("role.prompt.role_not_exist");

	// 操作失败，可能是网络原因，org.prompt.net_faild
	public static final String NET_FAILD = PropertiesUtil.getMessage("org.prompt.net_faild");
	// 角色名称必填，小于16位汉字或32个字母，role.prompt.rolename_prompt_info
	public static final String ROLENAME_PROMPT_INFO = PropertiesUtil.getMessage("role.prompt.rolename_prompt_info");
	// 角色描述，小于127位汉字或255个字母，角色描述，小于半角127位或全角255位,role.prompt.roledesc_prompt_info
	public static final String ROLEDESC_PROMPT_INFO = PropertiesUtil.getMessage("role.prompt.roledesc_prompt_info");
	// 最大人数必填，小于10位整数，最大人数必填，小于10位整数,role.prompt.maxusers_prompt_info
	public static final String MAXUSERS_PROMPT_INFO = PropertiesUtil.getMessage("role.prompt.maxusers_prompt_info");
	// role.prompt.must_be_admin_role=非管理角色用户不能建角色
	public static final String MUST_BE_ADMIN_ROLE = PropertiesUtil.getMessage("role.prompt.must_be_admin_role");
	// role.prompt.role_name_aleady_exist=角色名称已存在，请重新输入！
	public static final String ROLE_NAME_ALEADY_EXIST = PropertiesUtil.getMessage("role.prompt.role_name_aleady_exist");
	// role.prompt.role_user_overload=角色的用户数超过上限
	public static final String ROLE_USER_OVERLOAD = PropertiesUtil.getMessage("role.prompt.role_user_overload");

	// stat.title.user_select=用户选择
	public static final String STAT_USER_SELECT = PropertiesUtil.getMessage("stat.title.user_select");
	// stat.title.stat_detail=岗位信息
	public static final String STAT_STAT_DETAIL = PropertiesUtil.getMessage("stat.title.stat_detail");
	// stat.title.stat_mngt=岗位管理
	public static final String STAT_STAT_MNGT = PropertiesUtil.getMessage("stat.title.stat_mngt");
	// stat.prompt.fill_statname=请填写岗位名称
	public static final String STAT_FILL_STATNAME = PropertiesUtil.getMessage("stat.prompt.fill_statname");
	// stat.prompt.stat_long=岗位过长
	public static final String STAT_STAT_LONG = PropertiesUtil.getMessage("stat.prompt.stat_long");
	// stat.prompt.statdesc_long=岗位描述，小于半角127位或全角255位
	public static final String STAT_STATDESC_LONG = PropertiesUtil.getMessage("stat.prompt.statdesc_long");
	// stat.prompt.maxusers_mandatory=最大人数必填
	public static final String STAT_MAXUSERS_MANDATORY = PropertiesUtil.getMessage("stat.prompt.maxusers_mandatory");
	// stat.prompt.number_invalid=请填写数字，小于10位整数
	public static final String STAT_NUMBER_INVALID = PropertiesUtil.getMessage("stat.prompt.number_invalid");
	// stat.prompt.update_ok=修改成功
	public static final String STAT_UPDATE_OK = PropertiesUtil.getMessage("stat.prompt.update_ok");
	// stat.prompt.select_org=请选择组织
	public static final String STAT_SELECT_ORG = PropertiesUtil.getMessage("stat.prompt.select_org");
	// stat.prompt.select_station=请选择岗位
	public static final String STAT_SELECT_STATION = PropertiesUtil.getMessage("stat.prompt.select_station");

	// user.title.user_detail=用户信息
	public static final String USER_DETAIL = PropertiesUtil.getMessage("user.title.user_detail");
	// role.element.username=用户名
	public static final String USER_USERNAME = PropertiesUtil.getMessage("user.element.username");
	// user.element.userdesc=用户描述
	public static final String USER_DESC = PropertiesUtil.getMessage("user.element.userdesc");
	// role.element.account=用户帐户
	public static final String USER_ACCOUNT = PropertiesUtil.getMessage("user.element.useraccount");
	// org.element.org_unit=组织机构
	public static final String USER_UNIT = PropertiesUtil.getMessage("org.element.org_unit");
	// user.element.roles=用户角色
	public static final String USER_ROLES = PropertiesUtil.getMessage("user.element.roles");
	// user.element.lock=锁定
	public static final String USER_LOCK = PropertiesUtil.getMessage("user.element.lock");
	// user.button.adjust_user_privilege=权限调整
	public static final String USER_ADJUST_PRIVILEGE = PropertiesUtil.getMessage("user.button.adjust_user_privilege");
	// user.prompt.username_invalid=用户名必填，小于半角10位或全角20位
	public static final String USER_USERNAME_INVALID = PropertiesUtil.getMessage("user.prompt.username_invalid");
	// user.prompt.password_invalid=密码必填，1-20位字母、数字、下划线
	public static final String USER_PASSWORD_INVALID = PropertiesUtil.getMessage("user.prompt.password_invalid");
	// user.prompt.account_invalid=帐号必填，4-20位字母、数字、下划线
	public static final String USER_ACCOUNT_INVALID = PropertiesUtil.getMessage("user.prompt.account_invalid");
	// user.prompt.userdesc_invalid=用户描述，小于半角127位或全角255位
	public static final String USER_USERDESC_INVALID = PropertiesUtil.getMessage("user.prompt.userdesc_invalid");
	// user.prompt.input_long=输入内容过长
	public static final String USER_INPUT_LONG = PropertiesUtil.getMessage("user.prompt.input_long");
	// user.prompt.select_user_first=请先选择一个用户
	public static final String USER_SELECT_USER_FIRST = PropertiesUtil.getMessage("user.prompt.select_user_first");
	// user.prompt.select_user_to_edit=请先选择一个用户再修改
	public static final String USER_SELECT_USER_TO_EDIT = PropertiesUtil.getMessage("user.prompt.select_user_to_edit");
	// user.prompt.admin_user_cant_delete=管理员不能删除
	public static final String USER_ADMIN_USER_CANT_DELETE = PropertiesUtil
			.getMessage("user.prompt.admin_user_cant_delete");
	// user.prompt.choose_user_to_delete=请选择要删除的用户
	public static final String USER_CHOOSE_USER_TO_DELETE = PropertiesUtil
			.getMessage("user.prompt.choose_user_to_delete");
	// user.prompt.confirm_user_delete=确认删除选择的用户吗
	public static final String USER_CONFIRM_USER_DELETE = PropertiesUtil.getMessage("user.prompt.confirm_user_delete");
	// user.prompt.lock_user=锁定
	public static final String USER_LOCK_USER = PropertiesUtil.getMessage("user.prompt.lock_user");
	// user.prompt.unlock_user=解锁
	public static final String USER_UNLOCK_USER = PropertiesUtil.getMessage("user.prompt.unlock_user");
	// user.prompt.confirm_unlock_user=确认解锁此用户吗
	public static final String USER_CONFIRM_UNLOCK_USER = PropertiesUtil.getMessage("user.prompt.confirm_unlock_user");
	// user.prompt.confirm_lock_user=确认锁定此用户吗
	public static final String USER_CONFIRM_LOCK_USER = PropertiesUtil.getMessage("user.prompt.confirm_lock_user");
	// user.prompt.success=成功
	public static final String USER_SUCCESS = PropertiesUtil.getMessage("user.prompt.success");
	// user.prompt.user_not_exist=用户不存在
	public static final String USER_NOT_EXIST = PropertiesUtil.getMessage("user.prompt.user_not_exist");
	// user.prompt.account_exist=帐户已存在
	public static final String ACCOUNT_EXIST = PropertiesUtil.getMessage("user.prompt.account_exist");

	// menu.prompt.menu_under_menu=菜单只能建在菜单下
	public static final String MENU_MENU_UNDER_MENU = PropertiesUtil.getMessage("menu.prompt.menu_under_menu");
	// menu.prompt.allow_add_menu=此处只能创建菜单
	public static final String MENU_ALLOW_ADD_MENU = PropertiesUtil.getMessage("menu.prompt.allow_add_menu");
	// menu.prompt.element_must_under_page=元素只能建在页面下
	public static final String MENU_ELEMENT_MUST_UNDER_PAGE = PropertiesUtil
			.getMessage("menu.prompt.element_must_under_page");
	// menu.prompt.page_must_under_menu=页面只能建在菜单下
	public static final String MENU_PAGE_MUST_UNDER_MENU = PropertiesUtil
			.getMessage("menu.prompt.page_must_under_menu");
	// menu.prompt.current_node_cant_delete=不能在此节点下进行删除操作
	public static final String MENU_CURRENT_NODE_CANT_DELETE = PropertiesUtil
			.getMessage("menu.prompt.current_node_cant_delete");
	// menu.prompt.select_node_to_delete=请选择要删除的节点
	public static final String MENU_SELECT_NODE_TO_DELETE = PropertiesUtil
			.getMessage("menu.prompt.select_node_to_delete");
	// menu.prompt.have_sub_nodes_cant_delete=此节点下还有节点，不能删除
	public static final String MENU_HAVE_SUB_NODES_CANT_DELETE = PropertiesUtil
			.getMessage("menu.prompt.have_sub_nodes_cant_delete");
	// menu.prompt.please_select_node=请选中节点
	public static final String MENU_PLEASE_SELECT_NODE = PropertiesUtil.getMessage("menu.prompt.please_select_node");
	// menu.prompt.name_mandatory=名称不能为空
	public static final String MENU_NAME_MANDATORY = PropertiesUtil.getMessage("menu.prompt.name_mandatory");
	// menu.prompt.name_long=名称过长
	public static final String MENU_NAME_LONG = PropertiesUtil.getMessage("menu.prompt.name_long");
	// menu.prompt.img_long=图片路径过长
	public static final String MENU_IMG_LONG = PropertiesUtil.getMessage("menu.prompt.img_long");
	// menu.prompt.url_long=请求对象长度过长
	public static final String MENU_URL_LONG = PropertiesUtil.getMessage("menu.prompt.url_long");
	// menu.prompt.location_mandatory=目标区域不能为空
	public static final String MENU_LOCATION_MANDATORY = PropertiesUtil.getMessage("menu.prompt.location_mandatory");
	// menu.prompt.location_long=目标区域过长
	public static final String MENU_LOCATION_LONG = PropertiesUtil.getMessage("menu.prompt.location_long");
	// menu.prompt.please_select_element=请选中元素
	public static final String MENU_PLEASE_SELECT_ELEMENT = PropertiesUtil
			.getMessage("menu.prompt.please_select_element");
	// menu.prompt.element_id_mandatory=元素ID不能为空
	public static final String MENU_ELEMENT_ID_MANDATORY = PropertiesUtil
			.getMessage("menu.prompt.element_id_mandatory");
	// menu.prompt.element_id_long=元素ID过长
	public static final String MENU_ELEMENT_ID_LONG = PropertiesUtil.getMessage("menu.prompt.element_id_long");
	// menu.prompt.element_name_mandatory=元素名称不能为空
	public static final String MENU_ELEMENT_NAME_MANDATORY = PropertiesUtil
			.getMessage("menu.prompt.element_name_mandatory");
	// menu.prompt.element_name_long=元素名称过长
	public static final String MENU_ELEMENT_NAME_LONG = PropertiesUtil.getMessage("menu.prompt.element_name_long");
	// menu.prompt.desc_long=描述过长
	public static final String MENU_DESC_LONG = PropertiesUtil.getMessage("menu.prompt.desc_long");
	// menu.prompt.page_id_mandatory=页面ID不能为空
	public static final String MENU_PAGE_ID_MANDATORY = PropertiesUtil.getMessage("menu.prompt.page_id_mandatory");
	// menu.prompt.page_id_long=页面ID过长
	public static final String MENU_PAGE_ID_LONG = PropertiesUtil.getMessage("menu.prompt.page_id_long");
	// menu.prompt.one_node_cant_move=只有一个节点，无法移动
	public static final String MENU_ONE_NODE_CANT_MOVE = PropertiesUtil.getMessage("menu.prompt.one_node_cant_move");
	// menu.prompt.first_node_cant_moveup=第一个节点无法上移
	public static final String MENU_FIRST_NODE_CANT_MOVEUP = PropertiesUtil
			.getMessage("menu.prompt.first_node_cant_moveup");
	// menu.prompt.last_node_cant_movedown=最后一个节点无法下移
	public static final String MENU_LAST_NODE_CANT_MOVEDOWN = PropertiesUtil
			.getMessage("menu.prompt.last_node_cant_movedown");
	// bg.prompt.plz_select_role_or_stat=请选择角色或岗位
	public static final String BG_PLZ_SELECT_ROLE_OR_STAT = PropertiesUtil
			.getMessage("bg.prompt.plz_select_role_or_stat");
	// bg.prompt.data_no_change=数据没有改变
	public static final String BG_DATA_NO_CHANGE = PropertiesUtil.getMessage("bg.prompt.data_no_change");
	// delegate.title.privilege_detail=权限委托详细信息
	public static final String DELEGATE_PRIVILEGE_DETAIL = PropertiesUtil.getMessage("delegate.title.privilege_detail");
	// delegate.prompt.trustor_mandatory=委托名称必填
	public static final String DELEGATE_TRUSTOR_MANDATORY = PropertiesUtil
			.getMessage("delegate.prompt.trustor_mandatory");
	// delegate.prompt.dele_name_long=委托名称输入过长
	public static final String DELEGATE_DELE_NAME_LONG = PropertiesUtil.getMessage("delegate.prompt.dele_name_long");
	// delegate.prompt.plz_select_trustee=请选择被委托人
	public static final String DELEGATE_PLZ_SELECT_TRUSTEE = PropertiesUtil
			.getMessage("delegate.prompt.plz_select_trustee");
	// delegate.prompt.trustee_long=被委托人长度过长
	public static final String DELEGATE_TRUSTEE_LONG = PropertiesUtil.getMessage("delegate.prompt.trustee_long");
	// delegate.prompt.trustor_trustee_cant_same=委托人和被委托人不能是同一个用户
	public static final String DELEGATE_TRUSTOR_TRUSTEE_CANT_SAME = PropertiesUtil
			.getMessage("delegate.prompt.trustor_trustee_cant_same");
	// delegate.prompt.end_time_less_then_start_time=结束时间不能早于开始时间
	public static final String DELEGATE_END_TIME_LESS_THEN_START_TIME = PropertiesUtil
			.getMessage("delegate.prompt.end_time_less_then_start_time");
	// delegate.prompt.plz_fill_end_time=请填写结束时间
	public static final String DELEGATE_PLZ_FILL_END_TIME = PropertiesUtil
			.getMessage("delegate.prompt.plz_fill_end_time");
	// delegate.prompt.save_record_was_found=有相同记录存在，无法保存
	public static final String DELEGATE_SAVE_RECORD_WAS_FOUND = PropertiesUtil
			.getMessage("delegate.prompt.save_record_was_found");
	// delegate.prompt.select_dele_to_edit=请先选择一个委托项再修改
	public static final String DELEGATE_SELECT_DELE_TO_EDIT = PropertiesUtil
			.getMessage("delegate.prompt.select_dele_to_edit");
	// delegate.prompt.select_dele_to_delete=请选择要删除的权限委托
	public static final String DELEGATE_SELECT_DELE_TO_DELETE = PropertiesUtil
			.getMessage("delegate.prompt.select_dele_to_delete");
	// delegate.prompt.confirm_user_delete=确认删除选择的用户吗？
	public static final String DELEGATE_CONFIRM_USER_DELETE = PropertiesUtil
			.getMessage("delegate.prompt.confirm_user_delete");
	// delegate.prompt.confirm_delegate_delete=确认删除选择的委托吗？
	public static final String DELEGATE_CONFIRM_DELEGATE_DELETE = PropertiesUtil
			.getMessage("delegate.prompt.confirm_delegate_delete");
	// delegate.element.dele_name=委托名称
	public static final String DELEGATE_DELE_NAME = PropertiesUtil.getMessage("delegate.element.dele_name");
	// delegate.element.truster=委托人
	public static final String DELEGATE_TRUSTER = PropertiesUtil.getMessage("delegate.element.truster");
	// delegate.element.trustee=被委托人
	public static final String DELEGATE_TRUSTEE = PropertiesUtil.getMessage("delegate.element.trustee");
	// delegate.element.all_privilege=全部权限
	public static final String DELEGATE_ALL_PRIVILEGE = PropertiesUtil.getMessage("delegate.element.all_privilege");
	// delegate.element.time_start=生效时间
	public static final String DELEGATE_TIME_START = PropertiesUtil.getMessage("delegate.element.time_start");
	// delegate.element.time_end=失效时间
	public static final String DELEGATE_TIME_END = PropertiesUtil.getMessage("delegate.element.time_end");
	// delegate.element.desc=描述信息
	public static final String DELEGATE_DESC = PropertiesUtil.getMessage("delegate.element.desc");
	// delegate.element.plz_select=请选择
	public static final String DELEGATE_PLZ_SELECT = PropertiesUtil.getMessage("delegate.element.plz_select");
	// delegate.prompt.desc_long=输入长度过长
	public static final String DELEGATE_DESC_LONG = PropertiesUtil.getMessage("delegate.prompt.desc_long");
	// cant_edit_others_delegate=不能修改其它人的权限委托
	public static final String CANT_EDIT_OTHERS_DELEGATE = PropertiesUtil
			.getMessage("delegate.prompt.cant_edit_others_delegate");
	// delegate.prompt.plz_select_privilege=请选择权限
	public static final String PLZ_SELECT_PRIVILEGE = PropertiesUtil.getMessage("delegate.prompt.plz_select_privilege");
	// delegate.prompt.cant_del_others_delegate=不能删除其它人的权限委托
	public static final String CANT_DEL_OTHERS_DELEGATE = PropertiesUtil
			.getMessage("delegate.prompt.cant_del_others_delegate");
	// delegate.prompt.delegate_not_exist=请求的委托项不存在
	public static final String DELEGATE_NOT_EXIST = PropertiesUtil.getMessage("delegate.prompt.delegate_not_exist");

	// unit.prompt.please_select_node=请选择节点
	public static final String UNIT_SELECT_NODE_FIRST = PropertiesUtil.getMessage("org.prompt.select_node_first");
	// unit.prompt.no_delete=您没有操作的权限
	public static final String UNIT_NO_PRIVILEGES = PropertiesUtil.getMessage("org.prompt.no_privileges");
	// unit.prompt.please_select_delete_node=请选择需要删除的节点
	public static final String UNIT_SELECT_NODE_TO_DELETE = PropertiesUtil
			.getMessage("org.prompt.select_node_to_delete");
	// unit.prompt.node_cant_delete=该节点不能删除
	public static final String UNIT_NODE_CANT_DELETE = PropertiesUtil.getMessage("org.prompt.node_cant_delete");
	// org.element.useraccount=用户帐号
	public static final String UNIT_USERACCOUNT = PropertiesUtil.getMessage("org.element.useraccount");
	// org.element.username=用户姓名
	public static final String UNIT_USERNAME = PropertiesUtil.getMessage("org.element.username");
	// org.prompt.text_too_long=输入内容长度过长
	public static final String UNIT_TEXT_TOO_LONG = PropertiesUtil.getMessage("org.prompt.text_too_long");
	// org.prompt.select_data=输入内容长度过长
	public static final String UNIT_SELECT_DATA = PropertiesUtil.getMessage("org.prompt.select_data");
	// org.prompt.fill_orgunitname=请填写组织单元名称
	public static final String UNIT_FILL_ORGUNITNAME = PropertiesUtil.getMessage("org.prompt.fill_orgunitname");
	// org.element.leader_station=上级领导岗位
	public static final String UNIT_LEADER_STATION = PropertiesUtil.getMessage("org.element.leader_station");
	// org.element.unit=组织单元
	public static final String UNIT_NAME = PropertiesUtil.getMessage("org.element.unit");
	// common.message.invalid_char=含有非法字符，操作失败！
	public static final String INVALID_CHAR = PropertiesUtil.getMessage("common.message.invalid_char");
	// 删除菜单项目的提示
	public static final String ITEM_DELETE_CONFIRM = PropertiesUtil.getMessage("common.message.confirm_delete");

	/**
	 * 构造函数
	 */
	private OrgI18nConsts() {
	}
}
