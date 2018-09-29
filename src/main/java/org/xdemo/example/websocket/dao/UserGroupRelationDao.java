package org.xdemo.example.websocket.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.UserGroupRelation;

public interface UserGroupRelationDao {
	//根据用户id和群id确定一条唯一的群记录
	public UserGroupRelation getUserGroupRelation(@Param("userId")int userId, @Param("groupId")int groupId);
	//添加一条记录
	public void addUserGroupRelation(UserGroupRelation userGroupRelation);
	//删除一条记录
	public int  deleteUserGroupRelation(@Param("userId")int userId, @Param("groupId")int groupId);
	//更新一条记录
	public int  updateUserGroupRelation(UserGroupRelation userGroupRelation);
	//获取一个群的所有用户的id
	public List<UserGroupRelation> getAllUser(@Param("groupId")int groupId);
	//获取一个用户的所有群的记录
	public List<UserGroupRelation> getAllGroup(@Param("userId")int userId);
}
