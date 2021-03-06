package com.zy.service;

import com.zy.common.model.query.Page;
import com.zy.entity.adm.Admin;
import com.zy.entity.adm.AdminRole;
import com.zy.model.query.AdminQueryModel;

import java.util.List;
import java.util.Set;

public interface AdminService {

	void create(Admin admin, Long[] roleIds);
	
	void update(Admin admin, Long[] roleIds);
	
	void delete(Long id);
	
	Admin findOne(Long id);

	Page<Admin> findPage(AdminQueryModel adminQueryModel);
	
	Set<String> findPermissions(Long id);
	
	List<AdminRole> findAdminRoles(Long id);

	Admin findByUserId(Long id);
	
}
