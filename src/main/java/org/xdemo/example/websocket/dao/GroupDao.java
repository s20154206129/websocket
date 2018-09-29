package org.xdemo.example.websocket.dao;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.Group;

public interface GroupDao {
	
	public Group getGroupById(@Param("id")int id);

	public Group getGroupByGroupId(@Param("groupId")String groupId);

	public void addGroup(Group group);

	public int  deleteGroup(@Param("id")int id);

	public int updateGroup(Group group);
}