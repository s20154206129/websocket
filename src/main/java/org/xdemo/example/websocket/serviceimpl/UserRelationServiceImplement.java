package org.xdemo.example.websocket.serviceimpl;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xdemo.example.websocket.dao.UserDao;
import org.xdemo.example.websocket.dao.UserRelationDao;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.entity.UserRelation;
import org.xdemo.example.websocket.service.UserRelationService;

@Service("userRelationService")
public class UserRelationServiceImplement implements UserRelationService {

	@Autowired 
	private UserRelationDao userRelationDao;
	@Autowired 
	private UserDao userDao;
	
	@Override
	public UserRelation getUserRelation(int idA, int idB) {
		return userRelationDao.getUserRelation(idA, idB);
	}

	@Override
	public void addUserRelation(UserRelation userRelation) {
		userRelationDao.addUserRelation(userRelation);
	}

	@Override
	public boolean deleteUserRelation(int idA, int idB) {
		return userRelationDao.deleteUserRelation(idA, idB);
	}

	@Override
	public boolean updateUser(UserRelation userRelation) {
		return userRelationDao.updateUser(userRelation);
	}

	/**
	 * 获得所有好友
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getAllFriends(int id) {
		//获得好友的  user_id_b字段
		List list = userRelationDao.getAllFriends(id);
	
		ArrayList<User> lists = new ArrayList<User>();
		for(int i=0;i<list.size();i++){
			User user = userDao.getUserById((Integer) list.get(i));
			lists.add(user);
		}
		return lists;
	}

}
