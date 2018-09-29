package org.xdemo.example.websocket.service;

import org.xdemo.example.websocket.entity.Group;

public interface GroupService {
	public Group getGroup(int id);
	public Group getGroup(String groupId);
	public void addGroup(Group group);
	public int  deleteGroup(int id);
	public int  updateGroup(Group group);
}
