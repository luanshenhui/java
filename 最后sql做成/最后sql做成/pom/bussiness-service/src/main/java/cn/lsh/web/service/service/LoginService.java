package cn.lsh.web.service.service;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import login.model.DrewVo;
import login.model.FoltVoDraw;
import login.model.GroupUserVo;
import login.model.RoleVo;
import cn.lsh.web.mapper.login.domain.AreaDomain;
import cn.lsh.web.mapper.login.domain.ColorUserVo;
import cn.lsh.web.mapper.login.domain.FoltDomain;
import cn.lsh.web.mapper.login.domain.GroupDomain;
import cn.lsh.web.mapper.login.domain.ImgDomain;
import cn.lsh.web.mapper.login.domain.LshTable;
import cn.lsh.web.mapper.login.domain.ManagerDomain;
import cn.lsh.web.mapper.login.domain.PersonDomain;
import cn.lsh.web.mapper.login.domain.Role;
import cn.lsh.web.mapper.login.domain.RolePersonDomain;

import com.github.pagehelper.PageInfo;


/**
 * 
 * @author fanzy
 *
 */
public interface LoginService {
	public PageInfo<ColorUserVo> findByWhere(int page, int length,
			ColorUserVo param) throws Exception;

	public PageInfo<GroupUserVo> groupListView(int page, int length,
			GroupDomain param);

	public List<GroupUserVo> getGroupUserVoList(GroupDomain g);

	public List<DrewVo> getStreetDrew(GroupDomain group, HttpServletRequest request);

	public List<AreaDomain> getProvinceList(AreaDomain areaDomain);

	public String getSysTime(String string);

	public List<ColorUserVo> getUserVoList(ColorUserVo user);

	public List<String> printWeeks(HttpServletRequest request) throws ParseException;

	public List<FoltVoDraw> getOracleDrew(FoltDomain folt, List<String> listday)throws Exception;

	public ManagerDomain getLoginManager(ManagerDomain m);

	public void insertFolt(FoltDomain folt) throws Exception;

	public List<Role> getRolelist(Role role) throws Exception;

	public void updateImgName(ImgDomain img);

	public List<ImgDomain> getImgInfo();

	public void insertRegister(ManagerDomain d);

	public Map<String, Object> updateUser(HttpServletRequest request);

	public Map<String, Object> updatePassword(HttpServletRequest request);

	public PageInfo<Role> findRoleList(int page, int length, Role param);

	public Role getRole(Role role);

	public void updateRole(String colorName, String colorType,
			String roleType);

	public List<RoleVo> getRolelistVo(Role role);

	public void insertRoleVo(HttpServletRequest request) throws Exception;

	public List<RolePersonDomain> getAllList(RolePersonDomain rolePersonDomain);

	public void createPerson(PersonDomain person, String groupId) throws Exception;

	public List<GroupDomain> selectWatchNum(GroupDomain group);

	public PersonDomain getClientPerson(PersonDomain personDomain);

	public List<String> getGroupPerson(FoltDomain folt);

	public String getMsg(FoltDomain folt);

	public PersonDomain selectPerson(PersonDomain person);

	public List<AreaDomain> getCallList(AreaDomain a);

	public void insertGroup2(RolePersonDomain g);

	public List<LshTable> getLshTableList(LshTable lshTable);

	public List<AreaDomain> getProvinceList2(AreaDomain areaDomain);





}
