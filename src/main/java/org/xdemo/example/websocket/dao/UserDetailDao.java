package org.xdemo.example.websocket.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.UserDetail;


public interface UserDetailDao {
	
	public UserDetail getUserDetailById(@Param("id")int id);
	
	public UserDetail getUserDetailByName(@Param("name")String name);

	public void addUserDetail(UserDetail userDetail);

	public boolean deleteUserDetail(@Param("id")int id);

	public boolean updateUserDetail(UserDetail userDetail);

	public List<UserDetail> getAllUserDetail();
}
