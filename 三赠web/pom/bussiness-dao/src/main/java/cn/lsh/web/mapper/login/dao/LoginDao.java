package cn.lsh.web.mapper.login.dao;

import java.util.List;

import login.model.FoltVo;
import login.model.GroupUserVo;
import cn.lsh.web.mapper.login.domain.AreaDomain;
import cn.lsh.web.mapper.login.domain.ColorUserVo;
import cn.lsh.web.mapper.login.domain.FoltDomain;
import cn.lsh.web.mapper.login.domain.GroupDomain;
import cn.lsh.web.mapper.login.domain.ImgDomain;
import cn.lsh.web.mapper.login.domain.ManagerDomain;
import cn.lsh.web.mapper.login.domain.PersonDomain;
import cn.lsh.web.mapper.login.domain.Role;
import cn.lsh.web.mapper.login.domain.RolePersonDomain;

import com.github.pagehelper.PageInfo;


public interface LoginDao {

	PageInfo<ColorUserVo> findByWhere(int page, int length, ColorUserVo param) throws Exception;

	PageInfo<GroupUserVo> groupListView(int page, int length, GroupDomain param);

	List<GroupUserVo> getGroupUserVoList(GroupDomain g);

	List<FoltVo> getStreetDrew(GroupDomain group);

	List<Role> getRoleList(Role role);

	List<AreaDomain> getProvinceList(AreaDomain areaDomain);

	List<ColorUserVo> getUserVoList(ColorUserVo user);

	List<FoltVo> getOracleDrew(FoltDomain folt);

	Integer getOracleDrew(FoltVo v);

	ManagerDomain getLoginManager(ManagerDomain m);

	void createPerson(PersonDomain person);

	void createGroup(GroupDomain g);

	void insertFolt(FoltDomain folt);

	void updateImgName(ImgDomain img);

	List<ImgDomain> getImgInfo(ImgDomain imgDomain);

	void insertRegister(ManagerDomain d);

	void updateUser(ManagerDomain d);

	PageInfo<Role> findRoleList(int page, int length, Role param);

	Role getRole(Role role);

	void updateRole(Role role);

	List<RolePersonDomain> getAllList(RolePersonDomain rolePersonDomain);

	void insertRoleVo(Role r);

	List<GroupDomain> selectWatchNum(GroupDomain group);

	PersonDomain getClientPerson(PersonDomain personDomain);

	AreaDomain getProvinceCode(PersonDomain person);

	List<String> getGroupPerson(FoltDomain folt);

	List<ImgDomain> getMsg(FoltDomain folt);

	PersonDomain selectPerson(PersonDomain person);

}
