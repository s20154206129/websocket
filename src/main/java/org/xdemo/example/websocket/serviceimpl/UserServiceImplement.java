package org.xdemo.example.websocket.serviceimpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xdemo.example.websocket.dao.UserDao;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.service.UserService;


@Service("userService")
public class UserServiceImplement implements UserService {
	
	@Autowired 
	private UserDao userDao;
	
	@Override
	public User getUser(int id) {
		return userDao.getUserById(id);
	}
	
	@Override
	public User getUser(String name) {
		return userDao.getUserByName(name);
	}
	

	@Override
	public void addUser(User user) {
		userDao.addUser(user);
	}

	@Override
	public int  deleteUser(int id) {
		return userDao.deleteUser(id);

	}

	@Override
	public int  updateUser(User user) {
		return userDao.updateUser(user);

	}

	@Override
	public List<User> getAllUser() {
		return userDao.getAllUser();
	}

}
