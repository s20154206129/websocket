package org.xdemo.example.websocket.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.UserRelation;
public interface UserRelationDao {
	
	public UserRelation getUserRelation(@Param("idA")int idA, @Param("idB")int idB);
	
	public void addUserRelation(UserRelation userRelation);

	public boolean deleteUserRelation(@Param("idA")int idA, @Param("idB")int idB);

	public boolean updateUser(UserRelation userRelation);

	@SuppressWarnings("rawtypes")
	public List getAllFriends(@Param("id")int id);
}
