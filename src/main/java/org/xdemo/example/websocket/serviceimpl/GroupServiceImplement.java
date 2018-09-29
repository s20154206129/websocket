package org.xdemo.example.websocket.serviceimpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xdemo.example.websocket.dao.GroupDao;
import org.xdemo.example.websocket.entity.Group;
import org.xdemo.example.websocket.service.GroupService;


@Service("groupService")
public class GroupServiceImplement implements  GroupService {
	
	@Autowired 
	private GroupDao groupDao;
    
	@Override
	public Group getGroup(int id) {
		return groupDao.getGroupById(id);
	}

	@Override
	public Group getGroup(String groupId) {
		return groupDao.getGroupByGroupId(groupId);
	}

	@Override
	public void addGroup(Group group) {
		groupDao.addGroup(group);
	}

	@Override
	public int  deleteGroup(int id) {
		return groupDao.deleteGroup(id);
	}

	@Override
	public int  updateGroup(Group group) {
		return groupDao.updateGroup(group);
	}

}
